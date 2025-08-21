import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

// Advanced Territory & Expansion System
// Feature #16: Ultra-comprehensive territory control with districts,
// influence zones, expansion mechanics, territory wars, and strategic control

enum TerritoryType {
  residential,
  commercial,
  industrial,
  downtown,
  suburbs,
  docks,
  airport,
  university,
  financial,
  entertainment,
  redLight,
  slums
}

enum TerritoryStatus {
  neutral,
  contested,
  controlled,
  hostile,
  allied,
  disputed,
  expanding,
  fortified
}

enum InfluenceType {
  criminal,
  economic,
  political,
  social,
  military,
  informational,
  cultural,
  territorial
}

enum ExpansionMethod {
  peaceful,
  aggressive,
  economic,
  political,
  infiltration,
  alliance,
  acquisition,
  intimidation
}

enum TerritoryFeature {
  safehouse,
  drugLab,
  warehouse,
  moneyLaundering,
  casino,
  nightclub,
  restaurant,
  hotel,
  shop,
  garage,
  hospital,
  policeStation,
  courthouse,
  bank,
  port,
  factory
}

enum DefenseLevel {
  none,
  minimal,
  light,
  moderate,
  heavy,
  fortress,
  impregnable
}

class Territory {
  final String id;
  final String name;
  final TerritoryType type;
  final TerritoryStatus status;
  final String? controlledBy;
  final double size;
  final double population;
  final double wealth;
  final double crimeRate;
  final double policePresence;
  final Map<InfluenceType, double> influence;
  final List<TerritoryFeature> features;
  final DefenseLevel defenseLevel;
  final List<String> adjacentTerritories;
  final Map<String, double> relationships;
  final DateTime? controlledSince;
  final double loyalty;
  final double development;
  final Map<String, dynamic> properties;

  Territory({
    required this.id,
    required this.name,
    required this.type,
    this.status = TerritoryStatus.neutral,
    this.controlledBy,
    required this.size,
    required this.population,
    required this.wealth,
    this.crimeRate = 0.5,
    this.policePresence = 0.5,
    this.influence = const {},
    this.features = const [],
    this.defenseLevel = DefenseLevel.none,
    this.adjacentTerritories = const [],
    this.relationships = const {},
    this.controlledSince,
    this.loyalty = 0.0,
    this.development = 0.0,
    this.properties = const {},
  });

  Territory copyWith({
    String? id,
    String? name,
    TerritoryType? type,
    TerritoryStatus? status,
    String? controlledBy,
    double? size,
    double? population,
    double? wealth,
    double? crimeRate,
    double? policePresence,
    Map<InfluenceType, double>? influence,
    List<TerritoryFeature>? features,
    DefenseLevel? defenseLevel,
    List<String>? adjacentTerritories,
    Map<String, double>? relationships,
    DateTime? controlledSince,
    double? loyalty,
    double? development,
    Map<String, dynamic>? properties,
  }) {
    return Territory(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      status: status ?? this.status,
      controlledBy: controlledBy ?? this.controlledBy,
      size: size ?? this.size,
      population: population ?? this.population,
      wealth: wealth ?? this.wealth,
      crimeRate: crimeRate ?? this.crimeRate,
      policePresence: policePresence ?? this.policePresence,
      influence: influence ?? this.influence,
      features: features ?? this.features,
      defenseLevel: defenseLevel ?? this.defenseLevel,
      adjacentTerritories: adjacentTerritories ?? this.adjacentTerritories,
      relationships: relationships ?? this.relationships,
      controlledSince: controlledSince ?? this.controlledSince,
      loyalty: loyalty ?? this.loyalty,
      development: development ?? this.development,
      properties: properties ?? this.properties,
    );
  }

  double get totalInfluence {
    return influence.values.fold(0.0, (sum, value) => sum + value);
  }

  double get strategicValue {
    return (size * 0.3) + (population * 0.2) + (wealth * 0.4) + (totalInfluence * 0.1);
  }

  bool get isControlled => controlledBy != null;
  bool get isHostile => status == TerritoryStatus.hostile;
  bool get isContested => status == TerritoryStatus.contested;
  bool get isNeutral => status == TerritoryStatus.neutral;
}

class ExpansionPlan {
  final String id;
  final String targetTerritoryId;
  final ExpansionMethod method;
  final double cost;
  final double successChance;
  final Duration timeRequired;
  final DateTime startTime;
  final List<String> requiredResources;
  final Map<String, dynamic> parameters;

  ExpansionPlan({
    required this.id,
    required this.targetTerritoryId,
    required this.method,
    required this.cost,
    required this.successChance,
    required this.timeRequired,
    required this.startTime,
    this.requiredResources = const [],
    this.parameters = const {},
  });

