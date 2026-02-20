// Social Impact & Endgame Models
import 'package:flutter/foundation.dart';

extension MapExtension<K, V> on Map<K, V> {
  Map<K, V> cast<NK, NV>() => Map<NK, NV>.from(this.cast<NK, NV>()) as Map<K, V>;
}

@immutable
class SocialImpact {
  final String communityId;
  final String communityName;
  final Map<String, double> consequences; // crime_rate, addiction_rate, poverty_level
  final Map<String, int> affectedPopulation;
  final List<String> positivePrograms; // community programs you fund
  final List<String> negativeEffects;
  final double communityTrust; // -100 to 100
  final Map<String, double> economicImpact;
  final DateTime lastAssessment;

  const SocialImpact({
    required this.communityId,
    required this.communityName,
    required this.consequences,
    required this.affectedPopulation,
    required this.positivePrograms,
    required this.negativeEffects,
    required this.communityTrust,
    required this.economicImpact,
    required this.lastAssessment,
  });

  SocialImpact copyWith({
    String? communityId,
    String? communityName,
    Map<String, double>? consequences,
    Map<String, int>? affectedPopulation,
    List<String>? positivePrograms,
    List<String>? negativeEffects,
    double? communityTrust,
    Map<String, double>? economicImpact,
    DateTime? lastAssessment,
  }) {
    return SocialImpact(
      communityId: communityId ?? this.communityId,
      communityName: communityName ?? this.communityName,
      consequences: consequences ?? this.consequences,
      affectedPopulation: affectedPopulation ?? this.affectedPopulation,
      positivePrograms: positivePrograms ?? this.positivePrograms,
      negativeEffects: negativeEffects ?? this.negativeEffects,
      communityTrust: communityTrust ?? this.communityTrust,
      economicImpact: economicImpact ?? this.economicImpact,
      lastAssessment: lastAssessment ?? this.lastAssessment,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'communityId': communityId,
      'communityName': communityName,
      'consequences': consequences,
      'affectedPopulation': affectedPopulation,
      'positivePrograms': positivePrograms,
      'negativeEffects': negativeEffects,
      'communityTrust': communityTrust,
      'economicImpact': economicImpact,
      'lastAssessment': lastAssessment.toIso8601String(),
    };
  }

  factory SocialImpact.fromJson(Map<String, dynamic> json) {
    return SocialImpact(
      communityId: json['communityId'],
      communityName: json['communityName'],
      consequences: Map<String, double>.from(json['consequences']),
      affectedPopulation: Map<String, int>.from(json['affectedPopulation']),
      positivePrograms: List<String>.from(json['positivePrograms']),
      negativeEffects: List<String>.from(json['negativeEffects']),
      communityTrust: json['communityTrust'],
      economicImpact: Map<String, double>.from(json['economicImpact']),
      lastAssessment: DateTime.parse(json['lastAssessment']),
    );
  }
}

@immutable
class RehabilitationProgram {
  final String id;
  final String name;
  final String type; // 'addiction_treatment', 'job_training', 'education', 'mental_health'
  final int capacity;
  final int currentParticipants;
  final double successRate;
  final double monthlyCost;
  final double reputationBonus;
  final List<String> requirements;
  final Map<String, int> outcomes;

  const RehabilitationProgram({
    required this.id,
    required this.name,
    required this.type,
    required this.capacity,
    required this.currentParticipants,
    required this.successRate,
    required this.monthlyCost,
    required this.reputationBonus,
    required this.requirements,
    required this.outcomes,
  });

  RehabilitationProgram copyWith({
    String? id,
    String? name,
    String? type,
    int? capacity,
    int? currentParticipants,
    double? successRate,
    double? monthlyCost,
    double? reputationBonus,
    List<String>? requirements,
    Map<String, int>? outcomes,
  }) {
    return RehabilitationProgram(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      capacity: capacity ?? this.capacity,
      currentParticipants: currentParticipants ?? this.currentParticipants,
      successRate: successRate ?? this.successRate,
      monthlyCost: monthlyCost ?? this.monthlyCost,
      reputationBonus: reputationBonus ?? this.reputationBonus,
      requirements: requirements ?? this.requirements,
      outcomes: outcomes ?? this.outcomes,
    );
  }

  double get utilizationRate => currentParticipants / capacity;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'capacity': capacity,
      'currentParticipants': currentParticipants,
      'successRate': successRate,
      'monthlyCost': monthlyCost,
      'reputationBonus': reputationBonus,
      'requirements': requirements,
      'outcomes': outcomes,
    };
  }

  factory RehabilitationProgram.fromJson(Map<String, dynamic> json) {
    return RehabilitationProgram(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      capacity: json['capacity'],
      currentParticipants: json['currentParticipants'],
      successRate: json['successRate'],
      monthlyCost: json['monthlyCost'],
      reputationBonus: json['reputationBonus'],
      requirements: List<String>.from(json['requirements']),
      outcomes: Map<String, int>.from(json['outcomes']),
    );
  }
}

