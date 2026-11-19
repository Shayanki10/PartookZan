import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/book.dart';
import '../../domain/usecases/book_usecases.dart';

enum LoadState { loading, success, error }

class BooksProvider extends ChangeNotifier {
  /// Special category: shows the books the user opened lately (no API call).
  static const recentCategory = 'Recently Viewed';

  static const categories = [
    'All',
    recentCategory,
    'Fiction',
    'Fantasy',
    'Romance',
    'Science',
    'History',
    'Business',
    'Technology',
  ];

  final GetBooks _getBooks;
  final GetTopRatedBooks _getTopRated;
  final GetRecentBooks _getRecent;
  final AddRecentBook _addRecent;
  final ClearRecentBooks _clearRecent;

  LoadState state = LoadState.loading;
  String errorMessage = '';
  String selectedCategory = 'All';
  String query = '';
  List<Book> books = [];
  List<Book> recent = [];

  LoadState topRatedState = LoadState.loading;
  List<Book> topRated = [];

  Timer? _debounce;
  int _requestId = 0; // ignores stale responses
  int _topRequestId = 0;

  BooksProvider(
    this._getBooks,
    this._getTopRated,
    this._getRecent,
    this._addRecent,
    this._clearRecent,
  ) {
    _loadRecent();
  }

  bool get isRecentSelected => selectedCategory == recentCategory;

  /// Loads the main row. [refreshTopRated] is false while typing in search.
  Future<void> load({bool refreshTopRated = true}) async {
    if (refreshTopRated) _loadTopRated();
    if (isRecentSelected) {
      notifyListeners();
      return;
    }
    final id = ++_requestId;
    state = LoadState.loading;
    notifyListeners();
    try {
      final result = await _getBooks(
        GetBooksParams(category: selectedCategory, query: query),
      );
      if (id != _requestId) return;
      books = result;
      state = LoadState.success;
    } on Failure catch (f) {
      if (id != _requestId) return;
      errorMessage = f.message;
      state = LoadState.error;
    }
    notifyListeners();
  }

  Future<void> _loadTopRated() async {
    final id = ++_topRequestId;
    topRatedState = LoadState.loading;
    notifyListeners();
    final category =
        (selectedCategory == 'All' || isRecentSelected) ? null : selectedCategory;
    try {
      final result = await _getTopRated(category);
      if (id != _topRequestId) return;
      topRated = result;
      topRatedState = LoadState.success;
    } on Failure {
      if (id != _topRequestId) return;
      topRatedState = LoadState.error;
    }
    notifyListeners();
  }

  void selectCategory(String c) {
    if (c == selectedCategory) return;
    selectedCategory = c;
    load();
  }

  void setQuery(String q) {
    query = q;
    // Searching always looks at the whole library, not just recent books.
    if (isRecentSelected && q.isNotEmpty) selectedCategory = 'All';
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 450), () => load(refreshTopRated: false));
  }

  Future<void> addRecent(Book b) async {
    recent = await _addRecent(b);
    notifyListeners();
  }

  Future<void> clearRecent() async {
    await _clearRecent(const NoParams());
    recent = [];
    notifyListeners();
  }

  Future<void> _loadRecent() async {
    recent = await _getRecent(const NoParams());
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
