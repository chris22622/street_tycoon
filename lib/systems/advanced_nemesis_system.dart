import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

// Advanced Nemesis & Rival System
// Feature #17: Ultra-comprehensive rival and nemesis mechanics with dynamic relationships,
// personal vendettas, rival gangs, competitive gameplay, and narrative-driven conflicts

enum RivalType {
  gangLeader,
  criminalMastermind,
  corruptOfficial,
  businessTycoon,
  drugCartel,
  mafiaFamily,
  streetGang,
  policeDepartment,
  federalAgent,
  competitorDealer,
  formerAlly,
  personalEnemy
}

enum RivalshipLevel {
  neutral,
  competitor,
  rival,
  enemy,
  nemesis,
  archenemesis
}

enum ConflictType {
  territorial,
  business,
  personal,
  ideological,
  revenge,
  betrayal,
  competition,
  elimination
}

enum RivalAction {
  sabotage,
  attack,
  steal,
  intimidate,
  recruit,
  negotiate,
  alliance,
  betrayal,
  investigation,
  frame,
  eliminate,
  protect
}

enum RivalStatus {
  active,
  planning,
  retreating,
  imprisoned,
  dead,
  exiled,
  allied,
  neutral
}

class Rival {
  final String id;
  final String name;
  final String nickname;
  final RivalType type;
  final RivalshipLevel level;
  final RivalStatus status;
  final double power;
  final double influence;
  final double resources;
  final double reputation;
  final double intelligence;
  final double ruthlessness;
  final double loyalty;
  final List<String> territories;
  final List<String> assets;
  final Map<String, double> relationships;
  final Map<ConflictType, double> conflicts;
  final DateTime firstEncounter;
  final DateTime? lastAction;
  final int totalActions;
  final Map<String, dynamic> personality;
  final List<String> weaknesses;
  final List<String> strengths;
  final String backstory;

  Rival({
    required this.id,
    required this.name,
    required this.nickname,
    required this.type,
    this.level = RivalshipLevel.neutral,
    this.status = RivalStatus.active,
    required this.power,
    required this.influence,
    required this.resources,
    required this.reputation,
    required this.intelligence,
    required this.ruthlessness,
    this.loyalty = 0.0,
    this.territories = const [],
    this.assets = const [],
    this.relationships = const {},
    this.conflicts = const {},
    required this.firstEncounter,
    this.lastAction,
    this.totalActions = 0,
    this.personality = const {},
    this.weaknesses = const [],
    this.strengths = const [],
    required this.backstory,
  });

  Rival copyWith({
    String? id,
    String? name,
    String? nickname,
    RivalType? type,
    RivalshipLevel? level,
    RivalStatus? status,
    double? power,
    double? influence,
    double? resources,
    double? reputation,
    double? intelligence,
    double? ruthlessness,
    double? loyalty,
    List<String>? territories,
    List<String>? assets,
    Map<String, double>? relationships,
    Map<ConflictType, double>? conflicts,
    DateTime? firstEncounter,
    DateTime? lastAction,
    int? totalActions,
    Map<String, dynamic>? personality,
    List<String>? weaknesses,
    List<String>? strengths,
    String? backstory,
  }) {
    return Rival(
      id: id ?? this.id,
      name: name ?? this.name,
      nickname: nickname ?? this.nickname,
      type: type ?? this.type,
      level: level ?? this.level,
      status: status ?? this.status,
      power: power ?? this.power,
      influence: influence ?? this.influence,
      resources: resources ?? this.resources,
      reputation: reputation ?? this.reputation,
      intelligence: intelligence ?? this.intelligence,
      ruthlessness: ruthlessness ?? this.ruthlessness,
      loyalty: loyalty ?? this.loyalty,
      territories: territories ?? this.territories,
      assets: assets ?? this.assets,
      relationships: relationships ?? this.relationships,
      conflicts: conflicts ?? this.conflicts,
      firstEncounter: firstEncounter ?? this.firstEncounter,
      lastAction: lastAction ?? this.lastAction,
      totalActions: totalActions ?? this.totalActions,
      personality: personality ?? this.personality,
      weaknesses: weaknesses ?? this.weaknesses,
      strengths: strengths ?? this.strengths,
      backstory: backstory ?? this.backstory,
    );
  }

  double get overallThreat => (power + influence + resources + intelligence) / 4.0;
  bool get isNemesis => level == RivalshipLevel.nemesis || level == RivalshipLevel.archenemesis;
  bool get isActive => status == RivalStatus.active;
  bool get isDead => status == RivalStatus.dead;
  
  Duration get relationshipDuration => DateTime.now().difference(firstEncounter);
  int get daysSinceFirstEncounter => relationshipDuration.inDays;
}

class RivalEvent {
  final String id;
  final String rivalId;
  final RivalAction action;
  final String description;
  final DateTime timestamp;
  final Map<String, dynamic> consequences;
  final double impact;
  final bool playerInitiated;
  final String? targetId;

  RivalEvent({
    required this.id,
    required this.rivalId,
    required this.action,
    required this.description,
    required this.timestamp,
    this.consequences = const {},
    required this.impact,
    this.playerInitiated = false,
    this.targetId,
  });
}

class Vendetta {
  final String id;
  final String rivalId;
  final String playerId;
  final String cause;
  final DateTime startDate;
  final double intensity;
  final List<String> events;
  final Map<String, dynamic> conditions;
  final bool resolved;
  final String? resolution;

