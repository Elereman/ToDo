class Task {
  final int _id;
  final String _task, _taskDescription;

  bool isCompleted;

  Task(this._id, this._task, this._taskDescription, {this.isCompleted = false});

  bool get isComplete => isCompleted;
  String get task => _task;
  String get description => _taskDescription;
}