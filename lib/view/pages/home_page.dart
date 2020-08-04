import 'package:ToDo/blocs/home_page_bloc.dart' as bloc;
import 'package:ToDo/blocs/task_dialog_bloc.dart';
import 'package:ToDo/models/task.dart';
import 'package:ToDo/view/widgets/color_chose.dart';
import 'package:ToDo/view/widgets/settings_widget.dart';
import 'package:ToDo/view/widgets/task_dialog.dart';
import 'package:ToDo/view/widgets/task_widget.dart';
import 'package:ToDo/blocs/events.dart';
import 'package:ToDo/blocs/states.dart' as states;
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final bloc.HomePageBloc hbloc;
  final List<TaskWidget> _widgets = <SimpleTaskWidget>[];
  final TaskDialogBloc _taskBloc = TaskDialogBloc();
  Color _chosenColor = Colors.cyan;

  HomePage({@required this.hbloc, Key key}) : super(key: key) {
    hbloc.eventSink.add(bloc.HomePageInitializedEvent());
    hbloc.stateStream.first.then((states.State<dynamic> value) {
      print(value.runtimeType);

      final bloc.HomePageInitializedState<List<Task>> state =
          value as bloc.HomePageInitializedState<List<Task>>;

      final List<Task> tasks = state.data;
      tasks.forEach((Task element) {
        print(element);
        _widgets.add(
          SimpleTaskWidget(
            bloc: hbloc,
            mainColor: Color(element.color),
            task: element,
            onDismissed: _deleteTaskWidget,
            checkboxValue: element.isComplete,
            dialog: TaskDialog(
              onSaveButton: _sendTaskToBloc,
              dialogText: 'Create new task',
              bloc: TaskDialogBloc(),
            ),
          ),
        );
      });
    });
  }

  void _deleteTaskWidget(TaskWidget widget) {
    _widgets.remove(widget);
  }

  void _sendEventToBloc(Event event) {
    hbloc.eventSink.add(event);
  }

  void _sendTaskToBloc(String task, String description, int colorHex) {
    _sendEventToBloc(bloc.AddTaskButtonPressedEvent.fromStrings(
      task: task,
      description: description,
      colorHex: colorHex,
    ));
  }

  void _sendEditedTaskToBloc(String task, String description, int colorHex) {
    _sendEventToBloc(bloc.AddTaskButtonPressedEvent.fromStrings(
      task: task,
      description: description,
      colorHex: colorHex,
    ));
  }

  void _handleState(AsyncSnapshot<states.State<dynamic>> snapshot) {
    if (snapshot.hasData) {
      if (snapshot.data is states.TaskWidgetCreatedState<Task>) {
        final states.State<Task> _state =
            snapshot.data as states.TaskWidgetCreatedState<Task>;
        final Task _task = _state.stateData;
        _widgets.add(SimpleTaskWidget(
            onDismissed: _deleteTaskWidget,
            bloc: hbloc,
            mainColor: _chosenColor,
            task: _task,
            dialog: TaskDialog(
              onSaveButton: _sendTaskToBloc,
              dialogText: 'Edit task',
              bloc: _taskBloc,
            )));
      } else if (snapshot.data is bloc.TaskDeletedState<Task>) {
        final List<TaskWidget> _toRemove = <TaskWidget>[];
        final states.State<Task> _state =
        snapshot.data as bloc.TaskDeletedState<Task>;
        _widgets.forEach((TaskWidget element) {
          if(element.getTask() == _state.stateData) {
            _toRemove.add(element);
          }
        });
        _widgets.removeWhere((TaskWidget element) => _toRemove.contains(element));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: SettingsDrawer(<Color>[
        Colors.black,
      ], _deleteAllTasks),
      appBar: AppBar(
        title: const Text('Task\'s'),
      ),
      body: StreamBuilder<states.State<dynamic>>(
          stream: hbloc.stateStream,
          builder: (BuildContext context,
              AsyncSnapshot<states.State<dynamic>> snapshot) {
            _handleState(snapshot);
            return SingleChildScrollView(
              child: Column(
                children: _widgets,
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          final TaskDialog _taskDialog = TaskDialog(
            onSaveButton: _sendTaskToBloc,
            dialogText: 'Create new task',
            bloc: _taskBloc,
          );
          showDialog<TaskDialog>(context: context, child: _taskDialog)
              .then((TaskDialog value) {
            if (value != null) {
              _chosenColor = value.color;
              print(value.color);
            }
          });
        },
        tooltip: 'Create new task',
        elevation: 5,
      ),
    );
  }

  void _deleteAllTasks() {
    final List<TaskWidget> _toRemove = _widgets;
    _widgets.forEach((TaskWidget element) =>
        _sendEventToBloc(bloc.TaskDeletedEvent(task: element.getTask())));
    _widgets.removeWhere((TaskWidget element) => _toRemove.contains(element));
  }
}
