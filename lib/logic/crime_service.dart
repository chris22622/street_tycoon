import 'dart:math';
import '../data/crimes.dart';
import '../data/models.dart';
import '../data/constants.dart';

class CrimeOutcome {
  final GameState state;
  final bool success;
  final int cashDelta;
  final int heatDelta;
  final Map<String, int> xp;
  final String message;

  CrimeOutcome({
    required this.state,
    required this.success,
    required this.cashDelta,
    required this.heatDelta,
    required this.xp,
    required this.message,
  });
}

class CrimeService {
  static final Random _random = Random();

  static CrimeOutcome commit(CrimeDef def, GameState state) {
    // Check energy
    if (state.energy < def.energyCost) {
      return CrimeOutcome(
        state: state,
        success: false,
        cashDelta: 0,
        heatDelta: 0,
        xp: {},
        message: 'Too tired for ${def.name}. Need ${def.energyCost} energy.',
      );
    }

    // Calculate success probability
    double skillScore = def.skillWeights.entries
        .map((e) => (state.skills[e.key] ?? 0) * e.value)
        .fold(0.0, (a, b) => a + b.toDouble());
    
    final fatiguePenalty = (100 - state.energy) * 0.002; // more tired → worse
    double successProbability = def.baseSuccess + 0.015 * skillScore - fatiguePenalty;
    successProbability = successProbability.clamp(0.05, 0.90);

    // Roll for success
    final success = _random.nextDouble() < successProbability;
    
    // Always deduct energy
    var newState = state.withEnergy(state.energy - def.energyCost);

    int cashDelta = 0;
    int heatDelta = 0;
    Map<String, int> skillGains = {};
    String message;

    if (success) {
      // Success: payout + small heat + skill XP
      cashDelta = def.minPayout + _random.nextInt(def.maxPayout - def.minPayout + 1);
      heatDelta = kCrimeSuccessHeat.toInt();
      
      // Award skill XP based on weights
      def.skillWeights.forEach((skill, weight) {
        if (weight > 0) {
          skillGains[skill] = (weight * (1 + _random.nextInt(3))); // 1-3 XP per weight point
        }
      });
      
      message = '🎯 Pulled off ${def.name} for \$${_formatMoney(cashDelta)} (+${_formatSkillGains(skillGains)} XP). Heat +$heatDelta';
      
      newState = newState.copyWith(
        cash: newState.cash + cashDelta,
        heat: newState.heat + heatDelta,
      );
      
      // Apply skill gains
      skillGains.forEach((skill, xp) {
        newState = newState.gainSkill(skill, xp);
      });
      
    } else {
      // Failure: 50/50 clean fail vs complication
      heatDelta = kCrimeFailHeat.toInt();
      
      if (_random.nextBool()) {
        // Clean fail
        message = '⚠️ ${def.name} failed. Heat +$heatDelta';
      } else {
        // Complication
        if (_random.nextBool()) {
          // Injury - small cash fee
          final injuryCost = 50 + _random.nextInt(150);
          cashDelta = -injuryCost;
          newState = newState.copyWith(cash: newState.cash + cashDelta);
          message = '🚨 ${def.name} went sideways. Injured (-\$${_formatMoney(injuryCost.abs())}). Heat +$heatDelta';
        } else {
          // Arrest risk - boost enforcement odds
          heatDelta += 5; // Extra heat for arrest complication
          message = '🚨 ${def.name} went sideways. Law enforcement alerted! Heat +$heatDelta';
        }
      }
      
      newState = newState.copyWith(heat: newState.heat + heatDelta);
    }

    return CrimeOutcome(
      state: newState,
      success: success,
      cashDelta: cashDelta,
      heatDelta: heatDelta,
      xp: skillGains,
      message: message,
    );
  }

  static String _formatMoney(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  static String _formatSkillGains(Map<String, int> gains) {
    if (gains.isEmpty) return '0';
    return gains.entries.map((e) => '${e.key}: ${e.value}').join(', ');
  }
}
