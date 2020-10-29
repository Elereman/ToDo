import 'package:ToDo/domain/repositories/task_repository.dart';
import 'package:ToDo/domain/usecases/delete_task.dart';

class DeleteTaskUseCaseThroughRepository implements DeleteTaskUseCase {
  final TaskRepository _repository;

  DeleteTaskUseCaseThroughRepository(this._repository);

  @override
  Future<bool> call(int task) => _repository.delete(task);
}
