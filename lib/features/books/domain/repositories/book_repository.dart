import '../entities/book.dart';

/// The contract the domain needs. The data layer provides the implementation.
abstract class BookRepository {
  /// [category] == null or 'All' with an empty [query] returns trending books.
  Future<List<Book>> getBooks({String? category, String query = ''});

  Future<List<Book>> getTopRatedBooks({String? category});

  Future<String?> getDescription(String bookId);

  Future<List<Book>> getRecentBooks();

  /// Adds to the front (no duplicates, capped) and returns the new list.
  Future<List<Book>> addRecentBook(Book book);

  Future<void> clearRecentBooks();

  Future<List<Book>> getFavoriteBooks();

  /// Adds the book if it is not a favorite yet, otherwise removes it.
  /// Returns the new favorites list.
  Future<List<Book>> toggleFavoriteBook(Book book);
}
