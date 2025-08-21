import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

// Advanced International Operations System
// Feature #25: Ultra-comprehensive global expansion with
// international territories, cross-border smuggling, diplomatic relations, and worldwide empire

enum Country {
  usa,
  canada,
  mexico,
  colombia,
  brazil,
  uk,
  france,
  germany,
  russia,
  china,
  japan,
  australia,
  india,
  thailand,
  afghanistan,
  somalia,
  nigeria,
  southAfrica
}

enum OperationType {
  drugTrafficking,
  armsDealing,
  humanTrafficking,
  moneyLaundering,
  cybercrime,
  corruption,
  espionage,
  terrorism
}

enum DiplomaticStatus {
  ally,
  neutral,
  hostile,
  wanted,
  extraditionTarget,
  sanctioned
}

enum BorderSecurity {
  minimal,
  low,
  moderate,
  high,
  maximum,
  military
}

class InternationalTerritory {
  final String id;
  final String name;
  final Country country;
  final double size; // in km²
  final int population;
  final double corruptionLevel;
  final BorderSecurity security;
  final List<OperationType> activeOperations;
  final double monthlyIncome;
  final double operationalCost;
  final double heatLevel;
  final bool isActive;

  InternationalTerritory({
    required this.id,
    required this.name,
    required this.country,
    required this.size,
    required this.population,
    required this.corruptionLevel,
    required this.security,
    required this.activeOperations,
    required this.monthlyIncome,
    required this.operationalCost,
    this.heatLevel = 0.0,
    this.isActive = true,
  });

  InternationalTerritory copyWith({
    String? id,
    String? name,
    Country? country,
    double? size,
    int? population,
    double? corruptionLevel,
    BorderSecurity? security,
    List<OperationType>? activeOperations,
    double? monthlyIncome,
    double? operationalCost,
    double? heatLevel,
    bool? isActive,
  }) {
    return InternationalTerritory(
      id: id ?? this.id,
      name: name ?? this.name,
      country: country ?? this.country,
      size: size ?? this.size,
      population: population ?? this.population,
      corruptionLevel: corruptionLevel ?? this.corruptionLevel,
      security: security ?? this.security,
      activeOperations: activeOperations ?? this.activeOperations,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      operationalCost: operationalCost ?? this.operationalCost,
      heatLevel: heatLevel ?? this.heatLevel,
      isActive: isActive ?? this.isActive,
    );
  }

  double get netIncome => monthlyIncome - operationalCost;
  double get riskLevel => heatLevel * (1.0 - corruptionLevel);
  bool get isSafe => riskLevel < 0.5;
}

class SmuggllingRoute {
  final String id;
  final String name;
  final Country origin;
  final Country destination;
  final List<Country> waypoints;
  final OperationType operationType;
  final double distance;
  final double successRate;
  final double profitMargin;
  final BorderSecurity averageSecurity;
  final bool isActive;

  SmuggllingRoute({
    required this.id,
    required this.name,
    required this.origin,
    required this.destination,
    required this.waypoints,
    required this.operationType,
    required this.distance,
    required this.successRate,
    required this.profitMargin,
    required this.averageSecurity,
    this.isActive = true,
  });

  SmuggllingRoute copyWith({
    String? id,
    String? name,
    Country? origin,
    Country? destination,
    List<Country>? waypoints,
    OperationType? operationType,
    double? distance,
    double? successRate,
    double? profitMargin,
    BorderSecurity? averageSecurity,
    bool? isActive,
  }) {
    return SmuggllingRoute(
      id: id ?? this.id,
      name: name ?? this.name,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      waypoints: waypoints ?? this.waypoints,
      operationType: operationType ?? this.operationType,
      distance: distance ?? this.distance,
      successRate: successRate ?? this.successRate,
      profitMargin: profitMargin ?? this.profitMargin,
      averageSecurity: averageSecurity ?? this.averageSecurity,
      isActive: isActive ?? this.isActive,
    );
  }

  double get riskFactor => (distance / 1000) * (1.0 - successRate);
  double get expectedProfit => profitMargin * successRate;
}

class DiplomaticRelation {
  final String id;
  final Country country;
  final DiplomaticStatus status;
  final double relationshipLevel; // -1.0 to 1.0
  final double influenceLevel;
  final double corruptionInvestment;
  final List<String> activeAgreements;
  final bool hasExtraditionTreaty;

  DiplomaticRelation({
    required this.id,
    required this.country,
    required this.status,
    required this.relationshipLevel,
    required this.influenceLevel,
    required this.corruptionInvestment,
    required this.activeAgreements,
    this.hasExtraditionTreaty = true,
  });

  DiplomaticRelation copyWith({
    String? id,
    Country? country,
    DiplomaticStatus? status,
    double? relationshipLevel,
    double? influenceLevel,
    double? corruptionInvestment,
    List<String>? activeAgreements,
    bool? hasExtraditionTreaty,
  }) {
    return DiplomaticRelation(
      id: id ?? this.id,
      country: country ?? this.country,
      status: status ?? this.status,
      relationshipLevel: relationshipLevel ?? this.relationshipLevel,
      influenceLevel: influenceLevel ?? this.influenceLevel,
      corruptionInvestment: corruptionInvestment ?? this.corruptionInvestment,
      activeAgreements: activeAgreements ?? this.activeAgreements,
      hasExtraditionTreaty: hasExtraditionTreaty ?? this.hasExtraditionTreaty,
    );
  }

  bool get isSafeHaven => status == DiplomaticStatus.ally && relationshipLevel > 0.7;
  bool get isHostile => status == DiplomaticStatus.hostile || status == DiplomaticStatus.wanted;
}

