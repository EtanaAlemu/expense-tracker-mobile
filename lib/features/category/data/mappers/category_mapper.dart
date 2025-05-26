import 'package:expense_tracker/features/category/data/models/hive_category_model.dart';
import 'package:expense_tracker/features/category/domain/entities/category.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/core/theme/app_icons.dart';

class CategoryMapper {
  Category toEntity(dynamic model) {
    if (model is HiveCategoryModel) {
      final iconName = model.icon;
      final parsedIcon = _parseIcon(iconName);

      return Category(
        id: model.id ?? '',
        name: model.name,
        type: model.type,
        color: Color(model.color ?? 0xFF000000),
        icon: parsedIcon,
        budget: model.budget,
        description: model.description,
        createdAt: model.createdAt ?? DateTime.now(),
        updatedAt: model.updatedAt ?? DateTime.now(),
        userId: model.userId,
        isDefault: model.isDefault,
        isSynced: model.isSynced,
        isUpdated: model.isUpdated,
        isDeleted: model.isDeleted,
        transactionType: model.transactionType,
        frequency: model.frequency,
        defaultAmount: model.defaultAmount,
        isActive: model.isActive ?? true,
        isRecurring: model.isRecurring ?? false,
        lastProcessedDate: model.lastProcessedDate,
        nextProcessedDate: model.nextProcessedDate,
      );
    } else if (model is Map<String, dynamic>) {
      final iconName = model['icon'] as String?;
      final parsedIcon = _parseIcon(iconName);

      return Category(
        id: model['_id']?.toString() ?? '',
        name: model['name'] ?? '',
        type: model['type'] ?? '',
        color: _parseColor(model['color']),
        icon: parsedIcon,
        budget: model['budget']?.toDouble(),
        description: model['description'],
        createdAt: model['createdAt'] != null
            ? DateTime.parse(model['createdAt'])
            : DateTime.now(),
        updatedAt: model['updatedAt'] != null
            ? DateTime.parse(model['updatedAt'])
            : DateTime.now(),
        userId: model['user'] ?? '',
        isDefault: model['isDefault'] ?? false,
        isSynced: true, // API responses are always synced
        isUpdated: false, // API responses are never updated
        isDeleted: false, // API responses are never deleted
        transactionType: model['transactionType'] ?? '',
        frequency: model['frequency'],
        defaultAmount: model['defaultAmount']?.toDouble(),
        isActive: model['isActive'] ?? true,
        isRecurring: model['isRecurring'] ?? false,
        lastProcessedDate: model['lastProcessedDate'] != null
            ? DateTime.parse(model['lastProcessedDate'])
            : null,
        nextProcessedDate: model['nextProcessedDate'] != null
            ? DateTime.parse(model['nextProcessedDate'])
            : null,
      );
    }
    throw Exception('Invalid model type');
  }

  HiveCategoryModel toHiveModel(Category category) {
    final iconName = _getIconName(category.icon);

    return HiveCategoryModel(
      id: category.id,
      name: category.name,
      type: category.type,
      color: category.color.value,
      icon: iconName,
      budget: category.budget,
      description: category.description,
      createdAt: category.createdAt,
      updatedAt: category.updatedAt,
      userId: category.userId,
      isDefault: category.isDefault,
      transactionType: category.transactionType,
      frequency: category.frequency,
      defaultAmount: category.defaultAmount,
      isActive: category.isActive,
      isRecurring: category.isRecurring,
      lastProcessedDate: category.lastProcessedDate,
      nextProcessedDate: category.nextProcessedDate,
      isSynced: category.isSynced,
      isUpdated: category.isUpdated,
      isDeleted: category.isDeleted,
    );
  }

