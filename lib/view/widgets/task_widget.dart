import 'package:ToDo/blocs/states.dart';
import 'package:ToDo/blocs/events.dart';
import 'package:ToDo/blocs/home_page_bloc.dart';
import 'package:ToDo/models/task.dart';
import 'package:ToDo/view/widgets/task_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

abstract class TaskWidget extends StatelessWidget {
  Task getTask();

  void dismiss();
}

class SimpleTaskWidget extends TaskWidget {
  Color mainColor, taskColor, descriptionColor;
  final HomePageBloc bloc;
  final TaskDialog dialog;
  final Task task;
  final Function(TaskWidget) onDismissed;

  String taskText, description = '';
  bool checkboxValue = false;

  SimpleTaskWidget(
      {@required this.mainColor,
      @required this.bloc,
      @required this.dialog,
      @required this.task,
      @required this.onDismissed,
      this.taskColor = Colors.black,
      this.descriptionColor = Colors.grey,
      this.checkboxValue = false}) {
    taskText = task.task;
    description = task.description;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: StreamBuilder<BlocState<dynamic>>(
            stream: bloc.stateStream,
            builder: (BuildContext context,
                AsyncSnapshot<BlocState<dynamic>> snapshot) {
              return Dismissible(
                key: UniqueKey(),
                onDismissed: (DismissDirection direction) {
                  _sendEventToBloc(TaskDeletedEvent(task: task));
                  onDismissed(this);
                },
                child: Container(
                  color: mainColor,
                  width: double.infinity,
                  child: FlatButton(
                    onPressed: () {
                      _sendEventToBloc(TaskPressedEvent(
                        taskO: Task(task.task, task.description, task.color,
                            isCompleted: !task.isComplete, id: task.id),
                      ));
                      checkboxValue = !checkboxValue;
                    },
                    onLongPress: () {
                      dialog.color = mainColor;
                      dialog.task = taskText;
                      dialog.description = description;
                      showDialog<TaskDialog>(context: context, child: dialog)
                          .then((TaskDialog value) {
                        if (value != null) {
                          taskText = value.getTask;
                          description = value.getDescription;
                          mainColor = value.color;
                          _sendEventToBloc(TaskLongPressedEvent(
                            taskO: Task(taskText, description, mainColor.value,
                                isCompleted: checkboxValue, id: task.TaskID),
                          ));
                        }
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
                              style: TextStyle(color: taskColor),
                            ),
                            Wrap(
                              children: <Widget>[
                                Text(
                                  description,
                                  style: TextStyle(color: descriptionColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(
                          flex: 27,
                        ),
                        Checkbox(
                          value: checkboxValue,
                          onChanged: (bool status) =>
                              _sendEventToBloc(TaskPressedEvent(taskO: task)),
                        ),
                      ],
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
    bloc.eventSink.add(event);
  }

  @override
  Task getTask() => task;

  @override
  void dismiss() {
    _sendEventToBloc(TaskDeletedEvent(task: task));
    onDismissed(this);
  }
}
