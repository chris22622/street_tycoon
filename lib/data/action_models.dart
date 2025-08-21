// Action Elements Models
import 'package:flutter/foundation.dart';

@immutable
class ShootoutScenario {
  final String id;
  final String location;
  final String scenario; // 'police_raid', 'rival_gang', 'robbery', 'ambush'
  final List<String> enemies;
  final Map<String, int> enemyStats; // health, accuracy, armor
  final List<String> availableWeapons;
  final Map<String, String> cover; // position -> cover_type
  final List<String> objectives;
  final int timeLimit; // seconds
  final Map<String, double> rewards;

  const ShootoutScenario({
    required this.id,
    required this.location,
    required this.scenario,
    required this.enemies,
    required this.enemyStats,
    required this.availableWeapons,
    required this.cover,
    required this.objectives,
    required this.timeLimit,
    required this.rewards,
  });

  ShootoutScenario copyWith({
    String? id,
    String? location,
    String? scenario,
    List<String>? enemies,
    Map<String, int>? enemyStats,
    List<String>? availableWeapons,
    Map<String, String>? cover,
    List<String>? objectives,
    int? timeLimit,
    Map<String, double>? rewards,
  }) {
    return ShootoutScenario(
      id: id ?? this.id,
      location: location ?? this.location,
      scenario: scenario ?? this.scenario,
      enemies: enemies ?? this.enemies,
      enemyStats: enemyStats ?? this.enemyStats,
      availableWeapons: availableWeapons ?? this.availableWeapons,
      cover: cover ?? this.cover,
      objectives: objectives ?? this.objectives,
      timeLimit: timeLimit ?? this.timeLimit,
      rewards: rewards ?? this.rewards,
    );
  }
}

@immutable
class CarChase {
  final String id;
  final String startLocation;
  final String route;
  final List<String> pursuers;
  final Map<String, int> vehicleStats; // speed, handling, armor
  final List<String> obstacles;
  final Map<String, String> escapeRoutes;
  final int duration; // seconds
  final double difficulty;
  final Map<String, double> penalties; // crash damage, heat increase

  const CarChase({
    required this.id,
    required this.startLocation,
    required this.route,
    required this.pursuers,
    required this.vehicleStats,
    required this.obstacles,
    required this.escapeRoutes,
    required this.duration,
    required this.difficulty,
    required this.penalties,
  });

  CarChase copyWith({
    String? id,
    String? startLocation,
    String? route,
    List<String>? pursuers,
    Map<String, int>? vehicleStats,
    List<String>? obstacles,
    Map<String, String>? escapeRoutes,
    int? duration,
    double? difficulty,
    Map<String, double>? penalties,
  }) {
    return CarChase(
      id: id ?? this.id,
      startLocation: startLocation ?? this.startLocation,
      route: route ?? this.route,
      pursuers: pursuers ?? this.pursuers,
      vehicleStats: vehicleStats ?? this.vehicleStats,
      obstacles: obstacles ?? this.obstacles,
      escapeRoutes: escapeRoutes ?? this.escapeRoutes,
      duration: duration ?? this.duration,
      difficulty: difficulty ?? this.difficulty,
      penalties: penalties ?? this.penalties,
    );
  }
}

@immutable
class StealthMission {
  final String id;
  final String target; // 'police_station', 'rival_warehouse', 'government_building'
  final String objective; // 'steal_files', 'plant_evidence', 'sabotage', 'rescue'
  final Map<String, int> securityLevels;
  final List<String> guards;
  final Map<String, String> securitySystems; // cameras, alarms, sensors
  final List<String> entryPoints;
  final Map<String, String> disguises;
  final int timeWindow; // minutes
  final double detectionRisk;

  const StealthMission({
    required this.id,
    required this.target,
    required this.objective,
    required this.securityLevels,
    required this.guards,
    required this.securitySystems,
    required this.entryPoints,
    required this.disguises,
    required this.timeWindow,
    required this.detectionRisk,
  });

  StealthMission copyWith({
    String? id,
    String? target,
    String? objective,
    Map<String, int>? securityLevels,
    List<String>? guards,
    Map<String, String>? securitySystems,
    List<String>? entryPoints,
    Map<String, String>? disguises,
    int? timeWindow,
    double? detectionRisk,
  }) {
    return StealthMission(
      id: id ?? this.id,
      target: target ?? this.target,
      objective: objective ?? this.objective,
      securityLevels: securityLevels ?? this.securityLevels,
      guards: guards ?? this.guards,
      securitySystems: securitySystems ?? this.securitySystems,
      entryPoints: entryPoints ?? this.entryPoints,
      disguises: disguises ?? this.disguises,
      timeWindow: timeWindow ?? this.timeWindow,
      detectionRisk: detectionRisk ?? this.detectionRisk,
    );
  }
}

@immutable
class Negotiation {
  final String id;
  final String scenario; // 'hostage', 'drug_deal', 'territory_dispute', 'ransom'
  final List<String> participants;
  final Map<String, int> relationships; // participant -> relationship_level
  final Map<String, String> demands;
  final Map<String, String> leverages;
  final List<String> possibleOutcomes;
  final int timeLimit; // minutes
  final Map<String, double> successRates;

  const Negotiation({
    required this.id,
    required this.scenario,
    required this.participants,
    required this.relationships,
    required this.demands,
    required this.leverages,
    required this.possibleOutcomes,
    required this.timeLimit,
    required this.successRates,
  });

