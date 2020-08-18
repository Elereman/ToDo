abstract class BlocState<T> with _GetRuntimeType {
  T get stateData;
}

class TaskWidgetCreatedState<T> extends BlocState<T> {
  final T _data;

  TaskWidgetCreatedState(this._data);

  @override
  T get stateData => _data;
}

class SettingsChangedState<T> extends BlocState<T> {
  final T _data;

  SettingsChangedState(this._data);

  @override
  T get stateData => _data;
}

class HomePageInitializedState<T> extends BlocState<T> {
  final T _data;

  HomePageInitializedState(this._data);

  @override
  T get stateData => _data;
}


class AllTaskDeletedState<T> extends BlocState<T> {
  final T _data;

  AllTaskDeletedState(this._data);

  @override
  T get stateData => _data;
}

class PressedState<T> extends BlocState<T> {
  final T _data;

  PressedState(this._data);

  @override
  T get stateData => _data;
}

class TaskDeletedState<T> extends BlocState<T> {
  final T _data;

  TaskDeletedState(this._data);

  @override
  T get stateData => _data;
}

class LongPressedState<T> extends BlocState<T> {
  final T _data;

  LongPressedState(this._data);

  @override
  T get stateData => _data;
}

class ColorChangedState<T> extends BlocState<T> {
  final T _data;

  ColorChangedState(this._data);

  @override
  T get stateData => _data;
}

mixin _GetRuntimeType {
  Type get type => runtimeType;
}