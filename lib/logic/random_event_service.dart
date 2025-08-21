import 'dart:math';

class RandomEvent {
  final String id;
  final String title;
  final String description;
  final String icon;
  final Map<String, dynamic> effects;
  final int probability; // 1-100
  final List<String> choices;
  final Map<String, Map<String, dynamic>> choiceEffects;
  final String type; // 'positive', 'negative', 'neutral'

  const RandomEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.effects,
    this.probability = 10,
    this.choices = const [],
    this.choiceEffects = const {},
    this.type = 'neutral',
  });
}

class RandomEventService {
  static final Random _random = Random();
  
  static List<RandomEvent> getRandomEvents() {
    return [
      // Positive Events
      const RandomEvent(
        id: 'lottery_win',
        title: 'Lucky Day!',
        description: 'You found a winning lottery ticket on the ground!',
        icon: '🎰',
        effects: {'cashGain': 5000, 'heatDecrease': 5},
        probability: 3,
        type: 'positive',
      ),
      const RandomEvent(
        id: 'police_distraction',
        title: 'Police Distraction',
        description: 'A major incident across town draws all police attention away!',
        icon: '�',
        effects: {'heatDecrease': 25, 'duration': 2},
        probability: 8,
        type: 'positive',
      ),
      const RandomEvent(
        id: 'market_boom',
        title: 'Market Boom!',
        description: 'Economic prosperity drives demand through the roof!',
        icon: '�',
        effects: {'priceMultiplier': 2.0, 'duration': 3},
        probability: 5,
        type: 'positive',
      ),
      const RandomEvent(
        id: 'skill_bonus',
        title: 'Learning Experience',
        description: 'Recent events have sharpened your skills!',
        icon: '📚',
        effects: {'skillPointsGain': 3, 'experienceBonus': true},
        probability: 12,
        type: 'positive',
      ),
      const RandomEvent(
        id: 'free_transport',
        title: 'Free Ride',
        description: 'A friendly driver offers you free transportation!',
        icon: '🚗',
        effects: {'freeTravelNext': true, 'duration': 1},
        probability: 10,
        type: 'positive',
      ),
      
      // Negative Events
      const RandomEvent(
        id: 'market_crash',
        title: 'Market Crash!',
        description: 'Economic turmoil devastates the streets! Prices plummet.',
        icon: '📉',
        effects: {'priceMultiplier': 0.4, 'duration': 3},
        probability: 8,
        type: 'negative',
      ),
      const RandomEvent(
        id: 'police_crackdown',
        title: 'Police Crackdown!',
        description: 'Increased law enforcement presence makes operations dangerous!',
        icon: '🚔',
        effects: {'heatIncrease': 40, 'heatMultiplier': 1.5, 'duration': 3},
        probability: 12,
        type: 'negative',
      ),
      const RandomEvent(
        id: 'robbery',
        title: 'Robbery!',
        description: 'You\'ve been robbed! Choose how to respond.',
        icon: '💸',
        effects: {},
        probability: 10,
        type: 'negative',
        choices: ['Fight Back', 'Give Up Money', 'Try to Escape'],
        choiceEffects: {
          'Fight Back': {'cashLoss': 500, 'heatIncrease': 15, 'skillGain': 'intimidation'},
          'Give Up Money': {'cashLoss': 2000, 'heatDecrease': 5},
          'Try to Escape': {'cashLoss': 1000, 'energyLoss': 20, 'skillGain': 'stealth'},
        },
      ),
      const RandomEvent(
        id: 'equipment_failure',
        title: 'Equipment Failure',
        description: 'Your gear breaks down at the worst possible moment!',
        icon: '⚠️',
        effects: {'capacityLoss': 15, 'repairCost': 1500, 'duration': 2},
        probability: 8,
        type: 'negative',
      ),
      const RandomEvent(
        id: 'informant_betrayal',
        title: 'Betrayal!',
        description: 'Someone you trusted has betrayed you to the authorities!',
        icon: '🗣️',
        effects: {'heatIncrease': 50, 'stashLoss': 0.2},
        probability: 6,
        type: 'negative',
      ),
      
      // Choice-Based Events
      const RandomEvent(
        id: 'suspicious_deal',
        title: 'Suspicious Deal',
        description: 'A stranger offers you a deal that seems too good to be true...',
        icon: '🤔',
        effects: {},
        probability: 15,
        type: 'neutral',
        choices: ['Accept Deal', 'Decline Politely', 'Report to Police'],
        choiceEffects: {
          'Accept Deal': {'cashGain': 3000, 'heatIncrease': 30, 'riskOfArrest': 0.3},
          'Decline Politely': {'reputationGain': 5, 'safetyBonus': true},
          'Report to Police': {'heatDecrease': 20, 'cashReward': 1000, 'enemyCreated': true},
        },
      ),
      const RandomEvent(
        id: 'corrupt_official',
        title: 'Corrupt Official',
        description: 'A government official offers to reduce your heat for a price.',
        icon: '🏛️',
        effects: {},
        probability: 8,
        type: 'neutral',
        choices: ['Pay Bribe', 'Threaten', 'Walk Away'],
        choiceEffects: {
          'Pay Bribe': {'cashCost': 5000, 'heatDecrease': 40},
          'Threaten': {'heatIncrease': 20, 'intimidationSkillGain': 2},
          'Walk Away': {'moralBonus': true, 'reputationGain': 3},
        },
      ),
      const RandomEvent(
        id: 'gang_recruitment',
        title: 'Gang Recruitment',
        description: 'A local gang wants to recruit you. What do you do?',
        icon: '👥',
        effects: {},
        probability: 10,
        type: 'neutral',
        choices: ['Join Gang', 'Negotiate Alliance', 'Refuse'],
        choiceEffects: {
          'Join Gang': {'gangProtection': true, 'heatDecrease': 15, 'freedomLoss': true},
          'Negotiate Alliance': {'gangAlly': true, 'diplomaticSkillGain': 2},
          'Refuse': {'gangEnemy': true, 'independenceBonus': true},
        },
      ),
      
      // Location-Specific Events
      const RandomEvent(
        id: 'warehouse_find',
        title: 'Abandoned Warehouse',
        description: 'You discover an abandoned warehouse with hidden stash!',
        icon: '🏭',
        effects: {'capacityBonus': 25, 'randomItemsFound': true, 'duration': 5},
        probability: 5,
        type: 'positive',
      ),
      const RandomEvent(
        id: 'checkpoint',
        title: 'Police Checkpoint',
        description: 'There\'s a police checkpoint ahead! Act quickly!',
        icon: '🛑',
        effects: {},
        probability: 12,
        type: 'negative',
        choices: ['Turn Around', 'Act Casual', 'Speed Through'],
        choiceEffects: {
          'Turn Around': {'timeWasted': true, 'suspicionRaised': false},
          'Act Casual': {'heatIncrease': 10, 'chanceOfSearch': 0.3},
          'Speed Through': {'heatIncrease': 35, 'escapeChance': 0.7, 'stashLoss': 0.1},
        },
      ),
      
      // Weather Events
      const RandomEvent(
        id: 'storm',
        title: 'Severe Storm',
        description: 'Bad weather affects visibility and police presence.',
        icon: '⛈️',
        effects: {'heatDecrease': 15, 'movementRestricted': true, 'duration': 1},
        probability: 8,
        type: 'neutral',
      ),
      const RandomEvent(
        id: 'heatwave',
        title: 'Heat Wave',
        description: 'Extreme heat makes everyone irritable and suspicious.',
        icon: '�️',
        effects: {'heatIncrease': 10, 'energyDrain': 15, 'duration': 2},
        probability: 6,
        type: 'negative',
      ),
      
      // Social Events
      const RandomEvent(
        id: 'family_emergency',
        title: 'Family Emergency',
        description: 'A family member needs your help urgently.',
        icon: '👨‍👩‍👧‍👦',
        effects: {},
        probability: 8,
        type: 'neutral',
        choices: ['Help Family', 'Send Money', 'Ignore'],
        choiceEffects: {
          'Help Family': {'cashCost': 2000, 'timeWasted': 1, 'karmaBonus': true},
          'Send Money': {'cashCost': 3000, 'familyRelationImproved': true},
          'Ignore': {'karmaLoss': true, 'coldnessBonus': true},
        },
      ),
      
      // Federal Events
      const RandomEvent(
        id: 'federal_investigation',
        title: 'Federal Investigation',
        description: 'FBI agents are asking questions around town about you!',
        icon: '🕵️',
        effects: {'federalHeatIncrease': 25, 'paranoidMode': true, 'duration': 4},
        probability: 5,
        type: 'negative',
      ),
      const RandomEvent(
        id: 'witness_protection',
        title: 'Witness Opportunity',
        description: 'Someone offers information about federal operations.',
        icon: '👁️',
        effects: {},
        probability: 6,
        type: 'neutral',
        choices: ['Pay for Info', 'Threaten Witness', 'Report to Feds'],
        choiceEffects: {
          'Pay for Info': {'cashCost': 4000, 'federalHeatDecrease': 30, 'intelligenceGain': true},
          'Threaten Witness': {'federalHeatIncrease': 40, 'intimidationSkillGain': 3},
          'Report to Feds': {'federalHeatDecrease': 50, 'cashReward': 10000, 'traitorsLabel': true},
        },
      ),
    ];
  }
  
