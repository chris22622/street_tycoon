// Character Development Models
import 'package:flutter/foundation.dart';

@immutable
class Skill {
  final String id;
  final String name;
  final String category;
  final String description;
  final int level;
  final int maxLevel;
  final int experience;
  final int experienceToNext;
  final List<String> prerequisites;
  final Map<String, double> effects;
  final String iconPath;

  const Skill({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.level,
    required this.maxLevel,
    required this.experience,
    required this.experienceToNext,
    required this.prerequisites,
    required this.effects,
    required this.iconPath,
  });

  Skill copyWith({
    String? id, String? name, String? category, String? description,
    int? level, int? maxLevel, int? experience, int? experienceToNext,
    List<String>? prerequisites, Map<String, double>? effects, String? iconPath,
  }) {
    return Skill(id: id ?? this.id, name: name ?? this.name, category: category ?? this.category,
      description: description ?? this.description, level: level ?? this.level,
      maxLevel: maxLevel ?? this.maxLevel, experience: experience ?? this.experience,
      experienceToNext: experienceToNext ?? this.experienceToNext,
      prerequisites: prerequisites ?? this.prerequisites, effects: effects ?? this.effects,
      iconPath: iconPath ?? this.iconPath);
  }

  Map<String, dynamic> toJson() {
    return { 'id': id, 'name': name, 'category': category, 'description': description,
      'level': level, 'maxLevel': maxLevel, 'experience': experience,
      'experienceToNext': experienceToNext, 'prerequisites': prerequisites,
      'effects': effects, 'iconPath': iconPath };
  }

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(id: json['id'], name: json['name'], category: json['category'],
      description: json['description'], level: json['level'], maxLevel: json['maxLevel'],
      experience: json['experience'], experienceToNext: json['experienceToNext'],
      prerequisites: List<String>.from(json['prerequisites']),
      effects: Map<String, double>.from(json['effects']), iconPath: json['iconPath']);
  }
}

@immutable
class Reputation {
  final String faction;
  final int level;
  final int points;
  final String status;
  final List<String> unlockableFeatures;

  const Reputation({required this.faction, required this.level, required this.points,
    required this.status, required this.unlockableFeatures});

  Reputation copyWith({String? faction, int? level, int? points, String? status,
    List<String>? unlockableFeatures}) {
    return Reputation(faction: faction ?? this.faction, level: level ?? this.level,
      points: points ?? this.points, status: status ?? this.status,
      unlockableFeatures: unlockableFeatures ?? this.unlockableFeatures);
  }

  Map<String, dynamic> toJson() {
    return { 'faction': faction, 'level': level, 'points': points, 'status': status,
      'unlockableFeatures': unlockableFeatures };
  }

  factory Reputation.fromJson(Map<String, dynamic> json) {
    return Reputation(faction: json['faction'], level: json['level'], points: json['points'],
      status: json['status'], unlockableFeatures: List<String>.from(json['unlockableFeatures']));
  }
}

@immutable
class Relationship {
  final String characterId;
  final String name;
  final String type;
  final int affection;
  final int trust;
  final int fear;
  final List<String> traits;
  final Map<String, dynamic> history;
  final bool isAlive;
  final String location;

  const Relationship({required this.characterId, required this.name, required this.type,
    required this.affection, required this.trust, required this.fear, required this.traits,
    required this.history, this.isAlive = true, required this.location});

  Relationship copyWith({String? characterId, String? name, String? type, int? affection,
    int? trust, int? fear, List<String>? traits, Map<String, dynamic>? history,
    bool? isAlive, String? location}) {
    return Relationship(characterId: characterId ?? this.characterId, name: name ?? this.name,
      type: type ?? this.type, affection: affection ?? this.affection, trust: trust ?? this.trust,
      fear: fear ?? this.fear, traits: traits ?? this.traits, history: history ?? this.history,
      isAlive: isAlive ?? this.isAlive, location: location ?? this.location);
  }

  Map<String, dynamic> toJson() {
    return { 'characterId': characterId, 'name': name, 'type': type, 'affection': affection,
      'trust': trust, 'fear': fear, 'traits': traits, 'history': history,
      'isAlive': isAlive, 'location': location };
  }

