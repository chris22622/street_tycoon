// Social Impact & Endgame Models
import 'package:flutter/foundation.dart';

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
}

@immutable
class PrestigeSystem {
  final int prestigeLevel;
  final int prestigePoints;
  final Map<String, bool> prestigeUpgrades;
  final List<String> prestigeRewards;
  final Map<String, double> globalBonuses;
  final DateTime lastPrestige;
  final int totalPrestiges;

  const PrestigeSystem({
    required this.prestigeLevel,
    required this.prestigePoints,
    required this.prestigeUpgrades,
    required this.prestigeRewards,
    required this.globalBonuses,
    required this.lastPrestige,
    required this.totalPrestiges,
  });

  PrestigeSystem copyWith({
    int? prestigeLevel,
    int? prestigePoints,
    Map<String, bool>? prestigeUpgrades,
    List<String>? prestigeRewards,
    Map<String, double>? globalBonuses,
    DateTime? lastPrestige,
    int? totalPrestiges,
  }) {
    return PrestigeSystem(
      prestigeLevel: prestigeLevel ?? this.prestigeLevel,
      prestigePoints: prestigePoints ?? this.prestigePoints,
      prestigeUpgrades: prestigeUpgrades ?? this.prestigeUpgrades,
      prestigeRewards: prestigeRewards ?? this.prestigeRewards,
      globalBonuses: globalBonuses ?? this.globalBonuses,
      lastPrestige: lastPrestige ?? this.lastPrestige,
      totalPrestiges: totalPrestiges ?? this.totalPrestiges,
    );
  }
}
