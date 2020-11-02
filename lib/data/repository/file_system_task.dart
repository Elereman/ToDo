import 'dart:convert';
import 'dart:io';

import 'package:ToDo/domain/entities/task.dart';
import 'package:ToDo/domain/repositories/task_repository.dart';
import 'package:path_provider/path_provider.dart';

class FileSystemRepository implements TaskRepository {
  final String _fileName = 'todos.fs';
  final JsonCodec _codec = const JsonCodec();

  Future<File> get _localFile async {
    final String path = await _localPath;
    final File _file = File('$path/$_fileName');
    if (!await _file.exists()) {
      _file.createSync();
    }
    return _file;
  }

  Future<String> get _localPath async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _writeTaskList(List<Task> tasks) async {
    final File file = await _localFile;
    file.deleteSync();
    file.createSync();
    print('codec encode ${_codec.encode(tasks)}');
    return await file.writeAsString(_codec.encode(tasks));
  }

  Future<dynamic> _readTaskList() async {
    try {
      final File file = await _localFile;
      final String contents = await file.readAsString();
      print('String $contents end');
      if (contents.isNotEmpty) {
        //final String clearContents = contents.replaceAll('null,', '');
        return await _codec.decode(contents);
      } else {
        return <dynamic>[];
      }
    } on Exception catch (e) {
      print('exeption $e');
      return <dynamic>[];
    }
  }

  @override
  Future<Task> create(Task task) async {
    final List<Task> value = await getAll();
    final Task _createdTask = Task(
      task: task.task,
      taskDescription: task.description,
      color: task.color,
      isCompleted: task.isCompleted,
      id: value.length,
    );
    await _writeTaskList(<Task>[...value, _createdTask]);
    return _createdTask;
  }

  @override
  Future<bool> delete(int task) async {
    final List<Task> _tasks = await getAll();
    _tasks.removeAt(task);
    await _writeTaskList(_rebuildIDsInList(_tasks));
    print('deleted');
    return true;
  }

  @override
  Future<List<Task>> getAll() async {
    final dynamic value = await _readTaskList();
    if (value != null) {
      final List<Task> tasks = <Task>[];
      print('runtime type ${value.runtimeType}');
      final List<dynamic> _tasks = value as List<dynamic>;
      print('started conversion');
      _tasks.forEach((dynamic element) {
        print(element as Map<String, dynamic>);
        tasks.add(_convertFromJsonToTask(element as Map<String, dynamic>));
      });
      return tasks;
    } else {
      return <Task>[];
    }
  }

  @override
  Future<bool> deleteAll() async {
    final File file = await _localFile;
    file.deleteSync();
    file.createSync();
    return true;
  }

  List<Task> _rebuildIDsInList(List<Task> tasks) {
    final List<Task> _result = <Task>[];
    int id = 0;
    tasks.forEach((Task element) {
      Task newElement;
      if (element.id == id + 1) {
        newElement = Task(
          id: id,
          task: element.task,
          taskDescription: element.description,
          color: element.color,
          isCompleted: element.isCompleted,
        );
        _result.add(newElement);
      } else {
        _result.add(element);
      }
      ++id;
    });
    return _result;
  }

  Task _convertFromJsonToTask(Map<String, dynamic> task) =>
      Task(
          task: task['task'] as String,
          taskDescription: task['description'] as String,
          color: task['color'] as int,
          isCompleted: task['completed'] as bool,
          id: task['id'] as int);

  @override
  Future<void> initialize() async {
    await _readTaskList();
    return;
  }

  @override
  Future<Task> update(Task task) async {
    final List<Task> _tasks = await getAll();
    _tasks.removeAt(task.id);
    _tasks.insert(task.id, task);
    await _writeTaskList(_tasks);
    return task;
  }

  @override
  Future<Task> get(int id) async {
    final List<Task> _tasks = await getAll();
    return _tasks[id];
  }
}
