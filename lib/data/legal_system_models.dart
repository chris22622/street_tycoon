// Legal System Models
import 'package:flutter/foundation.dart';

@immutable
class LawyerSpecialization {
  final String id;
  final String name;
  final String specialty; // 'criminal', 'corporate', 'international', 'tax'
  final int level; // 1-10
  final int experience;
  final double successRate;
  final int baseCost;
  final List<String> specialAbilities;
  final Map<String, double> caseTypeModifiers;

  const LawyerSpecialization({
    required this.id,
    required this.name,
    required this.specialty,
    required this.level,
    required this.experience,
    required this.successRate,
    required this.baseCost,
    required this.specialAbilities,
    required this.caseTypeModifiers,
  });

  LawyerSpecialization copyWith({
    String? id,
    String? name,
    String? specialty,
    int? level,
    int? experience,
    double? successRate,
    int? baseCost,
    List<String>? specialAbilities,
    Map<String, double>? caseTypeModifiers,
  }) {
    return LawyerSpecialization(
      id: id ?? this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      level: level ?? this.level,
      experience: experience ?? this.experience,
      successRate: successRate ?? this.successRate,
      baseCost: baseCost ?? this.baseCost,
      specialAbilities: specialAbilities ?? this.specialAbilities,
      caseTypeModifiers: caseTypeModifiers ?? this.caseTypeModifiers,
    );
  }
}

@immutable
class CourtCase {
  final String id;
  final String type; // 'drug_possession', 'trafficking', 'money_laundering', 'rico'
  final String severity; // 'misdemeanor', 'felony', 'federal'
  final List<String> charges;
  final Map<String, double> evidence;
  final String prosecutorName;
  final int prosecutorLevel;
  final String judgeName;
  final int judgeCorruption; // 0-100
  final DateTime trialDate;
  final String status; // 'pending', 'in_progress', 'completed'

  const CourtCase({
    required this.id,
    required this.type,
    required this.severity,
    required this.charges,
    required this.evidence,
    required this.prosecutorName,
    required this.prosecutorLevel,
    required this.judgeName,
    required this.judgeCorruption,
    required this.trialDate,
    required this.status,
  });

  CourtCase copyWith({
    String? id,
    String? type,
    String? severity,
    List<String>? charges,
    Map<String, double>? evidence,
    String? prosecutorName,
    int? prosecutorLevel,
    String? judgeName,
    int? judgeCorruption,
    DateTime? trialDate,
    String? status,
  }) {
    return CourtCase(
      id: id ?? this.id,
      type: type ?? this.type,
      severity: severity ?? this.severity,
      charges: charges ?? this.charges,
      evidence: evidence ?? this.evidence,
      prosecutorName: prosecutorName ?? this.prosecutorName,
      prosecutorLevel: prosecutorLevel ?? this.prosecutorLevel,
      judgeName: judgeName ?? this.judgeName,
      judgeCorruption: judgeCorruption ?? this.judgeCorruption,
      trialDate: trialDate ?? this.trialDate,
      status: status ?? this.status,
    );
  }

  double get evidenceStrength => evidence.values.fold(0.0, (a, b) => a + b) / evidence.length;
  int get maxSentence => charges.length * 10; // Simplified calculation
}

@immutable
class Witness {
  final String id;
  final String name;
  final String type; // 'informant', 'victim', 'expert', 'character'
  final int credibility; // 0-100
  final int reliability; // 0-100
  final List<String> testimony;
  final bool isProtected;
  final String protectionLevel; // 'none', 'local', 'federal', 'witness_protection'
  final Map<String, dynamic> leverage; // What you have on them
  final bool isHostile;

  const Witness({
    required this.id,
    required this.name,
    required this.type,
    required this.credibility,
    required this.reliability,
    required this.testimony,
    this.isProtected = false,
    this.protectionLevel = 'none',
    required this.leverage,
    this.isHostile = false,
  });

  Witness copyWith({
    String? id,
    String? name,
    String? type,
    int? credibility,
    int? reliability,
    List<String>? testimony,
    bool? isProtected,
    String? protectionLevel,
    Map<String, dynamic>? leverage,
    bool? isHostile,
  }) {
    return Witness(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      credibility: credibility ?? this.credibility,
      reliability: reliability ?? this.reliability,
      testimony: testimony ?? this.testimony,
      isProtected: isProtected ?? this.isProtected,
      protectionLevel: protectionLevel ?? this.protectionLevel,
      leverage: leverage ?? this.leverage,
      isHostile: isHostile ?? this.isHostile,
    );
  }
}

@immutable
class PrisonSystem {
  final String facilityId;
  final String name;
  final String securityLevel; // 'minimum', 'medium', 'maximum', 'supermax'
  final Map<String, int> gangs;
  final Map<String, int> allies;
  final Map<String, int> enemies;
  final double respect; // 0-100
  final double protection; // 0-100
  final List<String> availableActivities;
  final Map<String, int> resources;
  final bool hasOutsideConnections;

  const PrisonSystem({
    required this.facilityId,
    required this.name,
    required this.securityLevel,
    required this.gangs,
    required this.allies,
    required this.enemies,
    required this.respect,
    required this.protection,
    required this.availableActivities,
    required this.resources,
    this.hasOutsideConnections = false,
  });