  Vendetta({
    required this.id,
    required this.rivalId,
    required this.playerId,
    required this.cause,
    required this.startDate,
    required this.intensity,
    this.events = const [],
    this.conditions = const {},
    this.resolved = false,
    this.resolution,
  });

  Duration get duration => DateTime.now().difference(startDate);
  bool get isActive => !resolved;
}

class RivalGang {
  final String id;
  final String leaderId;
  final String name;
  final List<String> members;
  final List<String> territories;
  final double strength;
  final double unity;
  final Map<String, double> specialties;
  final List<String> assets;
  final Map<String, dynamic> operations;

  RivalGang({
    required this.id,
    required this.leaderId,
    required this.name,
    this.members = const [],
    this.territories = const [],
    required this.strength,
    required this.unity,
    this.specialties = const {},
    this.assets = const [],
    this.operations = const {},
  });
}

class AdvancedNemesisSystem extends ChangeNotifier {
  static final AdvancedNemesisSystem _instance = AdvancedNemesisSystem._internal();
  factory AdvancedNemesisSystem() => _instance;
  AdvancedNemesisSystem._internal() {
    _initializeSystem();
  }

  final Map<String, Rival> _rivals = {};
  final Map<String, RivalEvent> _events = {};
  final Map<String, Vendetta> _vendettas = {};
  final Map<String, RivalGang> _rivalGangs = {};
  
  String? _playerId;
  String? _currentNemesis;
  int _totalRivals = 0;
  int _activeConflicts = 0;
  double _overallThreatLevel = 0.0;
  double _reputationImpact = 0.0;
  
  Timer? _systemTimer;
  final math.Random _random = math.Random();

  // Getters
  Map<String, Rival> get rivals => Map.unmodifiable(_rivals);
  Map<String, RivalEvent> get events => Map.unmodifiable(_events);
  Map<String, Vendetta> get vendettas => Map.unmodifiable(_vendettas);
  Map<String, RivalGang> get rivalGangs => Map.unmodifiable(_rivalGangs);
  String? get playerId => _playerId;
  String? get currentNemesis => _currentNemesis;
  int get totalRivals => _totalRivals;
  int get activeConflicts => _activeConflicts;
  double get overallThreatLevel => _overallThreatLevel;
  double get reputationImpact => _reputationImpact;

  void _initializeSystem() {
    _playerId = 'player_${DateTime.now().millisecondsSinceEpoch}';
    _generateInitialRivals();
    _generateRivalGangs();
    _startSystemTimer();
  }

  void _generateInitialRivals() {
    final rivalDefinitions = _getRivalDefinitions();
    
    for (final rival in rivalDefinitions) {
      _rivals[rival.id] = rival;
      _totalRivals++;
    }
  }

