import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

// Advanced Gang War System
// Feature #20: Ultra-comprehensive gang warfare mechanics with strategic territories,
// alliance systems, warfare tactics, and dynamic conflict resolution

enum GangType {
  street,
  cartel,
  mafia,
  biker,
  yakuza,
  triad,
  syndicate,
  militia
}

enum WarfareType {
  territorial,
  business,
  revenge,
  expansion,
  resource,
  ideological,
  personal,
  survival
}

enum BattleType {
  skirmish,
  raid,
  assault,
  siege,
  ambush,
  drive_by,
  turf_war,
  full_scale
}

enum WarStatus {
  peace,
  tension,
  cold_war,
  active_conflict,
  total_war,
  ceasefire,
  armistice
}

class Gang {
  final String id;
  final String name;
  final GangType type;
  final String leader;
  final int members;
  final double strength;
  final double influence;
  final double resources;
  final double morale;
  final double reputation;
  final List<String> territories;
  final Map<String, double> relationships;
  final List<String> allies;
  final List<String> enemies;
  final Map<String, int> equipment;
  final List<String> specialties;
  final String homeTerritory;
  final bool isActive;

  Gang({
    required this.id,
    required this.name,
    required this.type,
    required this.leader,
    this.members = 10,
    this.strength = 0.5,
    this.influence = 0.5,
    this.resources = 0.5,
    this.morale = 0.5,
    this.reputation = 0.5,
    this.territories = const [],
    this.relationships = const {},
    this.allies = const [],
    this.enemies = const [],
    this.equipment = const {},
    this.specialties = const [],
    required this.homeTerritory,
    this.isActive = true,
  });

  Gang copyWith({
    String? id,
    String? name,
    GangType? type,
    String? leader,
    int? members,
    double? strength,
    double? influence,
    double? resources,
    double? morale,
    double? reputation,
    List<String>? territories,
    Map<String, double>? relationships,
    List<String>? allies,
    List<String>? enemies,
    Map<String, int>? equipment,
    List<String>? specialties,
    String? homeTerritory,
    bool? isActive,
  }) {
    return Gang(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      leader: leader ?? this.leader,
      members: members ?? this.members,
      strength: strength ?? this.strength,
      influence: influence ?? this.influence,
      resources: resources ?? this.resources,
      morale: morale ?? this.morale,
      reputation: reputation ?? this.reputation,
      territories: territories ?? this.territories,
      relationships: relationships ?? this.relationships,
      allies: allies ?? this.allies,
      enemies: enemies ?? this.enemies,
      equipment: equipment ?? this.equipment,
      specialties: specialties ?? this.specialties,
      homeTerritory: homeTerritory ?? this.homeTerritory,
      isActive: isActive ?? this.isActive,
    );
  }

  double get totalPower => (strength + influence + resources + morale) / 4.0;
  double get combatEffectiveness => (strength * 0.4 + morale * 0.3 + resources * 0.3);
  bool get isHostile => enemies.isNotEmpty;
  bool get isAllied => allies.isNotEmpty;
  int get territoryCount => territories.length;
}

class GangWar {
  final String id;
  final List<String> participantGangs;
  final String aggressor;
  final String defender;
  final WarfareType warType;
  final WarStatus status;
  final DateTime startDate;
  final DateTime? endDate;
  final List<String> battleHistory;
  final Map<String, int> casualties;
  final Map<String, double> resources_lost;
  final List<String> disputedTerritories;
  final String? cause;
  final double intensity;

  GangWar({
    required this.id,
    required this.participantGangs,
    required this.aggressor,
    required this.defender,
    required this.warType,
    this.status = WarStatus.active_conflict,
    required this.startDate,
    this.endDate,
    this.battleHistory = const [],
    this.casualties = const {},
    this.resources_lost = const {},
    this.disputedTerritories = const [],
    this.cause,
    this.intensity = 0.5,
  });

  GangWar copyWith({
    String? id,
    List<String>? participantGangs,
    String? aggressor,
    String? defender,
    WarfareType? warType,
    WarStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? battleHistory,
    Map<String, int>? casualties,
    Map<String, double>? resources_lost,
    List<String>? disputedTerritories,
    String? cause,
    double? intensity,
  }) {
    return GangWar(
      id: id ?? this.id,
      participantGangs: participantGangs ?? this.participantGangs,
      aggressor: aggressor ?? this.aggressor,
      defender: defender ?? this.defender,
      warType: warType ?? this.warType,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      battleHistory: battleHistory ?? this.battleHistory,
      casualties: casualties ?? this.casualties,
      resources_lost: resources_lost ?? this.resources_lost,
      disputedTerritories: disputedTerritories ?? this.disputedTerritories,
      cause: cause ?? this.cause,
      intensity: intensity ?? this.intensity,
    );
  }

  Duration get warDuration => (endDate ?? DateTime.now()).difference(startDate);
  bool get isActive => endDate == null && status != WarStatus.peace;
  int get totalCasualties => casualties.values.fold(0, (sum, count) => sum + count);
  double get totalResourcesLost => resources_lost.values.fold(0.0, (sum, amount) => sum + amount);
}

class Battle {
  final String id;
  final String warId;
  final BattleType type;
  final List<String> attackers;
  final List<String> defenders;
  final String location;
  final DateTime timestamp;
  final Map<String, int> forces;
  final Map<String, int> losses;
  final String? winner;
  final Map<String, dynamic> outcome;
  final double intensity;
  final List<String> tactics_used;

