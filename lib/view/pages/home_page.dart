import 'package:ToDo/blocs/home_page_bloc.dart';
import 'package:ToDo/blocs/task_dialog_bloc.dart';
import 'package:ToDo/models/setting.dart';
import 'package:ToDo/models/task.dart';
import 'package:ToDo/view/widgets/settings_widget.dart';
import 'package:ToDo/view/widgets/task_dialog.dart';
import 'package:ToDo/view/widgets/task_widget.dart';
import 'package:ToDo/blocs/events.dart';
import 'package:ToDo/blocs/states.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final HomePageBloc hbloc;
  final List<TaskWidget> _widgets = <SimpleTaskWidget>[];
  final TaskDialogBloc _taskBloc = TaskDialogBloc();
  Color _chosenColor = Colors.indigo;
  Color _textColor = Colors.black;
  Color _descriptionColor = Colors.grey;

  HomePage({@required this.hbloc, Key key}) : super(key: key) {
    hbloc.eventSink.add(HomePageInitializedEvent());
    hbloc.stateStream.first.then((BlocState<dynamic> value) {
      print(value.runtimeType);

      final HomePageInitializedState<List<Task>> state =
          value as HomePageInitializedState<List<Task>>;

      _sendEventToBloc(SettingsBuildEvent());
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
            taskColor: _textColor,
            descriptionColor: _descriptionColor,
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

  void _sendEventToBloc(BlocEvent event) {
    hbloc.eventSink.add(event);
  }

  void _sendTaskToBloc(String task, String description, int colorHex) {
    _sendEventToBloc(AddTaskButtonPressedEvent.fromStrings(
      task: task,
      description: description,
      colorHex: colorHex,
    ));
  }

  void _sendEditedTaskToBloc(String task, String description, int colorHex) {
    _sendEventToBloc(AddTaskButtonPressedEvent.fromStrings(
      task: task,
      description: description,
      colorHex: colorHex,
    ));
  }

  void _handleState(AsyncSnapshot<BlocState<dynamic>> snapshot) {
    if (snapshot.hasData) {
      if (snapshot.data is TaskWidgetCreatedState<Task>) {
        final BlocState<Task> _state =
            snapshot.data as TaskWidgetCreatedState<Task>;
        final Task _task = _state.stateData;
        _widgets.add(SimpleTaskWidget(
            onDismissed: _deleteTaskWidget,
            bloc: hbloc,
            mainColor: _chosenColor,
            task: _task,
            taskColor: _textColor,
            descriptionColor: _descriptionColor,
            dialog: TaskDialog(
              onSaveButton: _sendTaskToBloc,
              dialogText: 'Edit task',
              bloc: _taskBloc,
            )));
      } else if (snapshot.data is TaskDeletedState<Task>) {
        final List<TaskWidget> _toRemove = <TaskWidget>[];
        final BlocState<Task> _state =
        snapshot.data as TaskDeletedState<Task>;
        _widgets.forEach((TaskWidget element) {
          if(element.getTask() == _state.stateData) {
            _toRemove.add(element);
          }
        });
        _widgets.removeWhere((TaskWidget element) => _toRemove.contains(element));
      } else if (snapshot.data is SettingsChangedState<List<Setting<String>>>) {
        final SettingsChangedState<List<Setting<String>>> _state =
        snapshot.data as SettingsChangedState<List<Setting<String>>>;
        final Map<String, String> map =  _listSettingsToMap(_state.stateData);
        _textColor = Color(int.parse(map['task_color']));
        _descriptionColor = Color(int.parse(map['description_color']));
        final List<TaskWidget> _replacement = <SimpleTaskWidget>[];
        _widgets.forEach((TaskWidget element) {
          _replacement.add(SimpleTaskWidget(
              onDismissed: _deleteTaskWidget,
              bloc: hbloc,
              mainColor: _chosenColor,
              task: element.getTask(),
              taskColor: _textColor,
              descriptionColor: _descriptionColor,
              dialog: TaskDialog(
                onSaveButton: _sendTaskToBloc,
                dialogText: 'Edit task',
                bloc: _taskBloc,
              )));
        });
        _widgets.replaceRange(0, _widgets.length, _replacement);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: SettingsDrawer(<Color>[
        Colors.black,
        Colors.grey,
        Colors.white,
        Colors.brown,
        Colors.white10,
        Colors.black38,
      ], _deleteAllTasks,
      hbloc),
      appBar: AppBar(
        title: const Text('Task\'s'),
      ),
      body: StreamBuilder<BlocState<dynamic>>(
          stream: hbloc.stateStream,
          builder: (BuildContext context,
              AsyncSnapshot<BlocState<dynamic>> snapshot) {
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

  Map<String, String> _listSettingsToMap(List<Setting<String>> settings) {
    final Map<String, String> _result = <String, String>{};
    settings.forEach((Setting<String> element) {
      _result.putIfAbsent(element.key, () => element.setting);
    });
    return _result;
  }

  void _deleteAllTasks() {
    final List<TaskWidget> _toRemove = _widgets;
    _widgets.forEach((TaskWidget element) =>
        _sendEventToBloc(TaskDeletedEvent(task: element.getTask())));
    _widgets.removeWhere((TaskWidget element) => _toRemove.contains(element));
  }
}