@immutable
class EnvironmentalImpact {
  final String operationId;
  final String operationType;
  final Map<String, double> pollutionLevels; // air, water, soil
  final List<String> affectedAreas;
  final double cleanupCost;
  final Map<String, int> healthEffects;
  final List<String> mitigationMeasures;
  final double environmentalScore; // 0-100 (100 = no impact)

  const EnvironmentalImpact({
    required this.operationId,
    required this.operationType,
    required this.pollutionLevels,
    required this.affectedAreas,
    required this.cleanupCost,
    required this.healthEffects,
    required this.mitigationMeasures,
    required this.environmentalScore,
  });

  EnvironmentalImpact copyWith({
    String? operationId,
    String? operationType,
    Map<String, double>? pollutionLevels,
    List<String>? affectedAreas,
    double? cleanupCost,
    Map<String, int>? healthEffects,
    List<String>? mitigationMeasures,
    double? environmentalScore,
  }) {
    return EnvironmentalImpact(
      operationId: operationId ?? this.operationId,
      operationType: operationType ?? this.operationType,
      pollutionLevels: pollutionLevels ?? this.pollutionLevels,
      affectedAreas: affectedAreas ?? this.affectedAreas,
      cleanupCost: cleanupCost ?? this.cleanupCost,
      healthEffects: healthEffects ?? this.healthEffects,
      mitigationMeasures: mitigationMeasures ?? this.mitigationMeasures,
      environmentalScore: environmentalScore ?? this.environmentalScore,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'operationId': operationId,
      'operationType': operationType,
      'pollutionLevels': pollutionLevels,
      'affectedAreas': affectedAreas,
      'cleanupCost': cleanupCost,
      'healthEffects': healthEffects,
      'mitigationMeasures': mitigationMeasures,
      'environmentalScore': environmentalScore,
    };
  }

  factory EnvironmentalImpact.fromJson(Map<String, dynamic> json) {
    return EnvironmentalImpact(
      operationId: json['operationId'],
      operationType: json['operationType'],
      pollutionLevels: Map<String, double>.from(json['pollutionLevels']),
      affectedAreas: List<String>.from(json['affectedAreas']),
      cleanupCost: json['cleanupCost'],
      healthEffects: Map<String, int>.from(json['healthEffects']),
      mitigationMeasures: List<String>.from(json['mitigationMeasures']),
      environmentalScore: json['environmentalScore'],
    );
  }
}

@immutable
class CharitySystem {
  final String charityId;
  final String name;
  final String cause; // 'education', 'healthcare', 'poverty', 'addiction'
  final double totalDonated;
  final double monthlyContribution;
  final double publicVisibility; // 0-100
  final double reputationGain;
  final Map<String, int> impact; // lives_helped, programs_funded
  final bool isPublic; // whether donations are public knowledge

  const CharitySystem({
    required this.charityId,
    required this.name,
    required this.cause,
    required this.totalDonated,
    required this.monthlyContribution,
    required this.publicVisibility,
    required this.reputationGain,
    required this.impact,
    this.isPublic = false,
  });

  CharitySystem copyWith({
    String? charityId,
    String? name,
    String? cause,
    double? totalDonated,
    double? monthlyContribution,
    double? publicVisibility,
    double? reputationGain,
    Map<String, int>? impact,
    bool? isPublic,
  }) {
    return CharitySystem(
      charityId: charityId ?? this.charityId,
      name: name ?? this.name,
      cause: cause ?? this.cause,
      totalDonated: totalDonated ?? this.totalDonated,
      monthlyContribution: monthlyContribution ?? this.monthlyContribution,
      publicVisibility: publicVisibility ?? this.publicVisibility,
      reputationGain: reputationGain ?? this.reputationGain,
      impact: impact ?? this.impact,
      isPublic: isPublic ?? this.isPublic,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'charityId': charityId,
      'name': name,
      'cause': cause,
      'totalDonated': totalDonated,
      'monthlyContribution': monthlyContribution,
      'publicVisibility': publicVisibility,
      'reputationGain': reputationGain,
      'impact': impact,
      'isPublic': isPublic,
    };
  }

  factory CharitySystem.fromJson(Map<String, dynamic> json) {
    return CharitySystem(
      charityId: json['charityId'],
      name: json['name'],
      cause: json['cause'],
      totalDonated: json['totalDonated'],
      monthlyContribution: json['monthlyContribution'],
      publicVisibility: json['publicVisibility'],
      reputationGain: json['reputationGain'],
      impact: Map<String, int>.from(json['impact']),
      isPublic: json['isPublic'] ?? false,
    );
  }
}

