import 'dart:math';
import '../data/constants.dart';
import '../data/models.dart';

enum EnforcementOutcome {
  none,
  stopAndFrisk,
  arrest,
}

enum CourtOutcome {
  acquittal,
  jail,
  prison,
}

class EnforcementCase {
  final int stashAtArrest;
  final int heatAtArrest;
  final int day;
  final Map<String, int> stashItems;

  EnforcementCase({
    required this.stashAtArrest,
    required this.heatAtArrest,
    required this.day,
    required this.stashItems,
  });
}

class EnforcementService {
  static final Random _random = Random();

  static double calculateEnforcementProbability(int heat, Map<String, int> habits) {
    double baseProb = BASE_ENFORCEMENT_PROB + (HEAT_ENFORCEMENT_MULTIPLIER * heat);
    
    // ML-ish adjustment based on habits
    final bigMoves = habits['bigMoves'] ?? 0;
    final days = habits['days'] ?? 1;
    final bigMoveRate = days > 0 ? bigMoves / days : 0.0;
    
    if (bigMoveRate > 0.5) {
      baseProb += BIG_MOVES_ENFORCEMENT_BONUS;
    }
    
    return baseProb.clamp(0.0, MAX_ENFORCEMENT_PROB);
  }

  static EnforcementOutcome rollEnforcement(int heat, Map<String, int> habits) {
    final probability = calculateEnforcementProbability(heat, habits);
    final roll = _random.nextDouble();
    
    if (roll < probability) {
      // 30% chance of stop and frisk, 70% arrest
      if (_random.nextDouble() < 0.3) {
        return EnforcementOutcome.stopAndFrisk;
      } else {
        return EnforcementOutcome.arrest;
      }
    }
    
    return EnforcementOutcome.none;
  }

  static EnforcementCase createCase(GameState state) {
    final totalStash = state.stash.values.fold(0, (sum, qty) => sum + qty);
    
    return EnforcementCase(
      stashAtArrest: totalStash,
      heatAtArrest: state.heat,
      day: state.day,
      stashItems: Map.from(state.stash),
    );
  }

  static int calculateBailAmount(EnforcementCase case_, int lawyerLevel) {
    int baseBail = 1000 + (case_.stashAtArrest * 50) + (case_.heatAtArrest * 20);
    
    // Lawyer reduces bail
    final reduction = lawyerLevel * 0.15;
    baseBail = (baseBail * (1.0 - reduction)).round();
    
    return baseBail.clamp(500, 50000);
  }

  static double calculateConvictionProbability(
    EnforcementCase case_, 
    List<RapEntry> rapSheet, 
    int lawyerLevel
  ) {
    double baseProb = 0.3;
    
    // Heat at arrest increases conviction chance
    baseProb += case_.heatAtArrest * 0.005;
    
    // Stash size increases conviction chance
    baseProb += case_.stashAtArrest * 0.01;
    
    // Prior felonies increase conviction chance
    final felonies = rapSheet.where((entry) => entry.felony).length;
    baseProb += felonies * 0.1;
    
    // Lawyer reduces conviction chance
    baseProb -= lawyerLevel * 0.15;
    
    return baseProb.clamp(0.05, 0.95);
  }

  static CourtOutcome rollCourt(
    EnforcementCase case_, 
    List<RapEntry> rapSheet, 
    int lawyerLevel
  ) {
    final convictionProb = calculateConvictionProbability(case_, rapSheet, lawyerLevel);
    
    if (_random.nextDouble() < convictionProb) {
      // Convicted - determine sentence
      final stashSize = case_.stashAtArrest;
      final felonies = rapSheet.where((entry) => entry.felony).length;
      
      // More likely to get prison for large stash or repeat offenses
      if (stashSize > 30 || felonies > 2 || _random.nextDouble() < 0.3) {
        return CourtOutcome.prison;
      } else {
        return CourtOutcome.jail;
      }
    } else {
      return CourtOutcome.acquittal;
    }
  }

