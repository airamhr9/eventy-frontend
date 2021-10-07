abstract class Service {
  abstract String url;

  Future<T> get<T>();
}
