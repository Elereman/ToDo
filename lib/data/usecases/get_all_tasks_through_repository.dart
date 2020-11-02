import 'package:ToDo/domain/entities/task.dart';
import 'package:ToDo/domain/repositories/task_repository.dart';
import 'package:ToDo/domain/usecases/get_all_tasks.dart';

class GetAllTasksUseCaseThroughRepository implements GetAllTasksUseCase {
  final TaskRepository _repository;

  GetAllTasksUseCaseThroughRepository(this._repository);

  @override
  Future<List<Task>> call() => _repository.getAll();
}