@immutable
class EndgameScenario {
  final String id;
  final String name;
  final String type; // 'retirement', 'capture', 'death', 'takeover', 'reform'
  final Map<String, int> requirements;
  final List<String> availableChoices;
  final Map<String, String> outcomes;
  final double difficulty;
  final Map<String, double> legacyEffects;
  final bool isUnlocked;

  const EndgameScenario({
    required this.id,
    required this.name,
    required this.type,
    required this.requirements,
    required this.availableChoices,
    required this.outcomes,
    required this.difficulty,
    required this.legacyEffects,
    this.isUnlocked = false,
  });

  EndgameScenario copyWith({
    String? id,
    String? name,
    String? type,
    Map<String, int>? requirements,
    List<String>? availableChoices,
    Map<String, String>? outcomes,
    double? difficulty,
    Map<String, double>? legacyEffects,
    bool? isUnlocked,
  }) {
    return EndgameScenario(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      requirements: requirements ?? this.requirements,
      availableChoices: availableChoices ?? this.availableChoices,
      outcomes: outcomes ?? this.outcomes,
      difficulty: difficulty ?? this.difficulty,
      legacyEffects: legacyEffects ?? this.legacyEffects,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'requirements': requirements,
      'availableChoices': availableChoices,
      'outcomes': outcomes,
      'difficulty': difficulty,
      'legacyEffects': legacyEffects,
      'isUnlocked': isUnlocked,
    };
  }

  factory EndgameScenario.fromJson(Map<String, dynamic> json) {
    return EndgameScenario(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      requirements: Map<String, int>.from(json['requirements']),
      availableChoices: List<String>.from(json['availableChoices']),
      outcomes: Map<String, String>.from(json['outcomes']),
      difficulty: json['difficulty'],
      legacyEffects: Map<String, double>.from(json['legacyEffects']),
      isUnlocked: json['isUnlocked'] ?? false,
    );
  }
}

@immutable
class LegacySystem {
  final String heirId;
  final String name;
  final Map<String, int> inheritedAssets;
  final Map<String, double> inheritedSkills;
  final List<String> inheritedReputation;
  final Map<String, String> inheritedRelationships;
  final double startingAdvantage; // 0-100
  final List<String> specialAbilities;
  final Map<String, int> challenges; // inherited problems

  const LegacySystem({
    required this.heirId,
    required this.name,
    required this.inheritedAssets,
    required this.inheritedSkills,
    required this.inheritedReputation,
    required this.inheritedRelationships,
    required this.startingAdvantage,
    required this.specialAbilities,
    required this.challenges,
  });

  LegacySystem copyWith({
    String? heirId,
    String? name,
    Map<String, int>? inheritedAssets,
    Map<String, double>? inheritedSkills,
    List<String>? inheritedReputation,
    Map<String, String>? inheritedRelationships,
    double? startingAdvantage,
    List<String>? specialAbilities,
    Map<String, int>? challenges,
  }) {
    return LegacySystem(
      heirId: heirId ?? this.heirId,
      name: name ?? this.name,
      inheritedAssets: inheritedAssets ?? this.inheritedAssets,
      inheritedSkills: inheritedSkills ?? this.inheritedSkills,
      inheritedReputation: inheritedReputation ?? this.inheritedReputation,
      inheritedRelationships: inheritedRelationships ?? this.inheritedRelationships,
      startingAdvantage: startingAdvantage ?? this.startingAdvantage,
      specialAbilities: specialAbilities ?? this.specialAbilities,
      challenges: challenges ?? this.challenges,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'heirId': heirId,
      'name': name,
      'inheritedAssets': inheritedAssets,
      'inheritedSkills': inheritedSkills,
      'inheritedReputation': inheritedReputation,
      'inheritedRelationships': inheritedRelationships,
      'startingAdvantage': startingAdvantage,
      'specialAbilities': specialAbilities,
      'challenges': challenges,
    };
  }

  factory LegacySystem.fromJson(Map<String, dynamic> json) {
    return LegacySystem(
      heirId: json['heirId'],
      name: json['name'],
      inheritedAssets: Map<String, int>.from(json['inheritedAssets']),
      inheritedSkills: Map<String, double>.from(json['inheritedSkills']),
      inheritedReputation: List<String>.from(json['inheritedReputation']),
      inheritedRelationships: Map<String, String>.from(json['inheritedRelationships']),
      startingAdvantage: json['startingAdvantage'],
      specialAbilities: List<String>.from(json['specialAbilities']),
      challenges: Map<String, int>.from(json['challenges']),
    );
  }
}