  PrisonSystem copyWith({
    String? facilityId,
    String? name,
    String? securityLevel,
    Map<String, int>? gangs,
    Map<String, int>? allies,
    Map<String, int>? enemies,
    double? respect,
    double? protection,
    List<String>? availableActivities,
    Map<String, int>? resources,
    bool? hasOutsideConnections,
  }) {
    return PrisonSystem(
      facilityId: facilityId ?? this.facilityId,
      name: name ?? this.name,
      securityLevel: securityLevel ?? this.securityLevel,
      gangs: gangs ?? this.gangs,
      allies: allies ?? this.allies,
      enemies: enemies ?? this.enemies,
      respect: respect ?? this.respect,
      protection: protection ?? this.protection,
      availableActivities: availableActivities ?? this.availableActivities,
      resources: resources ?? this.resources,
      hasOutsideConnections: hasOutsideConnections ?? this.hasOutsideConnections,
    );
  }
}

@immutable
class ParoleStatus {
  final bool isEligible;
  final DateTime eligibilityDate;
  final DateTime hearingDate;
  final int goodBehaviorPoints;
  final int violationPoints;
  final List<String> conditions;
  final String paroleOfficer;
  final double successProbability;
  final Map<String, String> requirements;

  const ParoleStatus({
    required this.isEligible,
    required this.eligibilityDate,
    required this.hearingDate,
    required this.goodBehaviorPoints,
    required this.violationPoints,
    required this.conditions,
    required this.paroleOfficer,
    required this.successProbability,
    required this.requirements,
  });

  ParoleStatus copyWith({
    bool? isEligible,
    DateTime? eligibilityDate,
    DateTime? hearingDate,
    int? goodBehaviorPoints,
    int? violationPoints,
    List<String>? conditions,
    String? paroleOfficer,
    double? successProbability,
    Map<String, String>? requirements,
  }) {
    return ParoleStatus(
      isEligible: isEligible ?? this.isEligible,
      eligibilityDate: eligibilityDate ?? this.eligibilityDate,
      hearingDate: hearingDate ?? this.hearingDate,
      goodBehaviorPoints: goodBehaviorPoints ?? this.goodBehaviorPoints,
      violationPoints: violationPoints ?? this.violationPoints,
      conditions: conditions ?? this.conditions,
      paroleOfficer: paroleOfficer ?? this.paroleOfficer,
      successProbability: successProbability ?? this.successProbability,
      requirements: requirements ?? this.requirements,
    );
  }
}

@immutable
class LegalBusiness {
  final String id;
  final String name;
  final String type; // 'restaurant', 'car_wash', 'construction', 'import_export'
  final double legitimacy; // 0-100
  final double monthlyIncome;
  final double suspicionLevel;
  final List<String> licenses;
  final Map<String, String> inspectionHistory;
  final bool hasAudits;
  final DateTime lastInspection;

  const LegalBusiness({
    required this.id,
    required this.name,
    required this.type,
    required this.legitimacy,
    required this.monthlyIncome,
    required this.suspicionLevel,
    required this.licenses,
    required this.inspectionHistory,
    this.hasAudits = false,
    required this.lastInspection,
  });

  LegalBusiness copyWith({
    String? id,
    String? name,
    String? type,
    double? legitimacy,
    double? monthlyIncome,
    double? suspicionLevel,
    List<String>? licenses,
    Map<String, String>? inspectionHistory,
    bool? hasAudits,
    DateTime? lastInspection,
  }) {
    return LegalBusiness(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      legitimacy: legitimacy ?? this.legitimacy,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      suspicionLevel: suspicionLevel ?? this.suspicionLevel,
      licenses: licenses ?? this.licenses,
      inspectionHistory: inspectionHistory ?? this.inspectionHistory,
      hasAudits: hasAudits ?? this.hasAudits,
      lastInspection: lastInspection ?? this.lastInspection,
    );
  }
}

@immutable
class InternationalLaw {
  final String countryId;
  final Map<String, String> extraditionTreaties;
  final List<String> diplomaticImmunities;
  final Map<String, double> jurisdictionStrengths;
  final List<String> safeHavens;
  final Map<String, int> corruptionLevels;
  final List<String> internationalWarrants;

  const InternationalLaw({
    required this.countryId,
    required this.extraditionTreaties,
    required this.diplomaticImmunities,
    required this.jurisdictionStrengths,
    required this.safeHavens,
    required this.corruptionLevels,
    required this.internationalWarrants,
  });

  InternationalLaw copyWith({
    String? countryId,
    Map<String, String>? extraditionTreaties,
    List<String>? diplomaticImmunities,
    Map<String, double>? jurisdictionStrengths,
    List<String>? safeHavens,
    Map<String, int>? corruptionLevels,
    List<String>? internationalWarrants,
  }) {
    return InternationalLaw(
      countryId: countryId ?? this.countryId,
      extraditionTreaties: extraditionTreaties ?? this.extraditionTreaties,
      diplomaticImmunities: diplomaticImmunities ?? this.diplomaticImmunities,
      jurisdictionStrengths: jurisdictionStrengths ?? this.jurisdictionStrengths,
      safeHavens: safeHavens ?? this.safeHavens,
      corruptionLevels: corruptionLevels ?? this.corruptionLevels,
      internationalWarrants: internationalWarrants ?? this.internationalWarrants,
    );
  }
}
