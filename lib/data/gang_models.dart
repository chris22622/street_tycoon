

enum GangReputation {
  unknown,
  respected,
  feared,
  legendary,
  mythical
}

class PlayerGang {
  final String name;
  final String? description;
  final GangReputation reputation;
  final int members;
  final int loyalty;
  final int power;
  final int territoriesControlled;
  final Map<String, int> relationships; // Gang ID -> relationship score (-100 to 100)
  final List<String> allies;
  final List<String> enemies;
  final int totalWins;
  final int totalLosses;
  final int totalKills;
  final int totalRevenue;
  final Map<String, dynamic> stats;
  final DateTime founded;
  final DateTime lastActive;

  const PlayerGang({
    required this.name,
    this.description,
    this.reputation = GangReputation.unknown,
    this.members = 1,
    this.loyalty = 50,
    this.power = 10,
    this.territoriesControlled = 0,
    this.relationships = const {},
    this.allies = const [],
    this.enemies = const [],
    this.totalWins = 0,
    this.totalLosses = 0,
    this.totalKills = 0,
    this.totalRevenue = 0,
    this.stats = const {},
    required this.founded,
    required this.lastActive,
  });

  PlayerGang copyWith({
    String? name,
    String? description,
    GangReputation? reputation,
    int? members,
    int? loyalty,
    int? power,
    int? territoriesControlled,
    Map<String, int>? relationships,
    List<String>? allies,
    List<String>? enemies,
    int? totalWins,
    int? totalLosses,
    int? totalKills,
    int? totalRevenue,
    Map<String, dynamic>? stats,
    DateTime? founded,
    DateTime? lastActive,
  }) {
    return PlayerGang(
      name: name ?? this.name,
      description: description ?? this.description,
      reputation: reputation ?? this.reputation,
      members: members ?? this.members,
      loyalty: loyalty ?? this.loyalty,
      power: power ?? this.power,
      territoriesControlled: territoriesControlled ?? this.territoriesControlled,
      relationships: relationships ?? this.relationships,
      allies: allies ?? this.allies,
      enemies: enemies ?? this.enemies,
      totalWins: totalWins ?? this.totalWins,
      totalLosses: totalLosses ?? this.totalLosses,
      totalKills: totalKills ?? this.totalKills,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      stats: stats ?? this.stats,
      founded: founded ?? this.founded,
      lastActive: lastActive ?? this.lastActive,
    );
  }

  static PlayerGang initial(String gangName) {
    final now = DateTime.now();
    return PlayerGang(
      name: gangName,
      description: 'A rising criminal organization',
      reputation: GangReputation.unknown,
      members: 1,
      loyalty: 50,
      power: 10,
      territoriesControlled: 0,
      relationships: {},
      allies: [],
      enemies: [],
      totalWins: 0,
      totalLosses: 0,
      totalKills: 0,
      totalRevenue: 0,
      stats: {
        'operations_completed': 0,
        'territories_conquered': 0,
        'rivals_defeated': 0,
        'respect_earned': 0,
      },
      founded: now,
      lastActive: now,
    );
  }

  String get reputationLabel {
    switch (reputation) {
      case GangReputation.unknown:
        return 'Unknown';
      case GangReputation.respected:
        return 'Respected';
      case GangReputation.feared:
        return 'Feared';
      case GangReputation.legendary:
        return 'Legendary';
      case GangReputation.mythical:
        return 'Mythical';
    }
  }

  String get reputationIcon {
    switch (reputation) {
      case GangReputation.unknown:
        return '🔰';
      case GangReputation.respected:
        return '⭐';
      case GangReputation.feared:
        return '💀';
      case GangReputation.legendary:
        return '👑';
      case GangReputation.mythical:
        return '🏆';
    }
  }

  double get winRate {
    final totalBattles = totalWins + totalLosses;
    return totalBattles > 0 ? totalWins / totalBattles : 0.0;
  }

