import '../../../../core/usecase/usecase.dart';
import '../repositories/settings_repository.dart';

class GetDarkMode extends UseCase<bool, NoParams> {
  final SettingsRepository _repo;
  GetDarkMode(this._repo);

  @override
  Future<bool> call(NoParams _) => _repo.isDarkMode();
}

class SetDarkMode extends UseCase<void, bool> {
  final SettingsRepository _repo;
  SetDarkMode(this._repo);

  @override
  Future<void> call(bool value) => _repo.setDarkMode(value);
}
