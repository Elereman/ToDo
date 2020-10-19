import 'dart:async';

import 'file:///D:/ToDo/lib/domain/entities/setting.dart';
import 'file:///D:/ToDo/lib/domain/entities/task.dart';
import 'package:ToDo/domain/repositories/task_repository.dart';
import 'package:ToDo/presentation/blocs/events.dart';
import 'package:ToDo/presentation/blocs/states.dart';
import 'package:ToDo/tools/settings_provider.dart';
import 'package:rxdart/rxdart.dart';

class HomePageBloc {
  final BehaviorSubject<BlocEvent> _eventStreamController;
  final BehaviorSubject<BlocState<dynamic>> _stateStreamController;
  final TaskRepository _repository;
  final SettingsProvider _settingsProvider;

  HomePageBloc(this._repository, this._settingsProvider)
      : _eventStreamController = BehaviorSubject<BlocEvent>(),
        _stateStreamController = BehaviorSubject<BlocState<dynamic>>() {
    _eventStreamController.stream
        .listen((BlocEvent event) async => await _handleHomePageEvent(event));
    _settingsProvider.stateStream.listen(
        (BlocState<dynamic> state) async => await _handleSettingsProviderState(state));
  }

  Stream<BlocState<dynamic>> get stateStream => _stateStreamController.stream;

  Sink<BlocEvent> get eventSink => _eventStreamController.sink;

  Future<void> _handleHomePageEvent(BlocEvent event) async {
    switch (event.type) {
      case HomePageInitializedEvent:
        print('HomePageInitialized');
        await _repository.initialize();
          _stateStreamController.add(
              HomePageInitializedState<List<Task>>(await _repository.getAll()));
        break;

      case AddTaskButtonPressedEvent:
        print('TaskButtonPressed');
        final AddTaskButtonPressedEvent _event =
            event as AddTaskButtonPressedEvent;
        await _repository.create(_event.task);
        _stateStreamController.add(TaskWidgetCreatedState<Task>(_event.task));
        break;

      case TaskDeletedEvent:
        print('TaskDeleted');
        final TaskDeletedEvent _event = event as TaskDeletedEvent;
        await _repository.delete(_event.task);
        _stateStreamController.add(TaskDeletedState<Task>(_event.task));
        break;

      case AllTaskDeletedEvent:
        print('AllTaskDeleted');
        final bool res = await _repository.deleteAll();
        _stateStreamController.add(AllTaskDeletedState<bool>(res));
        break;

      case TaskPressedEvent:
        final TaskPressedEvent _event = event as TaskPressedEvent;
        final Task updated = await _repository.update(_event.task);
        print('TaskPressed');
        _stateStreamController.add(PressedState<Task>(updated));
        break;

      case TaskLongPressedEvent:
        final TaskLongPressedEvent _event = event as TaskLongPressedEvent;
        final Task updated = await _repository.update(_event.task);
        print('TaskLongPressed');
        _stateStreamController.add(PressedState<Task>(updated));
        break;
    }
  }

  Future<void> _handleSettingsProviderState(BlocState<dynamic> state) async {
    print('lsd asd fgh ${state.stateData}');
    if (state is SettingsChangedState<List<Setting<String>>>) {
      _stateStreamController.add(state);
    }
  }
}