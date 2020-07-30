import 'dart:convert';
import 'dart:io';

import 'package:ToDo/models/task.dart';
import 'package:ToDo/models/task_repository.dart';
import 'package:path_provider/path_provider.dart';

class FileSystemRepository implements TaskRepository {
  final String _fileName = 'todos.fs';
  final JsonCodec _codec = const JsonCodec();

  Future<File> get _localFile async {
    final String path = await _localPath;
    final File _file = File('$path/$_fileName');
    if(!(await _file.exists())) {
      _file.create(recursive: true);
    }
    return _file;
  }

  Future<String> get _localPath async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _writeTaskList(List<Task> tasks) async {
    final File file = await _localFile;
    return file.writeAsString(_codec.encode(tasks));
  }

  Future<dynamic> _readTaskList() async {
    try {
      final File file = await _localFile;
      final String contents = await file.readAsString();

      print(contents);
      return _codec.decode(contents);
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<bool> create(Task task) async {
    getAll().then((List<Task> value) {
      _writeTaskList(<Task>[...value, task]);
      return true;
    });
    return true;
  }

  @override
  Future<bool> delete(Task task) async {
    List<Task> _tasks = await getAll();
    _tasks.removeAt(task.
    TaskID);
    await _writeTaskList(_tasks);
    return true;
  }

  @override
  Future<List<Task>> getAll() async {
    final dynamic value = await _readTaskList();
    if (value != null) {
      final List<Task> tasks = <Task>[];
      final List<dynamic> _tasks = value as List<dynamic>;
      _tasks.forEach((dynamic element) {
        tasks.add(_convertFromJsonToTask(element as Map<String, dynamic>));
      });
      return tasks;
    } else {
      return <Task> [];
    }
  }

  Task _convertFromJsonToTask(Map<String, dynamic> task) => Task(
      task['task'] as String,
      task['description'] as String,
      task['color'] as int,
      isCompleted: task['completed'] as bool,
      id: task['id'] as int);

  @override
  Future<void> initialize() async {
    await _readTaskList();
    return;
  }

  @override
  Future<bool> update(Task task) async {
    await delete(task);
    await create(task);
    return true;
  }
}