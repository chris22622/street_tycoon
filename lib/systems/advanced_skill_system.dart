import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

// Advanced Skill & Talent System
// Feature #15: Ultra-comprehensive character progression with skill trees,
// talents, specializations, mastery levels, and dynamic ability unlocks

enum SkillCategory {
  criminal,
  business,
  social,
  physical,
  mental,
  technical,
  survival,
  leadership
}

enum SkillType {
  // Criminal Skills
  lockpicking,
  hacking,
  stealing,
  drugKnowledge,
  weaponHandling,
  stealth,
  intimidation,
  smuggling,
  
  // Business Skills
  negotiation,
  accounting,
  marketing,
  investment,
  logistics,
  riskAssessment,
  economicAnalysis,
  projectManagement,
  
  // Social Skills
  persuasion,
  deception,
  networking,
  psychology,
  manipulation,
  charm,
  leadership,
  publicSpeaking,
  
  // Physical Skills
  strength,
  endurance,
  agility,
  reflexes,
  firearms,
  handToHand,
  driving,
  parkour,
  
  // Mental Skills
  intelligence,
  memory,
  creativity,
  problemSolving,
  strategicThinking,
  attention,
  mentalResilience,
  learning,
  
  // Technical Skills
  engineering,
  chemistry,
  electronics,
  programming,
  surveillance,
  forensics,
  communications,
  cybersecurity,
  
  // Survival Skills
  streetSmart,
  dangerSense,
  resourcefulness,
  adaptation,
  camouflage,
  tracking,
  firstAid,
  escapeArtist,
  
  // Leadership Skills
  commandPresence,
  teamBuilding,
  delegation,
  inspiration,
  decisionMaking,
  conflictResolution,
  organizationalSkills,
  strategicPlanning
}

enum TalentTier {
  basic,
  advanced,
  expert,
  master,
  legendary
}

enum SpecializationPath {
  drugDealer,
  enforcer,
  mastermind,
  techExpert,
  socialManipulator,
  businessTycoon,
  streetSurvivor,
  infiltrator
}

class Skill {
  final SkillType type;
  final SkillCategory category;
  final String name;
  final String description;
  final int level;
  final double experience;
  final double experienceToNext;
  final List<SkillType> prerequisites;
  final List<TalentType> unlockedTalents;
  final Map<String, dynamic> bonuses;

  Skill({
    required this.type,
    required this.category,
    required this.name,
    required this.description,
    this.level = 1,
    this.experience = 0.0,
    this.experienceToNext = 100.0,
    this.prerequisites = const [],
    this.unlockedTalents = const [],
    this.bonuses = const {},
  });

  Skill copyWith({
    SkillType? type,
    SkillCategory? category,
    String? name,
    String? description,
    int? level,
    double? experience,
    double? experienceToNext,
    List<SkillType>? prerequisites,
    List<TalentType>? unlockedTalents,
    Map<String, dynamic>? bonuses,
  }) {
    return Skill(
      type: type ?? this.type,
      category: category ?? this.category,
      name: name ?? this.name,
      description: description ?? this.description,
      level: level ?? this.level,
      experience: experience ?? this.experience,
      experienceToNext: experienceToNext ?? this.experienceToNext,
      prerequisites: prerequisites ?? this.prerequisites,
      unlockedTalents: unlockedTalents ?? this.unlockedTalents,
      bonuses: bonuses ?? this.bonuses,
    );
  }

  double get masteryPercentage => level >= 100 ? 1.0 : level / 100.0;
  bool get isMastered => level >= 100;
  bool get isLegendary => level >= 150;
}

enum TalentType {
  // Criminal Talents
  masterThief,
  drugChemist,
  assassin,
  smugglerKing,
  safecracker,
  ghostInMachine,
  
  // Business Talents
  moneyMagnet,
  dealMaker,
  marketManipulator,
  economicGenius,
  logisticsMaster,
  riskCalculator,
  
  // Social Talents
  silverTongue,
  mastermanipulator,
  networkBuilder,
  psychologist,
  charismaticLeader,
  doubleAgent,
  
  // Physical Talents
  ironBody,
  quickDraw,
  martialArtist,
  wheelman,
  freerunner,
  berserker,
  
  // Mental Talents
  photographic,
  strategicMind,
  problemSolver,
  creativitiyGenius,
  focusedMind,
  learningMachine,
  
  // Technical Talents
  techWizard,
  bombMaker,
  cyberWarrior,
  surveillance,
  communicator,
  forensicExpert,
  
  // Survival Talents
  streetWise,
  dangerSensor,
  resourceful,
  adaptable,
  invisible,
  escapist,
  
  // Leadership Talents
  bornLeader,
  teamMaster,
  inspirational,
  strategist,
  conflictResolver,
  organizationalGenius
}

