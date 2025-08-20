import '../data/constants.dart';

class UpgradeService {
  static int getDuffelCost(int currentLevel) {
    return DUFFEL_BASE_COST + (DUFFEL_COST_MULTIPLIER * currentLevel);
  }

  static int getSafehouseCost(int currentLevel) {
    return SAFEHOUSE_BASE_COST + (SAFEHOUSE_COST_MULTIPLIER * currentLevel);
  }

  static int getLawyerCost(int currentLevel) {
    return LAWYER_BASE_COST + (LAWYER_COST_MULTIPLIER * currentLevel);
  }

  static int getDuffelCapacityBonus(int level) {
    return DUFFEL_CAPACITY_BONUS * level;
  }

  static String getDuffelDescription(int level) {
    if (level == 0) {
      return 'Increases carrying capacity by ${DUFFEL_CAPACITY_BONUS} items';
    }
    return 'Level $level: +${getDuffelCapacityBonus(level)} capacity total';
  }

  static String getSafehouseDescription(int level) {
    if (level == 0) {
      return 'Reduces heat decay rate by 2 points per night';
    }
    final totalDecay = 1 + (2 * level);
    return 'Level $level: -$totalDecay heat per night';
  }

  static String getLawyerDescription(int level) {
    if (level == 0) {
      return 'Reduces conviction chance and bail amounts by 15%';
    }
    final totalReduction = (level * 15);
    return 'Level $level: -$totalReduction% conviction chance & bail';
  }

  static bool canAffordUpgrade(int cash, int cost) {
    return cash >= cost;
  }

  static int getMaxUpgradeLevel() {
    return 10; // Arbitrary max level
  }

  static bool isMaxLevel(int currentLevel) {
    return currentLevel >= getMaxUpgradeLevel();
  }
}