  static CourtOutcome rollCourtWithLawyer(
    EnforcementCase case_, 
    List<RapEntry> rapSheet, 
    int lawyerLevel,
    double lawyerSuccessRate
  ) {
    final baseConvictionProb = calculateConvictionProbability(case_, rapSheet, lawyerLevel);
    
    // Apply lawyer success rate bonus (reduces conviction probability)
    final adjustedConvictionProb = (baseConvictionProb * (1 - lawyerSuccessRate)).clamp(0.05, 0.95);
    
    if (_random.nextDouble() < adjustedConvictionProb) {
      // Convicted - determine sentence (lawyer can also help reduce sentence severity)
      final stashSize = case_.stashAtArrest;
      final felonies = rapSheet.where((entry) => entry.felony).length;
      
      // Lawyer reduces chance of prison vs jail
      final prisonChance = stashSize > 30 || felonies > 2 ? 0.5 : 0.3;
      final adjustedPrisonChance = (prisonChance * (1 - lawyerSuccessRate * 0.5)).clamp(0.1, 0.8);
      
      if (_random.nextDouble() < adjustedPrisonChance) {
        return CourtOutcome.prison;
      } else {
        return CourtOutcome.jail;
      }
    } else {
      return CourtOutcome.acquittal;
    }
  }

  static int calculateSentenceLength(CourtOutcome outcome, EnforcementCase case_, List<RapEntry> rapSheet) {
    final felonies = rapSheet.where((entry) => entry.felony).length;
    final stashSize = case_.stashAtArrest;
    
    switch (outcome) {
      case CourtOutcome.jail:
        int baseDays = 3 + _random.nextInt(4); // 3-6 days
        baseDays += (stashSize / 10).floor(); // +1 day per 10 items
        baseDays += felonies; // +1 day per prior felony
        return baseDays.clamp(1, 14);
        
      case CourtOutcome.prison:
        int baseDays = 14 + _random.nextInt(15); // 14-28 days
        baseDays += (stashSize / 5).floor(); // +1 day per 5 items
        baseDays += felonies * 2; // +2 days per prior felony
        return baseDays.clamp(7, 90);
        
      default:
        return 0;
    }
  }

  static String getChargeType(EnforcementCase case_) {
    final stashSize = case_.stashAtArrest;
    
    if (stashSize > 50) {
      return 'Trafficking';
    } else if (stashSize > 20) {
      return 'Distribution';
    } else if (stashSize > 0) {
      return 'Possession';
    } else {
      return 'Loitering';
    }
  }

  static bool isChargedAsFelony(String charge, int stashSize) {
    switch (charge) {
      case 'Trafficking':
        return true;
      case 'Distribution':
        return stashSize > 30 || _random.nextDouble() < 0.6;
      case 'Possession':
        return stashSize > 10 || _random.nextDouble() < 0.2;
      default:
        return false;
    }
  }

  static Map<String, int> calculateStashConfiscation(Map<String, int> stash) {
    final Map<String, int> confiscated = {};
    
    for (final entry in stash.entries) {
      // Random percentage of each item confiscated (30-70%)
      final confiscationRate = 0.3 + (_random.nextDouble() * 0.4);
      final confiscatedQty = (entry.value * confiscationRate).round();
      confiscated[entry.key] = confiscatedQty;
    }
    
    return confiscated;
  }

  static int calculateFees(int sentenceLength) {
    // Court fees, processing, etc.
    return 50 + (sentenceLength * 10) + _random.nextInt(100);
  }

  static bool shouldTriggerParole(List<RapEntry> rapSheet, int currentHeat) {
    // Small chance of parole violation if high heat and recent conviction
    if (rapSheet.isEmpty || currentHeat < 30) return false;
    
    final recentConvictions = rapSheet.where((entry) => 
        DateTime.now().millisecondsSinceEpoch - entry.date < 30 * 24 * 60 * 60 * 1000).length;
    
    if (recentConvictions > 0 && currentHeat > 50) {
      return _random.nextDouble() < 0.15; // 15% chance
    }
    
    return false;
  }

  static int calculateParoleViolationTime() {
    return 1 + _random.nextInt(2); // 1-2 days
  }
}
