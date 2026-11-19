import 'package:material_ui/material_ui.dart';

import '../../domain/usecases/settings_usecases.dart';

class ThemeProvider extends ChangeNotifier {
  final SetDarkMode _setDarkMode;
  ThemeMode mode;

  ThemeProvider(this._setDarkMode, {required bool initialDark})
      : mode = initialDark ? ThemeMode.dark : ThemeMode.light;

  bool get isDark => mode == ThemeMode.dark;

  void setDark(bool value) {
    mode = value ? ThemeMode.dark : ThemeMode.light;
    _setDarkMode(value);
    notifyListeners();
  }
}
