import 'package:ToDo/blocs/home_page.dart';
import 'package:ToDo/blocs/settings_widget.dart' show SettingsWidgetBloc;
import 'package:ToDo/blocs/task_dialog.dart';
import 'package:ToDo/domain/setting/setting.dart';
import 'package:ToDo/domain/task/task.dart';
import 'package:ToDo/view/widgets/settings_widget.dart';
import 'package:ToDo/view/widgets/task_dialog.dart';
import 'package:ToDo/view/widgets/task_widget.dart';
import 'package:ToDo/blocs/events.dart';
import 'package:ToDo/blocs/states.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final HomePageBloc bloc;
  final List<TaskWidget> _widgets = <SimpleTaskWidget>[];
  final TaskDialogBloc _taskBloc = TaskDialogBloc();
  Color _chosenColor = Colors.cyan;
  Color _defaultTextColor = Colors.black;
  Color _defaultDescriptionColor = Colors.grey;

  HomePage({@required this.bloc, Key key}) : super(key: key) {
    bloc.eventSink.add(HomePageInitializedEvent());
    bloc.stateStream.first.then((BlocState<dynamic> value) {
      print(value.runtimeType);

      if(value is HomePageInitializedState<List<Task>>) {
        final HomePageInitializedState<List<Task>> state = value;

        _sendEventToBloc(SettingsBuildEvent());
        final List<Task> tasks = state.data;
        tasks.forEach((Task element) {
          print(element);
          _widgets.add(
            SimpleTaskWidget(
              bloc: bloc,
              mainColor: Color(element.color),
              task: element,
              onDismissed: _deleteTaskWidget,
              taskColor: _defaultTextColor,
              descriptionColor: _defaultDescriptionColor,
              dialog: TaskDialog(
                onSaveButton: _sendTaskToBloc,
                dialogText: 'Create new task',
                bloc: TaskDialogBloc(),
              ),
            ),
          );
        });
      }
    });
  }

  void _deleteTaskWidget(TaskWidget widget) {
    _widgets.remove(widget);
  }

  void _sendEventToBloc(BlocEvent event) {
    bloc.eventSink.add(event);
  }

  void _sendTaskToBloc(Task task) {
    _sendEventToBloc(AddTaskButtonPressedEvent(task: task));
  }

  void _sendEditedTaskToBloc(Task task) {
    _sendEventToBloc(AddTaskButtonPressedEvent(task: task));
  }

  void _handleState(AsyncSnapshot<BlocState<dynamic>> snapshot) {
    if (snapshot.hasData) {
      if (snapshot.data is TaskWidgetCreatedState<Task>) {
        final BlocState<Task> _state =
            snapshot.data as TaskWidgetCreatedState<Task>;
        final Task _task = _state.stateData;
        _widgets.add(SimpleTaskWidget(
            onDismissed: _deleteTaskWidget,
            bloc: bloc,
            mainColor: Color(_state.stateData.color),
            task: _task,
            taskColor: _defaultTextColor,
            descriptionColor: _defaultDescriptionColor,
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
        _defaultTextColor = Color(int.parse(map['task_color']));
        _defaultDescriptionColor = Color(int.parse(map['description_color']));
        final List<TaskWidget> _replacement = <SimpleTaskWidget>[];
        _widgets.forEach((TaskWidget element) {
          _replacement.add(SimpleTaskWidget(
              onDismissed: _deleteTaskWidget,
              bloc: bloc,
              mainColor: Color(element.getTask().color),
              task: element.getTask(),
              taskColor: _defaultTextColor,
              descriptionColor: _defaultDescriptionColor,
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
      endDrawer: SettingsDrawer(const <Color>[
        Colors.black,
        Colors.grey,
        Colors.white,
        Colors.brown,
        Colors.white10,
        Colors.black38,
      ],
      _deleteAllTasks,
      _changeTheme,
      SettingsWidgetBloc()),
      appBar: AppBar(
        title: const Text('Task\'s'),
      ),
      body: StreamBuilder<BlocState<dynamic>>(
          stream: bloc.stateStream,
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

  void _changeTheme(BuildContext context) {
    final Brightness _currentBrightness=DynamicTheme.of(context).brightness;
    DynamicTheme.of(context).setBrightness(
        _currentBrightness==Brightness.light
            ?Brightness.dark:Brightness.light);
  }

  void _deleteAllTasks() {
    final List<TaskWidget> _toRemove = _widgets;
    _sendEventToBloc(AllTaskDeletedEvent());
    _widgets.removeWhere((TaskWidget element) => _toRemove.contains(element));
  }
}