  Battle({
    required this.id,
    required this.warId,
    required this.type,
    required this.attackers,
    required this.defenders,
    required this.location,
    required this.timestamp,
    this.forces = const {},
    this.losses = const {},
    this.winner,
    this.outcome = const {},
    this.intensity = 0.5,
    this.tactics_used = const [],
  });

  bool get hasWinner => winner != null;
  int get totalForces => forces.values.fold(0, (sum, count) => sum + count);
  int get totalLosses => losses.values.fold(0, (sum, count) => sum + count);
  double get casualtyRate => totalForces > 0 ? totalLosses / totalForces : 0.0;
}

class Alliance {
  final String id;
  final String name;
  final List<String> memberGangs;
  final String leader;
  final DateTime formedDate;
  final DateTime? dissolvedDate;
  final Map<String, dynamic> terms;
  final double stability;
  final bool isActive;

  Alliance({
    required this.id,
    required this.name,
    required this.memberGangs,
    required this.leader,
    required this.formedDate,
    this.dissolvedDate,
    this.terms = const {},
    this.stability = 0.5,
    this.isActive = true,
  });

  Duration get allianceDuration => (dissolvedDate ?? DateTime.now()).difference(formedDate);
  int get memberCount => memberGangs.length;
}

class AdvancedGangWarSystem extends ChangeNotifier {
  static final AdvancedGangWarSystem _instance = AdvancedGangWarSystem._internal();
  factory AdvancedGangWarSystem() => _instance;
  AdvancedGangWarSystem._internal() {
    _initializeSystem();
  }

  final Map<String, Gang> _gangs = {};
  final Map<String, GangWar> _wars = {};
  final Map<String, Battle> _battles = {};
  final Map<String, Alliance> _alliances = {};
  
  String? _playerId;
  String? _playerGangId;
  int _totalGangs = 0;
  int _activeWars = 0;
  double _cityTension = 0.3;
  double _playerInfluence = 0.1;
  
  Timer? _systemTimer;
  final math.Random _random = math.Random();

  // Getters
  Map<String, Gang> get gangs => Map.unmodifiable(_gangs);
  Map<String, GangWar> get wars => Map.unmodifiable(_wars);
  Map<String, Battle> get battles => Map.unmodifiable(_battles);
  Map<String, Alliance> get alliances => Map.unmodifiable(_alliances);
  String? get playerId => _playerId;
  String? get playerGangId => _playerGangId;
  int get totalGangs => _totalGangs;
  int get activeWars => _activeWars;
  double get cityTension => _cityTension;
  double get playerInfluence => _playerInfluence;

  void _initializeSystem() {
    _playerId = 'player_${DateTime.now().millisecondsSinceEpoch}';
    _generateInitialGangs();
    _createPlayerGang();
    _generateInitialConflicts();
    _startSystemTimer();
  }

  void _generateInitialGangs() {
    final gangDefinitions = _getGangDefinitions();
    
    for (final gang in gangDefinitions) {
      _gangs[gang.id] = gang;
      _totalGangs++;
    }
  }

  List<Gang> _getGangDefinitions() {
    return [
      Gang(
        id: 'gang_blood_hawks',
        name: 'Blood Hawks',
        type: GangType.street,
        leader: 'Marcus "Razor" Thompson',
        members: 25,
        strength: 0.7,
        influence: 0.5,
        resources: 0.4,
        morale: 0.8,
        reputation: 0.6,
        territories: ['downtown_east', 'industrial_north'],
        equipment: {'firearms': 15, 'vehicles': 8, 'safehouses': 3},
        specialties: ['drive_by', 'intimidation', 'street_deals'],
        homeTerritory: 'downtown_east',
      ),
      Gang(
        id: 'gang_iron_serpents',
        name: 'Iron Serpents',
        type: GangType.biker,
        leader: 'Jake "Snake" Morrison',
        members: 18,
        strength: 0.8,
        influence: 0.4,
        resources: 0.6,
        morale: 0.9,
        reputation: 0.7,
        territories: ['highway_corridor', 'warehouse_district'],
        equipment: {'motorcycles': 20, 'firearms': 25, 'armor': 18},
        specialties: ['motorcycle_assault', 'drug_running', 'protection_racket'],
        homeTerritory: 'highway_corridor',
      ),
      Gang(
        id: 'gang_golden_dragons',
        name: 'Golden Dragons',
        type: GangType.triad,
        leader: 'Chen Wei "Dragon" Liu',
        members: 35,
        strength: 0.6,
        influence: 0.8,
        resources: 0.9,
        morale: 0.7,
        reputation: 0.8,
        territories: ['chinatown', 'financial_district', 'port_area'],
        equipment: {'firearms': 40, 'vehicles': 15, 'businesses': 12},
        specialties: ['money_laundering', 'human_trafficking', 'business_infiltration'],
        homeTerritory: 'chinatown',
      ),
      Gang(
        id: 'gang_crimson_cartel',
        name: 'Crimson Cartel',
        type: GangType.cartel,
        leader: 'Eduardo "El Rojo" Vasquez',
        members: 45,
        strength: 0.9,
        influence: 0.7,
        resources: 0.8,
        morale: 0.6,
        reputation: 0.9,
        territories: ['south_district', 'border_zone', 'shipping_docks'],
        equipment: {'firearms': 60, 'vehicles': 25, 'labs': 8},
        specialties: ['drug_manufacturing', 'smuggling', 'assassination'],
        homeTerritory: 'south_district',
      ),
      Gang(
        id: 'gang_shadow_syndicate',
        name: 'Shadow Syndicate',
        type: GangType.syndicate,
        leader: 'Victor "The Ghost" Petrov',
        members: 30,
        strength: 0.7,
        influence: 0.9,
        resources: 0.7,
        morale: 0.5,
        reputation: 0.6,
        territories: ['uptown', 'business_center', 'government_district'],
        equipment: {'firearms': 35, 'technology': 20, 'contacts': 50},
        specialties: ['cybercrime', 'corruption', 'white_collar_crime'],
        homeTerritory: 'uptown',
      ),
      Gang(
        id: 'gang_steel_wolves',
        name: 'Steel Wolves',
        type: GangType.militia,
        leader: 'Colonel Frank "Wolf" Davies',
        members: 28,
        strength: 0.95,
        influence: 0.3,
        resources: 0.5,
        morale: 0.8,
        reputation: 0.4,
        territories: ['military_surplus', 'abandoned_factory'],
        equipment: {'military_grade': 40, 'vehicles': 12, 'explosives': 15},
        specialties: ['tactical_warfare', 'explosives', 'guerrilla_tactics'],
        homeTerritory: 'military_surplus',
      ),
    ];
  }