  factory Relationship.fromJson(Map<String, dynamic> json) {
    return Relationship(characterId: json['characterId'], name: json['name'],
      type: json['type'], affection: json['affection'], trust: json['trust'],
      fear: json['fear'], traits: List<String>.from(json['traits']), history: json['history'],
      isAlive: json['isAlive'] ?? true, location: json['location']);
  }
}

@immutable
class CharacterAge {
  final int years;
  final int months;
  final String ageGroup;
  final Map<String, double> physicalEffects;
  final Map<String, double> mentalEffects;
  final List<String> availableActions;

  const CharacterAge({required this.years, required this.months, required this.ageGroup,
    required this.physicalEffects, required this.mentalEffects, required this.availableActions});

  CharacterAge copyWith({int? years, int? months, String? ageGroup,
    Map<String, double>? physicalEffects, Map<String, double>? mentalEffects,
    List<String>? availableActions}) {
    return CharacterAge(years: years ?? this.years, months: months ?? this.months,
      ageGroup: ageGroup ?? this.ageGroup, physicalEffects: physicalEffects ?? this.physicalEffects,
      mentalEffects: mentalEffects ?? this.mentalEffects,
      availableActions: availableActions ?? this.availableActions);
  }

  Map<String, dynamic> toJson() {
    return { 'years': years, 'months': months, 'ageGroup': ageGroup,
      'physicalEffects': physicalEffects, 'mentalEffects': mentalEffects,
      'availableActions': availableActions };
  }

  factory CharacterAge.fromJson(Map<String, dynamic> json) {
    return CharacterAge(years: json['years'], months: json['months'], ageGroup: json['ageGroup'],
      physicalEffects: Map<String, double>.from(json['physicalEffects']),
      mentalEffects: Map<String, double>.from(json['mentalEffects']),
      availableActions: List<String>.from(json['availableActions']));
  }
}

@immutable
class FamilyMember {
  final String id;
  final String name;
  final String relationship;
  final int age;
  final Map<String, int> traits;
  final List<String> skills;
  final bool isAlive;
  final String location;
  final Map<String, dynamic> memories;

  const FamilyMember({required this.id, required this.name, required this.relationship,
    required this.age, required this.traits, required this.skills, this.isAlive = true,
    required this.location, required this.memories});

  FamilyMember copyWith({String? id, String? name, String? relationship, int? age,
    Map<String, int>? traits, List<String>? skills, bool? isAlive, String? location,
    Map<String, dynamic>? memories}) {
    return FamilyMember(id: id ?? this.id, name: name ?? this.name,
      relationship: relationship ?? this.relationship, age: age ?? this.age,
      traits: traits ?? this.traits, skills: skills ?? this.skills,
      isAlive: isAlive ?? this.isAlive, location: location ?? this.location,
      memories: memories ?? this.memories);
  }

  Map<String, dynamic> toJson() {
    return { 'id': id, 'name': name, 'relationship': relationship, 'age': age,
      'traits': traits, 'skills': skills, 'isAlive': isAlive, 'location': location,
      'memories': memories };
  }

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(id: json['id'], name: json['name'], relationship: json['relationship'],
      age: json['age'], traits: Map<String, int>.from(json['traits']),
      skills: List<String>.from(json['skills']), isAlive: json['isAlive'] ?? true,
      location: json['location'], memories: json['memories']);
  }
}

@immutable
class Education {
  final String id;
  final String name;
  final String type;
  final int level;
  final int progress;
  final List<String> unlockedSkills;
  final int cost;
  final int duration;
  final Map<String, int> requirements;

  const Education({required this.id, required this.name, required this.type,
    required this.level, required this.progress, required this.unlockedSkills,
    required this.cost, required this.duration, required this.requirements});

  Education copyWith({String? id, String? name, String? type, int? level, int? progress,
    List<String>? unlockedSkills, int? cost, int? duration, Map<String, int>? requirements}) {
    return Education(id: id ?? this.id, name: name ?? this.name, type: type ?? this.type,
      level: level ?? this.level, progress: progress ?? this.progress,
      unlockedSkills: unlockedSkills ?? this.unlockedSkills, cost: cost ?? this.cost,
      duration: duration ?? this.duration, requirements: requirements ?? this.requirements);
  }

