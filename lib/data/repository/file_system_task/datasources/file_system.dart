import 'dart:convert';
import 'dart:io';

import 'package:ToDo/data/models/task.dart';
import 'package:path_provider/path_provider.dart';

class TaskModelFileSystemDataSource {
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

  Future<File> writeTaskModels(List<TaskModel> tasks) async {
    final File file = await _localFile;
    file.deleteSync();
    file.createSync();
    return await file.writeAsString(_codec.encode(tasks));
  }

  Future<dynamic> readTaskList() async {
    try {
      final File file = await _localFile;
      final String contents = await file.readAsString();
      if (contents.isNotEmpty) {
        return await _codec.decode(contents);
      } else {
        return <dynamic>[];
      }
    } on Exception catch (e) {
      return <dynamic>[];
    }
  }

  List<TaskModel> rebuildIDsInList(List<TaskModel> tasks) {
    final List<TaskModel> _result = <TaskModel>[];
    int id = 0;
    tasks.forEach((TaskModel model) {
      TaskModel newElement;
      if (model.id == id + 1) {
        newElement = TaskModel(
          id: id,
          text: model.text,
          description: model.description,
          color: model.color,
          isCompleted: model.isCompleted,
        );
        _result.add(newElement);
      } else {
        _result.add(model);
      }
      ++id;
    });
    return _result;
  }

  Future<List<TaskModel>> getAllTaskModels() async {
    final dynamic value = await readTaskList();
    if (value != null) {
      final List<TaskModel> tasks = <TaskModel>[];
      final List<dynamic> _tasks = value as List<dynamic>;
      _tasks.forEach((dynamic element) {
        tasks.add(TaskModel.fromJson(element as Map<String, dynamic>));
      });
      return tasks;
    } else {
      return <TaskModel>[];
    }
  }

  Future<bool> deleteAll() async {
    final File file = await _localFile;
    file.deleteSync();
    file.createSync();
    return true;
  }
}