  void _createPlayerGang() {
    _playerGangId = 'gang_player_${_playerId}';
    
    _gangs[_playerGangId!] = Gang(
      id: _playerGangId!,
      name: 'The Syndicate',
      type: GangType.street,
      leader: 'You',
      members: 5,
      strength: 0.3,
      influence: 0.2,
      resources: 0.4,
      morale: 0.8,
      reputation: 0.1,
      territories: ['starter_territory'],
      equipment: {'firearms': 5, 'vehicles': 2, 'safehouses': 1},
      specialties: ['adaptability'],
      homeTerritory: 'starter_territory',
    );
    
    _totalGangs++;
  }

  void _generateInitialConflicts() {
    // Create some existing tensions
    final gangIds = _gangs.keys.where((id) => id != _playerGangId).toList();
    
    for (int i = 0; i < 2; i++) {
      if (gangIds.length >= 2) {
        final aggressor = gangIds[_random.nextInt(gangIds.length)];
        final defender = gangIds.where((id) => id != aggressor).elementAt(_random.nextInt(gangIds.length - 1));
        
        _startWar(aggressor, defender, _getRandomWarType());
      }
    }
  }

  WarfareType _getRandomWarType() {
    return WarfareType.values[_random.nextInt(WarfareType.values.length)];
  }

