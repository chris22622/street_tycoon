// Character Development System
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/character_development_models.dart';
import '../data/expanded_constants.dart';

class CharacterDevelopmentState {
  final Map<String, Skill> skills;
  final Map<String, Reputation> reputations;
  final Map<String, Relationship> relationships;
  final CharacterAge age;
  final List<FamilyMember> family;
  final List<Education> completedEducation;
  final HealthStatus health;
  final Map<String, LifestyleChoice> lifestyle;
  final int totalExperience;
  final int availableSkillPoints;

  const CharacterDevelopmentState({
    required this.skills,
    required this.reputations,
    required this.relationships,
    required this.age,
    required this.family,
    required this.completedEducation,
    required this.health,
    required this.lifestyle,
    this.totalExperience = 0,
    this.availableSkillPoints = 0,
  });

  CharacterDevelopmentState copyWith({
    Map<String, Skill>? skills,
    Map<String, Reputation>? reputations,
    Map<String, Relationship>? relationships,
    CharacterAge? age,
    List<FamilyMember>? family,
    List<Education>? completedEducation,
    HealthStatus? health,
    Map<String, LifestyleChoice>? lifestyle,
    int? totalExperience,
    int? availableSkillPoints,
  }) {
    return CharacterDevelopmentState(
      skills: skills ?? this.skills,
      reputations: reputations ?? this.reputations,
      relationships: relationships ?? this.relationships,
      age: age ?? this.age,
      family: family ?? this.family,
      completedEducation: completedEducation ?? this.completedEducation,
      health: health ?? this.health,
      lifestyle: lifestyle ?? this.lifestyle,
      totalExperience: totalExperience ?? this.totalExperience,
      availableSkillPoints: availableSkillPoints ?? this.availableSkillPoints,
    );
  }
}

class CharacterDevelopmentManager extends StateNotifier<CharacterDevelopmentState> {
  CharacterDevelopmentManager() : super(_createInitialState());

  static CharacterDevelopmentState _createInitialState() {
    return CharacterDevelopmentState(
      skills: _createInitialSkills(),
      reputations: _createInitialReputations(),
      relationships: {},
      age: const CharacterAge(
        years: 25,
        months: 0,
        ageGroup: 'young',
        physicalEffects: {'stamina': 1.0, 'health_regen': 1.0},
        mentalEffects: {'learning_speed': 1.2, 'stress_resistance': 0.8},
        availableActions: ['all'],
      ),
      family: [
        FamilyMember(
          id: 'mother',
          name: 'Maria Santos',
          relationship: 'parent',
          age: 52,
          traits: {'caring': 85, 'worried': 75, 'protective': 90},
          skills: ['cooking', 'family_advice', 'emotional_support'],
          location: 'hometown',
          memories: {
            'lastCall': 'last_week',
            'favoriteMemory': 'teaching_cooking',
            'concerns': 'your_safety'
          },
        ),
        FamilyMember(
          id: 'father',
          name: 'Roberto Santos',
          relationship: 'parent',
          age: 55,
          traits: {'hardworking': 90, 'strict': 70, 'proud': 80},
          skills: ['mechanical_work', 'life_advice', 'discipline'],
          location: 'hometown',
          memories: {
            'lastCall': 'last_month',
            'favoriteMemory': 'teaching_responsibility',
            'concerns': 'your_choices'
          },
        ),
        FamilyMember(
          id: 'sister',
          name: 'Sofia Santos',
          relationship: 'sibling',
          age: 22,
          traits: {'smart': 85, 'supportive': 80, 'ambitious': 75},
          skills: ['studying', 'technology', 'emotional_support'],
          location: 'college',
          memories: {
            'lastCall': 'yesterday',
            'favoriteMemory': 'growing_up_together',
            'concerns': 'missing_you'
          },
        ),
      ],
      completedEducation: [],
      health: const HealthStatus(
        physicalHealth: 100,
        mentalHealth: 100,
        addictions: {},
        injuries: [],
        conditions: [],
        treatmentProgress: {},
      ),
      lifestyle: {},
    );
  }

  static Map<String, Skill> _createInitialSkills() {
    final skills = <String, Skill>{};
    
    for (final category in SKILL_CATEGORIES) {
      final skillsInCategory = SKILLS_BY_CATEGORY[category] ?? [];
      for (final skillName in skillsInCategory) {
        skills[skillName] = Skill(
          id: skillName.toLowerCase().replaceAll(' ', '_'),
          name: skillName,
          category: category,
          description: 'Improve your $skillName abilities',
          level: 1,
          maxLevel: 10,
          experience: 0,
          experienceToNext: 100,
          prerequisites: [],
          effects: _getSkillEffects(skillName),
          iconPath: 'assets/icons/skills/${skillName.toLowerCase().replaceAll(' ', '_')}.png',
        );
      }
    }
    
    return skills;
  }

