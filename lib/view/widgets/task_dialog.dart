import 'package:ToDo/blocs/events.dart';
import 'package:ToDo/blocs/states.dart';
import 'package:ToDo/blocs/task_dialog.dart';
import 'package:ToDo/domain/task/task.dart';
import 'package:ToDo/view/widgets/color_chose.dart';
import 'package:flutter/material.dart';

class TaskDialog extends StatelessWidget {
  final Function(
    Task task,
  ) onSaveButton;
  final String dialogText;
  final TaskDialogBloc bloc;

  final TextEditingController taskController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final List<Color> colorPalette;
  final Color saveButtonColor;
  final Color cancelButtonColor;

  String task, description;
  Color color;

  Task taskO;

  TaskDialog({
    @required this.onSaveButton,
    @required this.dialogText,
    @required this.bloc,
    Key key,
    this.color = Colors.cyan,
    this.task = '',
    this.description = '',
    this.cancelButtonColor = Colors.redAccent,
    this.saveButtonColor = Colors.greenAccent,
    this.colorPalette = const <Color>[
      Colors.yellow,
      Colors.green,
      Colors.red,
      Colors.blueAccent,
      Colors.orange,
      Colors.indigo,
    ],
  }) : super(key: key);

  TaskDialog.edit({
    @required this.onSaveButton,
    @required this.dialogText,
    @required this.bloc,
    @required this.taskO,
    Key key,
    this.color = Colors.cyan,
    this.task = '',
    this.description = '',
    this.cancelButtonColor = Colors.redAccent,
    this.saveButtonColor = Colors.greenAccent,
    this.colorPalette = const <Color>[
      Colors.yellow,
      Colors.green,
      Colors.red,
      Colors.blueAccent,
      Colors.orange,
      Colors.indigo,
    ],
  }) : super(key: key);

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
                    color: saveButtonColor,
                    child: const Text('save'),
                    onPressed: () {
                      onSaveButton(Task(
                          taskController.text,
                          descriptionController.text, color.value
                      ));
                      _closeDialog(context);
                    },
                  ),
                  const Spacer(),
                  StreamBuilder<BlocState<dynamic>>(
                      stream: bloc.stateStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<BlocState<dynamic>> snapshot) {
                        color = _getColorFromSnapshot(snapshot);
                        return MaterialButton(
                          color: color,
                          child: const Text('color'),
                          onPressed: () {
                            _showColorPicker(context).then((ColorChoose value) {
                              color = value.chosenColor ?? color;
                              _sendColorChangedToBloc(color);
                            });
                          },
                        );
                      }),
                  const Spacer(),
                  MaterialButton(
                    color: cancelButtonColor,
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
        colors: colorPalette,
        function: changeColor,
      ),
    );
  }

  Color _getColorFromSnapshot(AsyncSnapshot<BlocState<dynamic>> snapshot) {
    if (snapshot.hasData) {
      print(snapshot.data);
      if (snapshot.data is ColorChangedState<int>) {
        final ColorChangedState<int> colorChange =
            snapshot.data as ColorChangedState<int>;
        return Color(colorChange.data);
      }
    }
    return color;
  }

  void _closeDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop(this);
  }

  void _sendEventToBloc(BlocEvent event) {
    bloc.eventSink.add(event);
  }

  void _sendColorChangedToBloc(Color color) {
    _sendEventToBloc(ColorChangedEvent(color.value));
  }

  String get getTask => task;

  String get getDescription => description;

  Color get colors => color;

  set setTask(String val) => task = val;

  set setDescription(String val) => description = val;
}