class Talent {
  final TalentType type;
  final String name;
  final String description;
  final TalentTier tier;
  final List<SkillType> requiredSkills;
  final Map<SkillType, int> skillRequirements;
  final List<TalentType> prerequisites;
  final bool unlocked;
  final bool active;
  final Map<String, dynamic> effects;
  final double cooldown;
  final double cost;

  Talent({
    required this.type,
    required this.name,
    required this.description,
    required this.tier,
    this.requiredSkills = const [],
    this.skillRequirements = const {},
    this.prerequisites = const [],
    this.unlocked = false,
    this.active = false,
    this.effects = const {},
    this.cooldown = 0.0,
    this.cost = 0.0,
  });

  Talent copyWith({
    TalentType? type,
    String? name,
    String? description,
    TalentTier? tier,
    List<SkillType>? requiredSkills,
    Map<SkillType, int>? skillRequirements,
    List<TalentType>? prerequisites,
    bool? unlocked,
    bool? active,
    Map<String, dynamic>? effects,
    double? cooldown,
    double? cost,
  }) {
    return Talent(
      type: type ?? this.type,
      name: name ?? this.name,
      description: description ?? this.description,
      tier: tier ?? this.tier,
      requiredSkills: requiredSkills ?? this.requiredSkills,
      skillRequirements: skillRequirements ?? this.skillRequirements,
      prerequisites: prerequisites ?? this.prerequisites,
      unlocked: unlocked ?? this.unlocked,
      active: active ?? this.active,
      effects: effects ?? this.effects,
      cooldown: cooldown ?? this.cooldown,
      cost: cost ?? this.cost,
    );
  }
}

class Specialization {
  final SpecializationPath path;
  final String name;
  final String description;
  final int level;
  final double progress;
  final List<SkillType> focusSkills;
  final List<TalentType> specialTalents;
  final Map<String, dynamic> bonuses;
  final bool unlocked;

  Specialization({
    required this.path,
    required this.name,
    required this.description,
    this.level = 0,
    this.progress = 0.0,
    this.focusSkills = const [],
    this.specialTalents = const [],
    this.bonuses = const {},
    this.unlocked = false,
  });

  Specialization copyWith({
    SpecializationPath? path,
    String? name,
    String? description,
    int? level,
    double? progress,
    List<SkillType>? focusSkills,
    List<TalentType>? specialTalents,
    Map<String, dynamic>? bonuses,
    bool? unlocked,
  }) {
    return Specialization(
      path: path ?? this.path,
      name: name ?? this.name,
      description: description ?? this.description,
      level: level ?? this.level,
      progress: progress ?? this.progress,
      focusSkills: focusSkills ?? this.focusSkills,
      specialTalents: specialTalents ?? this.specialTalents,
      bonuses: bonuses ?? this.bonuses,
      unlocked: unlocked ?? this.unlocked,
    );
  }
}

class SkillBonus {
  final String name;
  final String description;
  final double multiplier;
  final double flatBonus;
  final Duration duration;
  final DateTime? expiresAt;
  final Map<String, dynamic> conditions;

  SkillBonus({
    required this.name,
    required this.description,
    this.multiplier = 1.0,
    this.flatBonus = 0.0,
    required this.duration,
    this.expiresAt,
    this.conditions = const {},
  });

  bool get isActive => expiresAt == null || DateTime.now().isBefore(expiresAt!);
  bool get isExpired => !isActive;
}

class AdvancedSkillSystem extends ChangeNotifier {
  static final AdvancedSkillSystem _instance = AdvancedSkillSystem._internal();
  factory AdvancedSkillSystem() => _instance;
  AdvancedSkillSystem._internal() {
    _initializeSystem();
  }

  final Map<SkillType, Skill> _skills = {};
  final Map<TalentType, Talent> _talents = {};
  final Map<SpecializationPath, Specialization> _specializations = {};
  final Map<String, SkillBonus> _activeBonuses = {};
  
  int _skillPoints = 0;
  int _talentPoints = 0;
  int _totalExperience = 0;
  double _learningMultiplier = 1.0;
  
  Timer? _systemTimer;
  final math.Random _random = math.Random();

  // Getters
  Map<SkillType, Skill> get skills => Map.unmodifiable(_skills);
  Map<TalentType, Talent> get talents => Map.unmodifiable(_talents);
  Map<SpecializationPath, Specialization> get specializations => Map.unmodifiable(_specializations);
  Map<String, SkillBonus> get activeBonuses => Map.unmodifiable(_activeBonuses);
  int get skillPoints => _skillPoints;
  int get talentPoints => _talentPoints;
  int get totalExperience => _totalExperience;
  double get learningMultiplier => _learningMultiplier;

  void _initializeSystem() {
    _initializeSkills();
    _initializeTalents();
    _initializeSpecializations();
    _startSystemTimer();
  }

  void _initializeSkills() {
    final skillDefinitions = _getSkillDefinitions();
    
    for (final definition in skillDefinitions) {
      _skills[definition.type] = definition;
    }
  }