  List<Rival> _getRivalDefinitions() {
    return [
      Rival(
        id: 'rival_viktor_kozlov',
        name: 'Viktor Kozlov',
        nickname: 'The Butcher',
        type: RivalType.gangLeader,
        level: RivalshipLevel.rival,
        power: 0.8,
        influence: 0.6,
        resources: 0.7,
        reputation: 0.9,
        intelligence: 0.6,
        ruthlessness: 0.95,
        territories: ['industrial_east', 'slums_east'],
        firstEncounter: DateTime.now().subtract(const Duration(days: 30)),
        personality: {
          'aggressive': 0.9,
          'intelligent': 0.6,
          'paranoid': 0.7,
          'loyal': 0.8,
        },
        weaknesses: ['family', 'pride', 'predictable'],
        strengths: ['violence', 'loyalty', 'territory_control'],
        backstory: 'Former Russian mafia enforcer who built his own empire in the city\'s industrial district.',
      ),
      Rival(
        id: 'rival_maria_santos',
        name: 'Maria Santos',
        nickname: 'La Reina',
        type: RivalType.drugCartel,
        level: RivalshipLevel.enemy,
        power: 0.9,
        influence: 0.8,
        resources: 0.9,
        reputation: 0.8,
        intelligence: 0.9,
        ruthlessness: 0.7,
        territories: ['docks_main', 'suburbs_south'],
        firstEncounter: DateTime.now().subtract(const Duration(days: 60)),
        personality: {
          'intelligent': 0.9,
          'calculating': 0.8,
          'charismatic': 0.7,
          'ruthless': 0.7,
        },
        weaknesses: ['overconfidence', 'trust_issues', 'perfectionist'],
        strengths: ['strategy', 'network', 'drug_trade'],
        backstory: 'Colombian cartel princess who established a drug empire through cunning and brutality.',
      ),
      Rival(
        id: 'rival_detective_hayes',
        name: 'Detective Sarah Hayes',
        nickname: 'The Bloodhound',
        type: RivalType.policeDepartment,
        level: RivalshipLevel.nemesis,
        power: 0.7,
        influence: 0.8,
        resources: 0.6,
        reputation: 0.9,
        intelligence: 0.95,
        ruthlessness: 0.3,
        territories: ['downtown_financial', 'university_district'],
        firstEncounter: DateTime.now().subtract(const Duration(days: 90)),
        personality: {
          'intelligent': 0.95,
          'determined': 0.9,
          'honest': 0.8,
          'obsessive': 0.7,
        },
        weaknesses: ['by_the_book', 'family', 'guilt'],
        strengths: ['investigation', 'legal_system', 'public_support'],
        backstory: 'Brilliant detective with a personal vendetta after her partner was killed in a drug bust.',
      ),
      Rival(
        id: 'rival_chen_wu',
        name: 'Chen Wu',
        nickname: 'The Ghost',
        type: RivalType.criminalMastermind,
        level: RivalshipLevel.competitor,
        power: 0.6,
        influence: 0.7,
        resources: 0.8,
        reputation: 0.5,
        intelligence: 0.95,
        ruthlessness: 0.6,
        territories: ['downtown_entertainment', 'redlight_central'],
        firstEncounter: DateTime.now().subtract(const Duration(days: 15)),
        personality: {
          'intelligent': 0.95,
          'mysterious': 0.9,
          'patient': 0.8,
          'calculating': 0.9,
        },
        weaknesses: ['overplanning', 'isolation', 'pride'],
        strengths: ['planning', 'technology', 'stealth'],
        backstory: 'Former tech genius turned criminal mastermind specializing in high-tech heists.',
      ),
      Rival(
        id: 'rival_tommy_oneill',
        name: 'Tommy O\'Neill',
        nickname: 'Mad Dog',
        type: RivalType.streetGang,
        level: RivalshipLevel.competitor,
        power: 0.5,
        influence: 0.4,
        resources: 0.3,
        reputation: 0.6,
        intelligence: 0.4,
        ruthlessness: 0.8,
        territories: ['slums_south'],
        firstEncounter: DateTime.now().subtract(const Duration(days: 45)),
        personality: {
          'aggressive': 0.9,
          'impulsive': 0.8,
          'loyal': 0.7,
          'unpredictable': 0.9,
        },
        weaknesses: ['impulsive', 'drug_addiction', 'limited_resources'],
        strengths: ['street_fighting', 'unpredictability', 'local_knowledge'],
        backstory: 'Violent street gang leader with a hair-trigger temper and nothing to lose.',
      ),
      Rival(
        id: 'rival_james_blackwood',
        name: 'James Blackwood',
        nickname: 'The Kingmaker',
        type: RivalType.businessTycoon,
        level: RivalshipLevel.rival,
        power: 0.8,
        influence: 0.9,
        resources: 0.95,
        reputation: 0.7,
        intelligence: 0.8,
        ruthlessness: 0.6,
        territories: ['downtown_financial', 'downtown_business'],
        firstEncounter: DateTime.now().subtract(const Duration(days: 120)),
        personality: {
          'intelligent': 0.8,
          'manipulative': 0.9,
          'patient': 0.7,
          'greedy': 0.8,
        },
        weaknesses: ['greed', 'public_image', 'legal_scrutiny'],
        strengths: ['money', 'connections', 'legal_protection'],
        backstory: 'Corrupt business tycoon who controls half the city through money and influence.',
      ),
    ];
  }

  void _generateRivalGangs() {
    final gangDefinitions = [
      RivalGang(
        id: 'gang_red_dragons',
        leaderId: 'rival_chen_wu',
        name: 'Red Dragons',
        members: ['chen_wu', 'li_ming', 'wang_lei', 'zhao_feng'],
        territories: ['downtown_entertainment'],
        strength: 0.7,
        unity: 0.8,
        specialties: {
          'technology': 0.9,
          'stealth': 0.8,
          'planning': 0.9,
        },
      ),
      RivalGang(
        id: 'gang_iron_wolves',
        leaderId: 'rival_viktor_kozlov',
        name: 'Iron Wolves',
        members: ['viktor_kozlov', 'dmitri_petrov', 'sergei_volkov'],
        territories: ['industrial_east', 'slums_east'],
        strength: 0.9,
        unity: 0.9,
        specialties: {
          'violence': 0.9,
          'intimidation': 0.8,
          'territory_control': 0.8,
        },
      ),
      RivalGang(
        id: 'gang_south_side_dogs',
        leaderId: 'rival_tommy_oneill',
        name: 'South Side Dogs',
        members: ['tommy_oneill', 'mike_murphy', 'sean_kelly'],
        territories: ['slums_south'],
        strength: 0.5,
        unity: 0.6,
        specialties: {
          'street_fighting': 0.7,
          'drug_dealing': 0.6,
          'local_contacts': 0.8,
        },
      ),
    ];

    for (final gang in gangDefinitions) {
      _rivalGangs[gang.id] = gang;
    }
  }

  void _startSystemTimer() {
    _systemTimer?.cancel();
    _systemTimer = Timer.periodic(const Duration(seconds: 6), (_) {
      _updateRivals();
      _processRivalActions();
      _updateConflicts();
      _generateRandomEvents();
      _updateThreatLevels();
      notifyListeners();
    });
  }

  // Rival Interaction Management
  void escalateRivalry(String rivalId, ConflictType conflictType, double intensity) {
    final rival = _rivals[rivalId];
    if (rival == null) return;

    final currentLevel = rival.level;
    RivalshipLevel newLevel = currentLevel;

    // Escalate based on intensity and current level
    if (intensity > 0.7 && currentLevel.index < RivalshipLevel.archenemesis.index) {
      newLevel = RivalshipLevel.values[currentLevel.index + 1];
    }

    // Update conflicts
    final newConflicts = Map<ConflictType, double>.from(rival.conflicts);
    newConflicts[conflictType] = (newConflicts[conflictType] ?? 0.0) + intensity;

    _rivals[rivalId] = rival.copyWith(
      level: newLevel,
      conflicts: newConflicts,
      lastAction: DateTime.now(),
    );

    // Check if this rival becomes the nemesis
    if (newLevel == RivalshipLevel.nemesis || newLevel == RivalshipLevel.archenemesis) {
      _currentNemesis = rivalId;
    }

    // Create escalation event
    _createRivalEvent(rivalId, RivalAction.intimidate, 
        'Rivalry escalated to ${newLevel.name}', intensity, true);
  }

