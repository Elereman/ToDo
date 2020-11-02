import 'package:ToDo/domain/entities/task.dart';
import 'package:ToDo/domain/usecases/delete_task.dart';
import 'package:ToDo/presentation/blocs/home_page/events/event.dart';
import 'package:ToDo/presentation/blocs/home_page/state.dart';

class DeleteTaskEvent implements HomePageEvent<HomePageState> {
  final int _id;
  final DeleteTaskUseCase _deleteTaskUseCase;

  DeleteTaskEvent(this._id, this._deleteTaskUseCase);

  @override
  Future<HomePageState> reduce(HomePageState oldState) async {
    _deleteTaskUseCase(_id);
    oldState.tasks.removeAt(_id);
    return _rebuildIDsInState(oldState);
  }

  HomePageState _rebuildIDsInState(HomePageState state) {
    final List<Task> _result = <Task>[];
    int id = 0;
    state.tasks.forEach((Task element) {
      Task newElement;
      if (element.id == id + 1) {
        newElement = Task(
          id: id,
          text: element.text,
          description: element.description,
          color: element.color,
          isCompleted: element.isCompleted,
        );
        _result.add(newElement);
      } else {
        _result.add(element);
      }
      ++id;
    });
    return HomePageState(_result, state.state, state.settings);
  }
}
