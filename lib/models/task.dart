class Task {
  int id;
  final int _color;
  final String _task, _taskDescription;

  bool isCompleted;

  Task(this._task, this._taskDescription, this._color,
      {this.isCompleted = false, this.id = -1});

  bool get isComplete => isCompleted;

  String get task => _task;

  String get description => _taskDescription;

  int get TaskID => id;

  int get color => _color;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'task': _task,
        'description': _taskDescription,
        'color': _color,
        'completed': isCompleted,
      };
}
