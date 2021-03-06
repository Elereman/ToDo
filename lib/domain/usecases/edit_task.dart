import 'package:ToDo/core/usecases/usecase_with_params.dart';
import 'package:ToDo/domain/entities/task.dart';

abstract class EditTaskUseCase
    implements UseCaseWithParams<Future<Task>, Task> {
  @override
  Future<Task> call(Task task);
}
