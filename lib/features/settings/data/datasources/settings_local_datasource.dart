import 'package:shared_preferences/shared_preferences.dart';

class SettingsLocalDataSource {
  static const _darkKey = 'dark_mode';
  final SharedPreferences _prefs;
  SettingsLocalDataSource(this._prefs);

  bool getDark() => _prefs.getBool(_darkKey) ?? false;
  Future<void> setDark(bool v) => _prefs.setBool(_darkKey, v);
}