  void attemptRivalAction(String rivalId, RivalAction action, {String? targetId}) {
    final rival = _rivals[rivalId];
    if (rival == null || !rival.isActive) return;

    final success = _calculateActionSuccess(rival, action);
    final impact = _calculateActionImpact(rival, action);

    if (_random.nextDouble() < success) {
      _executeSuccessfulAction(rival, action, impact, targetId);
    } else {
      _executeFailedAction(rival, action, impact, targetId);
    }

    // Update rival stats
    _rivals[rivalId] = rival.copyWith(
      lastAction: DateTime.now(),
      totalActions: rival.totalActions + 1,
    );
  }

  double _calculateActionSuccess(Rival rival, RivalAction action) {
    double baseChance = 0.5;

    // Action-specific modifiers
    switch (action) {
      case RivalAction.sabotage:
        baseChance = 0.4 + (rival.intelligence * 0.3);
        break;
      case RivalAction.attack:
        baseChance = 0.3 + (rival.power * 0.4);
        break;
      case RivalAction.steal:
        baseChance = 0.3 + (rival.intelligence * 0.2) + (rival.ruthlessness * 0.2);
        break;
      case RivalAction.intimidate:
        baseChance = 0.5 + (rival.ruthlessness * 0.3);
        break;
      case RivalAction.negotiate:
        baseChance = 0.6 + (rival.influence * 0.2);
        break;
      default:
        break;
    }

    // Rival type modifiers
    switch (rival.type) {
      case RivalType.criminalMastermind:
        if ([RivalAction.sabotage, RivalAction.steal].contains(action)) {
          baseChance += 0.2;
        }
        break;
      case RivalType.gangLeader:
        if ([RivalAction.attack, RivalAction.intimidate].contains(action)) {
          baseChance += 0.2;
        }
        break;
      case RivalType.policeDepartment:
        if ([RivalAction.investigation, RivalAction.frame].contains(action)) {
          baseChance += 0.3;
        }
        break;
      default:
        break;
    }

    return baseChance.clamp(0.1, 0.9);
  }

  double _calculateActionImpact(Rival rival, RivalAction action) {
    double baseImpact = 0.3;

    // Action severity
    switch (action) {
      case RivalAction.eliminate:
        baseImpact = 1.0;
        break;
      case RivalAction.attack:
        baseImpact = 0.7;
        break;
      case RivalAction.sabotage:
        baseImpact = 0.5;
        break;
      case RivalAction.steal:
        baseImpact = 0.4;
        break;
      case RivalAction.intimidate:
        baseImpact = 0.3;
        break;
      default:
        break;
    }

    // Rival power modifier
    baseImpact *= (0.5 + rival.overallThreat);

    return baseImpact.clamp(0.1, 1.0);
  }

  void _executeSuccessfulAction(Rival rival, RivalAction action, double impact, String? targetId) {
    String description = '';
    final consequences = <String, dynamic>{};

    switch (action) {
      case RivalAction.sabotage:
        description = '${rival.nickname} successfully sabotaged your operations';
        consequences['moneyLoss'] = impact * 50000;
        consequences['reputationLoss'] = impact * 0.1;
        break;
      case RivalAction.attack:
        description = '${rival.nickname} launched a successful attack';
        consequences['casualties'] = (impact * 10).round();
        consequences['territoryThreat'] = impact * 0.3;
        break;
      case RivalAction.steal:
        description = '${rival.nickname} stole valuable assets';
        consequences['assetLoss'] = impact * 30000;
        consequences['securityBreach'] = true;
        break;
      case RivalAction.intimidate:
        description = '${rival.nickname} intimidated your associates';
        consequences['loyaltyLoss'] = impact * 0.2;
        consequences['fearIncrease'] = impact * 0.3;
        break;
      case RivalAction.recruit:
        description = '${rival.nickname} recruited from your organization';
        consequences['memberLoss'] = (impact * 5).round();
        consequences['rivalStrengthGain'] = impact * 0.1;
        break;
      default:
        description = '${rival.nickname} took action against you';
        break;
    }

    _createRivalEvent(rival.id, action, description, impact, false, consequences);
  }

  void _executeFailedAction(Rival rival, RivalAction action, double impact, String? targetId) {
    String description = '';
    final consequences = <String, dynamic>{};

    switch (action) {
      case RivalAction.sabotage:
        description = '${rival.nickname}\'s sabotage attempt was foiled';
        consequences['intelligenceGain'] = impact * 0.2;
        break;
      case RivalAction.attack:
        description = '${rival.nickname}\'s attack was repelled';
        consequences['reputationGain'] = impact * 0.1;
        consequences['enemyCasualties'] = (impact * 5).round();
        break;
      case RivalAction.steal:
        description = '${rival.nickname}\'s theft attempt failed';
        consequences['securityImproved'] = true;
        break;
      default:
        description = '${rival.nickname}\'s action failed';
        break;
    }

    // Failed actions can escalate rivalry
    escalateRivalry(rival.id, ConflictType.personal, impact * 0.5);

    _createRivalEvent(rival.id, action, description, impact * 0.5, false, consequences);
  }

