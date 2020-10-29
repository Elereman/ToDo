import 'package:ToDo/core/tools/settings_provider.dart';
import 'package:ToDo/data/usecases/get_all_tasks_through_repository.dart';
import 'package:ToDo/domain/entities/task.dart';
import 'package:ToDo/domain/repositories/task_repository.dart';
import 'package:ToDo/domain/usecases/create_task.dart';
import 'package:ToDo/domain/usecases/delete_all_tasks.dart';
import 'package:ToDo/domain/usecases/delete_task.dart';
import 'package:ToDo/domain/usecases/edit_task.dart';
import 'package:ToDo/domain/usecases/get_all_tasks.dart';
import 'package:ToDo/presentation/blocs/home_page/events/add_task.dart';
import 'package:ToDo/presentation/blocs/home_page/events/delete_all_tasks.dart';
import 'package:ToDo/presentation/blocs/home_page/events/delete_task.dart';
import 'package:ToDo/presentation/blocs/home_page/events/edit_task.dart';
import 'package:ToDo/presentation/blocs/home_page/events/event.dart';
import 'package:ToDo/presentation/blocs/home_page/events/load_tasks.dart';
import 'package:ToDo/presentation/blocs/home_page/state.dart';
import 'package:rxdart/rxdart.dart';

class HomePageBloc {
  final DeleteAllTasksUseCase deleteAllTasksUseCase;
  final GetAllTasksUseCase getAllTasksUseCase;
  final EditTaskUseCase editTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final CreateTaskUseCase createTaskUseCase;

  final TaskRepository repository;
  final SettingsProvider settingsProvider;

  final BehaviorSubject<HomePageState> stateSubject;
  final BehaviorSubject<HomePageEvent<HomePageState>> eventSubject;

  HomePageState _state;

  HomePageBloc(
      {this.settingsProvider,
      this.deleteAllTasksUseCase,
      this.getAllTasksUseCase,
      this.editTaskUseCase,
      this.deleteTaskUseCase,
      this.createTaskUseCase,
      this.repository})
      : stateSubject = BehaviorSubject<HomePageState>(),
        eventSubject = BehaviorSubject<HomePageEvent<HomePageState>>(),
        super() {
    eventSubject.listen((HomePageEvent<HomePageState> event) async {
      _state = await event.reduce(_state);
      stateSubject.sink.add(_state);
    });
    eventSubject.add(LoadTasksEvent(
        settingsProvider, GetAllTasksUseCaseThroughRepository(repository)));
  }

  void createInitialState() {
    eventSubject.add(LoadTasksEvent(
        settingsProvider, GetAllTasksUseCaseThroughRepository(repository)));
  }

  void createTask(Task task) {
    eventSubject.add(AddTaskEvent(task, createTaskUseCase));
  }

  void deleteAllTasks() {
    eventSubject.add(DeleteAllTasksEvent(deleteAllTasksUseCase));
  }

  void deleteTask(Task task) {
    eventSubject.add(DeleteTaskEvent(task.id, deleteTaskUseCase));
  }

  void updateTask(Task task) {
    eventSubject.add(EditTaskEvent(editTaskUseCase, task));
  }
}
