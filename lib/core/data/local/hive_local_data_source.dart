import 'package:hive_flutter/hive_flutter.dart';
import 'base_local_data_source.dart';

abstract class HiveLocalDataSource<T> implements BaseLocalDataSource<T> {
  final String boxName;
  late final Box<T> box;

  HiveLocalDataSource(this.boxName) {
    _initializeBox();
  }

  Future<void> _initializeBox() async {
    try {
      box = await Hive.openBox<T>(boxName);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> save(T item) async {
    try {
      final id = getId(item);
      await box.put(id, item);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> saveAll(List<T> items) async {
    try {
      final Map<String, T> itemsMap = {
        for (var item in items) getId(item): item,
      };
      await box.putAll(itemsMap);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<T?> get(String id) async {
    try {
      final item = box.get(id);
      return item;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<T>> getAll() async {
    try {
      final values = box.values.toList();
      return values;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> update(T item) async {
    try {
      final id = getId(item);
      await box.put(id, item);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> delete(dynamic item) async {
    try {
      final id = item is String ? item : getId(item);

      // Verify item exists before deletion
      final exists = box.containsKey(id);

      if (exists) {
        await box.delete(id);

        // Verify deletion
        final stillExists = box.containsKey(id);


        if (stillExists) {
          await box.delete(id);
        }
      } else {
        print('⚠️ HiveLocalDataSource: Item not found for deletion');
      }
    } catch (e) {
      print('❌ HiveLocalDataSource: Error during deletion: $e');
      rethrow;
    }
  }

  @override
  Future<void> clear() async {
    try {
      await box.clear();
    } catch (e) {
      rethrow;
    }
  }

  String getId(T item);
}
