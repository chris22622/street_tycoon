import 'dart:convert';
import 'federal_models.dart';
import 'crew_models.dart';
import 'territory_models.dart';
import 'prestige_models.dart';
import 'transaction_models.dart';
import 'lawyer_models.dart';
import 'character_models.dart';
import 'activity_log.dart';
import 'gang_models.dart';

class GameState {
  final int day;
  final int daysLimit;
  final String area;
  final int cash;
  final int bank;
  final int capacity;
  final int heat;
  final int goalNetWorth;
  final int energy; // 0..kEnergyMax
  final Map<String, int> skills; // {'stealth':0,'intimidation':0,'hacking':0,'driving':0}
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
  final FederalMeter? federalMeter;
  final Crew? crew;
  final TerritoryControl? territoryControl;
  final PrestigeSystem? prestigeSystem;
  final TransactionHistory? transactionHistory;
  final ActivityLog? activityLog;
  final LegalSystem? legalSystem;
  final CharacterAppearance? character;
  final PlayerGang? playerGang;
  final GangWarfare? gangWarfare;

  const GameState({
    required this.day,
    required this.daysLimit,
    required this.area,
    required this.cash,
    required this.bank,
    required this.capacity,
    required this.heat,
    required this.goalNetWorth,
    required this.energy,
    required this.skills,
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
    this.federalMeter,
    this.crew,
    this.territoryControl,
    this.prestigeSystem,
    this.transactionHistory,
    this.activityLog,
    this.legalSystem,
    this.character,
    this.playerGang,
    this.gangWarfare,
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
    int? energy,
    Map<String, int>? skills,
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
    FederalMeter? federalMeter,
    Crew? crew,
    TerritoryControl? territoryControl,
    PrestigeSystem? prestigeSystem,
    TransactionHistory? transactionHistory,
    ActivityLog? activityLog,
    LegalSystem? legalSystem,
    CharacterAppearance? character,
    PlayerGang? playerGang,
    GangWarfare? gangWarfare,
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
      energy: energy ?? this.energy,
      skills: skills ?? Map.from(this.skills),
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
      federalMeter: federalMeter ?? this.federalMeter,
      crew: crew ?? this.crew,
      territoryControl: territoryControl ?? this.territoryControl,
      prestigeSystem: prestigeSystem ?? this.prestigeSystem,
      transactionHistory: transactionHistory ?? this.transactionHistory,
      activityLog: activityLog ?? this.activityLog,
      legalSystem: legalSystem ?? this.legalSystem,
      character: character ?? this.character,
      playerGang: playerGang ?? this.playerGang,
      gangWarfare: gangWarfare ?? this.gangWarfare,
    );
  }

  int get netWorth {
    int stashValue = 0;
    // For net worth calculation, we'd need current prices
    // This is simplified - in real implementation, we'd pass current prices
    return cash + bank + stashValue;
  }

  int netWorthWithPrices(Map<String, int> prices) {
    var total = cash + bank;
    stash.forEach((item, qty) {
      total += (prices[item] ?? 0) * qty;
    });
    return total;
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
      'energy': energy,
      'skills': skills,
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
      'federalMeter': federalMeter?.toJson(),
      'crew': crew?.toJson(),
      'territoryControl': territoryControl?.toJson(),
      'prestigeSystem': prestigeSystem?.toJson(),
      'transactionHistory': transactionHistory?.toJson(),
      'activityLog': activityLog?.toJson(),
      'legalSystem': legalSystem?.toJson(),
      'character': character?.toJson(),
      'playerGang': playerGang?.toJson(),
      'gangWarfare': gangWarfare?.toJson(),
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
      energy: json['energy'] ?? 100,
      skills: Map<String, int>.from(json['skills'] ?? {'stealth': 0, 'intimidation': 0, 'hacking': 0, 'driving': 0}),
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
      federalMeter: json['federalMeter'] != null 
          ? FederalMeter.fromJson(json['federalMeter'])
          : null,
      crew: json['crew'] != null 
          ? Crew.fromJson(json['crew'])
          : null,
      territoryControl: json['territoryControl'] != null 
          ? TerritoryControl.fromJson(json['territoryControl'])
          : null,
      prestigeSystem: json['prestigeSystem'] != null 
          ? PrestigeSystem.fromJson(json['prestigeSystem'])
          : null,
      transactionHistory: json['transactionHistory'] != null 
          ? TransactionHistory.fromJson(json['transactionHistory'])
          : null,
      activityLog: json['activityLog'] != null 
          ? ActivityLog.fromJson(json['activityLog'])
          : null,
      legalSystem: json['legalSystem'] != null 
          ? LegalSystem.fromJson(json['legalSystem'])
          : null,
      character: json['character'] != null 
          ? CharacterAppearance.fromJson(json['character'])
          : null,
      playerGang: json['playerGang'] != null 
          ? PlayerGang.fromJson(json['playerGang'])
          : null,
      gangWarfare: json['gangWarfare'] != null 
          ? GangWarfare.fromJson(json['gangWarfare'])
          : null,
    );
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  factory GameState.fromJsonString(String jsonString) {
    return GameState.fromJson(jsonDecode(jsonString));
  }

  // Energy and Skills Helper Methods
  GameState withEnergy(int v) => copyWith(energy: v.clamp(0, 100)); // Using constant kEnergyMax would create import cycle
  
  int skill(String k) => (skills[k] ?? 0);
  
  GameState gainSkill(String k, int xp) {
    final m = Map<String, int>.from(skills);
    m[k] = (m[k] ?? 0) + xp;
    return copyWith(skills: m);
  }
  
  GameState regenEnergy(int safehouseLv) {
    final regen = 25 + 10 * safehouseLv; // kEnergyBaseRegenNightly + 10*safehouseLv
    return withEnergy(energy + regen);
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