  bool get isComplete => DateTime.now().isAfter(startTime.add(timeRequired));
  double get progress {
    final elapsed = DateTime.now().difference(startTime);
    return (elapsed.inMilliseconds / timeRequired.inMilliseconds).clamp(0.0, 1.0);
  }
}

class TerritoryWar {
  final String id;
  final List<String> participants;
  final String cause;
  final DateTime startTime;
  final DateTime? endTime;
  final List<String> battlefieldTerritories;
  final Map<String, double> casualties;
  final Map<String, double> losses;
  final String? winner;
  final Map<String, dynamic> warStats;

  TerritoryWar({
    required this.id,
    required this.participants,
    required this.cause,
    required this.startTime,
    this.endTime,
    this.battlefieldTerritories = const [],
    this.casualties = const {},
    this.losses = const {},
    this.winner,
    this.warStats = const {},
  });

  bool get isActive => endTime == null;
  Duration get duration => (endTime ?? DateTime.now()).difference(startTime);
}

class InfluenceNetwork {
  final String id;
  final String name;
  final InfluenceType type;
  final List<String> territories;
  final double strength;
  final double reach;
  final Map<String, double> connections;
  final DateTime establishedAt;

  InfluenceNetwork({
    required this.id,
    required this.name,
    required this.type,
    this.territories = const [],
    required this.strength,
    required this.reach,
    this.connections = const {},
    required this.establishedAt,
  });
}

class AdvancedTerritorySystem extends ChangeNotifier {
  static final AdvancedTerritorySystem _instance = AdvancedTerritorySystem._internal();
  factory AdvancedTerritorySystem() => _instance;
  AdvancedTerritorySystem._internal() {
    _initializeSystem();
  }

  final Map<String, Territory> _territories = {};
  final Map<String, ExpansionPlan> _expansionPlans = {};
  final Map<String, TerritoryWar> _activeWars = {};
  final Map<String, InfluenceNetwork> _influenceNetworks = {};
  
  String? _playerId;
  int _totalTerritories = 0;
  int _controlledTerritories = 0;
  double _totalInfluence = 0.0;
  double _territorialIncome = 0.0;
  double _expansionBudget = 100000.0;
  
  Timer? _systemTimer;
  final math.Random _random = math.Random();

  // Getters
  Map<String, Territory> get territories => Map.unmodifiable(_territories);
  Map<String, ExpansionPlan> get expansionPlans => Map.unmodifiable(_expansionPlans);
  Map<String, TerritoryWar> get activeWars => Map.unmodifiable(_activeWars);
  Map<String, InfluenceNetwork> get influenceNetworks => Map.unmodifiable(_influenceNetworks);
  String? get playerId => _playerId;
  int get totalTerritories => _totalTerritories;
  int get controlledTerritories => _controlledTerritories;
  double get totalInfluence => _totalInfluence;
  double get territorialIncome => _territorialIncome;
  double get expansionBudget => _expansionBudget;

  void _initializeSystem() {
    _playerId = 'player_${DateTime.now().millisecondsSinceEpoch}';
    _generateInitialTerritories();
    _generateInfluenceNetworks();
    _startSystemTimer();
  }

  void _generateInitialTerritories() {
    final territoryData = _getTerritoryDefinitions();
    
    for (final data in territoryData) {
      _territories[data.id] = data;
      _totalTerritories++;
    }
    
    // Give player control of one starting territory
    final startingTerritory = _territories.values.first;
    _claimTerritory(startingTerritory.id, _playerId!);
  }

