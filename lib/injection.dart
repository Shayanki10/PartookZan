import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/usecase/usecase.dart';
import 'features/books/data/datasources/book_local_datasource.dart';
import 'features/books/data/datasources/book_remote_datasource.dart';
import 'features/books/data/repositories/book_repository_impl.dart';
import 'features/books/domain/repositories/book_repository.dart';
import 'features/books/domain/usecases/book_usecases.dart';
import 'features/books/presentation/providers/books_provider.dart';
import 'features/books/presentation/providers/favorites_provider.dart';
import 'features/settings/data/datasources/settings_local_datasource.dart';
import 'features/settings/data/repositories/settings_repository_impl.dart';
import 'features/settings/domain/repositories/settings_repository.dart';
import 'features/settings/domain/usecases/settings_usecases.dart';
import 'features/settings/presentation/providers/theme_provider.dart';

final sl = GetIt.instance;

/// Dependency wiring. To use a fake API, register a different
/// BookRepository implementation here and nothing else changes.
Future<void> initDependencies() async {
  // external
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // books: data
  sl.registerLazySingleton(() => BookRemoteDataSource(sl()));
  sl.registerLazySingleton(() => BookLocalDataSource(sl()));
  sl.registerLazySingleton<BookRepository>(() => BookRepositoryImpl(sl(), sl()));

  // books: domain
  sl.registerLazySingleton(() => GetBooks(sl()));
  sl.registerLazySingleton(() => GetBookDescription(sl()));
  sl.registerLazySingleton(() => GetTopRatedBooks(sl()));
  sl.registerLazySingleton(() => GetRecentBooks(sl()));
  sl.registerLazySingleton(() => AddRecentBook(sl()));
  sl.registerLazySingleton(() => ClearRecentBooks(sl()));

  sl.registerLazySingleton(() => GetFavoriteBooks(sl()));
  sl.registerLazySingleton(() => ToggleFavoriteBook(sl()));

  // books: presentation
  sl.registerFactory(() => BooksProvider(sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory(() => FavoritesProvider(sl(), sl()));

  // settings
  sl.registerLazySingleton(() => SettingsLocalDataSource(sl()));
  sl.registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetDarkMode(sl()));
  sl.registerLazySingleton(() => SetDarkMode(sl()));
}

Future<ThemeProvider> createThemeProvider() async {
  final dark = await sl<GetDarkMode>()(const NoParams());
  return ThemeProvider(sl<SetDarkMode>(), initialDark: dark);
}
