class Expense {
  final String id;
  final String userId;
  final double amount;
  final String categoryId;
  final String description;
  final DateTime date;
  final bool isSynced;

  Expense({
    required this.id,
    required this.userId,
    required this.amount,
    required this.categoryId,
    required this.description,
    required this.date,
    this.isSynced = false,
  });

  Expense copyWith({
    String? id,
    String? userId,
    double? amount,
    String? categoryId,
    String? description,
    DateTime? date,
    bool? isSynced,
  }) {
    return Expense(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      description: description ?? this.description,
      date: date ?? this.date,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
