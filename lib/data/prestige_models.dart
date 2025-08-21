enum PrestigeLevel {
  amateur,
  professional,
  kingpin,
  legend,
}

extension PrestigeLevelExtension on PrestigeLevel {
  String get name {
    switch (this) {
      case PrestigeLevel.amateur:
        return 'Amateur';
      case PrestigeLevel.professional:
        return 'Professional';
      case PrestigeLevel.kingpin:
        return 'Kingpin';
      case PrestigeLevel.legend:
        return 'Legend';
    }
  }

  String get icon {
    switch (this) {
      case PrestigeLevel.amateur:
        return '🥉';
      case PrestigeLevel.professional:
        return '🥈';
      case PrestigeLevel.kingpin:
        return '🥇';
      case PrestigeLevel.legend:
        return '👑';
    }
  }

  int get requiredReputation {
    switch (this) {
      case PrestigeLevel.amateur:
        return 0;
      case PrestigeLevel.professional:
        return 1000;
      case PrestigeLevel.kingpin:
        return 5000;
      case PrestigeLevel.legend:
        return 15000;
    }
  }

  double get bonusMultiplier {
    switch (this) {
      case PrestigeLevel.amateur:
        return 1.0;
      case PrestigeLevel.professional:
        return 1.1; // 10% bonus
      case PrestigeLevel.kingpin:
        return 1.25; // 25% bonus
      case PrestigeLevel.legend:
        return 1.5; // 50% bonus
    }
  }

  List<String> get perks {
    switch (this) {
      case PrestigeLevel.amateur:
        return ['Basic operations available'];
      case PrestigeLevel.professional:
        return [
          '+10% all income',
          'Faster crew loyalty gain',
          'Reduced upgrade costs',
        ];
      case PrestigeLevel.kingpin:
        return [
          '+25% all income',
          'Exclusive high-value contracts',
          'Advanced territory options',
          'Elite crew members available',
        ];
      case PrestigeLevel.legend:
        return [
          '+50% all income',
          'Legendary status effects',
          'Maximum territory expansion',
          'Special endgame content',
          'Permanent achievement bonuses',
        ];
    }
  }
}

class PrestigeBonus {
  final String id;
  final String name;
  final String description;
  final int cost; // Reputation cost
  final PrestigeLevel requiredLevel;
  final bool isPermanent;
  final Map<String, double> bonuses; // Stat bonuses

  const PrestigeBonus({
    required this.id,
    required this.name,
    required this.description,
    required this.cost,
    required this.requiredLevel,
    required this.isPermanent,
    required this.bonuses,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'cost': cost,
      'requiredLevel': requiredLevel.name,
      'isPermanent': isPermanent,
      'bonuses': bonuses,
    };
  }

  factory PrestigeBonus.fromJson(Map<String, dynamic> json) {
    return PrestigeBonus(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      cost: json['cost'],
      requiredLevel: PrestigeLevel.values.firstWhere(
        (level) => level.name == json['requiredLevel'],
      ),
      isPermanent: json['isPermanent'],
      bonuses: Map<String, double>.from(json['bonuses']),
    );
  }
}

class PrestigeSystem {
  final int reputation;
  final PrestigeLevel currentLevel;
  final List<String> unlockedBonuses;
  final Map<String, int> achievements; // Achievement -> count
  final int totalPrestigePoints;

  const PrestigeSystem({
    required this.reputation,
    required this.currentLevel,
    required this.unlockedBonuses,
    required this.achievements,
    required this.totalPrestigePoints,
  });

  factory PrestigeSystem.initial() {
    return const PrestigeSystem(
      reputation: 0,
      currentLevel: PrestigeLevel.amateur,
      unlockedBonuses: [],
      achievements: {},
      totalPrestigePoints: 0,
    );
  }

  PrestigeLevel get nextLevel {
    final currentIndex = PrestigeLevel.values.indexOf(currentLevel);
    if (currentIndex < PrestigeLevel.values.length - 1) {
      return PrestigeLevel.values[currentIndex + 1];
    }
    return currentLevel; // Already at max level
  }

  int get reputationToNextLevel {
    final next = nextLevel;
    if (next == currentLevel) return 0; // Already at max
    return next.requiredReputation - reputation;
  }

