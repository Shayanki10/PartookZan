import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/circle_icon_button.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../domain/entities/book.dart';
import '../providers/book_details_provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/book_card.dart';

class DetailsScreen extends StatelessWidget {
  final Book book;
  final String section; // must match the card's Hero tag
  const DetailsScreen({super.key, required this.book, required this.section});

  Future<void> _read() =>
      launchUrl(Uri.parse(book.link), mode: LaunchMode.externalApplication);

  @override
  Widget build(BuildContext context) {
    final isFav = context.watch<FavoritesProvider>().isFavorite(book.id);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _Header(book: book, section: section, isFav: isFav),
            const Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Plot Synopsis',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700)),
                    SizedBox(height: 12),
                    _Description(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: GradientButton(label: 'Read This Book', onTap: _read),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final Book book;
  final String section;
  final bool isFav;
  const _Header(
      {required this.book, required this.section, required this.isFav});

  @override
  Widget build(BuildContext context) {
    final b = book;
    const white70 = TextStyle(color: Colors.white70, fontSize: 12);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppTheme.gradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.green.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleIconButton(
                  icon: Icons.arrow_back_rounded,
                  onTap: () => Navigator.pop(context)),
              const Spacer(),
              CircleIconButton(
                icon: isFav
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                onTap: () => context.read<FavoritesProvider>().toggle(b),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: coverHeroTag(section, b),
                child: Container(
                  width: 110,
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: BookCover(url: b.coverUrl, radius: 10),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(b.title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            height: 1.2)),
                    const SizedBox(height: 4),
                    Text('by ${b.authorText}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: white70),
                    if (b.firstPublishYear != null)
                      Text('${b.firstPublishYear}', style: white70),
                    if (b.subjects.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      const Text('Genres',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700)),
                      Text(b.subjects.join(', '), style: white70),
                    ],
                    const SizedBox(height: 10),
                    Row(children: [
                      ...List.generate(
                        5,
                        (i) => Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: i < (b.rating ?? 0).round()
                              ? const Color(0xFFFFC83D)
                              : Colors.white38,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(b.rating?.toStringAsFixed(1) ?? '-', style: white70),
                    ]),
                    if (b.pageCount != null) ...[
                      const SizedBox(height: 6),
                      Text('Length: ${b.pageCount} pages', style: white70),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Description extends StatelessWidget {
  const _Description();

  @override
  Widget build(BuildContext context) {
    final p = context.watch<BookDetailsProvider>();
    final muted = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.75);

    if (p.loading) {
      return const Padding(
        padding: EdgeInsets.all(8),
        child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 3)),
      );
    }
    if (p.failed) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Could not load the description.'),
        TextButton(onPressed: p.load, child: const Text('Retry')),
      ]);
    }
    return Text(p.description ?? 'No description available.',
        style: TextStyle(fontSize: 13, height: 1.6, color: muted));
  }
}
