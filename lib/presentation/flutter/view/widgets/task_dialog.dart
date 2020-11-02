import 'package:ToDo/domain/entities/task.dart';
import 'package:ToDo/presentation/flutter/view/widgets/chose_color_button.dart';

import 'package:flutter/material.dart';

class TaskDialog extends StatefulWidget {
  final String _dialogText;

  final List<Color> _colorPalette;
  final Color _saveButtonColor;
  final Color _cancelButtonColor;

  final String _taskText, _descriptionText, _buttonText, _colorChooserLabel;
  final Color _color;
  final int _id;

  const TaskDialog({
    @required String dialogText,
    Key key,
    Color color = Colors.cyan,
    String taskText = '',
    String descriptionText = '',
    String buttonText = 'Color',
    String colorChooserLabel = 'Choose color',
    Color cancelButtonColor = Colors.redAccent,
    Color saveButtonColor = Colors.greenAccent,
    int id = -1,
    List<Color> colorPalette = const <Color>[
      Colors.yellow,
      Colors.green,
      Colors.red,
      Colors.blueAccent,
      Colors.orange,
      Colors.indigo,
    ],
  })  : _dialogText = dialogText,
        _taskText = taskText,
        _buttonText = buttonText,
        _colorChooserLabel = colorChooserLabel,
        _descriptionText = descriptionText,
        _id = id,
        _cancelButtonColor = cancelButtonColor,
        _saveButtonColor = saveButtonColor,
        _colorPalette = colorPalette,
        _color = color,
        super(key: key);

  TaskDialog.fromTask({
    @required String dialogText,
    Key key,
    Task task,
    String buttonText = 'Color',
    String colorChooserLabel = 'Choose color',
    Color cancelButtonColor = Colors.redAccent,
    Color saveButtonColor = Colors.greenAccent,
    List<Color> colorPalette = const <Color>[
      Colors.yellow,
      Colors.green,
      Colors.red,
      Colors.blueAccent,
      Colors.orange,
      Colors.indigo,
    ],
  })  : _dialogText = dialogText,
        _taskText = task.task,
        _buttonText = buttonText,
        _colorChooserLabel = colorChooserLabel,
        _descriptionText = task.description,
        _id = task.id,
        _cancelButtonColor = cancelButtonColor,
        _saveButtonColor = saveButtonColor,
        _colorPalette = colorPalette,
        _color = Color(task.color),
        super(key: key);

  @override
  _TaskDialogState createState() => _TaskDialogState(_color);
}

class _TaskDialogState extends State<TaskDialog> {
  final TextEditingController _taskController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _TaskDialogState(this._color);

  Color _color;

  @override
  Widget build(BuildContext context) {
    _taskController.text = widget._taskText;
    _descriptionController.text = widget._descriptionText;
    return Dialog(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 8.0),
                child: Text(widget._dialogText),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextFormField(
                  controller: _taskController,
                  //onChanged: (String value) => _taskText = value,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter some task';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: 'Enter a task'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextFormField(
                  controller: _descriptionController,
                  //onChanged: (String value) => _descriptionText = value,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter some description';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter a description'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    MaterialButton(
                      color: widget._saveButtonColor,
                      child: const Text('save'),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _closeDialog(
                              context,
                              Task(
                                id: widget._id,
                                task: _taskController.text,
                                taskDescription: _descriptionController.text,
                                color: _color.value,
                              ));
                        }
                      },
                    ),
                    const Spacer(),
                    ChoseColorButton(
                        onColorChosen: (Color color) {
                          _color = color;
                        },
                        colorPalette: widget._colorPalette,
                        startColor: widget._color,
                        buttonText: widget._buttonText,
                        colorChooserLabel: widget._colorChooserLabel),
                    const Spacer(),
                    MaterialButton(
                      color: widget._cancelButtonColor,
                      child: const Text('cancel'),
                      onPressed: () => _closeDialog(context, null),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _closeDialog(BuildContext context, Task task) {
    Navigator.of(context, rootNavigator: true).pop(task);
  }

  String get getTaskText => _taskController.text;

  String get getDescription => _descriptionController.text;

  Color get color => widget._color;
}
