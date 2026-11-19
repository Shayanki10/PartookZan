import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'features/books/presentation/providers/books_provider.dart';
import 'features/books/presentation/providers/favorites_provider.dart';
import 'features/books/presentation/screens/splash_screen.dart';
import 'features/settings/presentation/providers/theme_provider.dart';
import 'injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  final themeProvider = await createThemeProvider();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider(create: (_) => sl<BooksProvider>()),
        ChangeNotifierProvider(create: (_) => sl<FavoritesProvider>()),
      ],
      child: const PartookZanApp(),
    ),
  );
}

class PartookZanApp extends StatelessWidget {
  const PartookZanApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeProvider>().mode;
    return MaterialApp(
      title: 'PartookZan',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      home: const SplashScreen(),
    );
  }
}
