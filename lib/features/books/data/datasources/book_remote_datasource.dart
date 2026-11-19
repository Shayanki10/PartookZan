import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/error/failures.dart';
import '../models/book_model.dart';

/// Talks to the Open Library API (https://openlibrary.org/developers/api). No key needed.
class BookRemoteDataSource {
  static const _host = 'openlibrary.org';
  static const _headers = {'User-Agent': 'PartookZan/1.0'};
  static const _timeout = Duration(seconds: 12);

  final http.Client _client;
  BookRemoteDataSource(this._client);

  Future<List<BookModel>> getBooks({String? category, String query = ''}) async {
    final q = query.trim();
    final hasCategory = category != null && category != 'All';

    final Uri uri;
    if (q.isEmpty && !hasCategory) {
      // Home page default: what people are reading right now.
      uri = Uri.https(_host, '/trending/weekly.json', {'limit': '20'});
    } else {
      final parts = <String>[
        if (q.isNotEmpty) q,
        if (hasCategory) 'subject:"${category.toLowerCase()}"',
      ];
      uri = Uri.https(_host, '/search.json', {
        'q': parts.join(' '),
        'limit': '20',
        'fields': 'key,title,author_name,cover_i,first_publish_year,'
            'number_of_pages_median,ratings_average,subject',
      });
    }

    final json = await _getJson(uri);
    // search.json -> "docs", trending -> "works"
    final list = (json['docs'] ?? json['works'] ?? const []) as List;
    return list
        .map((e) => BookModel.fromOpenLibrary(e as Map<String, dynamic>))
        .where((b) => b.coverUrl != null) // keep the UI looking good
        .toList();
  }

  /// Highest rated books (only books with enough ratings), optionally in a category.
  Future<List<BookModel>> getTopRated({String? category}) async {
    final hasCategory = category != null && category != 'All';
    final q = [
      'ratings_count:[20 TO *]',
      if (hasCategory) 'subject:"${category.toLowerCase()}"',
    ].join(' ');

    final json = await _getJson(Uri.https(_host, '/search.json', {
      'q': q,
      'sort': 'rating',
      'limit': '20',
      'fields': 'key,title,author_name,cover_i,first_publish_year,'
          'number_of_pages_median,ratings_average,subject',
    }));
    return ((json['docs'] ?? const []) as List)
        .map((e) => BookModel.fromOpenLibrary(e as Map<String, dynamic>))
        .where((b) => b.coverUrl != null && b.rating != null)
        .toList();
  }

  /// Descriptions are not part of search results; they live on the work page.
  Future<String?> getDescription(String workKey) async {
    final json = await _getJson(Uri.https(_host, '$workKey.json'));
    final d = json['description'];
    if (d is String) return d;
    if (d is Map && d['value'] is String) return d['value'] as String;
    return null;
  }

  Future<Map<String, dynamic>> _getJson(Uri uri) async {
    final res = await _client.get(uri, headers: _headers).timeout(_timeout);
    if (res.statusCode != 200) {
      throw ServerFailure('Library responded with ${res.statusCode}');
    }
    return jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
  }
}
