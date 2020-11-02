import 'package:ToDo/domain/entities/task.dart';
import 'package:ToDo/domain/usecases/create_task.dart';
import 'package:ToDo/presentation/blocs/home_page/events/event.dart';
import 'package:ToDo/presentation/blocs/home_page/state.dart';

class AddTaskEvent implements HomePageEvent<HomePageState> {
  final Task _task;
  final CreateTaskUseCase _createTaskUseCase;

  AddTaskEvent(this._task, this._createTaskUseCase);

  @override
  Future<HomePageState> reduce(HomePageState oldState) async {
    oldState.tasks.add(await _createTaskUseCase(_task));
    final HomePageState _newState =
        HomePageState(oldState.tasks, oldState.state, oldState.settings);
    return _newState;
  }
}
