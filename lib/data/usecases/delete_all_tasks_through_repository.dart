import 'package:ToDo/domain/repositories/task_repository.dart';
import 'package:ToDo/domain/usecases/delete_all_tasks.dart';

class DeleteAllTasksUseCaseThroughRepository implements DeleteAllTasksUseCase {
  final TaskRepository _repository;

  DeleteAllTasksUseCaseThroughRepository(this._repository);

  @override
  Future<bool> call() => _repository.deleteAll();
}
