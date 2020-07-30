import 'package:ToDo/blocs/home_page_bloc.dart' as bloc;
import 'package:ToDo/blocs/task_dialog_bloc.dart';
import 'package:ToDo/models/task.dart';
import 'package:ToDo/view/widgets/task_dialog.dart';
import 'package:ToDo/view/widgets/task_widget.dart';
import 'package:ToDo/blocs/events.dart';
import 'package:ToDo/blocs/states.dart' as states;
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final bloc.HomePageBloc hbloc;
  final List<Widget> _widgets = <SimpleTaskWidget>[];
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
            color: Color(element.color),
            task: element,
            onDissmised: _deleteTaskWidget,
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

  void _deleteTaskWidget(Widget widget) {
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

  void _addWidgetFromSnapshot(AsyncSnapshot<states.State<dynamic>> snapshot) {
    print(snapshot.data.runtimeType);
    if (snapshot.hasData) {
      if (snapshot.data is states.TaskWidgetCreatedState<Task>) {
        final states.State<Task> _state =
            snapshot.data as states.TaskWidgetCreatedState<Task>;
        final Task _task = _state.stateData;
        _widgets.add(SimpleTaskWidget(
          onDissmised: _deleteTaskWidget,
          bloc: hbloc,
          color: _chosenColor,
          task: _task,
          dialog: TaskDialog(
            onSaveButton: _sendTaskToBloc,
            dialogText: 'Edit task',
            bloc: _taskBloc,
          )
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task\'s'),
      ),
      body: StreamBuilder<states.State<dynamic>>(
          stream: hbloc.stateStream,
          builder: (BuildContext context,
              AsyncSnapshot<states.State<dynamic>> snapshot) {
            _addWidgetFromSnapshot(snapshot);
            return SingleChildScrollView(
              child: Column(
                children: _widgets,
              ),
            );
          }),
      backgroundColor: Colors.white,
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
}
