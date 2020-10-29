import 'package:ToDo/domain/entities/setting.dart';
import 'package:ToDo/domain/repositories/settings_repository.dart';
import 'package:ToDo/domain/usecases/get_settings_list.dart';

class GetSettingsListUseCaseThroughRepository
    implements GetSettingsListUseCase {
  final SettingsRepository _repository;

  GetSettingsListUseCaseThroughRepository(this._repository);

  @override
  Future<Map<String, Setting<String>>> call() => _repository.readAll();
}
