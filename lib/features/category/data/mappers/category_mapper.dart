import 'package:expense_tracker/features/category/data/models/hive_category_model.dart';
import 'package:expense_tracker/features/category/domain/entities/category.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/core/theme/app_icons.dart';

class CategoryMapper {
  Category toEntity(dynamic model) {
    if (model is HiveCategoryModel) {
      print('🔍 Parsing Hive model: ${model.icon}');
      final iconName = model.icon;
      print('🎯 Icon name from Hive: $iconName');
      final parsedIcon = _parseIcon(iconName);
      print('🎨 Parsed icon: $parsedIcon');

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
        isSynced: false,
      );
    } else {
      // Handle API response
      print('🔍 Parsing API response: $model');
      final iconName = model['icon'] as String?;
      print('🎯 Icon name from API: $iconName');
      final parsedIcon = _parseIcon(iconName);
      print('🎨 Parsed icon: $parsedIcon');

      return Category(
        id: model['_id'] ?? '',
        name: model['name'] ?? '',
        type: model['type'] ?? 'Expense',
        color: _parseColor(model['color']),
        icon: parsedIcon,
        budget: model['budget'] != null
            ? double.parse(model['budget'].toString())
            : null,
        description: model['description'],
        createdAt: DateTime.parse(
            model['createdAt'] ?? DateTime.now().toIso8601String()),
        updatedAt: DateTime.parse(
            model['updatedAt'] ?? DateTime.now().toIso8601String()),
        userId: model['userId'] ?? '',
        isDefault: model['isDefault'] ?? false,
        isSynced: true,
      );
    }
  }

  HiveCategoryModel toHiveModel(Category category) {
    final iconName = _getIconName(category.icon);
    print('💾 Saving icon name to Hive: $iconName');

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
    );
  }

  Map<String, dynamic> toApiModel(Category category) {
    return {
      'name': category.name,
      'description': category.description,
      'icon': _getIconName(category.icon),
      'color': '#${category.color.value.toRadixString(16).substring(2)}',
      'type': category.type,
      'budget': category.budget,
      'userId': category.userId,
      'isDefault': category.isDefault,
    };
  }

  String _getIconName(IconData icon) {
    print('🔍 CategoryMapper._getIconName: Looking for name of icon: $icon');

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
      print('⚠️ CategoryMapper._getIconName: No name found for icon: $icon');
      return 'category';
    }
    print('✅ CategoryMapper._getIconName: Found name: $iconName');
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
      print('⚠️ Icon name is null, using default icon');
      return Icons.category;
    }

    print('🔍 Looking up icon for name: $iconName');
    final icon = AppIcons.getIconByName(iconName);
    if (icon == null) {
      print('⚠️ No icon found for name: $iconName, using default icon');
      return Icons.category;
    }
    print('✅ Found icon: $icon');
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
    };
  }
}