@immutable
class NewGamePlus {
  final int playthrough;
  final Map<String, bool> unlockedFeatures;
  final Map<String, double> bonuses;
  final List<String> carriedAchievements;
  final Map<String, int> permanentUpgrades;
  final double difficultyMultiplier;
  final List<String> exclusiveContent;

  const NewGamePlus({
    required this.playthrough,
    required this.unlockedFeatures,
    required this.bonuses,
    required this.carriedAchievements,
    required this.permanentUpgrades,
    required this.difficultyMultiplier,
    required this.exclusiveContent,
  });

  NewGamePlus copyWith({
    int? playthrough,
    Map<String, bool>? unlockedFeatures,
    Map<String, double>? bonuses,
    List<String>? carriedAchievements,
    Map<String, int>? permanentUpgrades,
    double? difficultyMultiplier,
    List<String>? exclusiveContent,
  }) {
    return NewGamePlus(
      playthrough: playthrough ?? this.playthrough,
      unlockedFeatures: unlockedFeatures ?? this.unlockedFeatures,
      bonuses: bonuses ?? this.bonuses,
      carriedAchievements: carriedAchievements ?? this.carriedAchievements,
      permanentUpgrades: permanentUpgrades ?? this.permanentUpgrades,
      difficultyMultiplier: difficultyMultiplier ?? this.difficultyMultiplier,
      exclusiveContent: exclusiveContent ?? this.exclusiveContent,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'playthrough': playthrough,
      'unlockedFeatures': unlockedFeatures,
      'bonuses': bonuses,
      'carriedAchievements': carriedAchievements,
      'permanentUpgrades': permanentUpgrades,
      'difficultyMultiplier': difficultyMultiplier,
      'exclusiveContent': exclusiveContent,
    };
  }

  factory NewGamePlus.fromJson(Map<String, dynamic> json) {
    return NewGamePlus(
      playthrough: json['playthrough'],
      unlockedFeatures: Map<String, bool>.from(json['unlockedFeatures']),
      bonuses: Map<String, double>.from(json['bonuses']),
      carriedAchievements: List<String>.from(json['carriedAchievements']),
      permanentUpgrades: Map<String, int>.from(json['permanentUpgrades']),
      difficultyMultiplier: json['difficultyMultiplier'],
      exclusiveContent: List<String>.from(json['exclusiveContent']),
    );
  }
}

@immutable
class PrestigeMetaSystem {
  final int prestigeLevel;
  final int prestigePoints;
  final Map<String, bool> prestigeUpgrades;
  final List<String> prestigeRewards;
  final Map<String, double> globalBonuses;
  final DateTime lastPrestige;
  final int totalPrestiges;

  const PrestigeMetaSystem({
    required this.prestigeLevel,
    required this.prestigePoints,
    required this.prestigeUpgrades,
    required this.prestigeRewards,
    required this.globalBonuses,
    required this.lastPrestige,
    required this.totalPrestiges,
  });

  PrestigeMetaSystem copyWith({
    int? prestigeLevel,
    int? prestigePoints,
    Map<String, bool>? prestigeUpgrades,
    List<String>? prestigeRewards,
    Map<String, double>? globalBonuses,
    DateTime? lastPrestige,
    int? totalPrestiges,
  }) {
    return PrestigeMetaSystem(
      prestigeLevel: prestigeLevel ?? this.prestigeLevel,
      prestigePoints: prestigePoints ?? this.prestigePoints,
      prestigeUpgrades: prestigeUpgrades ?? this.prestigeUpgrades,
      prestigeRewards: prestigeRewards ?? this.prestigeRewards,
      globalBonuses: globalBonuses ?? this.globalBonuses,
      lastPrestige: lastPrestige ?? this.lastPrestige,
      totalPrestiges: totalPrestiges ?? this.totalPrestiges,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prestigeLevel': prestigeLevel,
      'prestigePoints': prestigePoints,
      'prestigeUpgrades': prestigeUpgrades,
      'prestigeRewards': prestigeRewards,
      'globalBonuses': globalBonuses,
      'lastPrestige': lastPrestige.toIso8601String(),
      'totalPrestiges': totalPrestiges,
    };
  }

  factory PrestigeMetaSystem.fromJson(Map<String, dynamic> json) {
    return PrestigeMetaSystem(
      prestigeLevel: json['prestigeLevel'],
      prestigePoints: json['prestigePoints'],
      prestigeUpgrades: Map<String, bool>.from(json['prestigeUpgrades']),
      prestigeRewards: List<String>.from(json['prestigeRewards']),
      globalBonuses: Map<String, double>.from(json['globalBonuses']),
      lastPrestige: DateTime.parse(json['lastPrestige']),
      totalPrestiges: json['totalPrestiges'],
    );
  }
}
