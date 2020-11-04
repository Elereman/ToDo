import 'package:ToDo/core/usecases/usecase_without_params.dart';
import 'package:ToDo/domain/entities/task.dart';

abstract class GetAllTasksUseCase
    implements UseCaseWithoutParams<Future<List<Task>>> {
  @override
  Future<List<Task>> call();
}