  void _startSystemTimer() {
    _systemTimer?.cancel();
    _systemTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _updateWars();
      _processOngoingBattles();
      _updateGangRelationships();
      _simulateGangActions();
      _updateCityTension();
      notifyListeners();
    });
  }

  // Gang Management
  void recruitMembers(int count) {
    final playerGang = _gangs[_playerGangId];
    if (playerGang != null) {
      _gangs[_playerGangId!] = playerGang.copyWith(
        members: playerGang.members + count,
        strength: (playerGang.strength + count * 0.02).clamp(0.0, 1.0),
      );
      _updatePlayerInfluence();
    }
  }

  void upgradeEquipment(String equipmentType, int amount) {
    final playerGang = _gangs[_playerGangId];
    if (playerGang != null) {
      final newEquipment = Map<String, int>.from(playerGang.equipment);
      newEquipment[equipmentType] = (newEquipment[equipmentType] ?? 0) + amount;
      
      _gangs[_playerGangId!] = playerGang.copyWith(
        equipment: newEquipment,
        strength: (playerGang.strength + amount * 0.01).clamp(0.0, 1.0),
      );
    }
  }

  void expandTerritory(String territoryId) {
    final playerGang = _gangs[_playerGangId];
    if (playerGang != null && !playerGang.territories.contains(territoryId)) {
      // Check if territory is contested
      final contestingGang = _gangs.values
          .where((gang) => gang.id != _playerGangId && gang.territories.contains(territoryId))
          .firstOrNull;
      
      if (contestingGang != null) {
        // Start territorial war
        _startWar(_playerGangId!, contestingGang.id, WarfareType.territorial);
      } else {
        // Peaceful expansion
        _gangs[_playerGangId!] = playerGang.copyWith(
          territories: [...playerGang.territories, territoryId],
          influence: (playerGang.influence + 0.1).clamp(0.0, 1.0),
        );
      }
    }
  }

  // War System
  String _startWar(String aggressorId, String defenderId, WarfareType warType) {
    final warId = 'war_${DateTime.now().millisecondsSinceEpoch}';
    
    final war = GangWar(
      id: warId,
      participantGangs: [aggressorId, defenderId],
      aggressor: aggressorId,
      defender: defenderId,
      warType: warType,
      startDate: DateTime.now(),
      cause: _generateWarCause(warType),
      intensity: _random.nextDouble() * 0.5 + 0.3,
    );

    _wars[warId] = war;
    _activeWars++;

    // Update gang relationships
    _updateGangRelationship(aggressorId, defenderId, -0.5);
    
    // Schedule first battle
    _scheduleBattle(warId);
    
    return warId;
  }

  String _generateWarCause(WarfareType warType) {
    switch (warType) {
      case WarfareType.territorial:
        return 'Dispute over territory control and boundaries';
      case WarfareType.business:
        return 'Competition over lucrative business operations';
      case WarfareType.revenge:
        return 'Retaliation for previous attacks or betrayals';
      case WarfareType.expansion:
        return 'Aggressive expansion into rival territory';
      case WarfareType.resource:
        return 'Control over valuable resources and supply routes';
      case WarfareType.ideological:
        return 'Fundamental differences in gang philosophy';
      case WarfareType.personal:
        return 'Personal vendetta between gang leaders';
      case WarfareType.survival:
        return 'Fight for survival against overwhelming force';
    }
  }

  void _scheduleBattle(String warId) {
    final delay = Duration(seconds: _random.nextInt(30) + 10);
    
    Timer(delay, () {
      _conductBattle(warId);
    });
  }

  void _conductBattle(String warId) {
    final war = _wars[warId];
    if (war == null || !war.isActive) return;

    final battleId = 'battle_${DateTime.now().millisecondsSinceEpoch}';
    final battleType = _selectBattleType(war);
    final location = _selectBattleLocation(war);
    
    final attackerGang = _gangs[war.aggressor]!;
    final defenderGang = _gangs[war.defender]!;
    
    // Calculate forces
    final attackerForces = _calculateBattleForces(attackerGang, true);
    final defenderForces = _calculateBattleForces(defenderGang, false);
    
    // Conduct battle simulation
    final battleResult = _simulateBattle(attackerGang, defenderGang, attackerForces, defenderForces, battleType);
    
    final battle = Battle(
      id: battleId,
      warId: warId,
      type: battleType,
      attackers: [war.aggressor],
      defenders: [war.defender],
      location: location,
      timestamp: DateTime.now(),
      forces: {war.aggressor: attackerForces, war.defender: defenderForces},
      losses: battleResult['losses'],
      winner: battleResult['winner'],
      outcome: battleResult['outcome'],
      intensity: war.intensity,
      tactics_used: battleResult['tactics'],
    );

    _battles[battleId] = battle;
    
    // Update war
    _wars[warId] = war.copyWith(
      battleHistory: [...war.battleHistory, battleId],
      casualties: _updateCasualties(war.casualties, battleResult['losses']),
    );

    // Apply battle consequences
    _applyBattleConsequences(battle);
    
    // Check war continuation
    if (!_checkWarContinuation(warId)) {
      _endWar(warId, battleResult['winner']);
    } else {
      // Schedule next battle
      _scheduleBattle(warId);
    }
  }

  BattleType _selectBattleType(GangWar war) {
    final types = [
      BattleType.skirmish,
      BattleType.raid,
      BattleType.assault,
      BattleType.drive_by,
      BattleType.turf_war,
    ];
    
    if (war.intensity > 0.8) {
      types.addAll([BattleType.siege, BattleType.full_scale]);
    }
    
    return types[_random.nextInt(types.length)];
  }

  String _selectBattleLocation(GangWar war) {
    final aggressor = _gangs[war.aggressor]!;
    final defender = _gangs[war.defender]!;
    
    final allTerritories = [...aggressor.territories, ...defender.territories];
    
    if (allTerritories.isNotEmpty) {
      return allTerritories[_random.nextInt(allTerritories.length)];
    }
    
    return 'neutral_ground';
  }

  int _calculateBattleForces(Gang gang, bool isAttacker) {
    final baseForces = (gang.members * 0.7).round();
    final moraleModifier = gang.morale;
    final equipmentModifier = gang.equipment.values.fold(0, (sum, count) => sum + count) * 0.1;
    
    double modifier = moraleModifier + equipmentModifier;
    
    if (!isAttacker) {
      modifier += 0.2; // Defender advantage
    }
    
    return (baseForces * modifier).round().clamp(1, gang.members);
  }

  Map<String, dynamic> _simulateBattle(Gang attacker, Gang defender, int attackerForces, int defenderForces, BattleType battleType) {
    // Calculate combat effectiveness
    final attackerEffectiveness = _calculateCombatEffectiveness(attacker, true, battleType);
    final defenderEffectiveness = _calculateCombatEffectiveness(defender, false, battleType);
    
    // Simulate casualties
    final attackerLosses = _calculateCasualties(attackerForces, defenderEffectiveness, battleType);
    final defenderLosses = _calculateCasualties(defenderForces, attackerEffectiveness, battleType);
    
    // Determine winner
    String? winner;
    if (attackerLosses < defenderLosses * 0.8) {
      winner = attacker.id;
    } else if (defenderLosses < attackerLosses * 0.8) {
      winner = defender.id;
    }
    // else: stalemate
    
    return {
      'winner': winner,
      'losses': {attacker.id: attackerLosses, defender.id: defenderLosses},
      'outcome': _generateBattleOutcome(winner, attackerLosses, defenderLosses),
      'tactics': _generateTacticsUsed(attacker, defender, battleType),
    };
  }

  double _calculateCombatEffectiveness(Gang gang, bool isAttacker, BattleType battleType) {
    double effectiveness = gang.combatEffectiveness;
    
    // Battle type modifiers
    switch (battleType) {
      case BattleType.drive_by:
        if (gang.specialties.contains('drive_by')) effectiveness += 0.2;
        break;
      case BattleType.siege:
        if (gang.equipment.containsKey('explosives')) effectiveness += 0.15;
        break;
      case BattleType.ambush:
        if (isAttacker) effectiveness += 0.25;
        break;
      case BattleType.turf_war:
        if (gang.type == GangType.street) effectiveness += 0.1;
        break;
      default:
        break;
    }
    
    // Gang type modifiers
    switch (gang.type) {
      case GangType.militia:
        effectiveness += 0.2;
        break;
      case GangType.cartel:
        effectiveness += 0.15;
        break;
      case GangType.biker:
        if (battleType == BattleType.drive_by) effectiveness += 0.2;
        break;
      default:
        break;
    }
    
    return effectiveness.clamp(0.1, 1.0);
  }

  int _calculateCasualties(int forces, double enemyEffectiveness, BattleType battleType) {
    double casualtyRate = enemyEffectiveness * 0.3;
    
    // Battle type modifiers
    switch (battleType) {
      case BattleType.full_scale:
        casualtyRate *= 1.5;
        break;
      case BattleType.siege:
        casualtyRate *= 1.3;
        break;
      case BattleType.skirmish:
        casualtyRate *= 0.5;
        break;
      default:
        break;
    }
    
    final baseCasualties = (forces * casualtyRate).round();
    final randomVariation = _random.nextInt(baseCasualties ~/ 2 + 1);
    
    return (baseCasualties + randomVariation).clamp(0, forces);
  }

  Map<String, dynamic> _generateBattleOutcome(String? winner, int attackerLosses, int defenderLosses) {
    if (winner != null) {
      return {
        'type': 'decisive_victory',
        'description': 'Clear victor emerged with significant advantage',
        'territory_change': true,
        'morale_impact': 0.2,
      };
    } else {
      return {
        'type': 'stalemate',
        'description': 'Both sides took heavy losses with no clear winner',
        'territory_change': false,
        'morale_impact': -0.1,
      };
    }
  }

  List<String> _generateTacticsUsed(Gang attacker, Gang defender, BattleType battleType) {
    final tactics = <String>[];
    
    // Add tactics based on gang specialties
    tactics.addAll(attacker.specialties.take(2));
    tactics.addAll(defender.specialties.take(1));
    
    // Add battle-specific tactics
    switch (battleType) {
      case BattleType.ambush:
        tactics.add('surprise_attack');
        break;
      case BattleType.siege:
        tactics.add('heavy_weapons');
        break;
      case BattleType.drive_by:
        tactics.add('hit_and_run');
        break;
      default:
        tactics.add('direct_assault');
        break;
    }
    
    return tactics.take(3).toList();
  }

  Map<String, int> _updateCasualties(Map<String, int> currentCasualties, Map<String, int> newLosses) {
    final updated = Map<String, int>.from(currentCasualties);
    
    newLosses.forEach((gangId, losses) {
      updated[gangId] = (updated[gangId] ?? 0) + losses;
    });
    
    return updated;
  }

  void _applyBattleConsequences(Battle battle) {
    // Apply casualties to gangs
    battle.losses.forEach((gangId, losses) {
      final gang = _gangs[gangId];
      if (gang != null) {
        final newMembers = (gang.members - losses).clamp(1, gang.members);
        final moraleChange = battle.winner == gangId ? 0.1 : -0.1;
        
        _gangs[gangId] = gang.copyWith(
          members: newMembers,
          morale: (gang.morale + moraleChange).clamp(0.0, 1.0),
        );
      }
    });
    
    // Handle territory changes
    if (battle.outcome['territory_change'] == true && battle.winner != null) {
      _handleTerritoryChange(battle);
    }
  }

  void _handleTerritoryChange(Battle battle) {
    final winner = _gangs[battle.winner!];
    final war = _wars[battle.warId];
    
    if (winner != null && war != null) {
      final loser = _gangs[war.aggressor == battle.winner ? war.defender : war.aggressor]!;
      
      if (loser.territories.isNotEmpty) {
        final contestedTerritory = loser.territories.first;
        
        _gangs[loser.id] = loser.copyWith(
          territories: loser.territories.where((t) => t != contestedTerritory).toList(),
        );
        
        _gangs[winner.id] = winner.copyWith(
          territories: [...winner.territories, contestedTerritory],
        );
      }
    }
  }

  bool _checkWarContinuation(String warId) {
    final war = _wars[warId]!;
    final aggressor = _gangs[war.aggressor]!;
    final defender = _gangs[war.defender]!;
    
    // Check if either gang is severely weakened
    if (aggressor.members < 5 || defender.members < 5) return false;
    if (aggressor.morale < 0.2 || defender.morale < 0.2) return false;
    
    // Check war duration
    if (war.warDuration.inDays > 30) return false;
    
    // Random chance of ceasefire
    return _random.nextDouble() > 0.1;
  }

  void _endWar(String warId, String? winner) {
    final war = _wars[warId]!;
    
    _wars[warId] = war.copyWith(
      status: WarStatus.peace,
      endDate: DateTime.now(),
    );
    
    _activeWars--;
    
    // Update relationships based on outcome
    if (winner != null) {
      final loser = war.aggressor == winner ? war.defender : war.aggressor;
      _updateGangRelationship(winner, loser, 0.2);
      _updateGangRelationship(loser, winner, -0.3);
    }
  }

  // Alliance System
  String createAlliance(String gangId1, String gangId2, String allianceName) {
    final allianceId = 'alliance_${DateTime.now().millisecondsSinceEpoch}';
    
    final alliance = Alliance(
      id: allianceId,
      name: allianceName,
      memberGangs: [gangId1, gangId2],
      leader: gangId1, // First gang becomes leader
      formedDate: DateTime.now(),
      stability: 0.7,
    );

    _alliances[allianceId] = alliance;
    
    // Update gang relationships
    _updateGangRelationship(gangId1, gangId2, 0.5);
    
    return allianceId;
  }

  void breakAlliance(String allianceId) {
    final alliance = _alliances[allianceId];
    if (alliance != null) {
      _alliances[allianceId] = Alliance(
        id: alliance.id,
        name: alliance.name,
        memberGangs: alliance.memberGangs,
        leader: alliance.leader,
        formedDate: alliance.formedDate,
        dissolvedDate: DateTime.now(),
        terms: alliance.terms,
        stability: 0.0,
        isActive: false,
      );
      
      // Damage relationships between former allies
      for (int i = 0; i < alliance.memberGangs.length; i++) {
        for (int j = i + 1; j < alliance.memberGangs.length; j++) {
          _updateGangRelationship(alliance.memberGangs[i], alliance.memberGangs[j], -0.3);
        }
      }
    }
  }

  // System Updates
  void _updateWars() {
    _activeWars = _wars.values.where((war) => war.isActive).length;
  }

  void _processOngoingBattles() {
    // Handle any ongoing battle effects
    for (final battle in _battles.values) {
      if (DateTime.now().difference(battle.timestamp).inMinutes < 30) {
        // Recent battle effects on city tension
        _cityTension += battle.intensity * 0.01;
      }
    }
  }

  void _updateGangRelationships() {
    // Natural relationship decay/improvement over time
    for (final gang in _gangs.values) {
      final newRelationships = Map<String, double>.from(gang.relationships);
      
      newRelationships.forEach((otherGangId, relationship) {
        // Relationships slowly drift toward neutral
        if (relationship > 0) {
          newRelationships[otherGangId] = (relationship - 0.01).clamp(0.0, 1.0);
        } else if (relationship < 0) {
          newRelationships[otherGangId] = (relationship + 0.01).clamp(-1.0, 0.0);
        }
      });
      
      _gangs[gang.id] = gang.copyWith(relationships: newRelationships);
    }
  }

  void _simulateGangActions() {
    if (_random.nextDouble() < 0.1) {
      _generateRandomGangEvent();
    }
  }

  void _generateRandomGangEvent() {
    final nonPlayerGangs = _gangs.values.where((gang) => gang.id != _playerGangId).toList();
    
    if (nonPlayerGangs.length >= 2) {
      final gang1 = nonPlayerGangs[_random.nextInt(nonPlayerGangs.length)];
      final gang2 = nonPlayerGangs.where((g) => g.id != gang1.id).elementAt(_random.nextInt(nonPlayerGangs.length - 1));
      
      final events = ['territorial_dispute', 'business_rivalry', 'alliance_proposal', 'betrayal'];
      final event = events[_random.nextInt(events.length)];
      
      _handleRandomEvent(gang1, gang2, event);
    }
  }

  void _handleRandomEvent(Gang gang1, Gang gang2, String event) {
    switch (event) {
      case 'territorial_dispute':
        if (!_isAtWar(gang1.id, gang2.id)) {
          _startWar(gang1.id, gang2.id, WarfareType.territorial);
        }
        break;
      case 'business_rivalry':
        _updateGangRelationship(gang1.id, gang2.id, -0.2);
        break;
      case 'alliance_proposal':
        if (_getRelationship(gang1.id, gang2.id) > 0.3) {
          createAlliance(gang1.id, gang2.id, '${gang1.name}-${gang2.name} Alliance');
        }
        break;
      case 'betrayal':
        final alliance = _alliances.values
            .where((a) => a.isActive && a.memberGangs.contains(gang1.id) && a.memberGangs.contains(gang2.id))
            .firstOrNull;
        if (alliance != null) {
          breakAlliance(alliance.id);
          _startWar(gang1.id, gang2.id, WarfareType.personal);
        }
        break;
    }
  }

  void _updateCityTension() {
    // Calculate tension based on active conflicts
    double baseTension = _activeWars * 0.1;
    
    // Recent battle impact
    final recentBattles = _battles.values
        .where((battle) => DateTime.now().difference(battle.timestamp).inHours < 24)
        .length;
    
    baseTension += recentBattles * 0.05;
    
    // Gang count impact
    baseTension += _totalGangs * 0.02;
    
    _cityTension = baseTension.clamp(0.0, 1.0);
  }

  void _updatePlayerInfluence() {
    final playerGang = _gangs[_playerGangId];
    if (playerGang != null) {
      _playerInfluence = playerGang.totalPower;
    }
  }

  void _updateGangRelationship(String gang1Id, String gang2Id, double change) {
    final gang1 = _gangs[gang1Id];
    final gang2 = _gangs[gang2Id];
    
    if (gang1 != null && gang2 != null) {
      final newRelationships1 = Map<String, double>.from(gang1.relationships);
      final newRelationships2 = Map<String, double>.from(gang2.relationships);
      
      newRelationships1[gang2Id] = ((newRelationships1[gang2Id] ?? 0.0) + change).clamp(-1.0, 1.0);
      newRelationships2[gang1Id] = ((newRelationships2[gang1Id] ?? 0.0) + change).clamp(-1.0, 1.0);
      
      _gangs[gang1Id] = gang1.copyWith(relationships: newRelationships1);
      _gangs[gang2Id] = gang2.copyWith(relationships: newRelationships2);
    }
  }

  // Public Interface Methods
  bool _isAtWar(String gang1Id, String gang2Id) {
    return _wars.values.any((war) => 
        war.isActive && 
        war.participantGangs.contains(gang1Id) && 
        war.participantGangs.contains(gang2Id));
  }

  double _getRelationship(String gang1Id, String gang2Id) {
    final gang1 = _gangs[gang1Id];
    return gang1?.relationships[gang2Id] ?? 0.0;
  }

  Gang? getPlayerGang() {
    return _gangs[_playerGangId];
  }

  List<Gang> getAllGangs() {
    return _gangs.values.toList()
      ..sort((a, b) => b.totalPower.compareTo(a.totalPower));
  }

  List<GangWar> getActiveWars() {
    return _wars.values.where((war) => war.isActive).toList()
      ..sort((a, b) => b.startDate.compareTo(a.startDate));
  }

  List<Battle> getRecentBattles({int limit = 10}) {
    return _battles.values.toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp))
      ..take(limit).toList();
  }

  List<Alliance> getActiveAlliances() {
    return _alliances.values.where((alliance) => alliance.isActive).toList();
  }

  bool canDeclareWar(String targetGangId) {
    final playerGang = getPlayerGang();
    if (playerGang == null) return false;
    
    return !_isAtWar(_playerGangId!, targetGangId) && 
           targetGangId != _playerGangId &&
           playerGang.members >= 5;
  }

  void declareWar(String targetGangId, WarfareType warType) {
    if (canDeclareWar(targetGangId)) {
      _startWar(_playerGangId!, targetGangId, warType);
    }
  }

  bool canFormAlliance(String targetGangId) {
    return _getRelationship(_playerGangId!, targetGangId) > 0.3 &&
           !_isAtWar(_playerGangId!, targetGangId) &&
           !_alliances.values.any((alliance) => 
               alliance.isActive && 
               alliance.memberGangs.contains(_playerGangId) && 
               alliance.memberGangs.contains(targetGangId));
  }

  void proposeAlliance(String targetGangId) {
    if (canFormAlliance(targetGangId)) {
      final playerGang = getPlayerGang()!;
      final targetGang = _gangs[targetGangId]!;
      
      createAlliance(_playerGangId!, targetGangId, '${playerGang.name}-${targetGang.name} Pact');
    }
  }

  void dispose() {
    _systemTimer?.cancel();
    super.dispose();
  }
}

