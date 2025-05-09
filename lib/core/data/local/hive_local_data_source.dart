import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';
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
      debugPrint('Box $boxName opened successfully');
    } catch (e, stackTrace) {
      debugPrint('Error opening box $boxName: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<void> save(T item) async {
    try {
      final id = getId(item);
      debugPrint('💾 Saving item to box $boxName with id: $id');
      await box.put(id, item);
      debugPrint('✅ Item saved successfully');
    } catch (e) {
      debugPrint('❌ Error saving item to box $boxName: $e');
      rethrow;
    }
  }

  @override
  Future<void> saveAll(List<T> items) async {
    try {
      debugPrint('💾 Saving ${items.length} items to box $boxName');
      final Map<String, T> itemsMap = {
        for (var item in items) getId(item): item,
      };
      await box.putAll(itemsMap);
      debugPrint('✅ All items saved successfully');
    } catch (e) {
      debugPrint('❌ Error saving items to box $boxName: $e');
      rethrow;
    }
  }

  @override
  Future<T?> get(String id) async {
    try {
      debugPrint('🔍 Getting item from box $boxName with id: $id');
      final item = box.get(id);
      debugPrint('✅ Item retrieved successfully');
      return item;
    } catch (e) {
      debugPrint('❌ Error getting item from box $boxName: $e');
      rethrow;
    }
  }

  @override
  Future<List<T>> getAll() async {
    try {
      final values = box.values.toList();
      debugPrint(
          '📦 Getting all items from box $boxName: ${values.length} items found');
      for (var item in values) {
        debugPrint('📝 Item in box: ${getId(item)}');
      }
      return values;
    } catch (e) {
      debugPrint('❌ Error getting all items from box $boxName: $e');
      rethrow;
    }
  }

  @override
  Future<void> update(T item) async {
    try {
      final id = getId(item);
      debugPrint('🔄 Updating item in box $boxName with id: $id');
      await box.put(id, item);
      debugPrint('✅ Item updated successfully');
    } catch (e) {
      debugPrint('❌ Error updating item in box $boxName: $e');
      rethrow;
    }
  }

  @override
  Future<void> delete(dynamic item) async {
    try {
      final id = item is String ? item : getId(item);
      debugPrint('🗑️ Deleting item from box $boxName with id: $id');
      await box.delete(id);
      debugPrint('✅ Item deleted successfully');
    } catch (e) {
      debugPrint('❌ Error deleting item from box $boxName: $e');
      rethrow;
    }
  }

  @override
  Future<void> clear() async {
    try {
      await box.clear();
    } catch (e) {
      debugPrint('Error clearing box $boxName: $e');
      rethrow;
    }
  }

  String getId(T item);
}
