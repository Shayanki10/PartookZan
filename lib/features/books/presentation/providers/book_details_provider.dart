import 'package:flutter/foundation.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/book.dart';
import '../../domain/usecases/book_usecases.dart';

/// Loads the long description for one book (created per details screen).
class BookDetailsProvider extends ChangeNotifier {
  final GetBookDescription _getDescription;
  final Book book;

  bool loading = true;
  bool failed = false;
  String? description;

  BookDetailsProvider(this._getDescription, this.book);

  Future<void> load() async {
    loading = true;
    failed = false;
    notifyListeners();
    try {
      description = await _getDescription(book.id);
    } on Failure {
      failed = true;
    }
    loading = false;
    notifyListeners();
  }
}