class InternationalOperation {
  final String id;
  final String name;
  final OperationType type;
  final List<Country> involvedCountries;
  final double investment;
  final double expectedReturn;
  final double duration; // in days
  final double riskLevel;
  final DateTime startDate;
  final bool isActive;
  final double progress;

  InternationalOperation({
    required this.id,
    required this.name,
    required this.type,
    required this.involvedCountries,
    required this.investment,
    required this.expectedReturn,
    required this.duration,
    required this.riskLevel,
    required this.startDate,
    this.isActive = true,
    this.progress = 0.0,
  });

  InternationalOperation copyWith({
    String? id,
    String? name,
    OperationType? type,
    List<Country>? involvedCountries,
    double? investment,
    double? expectedReturn,
    double? duration,
    double? riskLevel,
    DateTime? startDate,
    bool? isActive,
    double? progress,
  }) {
    return InternationalOperation(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      involvedCountries: involvedCountries ?? this.involvedCountries,
      investment: investment ?? this.investment,
      expectedReturn: expectedReturn ?? this.expectedReturn,
      duration: duration ?? this.duration,
      riskLevel: riskLevel ?? this.riskLevel,
      startDate: startDate ?? this.startDate,
      isActive: isActive ?? this.isActive,
      progress: progress ?? this.progress,
    );
  }

  double get roi => investment > 0 ? (expectedReturn - investment) / investment : 0.0;
  bool get isCompleted => progress >= 1.0;
  DateTime get expectedCompletion => startDate.add(Duration(days: duration.round()));
  int get daysRemaining => expectedCompletion.difference(DateTime.now()).inDays;
}

class InternationalContact {
  final String id;
  final String name;
  final Country country;
  final String role; // Government Official, Cartel Leader, Smuggler, etc.
  final double trustLevel;
  final double influenceLevel;
  final double corruptionCost;
  final List<OperationType> specialties;
  final bool isActive;

  InternationalContact({
    required this.id,
    required this.name,
    required this.country,
    required this.role,
    required this.trustLevel,
    required this.influenceLevel,
    required this.corruptionCost,
    required this.specialties,
    this.isActive = true,
  });

  InternationalContact copyWith({
    String? id,
    String? name,
    Country? country,
    String? role,
    double? trustLevel,
    double? influenceLevel,
    double? corruptionCost,
    List<OperationType>? specialties,
    bool? isActive,
  }) {
    return InternationalContact(
      id: id ?? this.id,
      name: name ?? this.name,
      country: country ?? this.country,
      role: role ?? this.role,
      trustLevel: trustLevel ?? this.trustLevel,
      influenceLevel: influenceLevel ?? this.influenceLevel,
      corruptionCost: corruptionCost ?? this.corruptionCost,
      specialties: specialties ?? this.specialties,
      isActive: isActive ?? this.isActive,
    );
  }

  double get reliability => trustLevel * influenceLevel;
  bool get isGovernmentOfficial => role.contains('Official') || role.contains('Minister');
  bool get isHighValue => influenceLevel > 0.7 && trustLevel > 0.5;
}

class AdvancedInternationalOperationsSystem extends ChangeNotifier {
  static final AdvancedInternationalOperationsSystem _instance = AdvancedInternationalOperationsSystem._internal();
  factory AdvancedInternationalOperationsSystem() => _instance;
  AdvancedInternationalOperationsSystem._internal() {
    _initializeSystem();
  }

  final Map<String, InternationalTerritory> _territories = {};
  final Map<String, SmuggllingRoute> _smugglingRoutes = {};
  final Map<String, DiplomaticRelation> _diplomaticRelations = {};
  final Map<String, InternationalOperation> _operations = {};
  final Map<String, InternationalContact> _contacts = {};
  
  String? _playerId;
  double _globalInfluence = 0.0;
  double _internationalHeat = 0.0;
  double _monthlyRevenue = 0.0;
  double _operationalCosts = 0.0;
  int _activeCountries = 0;
  double _globalReputation = 0.5;
  
  Timer? _systemTimer;
  Timer? _operationTimer;
  final math.Random _random = math.Random();

  // Getters
  Map<String, InternationalTerritory> get territories => Map.unmodifiable(_territories);
  Map<String, SmuggllingRoute> get smugglingRoutes => Map.unmodifiable(_smugglingRoutes);
  Map<String, DiplomaticRelation> get diplomaticRelations => Map.unmodifiable(_diplomaticRelations);
  Map<String, InternationalOperation> get operations => Map.unmodifiable(_operations);
  Map<String, InternationalContact> get contacts => Map.unmodifiable(_contacts);
  String? get playerId => _playerId;
  double get globalInfluence => _globalInfluence;
  double get internationalHeat => _internationalHeat;
  double get monthlyRevenue => _monthlyRevenue;
  double get operationalCosts => _operationalCosts;
  int get activeCountries => _activeCountries;
  double get globalReputation => _globalReputation;

  void _initializeSystem() {
    _playerId = 'international_${DateTime.now().millisecondsSinceEpoch}';
    _initializeDiplomaticRelations();
    _initializeContacts();
    _startSystemTimers();
  }

  void _initializeDiplomaticRelations() {
    for (final country in Country.values) {
      final relationId = 'relation_${country.name}';
      _diplomaticRelations[relationId] = DiplomaticRelation(
        id: relationId,
        country: country,
        status: DiplomaticStatus.neutral,
        relationshipLevel: 0.0,
        influenceLevel: 0.0,
        corruptionInvestment: 0.0,
        activeAgreements: [],
        hasExtraditionTreaty: _getCountryExtraditionStatus(country),
      );
    }
  }

