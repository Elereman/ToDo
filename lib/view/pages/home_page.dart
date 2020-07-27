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
  List<Widget> widgets = [];

  HomePage({Key key, @required this.hbloc}) : super(key: key) {
    hbloc.eventSink.add(bloc.HomePageInitializedEvent());
    print('sdadasdasdasdadasdasdasd');
    hbloc.stateStream.first.then((value) {
      print(value.runtimeType);

      bloc.HomePageInitializedState state =
          value as bloc.HomePageInitializedState;

      Future<List<Task>> tasks = state.data as Future<List<Task>>;
      tasks.then((value) {
        value.forEach((element) {
          print(element);
          widgets.add(
            SimpleTaskWidget(
              bloc: hbloc,
              color: Color(element.color),
              task: element,
              dialog: TaskDialog(
                onSaveButton: null,
                dialogText: 'Create new task',
                bloc: TaskDialogBloc(),
              ),
            ),
          );
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Build called');
    TaskDialogBloc _taskBloc = TaskDialogBloc();
    Color _chosenColor = Colors.cyan;

    void _sendEventToBloc(Event event) {
      hbloc.eventSink.add(event);
    }

    void _sendTaskToBloc(String task, description, int colorHex) {
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

    void addWidgetFromSnapshot(AsyncSnapshot snapshot) {
      print(snapshot.data.runtimeType);
      if (snapshot.hasData) {
        if (snapshot.data is states.TaskWidgetCreatedState<Task>) {
          states.State _state =
              snapshot.data as states.TaskWidgetCreatedState<Task>;
          Task _task = _state.stateData as Task;
          widgets.add(SimpleTaskWidget(
            bloc: hbloc,
            color: _chosenColor,
            task: _task,
            dialog: TaskDialog(
              onSaveButton: _sendTaskToBloc,
              dialogText: 'Edit task',
              bloc: _taskBloc,
            ),
          ));
        }
      }
    }


    return Scaffold(
      appBar: AppBar(
        title: Text('Task\'s'),
      ),
      body: StreamBuilder<states.State>(
          stream: hbloc.stateStream,
          builder: (context, snapshot) {
            addWidgetFromSnapshot(snapshot);
            return SingleChildScrollView(
              child: Column(
                children: widgets,
              ),
            );
          }),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          TaskDialog _taskDialog = TaskDialog(
            onSaveButton: _sendTaskToBloc,
            dialogText: 'Create new task',
            bloc: _taskBloc,
          );
          showDialog(context: context, child: _taskDialog).then((value) {
            if (value != null) {
              TaskDialog dialog = value as TaskDialog;
              _chosenColor = dialog.color;
              print(dialog.color);
            }
          });
        },
        tooltip: 'Create new task',
        elevation: 5,
      ),
    );
  }
}