import 'package:hive/hive.dart';

part 'hive_category_model.g.dart';

@HiveType(typeId: 1)
class HiveCategoryModel {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String type;

  @HiveField(3)
  final dynamic color;

  @HiveField(4)
  final String? icon;

  @HiveField(5)
  final double? budget;

  @HiveField(6)
  final String? description;

  @HiveField(7)
  final DateTime? createdAt;

  @HiveField(8)
  final DateTime? updatedAt;

  @HiveField(9)
  final String userId;

  @HiveField(10)
  final bool isDefault;

  // New fields
  @HiveField(11)
  final String transactionType;

  @HiveField(12)
  final String? frequency;

  @HiveField(13)
  final double? defaultAmount;

  @HiveField(14)
  final bool? isActive;

  @HiveField(15)
  final bool? isRecurring;

  @HiveField(16)
  final DateTime? lastProcessedDate;

  @HiveField(17)
  final DateTime? nextProcessedDate;

  @HiveField(18)
  final bool isSynced;

  @HiveField(19)
  final bool isUpdated;

  @HiveField(20)
  final bool isDeleted;

  HiveCategoryModel({
    this.id,
    required this.name,
    required this.type,
    this.color,
    this.icon,
    this.budget,
    this.description,
    this.createdAt,
    this.updatedAt,
    required this.userId,
    required this.isDefault,
    required this.transactionType,
    this.frequency,
    this.defaultAmount,
    this.isActive,
    this.isRecurring,
    this.lastProcessedDate,
    this.nextProcessedDate,
    this.isSynced = false,
    this.isUpdated = false,
    this.isDeleted = false,
  });

  // Helper method to get color as int
  int? get colorAsInt {
    if (color == null) return null;
    if (color is int) return color as int;
    if (color is String) {
      try {
        return int.parse(color as String);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
