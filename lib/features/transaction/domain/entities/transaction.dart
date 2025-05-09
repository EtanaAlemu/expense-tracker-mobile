class Transaction {
  final String id;
  final String userId;
  final String type; // 'Income' or 'Expense'
  final double amount;
  final String categoryId;
  final String description;
  final DateTime date;
  final bool isSynced;

  Transaction({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.categoryId,
    required this.description,
    required this.date,
    this.isSynced = false,
  });

  Transaction copyWith({
    String? id,
    String? userId,
    String? type,
    double? amount,
    String? categoryId,
    String? description,
    DateTime? date,
    bool? isSynced,
  }) {
    return Transaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      description: description ?? this.description,
      date: date ?? this.date,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
 