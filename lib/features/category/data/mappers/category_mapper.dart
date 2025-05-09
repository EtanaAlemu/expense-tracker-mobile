import 'package:expense_tracker/features/category/data/models/hive_category_model.dart';
import 'package:expense_tracker/features/category/domain/entities/category.dart';

class CategoryMapper {
  HiveCategoryModel toHiveModel(Category category) {
    return HiveCategoryModel(
      id: category.id,
      name: category.name,
      description: category.description,
      icon: category.icon,
      color: category.color,
      type: category.type,
      userId: category.userId,
      createdAt: category.createdAt,
      updatedAt: category.updatedAt,
      isDefault: category.isDefault,
    );
  }

  Category toEntity(dynamic model) {
    if (model is HiveCategoryModel) {
      return Category(
        id: model.id,
        name: model.name,
        description: model.description,
        icon: model.icon,
        color: model.color,
        type: model.type,
        userId: model.userId,
        createdAt: model.createdAt,
        updatedAt: model.updatedAt,
        isDefault: model.isDefault,
      );
    } else if (model is Map<String, dynamic>) {
      print('Mapping API response to Category: ${model['_id']}'); // Debug log
      final id = model['_id']?.toString();
      print('Category ID after mapping: $id'); // Debug log
      return Category(
        id: id,
        name: model['name'],
        description: model['description'],
        icon: _parseIcon(model['icon']),
        color: _parseColor(model['color']),
        type: model['type'],
        userId: model['userId'] ?? '',
        isDefault: model['isDefault'] ?? false,
        createdAt: model['createdAt'] != null
            ? DateTime.parse(model['createdAt'])
            : null,
        updatedAt: model['updatedAt'] != null
            ? DateTime.parse(model['updatedAt'])
            : null,
      );
    }
    throw Exception('Invalid model type');
  }

  Map<String, dynamic> toApiModel(Category category) {
    return {
      'name': category.name,
      'description': category.description,
      'icon': category.icon,
      'color': category.color != null
          ? '#${category.color!.toRadixString(16).padLeft(6, '0')}'
          : null,
      'type': category.type,
      'userId': category.userId,
      'isDefault': category.isDefault,
    };
  }

  int? _parseColor(String? colorString) {
    if (colorString == null) return null;
    if (colorString.startsWith('#')) {
      colorString = colorString.substring(1);
    }
    return int.tryParse(colorString, radix: 16);
  }

  String? _parseIcon(dynamic icon) {
    if (icon == null) return null;
    if (icon is String) {
      // If it's already a string, return it
      return icon;
    } else if (icon is int) {
      // If it's an int, convert to string
      return icon.toString();
    }
    return null;
  }

  Map<String, dynamic> toJson(Category category) {
    return {
      '_id': category.id,
      'name': category.name,
      'description': category.description,
      'icon': category.icon,
      'color': category.color,
      'type': category.type,
      'isDefault': category.isDefault,
      'createdAt': category.createdAt?.toIso8601String(),
      'updatedAt': category.updatedAt?.toIso8601String(),
    };
  }
}
