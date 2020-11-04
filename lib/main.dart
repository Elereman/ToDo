import 'package:ToDo/core/assembly/abstract/setting_entity.dart';
import 'package:ToDo/core/assembly/abstract/task_entity.dart';
import 'package:ToDo/core/assembly/concrete/setting_entity_from_model.dart';
import 'package:ToDo/core/assembly/concrete/task_entity_from_model.dart';
import 'package:ToDo/data/usecases/create_task_through_repository.dart';
import 'package:ToDo/data/usecases/edit_setting_through_repository.dart';
import 'package:ToDo/data/usecases/reset_settings_through_repository.dart';
import 'package:ToDo/domain/usecases/create_task.dart';
import 'package:ToDo/domain/usecases/delete_all_tasks.dart';
import 'package:ToDo/domain/usecases/delete_task.dart';
import 'package:ToDo/domain/usecases/get_all_tasks.dart';
import 'package:ToDo/domain/usecases/edit_task.dart';
import 'package:ToDo/domain/usecases/reset_settings.dart';
import 'package:ToDo/presentation/blocs/home_page/bloc.dart';
import 'package:ToDo/presentation/blocs/settings_drawer/bloc.dart';
import 'package:ToDo/presentation/flutter/view/pages/home.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/tools/settings_provider/settings_provider.dart';
import 'data/repository/file_system_task/repository.dart';
import 'data/repository/shared_preferences_settings/repository.dart';
import 'data/usecases/delete_all_tasks_through_repository.dart';
import 'data/usecases/delete_task_through_repository.dart';
import 'data/usecases/edit_task_through_repository.dart';
import 'data/usecases/get_all_tasks_through_repository.dart';
import 'data/usecases/get_settings_list_through_repository.dart';
import 'data/usecases/get_settings_through_repository.dart';
import 'domain/repositories/settings_repository.dart';
import 'domain/repositories/task_repository.dart';
import 'domain/usecases/edit_setting.dart';
import 'domain/usecases/get_setting.dart';
import 'domain/usecases/get_settings_list.dart';

void main() {
  runApp(ToDoApp());
}

class ToDoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <Provider<dynamic>>[
        Provider<TaskEntityFactory>(
          create: (_) => TaskEntityFromModelFactory(),
        ),
        Provider<SettingEntityFactory>(
          create: (_) => SettingEntityFromModelFactory(),
        ),
        Provider<TaskRepository>(
            create: (BuildContext context) => FileSystemTaskRepository(
                Provider.of<TaskEntityFactory>(context, listen: false))),
        Provider<SettingsRepository>(
            create: (BuildContext context) =>
                SharedPreferencesSettingsRepository(<String, String>{
                  'task_color': '4278190080',
                  'description_color': '4288585374',
                  'dark_mode': 'false',
                }, Provider.of<SettingEntityFactory>(context, listen: false))),
        Provider<SettingsProvider>(
          create: (BuildContext context) => SettingsProvider(
              Provider.of<SettingsRepository>(context, listen: false)),
        ),
        Provider<ResetSettingsUseCase>(
          create: (BuildContext context) =>
              ResetSettingsUseCaseThroughRepository(
                  Provider.of<SettingsProvider>(context, listen: false)),
        ),
        Provider<EditSettingUseCase>(
          create: (BuildContext context) => EditSettingUseCaseThroughRepository(
              Provider.of<SettingsProvider>(context, listen: false)),
        ),
        Provider<GetSettingUseCase>(
          create: (BuildContext context) => GetSettingUseCaseThroughRepository(
              Provider.of<SettingsProvider>(context, listen: false)),
        ),
        Provider<GetSettingsListUseCase>(
          create: (BuildContext context) =>
              GetSettingsListUseCaseThroughRepository(
                  Provider.of<SettingsProvider>(context, listen: false)),
        ),
        Provider<SettingsDrawerBloc>(
          create: (BuildContext context) => SettingsDrawerBloc(
            resetSettingsListUseCase:
                Provider.of<ResetSettingsUseCase>(context, listen: false),
            editSettingUseCase:
                Provider.of<EditSettingUseCase>(context, listen: false),
            getSettingsListUseCase:
                Provider.of<GetSettingsListUseCase>(context, listen: false),
            getSettingUseCase:
                Provider.of<GetSettingUseCase>(context, listen: false),
          ),
        ),
        Provider<DeleteAllTasksUseCase>(
          create: (BuildContext context) =>
              DeleteAllTasksUseCaseThroughRepository(
                  Provider.of<TaskRepository>(context, listen: false)),
        ),
        Provider<GetAllTasksUseCase>(
          create: (BuildContext context) => GetAllTasksUseCaseThroughRepository(
              Provider.of<TaskRepository>(context, listen: false)),
        ),
        Provider<EditTaskUseCase>(
          create: (BuildContext context) => EditTaskUseCaseThroughRepository(
              Provider.of<TaskRepository>(context, listen: false)),
        ),
        Provider<DeleteTaskUseCase>(
          create: (BuildContext context) => DeleteTaskUseCaseThroughRepository(
              Provider.of<TaskRepository>(context, listen: false)),
        ),
        Provider<CreateTaskUseCase>(
          create: (BuildContext context) => CreateTaskUseCaseThroughRepository(
              Provider.of<TaskRepository>(context, listen: false)),
        ),
        Provider<HomePageBloc>(
          create: (BuildContext context) => HomePageBloc(
            deleteAllTasksUseCase:
                Provider.of<DeleteAllTasksUseCase>(context, listen: false),
            getAllTasksUseCase:
                Provider.of<GetAllTasksUseCase>(context, listen: false),
            editTaskUseCase:
                Provider.of<EditTaskUseCase>(context, listen: false),
            deleteTaskUseCase:
                Provider.of<DeleteTaskUseCase>(context, listen: false),
            createTaskUseCase:
                Provider.of<CreateTaskUseCase>(context, listen: false),
            repository: Provider.of<TaskRepository>(context, listen: false),
            settingsProvider:
                Provider.of<SettingsProvider>(context, listen: false),
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
