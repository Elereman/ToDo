import 'package:ToDo/domain/repositories/settings_repository.dart';
import 'package:ToDo/domain/usecases/reset_settings.dart';

class ResetSettingsListUseCaseThroughRepository
    implements ResetSettingsListUseCase {
  final SettingsRepository _repository;

  ResetSettingsListUseCaseThroughRepository(this._repository);

  @override
  Future<bool> call() => _repository.resetAll();
}
