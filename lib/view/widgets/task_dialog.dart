import 'package:ToDo/blocs/events.dart';
import 'package:ToDo/blocs/states.dart' as states;
import 'package:ToDo/blocs/task_dialog_bloc.dart' as tbloc;
import 'package:ToDo/models/task.dart';
import 'package:ToDo/view/widgets/color_chose.dart';
import 'package:flutter/material.dart';

class TaskDialog extends StatelessWidget {
  final Function(
    String task,
    String description,
    int colorHex,
  ) onSaveButton;
  final String dialogText;
  final tbloc.TaskDialogBloc bloc;

  final TextEditingController taskController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String task, description;
  Color color;

  Task taskO;

  TaskDialog(
      {@required this.onSaveButton,
      @required this.dialogText,
      @required this.bloc,
      Key key,
      this.color = Colors.cyan,
      this.task = '',
      this.description = ''})
      : super(key: key);

  TaskDialog.edit(
      {@required this.onSaveButton,
      @required this.dialogText,
      @required this.bloc,
      @required this.taskO,
      Key key,
      this.color = Colors.cyan,
      this.task = '',
      this.description = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    taskController.text = task;
    descriptionController.text = description;
    return Dialog(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsetsDirectional.only(top: 8.0),
              child: Text(dialogText),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                controller: taskController,
                onChanged: (String value) => task = value,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'Enter a task'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                controller: descriptionController,
                onChanged: (String value) => description = value,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'Enter a description'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  MaterialButton(
                    color: Colors.greenAccent,
                    child: const Text('save'),
                    onPressed: () {
                      onSaveButton(taskController.text,
                          descriptionController.text, color.value);
                      _closeDialog(context);
                    },
                  ),
                  const Spacer(),
                  StreamBuilder<states.State<dynamic>>(
                      stream: bloc.stateStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<states.State<dynamic>> snapshot) {
                        color = _getColorFromSnapshot(snapshot);
                        return MaterialButton(
                          color: color,
                          child: const Text('color'),
                          onPressed: () {
                            _showColorPicker(context).then((ColorChoose value) {
                              color = value.chosenColor;
                              _sendColorChangedToBloc(color);
                            });
                          },
                        );
                      }),
                  const Spacer(),
                  MaterialButton(
                    color: Colors.redAccent,
                    child: const Text('cancel'),
                    onPressed: () => _closeDialog(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void changeColor(Color color) {
    print(color);
    this.color = color;
  }

  Future<ColorChoose> _showColorPicker(BuildContext context) async {
    return showDialog<ColorChoose>(
      context: context,
      child: ColorChoose(
        defaultColor: color,
        color: color,
        label: 'Chose color',
        colors: <Color>[
          Colors.yellow,
          Colors.green,
          Colors.red,
          Colors.blueAccent,
          Colors.orange,
          Colors.deepOrange,
        ],
        function: changeColor,
      ),
    );
  }

  Color _getColorFromSnapshot(AsyncSnapshot<states.State<dynamic>> snapshot) {
    if (snapshot.hasData) {
      print(snapshot.data);
      if (snapshot.data is tbloc.ColorChangedState<int>) {
        final tbloc.ColorChangedState<int> colorChange =
            snapshot.data as tbloc.ColorChangedState<int>;
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
    _sendEventToBloc(tbloc.ColorChangedEvent(color.value));
  }

  String get getTask => task;

  String get getDescription => description;

  Color get clolors => color;

  set setTask(String val) => task = val;

  set setDescription(String val) => description = val;
}
