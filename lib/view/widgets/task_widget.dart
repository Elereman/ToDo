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
  final Function(TaskWidget) onDissmised;

  String taskText, description = '';
  bool _checkboxValue = false;

  SimpleTaskWidget(
      {@required this.color,
      @required this.bloc,
      @required this.dialog,
      @required this.task,
      @required this.onDissmised}) {
    taskText = task.task;
    description = task.description;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: StreamBuilder<states.State<dynamic>>(
          stream: bloc.stateStream,
          builder: (BuildContext context,
              AsyncSnapshot<states.State<dynamic>> snapshot) {
            return Dismissible(
              key: UniqueKey(),
              onDismissed: (DismissDirection direction) {
                _sendEventToBloc(TaskDeletedEvent(task: task));
                onDissmised(this);
                },
              child: Container(
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
                    showDialog<TaskDialog>(context: context, child: dialog).then((TaskDialog value) {
                      taskText = value.getTask;
                      description = value.getDescription;
                      color = value.color;
                      _sendEventToBloc(TaskLongPressedEvent(
                        taskO: Task(taskText, description, color.value,
                            isCompleted: _checkboxValue,
                            id: task.TaskID),
                      ));
                    });
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
                            taskText,
                          ),
                          Wrap(
                            children: <Widget>[
                              Text(
                                description,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(
                        flex: 27,
                      ),
                      Checkbox(
                        value: _checkboxValue,
                        onChanged: null,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }

  bool getBoolFromSnapshot(AsyncSnapshot<states.State<dynamic>> snapshot) {
    print(snapshot.data.runtimeType);
    if (snapshot.hasData) {
      final states.State<dynamic> _state = snapshot.data;
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