  Map<String, dynamic> toApiModel(Category category) {
    debugPrint('📤 Converting category to API model: ${category.name}');
    final model = {
      'name': category.name,
      'description': category.description,
      'icon': _getIconName(category.icon),
      'color': '#${category.color.value.toRadixString(16).substring(2)}',
      'type': category.type,
      'budget': category.budget,
      'user': category.userId,
      'isDefault': category.isDefault,
      'transactionType': category.transactionType,
      'frequency': category.frequency,
      'defaultAmount': category.defaultAmount,
      'isActive': category.isActive,
      'isRecurring': category.isRecurring,
      'lastProcessedDate': category.lastProcessedDate?.toIso8601String(),
      'nextProcessedDate': category.nextProcessedDate?.toIso8601String(),
      'isUpdated': category.isUpdated,
      'isDeleted': category.isDeleted,
    };

    // Only include _id if it's not empty
    if (category.id.isNotEmpty) {
      model['_id'] = category.id;
    }

    debugPrint('📤 API model: $model');
    return model;
  }

  String _getIconName(IconData icon) {
    // Map of IconData to icon names based on AppIcons class
    final iconMap = {
      // Finance Icons
      Icons.wallet: 'wallet',
      Icons.money: 'money',
      Icons.account_balance: 'account_balance',
      Icons.credit_card: 'credit_card',
      Icons.loyalty: 'loyalty',
      Icons.card_membership: 'card_membership',
      Icons.bar_chart: 'bar_chart',
      Icons.leaderboard: 'leaderboard',

      // Shopping Icons
      Icons.shopping_bag: 'shopping_bag',
      Icons.shopping_cart: 'shopping_cart',
      Icons.store: 'store',
      Icons.local_mall: 'local_mall',
      Icons.local_grocery_store: 'local_grocery_store',

      // Food Icons
      Icons.fastfood: 'fastfood',
      Icons.restaurant: 'restaurant',
      Icons.restaurant_menu: 'restaurant_menu',
      Icons.cookie: 'cookie',
      Icons.local_dining: 'local_dining',
      Icons.local_cafe: 'local_cafe',

      // Health Icons
      Icons.health_and_safety: 'health_and_safety',
      Icons.monitor_heart: 'monitor_heart',
      Icons.medication: 'medication',
      Icons.medication_liquid: 'medication_liquid',
      Icons.favorite: 'favorite',
      Icons.favorite_border: 'favorite_border',

      // Work Icons
      Icons.work: 'work',
      Icons.workspaces: 'workspaces',
      Icons.business: 'business',
      Icons.domain: 'domain',
      Icons.engineering: 'engineering',
      Icons.computer: 'computer',

      // Social Icons
      Icons.people: 'people',
      Icons.person: 'person',
      Icons.diversity_3: 'diversity_3',
      Icons.handshake: 'handshake',
      Icons.emoji_people: 'emoji_people',
      Icons.groups: 'groups',

      // Entertainment Icons
      Icons.celebration: 'celebration',
      Icons.stars: 'stars',
      Icons.movie: 'movie',
      Icons.music_note: 'music_note',
      Icons.sports_esports: 'sports_esports',
      Icons.sports_soccer: 'sports_soccer',
    };

    final iconName = iconMap[icon];
    if (iconName == null) {
      return 'category';
    }
    return iconName;
  }

  Color _parseColor(String? colorString) {
    if (colorString == null) return Colors.blue;
    try {
      return Color(int.parse(colorString.replaceAll('#', '0xFF')));
    } catch (e) {
      return Colors.blue;
    }
  }

  IconData _parseIcon(String? iconName) {
    if (iconName == null) {
      return Icons.category;
    }

    final icon = AppIcons.getIconByName(iconName);
    if (icon == null) {
      return Icons.category;
    }
    return icon;
  }

  Map<String, dynamic> toJson(Category category) {
    return {
      '_id': category.id,
      'name': category.name,
      'description': category.description,
      'icon': category.icon,
      'color': category.color,
      'type': category.type,
      'isDefault': category.isDefault,
      'createdAt': category.createdAt.toIso8601String(),
      'updatedAt': category.updatedAt.toIso8601String(),
      'isUpdated': category.isUpdated,
      'isDeleted': category.isDeleted,
    };
  }
}
