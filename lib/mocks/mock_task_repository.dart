import 'dart:convert';

import 'package:ToDo/domain/entities/task.dart';
import 'package:ToDo/domain/repositories/task_repository.dart';

class MockTaskRepository implements TaskRepository {
  final Map<int, Task> _tasks = <int, Task>{
    0: Task(
      task: '123',
      taskDescription: 'csadfsafdasf',
      color: 0xff00bcd4,
      id: 0,
      isCompleted: false,
    ),
    1: Task(
      task: '567',
      taskDescription: 'zxcvxzcvxczvzx',
      color: 0xff00bcd4,
      id: 1,
      isCompleted: false,
    ),
    2: Task(
      task: 'dfgd',
      taskDescription: 'sadfsadfsadfasdf',
      color: 0xff00bcd4,
      id: 2,
      isCompleted: true,
    ),
    3: Task(
      task: 'xcxzczx',
      taskDescription: 'xopiopuipuiopui',
      color: 0xff00bcd4,
      id: 3,
      isCompleted: true,
    ),
  };

  @override
  Future<Task> create(Task task) async {
    const JsonCodec _codec = JsonCodec();
    print(_codec.encode(<Task>[task]));
    _tasks.putIfAbsent(task.id, () => task);
    return task;
  }

  @override
  Future<bool> delete(int task) async {
    _tasks.remove(task);
    return true;
  }

  @override
  Future<Task> update(Task task) async {
    _tasks.update(task.id, (Task value) => task);
    return _tasks[task.id];
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

  @override
  Future<bool> deleteAll() async {
    return true;
  }

  @override
  Future<Task> get(int id) async => _tasks[id];
}
