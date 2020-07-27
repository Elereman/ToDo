import 'package:ToDo/models/task.dart';
import 'package:flutter/foundation.dart';

abstract class Event with _GetRuntimeType {}

class TaskPressedEvent extends Event {}

class TaskLongPressedEvent extends Event {
  final Task taskO;

  TaskLongPressedEvent({@required this.taskO});

  TaskLongPressedEvent.fromStrings({String task, String description, int colorHex}) :
        this(taskO: Task(1, task, description, colorHex));

  String get task => taskO.task;
  String get description => taskO.description;
}

mixin _GetRuntimeType {
  Type get type => this.runtimeType;
}