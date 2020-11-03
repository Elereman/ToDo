import 'package:ToDo/domain/entities/task.dart';
import 'package:ToDo/domain/entities/setting.dart';

class HomePageState {
  final List<Task> _tasks;
  final State _state;
  final Map<String, Setting<String>> _settings;

  HomePageState(this._tasks, this._state, this._settings);

  Map<String, Setting<String>> get settings => _settings;

  State get state => _state;

  List<Task> get tasks => _tasks;
}

enum State { Loading, Loaded, Error }