  List<Skill> _getSkillDefinitions() {
    return [
      // Criminal Skills
      Skill(
        type: SkillType.lockpicking,
        category: SkillCategory.criminal,
        name: 'Lockpicking',
        description: 'Ability to open locks without keys',
        bonuses: {'lockpickSpeed': 1.0, 'lockpickSuccess': 0.5},
      ),
      Skill(
        type: SkillType.hacking,
        category: SkillCategory.criminal,
        name: 'Hacking',
        description: 'Computer and digital system infiltration',
        prerequisites: [SkillType.programming],
        bonuses: {'hackSpeed': 1.0, 'hackSuccess': 0.5},
      ),
      Skill(
        type: SkillType.stealing,
        category: SkillCategory.criminal,
        name: 'Stealing',
        description: 'Pickpocketing and theft techniques',
        bonuses: {'stealSuccess': 0.5, 'detectionAvoidance': 0.3},
      ),
      Skill(
        type: SkillType.drugKnowledge,
        category: SkillCategory.criminal,
        name: 'Drug Knowledge',
        description: 'Understanding of drug chemistry and effects',
        prerequisites: [SkillType.chemistry],
        bonuses: {'drugQuality': 0.5, 'drugYield': 0.3},
      ),
      Skill(
        type: SkillType.weaponHandling,
        category: SkillCategory.criminal,
        name: 'Weapon Handling',
        description: 'Proficiency with various weapons',
        bonuses: {'weaponAccuracy': 0.5, 'weaponDamage': 0.3},
      ),
      Skill(
        type: SkillType.stealth,
        category: SkillCategory.criminal,
        name: 'Stealth',
        description: 'Moving undetected and avoiding notice',
        bonuses: {'detectionReduction': 0.5, 'sneakSpeed': 0.3},
      ),
      
      // Business Skills
      Skill(
        type: SkillType.negotiation,
        category: SkillCategory.business,
        name: 'Negotiation',
        description: 'Getting better deals and terms',
        bonuses: {'dealSuccess': 0.5, 'priceImprovement': 0.2},
      ),
      Skill(
        type: SkillType.accounting,
        category: SkillCategory.business,
        name: 'Accounting',
        description: 'Financial management and record keeping',
        bonuses: {'moneyEfficiency': 0.3, 'taxAvoidance': 0.2},
      ),
      Skill(
        type: SkillType.marketing,
        category: SkillCategory.business,
        name: 'Marketing',
        description: 'Promoting products and services',
        bonuses: {'customerAttraction': 0.5, 'salesBonus': 0.3},
      ),
      Skill(
        type: SkillType.investment,
        category: SkillCategory.business,
        name: 'Investment',
        description: 'Making money work for you',
        bonuses: {'investmentReturns': 0.3, 'riskReduction': 0.2},
      ),
      
      // Social Skills
      Skill(
        type: SkillType.persuasion,
        category: SkillCategory.social,
        name: 'Persuasion',
        description: 'Convincing others to do what you want',
        bonuses: {'persuasionSuccess': 0.5, 'socialInfluence': 0.3},
      ),
      Skill(
        type: SkillType.deception,
        category: SkillCategory.social,
        name: 'Deception',
        description: 'Lying and misdirection effectively',
        bonuses: {'lieSuccess': 0.5, 'suspicionReduction': 0.3},
      ),
      Skill(
        type: SkillType.networking,
        category: SkillCategory.social,
        name: 'Networking',
        description: 'Building and maintaining connections',
        bonuses: {'contactGeneration': 0.5, 'favorAccess': 0.3},
      ),
      
      // Physical Skills
      Skill(
        type: SkillType.strength,
        category: SkillCategory.physical,
        name: 'Strength',
        description: 'Physical power and muscle',
        bonuses: {'carryCapacity': 0.5, 'meleeDamage': 0.3},
      ),
      Skill(
        type: SkillType.endurance,
        category: SkillCategory.physical,
        name: 'Endurance',
        description: 'Stamina and staying power',
        bonuses: {'staminaRegen': 0.5, 'fatigueResistance': 0.3},
      ),
      Skill(
        type: SkillType.agility,
        category: SkillCategory.physical,
        name: 'Agility',
        description: 'Speed and dexterity',
        bonuses: {'moveSpeed': 0.3, 'dodgeChance': 0.2},
      ),
      
      // Mental Skills
      Skill(
        type: SkillType.intelligence,
        category: SkillCategory.mental,
        name: 'Intelligence',
        description: 'Raw cognitive ability',
        bonuses: {'learningSpeed': 0.5, 'problemSolving': 0.3},
      ),
      Skill(
        type: SkillType.memory,
        category: SkillCategory.mental,
        name: 'Memory',
        description: 'Retention and recall of information',
        bonuses: {'informationRetention': 0.5, 'detailRecall': 0.3},
      ),
      
      // Technical Skills
      Skill(
        type: SkillType.programming,
        category: SkillCategory.technical,
        name: 'Programming',
        description: 'Computer programming and scripting',
        bonuses: {'softwareDevelopment': 0.5, 'automationEfficiency': 0.3},
      ),
      Skill(
        type: SkillType.chemistry,
        category: SkillCategory.technical,
        name: 'Chemistry',
        description: 'Understanding chemical processes',
        bonuses: {'chemicalEfficiency': 0.5, 'synthesisSpeed': 0.3},
      ),
      Skill(
        type: SkillType.electronics,
        category: SkillCategory.technical,
        name: 'Electronics',
        description: 'Electronic device manipulation',
        bonuses: {'deviceModification': 0.5, 'repairSpeed': 0.3},
      ),
      
      // Survival Skills
      Skill(
        type: SkillType.streetSmart,
        category: SkillCategory.survival,
        name: 'Street Smart',
        description: 'Urban survival knowledge',
        bonuses: {'dangerAvoidance': 0.5, 'opportunityRecognition': 0.3},
      ),
      Skill(
        type: SkillType.dangerSense,
        category: SkillCategory.survival,
        name: 'Danger Sense',
        description: 'Intuitive threat detection',
        bonuses: {'threatDetection': 0.5, 'ambushAvoidance': 0.3},
      ),
      
      // Leadership Skills
      Skill(
        type: SkillType.leadership,
        category: SkillCategory.leadership,
        name: 'Leadership',
        description: 'Inspiring and directing others',
        bonuses: {'teamEfficiency': 0.5, 'loyaltyIncrease': 0.3},
      ),
      Skill(
        type: SkillType.strategicThinking,
        category: SkillCategory.mental,
        name: 'Strategic Thinking',
        description: 'Long-term planning and analysis',
        bonuses: {'planningEfficiency': 0.5, 'riskAssessment': 0.3},
      ),
    ];
  }

