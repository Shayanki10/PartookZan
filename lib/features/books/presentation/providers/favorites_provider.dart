import 'package:flutter/foundation.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/book.dart';
import '../../domain/usecases/book_usecases.dart';

class FavoritesProvider extends ChangeNotifier {
  final GetFavoriteBooks _get;
  final ToggleFavoriteBook _toggle;

  List<Book> favorites = [];

  FavoritesProvider(this._get, this._toggle) {
    _load();
  }

  bool isFavorite(String id) => favorites.any((b) => b.id == id);

  Future<void> toggle(Book book) async {
    favorites = await _toggle(book);
    notifyListeners();
  }

  Future<void> _load() async {
    favorites = await _get(const NoParams());
    notifyListeners();
  }
}
