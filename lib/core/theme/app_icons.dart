import 'package:flutter/material.dart';

class AppIcons {
  // Finance Icons
  static const financeIcons = [
    Icons.wallet,
    Icons.money,
    Icons.account_balance,
    Icons.credit_card,
    Icons.loyalty,
    Icons.card_membership,
    Icons.bar_chart,
    Icons.leaderboard,
  ];

  // Shopping Icons
  static const shoppingIcons = [
    Icons.shopping_bag,
    Icons.shopping_cart,
    Icons.store,
    Icons.local_mall,
    Icons.local_grocery_store,
  ];

  // Food Icons
  static const foodIcons = [
    Icons.fastfood,
    Icons.restaurant,
    Icons.restaurant_menu,
    Icons.cookie,
    Icons.local_dining,
    Icons.local_cafe,
  ];

  // Health Icons
  static const healthIcons = [
    Icons.health_and_safety,
    Icons.monitor_heart,
    Icons.medication,
    Icons.medication_liquid,
    Icons.favorite,
    Icons.favorite_border,
  ];

  // Work Icons
  static const workIcons = [
    Icons.work,
    Icons.workspaces,
    Icons.business,
    Icons.domain,
    Icons.engineering,
    Icons.computer,
  ];

  // Social Icons
  static const socialIcons = [
    Icons.people,
    Icons.person,
    Icons.diversity_3,
    Icons.handshake,
    Icons.emoji_people,
    Icons.groups,
  ];

  // Entertainment Icons
  static const entertainmentIcons = [
    Icons.celebration,
    Icons.stars,
    Icons.movie,
    Icons.music_note,
    Icons.sports_esports,
    Icons.sports_soccer,
  ];

  // All Icons
  static List<IconData> get allIcons => [
        ...financeIcons,
        ...shoppingIcons,
        ...foodIcons,
        ...healthIcons,
        ...workIcons,
        ...socialIcons,
        ...entertainmentIcons,
      ];

  // Get icon by category
  static List<IconData> getIconsByCategory(String category) {
    switch (category.toLowerCase()) {
      case 'finance':
        return financeIcons;
      case 'shopping':
        return shoppingIcons;
      case 'food':
        return foodIcons;
      case 'health':
        return healthIcons;
      case 'work':
        return workIcons;
      case 'social':
        return socialIcons;
      case 'entertainment':
        return entertainmentIcons;
      default:
        return allIcons;
    }
  }

  // Get random icon
  static IconData getRandomIcon() {
    final random = DateTime.now().millisecondsSinceEpoch % allIcons.length;
    return allIcons[random];
  }

  // Get icon by name (case-insensitive)
  static IconData? getIconByName(String name) {
    final iconName = name.toLowerCase().replaceAll(' ', '_');
    print('🔍 AppIcons.getIconByName: Looking for icon: $iconName');

    // Map of icon names to IconData
    final iconMap = {
      // Finance Icons
      'wallet': Icons.wallet,
      'money': Icons.money,
      'account_balance': Icons.account_balance,
      'credit_card': Icons.credit_card,
      'loyalty': Icons.loyalty,
      'card_membership': Icons.card_membership,
      'bar_chart': Icons.bar_chart,
      'leaderboard': Icons.leaderboard,

      // Shopping Icons
      'shopping_bag': Icons.shopping_bag,
      'shopping_cart': Icons.shopping_cart,
      'store': Icons.store,
      'local_mall': Icons.local_mall,
      'local_grocery_store': Icons.local_grocery_store,

      // Food Icons
      'fastfood': Icons.fastfood,
      'restaurant': Icons.restaurant,
      'restaurant_menu': Icons.restaurant_menu,
      'cookie': Icons.cookie,
      'local_dining': Icons.local_dining,
      'local_cafe': Icons.local_cafe,

      // Health Icons
      'health_and_safety': Icons.health_and_safety,
      'monitor_heart': Icons.monitor_heart,
      'medication': Icons.medication,
      'medication_liquid': Icons.medication_liquid,
      'favorite': Icons.favorite,
      'favorite_border': Icons.favorite_border,

      // Work Icons
      'work': Icons.work,
      'workspaces': Icons.workspaces,
      'business': Icons.business,
      'domain': Icons.domain,
      'engineering': Icons.engineering,
      'computer': Icons.computer,

      // Social Icons
      'people': Icons.people,
      'person': Icons.person,
      'diversity_3': Icons.diversity_3,
      'handshake': Icons.handshake,
      'emoji_people': Icons.emoji_people,
      'groups': Icons.groups,

      // Entertainment Icons
      'celebration': Icons.celebration,
      'stars': Icons.stars,
      'movie': Icons.movie,
      'music_note': Icons.music_note,
      'sports_esports': Icons.sports_esports,
      'sports_soccer': Icons.sports_soccer,
    };

    final icon = iconMap[iconName];
    if (icon == null) {
      print('⚠️ AppIcons.getIconByName: No icon found for name: $iconName');
      return Icons.category;
    }
    print('✅ AppIcons.getIconByName: Found icon: $icon');
    return icon;
  }
}