  void _createRivalEvent(String rivalId, RivalAction action, String description, 
                        double impact, bool playerInitiated, [Map<String, dynamic>? consequences]) {
    final eventId = 'event_${DateTime.now().millisecondsSinceEpoch}';
    
    final event = RivalEvent(
      id: eventId,
      rivalId: rivalId,
      action: action,
      description: description,
      timestamp: DateTime.now(),
      consequences: consequences ?? {},
      impact: impact,
      playerInitiated: playerInitiated,
    );

    _events[eventId] = event;
  }

  // Vendetta Management
  void startVendetta(String rivalId, String cause, double intensity) {
    final vendettaId = 'vendetta_${DateTime.now().millisecondsSinceEpoch}';
    
    final vendetta = Vendetta(
      id: vendettaId,
      rivalId: rivalId,
      playerId: _playerId!,
      cause: cause,
      startDate: DateTime.now(),
      intensity: intensity,
    );

    _vendettas[vendettaId] = vendetta;

    // Automatically escalate the rivalry
    escalateRivalry(rivalId, ConflictType.revenge, intensity);
  }

  void resolveVendetta(String vendettaId, String resolution) {
    final vendetta = _vendettas[vendettaId];
    if (vendetta == null || vendetta.resolved) return;

    _vendettas[vendettaId] = Vendetta(
      id: vendetta.id,
      rivalId: vendetta.rivalId,
      playerId: vendetta.playerId,
      cause: vendetta.cause,
      startDate: vendetta.startDate,
      intensity: vendetta.intensity,
      events: vendetta.events,
      conditions: vendetta.conditions,
      resolved: true,
      resolution: resolution,
    );

    // Potentially change rival status based on resolution
    final rival = _rivals[vendetta.rivalId];
    if (rival != null) {
      RivalStatus newStatus = rival.status;
      RivalshipLevel newLevel = rival.level;

      if (resolution.contains('eliminated')) {
        newStatus = RivalStatus.dead;
      } else if (resolution.contains('imprisoned')) {
        newStatus = RivalStatus.imprisoned;
      } else if (resolution.contains('alliance')) {
        newStatus = RivalStatus.allied;
        newLevel = RivalshipLevel.neutral;
      }

      _rivals[vendetta.rivalId] = rival.copyWith(
        status: newStatus,
        level: newLevel,
      );
    }
  }

  // System Updates
  void _updateRivals() {
    for (final rivalId in _rivals.keys.toList()) {
      final rival = _rivals[rivalId]!;
      
      if (rival.isActive) {
        _updateActiveRival(rival);
      }
    }
  }

  void _updateActiveRival(Rival rival) {
    // Rivals grow stronger over time
    if (_random.nextDouble() < 0.01) {
      final growthAreas = ['power', 'influence', 'resources', 'reputation'];
      final area = growthAreas[_random.nextInt(growthAreas.length)];
      final growth = 0.01 + (_random.nextDouble() * 0.02);

      switch (area) {
        case 'power':
          _rivals[rival.id] = rival.copyWith(
            power: (rival.power + growth).clamp(0.0, 1.0),
          );
          break;
        case 'influence':
          _rivals[rival.id] = rival.copyWith(
            influence: (rival.influence + growth).clamp(0.0, 1.0),
          );
          break;
        case 'resources':
          _rivals[rival.id] = rival.copyWith(
            resources: (rival.resources + growth).clamp(0.0, 1.0),
          );
          break;
        case 'reputation':
          _rivals[rival.id] = rival.copyWith(
            reputation: (rival.reputation + growth).clamp(0.0, 1.0),
          );
          break;
      }
    }
  }

  void _processRivalActions() {
    for (final rival in _rivals.values) {
      if (rival.isActive && _shouldRivalAct(rival)) {
        final action = _selectRivalAction(rival);
        attemptRivalAction(rival.id, action);
      }
    }
  }

  bool _shouldRivalAct(Rival rival) {
    // Higher level rivals act more frequently
    final actionChance = 0.02 + (rival.level.index * 0.01);
    
    // Nemeses are much more active
    if (rival.isNemesis) {
      return _random.nextDouble() < (actionChance * 3);
    }

    return _random.nextDouble() < actionChance;
  }

  RivalAction _selectRivalAction(Rival rival) {
    final actions = <RivalAction>[];

    // Add actions based on rival type and personality
    switch (rival.type) {
      case RivalType.gangLeader:
        actions.addAll([RivalAction.attack, RivalAction.intimidate, RivalAction.recruit]);
        break;
      case RivalType.criminalMastermind:
        actions.addAll([RivalAction.sabotage, RivalAction.steal, RivalAction.frame]);
        break;
      case RivalType.policeDepartment:
        actions.addAll([RivalAction.investigation, RivalAction.frame]);
        break;
      case RivalType.businessTycoon:
        actions.addAll([RivalAction.sabotage, RivalAction.negotiate]);
        break;
      default:
        actions.addAll([RivalAction.attack, RivalAction.intimidate]);
        break;
    }

    // Add personality-based actions
    if (rival.ruthlessness > 0.7) {
      actions.add(RivalAction.attack);
    }
    if (rival.intelligence > 0.7) {
      actions.add(RivalAction.sabotage);
    }

    return actions[_random.nextInt(actions.length)];
  }

