class Category {
  final String? id;
  final String name;
  final String? description;
  final String? icon;
  final int? color;
  final String type; // 'Income' or 'Expense'
  final String userId;
  final bool isDefault;
  final bool isSynced;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Category({
    this.id,
    required this.name,
    this.description,
    this.icon,
    this.color,
    required this.type,
    required this.userId,
    this.isDefault = false,
    this.isSynced = false,
    this.createdAt,
    this.updatedAt,
  });

  Category copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    int? color,
    String? type,
    String? userId,
    bool? isDefault,
    bool? isSynced,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      type: type ?? this.type,
      userId: userId ?? this.userId,
      isDefault: isDefault ?? this.isDefault,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