  void _initializeTalents() {
    final talentDefinitions = _getTalentDefinitions();
    
    for (final definition in talentDefinitions) {
      _talents[definition.type] = definition;
    }
  }

  List<Talent> _getTalentDefinitions() {
    return [
      // Criminal Talents
      Talent(
        type: TalentType.masterThief,
        name: 'Master Thief',
        description: 'Legendary theft abilities',
        tier: TalentTier.master,
        skillRequirements: {
          SkillType.stealing: 75,
          SkillType.lockpicking: 50,
          SkillType.stealth: 60,
        },
        effects: {
          'stealSuccessBonus': 0.5,
          'lockpickSpeedBonus': 0.3,
          'detectionReduction': 0.4,
        },
      ),
      Talent(
        type: TalentType.drugChemist,
        name: 'Drug Chemist',
        description: 'Expert in drug synthesis',
        tier: TalentTier.expert,
        skillRequirements: {
          SkillType.drugKnowledge: 80,
          SkillType.chemistry: 70,
        },
        effects: {
          'drugQualityBonus': 0.6,
          'drugYieldBonus': 0.4,
          'synthesisSpeedBonus': 0.3,
        },
      ),
      Talent(
        type: TalentType.assassin,
        name: 'Assassin',
        description: 'Professional killer',
        tier: TalentTier.master,
        skillRequirements: {
          SkillType.weaponHandling: 85,
          SkillType.stealth: 80,
          SkillType.strategicThinking: 60,
        },
        effects: {
          'criticalHitChance': 0.5,
          'stealthKillBonus': 0.8,
          'weaponDamageBonus': 0.4,
        },
      ),
      
      // Business Talents
      Talent(
        type: TalentType.moneyMagnet,
        name: 'Money Magnet',
        description: 'Attracts wealth naturally',
        tier: TalentTier.advanced,
        skillRequirements: {
          SkillType.investment: 60,
          SkillType.accounting: 50,
          SkillType.negotiation: 40,
        },
        effects: {
          'incomeBonus': 0.3,
          'investmentReturnsBonus': 0.2,
          'dealProfitBonus': 0.25,
        },
      ),
      Talent(
        type: TalentType.dealMaker,
        name: 'Deal Maker',
        description: 'Exceptional negotiation skills',
        tier: TalentTier.expert,
        skillRequirements: {
          SkillType.negotiation: 80,
          SkillType.persuasion: 70,
          SkillType.psychology: 60,
        },
        effects: {
          'negotiationSuccessBonus': 0.4,
          'dealValueBonus': 0.3,
          'relationshipBonus': 0.2,
        },
      ),
      
      // Social Talents
      Talent(
        type: TalentType.silverTongue,
        name: 'Silver Tongue',
        description: 'Master of persuasion',
        tier: TalentTier.expert,
        skillRequirements: {
          SkillType.persuasion: 75,
          SkillType.deception: 60,
          SkillType.charm: 65,
        },
        effects: {
          'persuasionPowerBonus': 0.5,
          'lieDetectionImmunity': 0.3,
          'socialInfluenceBonus': 0.4,
        },
      ),
      
      // Physical Talents
      Talent(
        type: TalentType.ironBody,
        name: 'Iron Body',
        description: 'Exceptional physical resilience',
        tier: TalentTier.advanced,
        skillRequirements: {
          SkillType.strength: 70,
          SkillType.endurance: 75,
        },
        effects: {
          'damageReduction': 0.3,
          'staminaCostReduction': 0.2,
          'recoverySpeedBonus': 0.4,
        },
      ),
      
      // Mental Talents
      Talent(
        type: TalentType.photographic,
        name: 'Photographic Memory',
        description: 'Perfect recall of information',
        tier: TalentTier.legendary,
        skillRequirements: {
          SkillType.memory: 90,
          SkillType.intelligence: 80,
        },
        effects: {
          'perfectRecall': 1.0,
          'learningSpeedBonus': 0.5,
          'informationRetentionBonus': 1.0,
        },
      ),
      
      // Technical Talents
      Talent(
        type: TalentType.techWizard,
        name: 'Tech Wizard',
        description: 'Master of all technology',
        tier: TalentTier.master,
        skillRequirements: {
          SkillType.programming: 80,
          SkillType.electronics: 75,
          SkillType.hacking: 70,
        },
        effects: {
          'techEfficiencyBonus': 0.5,
          'hackingSpeedBonus': 0.4,
          'deviceControlBonus': 0.6,
        },
      ),
      
      // Leadership Talents
      Talent(
        type: TalentType.bornLeader,
        name: 'Born Leader',
        description: 'Natural leadership abilities',
        tier: TalentTier.master,
        skillRequirements: {
          SkillType.leadership: 85,
          SkillType.strategicThinking: 75,
          SkillType.inspiration: 70,
        },
        effects: {
          'teamEfficiencyBonus': 0.6,
          'loyaltyGenerationBonus': 0.5,
          'organizationalBonus': 0.4,
        },
      ),
    ];
  }

