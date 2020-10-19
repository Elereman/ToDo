import 'package:ToDo/presentation/blocs/home_page.dart';
import 'package:ToDo/presentation/blocs/settings_drawer.dart';
import 'package:ToDo/presentation/flutter/view/pages/home.dart';
import 'package:ToDo/tools/settings_provider.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/repository/file_system_task.dart';
import 'data/repository/shared_preferences_settings.dart';
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
        Provider<HomePageBloc>(
          create: (BuildContext context) => HomePageBloc(
              Provider.of<TaskRepository>(context, listen: false),
              Provider.of<SettingsProvider>(context, listen: false)),
        ),
        Provider<HomePage>(
          create: (BuildContext context) => HomePage(
              bloc: Provider.of<HomePageBloc>(context, listen: false),
              settingsBloc: Provider.of<SettingsDrawerBloc>(context, listen: false)),
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