  List<Territory> _getTerritoryDefinitions() {
    return [
      // Downtown Districts
      Territory(
        id: 'downtown_financial',
        name: 'Financial District',
        type: TerritoryType.financial,
        size: 2.5,
        population: 5000,
        wealth: 0.9,
        policePresence: 0.8,
        features: [TerritoryFeature.bank, TerritoryFeature.courthouse],
        adjacentTerritories: ['downtown_business', 'downtown_government'],
        influence: {
          InfluenceType.economic: 0.8,
          InfluenceType.political: 0.6,
        },
      ),
      Territory(
        id: 'downtown_business',
        name: 'Business Quarter',
        type: TerritoryType.commercial,
        size: 3.0,
        population: 8000,
        wealth: 0.7,
        policePresence: 0.6,
        features: [TerritoryFeature.restaurant, TerritoryFeature.hotel, TerritoryFeature.shop],
        adjacentTerritories: ['downtown_financial', 'downtown_entertainment'],
        influence: {
          InfluenceType.economic: 0.7,
          InfluenceType.social: 0.4,
        },
      ),
      Territory(
        id: 'downtown_entertainment',
        name: 'Entertainment District',
        type: TerritoryType.entertainment,
        size: 2.8,
        population: 12000,
        wealth: 0.6,
        policePresence: 0.4,
        features: [TerritoryFeature.casino, TerritoryFeature.nightclub],
        adjacentTerritories: ['downtown_business', 'redlight_central'],
        influence: {
          InfluenceType.social: 0.6,
          InfluenceType.criminal: 0.3,
        },
      ),
      
      // Red Light Districts
      Territory(
        id: 'redlight_central',
        name: 'Red Light Central',
        type: TerritoryType.redLight,
        size: 1.5,
        population: 3000,
        wealth: 0.3,
        crimeRate: 0.8,
        policePresence: 0.3,
        features: [TerritoryFeature.nightclub, TerritoryFeature.safehouse],
        adjacentTerritories: ['downtown_entertainment', 'slums_east'],
        influence: {
          InfluenceType.criminal: 0.7,
          InfluenceType.social: 0.4,
        },
      ),
      
      // Industrial Areas
      Territory(
        id: 'industrial_west',
        name: 'West Industrial Zone',
        type: TerritoryType.industrial,
        size: 5.0,
        population: 2000,
        wealth: 0.4,
        policePresence: 0.2,
        features: [TerritoryFeature.warehouse, TerritoryFeature.factory],
        adjacentTerritories: ['docks_main', 'suburbs_west'],
        influence: {
          InfluenceType.economic: 0.5,
          InfluenceType.criminal: 0.3,
        },
      ),
      Territory(
        id: 'industrial_east',
        name: 'East Industrial Zone',
        type: TerritoryType.industrial,
        size: 4.5,
        population: 1800,
        wealth: 0.4,
        policePresence: 0.2,
        features: [TerritoryFeature.drugLab, TerritoryFeature.warehouse],
        adjacentTerritories: ['airport_district', 'slums_east'],
        influence: {
          InfluenceType.economic: 0.4,
          InfluenceType.criminal: 0.5,
        },
      ),
      
      // Docks
      Territory(
        id: 'docks_main',
        name: 'Main Docks',
        type: TerritoryType.docks,
        size: 3.5,
        population: 1200,
        wealth: 0.5,
        policePresence: 0.3,
        features: [TerritoryFeature.port, TerritoryFeature.warehouse],
        adjacentTerritories: ['industrial_west', 'downtown_financial'],
        influence: {
          InfluenceType.economic: 0.6,
          InfluenceType.criminal: 0.4,
        },
      ),
      
      // Airport
      Territory(
        id: 'airport_district',
        name: 'Airport District',
        type: TerritoryType.airport,
        size: 4.0,
        population: 3000,
        wealth: 0.6,
        policePresence: 0.7,
        features: [TerritoryFeature.hotel, TerritoryFeature.shop],
        adjacentTerritories: ['industrial_east', 'suburbs_south'],
        influence: {
          InfluenceType.economic: 0.5,
          InfluenceType.political: 0.3,
        },
      ),
      
      // Suburbs
      Territory(
        id: 'suburbs_west',
        name: 'West Suburbs',
        type: TerritoryType.suburbs,
        size: 6.0,
        population: 25000,
        wealth: 0.6,
        policePresence: 0.5,
        features: [TerritoryFeature.shop, TerritoryFeature.restaurant],
        adjacentTerritories: ['industrial_west', 'suburbs_north'],
        influence: {
          InfluenceType.social: 0.6,
          InfluenceType.economic: 0.4,
        },
      ),
      Territory(
        id: 'suburbs_north',
        name: 'North Suburbs',
        type: TerritoryType.suburbs,
        size: 5.5,
        population: 22000,
        wealth: 0.7,
        policePresence: 0.6,
        features: [TerritoryFeature.hospital, TerritoryFeature.shop],
        adjacentTerritories: ['suburbs_west', 'university_district'],
        influence: {
          InfluenceType.social: 0.7,
          InfluenceType.political: 0.3,
        },
      ),
      Territory(
        id: 'suburbs_south',
        name: 'South Suburbs',
        type: TerritoryType.suburbs,
        size: 5.8,
        population: 20000,
        wealth: 0.5,
        policePresence: 0.5,
        features: [TerritoryFeature.garage, TerritoryFeature.shop],
        adjacentTerritories: ['airport_district', 'slums_south'],
        influence: {
          InfluenceType.social: 0.5,
          InfluenceType.economic: 0.4,
        },
      ),
      
      // University
      Territory(
        id: 'university_district',
        name: 'University District',
        type: TerritoryType.university,
        size: 3.0,
        population: 15000,
        wealth: 0.5,
        policePresence: 0.4,
        features: [TerritoryFeature.restaurant, TerritoryFeature.nightclub],
        adjacentTerritories: ['suburbs_north', 'downtown_business'],
        influence: {
          InfluenceType.social: 0.7,
          InfluenceType.cultural: 0.6,
        },
      ),
      
      // Slums
      Territory(
        id: 'slums_east',
        name: 'East Slums',
        type: TerritoryType.slums,
        size: 2.0,
        population: 8000,
        wealth: 0.1,
        crimeRate: 0.9,
        policePresence: 0.1,
        features: [TerritoryFeature.safehouse, TerritoryFeature.drugLab],
        adjacentTerritories: ['redlight_central', 'industrial_east'],
        influence: {
          InfluenceType.criminal: 0.8,
          InfluenceType.social: 0.2,
        },
      ),
      Territory(
        id: 'slums_south',
        name: 'South Slums',
        type: TerritoryType.slums,
        size: 2.2,
        population: 6000,
        wealth: 0.1,
        crimeRate: 0.8,
        policePresence: 0.1,
        features: [TerritoryFeature.safehouse, TerritoryFeature.moneyLaundering],
        adjacentTerritories: ['suburbs_south', 'industrial_east'],
        influence: {
          InfluenceType.criminal: 0.7,
          InfluenceType.social: 0.3,
        },
      ),
    ];
  }

