import 'package:ToDo/pages/home_page.dart';
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
        accentColor: Colors.greenAccent,
      ),
      title: "ToDo Application",
      home: HomePage(),
    );
  }
}
