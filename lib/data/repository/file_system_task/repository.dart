import 'package:ToDo/core/assembly/abstract/task_entity.dart';
import 'package:ToDo/data/models/task.dart';
import 'package:ToDo/data/repository/file_system_task/datasources/file_system.dart';
import 'package:ToDo/domain/entities/task.dart';
import 'package:ToDo/domain/repositories/task_repository.dart';

class FileSystemTaskRepository implements TaskRepository {
  final TaskEntityFactory _factory;

  final TaskModelFileSystemDataSource _dataSource =
      TaskModelFileSystemDataSource();

  FileSystemTaskRepository(this._factory);

  @override
  Future<Task> create(Task task) async {
    final List<TaskModel> value = await _dataSource.getAllTaskModels();
    final TaskModel _createdTaskModel = TaskModel(
        id: value.length,
        color: task.color,
        text: task.text,
        description: task.description,
        isCompleted: task.isCompleted);
    await _dataSource.writeTaskModels(<TaskModel>[...value, _createdTaskModel]);
    return _factory.create(_createdTaskModel);
  }

  @override
  Future<bool> delete(int task) async {
    final List<TaskModel> _tasks = await _dataSource.getAllTaskModels();
    _tasks.removeAt(task);
    await _dataSource.writeTaskModels(_dataSource.rebuildIDsInList(_tasks));
    return true;
  }

  @override
  Future<List<Task>> getAll() async {
    final List<Task> _tasks = <Task>[];
    final List<TaskModel> _models = await _dataSource.getAllTaskModels();
    _models.forEach((TaskModel model) {
      _tasks.add(_factory.create(model));
    });
    return _tasks;
  }

  @override
  Future<bool> deleteAll() => _dataSource.deleteAll();

  @override
  Future<void> initialize() async {}

  @override
  Future<Task> update(Task task) async {
    final List<TaskModel> _tasks = await _dataSource.getAllTaskModels();
    _tasks.removeAt(task.id);
    _tasks.insert(
        task.id,
        TaskModel(
          id: task.id,
          text: task.text,
          description: task.description,
          color: task.color,
          isCompleted: task.isCompleted,
        ));
    await _dataSource.writeTaskModels(_tasks);
    return task;
  }

  @override
  Future<Task> get(int id) async {
    final List<Task> _tasks = await getAll();
    return _tasks[id];
  }
}
