abstract class HomePageEvent<T> {
  Future<T> reduce(T oldState);
}