  void _initializeSpecializations() {
    final specializationDefinitions = _getSpecializationDefinitions();
    
    for (final definition in specializationDefinitions) {
      _specializations[definition.path] = definition;
    }
  }

  List<Specialization> _getSpecializationDefinitions() {
    return [
      Specialization(
        path: SpecializationPath.drugDealer,
        name: 'Drug Dealer',
        description: 'Master of the drug trade',
        focusSkills: [
          SkillType.drugKnowledge,
          SkillType.chemistry,
          SkillType.negotiation,
          SkillType.streetSmart,
        ],
        specialTalents: [
          TalentType.drugChemist,
          TalentType.dealMaker,
          TalentType.networkBuilder,
        ],
        bonuses: {
          'drugProfitBonus': 0.5,
          'drugQualityBonus': 0.3,
          'customerLoyaltyBonus': 0.4,
        },
      ),
      Specialization(
        path: SpecializationPath.enforcer,
        name: 'Enforcer',
        description: 'Muscle and intimidation specialist',
        focusSkills: [
          SkillType.weaponHandling,
          SkillType.strength,
          SkillType.intimidation,
          SkillType.handToHand,
        ],
        specialTalents: [
          TalentType.ironBody,
          TalentType.berserker,
          TalentType.martialArtist,
        ],
        bonuses: {
          'combatEfficiencyBonus': 0.5,
          'intimidationBonus': 0.6,
          'damageBonus': 0.4,
        },
      ),
      Specialization(
        path: SpecializationPath.mastermind,
        name: 'Mastermind',
        description: 'Strategic genius and planner',
        focusSkills: [
          SkillType.strategicThinking,
          SkillType.intelligence,
          SkillType.leadership,
          SkillType.psychology,
        ],
        specialTalents: [
          TalentType.strategicMind,
          TalentType.bornLeader,
          TalentType.mastermanipulator,
        ],
        bonuses: {
          'planningEfficiencyBonus': 0.6,
          'operationSuccessBonus': 0.4,
          'teamCoordinationBonus': 0.5,
        },
      ),
      Specialization(
        path: SpecializationPath.techExpert,
        name: 'Tech Expert',
        description: 'Technology and hacking specialist',
        focusSkills: [
          SkillType.hacking,
          SkillType.programming,
          SkillType.electronics,
          SkillType.cybersecurity,
        ],
        specialTalents: [
          TalentType.techWizard,
          TalentType.cyberWarrior,
          TalentType.ghostInMachine,
        ],
        bonuses: {
          'hackingEfficiencyBonus': 0.5,
          'techUpgradeBonus': 0.4,
          'digitalSecurityBonus': 0.6,
        },
      ),
      Specialization(
        path: SpecializationPath.socialManipulator,
        name: 'Social Manipulator',
        description: 'Master of human psychology',
        focusSkills: [
          SkillType.persuasion,
          SkillType.deception,
          SkillType.psychology,
          SkillType.networking,
        ],
        specialTalents: [
          TalentType.silverTongue,
          TalentType.mastermanipulator,
          TalentType.doubleAgent,
        ],
        bonuses: {
          'socialInfluenceBonus': 0.6,
          'manipulationSuccessBonus': 0.5,
          'networkEfficiencyBonus': 0.4,
        },
      ),
      Specialization(
        path: SpecializationPath.businessTycoon,
        name: 'Business Tycoon',
        description: 'Legitimate business empire builder',
        focusSkills: [
          SkillType.investment,
          SkillType.accounting,
          SkillType.marketing,
          SkillType.projectManagement,
        ],
        specialTalents: [
          TalentType.moneyMagnet,
          TalentType.economicGenius,
          TalentType.marketManipulator,
        ],
        bonuses: {
          'businessProfitBonus': 0.5,
          'investmentReturnsBonus': 0.4,
          'marketInfluenceBonus': 0.6,
        },
      ),
      Specialization(
        path: SpecializationPath.streetSurvivor,
        name: 'Street Survivor',
        description: 'Urban survival specialist',
        focusSkills: [
          SkillType.streetSmart,
          SkillType.dangerSense,
          SkillType.resourcefulness,
          SkillType.adaptation,
        ],
        specialTalents: [
          TalentType.streetWise,
          TalentType.dangerSensor,
          TalentType.resourceful,
        ],
        bonuses: {
          'survivalBonus': 0.6,
          'threatAvoidanceBonus': 0.5,
          'resourceEfficiencyBonus': 0.4,
        },
      ),
      Specialization(
        path: SpecializationPath.infiltrator,
        name: 'Infiltrator',
        description: 'Stealth and espionage expert',
        focusSkills: [
          SkillType.stealth,
          SkillType.lockpicking,
          SkillType.hacking,
          SkillType.surveillance,
        ],
        specialTalents: [
          TalentType.invisible,
          TalentType.masterThief,
          TalentType.ghostInMachine,
        ],
        bonuses: {
          'infiltrationSuccessBonus': 0.6,
          'stealthEfficiencyBonus': 0.5,
          'informationGatheringBonus': 0.4,
        },
      ),
    ];
  }

