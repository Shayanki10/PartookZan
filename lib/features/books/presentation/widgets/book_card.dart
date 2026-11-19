import 'package:material_ui/material_ui.dart';

import '../../domain/entities/book.dart';

String coverHeroTag(String section, Book b) => 'cover-$section-${b.id}';

class BookCard extends StatelessWidget {
  final Book book;
  final String section; // keeps Hero tags unique between lists
  final VoidCallback onTap;
  final double? width; // null = fill the available width (grid)

  const BookCard({
    super.key,
    required this.book,
    required this.section,
    required this.onTap,
    this.width = 140,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Hero(
                tag: coverHeroTag(section, book),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: BookCover(url: book.coverUrl, radius: 12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              book.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            Text(
              book.authorText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 11, color: cs.onSurface.withValues(alpha: 0.55)),
            ),
          ],
        ),
      ),
    );
  }
}

class BookCover extends StatelessWidget {
  final String? url;
  final double radius;
  const BookCover({super.key, required this.url, this.radius = 12});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final placeholder = Container(
      color: cs.primary.withValues(alpha: 0.2),
      alignment: Alignment.center,
      child: Icon(Icons.menu_book_rounded,
          color: cs.onSurface.withValues(alpha: 0.5), size: 36),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox.expand(
        child: url == null
            ? placeholder
            : Image.network(
                url!,
                fit: BoxFit.cover,
                loadingBuilder: (_, child, p) =>
                    p == null ? child : placeholder,
                errorBuilder: (_, __, ___) => placeholder,
              ),
      ),
    );
  }
}

/// Grey placeholder shown while books are loading.
class BookCardSkeleton extends StatelessWidget {
  const BookCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
