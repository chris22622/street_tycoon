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

  const RandomEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.effects,
    this.probability = 10,
    this.choices = const [],
    this.choiceEffects = const {},
  });
}

class RandomEventService {
  static final Random _random = Random();
  
  static List<RandomEvent> getRandomEvents() {
    return [
      // Market Events
      const RandomEvent(
        id: 'market_crash',
        title: 'Market Crash!',
        description: 'Economic turmoil hits the streets! All prices drop significantly.',
        icon: '📉',
        effects: {'priceMultiplier': 0.6, 'duration': 2},
        probability: 8,
      ),
      const RandomEvent(
        id: 'gold_rush',
        title: 'Gold Rush!',
        description: 'High demand drives prices through the roof!',
        icon: '💰',
        effects: {'priceMultiplier': 1.5, 'duration': 2},
        probability: 8,
      ),
      
      // Police Events
      const RandomEvent(
        id: 'police_raid',
        title: 'Police Raid!',
        description: 'The heat is on! Choose your response carefully.',
        icon: '🚔',
        effects: {'heatIncrease': 30},
        probability: 12,
        choices: ['Hide Out', 'Bribe Officer', 'Run Away'],
        choiceEffects: {
          'Hide Out': {'heatIncrease': 10, 'cashCost': 0},
          'Bribe Officer': {'heatDecrease': 20, 'cashCost': 500},
          'Run Away': {'heatIncrease': 5, 'stashLoss': 0.1},
        },
      ),
      
      // Opportunity Events
      const RandomEvent(
        id: 'insider_tip',
        title: 'Insider Tip',
        description: 'A contact gives you valuable market information!',
        icon: '💡',
        effects: {'revealTrends': true, 'duration': 3},
        probability: 15,
      ),
      const RandomEvent(
        id: 'bulk_discount',
        title: 'Bulk Discount',
        description: 'A dealer offers you a special bulk deal!',
        icon: '📦',
        effects: {'discountPercent': 25, 'duration': 1},
        probability: 12,
      ),
      
      // Character Events
      const RandomEvent(
        id: 'helpful_stranger',
        title: 'Helpful Stranger',
        description: 'Someone offers to increase your carrying capacity temporarily!',
        icon: '🎒',
        effects: {'capacityBonus': 20, 'duration': 3},
        probability: 10,
      ),
      const RandomEvent(
        id: 'medical_emergency',
        title: 'Medical Emergency',
        description: 'You need medical attention! Pay up or suffer consequences.',
        icon: '🏥',
        effects: {},
        probability: 6,
        choices: ['Pay \$800', 'Tough It Out', 'Use Connections'],
        choiceEffects: {
          'Pay \$800': {'cashCost': 800, 'healthBonus': true},
          'Tough It Out': {'capacityPenalty': 10, 'duration': 5},
          'Use Connections': {'heatIncrease': 15, 'cashCost': 200},
        },
      ),
      
      // Weather Events
      const RandomEvent(
        id: 'heavy_rain',
        title: 'Heavy Rain',
        description: 'Bad weather reduces street activity and prices.',
        icon: '🌧️',
        effects: {'priceMultiplier': 0.8, 'heatDecrease': 10, 'duration': 1},
        probability: 15,
      ),
      const RandomEvent(
        id: 'festival',
        title: 'Street Festival',
        description: 'A local festival increases demand and activity!',
        icon: '🎉',
        effects: {'priceMultiplier': 1.3, 'heatMultiplier': 1.2, 'duration': 2},
        probability: 10,
      ),
      
      // Lucky Events
      const RandomEvent(
        id: 'found_money',
        title: 'Lucky Find',
        description: 'You found some cash on the ground!',
        icon: '💵',
        effects: {'cashBonus': 300},
        probability: 8,
      ),
      const RandomEvent(
        id: 'free_sample',
        title: 'Free Sample',
        description: 'Someone gives you free merchandise!',
        icon: '🎁',
        effects: {'freeItem': true},
        probability: 7,
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
