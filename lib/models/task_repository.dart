import 'package:ToDo/models/task.dart';

abstract class TaskRepository {
  Future<void> initialize(){}
  Future<List<Task>> getAll() {}
  Future<bool> create(Task task) {}
  Future<bool> update(Task task) {}
  Future<bool> delete(Task task) {}
}