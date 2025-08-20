import 'dart:math';

class Mission {
  final String id;
  final String title;
  final String description;
  final String difficulty;
  final String icon;
  final Map<String, dynamic> objectives;
  final Map<String, dynamic> rewards;
  final int timeLimit; // days
  final List<String> prerequisites;
  final bool isActive;
  final bool isCompleted;
  final DateTime? startedAt;

  const Mission({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.icon,
    required this.objectives,
    required this.rewards,
    this.timeLimit = 0, // 0 = no limit
    this.prerequisites = const [],
    this.isActive = false,
    this.isCompleted = false,
    this.startedAt,
  });

  Mission copyWith({
    String? id,
    String? title,
    String? description,
    String? difficulty,
    String? icon,
    Map<String, dynamic>? objectives,
    Map<String, dynamic>? rewards,
    int? timeLimit,
    List<String>? prerequisites,
    bool? isActive,
    bool? isCompleted,
    DateTime? startedAt,
  }) {
    return Mission(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      difficulty: difficulty ?? this.difficulty,
      icon: icon ?? this.icon,
      objectives: objectives ?? this.objectives,
      rewards: rewards ?? this.rewards,
      timeLimit: timeLimit ?? this.timeLimit,
      prerequisites: prerequisites ?? this.prerequisites,
      isActive: isActive ?? this.isActive,
      isCompleted: isCompleted ?? this.isCompleted,
      startedAt: startedAt ?? this.startedAt,
    );
  }
}

class MissionService {
  static List<Mission> getAvailableMissions() {
    return [
      // Beginner Missions
      const Mission(
        id: 'first_steps',
        title: 'First Steps',
        description: 'Complete your first 5 transactions to learn the ropes',
        difficulty: 'Easy',
        icon: '👟',
        objectives: {
          'totalTransactions': 5,
        },
        rewards: {
          'cash': 500,
          'experience': 100,
        },
      ),
      
      const Mission(
        id: 'area_explorer',
        title: 'Area Explorer',
        description: 'Visit all 6 areas to scout the market',
        difficulty: 'Easy',
        icon: '🗺️',
        objectives: {
          'areasVisited': 6,
        },
        rewards: {
          'cash': 1000,
          'capacityUpgrade': 10,
        },
      ),
      
      // Intermediate Missions
      const Mission(
        id: 'high_roller',
        title: 'High Roller',
        description: 'Make a single transaction worth \$5,000 or more',
        difficulty: 'Medium',
        icon: '💸',
        objectives: {
          'singleTransactionValue': 5000,
        },
        rewards: {
          'cash': 2500,
          'heatReduction': 20,
        },
        prerequisites: ['first_steps'],
      ),
      
      const Mission(
        id: 'market_master',
        title: 'Market Master',
        description: 'Achieve \$25,000 in total profit',
        difficulty: 'Medium',
        icon: '📈',
        objectives: {
          'totalProfit': 25000,
        },
        rewards: {
          'cash': 5000,
          'permanentCapacityBonus': 15,
        },
        prerequisites: ['area_explorer'],
      ),
      
      const Mission(
        id: 'heat_survivor',
        title: 'Heat Survivor',
        description: 'Survive 3 days with heat above 80',
        difficulty: 'Medium',
        icon: '🔥',
        objectives: {
          'highHeatDays': 3,
        },
        rewards: {
          'cash': 3000,
          'heatResistance': 10,
        },
      ),
      
      // Advanced Missions
      const Mission(
        id: 'kingpin',
        title: 'Street Kingpin',
        description: 'Reach \$100,000 net worth',
        difficulty: 'Hard',
        icon: '👑',
        objectives: {
          'netWorth': 100000,
        },
        rewards: {
          'cash': 20000,
          'prestigePoints': 50,
          'unlockSpecialItems': true,
        },
        prerequisites: ['market_master'],
      ),
      
      const Mission(
        id: 'speed_demon',
        title: 'Speed Demon',
        description: 'Complete 50 transactions in a single day',
        difficulty: 'Hard',
        icon: '⚡',
        objectives: {
          'transactionsPerDay': 50,
        },
        rewards: {
          'cash': 10000,
          'quickTradeBonus': true,
        },
        timeLimit: 1,
      ),
      
      const Mission(
        id: 'monopolist',
        title: 'Monopolist',
        description: 'Control 80% market share in any area for 5 days',
        difficulty: 'Hard',
        icon: '🏆',
        objectives: {
          'marketDominanceDays': 5,
          'marketShareRequired': 0.8,
        },
        rewards: {
          'cash': 25000,
          'areaDiscountPermanent': 0.1,
        },
        timeLimit: 10,
        prerequisites: ['kingpin'],
      ),
      
      // Special/Weekly Missions
      const Mission(
        id: 'weekend_warrior',
        title: 'Weekend Warrior',
        description: 'Make \$15,000 profit during weekend (days 6-7, 13-14, etc.)',
        difficulty: 'Medium',
        icon: '🎮',
        objectives: {
          'weekendProfit': 15000,
        },
        rewards: {
          'cash': 7500,
          'weekendBonusPermanent': 1.2,
        },
        timeLimit: 2,
      ),
      
      const Mission(
        id: 'ghost_trader',
        title: 'Ghost Trader',
        description: 'Complete 20 transactions without gaining any heat',
        difficulty: 'Hard',
        icon: '👻',
        objectives: {
          'zeroHeatTransactions': 20,
        },
        rewards: {
          'cash': 15000,
          'stealthMode': true,
        },
      ),
    ];
  }
  
  static bool checkMissionProgress(Mission mission, Map<String, dynamic> gameStats) {
    for (var objective in mission.objectives.entries) {
      final required = objective.value;
      final current = gameStats[objective.key] ?? 0;
      
      if (current < required) {
        return false;
      }
    }
    return true;
  }
  
  static List<Mission> getAvailableMissionsForPlayer(
    Map<String, dynamic> gameStats,
    Set<String> completedMissions,
    List<Mission> activeMissions,
  ) {
    final allMissions = getAvailableMissions();
    final available = <Mission>[];
    
    for (var mission in allMissions) {
      // Skip if already completed or active
      if (completedMissions.contains(mission.id) ||
          activeMissions.any((m) => m.id == mission.id)) {
        continue;
      }
      
      // Check prerequisites
      bool prerequisitesMet = true;
      for (var prereq in mission.prerequisites) {
        if (!completedMissions.contains(prereq)) {
          prerequisitesMet = false;
          break;
        }
      }
      
      if (prerequisitesMet) {
        available.add(mission);
      }
    }
    
    return available;
  }
  
  static Mission? getRandomMission(List<Mission> availableMissions) {
    if (availableMissions.isEmpty) return null;
    
    final random = Random();
    return availableMissions[random.nextInt(availableMissions.length)];
  }
  
  static Map<String, dynamic> calculateRewards(Mission mission) {
    final rewards = Map<String, dynamic>.from(mission.rewards);
    
    // Bonus rewards based on difficulty
    switch (mission.difficulty) {
      case 'Medium':
        rewards['experience'] = (rewards['experience'] ?? 0) + 50;
        break;
      case 'Hard':
        rewards['experience'] = (rewards['experience'] ?? 0) + 100;
        rewards['prestigePoints'] = (rewards['prestigePoints'] ?? 0) + 10;
        break;
    }
    
    return rewards;
  }
}
