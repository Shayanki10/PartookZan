import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_datasource.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource _local;
  SettingsRepositoryImpl(this._local);

  @override
  Future<bool> isDarkMode() async => _local.getDark();

  @override
  Future<void> setDarkMode(bool value) => _local.setDark(value);
}