  int get totalBattles => totalWins + totalLosses;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'reputation': reputation.index,
      'members': members,
      'loyalty': loyalty,
      'power': power,
      'territoriesControlled': territoriesControlled,
      'relationships': relationships,
      'allies': allies,
      'enemies': enemies,
      'totalWins': totalWins,
      'totalLosses': totalLosses,
      'totalKills': totalKills,
      'totalRevenue': totalRevenue,
      'stats': stats,
      'founded': founded.millisecondsSinceEpoch,
      'lastActive': lastActive.millisecondsSinceEpoch,
    };
  }

  factory PlayerGang.fromJson(Map<String, dynamic> json) {
    return PlayerGang(
      name: json['name'] ?? 'Unnamed Gang',
      description: json['description'],
      reputation: GangReputation.values[json['reputation'] ?? 0],
      members: json['members'] ?? 1,
      loyalty: json['loyalty'] ?? 50,
      power: json['power'] ?? 10,
      territoriesControlled: json['territoriesControlled'] ?? 0,
      relationships: Map<String, int>.from(json['relationships'] ?? {}),
      allies: List<String>.from(json['allies'] ?? []),
      enemies: List<String>.from(json['enemies'] ?? []),
      totalWins: json['totalWins'] ?? 0,
      totalLosses: json['totalLosses'] ?? 0,
      totalKills: json['totalKills'] ?? 0,
      totalRevenue: json['totalRevenue'] ?? 0,
      stats: Map<String, dynamic>.from(json['stats'] ?? {}),
      founded: DateTime.fromMillisecondsSinceEpoch(json['founded'] ?? DateTime.now().millisecondsSinceEpoch),
      lastActive: DateTime.fromMillisecondsSinceEpoch(json['lastActive'] ?? DateTime.now().millisecondsSinceEpoch),
    );
  }
}

class RivalGang {
  final String id;
  final String name;
  final String leader;
  final String territory;
  final String icon;
  final int strength;
  final int reputation;
  final int territoryControl;
  final List<String> controlledAreas;
  final bool isHostile;
  final int relationship; // -100 to 100
  final Map<String, dynamic> operations;

  const RivalGang({
    required this.id,
    required this.name,
    required this.leader,
    required this.territory,
    required this.icon,
    required this.strength,
    required this.reputation,
    required this.territoryControl,
    required this.controlledAreas,
    this.isHostile = false,
    this.relationship = 0,
    this.operations = const {},
  });

  static const List<RivalGang> defaultRivals = [
    RivalGang(
      id: 'bloods',
      name: 'Blood Diamond Cartel',
      leader: 'Martinez "El Jefe" Rodriguez',
      territory: 'South Side',
      icon: '🩸',
      strength: 85,
      reputation: 90,
      territoryControl: 3,
      controlledAreas: ['South Park', 'Industrial District', 'Port Area'],
      isHostile: true,
      relationship: -60,
      operations: {'drug_trafficking': 80, 'weapons_smuggling': 70, 'protection_racket': 90},
    ),
    RivalGang(
      id: 'triads',
      name: 'Golden Dragon Triad',
      leader: 'Li Wei "Golden Dragon"',
      territory: 'Chinatown',
      icon: '🐉',
      strength: 78,
      reputation: 85,
      territoryControl: 2,
      controlledAreas: ['Chinatown', 'Financial District'],
      isHostile: false,
      relationship: -20,
      operations: {'money_laundering': 95, 'human_trafficking': 60, 'cybercrime': 85},
    ),
    RivalGang(
      id: 'russians',
      name: 'Red Star Bratva',
      leader: 'Viktor "The Bear" Volkov',
      territory: 'North District',
      icon: '⭐',
      strength: 88,
      reputation: 75,
      territoryControl: 2,
      controlledAreas: ['North District', 'Warehouse Quarter'],
      isHostile: true,
      relationship: -75,
      operations: {'arms_dealing': 90, 'contract_killing': 85, 'extortion': 80},
    ),
    RivalGang(
      id: 'italians',
      name: 'Cosa Nostra Family',
      leader: 'Anthony "Big Tony" Moretti',
      territory: 'Little Italy',
      icon: '🏛️',
      strength: 82,
      reputation: 95,
      territoryControl: 3,
      controlledAreas: ['Little Italy', 'Docks', 'Casino Strip'],
      isHostile: false,
      relationship: 10,
      operations: {'gambling': 95, 'loan_sharking': 90, 'construction_racket': 85},
    ),
    RivalGang(
      id: 'bikers',
      name: 'Death Riders MC',
      leader: 'Jake "Iron Wolf" Thompson',
      territory: 'Highway 66',
      icon: '🏍️',
      strength: 70,
      reputation: 65,
      territoryControl: 2,
      controlledAreas: ['Highway Strip', 'Biker Bars'],
      isHostile: false,
      relationship: 25,
      operations: {'drug_manufacturing': 75, 'stolen_goods': 80, 'gun_running': 70},
    ),
  ];
}

