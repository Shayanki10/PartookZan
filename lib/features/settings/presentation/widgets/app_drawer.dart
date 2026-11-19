import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../books/presentation/providers/books_provider.dart';
import '../../../books/presentation/screens/favorites_screen.dart';
import '../providers/theme_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final books = context.read<BooksProvider>();

    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
                24, MediaQuery.of(context).padding.top + 32, 24, 28),
            decoration: const BoxDecoration(
              gradient: AppTheme.gradient,
              borderRadius: BorderRadius.only(topRight: Radius.circular(28)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppLogo(size: 30),
                SizedBox(height: 4),
                Text('Settings', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.favorite_border_rounded),
            title: const Text('Favorites'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const FavoritesScreen()));
            },
          ),
          SwitchListTile(
            secondary: Icon(theme.isDark
                ? Icons.dark_mode_rounded
                : Icons.light_mode_rounded),
            title: const Text('Dark mode'),
            value: theme.isDark,
            activeThumbColor: AppTheme.green,
            onChanged: theme.setDark,
          ),
          ListTile(
            leading: const Icon(Icons.refresh_rounded),
            title: const Text('Refresh books'),
            onTap: () {
              Navigator.pop(context);
              books.load();
            },
          ),
          ListTile(
            leading: const Icon(Icons.history_rounded),
            title: const Text('Clear recently viewed'),
            onTap: () {
              books.clearRecent();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Recently viewed cleared')));
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline_rounded),
            title: const Text('About app'),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  title: const Row(
                    children: [
                      Icon(Icons.menu_book_rounded,
                          color: AppTheme.green, size: 36),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('PartookZan',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w700)),
                            Text('Version 1.0.0',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  content: const Text(
                      'Discover books, browse by category and read details. '
                      'Book data is provided by Open Library.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
