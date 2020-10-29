import 'package:ToDo/domain/entities/task.dart';
import 'package:ToDo/domain/usecases/edit_task.dart';
import 'package:ToDo/presentation/blocs/home_page/events/event.dart';
import 'package:ToDo/presentation/blocs/home_page/state.dart';

class EditTaskEvent implements HomePageEvent<HomePageState> {
  final EditTaskUseCase _editTaskUseCase;
  final Task _task;

  EditTaskEvent(this._editTaskUseCase, this._task);

  @override
  Future<HomePageState> reduce(HomePageState oldState) async {
    final Task _newTask = await _editTaskUseCase(_task);
    oldState.tasks.removeAt(_newTask.id);
    oldState.tasks.insert(_newTask.id, _newTask);
    return oldState;
  }
}
