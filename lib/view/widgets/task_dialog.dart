import 'package:ToDo/view/widgets/color_chose.dart';
import 'package:flutter/material.dart';

class TaskDialog extends StatelessWidget {
  final Function(String task, String description) onSaveButton;
  final String dialogText;

  String _task = '', _description = '';
  Color color = Colors.cyan;

  TaskDialog({Key key, @required this.onSaveButton, @required this.dialogText, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Container(
          height: 160,
          child: Column(
            children: [
              Text(dialogText),
              Padding(
                padding: EdgeInsets.symmetric(horizontal : 8.0),
                child: TextField(
                  onChanged: (value) => _task = value,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter a task'
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal : 8.0),
                child: TextField(
                  onChanged: (value) => _description = value,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter a description'
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal : 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MaterialButton(
                      color: Colors.greenAccent,
                      child: Text('save'),
                      onPressed: () {
                        this.onSaveButton(_task, _description);
                        _closeDialog(context);
                      },
                    ),
                    Spacer(),
                    MaterialButton(
                      color: Colors.yellow,
                      child: Text('color'),
                      onPressed: () {_showColorPicker(context);},
                    ),
                    Spacer(),
                    MaterialButton(
                      color: Colors.redAccent,
                      child: Text('cancel'),
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

  void changeColor(Color color) {
    print(color);
    this.color = color;
  }

  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      child: ColorChoose(
        label: 'Chose color',
        colors: [
          Colors.yellow,
          Colors.green,
          Colors.red,
          Colors.blue,
          Colors.orange,
        ],
        function: changeColor,
      ),
    );
  }

  void _closeDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop(this);
  }

  String get task => _task;

  String get description => _description;

  Color get clolors => color;
}