  bool _getCountryExtraditionStatus(Country country) {
    switch (country) {
      case Country.usa:
      case Country.uk:
      case Country.canada:
      case Country.australia:
      case Country.germany:
      case Country.france:
        return true;
      case Country.russia:
      case Country.china:
      case Country.afghanistan:
      case Country.somalia:
        return false;
      default:
        return true;
    }
  }

  void _initializeContacts() {
    // Government Officials
    _contacts['contact_usa_official'] = InternationalContact(
      id: 'contact_usa_official',
      name: 'Senator Williams',
      country: Country.usa,
      role: 'Government Official',
      trustLevel: 0.3,
      influenceLevel: 0.8,
      corruptionCost: 50000,
      specialties: [OperationType.corruption, OperationType.moneyLaundering],
    );

    _contacts['contact_colombia_cartel'] = InternationalContact(
      id: 'contact_colombia_cartel',
      name: 'El Jefe',
      country: Country.colombia,
      role: 'Cartel Leader',
      trustLevel: 0.7,
      influenceLevel: 0.9,
      corruptionCost: 25000,
      specialties: [OperationType.drugTrafficking, OperationType.armsDealing],
    );

    _contacts['contact_china_cyber'] = InternationalContact(
      id: 'contact_china_cyber',
      name: 'Zhang Wei',
      country: Country.china,
      role: 'Cyber Criminal',
      trustLevel: 0.5,
      influenceLevel: 0.6,
      corruptionCost: 15000,
      specialties: [OperationType.cybercrime, OperationType.espionage],
    );

    _contacts['contact_russia_arms'] = InternationalContact(
      id: 'contact_russia_arms',
      name: 'Viktor Petrov',
      country: Country.russia,
      role: 'Arms Dealer',
      trustLevel: 0.6,
      influenceLevel: 0.8,
      corruptionCost: 30000,
      specialties: [OperationType.armsDealing, OperationType.corruption],
    );
  }

