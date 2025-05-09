abstract class BaseRepository<T> {
  Future<void> save(T item);
  Future<void> saveAll(List<T> items);
  Future<T?> get(String id);
  Future<List<T>> getAll();
  Future<void> update(T item);
  Future<void> delete(T item);
  Future<void> clear();
}
