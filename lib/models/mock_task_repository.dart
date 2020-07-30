import 'dart:convert';

import 'package:ToDo/models/task.dart';
import 'package:ToDo/models/task_repository.dart';

class MockTaskRepository implements TaskRepository {
  final Map<int, Task> _tasks = {
    0: Task('123', 'csadfsafdasf', 0xff00bcd4),
    1: Task('567', 'zxcvxzcvxczvzx', 0xff00bcd4),
    2: Task('dfgd', 'sadfsadfsadfasdf', 0xff00bcd4),
    3: Task('xcxzczx', 'xopiopuipuiopui', 0xff00bcd4),
  };

  @override
  Future<bool> create(Task task) {
    JsonCodec _codec = JsonCodec();
    print(_codec.encode([task]));
    _tasks.putIfAbsent(task.TaskID, () => task);
  }

  @override
  Future<bool> delete(Task task) {
    _tasks.remove(task.TaskID);
  }

  @override
  Future<bool> update(Task task) {
    _tasks.update(task.TaskID, (value) => task);
  }

  @override
  Future<void> initialize() {
    print('Initialized');
  }

  @override
  Future<List<Task>> getAll() {
    return _mapToList(_tasks);
  }

  Future<List<Task>> _mapToList(Map<int, Task> map) async {
    List<Task> result = [];
    map.forEach((key, value) {
      result.add(value);
    });
    return result;
  }
}
