import 'package:ToDo/blocs/home_page_bloc.dart' as bloc;
import 'package:ToDo/models/task.dart';
import 'package:ToDo/view/widgets/task_dialog.dart';
import 'package:ToDo/view/widgets/task_widget.dart';
import 'package:ToDo/blocs/events.dart';
import 'package:ToDo/blocs/states.dart' as states;
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bloc.HomePageBloc _bloc = bloc.HomePageBloc();
    List<Widget> widgets = [];
    Color _chosenColor = Colors.cyan;

    void _sendEventToBloc(Event event) {
      _bloc.eventSink.add(event);
    }

    void _sendTaskToBloc(String task, description) {
      _sendEventToBloc(bloc.AddTaskButtonPressedEvent.fromStrings(
        task: task,
        description: description,
      ));
    }

    void _sendEditedTaskToBloc(String task, description) {
      _sendEventToBloc(bloc.AddTaskButtonPressedEvent.fromStrings(
        task: task,
        description: description,
      ));
    }

    void addWidgetFromSnapshot(AsyncSnapshot snapshot) {
      print(snapshot.data.runtimeType);
      if (snapshot.hasData) {
        if(snapshot.data is states.TaskWidgetCreatedState<Task>) {
          states.State _state =
          snapshot.data as states.TaskWidgetCreatedState<Task>;
          Task _task = _state.stateData as Task;
          widgets.add(SimpleTaskWidget(
            bloc: _bloc,
            color: _chosenColor,
            task: _task,
            dialog: TaskDialog(
              onSaveButton: _sendTaskToBloc,
              dialogText: 'Edit task',
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
          stream: _bloc.stateStream,
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
          );
          showDialog(context: context, child: _taskDialog).then((value) {
            TaskDialog dialog = value as TaskDialog;
            _chosenColor = dialog.color;
            print(dialog.color);
          });
        },
        tooltip: 'Create new task',
        elevation: 5,
      ),
    );
  }
}