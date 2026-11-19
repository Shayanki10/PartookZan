import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../navigation/open_book.dart';
import '../providers/favorites_provider.dart';
import '../widgets/book_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favs = context.watch<FavoritesProvider>().favorites;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites',
            style: TextStyle(fontWeight: FontWeight.w700)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: favs.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite_border_rounded,
                      size: 56, color: cs.onSurface.withValues(alpha: 0.3)),
                  const SizedBox(height: 12),
                  Text('No favorites yet',
                      style: TextStyle(color: cs.onSurface.withValues(alpha: 0.6))),
                  const SizedBox(height: 4),
                  Text('Tap the heart on a book to save it here.',
                      style: TextStyle(
                          fontSize: 12, color: cs.onSurface.withValues(alpha: 0.45))),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 0.58,
              ),
              itemCount: favs.length,
              itemBuilder: (_, i) => BookCard(
                book: favs[i],
                section: 'fav',
                width: null,
                onTap: () => openBookDetails(context, favs[i], 'fav'),
              ),
            ),
    );
  }
}
