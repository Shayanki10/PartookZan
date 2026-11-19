import '../../../../core/usecase/usecase.dart';
import '../entities/book.dart';
import '../repositories/book_repository.dart';

class GetBooksParams {
  final String? category;
  final String query;
  const GetBooksParams({this.category, this.query = ''});
}

class GetBooks extends UseCase<List<Book>, GetBooksParams> {
  final BookRepository _repo;
  GetBooks(this._repo);

  @override
  Future<List<Book>> call(GetBooksParams p) =>
      _repo.getBooks(category: p.category, query: p.query);
}

class GetTopRatedBooks extends UseCase<List<Book>, String?> {
  final BookRepository _repo;
  GetTopRatedBooks(this._repo);

  @override
  Future<List<Book>> call(String? category) => _repo.getTopRatedBooks(category: category);
}

class GetBookDescription extends UseCase<String?, String> {
  final BookRepository _repo;
  GetBookDescription(this._repo);

  @override
  Future<String?> call(String bookId) => _repo.getDescription(bookId);
}

class GetRecentBooks extends UseCase<List<Book>, NoParams> {
  final BookRepository _repo;
  GetRecentBooks(this._repo);

  @override
  Future<List<Book>> call(NoParams _) => _repo.getRecentBooks();
}

class AddRecentBook extends UseCase<List<Book>, Book> {
  final BookRepository _repo;
  AddRecentBook(this._repo);

  @override
  Future<List<Book>> call(Book book) => _repo.addRecentBook(book);
}

class GetFavoriteBooks extends UseCase<List<Book>, NoParams> {
  final BookRepository _repo;
  GetFavoriteBooks(this._repo);

  @override
  Future<List<Book>> call(NoParams _) => _repo.getFavoriteBooks();
}

class ToggleFavoriteBook extends UseCase<List<Book>, Book> {
  final BookRepository _repo;
  ToggleFavoriteBook(this._repo);

  @override
  Future<List<Book>> call(Book book) => _repo.toggleFavoriteBook(book);
}

class ClearRecentBooks extends UseCase<void, NoParams> {
  final BookRepository _repo;
  ClearRecentBooks(this._repo);

  @override
  Future<void> call(NoParams _) => _repo.clearRecentBooks();
}