  void _startSystemTimers() {
    _systemTimer?.cancel();
    _operationTimer?.cancel();
    
    _systemTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _updateTerritories();
      _updateDiplomaticRelations();
      _calculateGlobalMetrics();
      notifyListeners();
    });
    
    _operationTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _processOperations();
      _processSmuggling();
      notifyListeners();
    });
  }

  // Territory Management
  String establishTerritory(String name, Country country, OperationType primaryOperation) {
    final territoryId = 'territory_${DateTime.now().millisecondsSinceEpoch}';
    
    final countryData = _getCountryData(country);
    final size = 50.0 + _random.nextDouble() * 200; // 50-250 km²
    final population = 10000 + _random.nextInt(90000); // 10k-100k
    
    _territories[territoryId] = InternationalTerritory(
      id: territoryId,
      name: name,
      country: country,
      size: size,
      population: population,
      corruptionLevel: countryData['corruption']!,
      security: BorderSecurity.values[countryData['security']!.toInt()],
      activeOperations: [primaryOperation],
      monthlyIncome: _calculateTerritoryIncome(primaryOperation, population, countryData['corruption']!),
      operationalCost: _calculateTerritoryOperationalCost(size, population, countryData['security']!),
    );
    
    _updateActiveCountries();
    return territoryId;
  }

  Map<String, double> _getCountryData(Country country) {
    switch (country) {
      case Country.usa:
        return {'corruption': 0.3, 'security': 4.0, 'wealth': 0.9};
      case Country.colombia:
        return {'corruption': 0.8, 'security': 2.0, 'wealth': 0.4};
      case Country.mexico:
        return {'corruption': 0.7, 'security': 2.0, 'wealth': 0.5};
      case Country.russia:
        return {'corruption': 0.6, 'security': 3.0, 'wealth': 0.6};
      case Country.china:
        return {'corruption': 0.4, 'security': 5.0, 'wealth': 0.7};
      case Country.afghanistan:
        return {'corruption': 0.9, 'security': 1.0, 'wealth': 0.1};
      case Country.somalia:
        return {'corruption': 0.95, 'security': 0.5, 'wealth': 0.05};
      default:
        return {'corruption': 0.5, 'security': 3.0, 'wealth': 0.6};
    }
  }

  double _calculateTerritoryIncome(OperationType operation, int population, double corruption) {
    double baseIncome = population * 0.1; // Base income per person
    
    switch (operation) {
      case OperationType.drugTrafficking:
        baseIncome *= 3.0;
        break;
      case OperationType.armsDealing:
        baseIncome *= 2.5;
        break;
      case OperationType.humanTrafficking:
        baseIncome *= 4.0;
        break;
      case OperationType.cybercrime:
        baseIncome *= 2.0;
        break;
      case OperationType.moneyLaundering:
        baseIncome *= 1.5;
        break;
      case OperationType.corruption:
        baseIncome *= 1.8;
        break;
      case OperationType.espionage:
        baseIncome *= 3.5;
        break;
      case OperationType.terrorism:
        baseIncome *= 5.0;
        break;
    }
    
    return baseIncome * (1.0 + corruption);
  }

  double _calculateTerritoryOperationalCost(double size, int population, double security) {
    double baseCost = (size * 10) + (population * 0.05);
    baseCost *= (1.0 + security * 0.2);
    return baseCost;
  }

  // Smuggling Operations
  String createSmuggllingRoute(String name, Country origin, Country destination, OperationType operation) {
    final routeId = 'route_${DateTime.now().millisecondsSinceEpoch}';
    
    final distance = _calculateDistance(origin, destination);
    final waypoints = _generateWaypoints(origin, destination);
    final averageSecurity = _calculateAverageRouteSecurity(origin, destination, waypoints);
    final successRate = _calculateRouteSuccessRate(distance, averageSecurity);
    final profitMargin = _calculateRouteProfitMargin(operation, distance);
    
    _smugglingRoutes[routeId] = SmuggllingRoute(
      id: routeId,
      name: name,
      origin: origin,
      destination: destination,
      waypoints: waypoints,
      operationType: operation,
      distance: distance,
      successRate: successRate,
      profitMargin: profitMargin,
      averageSecurity: averageSecurity,
    );
    
    return routeId;
  }

  double _calculateDistance(Country origin, Country destination) {
    // Simplified distance calculation
    final distances = {
      'usa_colombia': 3000.0,
      'colombia_europe': 8000.0,
      'afghanistan_europe': 6000.0,
      'china_usa': 11000.0,
      'mexico_usa': 1500.0,
    };
    
    final key = '${origin.name}_${destination.name}';
    return distances[key] ?? (2000.0 + _random.nextDouble() * 8000.0);
  }

  List<Country> _generateWaypoints(Country origin, Country destination) {
    // Generate realistic waypoints based on geography
    if (origin == Country.colombia && destination == Country.usa) {
      return [Country.mexico];
    } else if (origin == Country.afghanistan && destination == Country.uk) {
      return [Country.russia, Country.germany];
    }
    return [];
  }

  BorderSecurity _calculateAverageRouteSecurity(Country origin, Country destination, List<Country> waypoints) {
    final countries = [origin, ...waypoints, destination];
    double totalSecurity = 0;
    
    for (final country in countries) {
      final countryData = _getCountryData(country);
      totalSecurity += countryData['security']!;
    }
    
    final average = totalSecurity / countries.length;
    return BorderSecurity.values[math.min(average.round(), BorderSecurity.values.length - 1)];
  }

  double _calculateRouteSuccessRate(double distance, BorderSecurity security) {
    double baseRate = 0.8;
    baseRate -= (distance / 10000) * 0.3; // Distance penalty
    baseRate -= security.index * 0.1; // Security penalty
    return baseRate.clamp(0.1, 0.95);
  }

  double _calculateRouteProfitMargin(OperationType operation, double distance) {
    double baseMargin = 100000; // Base profit
    
    switch (operation) {
      case OperationType.drugTrafficking:
        baseMargin *= 3.0;
        break;
      case OperationType.armsDealing:
        baseMargin *= 2.5;
        break;
      case OperationType.humanTrafficking:
        baseMargin *= 4.0;
        break;
      default:
        baseMargin *= 2.0;
        break;
    }
    
    baseMargin *= (1.0 + distance / 5000); // Distance bonus
    return baseMargin;
  }

  // Diplomatic Operations
  void improveDiplomaticRelations(Country country, double investment) {
    final relationId = 'relation_${country.name}';
    final relation = _diplomaticRelations[relationId];
    
    if (relation != null) {
      final improvement = investment / 100000; // $100k for 0.01 improvement
      final newRelationshipLevel = (relation.relationshipLevel + improvement).clamp(-1.0, 1.0);
      final newInfluenceLevel = (relation.influenceLevel + improvement * 0.5).clamp(0.0, 1.0);
      
      _diplomaticRelations[relationId] = relation.copyWith(
        relationshipLevel: newRelationshipLevel,
        influenceLevel: newInfluenceLevel,
        corruptionInvestment: relation.corruptionInvestment + investment,
      );
      
      // Update status based on relationship level
      if (newRelationshipLevel > 0.5) {
        _diplomaticRelations[relationId] = _diplomaticRelations[relationId]!.copyWith(
          status: DiplomaticStatus.ally,
        );
      } else if (newRelationshipLevel < -0.5) {
        _diplomaticRelations[relationId] = _diplomaticRelations[relationId]!.copyWith(
          status: DiplomaticStatus.hostile,
        );
      }
    }
  }

  void corruptOfficial(String contactId, double payment) {
    final contact = _contacts[contactId];
    if (contact == null) return;
    
    if (payment >= contact.corruptionCost) {
      _contacts[contactId] = contact.copyWith(
        trustLevel: (contact.trustLevel + 0.1).clamp(0.0, 1.0),
      );
      
      // Improve diplomatic relations with the contact's country
      improveDiplomaticRelations(contact.country, payment * 0.5);
    }
  }

  // International Operations
  String launchOperation(String name, OperationType type, List<Country> countries, double investment) {
    final operationId = 'operation_${DateTime.now().millisecondsSinceEpoch}';
    
    final duration = _calculateOperationDuration(type, countries.length);
    final riskLevel = _calculateOperationRisk(type, countries);
    final expectedReturn = _calculateOperationReturn(type, investment, countries.length);
    
    _operations[operationId] = InternationalOperation(
      id: operationId,
      name: name,
      type: type,
      involvedCountries: countries,
      investment: investment,
      expectedReturn: expectedReturn,
      duration: duration,
      riskLevel: riskLevel,
      startDate: DateTime.now(),
    );
    
    return operationId;
  }

  double _calculateOperationDuration(OperationType type, int countryCount) {
    double baseDuration = 30.0; // 30 days
    
    switch (type) {
      case OperationType.espionage:
        baseDuration = 60.0;
        break;
      case OperationType.terrorism:
        baseDuration = 90.0;
        break;
      case OperationType.humanTrafficking:
        baseDuration = 45.0;
        break;
      default:
        baseDuration = 30.0;
        break;
    }
    
    return baseDuration + (countryCount * 5); // 5 days per additional country
  }

  double _calculateOperationRisk(OperationType type, List<Country> countries) {
    double baseRisk = 0.3;
    
    switch (type) {
      case OperationType.terrorism:
        baseRisk = 0.9;
        break;
      case OperationType.humanTrafficking:
        baseRisk = 0.8;
        break;
      case OperationType.espionage:
        baseRisk = 0.7;
        break;
      case OperationType.armsDealing:
        baseRisk = 0.6;
        break;
      default:
        baseRisk = 0.4;
        break;
    }
    
    // Add risk based on countries involved
    for (final country in countries) {
      final countryData = _getCountryData(country);
      baseRisk += countryData['security']! * 0.1;
    }
    
    return baseRisk.clamp(0.1, 1.0);
  }

  double _calculateOperationReturn(OperationType type, double investment, int countryCount) {
    double multiplier = 1.5; // Base 50% return
    
    switch (type) {
      case OperationType.drugTrafficking:
        multiplier = 3.0;
        break;
      case OperationType.armsDealing:
        multiplier = 2.5;
        break;
      case OperationType.humanTrafficking:
        multiplier = 4.0;
        break;
      case OperationType.cybercrime:
        multiplier = 2.8;
        break;
      case OperationType.espionage:
        multiplier = 3.5;
        break;
      case OperationType.terrorism:
        multiplier = 5.0;
        break;
      default:
        multiplier = 2.0;
        break;
    }
    
    return investment * multiplier * (1.0 + countryCount * 0.2);
  }

  // System Updates
  void _updateTerritories() {
    _monthlyRevenue = 0;
    _operationalCosts = 0;
    
    for (final territoryId in _territories.keys) {
      final territory = _territories[territoryId]!;
      if (!territory.isActive) continue;
      
      _monthlyRevenue += territory.monthlyIncome;
      _operationalCosts += territory.operationalCost;
      
      // Update heat level based on operations
      double heatIncrease = 0;
      for (final operation in territory.activeOperations) {
        heatIncrease += _getOperationHeatGeneration(operation);
      }
      
      final newHeatLevel = (territory.heatLevel + heatIncrease * 0.001).clamp(0.0, 1.0);
      _territories[territoryId] = territory.copyWith(heatLevel: newHeatLevel);
      
      // Territory might become inactive if heat is too high
      if (newHeatLevel > 0.8 && _random.nextDouble() < 0.1) {
        _territories[territoryId] = territory.copyWith(isActive: false);
      }
    }
  }

  double _getOperationHeatGeneration(OperationType operation) {
    switch (operation) {
      case OperationType.terrorism:
        return 100.0;
      case OperationType.humanTrafficking:
        return 80.0;
      case OperationType.armsDealing:
        return 60.0;
      case OperationType.drugTrafficking:
        return 50.0;
      case OperationType.espionage:
        return 70.0;
      default:
        return 30.0;
    }
  }

  void _updateDiplomaticRelations() {
    for (final relationId in _diplomaticRelations.keys) {
      final relation = _diplomaticRelations[relationId]!;
      
      // Relations naturally decay over time without investment
      final decay = 0.001;
      final newRelationshipLevel = (relation.relationshipLevel - decay).clamp(-1.0, 1.0);
      
      _diplomaticRelations[relationId] = relation.copyWith(
        relationshipLevel: newRelationshipLevel,
      );
    }
  }

  void _processOperations() {
    for (final operationId in _operations.keys) {
      final operation = _operations[operationId]!;
      if (!operation.isActive || operation.isCompleted) continue;
      
      // Update progress
      final progressIncrement = 1.0 / (operation.duration * 2); // Assuming 2 updates per day
      final newProgress = (operation.progress + progressIncrement).clamp(0.0, 1.0);
      
      _operations[operationId] = operation.copyWith(progress: newProgress);
      
      // Check for operation completion
      if (newProgress >= 1.0) {
        _completeOperation(operationId);
      }
      
      // Random chance of operation failure based on risk
      if (_random.nextDouble() < operation.riskLevel * 0.001) {
        _failOperation(operationId);
      }
    }
  }

  void _processSmuggling() {
    for (final route in _smugglingRoutes.values) {
      if (!route.isActive) continue;
      
      // Random smuggling runs
      if (_random.nextDouble() < 0.05) { // 5% chance per cycle
        _executeSmuggllingRun(route);
      }
    }
  }

  void _executeSmuggllingRun(SmuggllingRoute route) {
    if (_random.nextDouble() < route.successRate) {
      // Successful run
      _monthlyRevenue += route.profitMargin;
      
      // Reduce success rate slightly due to increased attention
      _smugglingRoutes[route.id] = route.copyWith(
        successRate: (route.successRate - 0.01).clamp(0.1, 0.95),
      );
    } else {
      // Failed run - increase heat and reduce route effectiveness
      _internationalHeat += 0.1;
      
      _smugglingRoutes[route.id] = route.copyWith(
        successRate: (route.successRate - 0.05).clamp(0.1, 0.95),
        isActive: false, // Temporarily shut down route
      );
    }
  }

  void _completeOperation(String operationId) {
    final operation = _operations[operationId]!;
    
    if (_random.nextDouble() < (1.0 - operation.riskLevel)) {
      // Successful operation
      _monthlyRevenue += operation.expectedReturn - operation.investment;
      _globalInfluence += 0.05;
    } else {
      // Operation discovered/failed
      _internationalHeat += 0.2;
      _globalReputation -= 0.1;
      
      // Damage diplomatic relations with involved countries
      for (final country in operation.involvedCountries) {
        final relationId = 'relation_${country.name}';
        final relation = _diplomaticRelations[relationId];
        if (relation != null) {
          _diplomaticRelations[relationId] = relation.copyWith(
            relationshipLevel: (relation.relationshipLevel - 0.2).clamp(-1.0, 1.0),
            status: DiplomaticStatus.hostile,
          );
        }
      }
    }
    
    _operations[operationId] = operation.copyWith(isActive: false);
  }

  void _failOperation(String operationId) {
    final operation = _operations[operationId]!;
    
    _internationalHeat += 0.3;
    _globalReputation -= 0.15;
    
    // More severe diplomatic consequences
    for (final country in operation.involvedCountries) {
      final relationId = 'relation_${country.name}';
      final relation = _diplomaticRelations[relationId];
      if (relation != null) {
        _diplomaticRelations[relationId] = relation.copyWith(
          relationshipLevel: (relation.relationshipLevel - 0.3).clamp(-1.0, 1.0),
          status: DiplomaticStatus.wanted,
        );
      }
    }
    
    _operations[operationId] = operation.copyWith(isActive: false);
  }

  void _calculateGlobalMetrics() {
    _globalInfluence = _territories.values
        .where((t) => t.isActive)
        .fold(0.0, (sum, t) => sum + (t.size / 1000));
    
    _activeCountries = _territories.values
        .where((t) => t.isActive)
        .map((t) => t.country)
        .toSet()
        .length;
    
    // Heat naturally decreases over time
    _internationalHeat = (_internationalHeat - 0.001).clamp(0.0, 1.0);
    
    // Reputation slowly recovers if no recent incidents
    _globalReputation = (_globalReputation + 0.0005).clamp(0.0, 1.0);
  }

  void _updateActiveCountries() {
    _activeCountries = _territories.values
        .where((t) => t.isActive)
        .map((t) => t.country)
        .toSet()
        .length;
  }

  // Public Interface Methods
  List<InternationalTerritory> getActiveTerritories() {
    return _territories.values.where((t) => t.isActive).toList()
      ..sort((a, b) => b.netIncome.compareTo(a.netIncome));
  }

  List<SmuggllingRoute> getActiveRoutes() {
    return _smugglingRoutes.values.where((r) => r.isActive).toList()
      ..sort((a, b) => b.expectedProfit.compareTo(a.expectedProfit));
  }

  List<InternationalOperation> getActiveOperations() {
    return _operations.values.where((o) => o.isActive).toList()
      ..sort((a, b) => a.daysRemaining.compareTo(b.daysRemaining));
  }

  List<DiplomaticRelation> getAllDiplomaticRelations() {
    return _diplomaticRelations.values.toList()
      ..sort((a, b) => b.relationshipLevel.compareTo(a.relationshipLevel));
  }

  List<InternationalContact> getAvailableContacts() {
    return _contacts.values.where((c) => c.isActive).toList()
      ..sort((a, b) => b.reliability.compareTo(a.reliability));
  }

  List<Country> getSafeHavenCountries() {
    return _diplomaticRelations.values
        .where((r) => r.isSafeHaven)
        .map((r) => r.country)
        .toList();
  }

  List<Country> getHostileCountries() {
    return _diplomaticRelations.values
        .where((r) => r.isHostile)
        .map((r) => r.country)
        .toList();
  }

  double getNetInternationalRevenue() {
    return _monthlyRevenue - _operationalCosts;
  }

  double getTotalInvestment() {
    return _operations.values.fold(0.0, (sum, op) => sum + op.investment) +
           _diplomaticRelations.values.fold(0.0, (sum, rel) => sum + rel.corruptionInvestment);
  }

  void dispose() {
    _systemTimer?.cancel();
    _operationTimer?.cancel();
    super.dispose();
  }
}

