import 'package:ToDo/blocs/home_page.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'domain/setting/repository.dart';
import 'domain/setting/shared_preferences_repository.dart';
import 'domain/task/file_system_repository.dart';
import 'domain/task/repository.dart';
import 'flutter/view/pages/home.dart';

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
