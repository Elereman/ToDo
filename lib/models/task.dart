class Task {
  final int _id, _color;
  final String _task, _taskDescription;

  bool isCompleted;

  Task(this._id, this._task, this._taskDescription, this._color, {this.isCompleted = false});

  bool get isComplete => isCompleted;
  String get task => _task;
  String get description => _taskDescription;
  int get id => _id;
  int get color => _color;
}