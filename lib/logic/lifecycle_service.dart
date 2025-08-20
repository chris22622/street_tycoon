import 'dart:math';

class DeathCause {
  final String id;
  final String name;
  final String description;
  final String icon;
  final int probability;
  final Map<String, dynamic> triggers;
  final bool isPreventable;

  const DeathCause({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.probability,
    required this.triggers,
    required this.isPreventable,
  });
}

class LifeEvent {
  final String id;
  final String title;
  final String description;
  final String icon;
  final Map<String, dynamic> effects;
  final int probability;

  const LifeEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.effects,
    required this.probability,
  });
}

class LifecycleService {
  static final Random _random = Random();
  
  static List<DeathCause> getDeathCauses() {
    return [
      // Street Violence
      const DeathCause(
        id: 'gang_violence',
        name: 'Gang Violence',
        description: 'Killed in a gang war or territory dispute',
        icon: '💥',
        probability: 15,
        triggers: {
          'highHeat': 80,
          'gangTerritory': true,
          'weaponsTrafficking': true,
        },
        isPreventable: true,
      ),
      
      const DeathCause(
        id: 'drug_deal_gone_wrong',
        name: 'Deal Gone Wrong',
        description: 'Shot during a drug transaction',
        icon: '🔫',
        probability: 12,
        triggers: {
          'largeDeal': 10000,
          'unknownBuyer': true,
          'noProtection': true,
        },
        isPreventable: true,
      ),
      
      const DeathCause(
        id: 'police_shootout',
        name: 'Police Shootout',
        description: 'Killed in a firefight with law enforcement',
        icon: '👮‍♂️',
        probability: 8,
        triggers: {
          'heavyWeapons': true,
          'federalHeat': 90,
          'resistArrest': true,
        },
        isPreventable: true,
      ),
      
      // Prison Deaths
      const DeathCause(
        id: 'prison_murder',
        name: 'Prison Murder',
        description: 'Assassinated by rival inmates',
        icon: '🗡️',
        probability: 20,
        triggers: {
          'inPrison': true,
          'prisonEnemies': 3,
          'noProtection': true,
        },
        isPreventable: true,
      ),
      
      const DeathCause(
        id: 'prison_riot',
        name: 'Prison Riot',
        description: 'Killed during a violent prison uprising',
        icon: '⚔️',
        probability: 5,
        triggers: {
          'inPrison': true,
          'prisonTension': 90,
          'wrongPlace': true,
        },
        isPreventable: false,
      ),
      
      const DeathCause(
        id: 'suicide_prison',
        name: 'Prison Suicide',
        description: 'Took own life while incarcerated',
        icon: '💀',
        probability: 10,
        triggers: {
          'inPrison': true,
          'lifeSeantence': true,
          'isolation': 30,
        },
        isPreventable: true,
      ),
      
      // Drug-Related
      const DeathCause(
        id: 'overdose',
        name: 'Drug Overdose',
        description: 'Fatal overdose from own product',
        icon: '💊',
        probability: 8,
        triggers: {
          'drugUse': true,
          'pureProduct': 95,
          'stressLevel': 80,
        },
        isPreventable: true,
      ),
      
      const DeathCause(
        id: 'poisoned_supply',
        name: 'Poisoned Supply',
        description: 'Killed by contaminated drugs from rival',
        icon: '☠️',
        probability: 6,
        triggers: {
          'rivalGangs': true,
          'marketCompetition': 90,
          'trustSupplier': false,
        },
        isPreventable: true,
      ),
      
      // Natural/Health
      const DeathCause(
        id: 'stress_heart_attack',
        name: 'Stress-Induced Heart Attack',
        description: 'Heart attack from high-stress criminal lifestyle',
        icon: '💔',
        probability: 4,
        triggers: {
          'age': 50,
          'stressLevel': 95,
          'chronicStress': 365,
        },
        isPreventable: true,
      ),
      
      const DeathCause(
        id: 'old_age',
        name: 'Natural Death',
        description: 'Died of old age in prison',
        icon: '⚰️',
        probability: 2,
        triggers: {
          'age': 80,
          'lifeInPrison': true,
        },
        isPreventable: false,
      ),
      
      // Execution
      const DeathCause(
        id: 'death_penalty',
        name: 'Death Penalty',
        description: 'Executed by the state for capital crimes',
        icon: '⚡',
        probability: 1,
        triggers: {
          'capitalCrimes': true,
          'federalCharges': true,
          'deathPenaltyState': true,
        },
        isPreventable: true,
      ),
    ];
  }
  
