import 'package:ToDo/domain/entities/task.dart';
import 'package:ToDo/domain/repositories/task_repository.dart';
import 'package:ToDo/domain/usecases/create_task.dart';

class CreateTaskUseCaseThroughRepository implements CreateTaskUseCase {
  final TaskRepository _repository;

  CreateTaskUseCaseThroughRepository(this._repository);

  @override
  Future<Task> call(Task task) async => _repository.create(task);
}
