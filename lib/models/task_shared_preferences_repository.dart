import 'package:ToDo/models/task.dart';
import 'package:ToDo/models/task_repository.dart';
import 'package:localstorage/localstorage.dart';


class TaskSharedPreferencesRepository implements TaskRepository{
  final LocalStorage storage = new LocalStorage('todos.json');

  _saveToStorage() {
    //storage.setItem('todos', list.toJSONEncodable());
  }

  String _convertTaskToJson(Task task) {
    
    return '';
  }

  @override
  Future<bool> create(Task task) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<bool> delete(Task task) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<bool> update(Task task) {
    // TODO: implement update
    throw UnimplementedError();
  }

}