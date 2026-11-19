import '../../../../core/error/failures.dart';
import '../../domain/entities/book.dart';
import '../../domain/repositories/book_repository.dart';
import '../datasources/book_local_datasource.dart';
import '../datasources/book_remote_datasource.dart';
import '../models/book_model.dart';

class BookRepositoryImpl implements BookRepository {
  static const _maxRecent = 10;

  final BookRemoteDataSource _remote;
  final BookLocalDataSource _local;
  BookRepositoryImpl(this._remote, this._local);

  @override
  Future<List<Book>> getBooks({String? category, String query = ''}) =>
      _guard(() => _remote.getBooks(category: category, query: query));

  @override
  Future<List<Book>> getTopRatedBooks({String? category}) =>
      _guard(() => _remote.getTopRated(category: category));

  @override
  Future<String?> getDescription(String bookId) =>
      _guard(() => _remote.getDescription(bookId));

  @override
  Future<List<Book>> getRecentBooks() async => _local.getRecent();

  @override
  Future<List<Book>> addRecentBook(Book book) async {
    final list = _local.getRecent()..removeWhere((b) => b.id == book.id);
    list.insert(0, BookModel.fromEntity(book));
    final capped = list.take(_maxRecent).toList();
    await _local.saveRecent(capped);
    return capped;
  }

  @override
  Future<void> clearRecentBooks() => _local.clear();

  @override
  Future<List<Book>> getFavoriteBooks() async => _local.getFavorites();

  @override
  Future<List<Book>> toggleFavoriteBook(Book book) async {
    final list = _local.getFavorites();
    final exists = list.any((b) => b.id == book.id);
    if (exists) {
      list.removeWhere((b) => b.id == book.id);
    } else {
      list.insert(0, BookModel.fromEntity(book));
    }
    await _local.saveFavorites(list);
    return list;
  }

  /// Converts any low-level exception (timeout, no internet, bad JSON)
  /// into a [Failure] so the UI never sees raw exceptions.
  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on Failure {
      rethrow;
    } on FormatException {
      throw const ServerFailure();
    } catch (_) {
      throw const NetworkFailure();
    }
  }
}