// Advanced Gang War Dashboard Widget
class AdvancedGangWarDashboardWidget extends StatefulWidget {
  const AdvancedGangWarDashboardWidget({super.key});

  @override
  State<AdvancedGangWarDashboardWidget> createState() => _AdvancedGangWarDashboardWidgetState();
}

class _AdvancedGangWarDashboardWidgetState extends State<AdvancedGangWarDashboardWidget>
    with TickerProviderStateMixin {
  final AdvancedGangWarSystem _warSystem = AdvancedGangWarSystem();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _warSystem,
      builder: (context, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                _buildStatsRow(),
                const SizedBox(height: 16),
                _buildTabBar(),
                const SizedBox(height: 16),
                Expanded(child: _buildTabBarView()),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    final playerGang = _warSystem.getPlayerGang();
    
    return Row(
      children: [
        const Text(
          'Gang Wars',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        if (playerGang != null) ...[
          const Icon(Icons.groups, color: Colors.red),
          const SizedBox(width: 8),
          Text('${playerGang.name}: ${playerGang.members} members'),
        ],
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatCard('Total Gangs', '${_warSystem.totalGangs}'),
        _buildStatCard('Active Wars', '${_warSystem.activeWars}'),
        _buildStatCard('City Tension', '${(_warSystem.cityTension * 100).toInt()}%'),
        _buildStatCard('Influence', '${(_warSystem.playerInfluence * 100).toInt()}%'),
      ],
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Expanded(
      child: Card(
        color: Colors.red[50],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(label, style: const TextStyle(fontSize: 12)),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      tabs: const [
        Tab(text: 'Gangs', icon: Icon(Icons.groups)),
        Tab(text: 'Wars', icon: Icon(Icons.gavel)),
        Tab(text: 'Battles', icon: Icon(Icons.local_fire_department)),
        Tab(text: 'Alliances', icon: Icon(Icons.handshake)),
      ],
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildGangsTab(),
        _buildWarsTab(),
        _buildBattlesTab(),
        _buildAlliancesTab(),
      ],
    );
  }

  Widget _buildGangsTab() {
    final gangs = _warSystem.getAllGangs();
    
    return ListView.builder(
      itemCount: gangs.length,
      itemBuilder: (context, index) {
        final gang = gangs[index];
        return _buildGangCard(gang);
      },
    );
  }

  Widget _buildGangCard(Gang gang) {
    final isPlayerGang = gang.id == _warSystem.playerGangId;
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: isPlayerGang ? Colors.blue[50] : null,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: _getGangTypeColor(gang.type),
          child: Text(gang.name[0]),
        ),
        title: Text('${gang.name}${isPlayerGang ? ' (You)' : ''}'),
        subtitle: Text('${gang.type.name} - ${gang.members} members - Power: ${(gang.totalPower * 100).toInt()}%'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Leader: ${gang.leader}'),
                const SizedBox(height: 8),
                _buildGangStats(gang),
                const SizedBox(height: 8),
                if (gang.territories.isNotEmpty) ...[
                  const Text('Territories:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Wrap(
                    children: gang.territories.map((territory) => 
                      Chip(label: Text(territory))).toList(),
                  ),
                  const SizedBox(height: 8),
                ],
                if (!isPlayerGang) _buildGangActions(gang),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGangStats(Gang gang) {
    return Column(
      children: [
        _buildStatBar('Strength', gang.strength),
        _buildStatBar('Influence', gang.influence),
        _buildStatBar('Resources', gang.resources),
        _buildStatBar('Morale', gang.morale),
        _buildStatBar('Reputation', gang.reputation),
      ],
    );
  }

  Widget _buildStatBar(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: const TextStyle(fontSize: 12)),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(_getStatColor(value)),
            ),
          ),
          const SizedBox(width: 8),
          Text('${(value * 100).toInt()}%', style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildGangActions(Gang gang) {
    return Wrap(
      spacing: 8,
      children: [
        if (_warSystem.canDeclareWar(gang.id))
          ElevatedButton(
            onPressed: () => _showDeclareWarDialog(gang),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Declare War'),
          ),
        if (_warSystem.canFormAlliance(gang.id))
          ElevatedButton(
            onPressed: () => _warSystem.proposeAlliance(gang.id),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Propose Alliance'),
          ),
      ],
    );
  }

  Widget _buildWarsTab() {
    final wars = _warSystem.getActiveWars();
    
    return ListView.builder(
      itemCount: wars.length,
      itemBuilder: (context, index) {
        final war = wars[index];
        return _buildWarCard(war);
      },
    );
  }

  Widget _buildWarCard(GangWar war) {
    final aggressor = _warSystem.gangs[war.aggressor];
    final defender = _warSystem.gangs[war.defender];
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${aggressor?.name ?? 'Unknown'} vs ${defender?.name ?? 'Unknown'}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    war.status.name.toUpperCase(),
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Type: ${war.warType.name}'),
            if (war.cause != null) Text('Cause: ${war.cause}'),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('Duration: ${war.warDuration.inDays} days'),
                const Spacer(),
                Text('Battles: ${war.battleHistory.length}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('Casualties: ${war.totalCasualties}'),
                const Spacer(),
                Text('Intensity: ${(war.intensity * 100).toInt()}%'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBattlesTab() {
    final battles = _warSystem.getRecentBattles();
    
    return ListView.builder(
      itemCount: battles.length,
      itemBuilder: (context, index) {
        final battle = battles[index];
        return _buildBattleCard(battle);
      },
    );
  }

  Widget _buildBattleCard(Battle battle) {
    return Card(
      child: ListTile(
        leading: Icon(
          _getBattleTypeIcon(battle.type),
          color: battle.hasWinner ? Colors.red : Colors.orange,
        ),
        title: Text('${battle.type.name} at ${battle.location}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Forces: ${battle.totalForces} | Losses: ${battle.totalLosses}'),
            Text('Outcome: ${battle.outcome['type'] ?? 'Unknown'}'),
          ],
        ),
        trailing: Text(_formatDateTime(battle.timestamp)),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildAlliancesTab() {
    final alliances = _warSystem.getActiveAlliances();
    
    return ListView.builder(
      itemCount: alliances.length,
      itemBuilder: (context, index) {
        final alliance = alliances[index];
        return _buildAllianceCard(alliance);
      },
    );
  }

  Widget _buildAllianceCard(Alliance alliance) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    alliance.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: alliance.isActive ? Colors.green[100] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    alliance.isActive ? 'ACTIVE' : 'DISSOLVED',
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Members: ${alliance.memberCount}'),
            Text('Leader: ${_warSystem.gangs[alliance.leader]?.name ?? 'Unknown'}'),
            Text('Stability: ${(alliance.stability * 100).toInt()}%'),
            Text('Duration: ${alliance.allianceDuration.inDays} days'),
          ],
        ),
      ),
    );
  }

  void _showDeclareWarDialog(Gang targetGang) {
    WarfareType selectedType = WarfareType.territorial;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Declare War on ${targetGang.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('This will start a war with ${targetGang.name}. Choose the type of warfare:'),
            const SizedBox(height: 16),
            DropdownButtonFormField<WarfareType>(
              value: selectedType,
              decoration: const InputDecoration(labelText: 'War Type'),
              items: WarfareType.values.map((type) => 
                DropdownMenuItem(value: type, child: Text(type.name))).toList(),
              onChanged: (type) => selectedType = type!,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _warSystem.declareWar(targetGang.id, selectedType);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Declare War'),
          ),
        ],
      ),
    );
  }

  Color _getGangTypeColor(GangType type) {
    switch (type) {
      case GangType.street:
        return Colors.blue;
      case GangType.cartel:
        return Colors.red;
      case GangType.mafia:
        return Colors.black;
      case GangType.biker:
        return Colors.orange;
      case GangType.yakuza:
        return Colors.purple;
      case GangType.triad:
        return Colors.green;
      case GangType.syndicate:
        return Colors.indigo;
      case GangType.militia:
        return Colors.brown;
    }
  }

  Color _getStatColor(double value) {
    if (value < 0.3) return Colors.red;
    if (value < 0.6) return Colors.orange;
    return Colors.green;
  }

  IconData _getBattleTypeIcon(BattleType type) {
    switch (type) {
      case BattleType.skirmish:
        return Icons.warning;
      case BattleType.raid:
        return Icons.flash_on;
      case BattleType.assault:
        return Icons.gavel;
      case BattleType.siege:
        return Icons.security;
      case BattleType.ambush:
        return Icons.visibility_off;
      case BattleType.drive_by:
        return Icons.directions_car;
      case BattleType.turf_war:
        return Icons.terrain;
      case BattleType.full_scale:
        return Icons.local_fire_department;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
