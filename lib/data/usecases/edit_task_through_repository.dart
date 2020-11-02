import 'package:ToDo/domain/entities/task.dart';
import 'package:ToDo/domain/repositories/task_repository.dart';
import 'package:ToDo/domain/usecases/edit_task.dart';

class EditTaskUseCaseThroughRepository implements EditTaskUseCase {
  final TaskRepository _repository;

  EditTaskUseCaseThroughRepository(this._repository);

  @override
  Future<Task> call(Task task) => _repository.update(task);
}