  void _startSystemTimer() {
    _systemTimer?.cancel();
    _systemTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _processPassiveGains();
      _updateBonuses();
      _checkUnlocks();
      notifyListeners();
    });
  }

  // Experience and Leveling
  void gainExperience(SkillType skillType, double amount) {
    final skill = _skills[skillType];
    if (skill == null) return;
    
    final adjustedAmount = amount * _learningMultiplier * _getSkillMultiplier(skillType);
    final newExperience = skill.experience + adjustedAmount;
    final newLevel = _calculateLevel(newExperience);
    
    if (newLevel > skill.level) {
      _skillPoints += (newLevel - skill.level);
      _checkSkillUnlocks(skillType, newLevel);
    }
    
    _skills[skillType] = skill.copyWith(
      experience: newExperience,
      level: newLevel,
      experienceToNext: _calculateExperienceToNext(newLevel),
    );
    
    _totalExperience += adjustedAmount.round();
    
    // Progress specializations
    _updateSpecializationProgress(skillType, adjustedAmount);
    
    notifyListeners();
  }

  int _calculateLevel(double experience) {
    // Exponential scaling: each level requires more experience
    return (math.log(experience / 100 + 1) / math.log(1.1)).floor() + 1;
  }

  double _calculateExperienceToNext(int level) {
    return (100 * (math.pow(1.1, level) - math.pow(1.1, level - 1))).toDouble();
  }

  double _getSkillMultiplier(SkillType skillType) {
    double multiplier = 1.0;
    
    // Apply talent bonuses
    for (final talent in _talents.values) {
      if (talent.active && talent.effects.containsKey('learningSpeedBonus')) {
        multiplier += talent.effects['learningSpeedBonus'] as double;
      }
    }
    
    // Apply specialization bonuses
    for (final specialization in _specializations.values) {
      if (specialization.unlocked && specialization.focusSkills.contains(skillType)) {
        multiplier += 0.2 * specialization.level;
      }
    }
    
    // Apply active bonuses
    for (final bonus in _activeBonuses.values) {
      if (bonus.isActive) {
        multiplier += bonus.multiplier - 1.0;
      }
    }
    
    return multiplier;
  }

  void _checkSkillUnlocks(SkillType skillType, int newLevel) {
    // Check if any talents can be unlocked
    for (final talentType in _talents.keys) {
      final talent = _talents[talentType]!;
      if (!talent.unlocked && _canUnlockTalent(talent)) {
        _talents[talentType] = talent.copyWith(unlocked: true);
      }
    }
    
    // Check if any specializations can be unlocked
    for (final specializationPath in _specializations.keys) {
      final specialization = _specializations[specializationPath]!;
      if (!specialization.unlocked && _canUnlockSpecialization(specialization)) {
        _specializations[specializationPath] = specialization.copyWith(unlocked: true);
      }
    }
  }

  bool _canUnlockTalent(Talent talent) {
    // Check skill requirements
    for (final entry in talent.skillRequirements.entries) {
      final skill = _skills[entry.key];
      if (skill == null || skill.level < entry.value) {
        return false;
      }
    }
    
    // Check prerequisite talents
    for (final prerequisite in talent.prerequisites) {
      final prereqTalent = _talents[prerequisite];
      if (prereqTalent == null || !prereqTalent.unlocked) {
        return false;
      }
    }
    
    return true;
  }

  bool _canUnlockSpecialization(Specialization specialization) {
    // Require at least 25 levels in focus skills
    int totalFocusLevels = 0;
    for (final skillType in specialization.focusSkills) {
      final skill = _skills[skillType];
      if (skill != null) {
        totalFocusLevels += skill.level;
      }
    }
    
    return totalFocusLevels >= 25;
  }

  void _updateSpecializationProgress(SkillType skillType, double experience) {
    for (final specializationPath in _specializations.keys) {
      final specialization = _specializations[specializationPath]!;
      
      if (specialization.unlocked && specialization.focusSkills.contains(skillType)) {
        final progressGain = experience * 0.1; // 10% of skill experience
        final newProgress = specialization.progress + progressGain;
        final newLevel = (newProgress / 1000).floor(); // 1000 progress per level
        
        _specializations[specializationPath] = specialization.copyWith(
          progress: newProgress,
          level: newLevel,
        );
      }
    }
  }

  // Talent Management
  bool unlockTalent(TalentType talentType) {
    final talent = _talents[talentType];
    if (talent == null || !talent.unlocked || _talentPoints < _getTalentCost(talent)) {
      return false;
    }
    
    _talentPoints -= _getTalentCost(talent);
    _talents[talentType] = talent.copyWith(active: true);
    
    notifyListeners();
    return true;
  }

  int _getTalentCost(Talent talent) {
    switch (talent.tier) {
      case TalentTier.basic:
        return 1;
      case TalentTier.advanced:
        return 2;
      case TalentTier.expert:
        return 3;
      case TalentTier.master:
        return 5;
      case TalentTier.legendary:
        return 8;
    }
  }

  void _processPassiveGains() {
    // Passive skill gains from active talents and specializations
    for (final skillType in _skills.keys) {
      double passiveGain = 0.0;
      
      // Talent passive gains
      for (final talent in _talents.values) {
        if (talent.active && talent.effects.containsKey('passiveGain_${skillType.name}')) {
          passiveGain += talent.effects['passiveGain_${skillType.name}'] as double;
        }
      }
      
      if (passiveGain > 0) {
        gainExperience(skillType, passiveGain);
      }
    }
    
    // Generate talent points
    if (_random.nextDouble() < 0.1) {
      _talentPoints++;
    }
    
    // Generate skill points occasionally
    if (_random.nextDouble() < 0.05) {
      _skillPoints++;
    }
  }

  void _updateBonuses() {
    // Remove expired bonuses
    final expiredBonuses = _activeBonuses.entries
        .where((entry) => entry.value.isExpired)
        .map((entry) => entry.key)
        .toList();
    
    for (final bonusId in expiredBonuses) {
      _activeBonuses.remove(bonusId);
    }
  }

  void _checkUnlocks() {
    // Check for new talent unlocks based on current skills
    for (final talentType in _talents.keys) {
      final talent = _talents[talentType]!;
      if (!talent.unlocked && _canUnlockTalent(talent)) {
        _talents[talentType] = talent.copyWith(unlocked: true);
      }
    }
  }

  // Bonus Management
  void addSkillBonus(String id, SkillBonus bonus) {
    _activeBonuses[id] = bonus;
    notifyListeners();
  }

  void removeSkillBonus(String id) {
    _activeBonuses.remove(id);
    notifyListeners();
  }

  // Utility Methods
  double getSkillBonus(SkillType skillType, String bonusType) {
    final skill = _skills[skillType];
    if (skill == null) return 0.0;
    
    double bonus = skill.bonuses[bonusType]?.toDouble() ?? 0.0;
    
    // Apply level scaling
    bonus *= (1.0 + skill.level * 0.01);
    
    // Apply talent bonuses
    for (final talent in _talents.values) {
      if (talent.active && talent.effects.containsKey('${bonusType}Bonus')) {
        bonus += talent.effects['${bonusType}Bonus'] as double;
      }
    }
    
    // Apply specialization bonuses
    for (final specialization in _specializations.values) {
      if (specialization.unlocked && 
          specialization.focusSkills.contains(skillType) &&
          specialization.bonuses.containsKey('${bonusType}Bonus')) {
        bonus += (specialization.bonuses['${bonusType}Bonus'] as double) * specialization.level;
      }
    }
    
    return bonus;
  }

  List<Skill> getSkillsByCategory(SkillCategory category) {
    return _skills.values
        .where((skill) => skill.category == category)
        .toList()
        ..sort((a, b) => b.level.compareTo(a.level));
  }

  List<Talent> getAvailableTalents() {
    return _talents.values
        .where((talent) => talent.unlocked && !talent.active)
        .toList()
        ..sort((a, b) => _getTalentCost(a).compareTo(_getTalentCost(b)));
  }

  List<Specialization> getUnlockedSpecializations() {
    return _specializations.values
        .where((spec) => spec.unlocked)
        .toList()
        ..sort((a, b) => b.level.compareTo(a.level));
  }

  int getTotalSkillLevels() {
    return _skills.values.map((skill) => skill.level).fold(0, (a, b) => a + b);
  }

  double getOverallMastery() {
    if (_skills.isEmpty) return 0.0;
    
    final totalMastery = _skills.values
        .map((skill) => skill.masteryPercentage)
        .fold(0.0, (a, b) => a + b);
    
    return totalMastery / _skills.length;
  }

  void dispose() {
    _systemTimer?.cancel();
    super.dispose();
  }
}

