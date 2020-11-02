abstract class SettingsDrawerEvent<T> {
  Future<T> reduce(T oldState);
}
