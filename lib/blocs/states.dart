abstract class State<T> with _GetRuntimeType {
  T get stateData;
}

class TaskWidgetCreatedState<T> extends State<T> {
  final T _data;

  TaskWidgetCreatedState(this._data);

  @override
  T get stateData => _data;
}

mixin _GetRuntimeType {
  Type get type => runtimeType;
}