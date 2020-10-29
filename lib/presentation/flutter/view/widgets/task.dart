import 'package:ToDo/domain/entities/task.dart';
import 'package:ToDo/presentation/flutter/view/widgets/task_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class TaskWidget extends StatelessWidget {
  final Color _mainColor, _taskColor, _descriptionColor;
  final Task _task;
  final Function(Task) _onDismissed;
  final Function(Task) _onPress, _onLongPress;
  final String _taskText, _description;
  final bool _isCompleted;

  TaskWidget({
    @required Color mainColor,
    @required Task task,
    @required Function(Task) onDismissed,
    @required Function(Task) onPress,
    @required Function(Task) onLongPress,
    Color taskColor = Colors.black,
    Color descriptionColor = Colors.grey,
  })  : _mainColor = mainColor,
        _taskColor = taskColor,
        _descriptionColor = descriptionColor,
        _task = task,
        _onDismissed = onDismissed,
        _onPress = onPress,
        _onLongPress = onLongPress,
        _taskText = task.task,
        _description = task.description,
        _isCompleted = task.isCompleted,
        super(
            key: ValueKey<int>(task.hashCode +
                taskColor.hashCode +
                descriptionColor.hashCode +
                onPress.hashCode +
                onLongPress.hashCode));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Dismissible(
          key: UniqueKey(),
          onDismissed: (DismissDirection direction) {
            _onDismissed(_task);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              color: _mainColor,
              width: double.infinity,
              child: FlatButton(
                onPressed: () {
                  _onPress(_changeTaskCompletedState(_task));
                },
                onLongPress: () {
                  final TaskDialog _dialog = TaskDialog(
                    onSaveButton: (_) {},
                    dialogText: 'Edit task',
                    taskText: _task.task,
                    descriptionText: _task.description,
                  );
                  showDialog<TaskDialog>(context: context, child: _dialog)
                      .then((TaskDialog _dialog) {
                    if (_dialog != null) {
                      final Task _newTask = Task(
                        task: _taskText,
                        taskDescription: _description,
                        //color: _dialog.color.value,
                        isCompleted: _isCompleted,
                        id: _task.id,
                      );
                      _onLongPress(_newTask);
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
                        onChanged: (_) {
                          _onPress(_changeTaskCompletedState(_task));
                        }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Task _changeTaskCompletedState(Task task) => Task(
      task: task.task,
      taskDescription: task.description,
      color: task.color,
      isCompleted: !task.isCompleted,
      id: task.id);
}