  static List<LifeEvent> getLifeEvents() {
    return [
      // Health Events
      const LifeEvent(
        id: 'heart_condition',
        title: 'Heart Condition Diagnosed',
        description: 'Stress and lifestyle catch up - heart problems detected',
        icon: '💔',
        effects: {
          'healthPenalty': 20,
          'stressVulnerability': 1.5,
          'medicalCosts': 5000,
        },
        probability: 5,
      ),
      
      const LifeEvent(
        id: 'injury_recovery',
        title: 'Recovering from Injury',
        description: 'Healing from a recent violent encounter',
        icon: '🩹',
        effects: {
          'capacityPenalty': 25,
          'movementRestriction': 14,
          'painMedication': true,
        },
        probability: 8,
      ),
      
      // Family Events
      const LifeEvent(
        id: 'family_tragedy',
        title: 'Family Tragedy',
        description: 'Criminal lifestyle affects innocent family members',
        icon: '😢',
        effects: {
          'emotionalStress': 50,
          'motivationBoost': 'revenge',
          'familyEstrangement': true,
        },
        probability: 3,
      ),
      
      const LifeEvent(
        id: 'child_born',
        title: 'Child Born',
        description: 'A new child is born - brings both joy and responsibility',
        icon: '👶',
        effects: {
          'motivation': 'family',
          'expenses': 2000,
          'vulnerability': 'family_threat',
        },
        probability: 4,
      ),
      
      // Career Events
      const LifeEvent(
        id: 'territory_expansion',
        title: 'Territory Expansion',
        description: 'Successfully expand operations to new area',
        icon: '🗺️',
        effects: {
          'newTerritory': true,
          'incomeBoost': 1.3,
          'heatIncrease': 25,
        },
        probability: 6,
      ),
      
      const LifeEvent(
        id: 'major_supplier',
        title: 'Major Supplier Contact',
        description: 'Connect with high-level drug supplier',
        icon: '📦',
        effects: {
          'supplierAccess': 'cartel',
          'priceDiscount': 0.15,
          'qualityBoost': 20,
        },
        probability: 4,
      ),
      
      // Legal Events
      const LifeEvent(
        id: 'witness_protection',
        title: 'Witness in Protection',
        description: 'Key witness against you enters protection',
        icon: '👁️',
        effects: {
          'evidenceReduction': 30,
          'heatDecrease': 20,
          'legalAdvantage': true,
        },
        probability: 3,
      ),
      
      const LifeEvent(
        id: 'corrupt_judge',
        title: 'Corrupt Judge',
        description: 'Discover a judge who can be bought',
        icon: '⚖️',
        effects: {
          'legalProtection': 40,
          'bribeCost': 50000,
          'sentenceReduction': 0.5,
        },
        probability: 2,
      ),
    ];
  }
  
  static DeathCause? checkForDeath(Map<String, dynamic> gameState, Map<String, dynamic> circumstances) {
    final deathCauses = getDeathCauses();
    final age = gameState['age'] ?? 25;
    final heat = gameState['heat'] ?? 0;
    final inPrison = gameState['inPrison'] ?? false;
    
    for (var cause in deathCauses) {
      if (_evaluateDeathTriggers(cause, gameState, circumstances)) {
        final roll = _random.nextInt(1000); // 0-999
        var probability = cause.probability;
        
        // Age factor
        if (age > 60) probability *= 2;
        if (age > 80) probability *= 3;
        
        // High heat increases most death chances
        if (heat > 80 && !cause.id.contains('natural')) {
          probability = (probability * 1.5).round();
        }
        
        // Prison context
        if (inPrison && cause.id.contains('prison')) {
          probability *= 2;
        }
        
        if (roll < probability) {
          return cause;
        }
      }
    }
    
    return null;
  }
  
