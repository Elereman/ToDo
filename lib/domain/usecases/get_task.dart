import 'package:ToDo/core/usecases/usecase_with_params.dart';
import 'package:ToDo/domain/entities/task.dart';

abstract class GetTaskUseCase implements UseCaseWithParams<Future<Task>, int> {
  @override
  Future<Task> call(int id);
}
