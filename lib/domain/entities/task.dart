class Task {
  final int _id;
  final int _color;
  final String _task, _taskDescription;
  final bool _isCompleted;

  Task(
      {String taskDescription = '',
      String task = '',
      int color = 0,
      bool isCompleted = false,
      int id = 0})
      : _id = id,
        _isCompleted = isCompleted,
        _color = color,
        _task = task,
        _taskDescription = taskDescription;

  bool get isCompleted => _isCompleted;

  String get task => _task;

  String get description => _taskDescription;

  int get id => _id;

  int get color => _color;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': _id,
        'task': _task,
        'description': _taskDescription,
        'color': _color,
        'completed': _isCompleted,
      };
}