  Negotiation copyWith({
    String? id,
    String? scenario,
    List<String>? participants,
    Map<String, int>? relationships,
    Map<String, String>? demands,
    Map<String, String>? leverages,
    List<String>? possibleOutcomes,
    int? timeLimit,
    Map<String, double>? successRates,
  }) {
    return Negotiation(
      id: id ?? this.id,
      scenario: scenario ?? this.scenario,
      participants: participants ?? this.participants,
      relationships: relationships ?? this.relationships,
      demands: demands ?? this.demands,
      leverages: leverages ?? this.leverages,
      possibleOutcomes: possibleOutcomes ?? this.possibleOutcomes,
      timeLimit: timeLimit ?? this.timeLimit,
      successRates: successRates ?? this.successRates,
    );
  }
}

@immutable
class HackingMinigame {
  final String id;
  final String target; // 'bank_system', 'police_database', 'rival_network'
  final String difficulty; // 'beginner', 'intermediate', 'advanced', 'expert'
  final List<String> requiredSkills;
  final Map<String, int> securityLayers;
  final List<String> tools; // 'virus', 'trojan', 'backdoor', 'encryption_breaker'
  final int timeLimit; // minutes
  final double detectionChance;
  final Map<String, dynamic> rewards;

  const HackingMinigame({
    required this.id,
    required this.target,
    required this.difficulty,
    required this.requiredSkills,
    required this.securityLayers,
    required this.tools,
    required this.timeLimit,
    required this.detectionChance,
    required this.rewards,
  });

  HackingMinigame copyWith({
    String? id,
    String? target,
    String? difficulty,
    List<String>? requiredSkills,
    Map<String, int>? securityLayers,
    List<String>? tools,
    int? timeLimit,
    double? detectionChance,
    Map<String, dynamic>? rewards,
  }) {
    return HackingMinigame(
      id: id ?? this.id,
      target: target ?? this.target,
      difficulty: difficulty ?? this.difficulty,
      requiredSkills: requiredSkills ?? this.requiredSkills,
      securityLayers: securityLayers ?? this.securityLayers,
      tools: tools ?? this.tools,
      timeLimit: timeLimit ?? this.timeLimit,
      detectionChance: detectionChance ?? this.detectionChance,
      rewards: rewards ?? this.rewards,
    );
  }
}

@immutable
class DemolitionMission {
  final String id;
  final String target; // 'rival_lab', 'police_evidence', 'competitor_warehouse'
  final String explosiveType; // 'c4', 'dynamite', 'car_bomb', 'molotov'
  final Map<String, int> structuralPoints;
  final List<String> civilianAreas;
  final double collateralDamage;
  final int preparationTime; // hours
  final List<String> requiredMaterials;
  final double escapeTime; // minutes

  const DemolitionMission({
    required this.id,
    required this.target,
    required this.explosiveType,
    required this.structuralPoints,
    required this.civilianAreas,
    required this.collateralDamage,
    required this.preparationTime,
    required this.requiredMaterials,
    required this.escapeTime,
  });

  DemolitionMission copyWith({
    String? id,
    String? target,
    String? explosiveType,
    Map<String, int>? structuralPoints,
    List<String>? civilianAreas,
    double? collateralDamage,
    int? preparationTime,
    List<String>? requiredMaterials,
    double? escapeTime,
  }) {
    return DemolitionMission(
      id: id ?? this.id,
      target: target ?? this.target,
      explosiveType: explosiveType ?? this.explosiveType,
      structuralPoints: structuralPoints ?? this.structuralPoints,
      civilianAreas: civilianAreas ?? this.civilianAreas,
      collateralDamage: collateralDamage ?? this.collateralDamage,
      preparationTime: preparationTime ?? this.preparationTime,
      requiredMaterials: requiredMaterials ?? this.requiredMaterials,
      escapeTime: escapeTime ?? this.escapeTime,
    );
  }
}

@immutable
class SurveillanceOperation {
  final String id;
  final String target; // 'rival_boss', 'police_detective', 'politician'
  final String method; // 'physical', 'electronic', 'cyber', 'informant'
  final Map<String, String> equipment;
  final List<String> locations;
  final int duration; // days
  final double detectionRisk;
  final Map<String, dynamic> intelligence; // gathered information
  final List<String> operatives;

  const SurveillanceOperation({
    required this.id,
    required this.target,
    required this.method,
    required this.equipment,
    required this.locations,
    required this.duration,
    required this.detectionRisk,
    required this.intelligence,
    required this.operatives,
  });

  SurveillanceOperation copyWith({
    String? id,
    String? target,
    String? method,
    Map<String, String>? equipment,
    List<String>? locations,
    int? duration,
    double? detectionRisk,
    Map<String, dynamic>? intelligence,
    List<String>? operatives,
  }) {
    return SurveillanceOperation(
      id: id ?? this.id,
      target: target ?? this.target,
      method: method ?? this.method,
      equipment: equipment ?? this.equipment,
      locations: locations ?? this.locations,
      duration: duration ?? this.duration,
      detectionRisk: detectionRisk ?? this.detectionRisk,
      intelligence: intelligence ?? this.intelligence,
      operatives: operatives ?? this.operatives,
    );
  }
}
