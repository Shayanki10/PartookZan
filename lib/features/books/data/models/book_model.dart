import '../../domain/entities/book.dart';

/// Entity + JSON handling. Lives in the data layer only.
class BookModel extends Book {
  const BookModel({
    required super.id,
    required super.title,
    required super.authors,
    required super.link,
    super.coverUrl,
    super.firstPublishYear,
    super.pageCount,
    super.rating,
    super.subjects,
  });

  /// One doc from `search.json` or one work from `trending/*.json`.
  factory BookModel.fromOpenLibrary(Map<String, dynamic> j) {
    final key = j['key'] as String; // "/works/OL...W"
    final coverId = j['cover_i'];
    return BookModel(
      id: key,
      title: (j['title'] ?? 'Untitled') as String,
      authors: List<String>.from(j['author_name'] ?? const []),
      link: 'https://openlibrary.org$key',
      coverUrl:
          coverId == null ? null : 'https://covers.openlibrary.org/b/id/$coverId-L.jpg',
      firstPublishYear: (j['first_publish_year'] as num?)?.toInt(),
      pageCount: (j['number_of_pages_median'] as num?)?.toInt(),
      rating: (j['ratings_average'] as num?)?.toDouble(),
      subjects: _cleanSubjects(List<String>.from(j['subject'] ?? const [])),
    );
  }

  factory BookModel.fromEntity(Book b) => BookModel(
        id: b.id,
        title: b.title,
        authors: b.authors,
        link: b.link,
        coverUrl: b.coverUrl,
        firstPublishYear: b.firstPublishYear,
        pageCount: b.pageCount,
        rating: b.rating,
        subjects: b.subjects,
      );

  factory BookModel.fromJson(Map<String, dynamic> j) => BookModel(
        id: j['id'] as String,
        title: j['title'] as String,
        authors: List<String>.from(j['authors'] ?? const []),
        link: j['link'] as String,
        coverUrl: j['coverUrl'] as String?,
        firstPublishYear: j['firstPublishYear'] as int?,
        pageCount: j['pageCount'] as int?,
        rating: (j['rating'] as num?)?.toDouble(),
        subjects: List<String>.from(j['subjects'] ?? const []),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'authors': authors,
        'link': link,
        'coverUrl': coverUrl,
        'firstPublishYear': firstPublishYear,
        'pageCount': pageCount,
        'rating': rating,
        'subjects': subjects,
      };

  /// Open Library returns dozens of noisy subjects; keep a few short ones.
  static List<String> _cleanSubjects(List<String> all) =>
      all.where((s) => s.length <= 20 && !s.contains(':')).take(3).toList();
}
