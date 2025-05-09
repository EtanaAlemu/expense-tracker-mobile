class Budget {
  final String id;
  final String userId;
  final String categoryId;
  final double limit;
  final DateTime startDate;
  final DateTime endDate;
  final bool isSynced;

  Budget({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.limit,
    required this.startDate,
    required this.endDate,
    this.isSynced = false,
  });

  bool get isActive {
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate);
  }

  Budget copyWith({
    String? id,
    String? userId,
    String? categoryId,
    double? limit,
    DateTime? startDate,
    DateTime? endDate,
    bool? isSynced,
  }) {
    return Budget(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      categoryId: categoryId ?? this.categoryId,
      limit: limit ?? this.limit,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
 