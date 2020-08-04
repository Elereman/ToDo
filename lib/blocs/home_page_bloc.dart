import 'dart:async';

import 'package:ToDo/blocs/events.dart';
import 'package:ToDo/blocs/states.dart' as states;
import 'package:ToDo/blocs/states.dart';
import 'package:ToDo/models/file_system_repository.dart';
import 'package:ToDo/models/mock_task_repository.dart';
import 'package:ToDo/models/task.dart';
import 'package:ToDo/models/task_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class HomePageBloc {
  final BehaviorSubject<Event> _eventStreamController;
  final BehaviorSubject<states.State<dynamic>> _stateStreamController;
  final TaskRepository _repository;

  HomePageBloc()
      : _eventStreamController = BehaviorSubject<Event>(),
        _stateStreamController = BehaviorSubject<states.State<dynamic>>(),
        _repository = FileSystemRepository() {
    _eventStreamController.stream.listen((Event event) => _handleEvent(event));
  }

  Stream<states.State<dynamic>> get stateStream => _stateStreamController.stream;

  Sink<Event> get eventSink => _eventStreamController.sink;

  Future<void> _handleEvent(Event event) async {
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
        final AllTaskDeletedEvent _event = event as AllTaskDeletedEvent;
        _event.taskE.forEach((Task element) async {
          await _repository.delete(element);
        });
        _stateStreamController.add(AllTaskDeletedState<List<Task>>(_event.task));
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
    }
  }
}

class AddTaskButtonPressedEvent extends Event {
  final Task task;

  AddTaskButtonPressedEvent({@required this.task});

  AddTaskButtonPressedEvent.fromStrings(
      {String task, String description, int colorHex})
      : this(task: Task(task, description, colorHex));

  String get taskText => task.task;

  String get description => task.description;
}

class HomePageInitializedEvent extends Event {}

class TaskDeletedEvent extends Event {
  final Task task;

  TaskDeletedEvent({@required this.task});

  Task get taskE => task;
}

class AllTaskDeletedEvent extends Event {
  final List<Task> task;

  AllTaskDeletedEvent({@required this.task});

  List<Task> get taskE => task;
}

class TaskEditedEvent extends Event {
  final Task task;

  TaskEditedEvent({@required this.task});

  Task get taskE => task;
}

class HomePageInitializedState<T> extends states.State<T> {
  final T data;

  HomePageInitializedState(this.data);

  @override
  T get stateData => data;
}

class AllTaskDeletedState<T> extends states.State<T> {
  final T data;

  AllTaskDeletedState(this.data);

  @override
  T get stateData => data;
}

class PressedState<T> extends states.State<T> {
  final T state;

  PressedState(this.state);

  @override
  T get stateData => state;
}

class TaskDeletedState<T> extends states.State<T> {
  final T state;

  TaskDeletedState(this.state);

  @override
  T get stateData => state;
}

class LongPressedState<T> extends states.State<T> {
  final T state;

  LongPressedState(this.state);

  @override
  T get stateData => state;
}