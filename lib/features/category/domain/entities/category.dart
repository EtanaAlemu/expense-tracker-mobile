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
  final bool isUpdated;
  final bool isDeleted;
  final String transactionType; // 'one-time' or 'recurring'
  final String? frequency; // 'daily', 'weekly', 'monthly', 'quarterly', 'yearly'
  final double? defaultAmount;
  final bool isActive;
  final bool isRecurring;
  final DateTime? lastProcessedDate;
  final DateTime? nextProcessedDate;

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
    this.isUpdated = false,
    this.isDeleted = false,
    this.transactionType = 'one-time',
    this.frequency,
    this.defaultAmount,
    this.isActive = true,
    this.isRecurring = false,
    this.lastProcessedDate,
    this.nextProcessedDate,
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
    bool? isUpdated,
    bool? isDeleted,
    String? transactionType,
    String? frequency,
    double? defaultAmount,
    bool? isActive,
    bool? isRecurring,
    DateTime? lastProcessedDate,
    DateTime? nextProcessedDate,
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
      isUpdated: isUpdated ?? this.isUpdated,
      isDeleted: isDeleted ?? this.isDeleted,
      transactionType: transactionType ?? this.transactionType,
      frequency: frequency ?? this.frequency,
      defaultAmount: defaultAmount ?? this.defaultAmount,
      isActive: isActive ?? this.isActive,
      isRecurring: isRecurring ?? this.isRecurring,
      lastProcessedDate: lastProcessedDate ?? this.lastProcessedDate,
      nextProcessedDate: nextProcessedDate ?? this.nextProcessedDate,
    );
  }
}
