import 'package:ToDo/core/usecases/usecase_with_params.dart';
import 'package:ToDo/domain/entities/setting.dart';

abstract class EditSettingUseCase implements UseCaseWithParams<Future<Setting<String>>, Setting<String>> {
  @override
  Future<Setting<String>> call(Setting<String> setting);
}