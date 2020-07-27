import 'package:ToDo/blocs/home_page_bloc.dart';
import 'package:ToDo/view/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ToDoApp());
}

class ToDoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.green,
        accentColor: Colors.green[300],
      ),
      title: 'ToDo Application',
      home: HomePage(
        hbloc: HomePageBloc(),
      ),
    );
  }
}
