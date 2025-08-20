class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    String? icon,
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.millisecondsSinceEpoch,
    };
  }

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      icon: json['icon'],
      isUnlocked: json['isUnlocked'] ?? false,
      unlockedAt: json['unlockedAt'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['unlockedAt'])
          : null,
    );
  }
}

class AchievementService {
  static List<Achievement> getDefaultAchievements() {
    return [
      const Achievement(
        id: 'first_buy',
        title: 'First Purchase',
        description: 'Make your first purchase',
        icon: '🛒',
      ),
      const Achievement(
        id: 'first_sell',
        title: 'First Sale',
        description: 'Make your first sale',
        icon: '💰',
      ),
      const Achievement(
        id: 'big_spender',
        title: 'Big Spender',
        description: 'Spend over \$1,000 in a single transaction',
        icon: '💸',
      ),
      const Achievement(
        id: 'profit_maker',
        title: 'Profit Maker',
        description: 'Earn over \$1,000 in a single transaction',
        icon: '💎',
      ),
      const Achievement(
        id: 'traveler',
        title: 'Street Traveler',
        description: 'Visit all 5 areas',
        icon: '🗺️',
      ),
      const Achievement(
        id: 'capacity_master',
        title: 'Capacity Master',
        description: 'Upgrade your capacity to level 5',
        icon: '🎒',
      ),
      const Achievement(
        id: 'bank_account',
        title: 'Bank Account',
        description: 'Deposit \$10,000 in the bank',
        icon: '🏦',
      ),
      const Achievement(
        id: 'millionaire',
        title: 'Millionaire',
        description: 'Reach \$1,000,000 net worth',
        icon: '👑',
      ),
      const Achievement(
        id: 'survivor',
        title: 'Survivor',
        description: 'Survive 30 days on the streets',
        icon: '🛡️',
      ),
      const Achievement(
        id: 'risk_taker',
        title: 'Risk Taker',
        description: 'Reach maximum heat level',
        icon: '🔥',
      ),
    ];
  }

  static bool checkAchievement(String achievementId, Map<String, dynamic> gameData) {
    switch (achievementId) {
      case 'first_buy':
        return (gameData['totalPurchases'] ?? 0) >= 1;
      case 'first_sell':
        return (gameData['totalSales'] ?? 0) >= 1;
      case 'big_spender':
        return (gameData['largestPurchase'] ?? 0) >= 1000;
      case 'profit_maker':
        return (gameData['largestSale'] ?? 0) >= 1000;
      case 'traveler':
        return (gameData['areasVisited']?.length ?? 0) >= 5;
      case 'capacity_master':
        return (gameData['duffelLevel'] ?? 0) >= 5;
      case 'bank_account':
        return (gameData['maxBankDeposit'] ?? 0) >= 10000;
      case 'millionaire':
        return (gameData['netWorth'] ?? 0) >= 1000000;
      case 'survivor':
        return (gameData['day'] ?? 1) >= 30;
      case 'risk_taker':
        return (gameData['maxHeat'] ?? 0) >= 100;
      default:
        return false;
    }
  }

  static List<Achievement> checkAllAchievements(Map<String, dynamic> gameData, Set<String> unlockedIds) {
    final newlyUnlocked = <Achievement>[];
    final achievements = getDefaultAchievements();
    
    for (var achievement in achievements) {
      if (!unlockedIds.contains(achievement.id) && checkAchievement(achievement.id, gameData)) {
        newlyUnlocked.add(achievement.copyWith(
          isUnlocked: true,
          unlockedAt: DateTime.now(),
        ));
      }
    }
    
    return newlyUnlocked;
  }
}
