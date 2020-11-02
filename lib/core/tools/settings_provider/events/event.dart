abstract class SettingsProviderEvent<T> {
  Future<T> reduce(T t);
}