  static Map<String, double> _getSkillEffects(String skillName) {
    switch (skillName) {
      case 'Drug Manufacturing':
        return {'production_efficiency': 0.1, 'quality_bonus': 0.05};
      case 'Money Laundering':
        return {'laundering_efficiency': 0.15, 'suspicion_reduction': 0.1};
      case 'Market Analysis':
        return {'price_prediction_accuracy': 0.1, 'demand_forecast': 0.1};
      case 'Negotiation':
        return {'deal_success_rate': 0.1, 'price_improvement': 0.05};
      case 'Intimidation':
        return {'threat_effectiveness': 0.15, 'fear_generation': 0.1};
      case 'Reputation Management':
        return {'reputation_gain': 0.1, 'reputation_loss_reduction': 0.1};
      default:
        return {'general_effectiveness': 0.1};
    }
  }

  static Map<String, Reputation> _createInitialReputations() {
    return {
      'street': const Reputation(
        faction: 'Street',
        level: 0,
        points: 0,
        status: 'neutral',
        unlockableFeatures: ['street_deals', 'gang_connections'],
      ),
      'law_enforcement': const Reputation(
        faction: 'Law Enforcement',
        level: 0,
        points: 0,
        status: 'neutral',
        unlockableFeatures: [],
      ),
      'political': const Reputation(
        faction: 'Political',
        level: 0,
        points: 0,
        status: 'neutral',
        unlockableFeatures: ['corruption_opportunities', 'policy_influence'],
      ),
      'business': const Reputation(
        faction: 'Business',
        level: 0,
        points: 0,
        status: 'neutral',
        unlockableFeatures: ['investment_opportunities', 'legitimate_fronts'],
      ),
    };
  }

  void gainExperience(String skillName, int amount) {
    final skill = state.skills[skillName];
    if (skill == null || skill.level >= skill.maxLevel) return;

    final newExperience = skill.experience + amount;
    int newLevel = skill.level;
    int remainingExp = newExperience;
    int nextLevelExp = skill.experienceToNext;

    // Calculate level ups
    while (remainingExp >= nextLevelExp && newLevel < skill.maxLevel) {
      remainingExp -= nextLevelExp;
      newLevel++;
      nextLevelExp = _calculateExperienceForLevel(newLevel + 1);
    }

    final updatedSkill = skill.copyWith(
      level: newLevel,
      experience: remainingExp,
      experienceToNext: nextLevelExp - remainingExp,
    );

    state = state.copyWith(
      skills: {...state.skills, skillName: updatedSkill},
      totalExperience: state.totalExperience + amount,
      availableSkillPoints: state.availableSkillPoints + (newLevel - skill.level),
    );
  }

  int _calculateExperienceForLevel(int level) {
    return (100 * level * (level + 1) / 2).round();
  }

  void updateReputation(String faction, int points) {
    final reputation = state.reputations[faction];
    if (reputation == null) return;

    final newPoints = (reputation.points + points).clamp(-1000, 1000);
    final newLevel = (newPoints / 10).round().clamp(-100, 100);
    
    String newStatus;
    if (newLevel <= -50) {
      newStatus = 'enemy';
    } else if (newLevel <= -20) {
      newStatus = 'hostile';
    } else if (newLevel <= 20) {
      newStatus = 'neutral';
    } else if (newLevel <= 50) {
      newStatus = 'friendly';
    } else {
      newStatus = 'ally';
    }

    final updatedReputation = reputation.copyWith(
      level: newLevel,
      points: newPoints,
      status: newStatus,
    );

    state = state.copyWith(
      reputations: {...state.reputations, faction: updatedReputation},
    );
  }

  void addRelationship(Relationship relationship) {
    state = state.copyWith(
      relationships: {...state.relationships, relationship.characterId: relationship},
    );
  }

  void updateRelationship(String characterId, {
    int? affectionChange,
    int? trustChange,
    int? fearChange,
  }) {
    final relationship = state.relationships[characterId];
    if (relationship == null) return;

    final updatedRelationship = relationship.copyWith(
      affection: affectionChange != null 
          ? (relationship.affection + affectionChange).clamp(0, 100)
          : relationship.affection,
      trust: trustChange != null 
          ? (relationship.trust + trustChange).clamp(0, 100)
          : relationship.trust,
      fear: fearChange != null 
          ? (relationship.fear + fearChange).clamp(0, 100)
          : relationship.fear,
    );

    state = state.copyWith(
      relationships: {...state.relationships, characterId: updatedRelationship},
    );
  }

  void ageCharacter(int months) {
    final newMonths = state.age.months + months;
    final yearsToAdd = newMonths ~/ 12;
    final remainingMonths = newMonths % 12;
    
    final newAge = state.age.copyWith(
      years: state.age.years + yearsToAdd,
      months: remainingMonths,
      ageGroup: _determineAgeGroup(state.age.years + yearsToAdd),
    );

    state = state.copyWith(age: newAge);
  }

  String _determineAgeGroup(int years) {
    if (years < 30) return 'young';
    if (years < 50) return 'adult';
    if (years < 65) return 'middle-aged';
    return 'elderly';
  }

