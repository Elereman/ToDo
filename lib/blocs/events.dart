import 'package:ToDo/models/task.dart';
import 'package:flutter/foundation.dart';

abstract class BlocEvent with _GetRuntimeType {}

class TaskPressedEvent extends BlocEvent {
  final Task taskO;

  TaskPressedEvent({@required this.taskO});

  TaskPressedEvent.fromStrings({String task, String description, int colorHex}) :
        this(taskO: Task(task, description, colorHex));

  String get task => taskO.task;
  String get description => taskO.description;
}

class TaskLongPressedEvent extends BlocEvent {
  final Task taskO;

  TaskLongPressedEvent({@required this.taskO});

  TaskLongPressedEvent.fromStrings({String task, String description, int colorHex}) :
        this(taskO: Task(task, description, colorHex));

  String get task => taskO.task;
  String get description => taskO.description;
}

mixin _GetRuntimeType {
  Type get type => runtimeType;
}