  void _generateInfluenceNetworks() {
    final networks = [
      InfluenceNetwork(
        id: 'business_network',
        name: 'Business Alliance',
        type: InfluenceType.economic,
        territories: ['downtown_financial', 'downtown_business'],
        strength: 0.7,
        reach: 0.5,
        establishedAt: DateTime.now().subtract(const Duration(days: 365)),
      ),
      InfluenceNetwork(
        id: 'criminal_network',
        name: 'Underground Syndicate',
        type: InfluenceType.criminal,
        territories: ['redlight_central', 'slums_east', 'slums_south'],
        strength: 0.8,
        reach: 0.6,
        establishedAt: DateTime.now().subtract(const Duration(days: 180)),
      ),
      InfluenceNetwork(
        id: 'political_network',
        name: 'Political Machine',
        type: InfluenceType.political,
        territories: ['downtown_financial', 'university_district'],
        strength: 0.6,
        reach: 0.4,
        establishedAt: DateTime.now().subtract(const Duration(days: 730)),
      ),
    ];
    
    for (final network in networks) {
      _influenceNetworks[network.id] = network;
    }
  }

  void _startSystemTimer() {
    _systemTimer?.cancel();
    _systemTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      _updateTerritories();
      _processExpansionPlans();
      _updateInfluence();
      _generateTerritoryEvents();
      _calculateIncome();
      notifyListeners();
    });
  }

  // Territory Control
  bool claimTerritory(String territoryId, {ExpansionMethod method = ExpansionMethod.aggressive}) {
    final territory = _territories[territoryId];
    if (territory == null || territory.isControlled) return false;
    
    final cost = _calculateExpansionCost(territory, method);
    if (_expansionBudget < cost) return false;
    
    final successChance = _calculateSuccessChance(territory, method);
    if (_random.nextDouble() > successChance) return false;
    
    return _claimTerritory(territoryId, _playerId!);
  }

  bool _claimTerritory(String territoryId, String controllerId) {
    final territory = _territories[territoryId];
    if (territory == null) return false;
    
    _territories[territoryId] = territory.copyWith(
      controlledBy: controllerId,
      status: TerritoryStatus.controlled,
      controlledSince: DateTime.now(),
      loyalty: 0.3, // Start with low loyalty
    );
    
    if (controllerId == _playerId) {
      _controlledTerritories++;
    }
    
    notifyListeners();
    return true;
  }

  double _calculateExpansionCost(Territory territory, ExpansionMethod method) {
    double baseCost = territory.strategicValue * 10000;
    
    // Method modifiers
    switch (method) {
      case ExpansionMethod.peaceful:
        baseCost *= 0.5;
        break;
      case ExpansionMethod.aggressive:
        baseCost *= 1.2;
        break;
      case ExpansionMethod.economic:
        baseCost *= 2.0;
        break;
      case ExpansionMethod.political:
        baseCost *= 1.5;
        break;
      default:
        break;
    }
    
    // Territory modifiers
    if (territory.policePresence > 0.7) baseCost *= 1.5;
    if (territory.crimeRate > 0.7) baseCost *= 0.8;
    if (territory.wealth > 0.8) baseCost *= 1.3;
    
    return baseCost;
  }

  double _calculateSuccessChance(Territory territory, ExpansionMethod method) {
    double baseChance = 0.6;
    
    // Method effectiveness
    switch (method) {
      case ExpansionMethod.peaceful:
        baseChance = 0.8;
        break;
      case ExpansionMethod.aggressive:
        baseChance = 0.5;
        break;
      case ExpansionMethod.economic:
        baseChance = 0.7;
        break;
      case ExpansionMethod.infiltration:
        baseChance = 0.4;
        break;
      default:
        break;
    }
    
    // Territory factors
    baseChance -= territory.policePresence * 0.3;
    baseChance += territory.crimeRate * 0.2;
    baseChance -= territory.defenseLevel.index * 0.1;
    
    // Player influence in adjacent territories
    final adjacentControl = _getAdjacentControlRatio(territory);
    baseChance += adjacentControl * 0.2;
    
    return baseChance.clamp(0.1, 0.9);
  }

  double _getAdjacentControlRatio(Territory territory) {
    if (territory.adjacentTerritories.isEmpty) return 0.0;
    
    int controlledAdjacent = 0;
    for (final adjacentId in territory.adjacentTerritories) {
      final adjacent = _territories[adjacentId];
      if (adjacent != null && adjacent.controlledBy == _playerId) {
        controlledAdjacent++;
      }
    }
    
    return controlledAdjacent / territory.adjacentTerritories.length;
  }

  // Expansion Planning
  String planExpansion({
    required String territoryId,
    required ExpansionMethod method,
    Duration? timeframe,
  }) {
    final territory = _territories[territoryId];
    if (territory == null || territory.isControlled) {
      throw Exception('Invalid territory for expansion');
    }
    
    final planId = 'expansion_${DateTime.now().millisecondsSinceEpoch}';
    final cost = _calculateExpansionCost(territory, method);
    final successChance = _calculateSuccessChance(territory, method);
    final duration = timeframe ?? _calculateExpansionTime(territory, method);
    
    final plan = ExpansionPlan(
      id: planId,
      targetTerritoryId: territoryId,
      method: method,
      cost: cost,
      successChance: successChance,
      timeRequired: duration,
      startTime: DateTime.now(),
      requiredResources: _getRequiredResources(method),
    );
    
    _expansionPlans[planId] = plan;
    _expansionBudget -= cost;
    
    notifyListeners();
    return planId;
  }

  Duration _calculateExpansionTime(Territory territory, ExpansionMethod method) {
    int baseHours = 24;
    
    switch (method) {
      case ExpansionMethod.peaceful:
        baseHours = 48;
        break;
      case ExpansionMethod.aggressive:
        baseHours = 12;
        break;
      case ExpansionMethod.economic:
        baseHours = 72;
        break;
      case ExpansionMethod.infiltration:
        baseHours = 96;
        break;
      default:
        break;
    }
    
    // Territory complexity modifier
    baseHours = (baseHours * territory.strategicValue).round();
    
    return Duration(hours: baseHours);
  }

  List<String> _getRequiredResources(ExpansionMethod method) {
    switch (method) {
      case ExpansionMethod.aggressive:
        return ['weapons', 'personnel', 'vehicles'];
      case ExpansionMethod.economic:
        return ['money', 'legitimate_business', 'connections'];
      case ExpansionMethod.political:
        return ['political_connections', 'influence', 'information'];
      case ExpansionMethod.infiltration:
        return ['intelligence', 'inside_man', 'equipment'];
      default:
        return ['money', 'personnel'];
    }
  }

  void _processExpansionPlans() {
    final completedPlans = <String>[];
    
    for (final plan in _expansionPlans.values) {
      if (plan.isComplete) {
        _executeExpansionPlan(plan);
        completedPlans.add(plan.id);
      }
    }
    
    for (final planId in completedPlans) {
      _expansionPlans.remove(planId);
    }
  }

  void _executeExpansionPlan(ExpansionPlan plan) {
    final territory = _territories[plan.targetTerritoryId];
    if (territory == null) return;
    
    final success = _random.nextDouble() < plan.successChance;
    
    if (success) {
      _claimTerritory(plan.targetTerritoryId, _playerId!);
      
      // Apply method-specific effects
      _applyExpansionEffects(territory, plan.method);
    } else {
      // Expansion failed - consequences
      _handleExpansionFailure(territory, plan.method);
    }
  }

  void _applyExpansionEffects(Territory territory, ExpansionMethod method) {
    switch (method) {
      case ExpansionMethod.peaceful:
        // Higher loyalty, lower crime increase
        _territories[territory.id] = territory.copyWith(
          loyalty: 0.6,
          crimeRate: territory.crimeRate + 0.1,
        );
        break;
      case ExpansionMethod.aggressive:
        // Lower loyalty, higher crime increase
        _territories[territory.id] = territory.copyWith(
          loyalty: 0.2,
          crimeRate: territory.crimeRate + 0.3,
        );
        break;
      case ExpansionMethod.economic:
        // Moderate loyalty, economic benefits
        _territories[territory.id] = territory.copyWith(
          loyalty: 0.5,
          wealth: (territory.wealth + 0.1).clamp(0.0, 1.0),
        );
        break;
      default:
        break;
    }
  }

  void _handleExpansionFailure(Territory territory, ExpansionMethod method) {
    switch (method) {
      case ExpansionMethod.aggressive:
        // Increase police presence in the area
        _territories[territory.id] = territory.copyWith(
          policePresence: (territory.policePresence + 0.2).clamp(0.0, 1.0),
          status: TerritoryStatus.hostile,
        );
        break;
      case ExpansionMethod.infiltration:
        // Increase security and defense
        _territories[territory.id] = territory.copyWith(
          defenseLevel: DefenseLevel.values[
            (territory.defenseLevel.index + 1).clamp(0, DefenseLevel.values.length - 1)
          ],
        );
        break;
      default:
        break;
    }
  }

  // Territory Development
  bool developTerritory(String territoryId, TerritoryFeature feature) {
    final territory = _territories[territoryId];
    if (territory == null || territory.controlledBy != _playerId) return false;
    
    final cost = _getDevelopmentCost(feature);
    if (_expansionBudget < cost) return false;
    
    final newFeatures = List<TerritoryFeature>.from(territory.features)..add(feature);
    _territories[territoryId] = territory.copyWith(
      features: newFeatures,
      development: (territory.development + 0.1).clamp(0.0, 1.0),
    );
    
    _expansionBudget -= cost;
    
    notifyListeners();
    return true;
  }

  double _getDevelopmentCost(TerritoryFeature feature) {
    switch (feature) {
      case TerritoryFeature.safehouse:
        return 25000;
      case TerritoryFeature.drugLab:
        return 50000;
      case TerritoryFeature.warehouse:
        return 75000;
      case TerritoryFeature.moneyLaundering:
        return 100000;
      case TerritoryFeature.casino:
        return 200000;
      case TerritoryFeature.nightclub:
        return 150000;
      default:
        return 30000;
    }
  }

  // System Updates
  void _updateTerritories() {
    for (final territoryId in _territories.keys.toList()) {
      final territory = _territories[territoryId]!;
      
      if (territory.isControlled && territory.controlledBy == _playerId) {
        _updatePlayerTerritory(territory);
      } else {
        _updateNeutralTerritory(territory);
      }
    }
  }

  void _updatePlayerTerritory(Territory territory) {
    // Loyalty changes over time
    double loyaltyChange = 0.0;
    
    // Development increases loyalty
    loyaltyChange += territory.development * 0.001;
    
    // High crime decreases loyalty
    loyaltyChange -= territory.crimeRate * 0.002;
    
    // Police presence decreases loyalty for criminal territory
    loyaltyChange -= territory.policePresence * 0.001;
    
    // Random events
    loyaltyChange += (_random.nextDouble() - 0.5) * 0.001;
    
    _territories[territory.id] = territory.copyWith(
      loyalty: (territory.loyalty + loyaltyChange).clamp(0.0, 1.0),
    );
  }

  void _updateNeutralTerritory(Territory territory) {
    // Neutral territories can change over time
    if (_random.nextDouble() < 0.001) {
      // Random events that affect neutral territories
      final eventType = _random.nextInt(3);
      
      switch (eventType) {
        case 0:
          // Crime rate change
          final crimeChange = (_random.nextDouble() - 0.5) * 0.1;
          _territories[territory.id] = territory.copyWith(
            crimeRate: (territory.crimeRate + crimeChange).clamp(0.0, 1.0),
          );
          break;
        case 1:
          // Police presence change
          final policeChange = (_random.nextDouble() - 0.5) * 0.1;
          _territories[territory.id] = territory.copyWith(
            policePresence: (territory.policePresence + policeChange).clamp(0.0, 1.0),
          );
          break;
        case 2:
          // Wealth change
          final wealthChange = (_random.nextDouble() - 0.5) * 0.05;
          _territories[territory.id] = territory.copyWith(
            wealth: (territory.wealth + wealthChange).clamp(0.0, 1.0),
          );
          break;
      }
    }
  }

  void _updateInfluence() {
    _totalInfluence = 0.0;
    
    for (final territory in _territories.values) {
      if (territory.controlledBy == _playerId) {
        _totalInfluence += territory.totalInfluence;
      }
    }
  }

  void _generateTerritoryEvents() {
    if (_random.nextDouble() < 0.02) {
      _generateRandomEvent();
    }
  }

  void _generateRandomEvent() {
    final events = [
      'police_raid',
      'gang_conflict',
      'economic_boom',
      'political_scandal',
      'natural_disaster',
      'crime_wave',
    ];
    
    final eventType = events[_random.nextInt(events.length)];
    final affectedTerritories = _getRandomTerritories(1 + _random.nextInt(3));
    
    for (final territory in affectedTerritories) {
      _applyRandomEvent(territory, eventType);
    }
  }

  List<Territory> _getRandomTerritories(int count) {
    final allTerritories = _territories.values.toList()..shuffle(_random);
    return allTerritories.take(count).toList();
  }

  void _applyRandomEvent(Territory territory, String eventType) {
    switch (eventType) {
      case 'police_raid':
        _territories[territory.id] = territory.copyWith(
          policePresence: (territory.policePresence + 0.2).clamp(0.0, 1.0),
          crimeRate: (territory.crimeRate - 0.1).clamp(0.0, 1.0),
        );
        break;
      case 'gang_conflict':
        _territories[territory.id] = territory.copyWith(
          crimeRate: (territory.crimeRate + 0.3).clamp(0.0, 1.0),
          status: TerritoryStatus.contested,
        );
        break;
      case 'economic_boom':
        _territories[territory.id] = territory.copyWith(
          wealth: (territory.wealth + 0.1).clamp(0.0, 1.0),
        );
        break;
      default:
        break;
    }
  }

  void _calculateIncome() {
    _territorialIncome = 0.0;
    
    for (final territory in _territories.values) {
      if (territory.controlledBy == _playerId) {
        final baseIncome = territory.population * territory.wealth * 0.1;
        final loyaltyModifier = territory.loyalty;
        final developmentBonus = territory.development * 0.5;
        
        final territoryIncome = baseIncome * loyaltyModifier * (1.0 + developmentBonus);
        _territorialIncome += territoryIncome;
      }
    }
    
    // Add income to expansion budget
    _expansionBudget += _territorialIncome;
  }

  // Utility Methods
  List<Territory> getPlayerTerritories() {
    return _territories.values
        .where((t) => t.controlledBy == _playerId)
        .toList()
        ..sort((a, b) => b.strategicValue.compareTo(a.strategicValue));
  }

  List<Territory> getAvailableTerritories() {
    return _territories.values
        .where((t) => !t.isControlled)
        .toList()
        ..sort((a, b) => a.strategicValue.compareTo(b.strategicValue));
  }

  List<Territory> getAdjacentTerritories(String territoryId) {
    final territory = _territories[territoryId];
    if (territory == null) return [];
    
    return territory.adjacentTerritories
        .map((id) => _territories[id])
        .where((t) => t != null)
        .cast<Territory>()
        .toList();
  }

  double getTerritoryControlPercentage() {
    if (_totalTerritories == 0) return 0.0;
    return _controlledTerritories / _totalTerritories;
  }

  Map<TerritoryType, int> getTerritoryTypeDistribution() {
    final distribution = <TerritoryType, int>{};
    
    for (final territory in _territories.values) {
      if (territory.controlledBy == _playerId) {
        distribution[territory.type] = (distribution[territory.type] ?? 0) + 1;
      }
    }
    
    return distribution;
  }

  void dispose() {
    _systemTimer?.cancel();
    super.dispose();
  }
}

