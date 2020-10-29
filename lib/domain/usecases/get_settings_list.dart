import 'package:ToDo/core/usecases/usecase_without_params.dart';
import 'package:ToDo/domain/entities/setting.dart';
import 'package:ToDo/domain/repositories/settings_repository.dart';

abstract class GetSettingsListUseCase
    implements UseCaseWithoutParams<Future<Map<String, Setting<String>>>> {
  @override
  Future<Map<String ,Setting<String>>> call();
}
