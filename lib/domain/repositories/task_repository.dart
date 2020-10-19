import 'file:///D:/ToDo/lib/domain/entities/task.dart';

abstract class TaskRepository {
  Future<void> initialize();

  Future<List<Task>> getAll();

  Future<bool> deleteAll();

  Future<bool> create(Task task);

  Future<Task> update(Task task);

  Future<bool> delete(Task task);
}