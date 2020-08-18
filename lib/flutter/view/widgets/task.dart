import 'package:ToDo/blocs/states.dart';
import 'package:ToDo/blocs/events.dart';
import 'package:ToDo/blocs/home_page.dart';
import 'package:ToDo/domain/task/task.dart';
import 'package:ToDo/flutter/view/widgets/task_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class TaskWidget extends StatefulWidget {
  final Color _mainColor, _taskColor, _descriptionColor;
  final HomePageBloc _bloc;
  final TaskDialog _dialog;
  final Task _task;
  final Function(TaskWidget) _onDismissed;
  final Function _onLongPress, _onPress;
  final String _taskText, _description;
  final bool _isCompleted;

  TaskWidget({
    @required Color mainColor,
    @required HomePageBloc bloc,
    @required TaskDialog dialog,
    @required Task task,
    @required Function(TaskWidget) onDismissed,
    @required Function() onPress,
    @required Function() onLongPress,
    Color taskColor = Colors.black,
    Color descriptionColor = Colors.grey,
  })  : _mainColor = mainColor,
        _taskColor = taskColor,
        _descriptionColor = descriptionColor,
        _bloc = bloc,
        _task = task,
        _onDismissed = onDismissed,
        _onLongPress = onLongPress,
        _onPress = onPress,
        _dialog = dialog,
        _taskText = task.task,
        _description = task.description,
        _isCompleted = task.isCompleted;

  @override
  _TaskWidgetState createState() => _TaskWidgetState(
      this,
      _mainColor,
      _taskColor,
      _descriptionColor,
      _bloc,
      _dialog,
      _task,
      _onDismissed,
      _onLongPress,
      _onPress,
      _taskText,
      _description,
      _isCompleted);

  Task getTask() => _task;
}

class _TaskWidgetState extends State<TaskWidget> {
  final TaskWidget _this;
  final HomePageBloc _bloc;
  final TaskDialog _dialog;
  final Task _task;
  final Function(TaskWidget) _onDismissed;
  final Function _onLongPress, _onPress;
  Color _mainColor, _taskColor, _descriptionColor;
  String _taskText, _description;
  bool _isCompleted;

  _TaskWidgetState(
      this._this,
      this._mainColor,
      this._taskColor,
      this._descriptionColor,
      this._bloc,
      this._dialog,
      this._task,
      this._onDismissed,
      this._onLongPress,
      this._onPress,
      this._taskText,
      this._description,
      this._isCompleted);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: StreamBuilder<BlocState<dynamic>>(
            stream: _bloc.stateStream,
            builder: (BuildContext context,
                AsyncSnapshot<BlocState<dynamic>> snapshot) {
              return Dismissible(
                key: UniqueKey(),
                onDismissed: (DismissDirection direction) {
                  _sendEventToBloc(TaskDeletedEvent(task: _task));
                  _onDismissed(_this);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                    color: _mainColor,
                    width: double.infinity,
                    child: FlatButton(
                      onPressed: () {
                        setState(() {
                          _isCompleted = !_isCompleted;
                        });
                        _sendEventToBloc(TaskPressedEvent(
                          task: Task(
                              task: _task.task,
                              taskDescription: _task.description,
                              color: _task.color,
                              isCompleted: !_task.isCompleted,
                              id: _task.id
                          ),
                        ));
                        _onPress();
                      },
                      onLongPress: () {
                        _dialog.color = _mainColor;
                        _dialog.setTask = _taskText;
                        _dialog.setDescription = _description;
                        showDialog<TaskDialog>(context: context, child: _dialog)
                            .then((TaskDialog value) {
                          if (value != null) {
                            setState(() {
                              _taskText = value.getTask;
                              _description = value.getDescription;
                              _mainColor = value.color;
                            });
                            _sendEventToBloc(TaskLongPressedEvent(
                              task: Task(
                                  task: _taskText,
                                  taskDescription: _description,
                                  color: value.color.value,
                                  isCompleted: _isCompleted,
                                  id: _task.id),
                            ));
                          }
                        });
                        _onLongPress();
                      },
                      child: Row(
                        children: <Widget>[
                          const Spacer(
                            flex: 1,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                _taskText,
                                style: TextStyle(color: _taskColor),
                              ),
                              Wrap(
                                children: <Widget>[
                                  Text(
                                    _description,
                                    style: TextStyle(color: _descriptionColor),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(
                            flex: 27,
                          ),
                          Checkbox(
                              value: _isCompleted,
                              onChanged: (bool status) {
                                _sendEventToBloc(TaskPressedEvent(task: _task));
                                setState(() {
                                  _isCompleted = !_isCompleted;
                                });
                                _onPress();
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  bool getBoolFromSnapshot(AsyncSnapshot<BlocState<dynamic>> snapshot) {
    print(snapshot.data.runtimeType);
    if (snapshot.hasData) {
      final BlocState<dynamic> _state = snapshot.data;
      switch (_state.runtimeType) {
        case PressedState:
          print('tps');
          break;

        case LongPressedState:
          print('tlps');
          break;
      }
    }
    return false;
  }

  void _sendEventToBloc(BlocEvent event) {
    _bloc.eventSink.add(event);
  }
}
