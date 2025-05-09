class CategoryApiModel {
  final String? id;
  final String name;
  final String? description;
  final String? icon;
  final int? color;
  final String type;
  final String userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CategoryApiModel({
    this.id,
    required this.name,
    this.description,
    this.icon,
    this.color,
    required this.type,
    required this.userId,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'color': color,
      'type': type,
      'userId': userId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory CategoryApiModel.fromJson(Map<String, dynamic> json) {
    return CategoryApiModel(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      color: json['color'],
      type: json['type'],
      userId: json['userId'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}
