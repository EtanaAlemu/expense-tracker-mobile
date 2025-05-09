import 'package:hive/hive.dart';

part 'hive_budget_model.g.dart';

@HiveType(typeId: 2)
class HiveBudgetModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String userId;

  @HiveField(2)
  String categoryId;

  @HiveField(3)
  double limit;

  @HiveField(4)
  DateTime startDate;

  @HiveField(5)
  DateTime endDate;

  @HiveField(6)
  bool isSynced;

  HiveBudgetModel({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.limit,
    required this.startDate,
    required this.endDate,
    this.isSynced = false,
  });
}
