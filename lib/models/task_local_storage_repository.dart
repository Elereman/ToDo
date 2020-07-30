import 'dart:convert';

import 'package:ToDo/models/task.dart';
import 'package:ToDo/models/task_repository.dart';
import 'package:localstorage/localstorage.dart';

class TaskLocalStorageRepository implements TaskRepository {
  final LocalStorage storage = new LocalStorage('todos.json');
  final JsonCodec _codec = JsonCodec();
  List<Task> _tasks;

  TaskLocalStorageRepository() : _tasks = [];

 // _saveToStorage(List<Task> tasks) {
  //  print('_codec.encode');
  //  print(_codec.encode(tasks));
  //  storage.setItem('todos', _codec.encode(tasks));
  //}

  @override
  Future<bool> create(Task task) {
    //_saveToStorage([task]);
  }

  @override
  Future<bool> delete(Task task) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<bool> update(Task task) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<void> initialize() {
    _getAll().then((value) {
      _tasks = value;
    });
    storage.ready.then((value) {
      print('$value initial');
      dynamic data = storage.getItem('todos');
      print(data);
    });
  }

  @override
  Future<List<Task>> _getAll() async {
    List<Task> result = [];
    storage.ready.then((value) {
      print('storage.getItem');
      print(storage.getItem('todos'));
      List<Task> tasks = [];
      //List dynamic = _codec.decode(storage.getItem('todos'));
    //  dynamic.forEach((element) {
     //   Task t = element as Task;
     //   print(t.toJson());
     //   tasks.add(t);
     // });
      result.addAll(tasks);
      return result;
    });
  }

  @override
  Future<List<Task>> getAll() async {
    return [Task('', '', 0xff00bcd4)];
  }
}
