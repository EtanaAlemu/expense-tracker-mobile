import 'package:hive/hive.dart';

part 'hive_transaction_model.g.dart';

@HiveType(typeId: 3)
class HiveTransactionModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String userId;

  @HiveField(2)
  String type; // 'Income' or 'Expense'

  @HiveField(3)
  double amount;

  @HiveField(4)
  String categoryId;

  @HiveField(5)
  String description;

  @HiveField(6)
  DateTime date;

  @HiveField(7)
  bool isSynced;

  HiveTransactionModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.categoryId,
    required this.description,
    required this.date,
    this.isSynced = false,
  });
}