  static bool _evaluateDeathTriggers(
    DeathCause cause,
    Map<String, dynamic> gameState,
    Map<String, dynamic> circumstances,
  ) {
    for (var trigger in cause.triggers.entries) {
      final key = trigger.key;
      final requiredValue = trigger.value;
      
      switch (key) {
        case 'highHeat':
          if ((gameState['heat'] ?? 0) < requiredValue) return false;
          break;
        case 'inPrison':
          if ((gameState['inPrison'] ?? false) != requiredValue) return false;
          break;
        case 'age':
          if ((gameState['age'] ?? 25) < requiredValue) return false;
          break;
        case 'largeDeal':
          if ((circumstances['transactionAmount'] ?? 0) < requiredValue) return false;
          break;
        case 'federalHeat':
          if ((gameState['federalHeat'] ?? 0) < requiredValue) return false;
          break;
        case 'lifeSeantence':
          if ((gameState['sentenceYears'] ?? 0) < 25) return false;
          break;
        case 'weaponsTrafficking':
          if (!(gameState['hasWeapons'] ?? false)) return false;
          break;
        case 'heavyWeapons':
          if (!(gameState['hasHeavyWeapons'] ?? false)) return false;
          break;
        case 'noProtection':
          if ((gameState['bodyguards'] ?? 0) > 0) return false;
          break;
        // Add more trigger evaluations as needed
      }
    }
    
    return true;
  }
  
  static LifeEvent? checkForLifeEvent(Map<String, dynamic> gameState) {
    final events = getLifeEvents();
    
    for (var event in events) {
      final roll = _random.nextInt(1000);
      if (roll < event.probability) {
        return event;
      }
    }
    
    return null;
  }
  
  static Map<String, dynamic> calculateLegacyScore(Map<String, dynamic> finalGameState) {
    final legacy = <String, dynamic>{};
    
    // Financial Legacy
    final totalProfit = finalGameState['totalProfit'] ?? 0;
    final peakNetWorth = finalGameState['peakNetWorth'] ?? 0;
    
    // Criminal Legacy
    final yearsActive = finalGameState['yearsActive'] ?? 0;
    final territoriesControlled = finalGameState['territoriesControlled'] ?? 0;
    final crewSize = finalGameState['crewSize'] ?? 0;
    
    // Notoriety
    final federalInvestigations = finalGameState['federalInvestigations'] ?? 0;
    final prisonEscapes = finalGameState['prisonEscapes'] ?? 0;
    final legendaryDeals = finalGameState['legendaryDeals'] ?? 0;
    
    // Calculate scores
    legacy['wealthScore'] = (totalProfit / 1000).round();
    legacy['powerScore'] = territoriesControlled * 100 + crewSize * 10;
    legacy['notorietyScore'] = federalInvestigations * 200 + prisonEscapes * 500;
    legacy['longevityScore'] = yearsActive * 50;
    
    // Overall legacy rating
    final totalScore = legacy['wealthScore'] + legacy['powerScore'] + 
                     legacy['notorietyScore'] + legacy['longevityScore'];
    
    if (totalScore > 10000) {
      legacy['rating'] = 'Legendary Kingpin';
      legacy['description'] = 'Your name will be whispered in the streets for generations';
    } else if (totalScore > 5000) {
      legacy['rating'] = 'Criminal Mastermind';
      legacy['description'] = 'You built an empire that rivals the cartels';
    } else if (totalScore > 2000) {
      legacy['rating'] = 'Street Legend';
      legacy['description'] = 'Your reputation extends far beyond your territory';
    } else if (totalScore > 500) {
      legacy['rating'] = 'Seasoned Criminal';
      legacy['description'] = 'You made your mark on the underworld';
    } else {
      legacy['rating'] = 'Small Time Hustler';
      legacy['description'] = 'You tried, but the streets consumed you';
    }
    
    legacy['totalScore'] = totalScore;
    legacy['epitaph'] = _generateEpitaph(finalGameState);
    
    return legacy;
  }
  
  static String _generateEpitaph(Map<String, dynamic> gameState) {
    final deathCause = gameState['deathCause'];
    final totalProfit = gameState['totalProfit'] ?? 0;
    final yearsActive = gameState['yearsActive'] ?? 0;
    
    if (deathCause?.contains('prison') == true) {
      return 'Died behind bars, but the empire lives on';
    } else if (deathCause?.contains('gang') == true) {
      return 'Fell to the streets that made them';
    } else if (deathCause?.contains('police') == true) {
      return 'Went out in a blaze of glory';
    } else if (totalProfit > 1000000) {
      return 'Lived fast, died rich';
    } else if (yearsActive > 10) {
      return 'Survived longer than most in this game';
    } else {
      return 'Another casualty of the drug war';
    }
  }
}