  Map<String, dynamic> toJson() {
    return { 'id': id, 'name': name, 'type': type, 'level': level, 'progress': progress,
      'unlockedSkills': unlockedSkills, 'cost': cost, 'duration': duration,
      'requirements': requirements };
  }

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(id: json['id'], name: json['name'], type: json['type'],
      level: json['level'], progress: json['progress'],
      unlockedSkills: List<String>.from(json['unlockedSkills']), cost: json['cost'],
      duration: json['duration'], requirements: Map<String, int>.from(json['requirements']));
  }
}

@immutable
class HealthStatus {
  final int physicalHealth;
  final int mentalHealth;
  final Map<String, int> addictions;
  final List<String> injuries;
  final List<String> conditions;
  final Map<String, int> treatmentProgress;
  final bool isRecovering;

  const HealthStatus({required this.physicalHealth, required this.mentalHealth,
    required this.addictions, required this.injuries, required this.conditions,
    required this.treatmentProgress, this.isRecovering = false});

  HealthStatus copyWith({int? physicalHealth, int? mentalHealth, Map<String, int>? addictions,
    List<String>? injuries, List<String>? conditions, Map<String, int>? treatmentProgress,
    bool? isRecovering}) {
    return HealthStatus(physicalHealth: physicalHealth ?? this.physicalHealth,
      mentalHealth: mentalHealth ?? this.mentalHealth, addictions: addictions ?? this.addictions,
      injuries: injuries ?? this.injuries, conditions: conditions ?? this.conditions,
      treatmentProgress: treatmentProgress ?? this.treatmentProgress,
      isRecovering: isRecovering ?? this.isRecovering);
  }

  Map<String, dynamic> toJson() {
    return { 'physicalHealth': physicalHealth, 'mentalHealth': mentalHealth,
      'addictions': addictions, 'injuries': injuries, 'conditions': conditions,
      'treatmentProgress': treatmentProgress, 'isRecovering': isRecovering };
  }

  factory HealthStatus.fromJson(Map<String, dynamic> json) {
    return HealthStatus(physicalHealth: json['physicalHealth'], mentalHealth: json['mentalHealth'],
      addictions: Map<String, int>.from(json['addictions']),
      injuries: List<String>.from(json['injuries']), conditions: List<String>.from(json['conditions']),
      treatmentProgress: Map<String, int>.from(json['treatmentProgress']),
      isRecovering: json['isRecovering'] ?? false);
  }
}

@immutable
class LifestyleChoice {
  final String id;
  final String name;
  final String category;
  final int luxuryLevel;
  final int monthlyCost;
  final Map<String, double> effects;
  final List<String> requirements;
  final String description;

  const LifestyleChoice({required this.id, required this.name, required this.category,
    required this.luxuryLevel, required this.monthlyCost, required this.effects,
    required this.requirements, required this.description});

  LifestyleChoice copyWith({String? id, String? name, String? category, int? luxuryLevel,
    int? monthlyCost, Map<String, double>? effects, List<String>? requirements,
    String? description}) {
    return LifestyleChoice(id: id ?? this.id, name: name ?? this.name,
      category: category ?? this.category, luxuryLevel: luxuryLevel ?? this.luxuryLevel,
      monthlyCost: monthlyCost ?? this.monthlyCost, effects: effects ?? this.effects,
      requirements: requirements ?? this.requirements, description: description ?? this.description);
  }

  Map<String, dynamic> toJson() {
    return { 'id': id, 'name': name, 'category': category, 'luxuryLevel': luxuryLevel,
      'monthlyCost': monthlyCost, 'effects': effects, 'requirements': requirements,
      'description': description };
  }

  factory LifestyleChoice.fromJson(Map<String, dynamic> json) {
    return LifestyleChoice(id: json['id'], name: json['name'], category: json['category'],
      luxuryLevel: json['luxuryLevel'], monthlyCost: json['monthlyCost'],
      effects: Map<String, double>.from(json['effects']),
      requirements: List<String>.from(json['requirements']), description: json['description']);
  }
}
