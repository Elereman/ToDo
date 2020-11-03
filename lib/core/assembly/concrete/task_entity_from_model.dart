import 'file:///D:/ToDo/lib/core/assembly/abstract/entity_factory.dart';
import 'package:ToDo/core/assembly/abstract/task_entity.dart';
import 'package:ToDo/data/models/task.dart';
import 'package:ToDo/domain/entities/task.dart';

class TaskEntityFromModelFactory implements TaskEntityFactory {
  @override
  Task create(TaskModel argument) => Task(
        id: argument.id,
        description: argument.description,
        text: argument.text,
        color: argument.color,
        isCompleted: argument.isCompleted,
      );
}
