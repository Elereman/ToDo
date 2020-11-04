import 'package:ToDo/core/usecases/usecase_without_params.dart';

abstract class DeleteAllTasksUseCase
    implements UseCaseWithoutParams<Future<bool>> {
  @override
  Future<bool> call();
}
