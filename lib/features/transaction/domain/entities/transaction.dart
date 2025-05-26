class Transaction {
  final String id;
  final String userId;
  final String type; // 'Income' or 'Expense'
  final double amount;
  final String categoryId;
  final String title;
  final String description;
  final DateTime date;
  final bool isSynced;
  final bool isDeleted;
  final bool isUpdated;

  Transaction({
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

  Transaction copyWith({
    String? id,
    String? userId,
    String? type,
    double? amount,
    String? categoryId,
    String? title,
    String? description,
    DateTime? date,
    bool? isSynced,
    bool? isDeleted,
    bool? isUpdated,
  }) {
    return Transaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
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
