import 'package:ToDo/models/task.dart';
import 'package:ToDo/models/task_repository.dart';

class MockTaskRepository implements TaskRepository {
  Map<int, Task> _tasks = {
    0: Task(0, '123', 'csadfsafdasf', 0xff00bcd4),
    1: Task(1, '567', 'zxcvxzcvxczvzx', 0xff00bcd4),
    2: Task(2, 'dfgd', 'sadfsadfsadfasdf', 0xff00bcd4),
    3: Task(3, 'xcxzczx', 'xopiopuipuiopui', 0xff00bcd4),
  };

  @override
  Future<bool> create(Task task) {
    _tasks.putIfAbsent(task.id, () => task);
  }

  @override
  Future<bool> delete(Task task) {
    _tasks.remove(task.id);
  }

  @override
  Future<bool> update(Task task) {
    _tasks.update(task.id, (value) => task);
  }

  @override
  Future<void> initialyze() {
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
