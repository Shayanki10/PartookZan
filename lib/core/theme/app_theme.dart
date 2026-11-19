import 'package:material_ui/material_ui.dart';

class AppTheme {
  static const Color green = Color(0xFF1DB584);
  static const Color mint = Color(0xFFD9F5EA);

  /// The signature green gradient used on the splash, header, chips and buttons.
  static const LinearGradient gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2FCB90), Color(0xFF12A27E)],
  );

  static ThemeData light() => _build(
        Brightness.light,
        bg: Colors.white,
        ink: const Color(0xFF1B2420),
        surface: const Color(0xFFF1F4F2),
        outline: const Color(0xFFE3E7E5),
      );

  static ThemeData dark() => _build(
        Brightness.dark,
        bg: const Color(0xFF0F1613),
        ink: Colors.white,
        surface: const Color(0xFF1A2420),
        outline: const Color(0xFF2A3630),
      );

  static ThemeData _build(
    Brightness b, {
    required Color bg,
    required Color ink,
    required Color surface,
    required Color outline,
  }) {
    final scheme =
        ColorScheme.fromSeed(seedColor: green, brightness: b).copyWith(
      primary: green,
      onPrimary: Colors.white,
      surface: surface,
      onSurface: ink,
      outline: outline,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: b,
      colorScheme: scheme,
      scaffoldBackgroundColor: bg,
      dividerTheme: DividerThemeData(color: outline, thickness: 1, space: 1),
      drawerTheme: DrawerThemeData(backgroundColor: bg),
    );
  }
}