  void updateHealth({
    int? physicalChange,
    int? mentalChange,
    Map<String, int>? addictionChanges,
    List<String>? newInjuries,
    List<String>? removedInjuries,
  }) {
    final currentHealth = state.health;
    
    final newAddictions = Map<String, int>.from(currentHealth.addictions);
    addictionChanges?.forEach((substance, change) {
      newAddictions[substance] = (newAddictions[substance] ?? 0) + change;
      if (newAddictions[substance]! <= 0) {
        newAddictions.remove(substance);
      }
    });

    final newInjuriesList = List<String>.from(currentHealth.injuries);
    if (newInjuries != null) {
      newInjuriesList.addAll(newInjuries);
    }
    if (removedInjuries != null) {
      newInjuriesList.removeWhere((injury) => removedInjuries.contains(injury));
    }

    final updatedHealth = currentHealth.copyWith(
      physicalHealth: physicalChange != null 
          ? (currentHealth.physicalHealth + physicalChange).clamp(0, 100)
          : currentHealth.physicalHealth,
      mentalHealth: mentalChange != null 
          ? (currentHealth.mentalHealth + mentalChange).clamp(0, 100)
          : currentHealth.mentalHealth,
      addictions: newAddictions,
      injuries: newInjuriesList,
    );

    state = state.copyWith(health: updatedHealth);
  }

  double getSkillModifier(String skillName) {
    final skill = state.skills[skillName];
    if (skill == null) return 1.0;
    
    // Each skill level provides a 10% bonus
    return 1.0 + (skill.level - 1) * 0.1;
  }

  Map<String, double> getAllSkillModifiers() {
    final modifiers = <String, double>{};
    
    for (final skill in state.skills.values) {
      skill.effects.forEach((effectName, baseEffect) {
        final levelMultiplier = skill.level.toDouble();
        modifiers[effectName] = (modifiers[effectName] ?? 0.0) + (baseEffect * levelMultiplier);
      });
    }
    
    return modifiers;
  }

  // Improve relationship methods
  void improveRelationship(String type) {
    final relationships = Map<String, Relationship>.from(state.relationships);
    
    switch (type) {
      case 'familyTrust':
        relationships['family'] = (relationships['family'] ?? _createDefaultFamilyRelationship()).copyWith(
          trust: (relationships['family']?.trust ?? 50) + 8,
          affection: (relationships['family']?.affection ?? 50) + 5,
        );
        break;
      case 'crewLoyalty':
        relationships['crew'] = (relationships['crew'] ?? _createDefaultCrewRelationship()).copyWith(
          trust: (relationships['crew']?.trust ?? 30) + 6,
          affection: (relationships['crew']?.affection ?? 30) + 4,
        );
        break;
      case 'businessContacts':
        relationships['business'] = (relationships['business'] ?? _createDefaultBusinessRelationship()).copyWith(
          trust: (relationships['business']?.trust ?? 10) + 5,
          affection: (relationships['business']?.affection ?? 10) + 3,
        );
        break;
      case 'undergroundNetwork':
        relationships['underground'] = (relationships['underground'] ?? _createDefaultUndergroundRelationship()).copyWith(
          trust: (relationships['underground']?.trust ?? 20) + 4,
          fear: (relationships['underground']?.fear ?? 30) + 2,
        );
        break;
    }
    
    state = state.copyWith(relationships: relationships);
  }

  Relationship _createDefaultFamilyRelationship() {
    return const Relationship(
      characterId: 'family',
      name: 'Family',
      type: 'family',
      affection: 50,
      trust: 50,
      fear: 5,
      traits: ['caring', 'worried'],
      history: {'lastContact': 'recent'},
      location: 'hometown',
    );
  }

  Relationship _createDefaultCrewRelationship() {
    return const Relationship(
      characterId: 'crew',
      name: 'Crew',
      type: 'business',
      affection: 30,
      trust: 30,
      fear: 20,
      traits: ['loyal', 'streetwise'],
      history: {'formed': 'recently'},
      location: 'local',
    );
  }

  Relationship _createDefaultBusinessRelationship() {
    return const Relationship(
      characterId: 'business',
      name: 'Business Contacts',
      type: 'business',
      affection: 10,
      trust: 10,
      fear: 5,
      traits: ['professional', 'calculating'],
      history: {'meetings': 'few'},
      location: 'citywide',
    );
  }

  Relationship _createDefaultUndergroundRelationship() {
    return const Relationship(
      characterId: 'underground',
      name: 'Underground Network',
      type: 'ally',
      affection: 20,
      trust: 20,
      fear: 30,
      traits: ['dangerous', 'reliable'],
      history: {'dealings': 'occasional'},
      location: 'shadows',
    );
  }
}

final characterDevelopmentProvider = StateNotifierProvider<CharacterDevelopmentManager, CharacterDevelopmentState>((ref) {
  return CharacterDevelopmentManager();
});
