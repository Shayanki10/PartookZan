import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/book_model.dart';

/// Stores the "recently viewed" list on the device.
class BookLocalDataSource {
  static const _key = 'recent_books';
  final SharedPreferences _prefs;
  BookLocalDataSource(this._prefs);

  List<BookModel> getRecent() => (_prefs.getStringList(_key) ?? [])
      .map((s) => BookModel.fromJson(jsonDecode(s) as Map<String, dynamic>))
      .toList();

  Future<void> saveRecent(List<BookModel> books) => _prefs.setStringList(
        _key,
        books.map((b) => jsonEncode(b.toJson())).toList(),
      );

  Future<void> clear() => _prefs.remove(_key);

  static const _favKey = 'favorite_books';

  List<BookModel> getFavorites() => (_prefs.getStringList(_favKey) ?? [])
      .map((s) => BookModel.fromJson(jsonDecode(s) as Map<String, dynamic>))
      .toList();

  Future<void> saveFavorites(List<BookModel> books) => _prefs.setStringList(
        _favKey,
        books.map((b) => jsonEncode(b.toJson())).toList(),
      );
}
