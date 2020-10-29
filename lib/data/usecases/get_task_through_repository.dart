import 'package:ToDo/domain/entities/task.dart';
import 'package:ToDo/domain/repositories/task_repository.dart';
import 'package:ToDo/domain/usecases/get_task.dart';

class GetTaskUseCaseThroughRepository implements GetTaskUseCase {
  final TaskRepository _repository;

  GetTaskUseCaseThroughRepository(this._repository);

  @override
  Future<Task> call(int id) => _repository.get(id);
}
