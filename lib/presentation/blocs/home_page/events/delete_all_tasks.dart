import 'package:ToDo/domain/entities/task.dart';
import 'package:ToDo/domain/usecases/delete_all_tasks.dart';
import 'package:ToDo/presentation/blocs/home_page/events/event.dart';
import 'package:ToDo/presentation/blocs/home_page/state.dart';

class DeleteAllTasksEvent implements HomePageEvent<HomePageState> {
  final DeleteAllTasksUseCase _deleteAllTasksUseCase;

  DeleteAllTasksEvent(this._deleteAllTasksUseCase);

  @override
  Future<HomePageState> reduce(HomePageState oldState) async {
    _deleteAllTasksUseCase();
    return HomePageState(<Task>[], oldState.state, oldState.settings);
  }
}
