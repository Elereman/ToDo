import 'file:///D:/ToDo/lib/domain/entities/setting.dart';
import 'file:///D:/ToDo/lib/domain/entities/task.dart';
import 'package:ToDo/presentation/blocs/events.dart';
import 'package:ToDo/presentation/blocs/home_page.dart';
import 'package:ToDo/presentation/blocs/settings_drawer.dart';
import 'package:ToDo/presentation/blocs/states.dart';
import 'package:ToDo/presentation/blocs/task_dialog.dart';
import 'package:ToDo/presentation/flutter/view/widgets/settings_drawer.dart';
import 'package:ToDo/presentation/flutter/view/widgets/task.dart';
import 'package:ToDo/presentation/flutter/view/widgets/task_dialog.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final HomePageBloc bloc;
  final List<TaskWidget> _widgets = <TaskWidget>[];
  final TaskDialogBloc _taskBloc = TaskDialogBloc();
  final SettingsDrawerBloc settingsBloc;
  final Color _defaultTextColor = Colors.black;
  final Color _defaultDescriptionColor = Colors.grey;

  HomePage({@required this.bloc, @required this.settingsBloc, Key key})
      : super(key: key) {
    bloc.eventSink.add(HomePageInitializedEvent());
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

  void _handleState(
      AsyncSnapshot<BlocState<dynamic>> snapshot, BuildContext context) {
    if (snapshot.hasData) {
      if (snapshot.data is TaskWidgetCreatedState<Task>) {
        final BlocState<Task> _state =
            snapshot.data as TaskWidgetCreatedState<Task>;
        final Task _stateTask = _state.stateData;
        final Task _widgetTask = Task(
          task: _stateTask.task,
          taskDescription: _stateTask.description,
          color: _stateTask.color,
          isCompleted: _stateTask.isCompleted,
          id: _widgets.length,
        );
        _widgets.add(TaskWidget(
          onDismissed: _deleteTaskWidget,
          bloc: bloc,
          mainColor: Color(_state.stateData.color),
          task: _widgetTask,
          taskColor: Theme.of(context).textTheme.headline1.color,
          descriptionColor: Theme.of(context).textTheme.subtitle1.color,
          dialog: TaskDialog(
            onSaveButton: _sendTaskToBloc,
            dialogText: 'Edit task',
            bloc: _taskBloc,
          ),
          onPress: () => print(''),
          onLongPress: () => print(''),
        ));
      } else if (snapshot.data is TaskDeletedState<Task>) {
        final List<TaskWidget> _toRemove = <TaskWidget>[];
        final BlocState<Task> _state = snapshot.data as TaskDeletedState<Task>;
        _widgets.forEach((TaskWidget element) {
          if (element.getTask() == _state.stateData) {
            _toRemove.add(element);
          }
        });
        _widgets
            .removeWhere((TaskWidget element) => _toRemove.contains(element));
      } else if (snapshot.data is SettingsChangedState<List<Setting<String>>>) {
        final SettingsChangedState<List<Setting<String>>> _state =
            snapshot.data as SettingsChangedState<List<Setting<String>>>;
        final Map<String, String> map = _listSettingsToMap(_state.stateData);
        Theme.of(context).textTheme.copyWith(
          headline1: TextStyle(color: Color(int.parse(map['task_color']))),
          subtitle1: TextStyle(color: Color(int.parse(map['description_color']))),
        );
        final List<TaskWidget> _replacement = <TaskWidget>[];
        _widgets.forEach((TaskWidget element) {
          _replacement.add(TaskWidget(
            onDismissed: _deleteTaskWidget,
            bloc: bloc,
            mainColor: Color(element.getTask().color),
            task: element.getTask(),
            taskColor: Theme.of(context).textTheme.headline1.color,
            descriptionColor: Theme.of(context).textTheme.subtitle1.color,
            dialog: TaskDialog(
              onSaveButton: _sendTaskToBloc,
              dialogText: 'Edit task',
              bloc: _taskBloc,
            ),
            onLongPress: () => print('lp'),
            onPress: () => print('p'),
          ));
        });
        print('_widgets replace');
        _widgets.replaceRange(0, _widgets.length, _replacement);
      } else if(snapshot.data is HomePageInitializedState<List<Task>>) {
        final HomePageInitializedState<List<Task>> state = snapshot.data as
        HomePageInitializedState<List<Task>>;

        _sendEventToBloc(SettingsBuildEvent());
        final List<Task> tasks = state.stateData;
        tasks.forEach((Task element) {
          print(element);
          _widgets.add(
            TaskWidget(
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
              onPress: () => print(''),
              onLongPress: () => print(''),
            ),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: SettingsDrawer(
        colorPalette: const <Color>[
          Colors.black,
          Colors.grey,
          Colors.white,
          Colors.brown,
          Colors.white10,
          Colors.black38,
        ],
        onDeleteAllButton: _deleteAllTasks,
        onThemeSwitch: _changeTheme,
        bloc: settingsBloc,
      ),
      appBar: AppBar(
        title: const Text('Task\'s'),
      ),
      body: StreamBuilder<BlocState<dynamic>>(
          stream: bloc.stateStream,
          builder: (BuildContext context,
              AsyncSnapshot<BlocState<dynamic>> snapshot) {
            _handleState(snapshot, context);
            print('rebuild called');
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
              //_chosenColor = value.color;
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
    final Brightness _currentBrightness = DynamicTheme.of(context).brightness;
    DynamicTheme.of(context).setBrightness(
        _currentBrightness == Brightness.light
            ? Brightness.dark
            : Brightness.light);
  }

  void _deleteAllTasks() {
    final List<TaskWidget> _toRemove = _widgets;
    _sendEventToBloc(AllTaskDeletedEvent());
    _widgets.removeWhere((TaskWidget element) => _toRemove.contains(element));
  }
}