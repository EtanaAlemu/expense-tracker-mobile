import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final String type;
  final Color color;
  final IconData icon;
  final double? budget;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;
  final bool isDefault;
  final bool isSynced;

  const Category({
    required this.id,
    required this.name,
    required this.type,
    required this.color,
    required this.icon,
    this.budget,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    this.isDefault = false,
    this.isSynced = false,
  });

  Category copyWith({
    String? id,
    String? name,
    String? type,
    Color? color,
    IconData? icon,
    double? budget,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
    bool? isDefault,
    bool? isSynced,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      budget: budget ?? this.budget,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      isDefault: isDefault ?? this.isDefault,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
