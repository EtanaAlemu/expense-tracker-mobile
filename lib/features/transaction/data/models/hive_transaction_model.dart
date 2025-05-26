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
  String title;

  @HiveField(6)
  String description;

  @HiveField(7)
  DateTime date;

  @HiveField(8)
  bool isSynced;

  @HiveField(9)
  bool isDeleted;

  @HiveField(10)
  bool isUpdated;

  HiveTransactionModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.date,
    this.isSynced = false,
    this.isDeleted = false,
    this.isUpdated = false,
  });

  HiveTransactionModel copyWith({
    String? id,
    String? userId,
    double? amount,
    String? type,
    String? categoryId,
    String? title,
    String? description,
    DateTime? date,
    bool? isSynced,
    bool? isDeleted,
    bool? isUpdated,
  }) {
    return HiveTransactionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
      isUpdated: isUpdated ?? this.isUpdated,
    );
  }
}
