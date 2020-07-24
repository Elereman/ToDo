import 'dart:async';

import 'package:ToDo/models/task.dart';
import 'package:ToDo/view/widgets/task_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class HomePageBloc {
  final StreamController<Event> _eventStreamController;
  final StreamController<State> _stateStreamController;

  HomePageBloc()
      : _eventStreamController = StreamController<Event>(),
        _stateStreamController = StreamController<State>() {
    _eventStreamController.stream.listen((event) => _handleEvent(event));
  }

  Stream<State> get stateStream => _stateStreamController.stream;

  Sink<Event> get eventSink => _eventStreamController.sink;

  void _handleEvent(Event event) {
    switch (event.type) {
      case AddTaskButtonPressedEvent:
        print('TaskButtonPressed');
        AddTaskButtonPressedEvent _event = event as AddTaskButtonPressedEvent;
        _stateStreamController.add(TaskWidgetCreatedState(SimpleTaskWidget(
          task: _event.task,
          description: _event.description,
          color: Colors.blueAccent,
        )));
        break;
    }
  }
}

abstract class State<T> with _GetRuntimeType {
  T get stateData;
}

abstract class Event with _GetRuntimeType {}

class AddTaskButtonPressedEvent extends Event {
  final Task taskO;

  AddTaskButtonPressedEvent({@required this.taskO});

  AddTaskButtonPressedEvent.fromStrings({String task, String description}) :
      this(taskO: Task(1, task, description));

  String get task => taskO.task;
  String get description => taskO.description;
}

class TaskWidgetCreatedState<T> extends State {
  final T _data;

  TaskWidgetCreatedState(this._data);

  @override
  T get stateData => _data;
}

mixin _GetRuntimeType {
  Type get type => this.runtimeType;
}