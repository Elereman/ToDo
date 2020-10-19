import 'file:///D:/ToDo/lib/domain/entities/setting.dart';
import 'file:///D:/ToDo/lib/domain/entities/task.dart';
import 'package:flutter/foundation.dart';

abstract class BlocEvent with _GetRuntimeType {}

abstract class BlockEventWithTask extends BlocEvent {
  final Task _task;

  BlockEventWithTask({@required Task task}) : _task = task;

  Task get task => _task;

  String get taskText => _task.task;

  String get descriptionText => _task.description;
}

class TaskPressedEvent extends BlockEventWithTask {
  TaskPressedEvent({@required Task task}) : super(task: task);
}

class TaskLongPressedEvent extends BlockEventWithTask {
  TaskLongPressedEvent({@required Task task}) : super(task: task);
}

class AddTaskButtonPressedEvent extends BlockEventWithTask {
  AddTaskButtonPressedEvent({@required Task task}) : super(task: task);
}

class TaskDeletedEvent extends BlockEventWithTask {
  TaskDeletedEvent({@required Task task}) : super(task: task);
}

class TaskEditedEvent extends BlockEventWithTask {}

class SettingsResetPressedEvent extends BlocEvent {}

class SettingsBuildEvent extends BlocEvent {}

class SettingsChangedPressedEvent extends BlocEvent {
  final Setting<String> data;

  SettingsChangedPressedEvent({@required this.data});

  Setting<String> get setting => data;
}

class HomePageInitializedEvent extends BlocEvent {}

class AllTaskDeletedEvent extends BlocEvent {}

class ColorChangedEvent extends BlocEvent {
  final int colorHex;

  ColorChangedEvent(this.colorHex);
}

mixin _GetRuntimeType {
  Type get type => runtimeType;
}