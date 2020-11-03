import 'package:ToDo/core/usecases/usecase_with_params.dart';

abstract class DeleteTaskUseCase
    implements UseCaseWithParams<Future<bool>, int> {
  @override
  Future<bool> call(int task);
}
