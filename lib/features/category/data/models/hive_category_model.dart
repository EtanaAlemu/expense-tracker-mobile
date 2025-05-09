import 'package:hive/hive.dart';

part 'hive_category_model.g.dart';

@HiveType(typeId: 1)
class HiveCategoryModel {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final String? icon;

  @HiveField(4)
  final int? color;

  @HiveField(5)
  final String type; // 'income' or 'expense'

  @HiveField(6)
  final String userId;

  @HiveField(7)
  final DateTime? createdAt;

  @HiveField(8)
  final DateTime? updatedAt;

  @HiveField(9, defaultValue: false)
  final bool isDefault;

  HiveCategoryModel({
    this.id,
    required this.name,
    this.description,
    this.icon,
    this.color,
    required this.type,
    required this.userId,
    this.createdAt,
    this.updatedAt,
    this.isDefault = false,
  });
}
