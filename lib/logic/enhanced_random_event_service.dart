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
        icon: '🚨',
        effects: {'heatDecrease': 25, 'duration': 2},
        probability: 8,
        type: 'positive',
      ),
      const RandomEvent(
        id: 'market_boom',
        title: 'Market Boom!',
        description: 'Economic prosperity drives demand through the roof!',
        icon: '📈',
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
        id: 'equipment_failure',
        title: 'Equipment Failure',
        description: 'Your gear breaks down at the worst possible moment!',
        icon: '⚠️',
        effects: {'capacityLoss': 15, 'repairCost': 1500, 'duration': 2},
        probability: 8,
        type: 'negative',
      ),
      
      // Choice-Based Events
      const RandomEvent(
        id: 'robbery',
        title: 'Robbery!',
        description: 'You have been robbed! Choose how to respond.',
        icon: '💸',
        effects: {},
        probability: 10,
        type: 'negative',
        choices: ['Fight Back', 'Give Up Money', 'Try to Escape'],
        choiceEffects: {
          'Fight Back': {'cashLoss': 500, 'heatIncrease': 15, 'skillGain': 1},
          'Give Up Money': {'cashLoss': 2000, 'heatDecrease': 5},
          'Try to Escape': {'cashLoss': 1000, 'energyLoss': 20, 'skillGain': 1},
        },
      ),
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
          'Accept Deal': {'cashGain': 3000, 'heatIncrease': 30},
          'Decline Politely': {'reputationGain': 5, 'safetyBonus': true},
          'Report to Police': {'heatDecrease': 20, 'cashReward': 1000},
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
          'Threaten': {'heatIncrease': 20, 'skillGain': 2},
          'Walk Away': {'moralBonus': true, 'reputationGain': 3},
        },
      ),
      const RandomEvent(
        id: 'checkpoint',
        title: 'Police Checkpoint',
        description: 'There is a police checkpoint ahead! Act quickly!',
        icon: '🛑',
        effects: {},
        probability: 12,
        type: 'negative',
        choices: ['Turn Around', 'Act Casual', 'Speed Through'],
        choiceEffects: {
          'Turn Around': {'timeWasted': true, 'suspicionRaised': false},
          'Act Casual': {'heatIncrease': 10},
          'Speed Through': {'heatIncrease': 35, 'stashLoss': 0.1},
        },
      ),
      
      // Weather Events
      const RandomEvent(
        id: 'storm',
        title: 'Severe Storm',
        description: 'Bad weather affects visibility and police presence.',
        icon: '⛈️',
        effects: {'heatDecrease': 15, 'duration': 1},
        probability: 8,
        type: 'neutral',
      ),
      const RandomEvent(
        id: 'heatwave',
        title: 'Heat Wave',
        description: 'Extreme heat makes everyone irritable and suspicious.',
        icon: '🌡️',
        effects: {'heatIncrease': 10, 'energyDrain': 15, 'duration': 2},
        probability: 6,
        type: 'negative',
      ),
      
      // Federal Events
      const RandomEvent(
        id: 'federal_investigation',
        title: 'Federal Investigation',
        description: 'FBI agents are asking questions around town about you!',
        icon: '🕵️',
        effects: {'federalHeatIncrease': 25, 'duration': 4},
        probability: 5,
        type: 'negative',
      ),
    ];
  }

  static RandomEvent? generateRandomEvent(int currentHeat, int federalHeat) {
    final events = getRandomEvents();
    final availableEvents = events.where((event) {
      // Adjust probability based on heat levels
      if (event.type == 'negative' && currentHeat > 50) {
        return _random.nextInt(100) < event.probability * 2; // More negative events at high heat
      } else if (event.type == 'positive' && currentHeat < 20) {
        return _random.nextInt(100) < event.probability * 1.5; // More positive events at low heat
      }
      return _random.nextInt(100) < event.probability;
    }).toList();

    if (availableEvents.isEmpty) return null;
    
    return availableEvents[_random.nextInt(availableEvents.length)];
  }

  static Map<String, dynamic> applyEventEffects(Map<String, dynamic> effects, {String? choice}) {
    final results = <String, dynamic>{};
    
    // Apply direct effects
    effects.forEach((key, value) {
      switch (key) {
        case 'cashGain':
          results['cashChange'] = value;
          break;
        case 'cashLoss':
          results['cashChange'] = -value;
          break;
        case 'cashCost':
          results['cashChange'] = -value;
          break;
        case 'cashReward':
          results['cashChange'] = value;
          break;
        case 'heatIncrease':
          results['heatChange'] = value;
          break;
        case 'heatDecrease':
          results['heatChange'] = -value;
          break;
        case 'federalHeatIncrease':
          results['federalHeatChange'] = value;
          break;
        case 'federalHeatDecrease':
          results['federalHeatChange'] = -value;
          break;
        case 'skillPointsGain':
          results['skillPointsChange'] = value;
          break;
        case 'skillGain':
          results['skillIncrease'] = value;
          break;
        case 'energyLoss':
          results['energyChange'] = -value;
          break;
        case 'energyDrain':
          results['energyChange'] = -value;
          break;
        case 'capacityLoss':
          results['capacityChange'] = -value;
          break;
        case 'capacityBonus':
          results['capacityChange'] = value;
          break;
        case 'stashLoss':
          results['stashLossPercent'] = value;
          break;
        case 'priceMultiplier':
          results['priceMultiplier'] = value;
          break;
        case 'duration':
          results['duration'] = value;
          break;
        default:
          results[key] = value;
      }
    });
    
    return results;
  }
}
