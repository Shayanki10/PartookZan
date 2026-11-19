import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../../../injection.dart';
import '../../domain/entities/book.dart';
import '../../domain/usecases/book_usecases.dart';
import '../providers/book_details_provider.dart';
import '../providers/books_provider.dart';
import '../screens/details_screen.dart';

/// Records the book as "recently viewed" and opens the details screen.
/// [section] keeps the Hero tag unique for the list the card came from.
void openBookDetails(BuildContext context, Book book, String section) {
  context.read<BooksProvider>().addRecent(book);
  Navigator.of(context).push(PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 500),
    reverseTransitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) => ChangeNotifierProvider(
      create: (_) => BookDetailsProvider(sl<GetBookDescription>(), book)..load(),
      child: DetailsScreen(book: book, section: section),
    ),
    transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: child),
  ));
}
