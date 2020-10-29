import 'package:ToDo/core/usecases/usecase_without_params.dart';

abstract class ResetSettingsListUseCase implements UseCaseWithoutParams<Future<bool>> {
  @override
  Future<bool> call();
}
