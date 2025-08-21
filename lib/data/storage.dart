import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';
import 'constants.dart';
import 'federal_models.dart';
import 'crew_models.dart';
import 'lawyer_models.dart';
import 'save_game_models.dart';
import 'activity_log.dart';
import 'dart:convert';

class SharedPrefsStorage {
  static const String _gameStateKey = 'game_state';
  static const String _saveGamesKey = 'save_games_list';
  static const String _currentSaveKey = 'current_save_id';

  // Legacy single save methods (for backwards compatibility)
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

  // New multi-save system
  static Future<SaveGameList> loadSaveGameList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_saveGamesKey);
      
      if (jsonString != null) {
        final json = jsonDecode(jsonString);
        return SaveGameList.fromJson(json);
      }
    } catch (e) {
      debugPrint('Error loading save games list: $e');
    }
    return SaveGameList(saves: []);
  }

  static Future<bool> saveSaveGameList(SaveGameList saveList) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(saveList.toJson());
      final result = await prefs.setString(_saveGamesKey, jsonString);
      debugPrint('Save games list updated successfully');
      return result;
    } catch (e) {
      debugPrint('Error saving save games list: $e');
      return false;
    }
  }

  static Future<String?> getCurrentSaveId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_currentSaveKey);
    } catch (e) {
      debugPrint('Error loading current save ID: $e');
      return null;
    }
  }

  static Future<bool> setCurrentSaveId(String saveId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_currentSaveKey, saveId);
    } catch (e) {
      debugPrint('Error setting current save ID: $e');
      return false;
    }
  }

  static Future<SaveGameData?> loadSaveGame(String saveId) async {
    final saveList = await loadSaveGameList();
    return saveList.findById(saveId);
  }

  static Future<bool> saveSaveGame(SaveGameData saveData) async {
    try {
      // Update the saves list
      final saveList = await loadSaveGameList();
      final updatedList = saveList.updateSave(saveData);
      await saveSaveGameList(updatedList);
      
      // Set as current save
      await setCurrentSaveId(saveData.id);
      
      // Also save to legacy location for current game
      await saveGameState(saveData.gameState);
      
      return true;
    } catch (e) {
      debugPrint('Error saving save game: $e');
      return false;
    }
  }

  static Future<bool> createNewSaveGame(SaveGameData saveData) async {
    try {
      final saveList = await loadSaveGameList();
      final updatedList = saveList.addSave(saveData);
      await saveSaveGameList(updatedList);
      await setCurrentSaveId(saveData.id);
      
      // Also save to legacy location
      await saveGameState(saveData.gameState);
      
      return true;
    } catch (e) {
      debugPrint('Error creating new save game: $e');
      return false;
    }
  }

  static Future<bool> deleteSaveGame(String saveId) async {
    try {
      final saveList = await loadSaveGameList();
      final updatedList = saveList.removeSave(saveId);
      await saveSaveGameList(updatedList);
      
      // If this was the current save, clear current save ID
      final currentSaveId = await getCurrentSaveId();
      if (currentSaveId == saveId) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(_currentSaveKey);
        await clearGameState();
      }
      
      return true;
    } catch (e) {
      debugPrint('Error deleting save game: $e');
      return false;
    }
  }

  // Migration from old save format to new format
  static Future<bool> migrateLegacySave() async {
    try {
      final legacyState = await loadGameState();
      if (legacyState != null && legacyState.character != null) {
        final saveData = SaveGameData(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          characterName: '${legacyState.character!.firstName} ${legacyState.character!.lastName}',
          character: legacyState.character!,
          gameState: legacyState,
          lastPlayed: DateTime.now(),
          created: DateTime.now(),
        );
        
        await createNewSaveGame(saveData);
        debugPrint('Legacy save migrated successfully');
        return true;
      }
    } catch (e) {
      debugPrint('Error migrating legacy save: $e');
    }
    return false;
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
      energy: 100, // Start with full energy
      skills: {
        'stealth': 0,
        'intimidation': 0,
        'hacking': 0,
        'driving': 0,
      },
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
      federalMeter: FederalMeter.initial(),
      crew: Crew.initial(),
      activityLog: ActivityLog.initial(),
      legalSystem: const LegalSystem(),
      character: null, // No default character - must create one
    );
  }
}
