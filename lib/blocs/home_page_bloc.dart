import 'dart:async';
import 'dart:math';

import 'package:ToDo/blocs/events.dart';
import 'package:ToDo/blocs/states.dart' as states;
import 'package:ToDo/blocs/states.dart';
import 'package:ToDo/models/mock_task_repository.dart';
import 'package:ToDo/models/task.dart';
import 'package:ToDo/models/task_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';


class HomePageBloc {
  final BehaviorSubject<Event> _eventStreamController;
  final BehaviorSubject<states.State> _stateStreamController;
  final TaskRepository _repository;

  List colors = [Colors.red, Colors.green, Colors.yellow, Colors.blue,
    Colors.amber, Colors.cyan];
  Random random = new Random();

  HomePageBloc()
      : _eventStreamController = BehaviorSubject<Event>(),
        _stateStreamController = BehaviorSubject<states.State>(),
        _repository = MockTaskRepository() {
    _eventStreamController.stream.listen((event) => _handleEvent(event));
  }

  Stream<states.State> get stateStream => _stateStreamController.stream;

  Sink<Event> get eventSink => _eventStreamController.sink;

  void _handleEvent(Event event) {
    switch (event.type) {
      case AddTaskButtonPressedEvent:
        print('TaskButtonPressed');
        AddTaskButtonPressedEvent _event = event as AddTaskButtonPressedEvent;
        _repository.create(_event.task);
        _stateStreamController.add(TaskWidgetCreatedState(
            Task(1,_event.task.task,_event.task.description)
        ));
        break;

      case TaskPressedEvent:
        print('TaskPressed');
        _stateStreamController.add(PressedState<bool>(true));
        break;

      case TaskLongPressedEvent:
        print('TaskLongPressed');
        _stateStreamController.add(PressedState<bool>(true));
        break;
    }
  }
}

class AddTaskButtonPressedEvent extends Event {
  final Task task;

  AddTaskButtonPressedEvent({@required this.task});

  AddTaskButtonPressedEvent.fromStrings({String task, String description}) :
        this(task: Task(1, task, description));

  String get taskText => task.task;
  String get description => task.description;
}

class PressedState<T> extends states.State {
  final T state;

  PressedState(this.state);

  @override
  get stateData => state;
}

class LongPressedState<T> extends states.State {
  final T state;

  LongPressedState(this.state);

  @override
  get stateData => state;
}