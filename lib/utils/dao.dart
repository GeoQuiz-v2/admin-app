abstract class IDao<T> {
  Future<List<T>> list();
  Future create(T model);
  Future update(T model);
  Future delete(T model);
}