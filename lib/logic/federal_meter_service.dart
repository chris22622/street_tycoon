import 'dart:math';
import '../data/federal_models.dart';

class FederalMeterService {
  static FederalMeterService? _instance;
  static FederalMeterService get instance => _instance ??= FederalMeterService._internal();
  
  FederalMeterService._internal();

  // Calculate federal heat increase for different activities
  static int getActivityHeat(String activity, {int quantity = 1, int value = 0}) {
    switch (activity.toLowerCase()) {
      // Trading activities
      case 'buy':
        if (value > 50000) return 2; // Large purchases attract attention
        if (value > 20000) return 1;
        return 0;
      
      case 'sell':
        if (value > 100000) return 3; // Large sales very suspicious
        if (value > 50000) return 2;
        if (value > 20000) return 1;
        return 0;

      // Travel
      case 'travel':
        return 1; // Interstate travel always generates some heat

      // Weapons
      case 'weapon_purchase':
        return 5; // Weapon purchases are highly tracked

      // Upgrades (some are suspicious)
      case 'capacity_upgrade':
        return 1; // Larger storage capacity is suspicious
      case 'speed_upgrade':
        return 2; // Fast vehicles used for smuggling
      case 'stealth_upgrade':
        return 3; // Clearly criminal intent

      // Criminal activities
      case 'bribe':
        return 8; // Bribing officials is federal crime
      case 'heist':
        return 15; // Heists attract massive federal attention
      case 'gang_warfare':
        return 10; // Gang activities are federal jurisdiction
      case 'contract_completion':
        return quantity; // Contracts generate heat based on size

      // Prison/Law enforcement encounters
      case 'arrest':
        return 20; // Being arrested creates federal records
      case 'prison_escape':
        return 25; // Prison escapes are federal crimes

      default:
        return 0;
    }
  }

  // Apply federal meter effects to game mechanics
  static Map<String, dynamic> applyFederalEffects(FederalMeter meter, Map<String, dynamic> gameData) {
    final level = meter.currentLevel;
    final effects = <String, dynamic>{};

    // Price impacts
    if (gameData.containsKey('prices')) {
      final Map<String, int> prices = Map<String, int>.from(gameData['prices']);
      for (final entry in prices.entries) {
        final originalPrice = entry.value;
        final adjustedPrice = (originalPrice * (1 + level.priceImpact)).round();
        prices[entry.key] = adjustedPrice;
      }
      effects['prices'] = prices;
    }

    // Travel costs
    if (gameData.containsKey('travelCost')) {
      final originalCost = gameData['travelCost'] as int;
      effects['travelCost'] = (originalCost * level.travelCostMultiplier).round();
    }

    // Heat multiplier for actions
    effects['heatMultiplier'] = level.heatMultiplier;

    // Event risk multiplier
    effects['eventRiskMultiplier'] = level.eventRiskMultiplier;

    // Operating restrictions
    effects['canOperate'] = meter.canOperate;
    effects['isEscalating'] = meter.isEscalating;
    effects['isCritical'] = meter.isCritical;

    return effects;
  }

  // Update federal meter based on activity
  static FederalMeter updateMeter(FederalMeter currentMeter, String activity, {
    int quantity = 1,
    int value = 0,
    Map<String, dynamic>? context,
  }) {
    final heatIncrease = getActivityHeat(activity, quantity: quantity, value: value);
    
    if (heatIncrease == 0) return currentMeter;

    // Apply heat multiplier from current level
    final adjustedHeat = (heatIncrease * currentMeter.currentLevel.heatMultiplier).round();
    final newLevel = (currentMeter.level + adjustedHeat).clamp(0, 100);

    // Update activities tracking
    final newActivities = Map<String, int>.from(currentMeter.activities);
    newActivities[activity] = (newActivities[activity] ?? 0) + adjustedHeat;

    // Generate warnings for escalation
    final newWarnings = List<String>.from(currentMeter.activeWarnings);
    final newStatus = _calculateStatus(newLevel);
    
    if (newStatus != currentMeter.currentLevel) {
      newWarnings.add(_getEscalationWarning(newStatus));
      // Keep only last 3 warnings
      if (newWarnings.length > 3) {
        newWarnings.removeAt(0);
      }
    }

    return currentMeter.copyWith(
      level: newLevel,
      status: newStatus,
      lastUpdate: DateTime.now(),
      activities: newActivities,
      activeWarnings: newWarnings,
    );
  }

  // Process daily decay
  static FederalMeter processDailyDecay(FederalMeter currentMeter) {
    final decay = currentMeter.dailyDecay;
    final newLevel = (currentMeter.level - decay).clamp(0, 100);
    final newStatus = _calculateStatus(newLevel);

    // Clear old warnings if status improves
    List<String> newWarnings = List<String>.from(currentMeter.activeWarnings);
    if (newStatus.index < currentMeter.currentLevel.index) {
      newWarnings.add('Federal heat decreased - status improved to ${newStatus.name}');
      if (newWarnings.length > 3) {
        newWarnings.removeAt(0);
      }
    }

    return currentMeter.copyWith(
      level: newLevel,
      status: newStatus,
      lastUpdate: DateTime.now(),
      activeWarnings: newWarnings,
    );
  }