  void _updateConflicts() {
    _activeConflicts = _rivals.values
        .where((rival) => rival.isActive && rival.level.index >= RivalshipLevel.rival.index)
        .length;
  }

  void _generateRandomEvents() {
    if (_random.nextDouble() < 0.01) {
      _generateRivalEvent();
    }
  }

  void _generateRivalEvent() {
    final events = [
      'rival_betrayal',
      'new_rival_appears',
      'rival_alliance_offer',
      'rival_weakness_discovered',
      'rival_power_struggle',
    ];

    final eventType = events[_random.nextInt(events.length)];
    
    switch (eventType) {
      case 'rival_betrayal':
        _handleRivalBetrayal();
        break;
      case 'new_rival_appears':
        _generateNewRival();
        break;
      case 'rival_alliance_offer':
        _generateAllianceOffer();
        break;
      case 'rival_weakness_discovered':
        _discoverRivalWeakness();
        break;
      case 'rival_power_struggle':
        _handleRivalPowerStruggle();
        break;
    }
  }

  void _handleRivalBetrayal() {
    final activeRivals = _rivals.values.where((r) => r.isActive).toList();
    if (activeRivals.isEmpty) return;

    final traitor = activeRivals[_random.nextInt(activeRivals.length)];
    
    // Create betrayal event
    _createRivalEvent(traitor.id, RivalAction.betrayal,
        '${traitor.nickname} betrayed their own organization', 0.6, false);
    
    // Weaken the rival
    _rivals[traitor.id] = traitor.copyWith(
      power: traitor.power * 0.8,
      loyalty: traitor.loyalty * 0.5,
    );
  }

  void _generateNewRival() {
    final newRivalId = 'rival_${DateTime.now().millisecondsSinceEpoch}';
    final names = ['Alexander Kane', 'Isabella Cruz', 'Marcus Thompson', 'Elena Vasquez'];
    final nicknames = ['The Phantom', 'Iron Fist', 'The Viper', 'Silent Death'];
    
    final newRival = Rival(
      id: newRivalId,
      name: names[_random.nextInt(names.length)],
      nickname: nicknames[_random.nextInt(nicknames.length)],
      type: RivalType.values[_random.nextInt(RivalType.values.length)],
      power: 0.3 + (_random.nextDouble() * 0.4),
      influence: 0.2 + (_random.nextDouble() * 0.5),
      resources: 0.2 + (_random.nextDouble() * 0.5),
      reputation: 0.1 + (_random.nextDouble() * 0.3),
      intelligence: 0.3 + (_random.nextDouble() * 0.6),
      ruthlessness: 0.2 + (_random.nextDouble() * 0.7),
      firstEncounter: DateTime.now(),
      backstory: 'A new player has entered the game with unknown motives.',
    );

    _rivals[newRivalId] = newRival;
    _totalRivals++;
  }

  void _generateAllianceOffer() {
    final eligibleRivals = _rivals.values
        .where((r) => r.isActive && r.level == RivalshipLevel.competitor)
        .toList();
    
    if (eligibleRivals.isEmpty) return;

    final rival = eligibleRivals[_random.nextInt(eligibleRivals.length)];
    
    _createRivalEvent(rival.id, RivalAction.alliance,
        '${rival.nickname} offers a temporary alliance', 0.3, false);
  }

  void _discoverRivalWeakness() {
    final rivals = _rivals.values.where((r) => r.isActive).toList();
    if (rivals.isEmpty) return;

    final rival = rivals[_random.nextInt(rivals.length)];
    
    _createRivalEvent(rival.id, RivalAction.investigation,
        'Discovered intelligence about ${rival.nickname}\'s operations', 0.4, true);
  }

  void _handleRivalPowerStruggle() {
    final gangRivals = _rivals.values
        .where((r) => r.isActive && [RivalType.gangLeader, RivalType.streetGang].contains(r.type))
        .toList();
    
    if (gangRivals.length < 2) return;

    final rival1 = gangRivals[_random.nextInt(gangRivals.length)];
    final rival2 = gangRivals[_random.nextInt(gangRivals.length)];
    
    if (rival1.id == rival2.id) return;

    // Power struggle weakens both rivals
    _rivals[rival1.id] = rival1.copyWith(
      power: rival1.power * 0.9,
      resources: rival1.resources * 0.9,
    );
    
    _rivals[rival2.id] = rival2.copyWith(
      power: rival2.power * 0.9,
      resources: rival2.resources * 0.9,
    );

    _createRivalEvent(rival1.id, RivalAction.attack,
        '${rival1.nickname} and ${rival2.nickname} engaged in a power struggle', 0.5, false);
  }

  void _updateThreatLevels() {
    _overallThreatLevel = 0.0;
    
    for (final rival in _rivals.values) {
      if (rival.isActive) {
        final threatContribution = rival.overallThreat * (rival.level.index + 1) * 0.2;
        _overallThreatLevel += threatContribution;
      }
    }
    
    _overallThreatLevel = _overallThreatLevel.clamp(0.0, 1.0);
  }

