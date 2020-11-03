class Task {
  final int _id;
  final int _color;
  final String _text, _description;
  final bool _isCompleted;

  Task(
      {String description = '',
      String text = '',
      int color = 0,
      bool isCompleted = false,
      int id = 0})
      : _id = id,
        _isCompleted = isCompleted,
        _color = color,
        _text = text,
        _description = description;

  bool get isCompleted => _isCompleted;

  String get text => _text;

  String get description => _description;

  int get id => _id;

  int get color => _color;
}
