import 'package:ToDo/domain/entities/setting.dart';
import 'package:ToDo/domain/repositories/settings_repository.dart';
import 'package:ToDo/domain/usecases/get_setting.dart';

class GetSettingUseCaseThroughRepository implements GetSettingUseCase {
  final SettingsRepository _repository;

  GetSettingUseCaseThroughRepository(this._repository);

  @override
  Future<Setting<String>> call(String setting) => _repository.read(setting);
}
