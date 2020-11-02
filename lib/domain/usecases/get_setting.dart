import 'package:ToDo/core/usecases/usecase_with_params.dart';
import 'package:ToDo/domain/entities/setting.dart';
import 'package:ToDo/domain/repositories/settings_repository.dart';

abstract class GetSettingUseCase
    implements UseCaseWithParams<Future<Setting<String>>, String> {
  @override
  Future<Setting<String>> call(String setting);
}
