import 'file:///D:/ToDo/lib/domain/entities/task.dart';
import 'package:ToDo/presentation/blocs/events.dart';
import 'package:ToDo/presentation/blocs/states.dart';
import 'package:ToDo/presentation/blocs/task_dialog.dart';
import 'package:flutter/material.dart';

import 'color_chose_dialog.dart';

class TaskDialog extends StatelessWidget {
  final Function(Task task) _onSaveButton;
  final String _dialogText;
  final TaskDialogBloc _bloc;

  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<Color> _colorPalette;
  final Color _saveButtonColor;
  final Color _cancelButtonColor;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _taskText, _descriptionText;
  Color _color;

  TaskDialog({
    @required Function(Task task) onSaveButton,
    @required String dialogText,
    @required TaskDialogBloc bloc,
    Key key,
    Color color = Colors.cyan,
    String taskText = '',
    String descriptionText = '',
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
  })  : _onSaveButton = onSaveButton,
        _dialogText = dialogText,
        _bloc = bloc,
        _taskText = taskText,
        _descriptionText = descriptionText,
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
                  onChanged: (String value) => _taskText = value,
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
                  onChanged: (String value) => _descriptionText = value,
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
                            task: _taskController.text,
                            taskDescription: _descriptionController.text,
                            color: _color.value,
                          ));
                          _closeDialog(context);
                        }
                      },
                    ),
                    const Spacer(),
                    StreamBuilder<BlocState<dynamic>>(
                        stream: _bloc.stateStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<BlocState<dynamic>> snapshot) {
                          _color = _getColorFromSnapshot(snapshot);
                          return MaterialButton(
                            color: _color,
                            child: const Text('color'),
                            onPressed: () {
                              _showColorPicker(context)
                                  .then((ColorChooseDialog value) {
                                _sendColorChangedToBloc(_color);
                              });
                            },
                          );
                        }),
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

  void changeColor(Color color) {
    print(color);
    _color = color;
  }

  Future<ColorChooseDialog> _showColorPicker(BuildContext context) async {
    return showDialog<ColorChooseDialog>(
      context: context,
      child: ColorChooseDialog(
        defaultColor: _color,
        label: 'Chose color',
        colorPalette: _colorPalette,
        onColorChosen: changeColor,
      ),
    );
  }

  Color _getColorFromSnapshot(AsyncSnapshot<BlocState<dynamic>> snapshot) {
    if (snapshot.hasData) {
      print(snapshot.data);
      if (snapshot.data is ColorChangedState<int>) {
        final ColorChangedState<int> colorChange =
            snapshot.data as ColorChangedState<int>;
        return Color(colorChange.stateData);
      }
    }
    return _color;
  }

  void _closeDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop(this);
  }

  void _sendEventToBloc(BlocEvent event) {
    _bloc.eventSink.add(event);
  }

  void _sendColorChangedToBloc(Color color) {
    _sendEventToBloc(ColorChangedEvent(color.value));
  }

  String get getTask => _taskText;

  String get getDescription => _descriptionText;

  Color get color => _color;

  set setTask(String val) => _taskText = val;

  set setDescription(String val) => _descriptionText = val;
}
