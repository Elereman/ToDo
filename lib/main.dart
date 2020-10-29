import 'package:ToDo/core/usecases/usecase_with_params.dart';
import 'package:ToDo/data/usecases/create_task_through_repository.dart';
import 'package:ToDo/domain/entities/task.dart';
import 'package:ToDo/domain/usecases/create_task.dart';
import 'package:ToDo/domain/usecases/delete_all_tasks.dart';
import 'package:ToDo/domain/usecases/delete_task.dart';
import 'package:ToDo/domain/usecases/get_all_tasks.dart';
import 'package:ToDo/domain/usecases/edit_task.dart';
import 'package:ToDo/presentation/blocs/home_page/bloc.dart';
import 'package:ToDo/presentation/blocs/settings_drawer.dart';
import 'package:ToDo/presentation/flutter/view/pages/home.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/tools/settings_provider.dart';
import 'core/usecases/usecase_without_params.dart';
import 'data/repository/file_system_task.dart';
import 'data/repository/shared_preferences_settings.dart';
import 'data/usecases/delete_all_tasks_through_repository.dart';
import 'data/usecases/delete_task_through_repository.dart';
import 'data/usecases/edit_task_through_repository.dart';
import 'data/usecases/get_all_tasks_through_repository.dart';
import 'domain/repositories/settings_repository.dart';
import 'domain/repositories/task_repository.dart';

void main() {
  runApp(ToDoApp());
}

class ToDoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <Provider<dynamic>>[
        Provider<TaskRepository>(create: (_) => FileSystemRepository()),
        Provider<SettingsRepository>(
            create: (_) => SharedPreferencesSettingsRepository()),
        Provider<SettingsProvider>(
          create: (BuildContext context) => SettingsProvider(
              Provider.of<SettingsRepository>(context, listen: false)),
        ),
        Provider<SettingsDrawerBloc>(
          create: (BuildContext context) => SettingsDrawerBloc(
              Provider.of<SettingsProvider>(context, listen: false)),
        ),
        Provider<DeleteAllTasksUseCase>(
          create: (BuildContext context) => DeleteAllTasksUseCaseThroughRepository(Provider.of<TaskRepository>(context, listen: false)),
        ),
        Provider<GetAllTasksUseCase>(
          create: (BuildContext context) => GetAllTasksUseCaseThroughRepository(Provider.of<TaskRepository>(context, listen: false)),
        ),
        Provider<EditTaskUseCase>(
          create: (BuildContext context) => EditTaskUseCaseThroughRepository(Provider.of<TaskRepository>(context, listen: false)),
        ),
        Provider<DeleteTaskUseCase>(
          create: (BuildContext context) => DeleteTaskUseCaseThroughRepository(Provider.of<TaskRepository>(context, listen: false)),
        ),
        Provider<CreateTaskUseCase>(
          create: (BuildContext context) => CreateTaskUseCaseThroughRepository(Provider.of<TaskRepository>(context, listen: false)),
        ),
        Provider<HomePageBloc>(
          create: (BuildContext context) => HomePageBloc(
            deleteAllTasksUseCase: Provider.of<DeleteAllTasksUseCase>(context, listen: false),
            getAllTasksUseCase: Provider.of<GetAllTasksUseCase>(context, listen: false),
            editTaskUseCase: Provider.of<EditTaskUseCase>(context, listen: false),
            deleteTaskUseCase: Provider.of<DeleteTaskUseCase>(context, listen: false),
            createTaskUseCase: Provider.of<CreateTaskUseCase>(context, listen: false),
            repository: Provider.of<TaskRepository>(context, listen: false),
            settingsProvider: Provider.of<SettingsProvider>(context, listen: false),
          ),
        ),
        Provider<HomePage>(
          create: (BuildContext context) => HomePage(
              bloc: Provider.of<HomePageBloc>(context, listen: false),
              settingsBloc:
                  Provider.of<SettingsDrawerBloc>(context, listen: false)),
        )
      ],
      child: DynamicTheme(
          defaultBrightness: Brightness.light,
          data: (Brightness brightness) => brightness == Brightness.light
              ? ThemeData.light()
              : ThemeData.dark(),
          themedWidgetBuilder: (BuildContext context, ThemeData theme) {
            return MaterialApp(
              theme: theme,
              darkTheme: ThemeData.dark(),
              title: 'ToDo Application',
              home: Provider.of<HomePage>(context, listen: false),
            );
          }),
    );
  }
}
