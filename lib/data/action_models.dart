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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'location': location,
      'scenario': scenario,
      'enemies': enemies,
      'enemyStats': enemyStats,
      'availableWeapons': availableWeapons,
      'cover': cover,
      'objectives': objectives,
      'timeLimit': timeLimit,
      'rewards': rewards,
    };
  }

  factory ShootoutScenario.fromJson(Map<String, dynamic> json) {
    return ShootoutScenario(
      id: json['id'],
      location: json['location'],
      scenario: json['scenario'],
      enemies: List<String>.from(json['enemies']),
      enemyStats: Map<String, int>.from(json['enemyStats']),
      availableWeapons: List<String>.from(json['availableWeapons']),
      cover: Map<String, String>.from(json['cover']),
      objectives: List<String>.from(json['objectives']),
      timeLimit: json['timeLimit'],
      rewards: Map<String, double>.from(json['rewards']),
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startLocation': startLocation,
      'route': route,
      'pursuers': pursuers,
      'vehicleStats': vehicleStats,
      'obstacles': obstacles,
      'escapeRoutes': escapeRoutes,
      'duration': duration,
      'difficulty': difficulty,
      'penalties': penalties,
    };
  }

  factory CarChase.fromJson(Map<String, dynamic> json) {
    return CarChase(
      id: json['id'],
      startLocation: json['startLocation'],
      route: json['route'],
      pursuers: List<String>.from(json['pursuers']),
      vehicleStats: Map<String, int>.from(json['vehicleStats']),
      obstacles: List<String>.from(json['obstacles']),
      escapeRoutes: Map<String, String>.from(json['escapeRoutes']),
      duration: json['duration'],
      difficulty: json['difficulty'],
      penalties: Map<String, double>.from(json['penalties']),
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'target': target,
      'objective': objective,
      'securityLevels': securityLevels,
      'guards': guards,
      'securitySystems': securitySystems,
      'entryPoints': entryPoints,
      'disguises': disguises,
      'timeWindow': timeWindow,
      'detectionRisk': detectionRisk,
    };
  }

  factory StealthMission.fromJson(Map<String, dynamic> json) {
    return StealthMission(
      id: json['id'],
      target: json['target'],
      objective: json['objective'],
      securityLevels: Map<String, int>.from(json['securityLevels']),
      guards: List<String>.from(json['guards']),
      securitySystems: Map<String, String>.from(json['securitySystems']),
      entryPoints: List<String>.from(json['entryPoints']),
      disguises: Map<String, String>.from(json['disguises']),
      timeWindow: json['timeWindow'],
      detectionRisk: json['detectionRisk'],
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scenario': scenario,
      'participants': participants,
      'relationships': relationships,
      'demands': demands,
      'leverages': leverages,
      'possibleOutcomes': possibleOutcomes,
      'timeLimit': timeLimit,
      'successRates': successRates,
    };
  }

  factory Negotiation.fromJson(Map<String, dynamic> json) {
    return Negotiation(
      id: json['id'],
      scenario: json['scenario'],
      participants: List<String>.from(json['participants']),
      relationships: Map<String, int>.from(json['relationships']),
      demands: Map<String, String>.from(json['demands']),
      leverages: Map<String, String>.from(json['leverages']),
      possibleOutcomes: List<String>.from(json['possibleOutcomes']),
      timeLimit: json['timeLimit'],
      successRates: Map<String, double>.from(json['successRates']),
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'target': target,
      'difficulty': difficulty,
      'requiredSkills': requiredSkills,
      'securityLayers': securityLayers,
      'tools': tools,
      'timeLimit': timeLimit,
      'detectionChance': detectionChance,
      'rewards': rewards,
    };
  }

  factory HackingMinigame.fromJson(Map<String, dynamic> json) {
    return HackingMinigame(
      id: json['id'],
      target: json['target'],
      difficulty: json['difficulty'],
      requiredSkills: List<String>.from(json['requiredSkills']),
      securityLayers: Map<String, int>.from(json['securityLayers']),
      tools: List<String>.from(json['tools']),
      timeLimit: json['timeLimit'],
      detectionChance: json['detectionChance'],
      rewards: json['rewards'],
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'target': target,
      'explosiveType': explosiveType,
      'structuralPoints': structuralPoints,
      'civilianAreas': civilianAreas,
      'collateralDamage': collateralDamage,
      'preparationTime': preparationTime,
      'requiredMaterials': requiredMaterials,
      'escapeTime': escapeTime,
    };
  }

  factory DemolitionMission.fromJson(Map<String, dynamic> json) {
    return DemolitionMission(
      id: json['id'],
      target: json['target'],
      explosiveType: json['explosiveType'],
      structuralPoints: Map<String, int>.from(json['structuralPoints']),
      civilianAreas: List<String>.from(json['civilianAreas']),
      collateralDamage: json['collateralDamage'],
      preparationTime: json['preparationTime'],
      requiredMaterials: List<String>.from(json['requiredMaterials']),
      escapeTime: json['escapeTime'],
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'target': target,
      'method': method,
      'equipment': equipment,
      'locations': locations,
      'duration': duration,
      'detectionRisk': detectionRisk,
      'intelligence': intelligence,
      'operatives': operatives,
    };
  }

  factory SurveillanceOperation.fromJson(Map<String, dynamic> json) {
    return SurveillanceOperation(
      id: json['id'],
      target: json['target'],
      method: json['method'],
      equipment: Map<String, String>.from(json['equipment']),
      locations: List<String>.from(json['locations']),
      duration: json['duration'],
      detectionRisk: json['detectionRisk'],
      intelligence: json['intelligence'],
      operatives: List<String>.from(json['operatives']),
    );
  }
}
