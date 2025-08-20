import 'dart:convert';

class GameState {
  final int day;
  final int daysLimit;
  final String area;
  final int cash;
  final int bank;
  final int capacity;
  final int heat;
  final int goalNetWorth;
  final Map<String, int> stash;
  final Map<String, double> trend;
  final Map<String, int> upgrades;
  final List<RapEntry> rapSheet;
  final Map<String, int> habits;
  final Map<String, dynamic> settings;
  final Map<String, dynamic> statistics;
  final Set<String> unlockedAchievements;
  final Map<String, int> weapons;
  final bool inPrison;
  final Map<String, dynamic> prisonData;

  const GameState({
    required this.day,
    required this.daysLimit,
    required this.area,
    required this.cash,
    required this.bank,
    required this.capacity,
    required this.heat,
    required this.goalNetWorth,
    required this.stash,
    required this.trend,
    required this.upgrades,
    required this.rapSheet,
    required this.habits,
    required this.settings,
    required this.statistics,
    this.unlockedAchievements = const {},
    this.weapons = const {},
    this.inPrison = false,
    this.prisonData = const {},
  });

  GameState copyWith({
    int? day,
    int? daysLimit,
    String? area,
    int? cash,
    int? bank,
    int? capacity,
    int? heat,
    int? goalNetWorth,
    Map<String, int>? stash,
    Map<String, double>? trend,
    Map<String, int>? upgrades,
    List<RapEntry>? rapSheet,
    Map<String, int>? habits,
    Map<String, dynamic>? settings,
    Map<String, dynamic>? statistics,
    Set<String>? unlockedAchievements,
    Map<String, int>? weapons,
    bool? inPrison,
    Map<String, dynamic>? prisonData,
  }) {
    return GameState(
      day: day ?? this.day,
      daysLimit: daysLimit ?? this.daysLimit,
      area: area ?? this.area,
      cash: cash ?? this.cash,
      bank: bank ?? this.bank,
      capacity: capacity ?? this.capacity,
      heat: heat ?? this.heat,
      goalNetWorth: goalNetWorth ?? this.goalNetWorth,
      stash: stash ?? Map.from(this.stash),
      trend: trend ?? Map.from(this.trend),
      upgrades: upgrades ?? Map.from(this.upgrades),
      rapSheet: rapSheet ?? List.from(this.rapSheet),
      habits: habits ?? Map.from(this.habits),
      settings: settings ?? Map.from(this.settings),
      statistics: statistics ?? Map.from(this.statistics),
      unlockedAchievements: unlockedAchievements ?? Set.from(this.unlockedAchievements),
      weapons: weapons ?? Map.from(this.weapons),
      inPrison: inPrison ?? this.inPrison,
      prisonData: prisonData ?? Map.from(this.prisonData),
    );
  }

  int get netWorth {
    int stashValue = 0;
    // For net worth calculation, we'd need current prices
    // This is simplified - in real implementation, we'd pass current prices
    return cash + bank + stashValue;
  }

  int get usedCapacity {
    return stash.values.fold(0, (sum, qty) => sum + qty);
  }

  int get availableCapacity {
    return capacity - usedCapacity;
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'daysLimit': daysLimit,
      'area': area,
      'cash': cash,
      'bank': bank,
      'capacity': capacity,
      'heat': heat,
      'goalNetWorth': goalNetWorth,
      'stash': stash,
      'trend': trend,
      'upgrades': upgrades,
      'rapSheet': rapSheet.map((e) => e.toJson()).toList(),
      'habits': habits,
      'settings': settings,
      'statistics': statistics,
      'unlockedAchievements': unlockedAchievements.toList(),
      'weapons': weapons,
      'inPrison': inPrison,
      'prisonData': prisonData,
    };
  }

  factory GameState.fromJson(Map<String, dynamic> json) {
    return GameState(
      day: json['day'] ?? 1,
      daysLimit: json['daysLimit'] ?? 30,
      area: json['area'] ?? 'Downtown',
      cash: json['cash'] ?? 2000,
      bank: json['bank'] ?? 0,
      capacity: json['capacity'] ?? 40,
      heat: json['heat'] ?? 0,
      goalNetWorth: json['goalNetWorth'] ?? 50000,
      stash: Map<String, int>.from(json['stash'] ?? {}),
      trend: Map<String, double>.from(json['trend'] ?? {}),
      upgrades: Map<String, int>.from(json['upgrades'] ?? {}),
      rapSheet: (json['rapSheet'] as List<dynamic>?)
              ?.map((e) => RapEntry.fromJson(e))
              .toList() ??
          [],
      habits: Map<String, int>.from(json['habits'] ?? {}),
      settings: Map<String, dynamic>.from(json['settings'] ?? {}),
      statistics: Map<String, dynamic>.from(json['statistics'] ?? {}),
      unlockedAchievements: Set<String>.from(json['unlockedAchievements'] ?? []),
      weapons: Map<String, int>.from(json['weapons'] ?? {}),
      inPrison: json['inPrison'] ?? false,
      prisonData: Map<String, dynamic>.from(json['prisonData'] ?? {}),
    );
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  factory GameState.fromJsonString(String jsonString) {
    return GameState.fromJson(jsonDecode(jsonString));
  }
}

class RapEntry {
  final int date;
  final String charge;
  final int lengthDays;
  final bool felony;

  const RapEntry({
    required this.date,
    required this.charge,
    required this.lengthDays,
    required this.felony,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'charge': charge,
      'lengthDays': lengthDays,
      'felony': felony,
    };
  }

  factory RapEntry.fromJson(Map<String, dynamic> json) {
    return RapEntry(
      date: json['date'],
      charge: json['charge'],
      lengthDays: json['lengthDays'],
      felony: json['felony'],
    );
  }
}

class PriceHistory {
  final Map<String, List<double>> history;

  PriceHistory(this.history);

  void addPrice(String item, double price) {
    history.putIfAbsent(item, () => []);
    history[item]!.add(price);
    
    // Keep only last 7 days
    if (history[item]!.length > 7) {
      history[item]!.removeAt(0);
    }
  }

  List<double> getHistory(String item) {
    return history[item] ?? [];
  }

  double? getPreviousPrice(String item) {
    final itemHistory = history[item];
    if (itemHistory != null && itemHistory.length >= 2) {
      return itemHistory[itemHistory.length - 2];
    }
    return null;
  }
}

class GameEvent {
  final String type;
  final String message;
  final int cashImpact;
  final Map<String, int> stashImpact;
  final int heatImpact;

  const GameEvent({
    required this.type,
    required this.message,
    this.cashImpact = 0,
    this.stashImpact = const {},
    this.heatImpact = 0,
  });
}
