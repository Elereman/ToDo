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
  Future<bool> create(Task task) async {
    const JsonCodec _codec = JsonCodec();
    print(_codec.encode(<Task>[task]));
    _tasks.putIfAbsent(task.TaskID, () => task);
    return true;
  }

  @override
  Future<bool> delete(Task task) async {
    _tasks.remove(task.TaskID);
    return true;
  }

  @override
  Future<Task> update(Task task) async {
    _tasks.update(task.TaskID, (Task value) => task);
    return _tasks[task.TaskID];
  }

  @override
  Future<void> initialize() async {
    print('Initialized');
    return;
  }

  @override
  Future<List<Task>> getAll() {
    return _mapToList(_tasks);
  }

  Future<List<Task>> _mapToList(Map<int, Task> map) async {
    final List<Task> result = <Task> [];
    map.forEach((int key, Task value) {
      result.add(value);
    });
    return result;
  }
}