  // Public Interface Methods
  List<Rival> getActiveRivals() {
    return _rivals.values
        .where((rival) => rival.isActive)
        .toList()
        ..sort((a, b) => b.overallThreat.compareTo(a.overallThreat));
  }

  List<Rival> getRivalsByLevel(RivalshipLevel level) {
    return _rivals.values
        .where((rival) => rival.level == level)
        .toList()
        ..sort((a, b) => b.overallThreat.compareTo(a.overallThreat));
  }

  List<RivalEvent> getRecentEvents({int limit = 10}) {
    final events = _events.values.toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    
    return events.take(limit).toList();
  }

  List<Vendetta> getActiveVendettas() {
    return _vendettas.values
        .where((vendetta) => vendetta.isActive)
        .toList()
        ..sort((a, b) => b.intensity.compareTo(a.intensity));
  }

  Rival? getNemesis() {
    return _currentNemesis != null ? _rivals[_currentNemesis] : null;
  }

  double getRivalThreat(String rivalId) {
    final rival = _rivals[rivalId];
    return rival?.overallThreat ?? 0.0;
  }

  bool canStartVendetta(String rivalId) {
    final rival = _rivals[rivalId];
    if (rival == null || !rival.isActive) return false;
    
    // Check if vendetta already exists
    return !_vendettas.values.any((v) => v.rivalId == rivalId && v.isActive);
  }

  void dispose() {
    _systemTimer?.cancel();
    super.dispose();
  }
}

// Advanced Nemesis Dashboard Widget
class AdvancedNemesisDashboardWidget extends StatefulWidget {
  const AdvancedNemesisDashboardWidget({super.key});

  @override
  State<AdvancedNemesisDashboardWidget> createState() => _AdvancedNemesisDashboardWidgetState();
}

