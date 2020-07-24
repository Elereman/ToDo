import 'package:ToDo/blocs/home_page_bloc.dart' as bloc;
import 'package:ToDo/view/widgets/task_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bloc.HomePageBloc _bloc = bloc.HomePageBloc();
    List widgets = [];

    Widget getWidgetFromSnapshot(AsyncSnapshot snapshot) {
      if (snapshot.hasData) {
        bloc.State _state =
            snapshot.data as bloc.TaskWidgetCreatedState<SimpleTaskWidget>;
        widgets.add(_state.stateData);
        return _state.stateData;
      } else {
        return Text('asdas');
      }
    }

    void _sendEventToBloc(bloc.Event event) {
      _bloc.eventSink.add(event);
    }

    void _sendTaskToBloc(String task, description) {
      _sendEventToBloc(bloc.AddTaskButtonPressedEvent.fromStrings(
        task: task,
        description: description,
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Task\'s'),
      ),
      body: StreamBuilder<bloc.State>(
          stream: _bloc.stateStream,
          builder: (context, snapshot) {
            getWidgetFromSnapshot(snapshot);
            return SingleChildScrollView(
              child: Column(
                children: [
                  ...widgets,
                ],
              ),
            );
          }),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          CreateTaskDialog _taskDialog = CreateTaskDialog(
              onSaveButton: _sendTaskToBloc,
              dialogText: 'Create new task',
          );
          showDialog(context: context, child: _taskDialog).then((value) {});
        },
        tooltip: 'Create new task',
        elevation: 5,
      ),
    );
  }
}

class CreateTaskDialog extends StatelessWidget {
  final Function(String task, String description) onSaveButton;
  final String dialogText;

  String _task = '', _description = '';

  CreateTaskDialog({Key key, @required this.onSaveButton, @required this.dialogText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 170,
        child: Column(
          children: [
            Text(dialogText),
            TextField(
              onChanged: (value) => _task = value,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter a task'
              ),
            ),
            TextField(
              onChanged: (value) => _description = value,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter a description'
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                  color: Colors.greenAccent,
                  child: Text('save'),
                  onPressed: () {
                     this?.onSaveButton(_task, _description);
                    _closeDialog(context);
                  },
                ),
                Spacer(),
                MaterialButton(
                  color: Colors.redAccent,
                  child: Text('cancel'),
                  onPressed: () => _closeDialog(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _closeDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop(this);
  }

  String get task => _task;

  String get description => _description;
}