  double get progressToNextLevel {
    if (nextLevel == currentLevel) return 1.0; // Max level
    final current = currentLevel.requiredReputation;
    final next = nextLevel.requiredReputation;
    return ((reputation - current) / (next - current)).clamp(0.0, 1.0);
  }

  List<PrestigeBonus> get availableBonuses {
    return PrestigeBonusTemplates.all
        .where((bonus) => 
          bonus.requiredLevel.index <= currentLevel.index &&
          !unlockedBonuses.contains(bonus.id))
        .toList();
  }

  double get totalBonusMultiplier {
    double multiplier = currentLevel.bonusMultiplier;
    
    // Add bonuses from unlocked prestige bonuses
    for (final bonusId in unlockedBonuses) {
      final bonus = PrestigeBonusTemplates.all.firstWhere(
        (b) => b.id == bonusId,
        orElse: () => PrestigeBonusTemplates.all.first,
      );
      if (bonus.bonuses.containsKey('income_multiplier')) {
        multiplier += bonus.bonuses['income_multiplier']!;
      }
    }
    
    return multiplier;
  }

  PrestigeSystem copyWith({
    int? reputation,
    PrestigeLevel? currentLevel,
    List<String>? unlockedBonuses,
    Map<String, int>? achievements,
    int? totalPrestigePoints,
  }) {
    return PrestigeSystem(
      reputation: reputation ?? this.reputation,
      currentLevel: currentLevel ?? this.currentLevel,
      unlockedBonuses: unlockedBonuses ?? List.from(this.unlockedBonuses),
      achievements: achievements ?? Map.from(this.achievements),
      totalPrestigePoints: totalPrestigePoints ?? this.totalPrestigePoints,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reputation': reputation,
      'currentLevel': currentLevel.name,
      'unlockedBonuses': unlockedBonuses,
      'achievements': achievements,
      'totalPrestigePoints': totalPrestigePoints,
    };
  }

  factory PrestigeSystem.fromJson(Map<String, dynamic> json) {
    return PrestigeSystem(
      reputation: json['reputation'] ?? 0,
      currentLevel: PrestigeLevel.values.firstWhere(
        (level) => level.name == json['currentLevel'],
        orElse: () => PrestigeLevel.amateur,
      ),
      unlockedBonuses: List<String>.from(json['unlockedBonuses'] ?? []),
      achievements: Map<String, int>.from(json['achievements'] ?? {}),
      totalPrestigePoints: json['totalPrestigePoints'] ?? 0,
    );
  }
}

class PrestigeBonusTemplates {
  static final List<PrestigeBonus> all = [
    const PrestigeBonus(
      id: 'efficient_dealer',
      name: 'Efficient Dealer',
      description: '+5% income from all sales',
      cost: 100,
      requiredLevel: PrestigeLevel.amateur,
      isPermanent: true,
      bonuses: {'income_multiplier': 0.05},
    ),
    const PrestigeBonus(
      id: 'street_connections',
      name: 'Street Connections',
      description: 'Faster crew loyalty gain',
      cost: 150,
      requiredLevel: PrestigeLevel.amateur,
      isPermanent: true,
      bonuses: {'loyalty_gain': 0.25},
    ),
    const PrestigeBonus(
      id: 'territory_expert',
      name: 'Territory Expert',
      description: '+10% territory income',
      cost: 200,
      requiredLevel: PrestigeLevel.professional,
      isPermanent: true,
      bonuses: {'territory_income': 0.10},
    ),
    const PrestigeBonus(
      id: 'federal_insider',
      name: 'Federal Insider',
      description: '15% slower federal heat gain',
      cost: 300,
      requiredLevel: PrestigeLevel.professional,
      isPermanent: true,
      bonuses: {'heat_reduction': 0.15},
    ),
    const PrestigeBonus(
      id: 'kingpin_network',
      name: 'Kingpin Network',
      description: '+20% all income, exclusive contracts',
      cost: 500,
      requiredLevel: PrestigeLevel.kingpin,
      isPermanent: true,
      bonuses: {'income_multiplier': 0.20, 'exclusive_contracts': 1.0},
    ),
    const PrestigeBonus(
      id: 'legendary_status',
      name: 'Legendary Status',
      description: 'All bonuses increased by 25%',
      cost: 1000,
      requiredLevel: PrestigeLevel.legend,
      isPermanent: true,
      bonuses: {'bonus_amplifier': 0.25},
    ),
  ];
}
