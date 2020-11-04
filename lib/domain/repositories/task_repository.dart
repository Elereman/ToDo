import 'package:ToDo/domain/entities/task.dart';

abstract class TaskRepository {
  Future<void> initialize();

  Future<Task> get(int id);

  Future<List<Task>> getAll();

  Future<bool> deleteAll();

  Future<Task> create(Task task);

  Future<Task> update(Task task);

  Future<bool> delete(int id);
}