// Advanced Territory Map Widget
class AdvancedTerritoryMapWidget extends StatefulWidget {
  const AdvancedTerritoryMapWidget({super.key});

  @override
  State<AdvancedTerritoryMapWidget> createState() => _AdvancedTerritoryMapWidgetState();
}

class _AdvancedTerritoryMapWidgetState extends State<AdvancedTerritoryMapWidget> {
  final AdvancedTerritorySystem _territorySystem = AdvancedTerritorySystem();
  String? _selectedTerritoryId;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _territorySystem,
      builder: (context, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                _buildStatsBar(),
                const SizedBox(height: 16),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(flex: 2, child: _buildTerritoryList()),
                      const SizedBox(width: 16),
                      Expanded(flex: 1, child: _buildTerritoryDetails()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Text(
          'Territory Control',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Text('Budget: \$${_territorySystem.expansionBudget.toStringAsFixed(0)}'),
      ],
    );
  }

  Widget _buildStatsBar() {
    return Row(
      children: [
        _buildStatCard('Controlled', '${_territorySystem.controlledTerritories}'),
        _buildStatCard('Total', '${_territorySystem.totalTerritories}'),
        _buildStatCard('Control %', '${(_territorySystem.getTerritoryControlPercentage() * 100).toInt()}%'),
        _buildStatCard('Income', '\$${_territorySystem.territorialIncome.toStringAsFixed(0)}'),
      ],
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Expanded(
      child: Card(
        color: Colors.blue[50],
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

  Widget _buildTerritoryList() {
    final allTerritories = _territorySystem.territories.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Territories', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            itemCount: allTerritories.length,
            itemBuilder: (context, index) {
              final territory = allTerritories[index];
              return _buildTerritoryTile(territory);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTerritoryTile(Territory territory) {
    final isSelected = _selectedTerritoryId == territory.id;
    final isControlled = territory.controlledBy == _territorySystem.playerId;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 2),
      color: isSelected ? Colors.blue[100] : null,
      child: ListTile(
        dense: true,
        leading: CircleAvatar(
          backgroundColor: _getTerritoryColor(territory),
          child: Icon(_getTerritoryIcon(territory.type), size: 16),
        ),
        title: Text(territory.name),
        subtitle: Text(_getTerritoryStatusText(territory)),
        trailing: isControlled 
            ? Icon(Icons.check_circle, color: Colors.green)
            : Text('\$${_territorySystem._calculateExpansionCost(territory, ExpansionMethod.aggressive).toStringAsFixed(0)}'),
        onTap: () {
          setState(() {
            _selectedTerritoryId = territory.id;
          });
        },
      ),
    );
  }

  Widget _buildTerritoryDetails() {
    final selectedTerritory = _selectedTerritoryId != null 
        ? _territorySystem.territories[_selectedTerritoryId]
        : null;

    if (selectedTerritory == null) {
      return const Card(
        child: Center(
          child: Text('Select a territory to view details'),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              selectedTerritory.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildTerritoryStats(selectedTerritory),
            const SizedBox(height: 16),
            if (!selectedTerritory.isControlled) ...[
              const Text('Expansion Options:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildExpansionButtons(selectedTerritory),
            ] else ...[
              const Text('Development Options:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildDevelopmentButtons(selectedTerritory),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTerritoryStats(Territory territory) {
    return Column(
      children: [
        _buildStatRow('Population', '${territory.population.toStringAsFixed(0)}'),
        _buildStatRow('Wealth', '${(territory.wealth * 100).toInt()}%'),
        _buildStatRow('Crime Rate', '${(territory.crimeRate * 100).toInt()}%'),
        _buildStatRow('Police Presence', '${(territory.policePresence * 100).toInt()}%'),
        if (territory.isControlled) ...[
          _buildStatRow('Loyalty', '${(territory.loyalty * 100).toInt()}%'),
          _buildStatRow('Development', '${(territory.development * 100).toInt()}%'),
        ],
      ],
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildExpansionButtons(Territory territory) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => _attemptExpansion(territory, ExpansionMethod.aggressive),
          child: const Text('Aggressive Takeover'),
        ),
        ElevatedButton(
          onPressed: () => _attemptExpansion(territory, ExpansionMethod.peaceful),
          child: const Text('Peaceful Negotiation'),
        ),
        ElevatedButton(
          onPressed: () => _attemptExpansion(territory, ExpansionMethod.economic),
          child: const Text('Economic Acquisition'),
        ),
      ],
    );
  }

  Widget _buildDevelopmentButtons(Territory territory) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => _developTerritory(territory, TerritoryFeature.safehouse),
          child: const Text('Build Safehouse'),
        ),
        ElevatedButton(
          onPressed: () => _developTerritory(territory, TerritoryFeature.drugLab),
          child: const Text('Build Drug Lab'),
        ),
        ElevatedButton(
          onPressed: () => _developTerritory(territory, TerritoryFeature.warehouse),
          child: const Text('Build Warehouse'),
        ),
      ],
    );
  }

  void _attemptExpansion(Territory territory, ExpansionMethod method) {
    final success = _territorySystem.claimTerritory(territory.id, method: method);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success 
            ? 'Successfully claimed ${territory.name}!' 
            : 'Failed to claim ${territory.name}'),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  void _developTerritory(Territory territory, TerritoryFeature feature) {
    final success = _territorySystem.developTerritory(territory.id, feature);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success 
            ? 'Successfully developed ${territory.name}!' 
            : 'Failed to develop ${territory.name}'),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  Color _getTerritoryColor(Territory territory) {
    if (territory.controlledBy == _territorySystem.playerId) {
      return Colors.green;
    } else if (territory.isControlled) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  IconData _getTerritoryIcon(TerritoryType type) {
    switch (type) {
      case TerritoryType.financial:
        return Icons.account_balance;
      case TerritoryType.commercial:
        return Icons.business;
      case TerritoryType.industrial:
        return Icons.factory;
      case TerritoryType.entertainment:
        return Icons.theaters;
      case TerritoryType.redLight:
        return Icons.nightlight;
      case TerritoryType.slums:
        return Icons.home;
      case TerritoryType.docks:
        return Icons.anchor;
      case TerritoryType.airport:
        return Icons.flight;
      case TerritoryType.university:
        return Icons.school;
      case TerritoryType.suburbs:
        return Icons.house;
      default:
        return Icons.location_on;
    }
  }

  String _getTerritoryStatusText(Territory territory) {
    if (territory.controlledBy == _territorySystem.playerId) {
      return 'Controlled - Loyalty: ${(territory.loyalty * 100).toInt()}%';
    } else if (territory.isControlled) {
      return 'Enemy Territory';
    } else {
      return 'Neutral - ${territory.type.name}';
    }
  }
}
