/// Pure business object. No JSON, no Flutter, no knowledge of Open Library.
class Book {
  final String id; // Open Library work key, e.g. "/works/OL45804W"
  final String title;
  final List<String> authors;
  final String? coverUrl;
  final int? firstPublishYear;
  final int? pageCount;
  final double? rating;
  final List<String> subjects;
  final String link;

  const Book({
    required this.id,
    required this.title,
    required this.authors,
    required this.link,
    this.coverUrl,
    this.firstPublishYear,
    this.pageCount,
    this.rating,
    this.subjects = const [],
  });

  String get authorText => authors.isEmpty ? 'Unknown author' : authors.join(', ');
}
