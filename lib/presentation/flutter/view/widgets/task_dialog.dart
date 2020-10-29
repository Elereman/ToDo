import 'package:ToDo/domain/entities/task.dart';
import 'package:ToDo/presentation/flutter/view/widgets/chose_color_button.dart';

import 'package:flutter/material.dart';

class TaskDialog extends StatelessWidget {
  final Function(Task task) _onSaveButton;
  final String _dialogText;

  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<Color> _colorPalette;
  final Color _saveButtonColor;
  final Color _cancelButtonColor;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final String _taskText, _descriptionText, _buttonText, _colorChooserLabel;
  final Color _color;
  final int _id;

  TaskDialog({
    @required Function(Task task) onSaveButton,
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
  })  : _onSaveButton = onSaveButton,
        _dialogText = dialogText,
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

  @override
  Widget build(BuildContext context) {
    _taskController.text = _taskText;
    _descriptionController.text = _descriptionText;
    return Dialog(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 8.0),
                child: Text(_dialogText),
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
                      color: _saveButtonColor,
                      child: const Text('save'),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _onSaveButton(Task(
                            id: _id,
                            task: _taskController.text,
                            taskDescription: _descriptionController.text,
                            color: _color.value,
                          ));
                          _closeDialog(context);
                        }
                      },
                    ),
                    const Spacer(),
                    ChoseColorButton(
                        onColorChosen: (Color color) {
                          //_onSaveButton(
                          //  Task(),
                          // );
                        },
                        colorPalette: _colorPalette,
                        startColor: _color,
                        buttonText: _buttonText,
                        colorChooserLabel: _colorChooserLabel),
                    const Spacer(),
                    MaterialButton(
                      color: _cancelButtonColor,
                      child: const Text('cancel'),
                      onPressed: () => _closeDialog(context),
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

  void _closeDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop(this);
  }

  String get getTaskText => _taskController.text;

  String get getDescription => _descriptionController.text;

  Color get color => _color;
}
