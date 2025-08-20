import 'dart:math';
import '../data/constants.dart';
import '../data/models.dart';

class PriceEngine {
  static final Random _random = Random();
  static PriceHistory _history = PriceHistory({});

  static void resetHistory() {
    _history = PriceHistory({});
  }

  static Map<String, int> getDailyPrices(
    String area, 
    Map<String, double> trends,
    {Map<String, int>? previousPrices}
  ) {
    final Map<String, int> prices = {};
    final areaModifier = AREA_MODIFIERS[area] ?? 1.0;
    
    for (final good in GOODS) {
      final basePrice = BASE_PRICES[good] ?? 100;
      final trend = trends[good] ?? 0.0;
      
      // Apply area modifier
      double price = basePrice * areaModifier;
      
      // Apply trend
      price *= (1.0 + trend);
      
      // Add random noise (±20%)
      final noise = 0.8 + (_random.nextDouble() * 0.4);
      price *= noise;
      
      // Occasional surge/crash (5% chance)
      if (_random.nextDouble() < 0.05) {
        if (_random.nextBool()) {
          price *= 1.5 + _random.nextDouble(); // Surge
        } else {
          price *= 0.3 + (_random.nextDouble() * 0.4); // Crash
        }
      }
      
      final finalPrice = price.round().clamp(1, 999999);
      prices[good] = finalPrice;
      
      // Add to history
      _history.addPrice(good, finalPrice.toDouble());
    }
    
    return prices;
  }

  static Map<String, double> updateTrends(Map<String, double> currentTrends) {
    final Map<String, double> newTrends = {};
    
    for (final good in GOODS) {
      final currentTrend = currentTrends[good] ?? 0.0;
      
      // Small random drift each day
      final drift = -0.03 + (_random.nextDouble() * 0.06);
      final newTrend = (currentTrend + drift).clamp(-0.35, 0.35);
      
      newTrends[good] = newTrend;
    }
    
    return newTrends;
  }

  static double getPercentageChange(String good, int currentPrice) {
    final previousPrice = _history.getPreviousPrice(good);
    if (previousPrice == null || previousPrice == 0) return 0.0;
    
    return ((currentPrice - previousPrice) / previousPrice) * 100;
  }

  static List<double> getPriceHistory(String good) {
    return _history.getHistory(good);
  }

  static String? getSurgeOrCrashItem(Map<String, int> currentPrices, Map<String, int> previousPrices) {
    for (final good in GOODS) {
      final current = currentPrices[good] ?? 0;
      final previous = previousPrices[good] ?? 0;
      
      if (previous > 0) {
        final change = (current - previous) / previous;
        if (change.abs() > 0.4) { // 40% change
          return good;
        }
      }
    }
    return null;
  }
}