class GangWarfare {
  final Map<String, RivalGang> rivals;
  final List<String> activeConflicts;
  final Map<String, int> territoryDisputes;
  final int totalWars;
  final int totalVictories;
  final DateTime lastWarfare;

  const GangWarfare({
    this.rivals = const {},
    this.activeConflicts = const [],
    this.territoryDisputes = const {},
    this.totalWars = 0,
    this.totalVictories = 0,
    required this.lastWarfare,
  });

  static GangWarfare initial() {
    final rivals = <String, RivalGang>{};
    for (final rival in RivalGang.defaultRivals) {
      rivals[rival.id] = rival;
    }
    
    return GangWarfare(
      rivals: rivals,
      activeConflicts: [],
      territoryDisputes: {},
      totalWars: 0,
      totalVictories: 0,
      lastWarfare: DateTime.now(),
    );
  }

  GangWarfare copyWith({
    Map<String, RivalGang>? rivals,
    List<String>? activeConflicts,
    Map<String, int>? territoryDisputes,
    int? totalWars,
    int? totalVictories,
    DateTime? lastWarfare,
  }) {
    return GangWarfare(
      rivals: rivals ?? this.rivals,
      activeConflicts: activeConflicts ?? this.activeConflicts,
      territoryDisputes: territoryDisputes ?? this.territoryDisputes,
      totalWars: totalWars ?? this.totalWars,
      totalVictories: totalVictories ?? this.totalVictories,
      lastWarfare: lastWarfare ?? this.lastWarfare,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rivals': rivals.map((key, value) => MapEntry(key, {
        'id': value.id,
        'name': value.name,
        'leader': value.leader,
        'territory': value.territory,
        'icon': value.icon,
        'strength': value.strength,
        'reputation': value.reputation,
        'territoryControl': value.territoryControl,
        'controlledAreas': value.controlledAreas,
        'isHostile': value.isHostile,
        'relationship': value.relationship,
        'operations': value.operations,
      })),
      'activeConflicts': activeConflicts,
      'territoryDisputes': territoryDisputes,
      'totalWars': totalWars,
      'totalVictories': totalVictories,
      'lastWarfare': lastWarfare.millisecondsSinceEpoch,
    };
  }

  factory GangWarfare.fromJson(Map<String, dynamic> json) {
    final rivalsData = json['rivals'] as Map<String, dynamic>? ?? {};
    final rivals = <String, RivalGang>{};
    
    for (final entry in rivalsData.entries) {
      final data = entry.value as Map<String, dynamic>;
      rivals[entry.key] = RivalGang(
        id: data['id'] ?? entry.key,
        name: data['name'] ?? 'Unknown Gang',
        leader: data['leader'] ?? 'Unknown',
        territory: data['territory'] ?? 'Unknown',
        icon: data['icon'] ?? '🏴‍☠️',
        strength: data['strength'] ?? 50,
        reputation: data['reputation'] ?? 50,
        territoryControl: data['territoryControl'] ?? 1,
        controlledAreas: List<String>.from(data['controlledAreas'] ?? []),
        isHostile: data['isHostile'] ?? false,
        relationship: data['relationship'] ?? 0,
        operations: Map<String, dynamic>.from(data['operations'] ?? {}),
      );
    }

    return GangWarfare(
      rivals: rivals,
      activeConflicts: List<String>.from(json['activeConflicts'] ?? []),
      territoryDisputes: Map<String, int>.from(json['territoryDisputes'] ?? {}),
      totalWars: json['totalWars'] ?? 0,
      totalVictories: json['totalVictories'] ?? 0,
      lastWarfare: DateTime.fromMillisecondsSinceEpoch(json['lastWarfare'] ?? DateTime.now().millisecondsSinceEpoch),
    );
  }
}
