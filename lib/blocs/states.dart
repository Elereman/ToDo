abstract class BlocState<T> with _GetRuntimeType {
  T get stateData;
}

class TaskWidgetCreatedState<T> extends BlocState<T> {
  final T _data;

  TaskWidgetCreatedState(this._data);

  @override
  T get stateData => _data;
}

mixin _GetRuntimeType {
  Type get type => runtimeType;
}