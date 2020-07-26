import 'package:ToDo/models/task.dart';
import 'package:ToDo/models/task_repository.dart';

class MockTaskRepository implements TaskRepository {
  Map<int ,Task> _tasks = {};
  
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
  
}