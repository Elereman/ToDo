import 'dart:io';

import 'package:ToDo/blocs/events.dart';
import 'package:ToDo/blocs/states.dart' as states;
import 'package:ToDo/blocs/task_dialog_bloc.dart' as tbloc;
import 'package:ToDo/view/widgets/color_chose.dart';
import 'package:flutter/material.dart';

class TaskDialog extends StatelessWidget {
  final Function(String task, String description,int colorHex,) onSaveButton;
  final String dialogText;
  final tbloc.TaskDialogBloc bloc;

  final taskController = TextEditingController();
  final descriptionController = TextEditingController();

  String task, description;
  Color color;

  TaskDialog({Key key,
    @required this.onSaveButton,
    @required this.dialogText,
    @required this.bloc,
    this.color : Colors.cyan,
    this.task : '',
    this.description : ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    taskController.text = task;
    descriptionController.text = description;
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
                  controller: taskController,
                  onChanged: (value) => task = value,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter a task'
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal : 8.0),
                child: TextField(
                  controller: descriptionController,
                  onChanged: (value) => description = value,
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
                        this.onSaveButton(taskController.text, descriptionController.text, color.value);
                        _closeDialog(context);
                      },
                    ),
                    Spacer(),
                    StreamBuilder<states.State>(
                      stream: bloc.stateStream,
                      builder: (context, snapshot) {
                        color = _getColorFromSnapshot(snapshot);
                        return MaterialButton(
                          color: color,
                          child: Text('color'),
                          onPressed: () {
                            _showColorPicker(context).then((value) {
                              color = value.chosenColor;
                              _sendColorChangedToBloc(color);
                            });
                            },
                        );
                      }
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

  Future<dynamic> _showColorPicker(BuildContext context) async {
    return showDialog(
      context: context,
      child: ColorChoose(
        defaultColor: color,
        color: color,
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

  Color _getColorFromSnapshot(AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      print(snapshot.data);
      if(snapshot.data is tbloc.ColorChangedState<int>) {
        tbloc.ColorChangedState<int> colorChange = snapshot.data as tbloc.ColorChangedState<int>;
        return Color(colorChange.data);
      }
    }
    return color;
  }

  void _closeDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop(this);
  }

  void _sendEventToBloc(Event event) {
    bloc.eventSink.add(event);
  }

  void _sendColorChangedToBloc(Color color) {
    _sendEventToBloc(tbloc.ColorChangedEvent(color));
  }

  String get getTask => task;

  String get getDescription => description;

  Color get clolors => color;

  set setTask(String val) => task = val;

  set setDescription(String val) => description = val;
}