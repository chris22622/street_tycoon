import 'dart:math';
import '../data/constants.dart';

class HeatService {
  static int applyBuySellHeat(int quantity, int currentHeat) {
    // More heat for larger quantities
    int heatIncrease = 0;
    
    if (quantity >= 50) {
      heatIncrease = 8 + Random().nextInt(5); // 8-12
    } else if (quantity >= 20) {
      heatIncrease = 4 + Random().nextInt(4); // 4-7
    } else if (quantity >= 10) {
      heatIncrease = 2 + Random().nextInt(3); // 2-4
    } else if (quantity >= 5) {
      heatIncrease = 1 + Random().nextInt(2); // 1-2
    } else if (quantity >= 1) {
      heatIncrease = Random().nextInt(2); // 0-1
    }
    
    return (currentHeat + heatIncrease).clamp(0, 100);
  }

  static int nightlyDecay(int currentHeat, int safehouseLevel) {
    // Base decay of 1 + 2 per safehouse level
    final decay = 1 + (2 * safehouseLevel);
    return (currentHeat - decay).clamp(0, 100);
  }

  static int layLowCost(int currentHeat) {
    return LAY_LOW_BASE_COST + (LAY_LOW_COST_PER_HEAT * currentHeat);
  }

  static int layLowHeatReduction(int currentHeat) {
    return min(LAY_LOW_HEAT_REDUCTION, currentHeat);
  }

  static String getHeatLabel(int heat) {
    if (heat <= 20) return 'Low';
    if (heat <= 50) return 'Medium';
    if (heat <= 75) return 'High';
    return 'Critical';
  }

  static double getHeatProgress(int heat) {
    return heat / 100.0;
  }
}
