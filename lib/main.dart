import 'package:ToDo/blocs/home_page_bloc.dart';
import 'package:ToDo/models/file_system_repository.dart';
import 'package:ToDo/models/settings_repository.dart';
import 'package:ToDo/models/shared_preferences_settings_repository.dart';
import 'package:ToDo/models/task_repository.dart';
import 'package:ToDo/settings_provider.dart';
import 'package:ToDo/view/pages/home_page.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      ],
      child: Provider<HomePageBloc>(
        create: (BuildContext context) => HomePageBloc(
          Provider.of<TaskRepository>(context, listen: false),
          Provider.of<SettingsRepository>(context, listen: false),
        ),
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
                home: HomePage(
                  bloc: Provider.of<HomePageBloc>(context, listen: false),
                ),
              );
            }),
      ),
    );
  }
}