  // Generate random federal events based on meter level
  static Map<String, dynamic>? generateRandomEvent(FederalMeter meter, Random random) {
    final level = meter.currentLevel;
    final baseChance = level.eventRiskMultiplier * 0.1; // Base 10% chance, modified by level

    if (random.nextDouble() > baseChance) return null;

    switch (level) {
      case FederalLevel.clear:
        return _generateClearEvent(random);
      case FederalLevel.watch:
        return _generateWatchEvent(random);
      case FederalLevel.target:
        return _generateTargetEvent(random);
      case FederalLevel.manhunt:
        return _generateManhuntEvent(random);
    }
  }

  static FederalLevel _calculateStatus(int level) {
    if (level >= 75) return FederalLevel.manhunt;
    if (level >= 50) return FederalLevel.target;
    if (level >= 25) return FederalLevel.watch;
    return FederalLevel.clear;
  }

  static String _getEscalationWarning(FederalLevel newLevel) {
    switch (newLevel) {
      case FederalLevel.watch:
        return '⚠️ ESCALATION: FBI surveillance initiated';
      case FederalLevel.target:
        return '🚨 ESCALATION: Active federal investigation';
      case FederalLevel.manhunt:
        return '🔴 CRITICAL: Federal manhunt activated';
      case FederalLevel.clear:
        return '✅ Status improved: Operating clear';
    }
  }

  static Map<String, dynamic> _generateClearEvent(Random random) {
    final events = [
      {
        'type': 'federal_info',
        'title': 'Clean Record',
        'message': 'Your clean record helps with business dealings',
        'effects': {'priceBonus': 0.05}, // 5% better prices
      },
      {
        'type': 'federal_tip',
        'title': 'Informant Tip',
        'message': 'Street contact warns about increased police activity',
        'effects': {'heatReduction': 5},
      },
    ];
    return events[random.nextInt(events.length)];
  }

  static Map<String, dynamic> _generateWatchEvent(Random random) {
    final events = [
      {
        'type': 'federal_surveillance',
        'title': 'Surveillance Detected',
        'message': 'You notice unmarked cars following you. Lay low.',
        'effects': {'heatIncrease': 3, 'priceReduction': 0.1},
      },
      {
        'type': 'federal_wiretap',
        'title': 'Phone Tapped',
        'message': 'Your phone conversations may be monitored',
        'effects': {'operationRestriction': true},
      },
    ];
    return events[random.nextInt(events.length)];
  }

  static Map<String, dynamic> _generateTargetEvent(Random random) {
    final events = [
      {
        'type': 'federal_raid',
        'title': 'Federal Raid Warning',
        'message': 'Contacts warn of planned federal raids in the area',
        'effects': {'cashLoss': 5000, 'inventoryLoss': 0.2}, // Lose 20% of inventory
      },
      {
        'type': 'federal_freeze',
        'title': 'Asset Monitoring',
        'message': 'Federal agents are monitoring your financial activity',
        'effects': {'bankRestriction': true, 'travelCostIncrease': 2.0},
      },
    ];
    return events[random.nextInt(events.length)];
  }

  static Map<String, dynamic> _generateManhuntEvent(Random random) {
    final events = [
      {
        'type': 'federal_manhunt',
        'title': 'FEDERAL MANHUNT',
        'message': 'Your face is on wanted posters. Movement is extremely dangerous.',
        'effects': {'cashLoss': 15000, 'heatIncrease': 10, 'operationShutdown': true},
      },
      {
        'type': 'federal_siege',
        'title': 'SAFE HOUSE COMPROMISED',
        'message': 'Federal agents have located your operations. Emergency evacuation!',
        'effects': {'inventoryLoss': 0.5, 'cashLoss': 25000}, // Lose 50% of everything
      },
    ];
    return events[random.nextInt(events.length)];
  }

  // Methods for reducing federal heat
  static int calculateBribeCost(FederalMeter meter) {
    final baseCost = 10000;
    final levelMultiplier = meter.currentLevel.index + 1;
    return baseCost * levelMultiplier * levelMultiplier; // Exponential cost increase
  }

  static FederalMeter applyBribe(FederalMeter meter, int cost) {
    // Bribing reduces heat but also increases it slightly (bribing is illegal)
    final heatReduction = (cost / 1000).round(); // $1000 = 1 heat reduction
    final heatIncrease = 5; // But bribing itself generates 5 heat
    
    final netReduction = heatReduction - heatIncrease;
    final newLevel = (meter.level - netReduction).clamp(0, 100);

    final newActivities = Map<String, int>.from(meter.activities);
    newActivities['bribe'] = (newActivities['bribe'] ?? 0) + heatIncrease;

    return meter.copyWith(
      level: newLevel,
      lastUpdate: DateTime.now(),
      activities: newActivities,
    );
  }

  static FederalMeter applyLyingLow(FederalMeter meter) {
    // Lying low reduces heat more effectively but costs time
    final heatReduction = 15;
    final newLevel = (meter.level - heatReduction).clamp(0, 100);

    return meter.copyWith(
      level: newLevel,
      lastUpdate: DateTime.now(),
    );
  }
}
