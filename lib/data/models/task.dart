class TaskModel {
  final int _id, _color;
  final String _text, _description;
  final bool _isCompleted;

  TaskModel(
      {int id, int color, String text, String description, bool isCompleted})
      : _id = id,
        _color = color,
        _text = text,
        _description = description,
        _isCompleted = isCompleted,
        super();

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as int,
      color: json['color'] as int,
      text: json['text'] as String,
      description: json['description'] as String,
      isCompleted: json['completed'] as bool,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': _id,
        'text': _text,
        'description': _description,
        'color': _color,
        'completed': _isCompleted,
      };

  bool get isCompleted => _isCompleted;

  String get description => _description;

  String get text => _text;

  int get color => _color;

  int get id => _id;
}
