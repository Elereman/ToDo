import 'package:ToDo/blocs/states.dart' as states;
import 'package:ToDo/blocs/events.dart';
import 'package:ToDo/blocs/home_page_bloc.dart';
import 'package:ToDo/models/task.dart';
import 'package:ToDo/view/widgets/task_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

abstract class TaskWidget extends StatelessWidget {}

class SimpleTaskWidget extends TaskWidget {
  Color color;
  final HomePageBloc bloc;
  final TaskDialog dialog;
  final Task task;

  String taskText, description = '';
  bool _checkboxValue = false;

  SimpleTaskWidget(
      {@required this.color,
      @required this.bloc,
      @required this.dialog,
      @required this.task}) {
    taskText = task.task;
    description = task.description;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: StreamBuilder<states.State>(
          stream: bloc.stateStream,
          builder: (context, snapshot) {
            return Container(
              color: color,
              width: double.infinity,
              child: FlatButton(
                onPressed: () {
                  _sendEventToBloc(TaskPressedEvent());
                  _checkboxValue = !_checkboxValue;
                },
                onLongPress: () {
                  dialog.color = color;
                  dialog.task = taskText;
                  dialog.description = description;
                  showDialog(context: context, child: dialog).then((value) {
                    TaskDialog dialog = value as TaskDialog;
                    taskText = dialog.getTask;
                    description = dialog.getDescription;
                    color = dialog.color;
                    _sendEventToBloc(TaskLongPressedEvent(
                      taskO: Task(task.id, taskText, description, color.value),
                    ));
                  });
                },
                child: Row(
                  children: [
                    Spacer(
                      flex: 1,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          taskText,
                        ),
                        Wrap(
                          children: [
                            Text(
                              description,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Spacer(
                      flex: 27,
                    ),
                    Checkbox(
                      value: _checkboxValue,
                      onChanged: null,
                    ),
                  ],
                ),
              ),
            );
          }
        ),
      ),
    );
  }

  bool getBoolFromSnapshot(AsyncSnapshot snapshot) {
    print(snapshot.data.runtimeType);
    if (snapshot.hasData) {
      states.State _state = snapshot.data;
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

  void _sendEventToBloc(Event event) {
    bloc.eventSink.add(event);
  }
}
