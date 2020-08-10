import 'dart:async';

import 'package:ToDo/blocs/events.dart';
import 'package:ToDo/blocs/states.dart';
import 'package:ToDo/models/setting.dart';
import 'package:ToDo/models/settings_repository.dart';
import 'package:ToDo/models/task.dart';
import 'package:ToDo/models/task_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class HomePageBloc {
  final BehaviorSubject<BlocEvent> _eventStreamController;
  final BehaviorSubject<BlocState<dynamic>> _stateStreamController;
  final TaskRepository _repository;
  final SettingsRepository _settingsRepository;

  HomePageBloc(this._repository, this._settingsRepository)
      : _eventStreamController = BehaviorSubject<BlocEvent>(),
        _stateStreamController = BehaviorSubject<BlocState<dynamic>>(){
    _settingsRepository.initialize();
    _eventStreamController.stream.listen((BlocEvent event) => _handleEvent(event));
  }

  Stream<BlocState<dynamic>> get stateStream => _stateStreamController.stream;

  Sink<BlocEvent> get eventSink => _eventStreamController.sink;

  Future<void> _handleEvent(BlocEvent event) async {
    switch (event.type) {
      case HomePageInitializedEvent:
        print('HomePageInitialized');
        await _repository.initialize().then((void value) async {
          _stateStreamController
              .add(HomePageInitializedState<List<Task>>(await _repository.getAll()));
        });
        break;

      case AddTaskButtonPressedEvent:
        print('TaskButtonPressed');
        final AddTaskButtonPressedEvent _event = event as AddTaskButtonPressedEvent;
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
        final Task updated = await _repository.update(_event.taskO);
        print('TaskPressed');
        _stateStreamController.add(PressedState<Task>(updated));
        break;

      case TaskLongPressedEvent:
        final TaskLongPressedEvent _event = event as TaskLongPressedEvent;
        final Task updated = await _repository.update(_event.taskO);
        print('TaskLongPressed');
        _stateStreamController.add(PressedState<Task>(updated));
        break;

      case SettingsChangedPressedEvent:
        final SettingsChangedPressedEvent _event = event as SettingsChangedPressedEvent;
        _settingsRepository.update(_event.setting);
        print('SettingsChangedPressed');
        _stateStreamController.add(SettingsChangedState<List<Setting<String>>>
          (await _settingsRepository.readAll())
        );
        break;

      case SettingsResetPressedEvent:
        //final SettingsResetPressedEvent _event = event as SettingsResetPressedEvent;
        await _settingsRepository.resetAll();
        _stateStreamController.add(SettingsChangedState<List<Setting<String>>>
          (await _settingsRepository.readAll()));
        break;

      case SettingsBuildEvent:
      //final SettingsResetPressedEvent _event = event as SettingsResetPressedEvent;
        _stateStreamController.add(SettingsChangedState<List<Setting<String>>>
          (await _settingsRepository.readAll()));
        break;
    }
  }
}

class SettingsResetPressedEvent extends BlocEvent {}

class SettingsBuildEvent extends BlocEvent {}

class AddTaskButtonPressedEvent extends BlocEvent {
  final Task task;

  AddTaskButtonPressedEvent({@required this.task});

  String get taskText => task.task;

  String get description => task.description;
}

class SettingsChangedPressedEvent extends BlocEvent {
  final Setting<String> data;

  SettingsChangedPressedEvent({@required this.data});


  Setting<String> get setting => data;
}

class HomePageInitializedEvent extends BlocEvent {}

class TaskDeletedEvent extends BlocEvent {
  final Task task;

  TaskDeletedEvent({@required this.task});

  Task get taskE => task;
}

class AllTaskDeletedEvent extends BlocEvent {
}

class TaskEditedEvent extends BlocEvent {
  final Task task;

  TaskEditedEvent({@required this.task});

  Task get taskE => task;
}

class HomePageInitializedState<T> extends BlocState<T> {
  final T data;

  HomePageInitializedState(this.data);

  @override
  T get stateData => data;
}

class SettingsChangedState<T> extends BlocState<T> {
  final T data;

  SettingsChangedState(this.data);

  @override
  T get stateData => data;
}

class AllTaskDeletedState<T> extends BlocState<T> {
  final T data;

  AllTaskDeletedState(this.data);

  @override
  T get stateData => data;
}

class PressedState<T> extends BlocState<T> {
  final T state;

  PressedState(this.state);

  @override
  T get stateData => state;
}

class TaskDeletedState<T> extends BlocState<T> {
  final T state;

  TaskDeletedState(this.state);

  @override
  T get stateData => state;
}

class LongPressedState<T> extends BlocState<T> {
  final T state;

  LongPressedState(this.state);

  @override
  T get stateData => state;
}