import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';
import 'constants.dart';

class SharedPrefsStorage {
  static const String _gameStateKey = 'game_state';

  static Future<GameState?> loadGameState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_gameStateKey);
      
      if (jsonString != null) {
        return GameState.fromJsonString(jsonString);
      }
    } catch (e) {
      debugPrint('Error loading game state: $e');
    }
    return null;
  }

  static Future<bool> saveGameState(GameState state) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = state.toJsonString();
      final result = await prefs.setString(_gameStateKey, jsonString);
      debugPrint('Game saved successfully');
      return result;
    } catch (e) {
      debugPrint('Error saving game state: $e');
      return false;
    }
  }

  static Future<bool> clearGameState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_gameStateKey);
    } catch (e) {
      print('Error clearing game state: $e');
      return false;
    }
  }

  static GameState createInitialGameState() {
    // Initialize trend map for all goods
    final Map<String, double> initialTrend = {};
    for (final good in GOODS) {
      initialTrend[good] = 0.0;
    }

    return GameState(
      day: 1,
      daysLimit: INITIAL_DAYS_LIMIT,
      area: INITIAL_AREA,
      cash: INITIAL_CASH,
      bank: INITIAL_BANK,
      capacity: INITIAL_CAPACITY,
      heat: INITIAL_HEAT,
      goalNetWorth: INITIAL_GOAL_NET_WORTH,
      stash: {},
      trend: initialTrend,
      upgrades: {
        'duffel': 0,
        'safehouse': 0,
        'lawyer': 0,
      },
      rapSheet: [],
      habits: {
        'bigMoves': 0,
        'days': 0,
      },
      settings: {
        'sound': true,
        'darkMode': true,
        'showDisclaimer': true,
      },
      statistics: {
        'totalPurchases': 0,
        'totalSales': 0,
        'largestPurchase': 0,
        'largestSale': 0,
        'areasVisited': ['Downtown'],
        'maxBankDeposit': 0,
        'maxHeat': 0,
        'totalProfit': 0,
        'gameStartTime': DateTime.now().millisecondsSinceEpoch,
      },
      unlockedAchievements: {},
      weapons: {},
      inPrison: false,
      prisonData: {},
    );
  }
}