class _AdvancedNemesisDashboardWidgetState extends State<AdvancedNemesisDashboardWidget>
    with TickerProviderStateMixin {
  final AdvancedNemesisSystem _nemesisSystem = AdvancedNemesisSystem();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _nemesisSystem,
      builder: (context, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                _buildThreatIndicator(),
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
    final nemesis = _nemesisSystem.getNemesis();
    
    return Row(
      children: [
        const Text(
          'Nemesis System',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        if (nemesis != null) ...[
          const Icon(Icons.warning, color: Colors.red),
          const SizedBox(width: 8),
          Text('Current Nemesis: ${nemesis.nickname}'),
        ],
      ],
    );
  }

  Widget _buildThreatIndicator() {
    return Card(
      color: _getThreatColor(_nemesisSystem.overallThreatLevel),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            const Icon(Icons.warning, color: Colors.white),
            const SizedBox(width: 8),
            const Text('Threat Level:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            Expanded(
              child: LinearProgressIndicator(
                value: _nemesisSystem.overallThreatLevel,
                backgroundColor: Colors.white30,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${(_nemesisSystem.overallThreatLevel * 100).toInt()}%',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      tabs: const [
        Tab(text: 'Active Rivals', icon: Icon(Icons.people)),
        Tab(text: 'Events', icon: Icon(Icons.history)),
        Tab(text: 'Vendettas', icon: Icon(Icons.gavel)),
        Tab(text: 'Gangs', icon: Icon(Icons.group)),
      ],
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildRivalsTab(),
        _buildEventsTab(),
        _buildVendettasTab(),
        _buildGangsTab(),
      ],
    );
  }

  Widget _buildRivalsTab() {
    final activeRivals = _nemesisSystem.getActiveRivals();
    
    if (activeRivals.isEmpty) {
      return const Center(child: Text('No active rivals'));
    }

    return ListView.builder(
      itemCount: activeRivals.length,
      itemBuilder: (context, index) {
        final rival = activeRivals[index];
        return _buildRivalCard(rival);
      },
    );
  }

  Widget _buildRivalCard(Rival rival) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: _getRivalLevelColor(rival.level),
          child: Text(rival.nickname[0]),
        ),
        title: Text('${rival.name} "${rival.nickname}"'),
        subtitle: Text('${_getRivalLevelName(rival.level)} - Threat: ${(rival.overallThreat * 100).toInt()}%'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Type: ${_getRivalTypeName(rival.type)}'),
                const SizedBox(height: 8),
                _buildRivalStats(rival),
                const SizedBox(height: 8),
                Text('Backstory: ${rival.backstory}'),
                const SizedBox(height: 8),
                if (rival.weaknesses.isNotEmpty) ...[
                  Text('Weaknesses: ${rival.weaknesses.join(', ')}'),
                  const SizedBox(height: 8),
                ],
                _buildRivalActions(rival),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRivalStats(Rival rival) {
    return Column(
      children: [
        _buildStatBar('Power', rival.power),
        _buildStatBar('Influence', rival.influence),
        _buildStatBar('Resources', rival.resources),
        _buildStatBar('Intelligence', rival.intelligence),
        _buildStatBar('Ruthlessness', rival.ruthlessness),
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

  Widget _buildRivalActions(Rival rival) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () => _escalateRivalry(rival),
          child: const Text('Escalate'),
        ),
        if (_nemesisSystem.canStartVendetta(rival.id))
          ElevatedButton(
            onPressed: () => _startVendetta(rival),
            child: const Text('Vendetta'),
          ),
        ElevatedButton(
          onPressed: () => _attackRival(rival),
          child: const Text('Attack'),
        ),
      ],
    );
  }

  Widget _buildEventsTab() {
    final recentEvents = _nemesisSystem.getRecentEvents();
    
    if (recentEvents.isEmpty) {
      return const Center(child: Text('No recent events'));
    }

    return ListView.builder(
      itemCount: recentEvents.length,
      itemBuilder: (context, index) {
        final event = recentEvents[index];
        return _buildEventTile(event);
      },
    );
  }

  Widget _buildEventTile(RivalEvent event) {
    final rival = _nemesisSystem.rivals[event.rivalId];
    
    return ListTile(
      leading: Icon(
        _getActionIcon(event.action),
        color: event.playerInitiated ? Colors.green : Colors.red,
      ),
      title: Text(event.description),
      subtitle: Text(
        '${rival?.nickname ?? 'Unknown'} - ${_formatDateTime(event.timestamp)}',
      ),
      trailing: Text('Impact: ${(event.impact * 100).toInt()}%'),
    );
  }

  Widget _buildVendettasTab() {
    final activeVendettas = _nemesisSystem.getActiveVendettas();
    
    if (activeVendettas.isEmpty) {
      return const Center(child: Text('No active vendettas'));
    }

    return ListView.builder(
      itemCount: activeVendettas.length,
      itemBuilder: (context, index) {
        final vendetta = activeVendettas[index];
        return _buildVendettaTile(vendetta);
      },
    );
  }

  Widget _buildVendettaTile(Vendetta vendetta) {
    final rival = _nemesisSystem.rivals[vendetta.rivalId];
    
    return Card(
      child: ListTile(
        leading: const Icon(Icons.gavel, color: Colors.red),
        title: Text('Vendetta vs ${rival?.nickname ?? 'Unknown'}'),
        subtitle: Text('Cause: ${vendetta.cause}\nDuration: ${vendetta.duration.inDays} days'),
        trailing: Text('Intensity: ${(vendetta.intensity * 100).toInt()}%'),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildGangsTab() {
    final rivalGangs = _nemesisSystem.rivalGangs.values.toList();
    
    if (rivalGangs.isEmpty) {
      return const Center(child: Text('No rival gangs'));
    }

    return ListView.builder(
      itemCount: rivalGangs.length,
      itemBuilder: (context, index) {
        final gang = rivalGangs[index];
        return _buildGangTile(gang);
      },
    );
  }

  Widget _buildGangTile(RivalGang gang) {
    final leader = _nemesisSystem.rivals[gang.leaderId];
    
    return Card(
      child: ListTile(
        leading: const Icon(Icons.group),
        title: Text(gang.name),
        subtitle: Text(
          'Leader: ${leader?.name ?? 'Unknown'}\n'
          'Members: ${gang.members.length}\n'
          'Territories: ${gang.territories.length}',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Strength: ${(gang.strength * 100).toInt()}%'),
            Text('Unity: ${(gang.unity * 100).toInt()}%'),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  void _escalateRivalry(Rival rival) {
    _nemesisSystem.escalateRivalry(rival.id, ConflictType.territorial, 0.3);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Escalated rivalry with ${rival.nickname}'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _startVendetta(Rival rival) {
    _nemesisSystem.startVendetta(rival.id, 'Personal conflict escalated to vendetta', 0.7);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Started vendetta against ${rival.nickname}'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _attackRival(Rival rival) {
    _nemesisSystem.attemptRivalAction(rival.id, RivalAction.attack);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Initiated attack on ${rival.nickname}'),
        backgroundColor: Colors.red,
      ),
    );
  }

  Color _getThreatColor(double threatLevel) {
    if (threatLevel < 0.3) return Colors.green;
    if (threatLevel < 0.6) return Colors.orange;
    return Colors.red;
  }

  Color _getRivalLevelColor(RivalshipLevel level) {
    switch (level) {
      case RivalshipLevel.neutral:
        return Colors.grey;
      case RivalshipLevel.competitor:
        return Colors.blue;
      case RivalshipLevel.rival:
        return Colors.orange;
      case RivalshipLevel.enemy:
        return Colors.red;
      case RivalshipLevel.nemesis:
        return Colors.purple;
      case RivalshipLevel.archenemesis:
        return Colors.black;
    }
  }

  Color _getStatColor(double value) {
    if (value < 0.3) return Colors.green;
    if (value < 0.7) return Colors.orange;
    return Colors.red;
  }

  String _getRivalLevelName(RivalshipLevel level) {
    return level.name[0].toUpperCase() + level.name.substring(1);
  }

  String _getRivalTypeName(RivalType type) {
    return type.name.split('').map((c) => 
      c == c.toUpperCase() && type.name.indexOf(c) > 0 ? ' $c' : c
    ).join('').split(' ').map((word) => 
      word[0].toUpperCase() + word.substring(1)
    ).join(' ');
  }

  IconData _getActionIcon(RivalAction action) {
    switch (action) {
      case RivalAction.attack:
        return Icons.local_fire_department;
      case RivalAction.sabotage:
        return Icons.build;
      case RivalAction.steal:
        return Icons.money_off;
      case RivalAction.intimidate:
        return Icons.warning;
      case RivalAction.negotiate:
        return Icons.handshake;
      case RivalAction.alliance:
        return Icons.group_add;
      case RivalAction.betrayal:
        return Icons.dangerous;
      default:
        return Icons.help_outline;
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