// Advanced International Operations Dashboard Widget
class AdvancedInternationalOperationsDashboardWidget extends StatefulWidget {
  const AdvancedInternationalOperationsDashboardWidget({super.key});

  @override
  State<AdvancedInternationalOperationsDashboardWidget> createState() => _AdvancedInternationalOperationsDashboardWidgetState();
}

class _AdvancedInternationalOperationsDashboardWidgetState extends State<AdvancedInternationalOperationsDashboardWidget>
    with TickerProviderStateMixin {
  final AdvancedInternationalOperationsSystem _intlSystem = AdvancedInternationalOperationsSystem();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _intlSystem,
      builder: (context, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                _buildGlobalMetrics(),
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
    return Row(
      children: [
        const Icon(Icons.public, color: Colors.blue),
        const SizedBox(width: 8),
        const Text(
          'International Operations',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Text('${_intlSystem.activeCountries} Countries'),
      ],
    );
  }

  Widget _buildGlobalMetrics() {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                _buildMetricCard('Net Revenue', '\$${(_intlSystem.getNetInternationalRevenue() / 1000).toStringAsFixed(1)}K'),
                _buildMetricCard('Global Influence', '${(_intlSystem.globalInfluence * 100).toInt()}%'),
                _buildMetricCard('Int\'l Heat', '${(_intlSystem.internationalHeat * 100).toInt()}%'),
                _buildMetricCard('Reputation', '${(_intlSystem.globalReputation * 100).toInt()}%'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('International Heat Level', style: TextStyle(fontWeight: FontWeight.bold)),
                      LinearProgressIndicator(
                        value: _intlSystem.internationalHeat,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _intlSystem.internationalHeat > 0.7 ? Colors.red : Colors.orange,
                        ),
                      ),
                      Text('${(_intlSystem.internationalHeat * 100).toInt()}% Heat'),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Global Reputation', style: TextStyle(fontWeight: FontWeight.bold)),
                      LinearProgressIndicator(
                        value: _intlSystem.globalReputation,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _intlSystem.globalReputation > 0.6 ? Colors.green : Colors.red,
                        ),
                      ),
                      Text('${(_intlSystem.globalReputation * 100).toInt()}% Rep'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String label, String value) {
    return Expanded(
      child: Card(
        color: Colors.white,
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
      isScrollable: true,
      tabs: const [
        Tab(text: 'Territories', icon: Icon(Icons.terrain)),
        Tab(text: 'Operations', icon: Icon(Icons.military_tech)),
        Tab(text: 'Smuggling', icon: Icon(Icons.local_shipping)),
        Tab(text: 'Diplomacy', icon: Icon(Icons.handshake)),
        Tab(text: 'Contacts', icon: Icon(Icons.contacts)),
      ],
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildTerritoriesTab(),
        _buildOperationsTab(),
        _buildSmugglingTab(),
        _buildDiplomacyTab(),
        _buildContactsTab(),
      ],
    );
  }

  Widget _buildTerritoriesTab() {
    final territories = _intlSystem.getActiveTerritories();
    
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _showEstablishTerritoryDialog,
                    child: const Text('Establish Territory'),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: territories.length,
            itemBuilder: (context, index) {
              final territory = territories[index];
              return _buildTerritoryCard(territory);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTerritoryCard(InternationalTerritory territory) {
    return Card(
      color: territory.isSafe ? null : Colors.red[50],
      child: ListTile(
        leading: Text(
          _getCountryFlag(territory.country),
          style: const TextStyle(fontSize: 24),
        ),
        title: Text('${territory.name} (${territory.country.name})'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Size: ${territory.size.toInt()}km² | Pop: ${(territory.population / 1000).toInt()}K'),
            Text('Income: \$${territory.monthlyIncome.toInt()} | Cost: \$${territory.operationalCost.toInt()}'),
            Text('Net: \$${territory.netIncome.toInt()} | Heat: ${(territory.heatLevel * 100).toInt()}%'),
            Text('Operations: ${territory.activeOperations.map((op) => op.name).join(', ')}'),
          ],
        ),
        trailing: Icon(
          territory.isSafe ? Icons.security : Icons.warning,
          color: territory.isSafe ? Colors.green : Colors.red,
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildOperationsTab() {
    final operations = _intlSystem.getActiveOperations();
    
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _showLaunchOperationDialog,
                    child: const Text('Launch Operation'),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: operations.length,
            itemBuilder: (context, index) {
              final operation = operations[index];
              return _buildOperationCard(operation);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOperationCard(InternationalOperation operation) {
    return Card(
      child: ListTile(
        leading: Icon(
          _getOperationIcon(operation.type),
          color: _getOperationColor(operation.type),
        ),
        title: Text(operation.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${operation.type.name}'),
            Text('Countries: ${operation.involvedCountries.map((c) => c.name).join(', ')}'),
            Text('Investment: \$${operation.investment.toInt()} | Expected: \$${operation.expectedReturn.toInt()}'),
            Text('Progress: ${(operation.progress * 100).toInt()}% | Days Left: ${operation.daysRemaining}'),
            LinearProgressIndicator(value: operation.progress),
          ],
        ),
        trailing: Icon(
          operation.riskLevel > 0.7 ? Icons.dangerous : Icons.check_circle,
          color: operation.riskLevel > 0.7 ? Colors.red : Colors.green,
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildSmugglingTab() {
    final routes = _intlSystem.getActiveRoutes();
    
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _showCreateRouteDialog,
                    child: const Text('Create Smuggling Route'),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: routes.length,
            itemBuilder: (context, index) {
              final route = routes[index];
              return _buildRouteCard(route);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRouteCard(SmuggllingRoute route) {
    return Card(
      child: ListTile(
        leading: Icon(
          _getOperationIcon(route.operationType),
          color: _getOperationColor(route.operationType),
        ),
        title: Text(route.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${route.origin.name} → ${route.destination.name}'),
            Text('Type: ${route.operationType.name}'),
            Text('Distance: ${route.distance.toInt()}km | Success: ${(route.successRate * 100).toInt()}%'),
            Text('Profit: \$${(route.profitMargin / 1000).toInt()}K | Security: ${route.averageSecurity.name}'),
          ],
        ),
        trailing: Switch(
          value: route.isActive,
          onChanged: (value) => _toggleRoute(route.id, value),
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildDiplomacyTab() {
    final relations = _intlSystem.getAllDiplomaticRelations();
    
    return ListView.builder(
      itemCount: relations.length,
      itemBuilder: (context, index) {
        final relation = relations[index];
        return _buildDiplomaticCard(relation);
      },
    );
  }

  Widget _buildDiplomaticCard(DiplomaticRelation relation) {
    return Card(
      color: relation.isSafeHaven ? Colors.green[50] : 
             relation.isHostile ? Colors.red[50] : null,
      child: ListTile(
        leading: Text(
          _getCountryFlag(relation.country),
          style: const TextStyle(fontSize: 24),
        ),
        title: Text('${relation.country.name} (${relation.status.name})'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Relationship: ${(relation.relationshipLevel * 100).toInt()}%'),
            Text('Influence: ${(relation.influenceLevel * 100).toInt()}%'),
            Text('Investment: \$${(relation.corruptionInvestment / 1000).toInt()}K'),
            Text('Extradition: ${relation.hasExtraditionTreaty ? 'YES' : 'NO'}'),
            LinearProgressIndicator(
              value: (relation.relationshipLevel + 1.0) / 2.0,
              backgroundColor: Colors.red[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                relation.relationshipLevel > 0 ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () => _showImproveRelationsDialog(relation),
          child: const Text('Improve'),
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildContactsTab() {
    final contacts = _intlSystem.getAvailableContacts();
    
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        return _buildContactCard(contact);
      },
    );
  }

  Widget _buildContactCard(InternationalContact contact) {
    return Card(
      child: ListTile(
        leading: Text(
          _getCountryFlag(contact.country),
          style: const TextStyle(fontSize: 24),
        ),
        title: Text('${contact.name} (${contact.role})'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Country: ${contact.country.name}'),
            Text('Trust: ${(contact.trustLevel * 100).toInt()}% | Influence: ${(contact.influenceLevel * 100).toInt()}%'),
            Text('Corruption Cost: \$${(contact.corruptionCost / 1000).toInt()}K'),
            Text('Specialties: ${contact.specialties.map((s) => s.name).join(', ')}'),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () => _showCorruptContactDialog(contact),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
          child: const Text('Corrupt'),
        ),
        isThreeLine: true,
      ),
    );
  }

  void _showEstablishTerritoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Establish Territory'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: Country.values.map((country) {
            return ListTile(
              leading: Text(_getCountryFlag(country), style: const TextStyle(fontSize: 20)),
              title: Text(country.name),
              onTap: () {
                _intlSystem.establishTerritory(
                  '${country.name} Territory',
                  country,
                  OperationType.drugTrafficking,
                );
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showLaunchOperationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Launch Operation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: OperationType.values.map((type) {
            return ListTile(
              leading: Icon(_getOperationIcon(type), color: _getOperationColor(type)),
              title: Text(type.name),
              onTap: () {
                _intlSystem.launchOperation(
                  '${type.name} Operation',
                  type,
                  [Country.usa, Country.colombia],
                  100000,
                );
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showCreateRouteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Smuggling Route'),
        content: const Text('Select origin and destination countries'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _intlSystem.createSmuggllingRoute(
                'Colombia-USA Route',
                Country.colombia,
                Country.usa,
                OperationType.drugTrafficking,
              );
              Navigator.of(context).pop();
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showImproveRelationsDialog(DiplomaticRelation relation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Improve Relations with ${relation.country.name}'),
        content: const Text('How much do you want to invest in diplomatic relations?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _intlSystem.improveDiplomaticRelations(relation.country, 50000);
              Navigator.of(context).pop();
            },
            child: const Text('\$50K'),
          ),
          ElevatedButton(
            onPressed: () {
              _intlSystem.improveDiplomaticRelations(relation.country, 100000);
              Navigator.of(context).pop();
            },
            child: const Text('\$100K'),
          ),
        ],
      ),
    );
  }

  void _showCorruptContactDialog(InternationalContact contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Corrupt ${contact.name}'),
        content: Text('Pay \$${(contact.corruptionCost / 1000).toInt()}K to corrupt this contact?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _intlSystem.corruptOfficial(contact.id, contact.corruptionCost);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Corrupt'),
          ),
        ],
      ),
    );
  }

  void _toggleRoute(String routeId, bool isActive) {
    // Implementation would toggle route active state
  }

  String _getCountryFlag(Country country) {
    switch (country) {
      case Country.usa: return '🇺🇸';
      case Country.canada: return '🇨🇦';
      case Country.mexico: return '🇲🇽';
      case Country.colombia: return '🇨🇴';
      case Country.brazil: return '🇧🇷';
      case Country.uk: return '🇬🇧';
      case Country.france: return '🇫🇷';
      case Country.germany: return '🇩🇪';
      case Country.russia: return '🇷🇺';
      case Country.china: return '🇨🇳';
      case Country.japan: return '🇯🇵';
      case Country.australia: return '🇦🇺';
      case Country.india: return '🇮🇳';
      case Country.thailand: return '🇹🇭';
      case Country.afghanistan: return '🇦🇫';
      case Country.somalia: return '🇸🇴';
      case Country.nigeria: return '🇳🇬';
      case Country.southAfrica: return '🇿🇦';
    }
  }

  Color _getOperationColor(OperationType type) {
    switch (type) {
      case OperationType.drugTrafficking: return Colors.green;
      case OperationType.armsDealing: return Colors.red;
      case OperationType.humanTrafficking: return Colors.purple;
      case OperationType.moneyLaundering: return Colors.blue;
      case OperationType.cybercrime: return Colors.cyan;
      case OperationType.corruption: return Colors.orange;
      case OperationType.espionage: return Colors.grey;
      case OperationType.terrorism: return Colors.black;
    }
  }

  IconData _getOperationIcon(OperationType type) {
    switch (type) {
      case OperationType.drugTrafficking: return Icons.local_pharmacy;
      case OperationType.armsDealing: return Icons.security;
      case OperationType.humanTrafficking: return Icons.people;
      case OperationType.moneyLaundering: return Icons.attach_money;
      case OperationType.cybercrime: return Icons.computer;
      case OperationType.corruption: return Icons.handshake;
      case OperationType.espionage: return Icons.visibility;
      case OperationType.terrorism: return Icons.dangerous;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
