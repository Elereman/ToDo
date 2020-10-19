class TaskModel {
  final int _id;
  final int _color;
  final String _task, _taskDescription;
  final bool _isCompleted;

  TaskModel._(this._id, this._color, this._task, this._taskDescription,
      this._isCompleted);

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel._(
      json['id'] as int,
      json['color'] as int,
      json['task'] as String,
      json['description'] as String,
      json['completed'] as bool,
    );
  }

  bool get isCompleted => _isCompleted;

  String get taskDescription => _taskDescription;

  String get task => _task;

  int get color => _color;

  int get id => _id;
}
