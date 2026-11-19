import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../settings/presentation/widgets/app_drawer.dart';
import '../navigation/open_book.dart';
import '../providers/books_provider.dart';
import '../widgets/book_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  String _title(BooksProvider p) {
    if (p.query.isNotEmpty) return 'Results for "${p.query}"';
    return p.selectedCategory == 'All' ? 'Trending Books' : p.selectedCategory;
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<BooksProvider>();

    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(onSettings: () => _scaffoldKey.currentState?.openDrawer()),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 24),
                children: [
                  const SizedBox(height: 8),
                  _SearchField(controller: _search, onChanged: p.setQuery),
                  const SizedBox(height: 22),
                  const _SectionTitle('Categories'),
                  const SizedBox(height: 12),
                  _Categories(selected: p.selectedCategory, onSelect: p.selectCategory),
                  const SizedBox(height: 22),
                  _SectionTitle(_title(p)),
                  const SizedBox(height: 14),
                  SizedBox(height: 250, child: p.isRecentSelected ? _recentRow(p) : _booksRow(p)),
                  const SizedBox(height: 24),
                  const _SectionTitle('Top Rated Books'),
                  const SizedBox(height: 14),
                  SizedBox(height: 250, child: _topRatedRow(p)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _booksRow(BooksProvider p) {
    switch (p.state) {
      case LoadState.loading:
        return _row(List.generate(3, (_) => const BookCardSkeleton()));
      case LoadState.error:
        return Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(p.errorMessage, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            TextButton(onPressed: p.load, child: const Text('Retry')),
          ]),
        );
      case LoadState.success:
        if (p.books.isEmpty) return const Center(child: Text('No books found.'));
        return _row(p.books
            .map((b) => BookCard(
                book: b, section: 'main', onTap: () => openBookDetails(context, b, 'main')))
            .toList());
    }
  }

  Widget _recentRow(BooksProvider p) {
    if (p.recent.isEmpty) {
      return Center(
        child: Text('Books you open will show up here.',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5))),
      );
    }
    return _row(p.recent
        .map((b) => BookCard(
            book: b, section: 'recent', onTap: () => openBookDetails(context, b, 'recent')))
        .toList());
  }

  Widget _topRatedRow(BooksProvider p) {
    switch (p.topRatedState) {
      case LoadState.loading:
        return _row(List.generate(3, (_) => const BookCardSkeleton()));
      case LoadState.error:
        return const Center(child: Text('Could not load top rated books.'));
      case LoadState.success:
        if (p.topRated.isEmpty) return const Center(child: Text('No rated books found.'));
        return _row(p.topRated
            .map((b) => BookCard(
                book: b, section: 'top', onTap: () => openBookDetails(context, b, 'top')))
            .toList());
    }
  }

  Widget _row(List<Widget> children) => ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: children.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (_, i) => children[i],
      );
}

class _TopBar extends StatelessWidget {
  final VoidCallback onSettings;
  const _TopBar({required this.onSettings});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
      child: Row(
        children: [
          IconButton(
            onPressed: onSettings,
            iconSize: 26,
            icon: const Icon(Icons.settings_outlined),
          ),
          const Expanded(
            child: Center(child: AppLogo(size: 26, color: AppTheme.green)),
          ),
          const SizedBox(width: 48), // balances the settings button
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  const _SearchField({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 48,
        padding: const EdgeInsets.only(left: 18, right: 5),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Row(children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              textInputAction: TextInputAction.search,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search for books, name...',
                hintStyle: TextStyle(fontSize: 14, color: cs.onSurface.withValues(alpha: 0.45)),
                border: InputBorder.none,
              ),
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (_, v, __) => v.text.isEmpty
                ? const SizedBox.shrink()
                : GestureDetector(
                    onTap: () {
                      controller.clear();
                      onChanged('');
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(Icons.close_rounded,
                          size: 18, color: cs.onSurface.withValues(alpha: 0.5)),
                    ),
                  ),
          ),
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(shape: BoxShape.circle, gradient: AppTheme.gradient),
            child: const Icon(Icons.search_rounded, color: Colors.white, size: 20),
          ),
        ]),
      ),
    );
  }
}

class _Categories extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelect;
  const _Categories({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: BooksProvider.categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final c = BooksProvider.categories[i];
          final active = c == selected;
          return GestureDetector(
            onTap: () => onSelect(c),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: active ? AppTheme.gradient : null,
                color: active ? null : cs.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(c,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: active ? Colors.white : cs.onSurface.withValues(alpha: 0.75),
                  )),
            ),
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      );
}
