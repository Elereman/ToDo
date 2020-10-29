import 'package:ToDo/core/tools/settings_provider.dart';
import 'package:ToDo/core/tools/settings_provider_state.dart';
import 'package:ToDo/domain/entities/task.dart';
import 'package:ToDo/domain/usecases/get_all_tasks.dart';
import 'package:ToDo/presentation/blocs/home_page/events/event.dart';
import 'package:ToDo/presentation/blocs/home_page/state.dart';

class LoadTasksEvent implements HomePageEvent<HomePageState> {
  final SettingsProvider _settingsProvider;
  final GetAllTasksUseCase _loadTasksUseCase;

  LoadTasksEvent(this._settingsProvider, this._loadTasksUseCase);

  @override
  Future<HomePageState> reduce(HomePageState oldState) async {
    final List<Task> _tasks = await _loadTasksUseCase();
    await _settingsProvider.requireAllSettings();
    final SettingsState _settingsState = await _settingsProvider.stateStream.first;
    return HomePageState(_tasks, State.Loaded, _settingsState.settings);
  }
}
