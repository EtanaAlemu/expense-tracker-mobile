import 'package:hive/hive.dart';

part 'hive_expense_model.g.dart';

@HiveType(typeId: 4)
class HiveExpenseModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String userId;

  @HiveField(2)
  double amount;

  @HiveField(3)
  String categoryId;

  @HiveField(4)
  String description;

  @HiveField(5)
  DateTime date;

  @HiveField(6)
  bool isSynced;

  HiveExpenseModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.categoryId,
    required this.description,
    required this.date,
    this.isSynced = false,
  });
}