  static RandomEvent? checkForRandomEvent(int day, int heat) {
    final events = getRandomEvents();
    
    for (var event in events) {
      var probability = event.probability;
      
      // Adjust probability based on game state
      if (event.id.contains('police') && heat > 70) {
        probability *= 2;
      }
      if (event.id.contains('market') && day > 15) {
        probability = (probability * 1.5).round();
      }
      
      if (_random.nextInt(100) < probability) {
        return event;
      }
    }
    
    return null;
  }
  
  static Map<String, dynamic> applyEventEffects(
    RandomEvent event, 
    Map<String, dynamic> gameState,
    [String? choice]
  ) {
    final effects = <String, dynamic>{};
    Map<String, dynamic> activeEffects = event.effects;
    
    // If choice was made, use choice effects instead
    if (choice != null && event.choiceEffects.containsKey(choice)) {
      activeEffects = event.choiceEffects[choice]!;
    }
    
    // Apply effects
    for (var entry in activeEffects.entries) {
      switch (entry.key) {
        case 'cashBonus':
          effects['cash'] = (gameState['cash'] ?? 0) + entry.value;
          break;
        case 'cashCost':
          effects['cash'] = (gameState['cash'] ?? 0) - entry.value;
          break;
        case 'heatIncrease':
          effects['heat'] = (gameState['heat'] ?? 0) + entry.value;
          break;
        case 'heatDecrease':
          effects['heat'] = ((gameState['heat'] ?? 0) - entry.value).clamp(0, 100);
          break;
        case 'capacityBonus':
          effects['tempCapacityBonus'] = entry.value;
          effects['tempEffectDuration'] = activeEffects['duration'] ?? 1;
          break;
        case 'freeItem':
          // Will be handled in UI to let player choose item
          effects['freeItemChoice'] = true;
          break;
      }
    }
    
    return effects;
  }
}
