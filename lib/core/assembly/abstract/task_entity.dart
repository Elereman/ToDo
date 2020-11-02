import 'package:ToDo/core/assembly/abstract/entity_factory.dart';
import 'package:ToDo/data/models/task.dart';
import 'package:ToDo/domain/entities/task.dart';

abstract class TaskEntityFactory implements EntityFactory<Task, TaskModel> {}
