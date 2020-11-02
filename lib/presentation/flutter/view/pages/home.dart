import 'package:ToDo/domain/entities/task.dart';
import 'package:ToDo/presentation/blocs/home_page/bloc.dart';
import 'package:ToDo/presentation/blocs/home_page/state.dart';
import 'package:ToDo/presentation/blocs/settings_drawer/bloc.dart';
import 'package:ToDo/presentation/flutter/view/widgets/settings_drawer.dart';
import 'package:ToDo/presentation/flutter/view/widgets/task.dart';
import 'package:ToDo/presentation/flutter/view/widgets/task_dialog.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final HomePageBloc bloc;
  final SettingsDrawerBloc settingsBloc;
  final TaskDialog taskDialog;

  static const Color _defaultTextColor = Colors.black;
  static const Color _defaultDescriptionColor = Colors.grey;

  HomePage(
      {@required this.bloc,
      @required this.settingsBloc,
      Key key,
      this.taskDialog})
      : super(key: key) {
    bloc.createInitialState();
  }

  List<Widget> _getWidgetsFromState(
      AsyncSnapshot<HomePageState> state, BuildContext context) {
    if (state.hasData) {
      final List<Widget> _taskWidgets = <Widget>[];
      state.data.tasks.forEach((Task _task) {
        _taskWidgets.add(TaskWidget(
          mainColor: Color(_task.color),
          task: _task,
          onDismissed: (Task task) => bloc.deleteTask(task),
          onPress: (Task task) => bloc.updateTask(task),
          onLongPress: (Task task) => bloc.updateTask(task),
          taskColor:
              Color(int.parse(state.data.settings['task_color'].setting)),
          descriptionColor: Color(
              int.parse(state.data.settings['description_color'].setting)),
        ));
      });
      return _taskWidgets;
    } else {
      return <Widget>[
        Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height / 2.5),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        )
      ];
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
        onDeleteAllButton: bloc.deleteAllTasks,
        onThemeSwitch: _changeTheme,
        bloc: settingsBloc,
      ),
      appBar: AppBar(
        title: const Text('Task\'s'),
      ),
      body: StreamBuilder<HomePageState>(
          stream: bloc.stateSubject.stream,
          builder: (BuildContext context, AsyncSnapshot<HomePageState> _state) {
            //_handleState(_state, context);
            return SingleChildScrollView(
              child: Column(
                children: _getWidgetsFromState(_state, context),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          final TaskDialog _taskDialog = TaskDialog(
            dialogText: 'Create new task',
          );
          showDialog<Task>(context: context, child: _taskDialog)
              .then((Task task) {
            if (task != null) {
              bloc.createTask(task);
            }
          });
        },
        tooltip: 'Create new task',
        elevation: 5,
      ),
    );
  }

  void _changeTheme(BuildContext context) {
    final Brightness _currentBrightness = DynamicTheme.of(context).brightness;
    DynamicTheme.of(context).setBrightness(
        _currentBrightness == Brightness.light
            ? Brightness.dark
            : Brightness.light);
  }
}