// Advanced Skill Tree Widget
class AdvancedSkillTreeWidget extends StatefulWidget {
  const AdvancedSkillTreeWidget({super.key});

  @override
  State<AdvancedSkillTreeWidget> createState() => _AdvancedSkillTreeWidgetState();
}

class _AdvancedSkillTreeWidgetState extends State<AdvancedSkillTreeWidget> 
    with TickerProviderStateMixin {
  final AdvancedSkillSystem _skillSystem = AdvancedSkillSystem();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: SkillCategory.values.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _skillSystem,
      builder: (context, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
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
        const Text(
          'Advanced Skill System',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        _buildResourceDisplay(),
      ],
    );
  }

  Widget _buildResourceDisplay() {
    return Row(
      children: [
        _buildResourceChip('SP', _skillSystem.skillPoints, Icons.star),
        const SizedBox(width: 8),
        _buildResourceChip('TP', _skillSystem.talentPoints, Icons.diamond),
      ],
    );
  }

  Widget _buildResourceChip(String label, int value, IconData icon) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text('$label: $value'),
      backgroundColor: Colors.blue[100],
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      tabs: SkillCategory.values.map((category) {
        return Tab(
          text: _getCategoryName(category),
          icon: Icon(_getCategoryIcon(category)),
        );
      }).toList(),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: SkillCategory.values.map((category) {
        return _buildCategoryView(category);
      }).toList(),
    );
  }

  Widget _buildCategoryView(SkillCategory category) {
    final skills = _skillSystem.getSkillsByCategory(category);
    
    return Column(
      children: [
        _buildCategoryStats(category, skills),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: skills.length,
            itemBuilder: (context, index) {
              return _buildSkillTile(skills[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryStats(SkillCategory category, List<Skill> skills) {
    final totalLevels = skills.fold(0, (sum, skill) => sum + skill.level);
    final avgMastery = skills.isEmpty ? 0.0 : 
        skills.map((s) => s.masteryPercentage).reduce((a, b) => a + b) / skills.length;
    
    return Card(
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatColumn('Skills', '${skills.length}'),
            _buildStatColumn('Total Levels', '$totalLevels'),
            _buildStatColumn('Avg Mastery', '${(avgMastery * 100).toInt()}%'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSkillTile(Skill skill) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getSkillColor(skill),
          child: Text('${skill.level}'),
        ),
        title: Text(skill.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(skill.description),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: skill.experience / (skill.experience + skill.experienceToNext),
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(_getSkillColor(skill)),
            ),
          ],
        ),
        trailing: _buildSkillActions(skill),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildSkillActions(Skill skill) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (skill.isMastered)
          Icon(Icons.star, color: Colors.amber)
        else if (skill.isLegendary)
          const Icon(Icons.diamond, color: Colors.purple),
        Text('${skill.experience.toInt()} XP'),
      ],
    );
  }

  Color _getSkillColor(Skill skill) {
    if (skill.isLegendary) return Colors.purple;
    if (skill.isMastered) return Colors.amber;
    if (skill.level >= 75) return Colors.orange;
    if (skill.level >= 50) return Colors.blue;
    if (skill.level >= 25) return Colors.green;
    return Colors.grey;
  }

  String _getCategoryName(SkillCategory category) {
    return category.name.split('').map((c) => 
      c == c.toUpperCase() && category.name.indexOf(c) > 0 ? ' $c' : c
    ).join('').split(' ').map((word) => 
      word[0].toUpperCase() + word.substring(1)
    ).join(' ');
  }

  IconData _getCategoryIcon(SkillCategory category) {
    switch (category) {
      case SkillCategory.criminal:
        return Icons.security;
      case SkillCategory.business:
        return Icons.business;
      case SkillCategory.social:
        return Icons.people;
      case SkillCategory.physical:
        return Icons.fitness_center;
      case SkillCategory.mental:
        return Icons.psychology;
      case SkillCategory.technical:
        return Icons.computer;
      case SkillCategory.survival:
        return Icons.terrain;
      case SkillCategory.leadership:
        return Icons.person;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
