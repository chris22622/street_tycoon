import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/models.dart';
import 'data/storage.dart';
import 'data/constants.dart';
import 'data/save_game_models.dart';
import 'data/crimes.dart';
import 'data/activity_log.dart';
import 'logic/price_engine.dart';
import 'logic/heat_service.dart';
import 'logic/enforcement.dart';
import 'logic/upgrade_service.dart';
import 'logic/bank_service.dart';
import 'logic/crime_service.dart';
import 'logic/minigames_service.dart';
import 'util/formatters.dart';
import 'logic/achievement_service.dart';
// import 'logic/random_event_service.dart'; // Temporarily disabled
import 'logic/advanced_bank_service.dart';
import 'services/audio_service.dart';
import 'data/federal_models.dart';
import 'logic/federal_meter_service.dart';
import 'data/crew_models.dart';
import 'data/territory_models.dart';
import 'data/prestige_models.dart';
import 'data/transaction_models.dart';
import 'data/lawyer_models.dart';
import 'data/character_models.dart';
import 'data/gang_models.dart';
import 'systems/character_development_manager.dart';
import 'systems/meta_features_manager.dart';
import 'systems/business_features_manager.dart';
import 'systems/world_manager.dart';

// Current prices provider
final currentPricesProvider = StateProvider<Map<String, int>>((ref) => {});

// Game events provider
final gameEventsProvider = StateProvider<List<GameEvent>>((ref) => []);

// Game controller provider
final gameControllerProvider = StateNotifierProvider<GameController, GameState>((ref) {
  return GameController(ref);
});

// Enforcement case provider (for modals)
final enforcementCaseProvider = StateProvider<EnforcementCase?>((ref) => null);

// Advanced Features Providers - Making all advanced screens functional
final characterDevelopmentProvider = StateNotifierProvider<CharacterDevelopmentManager, CharacterDevelopmentState>((ref) {
  return CharacterDevelopmentManager();
});

final metaFeaturesProvider = StateNotifierProvider<MetaFeaturesManager, MetaFeaturesState>((ref) {
  return MetaFeaturesManager();
});

final businessFeaturesProvider = StateNotifierProvider<BusinessFeaturesManager, BusinessFeaturesState>((ref) {
  return BusinessFeaturesManager();
});

final worldManagerProvider = StateNotifierProvider<WorldManager, WorldState>((ref) {
  return WorldManager();
});

// Price history provider for charts and analytics
final priceHistoryProvider = StateProvider<Map<String, List<double>>>((ref) => {});

// Action minigames provider
final minigameStatsProvider = StateProvider<Map<String, Map<String, dynamic>>>((ref) => {
  'lockpicking': {'attempts': 0, 'successes': 0, 'bestTime': 0.0},
  'hacking': {'attempts': 0, 'successes': 0, 'bestTime': 0.0},
  'stealth': {'attempts': 0, 'successes': 0, 'bestTime': 0.0},
  'combat': {'attempts': 0, 'successes': 0, 'bestTime': 0.0},
});

class GameController extends StateNotifier<GameState> {
  final Ref ref;
  final Random _random = Random();

  GameController(this.ref) : super(SharedPrefsStorage.createInitialGameState()) {
    _loadGame();
  }

  Future<void> _loadGame() async {
    final savedState = await SharedPrefsStorage.loadGameState();
    if (savedState != null) {
      state = savedState;
    }
    _updatePrices();
    _initializeAdvancedFeatures();
  }

  // Initialize advanced features to sync with main game state
  void _initializeAdvancedFeatures() {
    // Initialize price history
    final priceHistory = ref.read(priceHistoryProvider.notifier);
    final currentPrices = ref.read(currentPricesProvider);
    
    // Set up initial price history if empty
    final historyData = <String, List<double>>{};
    for (final drug in currentPrices.keys) {
      historyData[drug] = [currentPrices[drug]?.toDouble() ?? 100.0];
    }
    priceHistory.state = historyData;
    
    // Initialize advanced feature managers (they have their own initial states)
    // These will be automatically initialized when first accessed
  }

  Future<void> _saveGame() async {
    // Always save to the main game state (overwrite original)
    await SharedPrefsStorage.saveGameState(state);
    
    // Also update the current save if we're in a multi-save context
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentSaveId = prefs.getString('current_save_id');
      if (currentSaveId != null) {
        final character = state.character ?? CharacterAppearance.defaultCharacter();
        final characterName = character.fullName;
        
        final saveData = SaveGameData(
          id: currentSaveId,
          characterName: characterName,
          character: character,
          gameState: state,
          lastPlayed: DateTime.now(),
          created: DateTime.now(),
        );
        await SharedPrefsStorage.saveSaveGame(saveData);
      }
    } catch (e) {
      debugPrint('Error updating multi-save: $e');
    }
  }

  void _updatePrices() {
    final prices = PriceEngine.getDailyPrices(state.area, state.trend);
    ref.read(currentPricesProvider.notifier).state = prices;
    
    // Update price history for charts
    _updatePriceHistory(prices);
  }

  void _updatePriceHistory(Map<String, int> newPrices) {
    final priceHistory = ref.read(priceHistoryProvider.notifier);
    final currentHistory = priceHistory.state;
    
    final updatedHistory = <String, List<double>>{};
    for (final drug in newPrices.keys) {
      final drugHistory = List<double>.from(currentHistory[drug] ?? []);
      drugHistory.add(newPrices[drug]!.toDouble());
      
      // Keep only last 30 data points for performance
      if (drugHistory.length > 30) {
        drugHistory.removeAt(0);
      }
      
      updatedHistory[drug] = drugHistory;
    }
    
    priceHistory.state = updatedHistory;
  }

  void newGame() {
    PriceEngine.resetHistory(); // Clear price history for new game
    state = SharedPrefsStorage.createInitialGameState();
    ref.read(gameEventsProvider.notifier).state = [];
    _updatePrices();
    _saveGame();
  }

  // Character management
  void updateCharacterInfo({
    String? firstName,
    String? lastName,
    String? gender,
    String? ethnicity,
    String? skinTone,
    String? hairColor,
    String? hairStyle,
    String? faceShape,
    String? eyeColor,
    String? backstory,
  }) {
    final currentCharacter = state.character ?? CharacterAppearance.defaultCharacter();
    final updatedCharacter = currentCharacter.copyWith(
      firstName: firstName,
      lastName: lastName,
      gender: gender != null ? Gender.values.firstWhere((g) => g.name == gender, orElse: () => currentCharacter.gender) : null,
      ethnicity: ethnicity != null ? Ethnicity.values.firstWhere((e) => e.name == ethnicity, orElse: () => currentCharacter.ethnicity) : null,
      skinTone: skinTone != null ? SkinTone.values.firstWhere((s) => s.name == skinTone, orElse: () => currentCharacter.skinTone) : null,
      hairColor: hairColor != null ? HairColor.values.firstWhere((h) => h.name == hairColor, orElse: () => currentCharacter.hairColor) : null,
      hairStyle: hairStyle != null ? HairStyle.values.firstWhere((h) => h.name == hairStyle, orElse: () => currentCharacter.hairStyle) : null,
      faceShape: faceShape != null ? FaceShape.values.firstWhere((f) => f.name == faceShape, orElse: () => currentCharacter.faceShape) : null,
      eyeColor: eyeColor != null ? EyeColor.values.firstWhere((e) => e.name == eyeColor, orElse: () => currentCharacter.eyeColor) : null,
      backstory: backstory,
    );
    
    state = state.copyWith(character: updatedCharacter);
    _saveGame();
  }

  void travel(String newArea) {
    if (newArea == state.area || state.cash < TRAVEL_COST) return;
    
    final fromArea = state.area; // Store the previous area
    
    print('🚀 TRAVEL ACTION TRIGGERED - About to play sound');
    // Play travel sound effect
    AudioService().playSoundEffect(SoundEffect.travel);
    print('🚀 TRAVEL SOUND CALLED');
    
    state = state.copyWith(
      area: newArea,
      cash: state.cash - TRAVEL_COST,
    );
    
    // Deduct energy for traveling
    state = state.withEnergy(state.energy - kEnergyTravel);
    
    _updatePrices();
    _addEvent(GameEvent(
      type: 'travel',
      message: 'Traveled to $newArea',
      cashImpact: -TRAVEL_COST,
    ));

    // Log the activity
    final activity = Activity.travel(
      fromArea: fromArea,
      toArea: newArea,
      energyCost: kEnergyTravel,
    );
    _logActivity(activity);
    
    // Check if exhausted and auto-end day
    _autoEndDayIfExhausted();
    
    _saveGame();
  }

  bool canBuy(String item, int quantity) {
    final prices = ref.read(currentPricesProvider);
    final price = prices[item] ?? 0;
    final totalCost = price * quantity;
    
    return totalCost <= state.cash && 
           quantity <= state.availableCapacity;
  }

  void buy(String item, int quantity) {
    if (!canBuy(item, quantity)) return;
    
    final prices = ref.read(currentPricesProvider);
    final price = prices[item] ?? 0;
    final totalCost = price * quantity;
    
    final newStash = Map<String, int>.from(state.stash);
    newStash[item] = (newStash[item] ?? 0) + quantity;
    
    final newHeat = HeatService.applyBuySellHeat(quantity, state.heat);
    
    // Track big moves for ML-ish adjustment
    final newHabits = Map<String, int>.from(state.habits);
    if (quantity >= 20) {
      newHabits['bigMoves'] = (newHabits['bigMoves'] ?? 0) + 1;
    }
    
    // Update statistics
    final newStats = Map<String, dynamic>.from(state.statistics);
    newStats['totalPurchases'] = (newStats['totalPurchases'] ?? 0) + 1;
    newStats['largestPurchase'] = totalCost > (newStats['largestPurchase'] ?? 0) ? totalCost : newStats['largestPurchase'];
    
    // Award skill points for business transactions
    final skillPointReward = (quantity / 5).ceil().clamp(1, 2); // 1-2 skill points per trade
    addSkillPoints(skillPointReward);
    gainExperience('business', skillPointReward * 5);
    print('💼 Trade completed! Gained $skillPointReward skill points for business skills');
    
    // Play buy sound effect
    print('💰 BUY ACTION TRIGGERED - About to play sound');
    AudioService().playSoundEffect(SoundEffect.buy);
    print('💰 BUY SOUND CALLED');
    
    // Update federal heat for large purchases
    final currentMeter = state.federalMeter ?? FederalMeter.initial();
    final newMeter = FederalMeterService.updateMeter(
      currentMeter,
      'buy',
      quantity: quantity,
      value: totalCost,
    );

    // Record transaction
    final transactionHistory = state.transactionHistory ?? TransactionHistory.initial();
    final transaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'buy',
      item: item,
      quantity: quantity,
      pricePerUnit: price,
      totalAmount: totalCost,
      area: state.area,
      timestamp: DateTime.now(),
    );
    final newTransactionHistory = transactionHistory.addTransaction(transaction);
    
    state = state.copyWith(
      cash: state.cash - totalCost,
      stash: newStash,
      heat: newHeat,
      habits: newHabits,
      statistics: newStats,
      federalMeter: newMeter,
      transactionHistory: newTransactionHistory,
    );
    
    // Deduct energy for buying
    state = state.withEnergy(state.energy - kEnergyBuy);
    
    _addEvent(GameEvent(
      type: 'buy',
      message: 'Bought $quantity $item for ${Formatters.money(totalCost)}',
      cashImpact: -totalCost,
    ));

    // Log the activity
    final activity = Activity.transaction(
      item: item,
      transactionType: 'buy',
      quantity: quantity,
      pricePerUnit: price,
      totalAmount: totalCost,
      area: state.area,
    );
    _logActivity(activity);
    
    // Check for achievements
    final newAchievements = AchievementService.checkAllAchievements(newStats, state.unlockedAchievements);
    if (newAchievements.isNotEmpty) {
      final newUnlocked = Set<String>.from(state.unlockedAchievements);
      for (var achievement in newAchievements) {
        newUnlocked.add(achievement.id);
        // Play achievement sound effect
        AudioService().playSoundEffect(SoundEffect.achievement);
        _addEvent(GameEvent(
          type: 'achievement',
          message: '🏆 Achievement unlocked: ${achievement.title}',
          cashImpact: 0,
        ));
      }
      // Update state with new achievements
      state = state.copyWith(unlockedAchievements: newUnlocked);
      
      // Update meta features with new achievements
      _updateMetaFeatures();
    }
    
    // Check if exhausted and auto-end day
    _autoEndDayIfExhausted();
    
    _saveGame();
  }

  bool canSell(String item, int quantity) {
    return (state.stash[item] ?? 0) >= quantity && quantity > 0;
  }

  void sell(String item, int quantity) {
    if (!canSell(item, quantity)) return;
    
    final prices = ref.read(currentPricesProvider);
    final price = prices[item] ?? 0;
    final totalValue = price * quantity;
    
    final newStash = Map<String, int>.from(state.stash);
    newStash[item] = (newStash[item] ?? 0) - quantity;
    if (newStash[item] == 0) {
      newStash.remove(item);
    }
    
    final newHeat = HeatService.applyBuySellHeat(quantity, state.heat);
    
    // Track big moves for ML-ish adjustment
    final newHabits = Map<String, int>.from(state.habits);
    if (quantity >= 20) {
      newHabits['bigMoves'] = (newHabits['bigMoves'] ?? 0) + 1;
    }
    
    // Update statistics
    final newStats = Map<String, dynamic>.from(state.statistics);
    newStats['totalSales'] = (newStats['totalSales'] ?? 0) + 1;
    newStats['totalProfit'] = (newStats['totalProfit'] ?? 0) + totalValue;
    newStats['largestSale'] = totalValue > (newStats['largestSale'] ?? 0) ? totalValue : newStats['largestSale'];
    
    // Award skill points for business transactions
    final skillPointReward = (quantity / 5).ceil().clamp(1, 2); // 1-2 skill points per trade
    addSkillPoints(skillPointReward);
    gainExperience('business', skillPointReward * 5);
    print('💰 Sale completed! Gained $skillPointReward skill points for business skills');
    
    // Play sell sound effect
    AudioService().playSoundEffect(SoundEffect.sell);
    if (totalValue > 10000) {
      // Big money sound for large sales
      AudioService().playSoundEffect(SoundEffect.money);
    }
    
    // Update federal heat for large sales
    final currentMeter = state.federalMeter ?? FederalMeter.initial();
    final newMeter = FederalMeterService.updateMeter(
      currentMeter,
      'sell',
      quantity: quantity,
      value: totalValue,
    );

    // Record transaction
    final transactionHistory = state.transactionHistory ?? TransactionHistory.initial();
    final transaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'sell',
      item: item,
      quantity: quantity,
      pricePerUnit: price,
      totalAmount: totalValue,
      area: state.area,
      timestamp: DateTime.now(),
    );
    final newTransactionHistory = transactionHistory.addTransaction(transaction);
    
    state = state.copyWith(
      cash: state.cash + totalValue,
      stash: newStash,
      heat: newHeat,
      habits: newHabits,
      statistics: newStats,
      federalMeter: newMeter,
      transactionHistory: newTransactionHistory,
    );
    
    // Deduct energy for selling
    state = state.withEnergy(state.energy - kEnergySell);
    
    _addEvent(GameEvent(
      type: 'sell',
      message: 'Sold $quantity $item for ${Formatters.money(totalValue)}',
      cashImpact: totalValue,
    ));

    // Log the activity
    final activity = Activity.transaction(
      item: item,
      transactionType: 'sell',
      quantity: quantity,
      pricePerUnit: price,
      totalAmount: totalValue,
      area: state.area,
    );
    _logActivity(activity);
    
    // Check for achievements
    final newAchievements = AchievementService.checkAllAchievements(newStats, state.unlockedAchievements);
    if (newAchievements.isNotEmpty) {
      final newUnlocked = Set<String>.from(state.unlockedAchievements);
      for (var achievement in newAchievements) {
        newUnlocked.add(achievement.id);
        // Play achievement sound effect
        AudioService().playSoundEffect(SoundEffect.achievement);
        _addEvent(GameEvent(
          type: 'achievement',
          message: '🏆 Achievement unlocked: ${achievement.title}',
          cashImpact: 0,
        ));
      }
      // Update state with new achievements
      state = state.copyWith(unlockedAchievements: newUnlocked);
    }
    
    // Check if exhausted and auto-end day
    _autoEndDayIfExhausted();
    
    _saveGame();
  }

  void deposit(int amount) {
    if (!BankService.canDeposit(amount, state.cash)) return;
    
    state = state.copyWith(
      cash: state.cash - amount,
      bank: state.bank + amount,
    );
    
    _addEvent(GameEvent(
      type: 'bank',
      message: 'Deposited ${Formatters.money(amount)}',
      cashImpact: -amount,
    ));
    _saveGame();
  }

  void withdraw(int amount) {
    if (!BankService.canWithdraw(amount, state.bank)) return;
    
    state = state.copyWith(
      cash: state.cash + amount,
      bank: state.bank - amount,
    );
    
    _addEvent(GameEvent(
      type: 'bank',
      message: 'Withdrew ${Formatters.money(amount)}',
      cashImpact: amount,
    ));
    _saveGame();
  }

  bool canBuyUpgrade(String upgradeType) {
    final currentLevel = state.upgrades[upgradeType] ?? 0;
    if (UpgradeService.isMaxLevel(currentLevel)) return false;
    
    int cost;
    switch (upgradeType) {
      case 'duffel':
        cost = UpgradeService.getDuffelCost(currentLevel);
        break;
      case 'safehouse':
        cost = UpgradeService.getSafehouseCost(currentLevel);
        break;
      case 'lawyer':
        cost = UpgradeService.getLawyerCost(currentLevel);
        break;
      default:
        return false;
    }
    
    return UpgradeService.canAffordUpgrade(state.cash, cost);
  }

  void buyUpgrade(String upgradeType) {
    if (!canBuyUpgrade(upgradeType)) return;
    
    final currentLevel = state.upgrades[upgradeType] ?? 0;
    int cost;
    switch (upgradeType) {
      case 'duffel':
        cost = UpgradeService.getDuffelCost(currentLevel);
        break;
      case 'safehouse':
        cost = UpgradeService.getSafehouseCost(currentLevel);
        break;
      case 'lawyer':
        cost = UpgradeService.getLawyerCost(currentLevel);
        break;
      default:
        return;
    }
    
    final newUpgrades = Map<String, int>.from(state.upgrades);
    newUpgrades[upgradeType] = currentLevel + 1;
    
    int newCapacity = state.capacity;
    if (upgradeType == 'duffel') {
      newCapacity += UpgradeService.getDuffelCapacityBonus(1);
    }
    
    // Play upgrade sound effect
    AudioService().playSoundEffect(SoundEffect.upgrade);
    
    state = state.copyWith(
      cash: state.cash - cost,
      upgrades: newUpgrades,
      capacity: newCapacity,
    );
    
    _addEvent(GameEvent(
      type: 'upgrade',
      message: 'Upgraded $upgradeType to level ${currentLevel + 1}',
      cashImpact: -cost,
    ));
    _saveGame();
  }

  void layLow() {
    final cost = HeatService.layLowCost(state.heat);
    if (state.cash < cost) return;
    
    final heatReduction = HeatService.layLowHeatReduction(state.heat);
    
    state = state.copyWith(
      cash: state.cash - cost,
      heat: state.heat - heatReduction,
    );
    
    // Deduct energy for laying low
    state = state.withEnergy(state.energy - kEnergyLayLow);
    
    _addEvent(GameEvent(
      type: 'laylow',
      message: 'Laid low, reduced heat by $heatReduction',
      cashImpact: -cost,
      heatImpact: -heatReduction,
    ));

    // Log the activity
    final activity = Activity.layLow(
      cost: cost,
      heatReduction: heatReduction,
    );
    _logActivity(activity);
    
    // Check if exhausted and auto-end day
    _autoEndDayIfExhausted();
    _saveGame();
  }

  // Crime System Methods
  Future<void> commitCrime(String crimeKey) async {
    final def = kCrimes.firstWhere((c) => c.key == crimeKey, orElse: () => throw ArgumentError('Crime not found: $crimeKey'));
    
    if (state.energy < def.energyCost) {
      _addEvent(GameEvent(type: 'warn', message: 'Too tired for ${def.name}.'));
      return;
    }
    
    final outcome = CrimeService.commit(def, state);
    state = outcome.state;
    
    // Award skill points for successful crimes
    if (outcome.success) {
      final skillPointReward = (def.energyCost / 10).ceil(); // More energy = more skill points
      addSkillPoints(skillPointReward);
      
      // Award experience for criminal skills
      gainExperience('criminal', outcome.xp['total'] ?? 10);
      
      print('🎯 Crime successful! Gained $skillPointReward skill points and ${outcome.xp['total'] ?? 10} experience');
    }
    
    _addEvent(GameEvent(
      type: outcome.success ? 'crime_success' : 'crime_fail',
      message: outcome.message,
      cashImpact: outcome.cashDelta,
      heatImpact: outcome.heatDelta,
    ));

    // Log the crime activity
    final activity = Activity.crime(
      crimeName: def.name,
      success: outcome.success,
      payout: outcome.cashDelta,
      energyCost: def.energyCost,
      heatGain: outcome.heatDelta,
      outcome: outcome.message,
      skillGains: outcome.xp,
    );
    _logActivity(activity);
    
    _autoEndDayIfExhausted();
    await _saveGame();
  }

  // Minigame System Methods
  Future<MinigameResult> playMinigame({
    required String gameType,
    required int betAmount,
    Map<String, dynamic>? gameParams,
  }) async {
    if (state.cash < betAmount) {
      throw Exception('Insufficient funds for bet');
    }

    // Deduct bet amount first
    state = state.copyWith(cash: state.cash - betAmount);

    MinigameResult result;
    
    try {
      switch (gameType) {
        case 'blackjack':
        case 'dice':
          result = MinigamesService.playDiceRoll(
            betAmount: betAmount,
            betType: gameParams?['betType'] ?? 'high',
            exactNumber: gameParams?['exactNumber'] ?? 6,
          );
          break;
        case 'slots':
        case 'card_draw':
          result = MinigamesService.playCardDraw(
            betAmount: betAmount,
            betType: gameParams?['betType'] ?? 'red',
          );
          break;
        case 'roulette':
        case 'number_guess':
          result = MinigamesService.playNumberGuess(
            betAmount: betAmount,
            guessedNumber: gameParams?['guessedNumber'] ?? 5,
          );
          break;
        case 'street_race':
          result = MinigamesService.playStreetRace(
            betAmount: betAmount,
            skillLevel: state.statistics['skill_driving'] ?? 0,
          );
          break;
        default:
          throw Exception('Unknown game type: $gameType');
      }

      // Update cash with winnings
      state = state.copyWith(cash: state.cash + result.winnings);
      
      // Award skill points for playing (win or lose)
      final skillPointReward = (betAmount / 1000).ceil().clamp(1, 3); // 1-3 skill points based on bet
      addSkillPoints(skillPointReward);
      
      // Award experience for social/mental skills
      gainExperience(result.won ? 'social' : 'mental', skillPointReward * 5);
      
      print('🎮 Minigame completed! Gained $skillPointReward skill points');
      
      _addEvent(GameEvent(
        type: result.won ? 'minigame_win' : 'minigame_loss',
        message: result.message,
        cashImpact: result.won ? result.winnings - betAmount : -betAmount,
      ));
      
      _saveGame();
      return result;
      
    } catch (e) {
      // Restore bet amount on error
      state = state.copyWith(cash: state.cash + betAmount);
      rethrow;
    }
  }

  void _autoEndDayIfExhausted() {
    if (state.energy <= kEnergyEndDayThreshold) {
      endDay(); // reuse existing flow: random events, enforcement, regenEnergy, interest, save
    }
  }

  Future<void> endDay() async {
    // Play end day sound effect
    AudioService().playSoundEffect(SoundEffect.endDay);
    
    // Process events first
    _processRandomEvents();
    
    // Check for enforcement
    final outcome = EnforcementService.rollEnforcement(state.heat, state.habits);
    
    if (outcome == EnforcementOutcome.stopAndFrisk) {
      _processStopAndFrisk();
    } else if (outcome == EnforcementOutcome.arrest) {
      _processArrest();
      return; // Don't continue with normal end day if arrested
    }
    
    // Normal end day processing
    _processEndDay();
  }

  void _processRandomEvents() {
    if (_random.nextDouble() < RANDOM_EVENT_PROBABILITY) {
      final eventType = _random.nextInt(5);
      
      switch (eventType) {
        case 0: // Side gig
          final cashGain = 50 + _random.nextInt(100);
          state = state.copyWith(cash: state.cash + cashGain);
          _addEvent(GameEvent(
            type: 'positive',
            message: 'Side gig earned \$${cashGain.toStringAsFixed(0)}',
            cashImpact: cashGain,
          ));
          break;
          
        case 1: // Repairs
          final cashLoss = 30 + _random.nextInt(80);
          state = state.copyWith(cash: (state.cash - cashLoss).clamp(0, 999999));
          _addEvent(GameEvent(
            type: 'negative',
            message: 'Equipment repairs cost \$${cashLoss.toStringAsFixed(0)}',
            cashImpact: -cashLoss,
          ));
          break;
          
        case 2: // Sweep
          if (state.stash.isNotEmpty) {
            final item = state.stash.keys.elementAt(_random.nextInt(state.stash.length));
            final lossQty = min(3 + _random.nextInt(5), state.stash[item] ?? 0);
            final newStash = Map<String, int>.from(state.stash);
            newStash[item] = (newStash[item] ?? 0) - lossQty;
            if (newStash[item]! <= 0) newStash.remove(item);
            
            state = state.copyWith(stash: newStash);
            _addEvent(GameEvent(
              type: 'negative',
              message: 'Lost $lossQty $item in a sweep',
              stashImpact: {item: -lossQty},
            ));
          }
          break;
          
        case 3: // Informant rumor
          final heatIncrease = 2 + _random.nextInt(4);
          state = state.copyWith(heat: (state.heat + heatIncrease).clamp(0, 100));
          _addEvent(GameEvent(
            type: 'negative',
            message: 'Informant rumor increased heat by $heatIncrease',
            heatImpact: heatIncrease,
          ));
          break;
          
        case 4: // Good contact
          _addEvent(const GameEvent(
            type: 'positive',
            message: 'Made a good contact - better prices today',
          ));
          break;
      }
    }
  }

  void _processStopAndFrisk() {
    final totalStash = state.stash.values.fold(0, (sum, qty) => sum + qty);
    
    if (totalStash > 0) {
      final heatIncrease = 5 + _random.nextInt(10);
      state = state.copyWith(heat: (state.heat + heatIncrease).clamp(0, 100));
      _addEvent(GameEvent(
        type: 'negative',
        message: 'Stop & frisk - warning issued, heat increased',
        heatImpact: heatIncrease,
      ));
    } else {
      _addEvent(const GameEvent(
        type: 'neutral',
        message: 'Stop & frisk - clean, no issues',
      ));
    }
  }

  void _processArrest() {
    final case_ = EnforcementService.createCase(state);
    ref.read(enforcementCaseProvider.notifier).state = case_;
    
    _addEvent(const GameEvent(
      type: 'negative',
      message: 'ARRESTED! Awaiting court hearing...',
    ));
  }

  void postBail(int amount) {
    if (state.cash < amount) return;
    
    state = state.copyWith(cash: state.cash - amount);
    ref.read(enforcementCaseProvider.notifier).state = null;
    
    _addEvent(GameEvent(
      type: 'neutral',
      message: 'Posted bail for \$${amount.toStringAsFixed(0)}',
      cashImpact: -amount,
    ));
    
    _saveGame();
    _processEndDay();
  }

  void goToCourt() {
    final case_ = ref.read(enforcementCaseProvider);
    if (case_ == null) return;
    
    final lawyerLevel = state.upgrades['lawyer'] ?? 0;
    final lawyerSuccessRate = getLawyerSuccessBonus();
    
    // Use the new lawyer system for better court outcomes
    final outcome = EnforcementService.rollCourtWithLawyer(
      case_, 
      state.rapSheet, 
      lawyerLevel, 
      lawyerSuccessRate
    );
    
    // Record lawyer usage if retainer is active
    if (state.legalSystem?.currentRetainer != null) {
      final legalSystem = state.legalSystem!;
      final updatedRetainer = legalSystem.currentRetainer!.copyWith(
        hoursUsed: legalSystem.currentRetainer!.hoursUsed + 8, // Court appearance = 8 hours
        casesHandled: [...legalSystem.currentRetainer!.casesHandled, 'Court Case ${DateTime.now().millisecondsSinceEpoch}'],
      );
      
      final updatedLegalSystem = legalSystem.copyWith(currentRetainer: updatedRetainer);
      state = state.copyWith(legalSystem: updatedLegalSystem);
    }
    
    switch (outcome) {
      case CourtOutcome.acquittal:
        state = state.copyWith(heat: (state.heat - 10).clamp(0, 100));
        _addEvent(const GameEvent(
          type: 'positive',
          message: 'ACQUITTED! Heat reduced.',
          heatImpact: -10,
        ));
        ref.read(enforcementCaseProvider.notifier).state = null;
        _processEndDay();
        break;
        
      case CourtOutcome.jail:
      case CourtOutcome.prison:
        _processConviction(case_, outcome);
        break;
    }
  }

  void _processConviction(EnforcementCase case_, CourtOutcome outcome) {
    final sentenceLength = EnforcementService.calculateSentenceLength(outcome, case_, state.rapSheet);
    final charge = EnforcementService.getChargeType(case_);
    final isFelony = EnforcementService.isChargedAsFelony(charge, case_.stashAtArrest);
    
    // Add to rap sheet
    final newRapSheet = List<RapEntry>.from(state.rapSheet);
    newRapSheet.add(RapEntry(
      date: DateTime.now().millisecondsSinceEpoch,
      charge: charge,
      lengthDays: sentenceLength,
      felony: isFelony,
    ));
    
    // Confiscate stash
    final confiscated = EnforcementService.calculateStashConfiscation(state.stash);
    final newStash = Map<String, int>.from(state.stash);
    for (final entry in confiscated.entries) {
      newStash[entry.key] = (newStash[entry.key] ?? 0) - entry.value;
      if (newStash[entry.key]! <= 0) newStash.remove(entry.key);
    }
    
    // Apply fees
    final fees = EnforcementService.calculateFees(sentenceLength);
    
    state = state.copyWith(
      day: state.day + sentenceLength,
      rapSheet: newRapSheet,
      stash: newStash,
      cash: (state.cash - fees).clamp(0, 999999),
      heat: (state.heat * 0.5).round(), // Heat reduced while incarcerated
    );
    
    final facilityType = outcome == CourtOutcome.jail ? 'jail' : 'prison';
    _addEvent(GameEvent(
      type: 'negative',
      message: 'CONVICTED: $sentenceLength days in $facilityType',
      cashImpact: -fees,
    ));
    
    ref.read(enforcementCaseProvider.notifier).state = null;
    _checkGameEnd();
  }

  void _processEndDay() {
    // Log the end day activity
    final energyRestored = state.regenEnergy(state.upgrades['safehouse'] ?? 0).energy - state.energy;
    final activity = Activity.endDay(
      day: state.day,
      energyRestored: energyRestored,
    );
    _logActivity(activity);
    
    // Better heat decay with safehouse bonus
    final safehouseLevel = state.upgrades['safehouse'] ?? 0;
    final decay = 1 + (safehouseLevel * 2);
    final newHeat = (state.heat - decay).clamp(0, 100);
    
    // Energy regeneration
    final regenEnergy = state.regenEnergy(safehouseLevel);
    
    // Trend drift
    final newTrend = PriceEngine.updateTrends(state.trend);
    
    // Better bank interest (0.1% daily)
    final newBank = (state.bank * 1.001).round();
    final interest = newBank - state.bank;
    
    // Update habits
    final newHabits = Map<String, int>.from(state.habits);
    newHabits['days'] = (newHabits['days'] ?? 0) + 1;
    
    state = regenEnergy.copyWith(
      day: regenEnergy.day + 1,
      heat: newHeat,
      trend: newTrend,
      bank: newBank,
      habits: newHabits,
    );
    
    if (interest > 0) {
      _addEvent(GameEvent(
        type: 'positive',
        message: 'Bank interest: ${Formatters.money(interest)}',
        cashImpact: interest,
      ));
    }
    
    // Update prices for new day
    _updatePrices();
    
    // TODO: Re-enable random events when fixed
    // Check for random events
    // final randomEvent = RandomEventService.checkForRandomEvent(state.day, state.heat);
    // if (randomEvent != null) {
    //   // Store event to be shown in UI
    //   final newSettings = Map<String, dynamic>.from(state.settings);
    //   newSettings['pendingEvent'] = randomEvent.id;
    //   state = state.copyWith(settings: newSettings);
    //   
    //   _addEvent(GameEvent(
    //     type: 'event',
    //     message: '⚡ ${randomEvent.title}: ${randomEvent.description}',
    //     cashImpact: 0,
    //   ));
    // }
    
    // Check for game end
    _checkGameEnd();
    
    _saveGame();
  }

  void _checkGameEnd() {
    final prices = ref.read(currentPricesProvider);
    final currentNetWorth = state.netWorthWithPrices(prices);
    
    if (currentNetWorth >= state.goalNetWorth) {
      // Achievement unlocked! Calculate next milestone
      final nextGoal = _calculateNextMilestone(state.goalNetWorth);
      
      _addEvent(GameEvent(
        type: 'positive',
        message: '🎯 MILESTONE ACHIEVED! Net Worth: ${Formatters.money(currentNetWorth)} | Next Goal: ${Formatters.money(nextGoal)}',
      ));
      
      // Update goal to next milestone
      state = state.copyWith(goalNetWorth: nextGoal);
      
      // Bonus reward for achieving milestone
      final bonus = (currentNetWorth * 0.05).round(); // 5% bonus
      state = state.copyWith(cash: state.cash + bonus);
      
      _addEvent(GameEvent(
        type: 'positive',
        message: '💰 Milestone bonus: ${Formatters.money(bonus)}!',
        cashImpact: bonus,
      ));
      
    } else if (state.day > state.daysLimit) {
      _addEvent(GameEvent(
        type: 'negative',
        message: 'Time up! Final net worth: ${Formatters.money(currentNetWorth)}',
      ));
    }
  }

  // Call this after every significant cash change
  void _checkMilestones() {
    final prices = ref.read(currentPricesProvider);
    final currentNetWorth = state.netWorthWithPrices(prices);
    
    if (currentNetWorth >= state.goalNetWorth) {
      _checkGameEnd();
    }
  }

  // Banking operations
  void depositMoney(int amount) {
    if (amount <= 0 || amount > state.cash) return;
    
    state = state.copyWith(
      cash: state.cash - amount,
      bank: state.bank + amount,
    );
    
    _addEvent(GameEvent(
      type: 'positive',
      message: '🏦 Deposited ${Formatters.money(amount)} to bank',
      cashImpact: -amount,
    ));
    
    _checkMilestones(); // Check milestones when money is deposited
    _saveGame();
  }

  void withdrawMoney(int amount) {
    if (amount <= 0 || amount > state.bank) return;
    
    state = state.copyWith(
      cash: state.cash + amount,
      bank: state.bank - amount,
    );
    
    _addEvent(GameEvent(
      type: 'neutral',
      message: '🏦 Withdrew ${Formatters.money(amount)} from bank',
      cashImpact: amount,
    ));
    
    _saveGame();
  }

  void applyDailyBankInterest() {
    if (state.bank <= 0) return;
    
    final accountType = AdvancedBankService.getAccountType(state.bank);
    final interestRate = AdvancedBankService.getInterestRate(accountType);
    final interest = (state.bank * interestRate).round();
    
    if (interest > 0) {
      state = state.copyWith(bank: state.bank + interest);
      
      _addEvent(GameEvent(
        type: 'positive',
        message: '🏦 Bank interest earned: ${Formatters.money(interest)} (${(interestRate * 100).toStringAsFixed(2)}%)',
        cashImpact: 0,
      ));
    }
    
    // Apply monthly fee if applicable
    final monthlyFee = AdvancedBankService.getMonthlyFee(accountType);
    if (monthlyFee > 0 && state.day % 30 == 0) {
      final newBalance = (state.bank - monthlyFee).clamp(0, state.bank);
      state = state.copyWith(bank: newBalance);
      
      _addEvent(GameEvent(
        type: 'negative',
        message: '🏦 Monthly account fee: ${Formatters.money(monthlyFee)}',
        cashImpact: 0,
      ));
    }
    
    _checkMilestones(); // Check milestones when interest is applied
  }

  void takeLoan(LoanOffer loanOffer, int amount) {
    if (amount > loanOffer.maxAmount || amount <= 0) return;
    
    final creditScore = AdvancedBankService.calculateCreditScore(
      state.bank,
      [], // TODO: implement loan history
      30,
      state.day,
    );
    
    if (creditScore < loanOffer.creditRequirement) {
      _addEvent(GameEvent(
        type: 'negative',
        message: '❌ Loan application denied - insufficient credit score',
        cashImpact: 0,
      ));
      return;
    }
    
    state = state.copyWith(cash: state.cash + amount);
    
    _addEvent(GameEvent(
      type: 'positive',
      message: '💰 Loan approved: ${Formatters.money(amount)} at ${loanOffer.interestRate}% interest',
      cashImpact: amount,
    ));
    
    _checkMilestones();
    _saveGame();
  }

  int _calculateNextMilestone(int currentGoal) {
    // Progressive milestone system starting at $50,000
    if (currentGoal < 50000) return 50000;
    if (currentGoal < 100000) return 100000;
    if (currentGoal < 250000) return 250000;
    if (currentGoal < 500000) return 500000;
    if (currentGoal < 1000000) return 1000000;
    if (currentGoal < 2500000) return 2500000;
    if (currentGoal < 5000000) return 5000000;
    if (currentGoal < 10000000) return 10000000;
    if (currentGoal < 25000000) return 25000000;
    if (currentGoal < 50000000) return 50000000;
    if (currentGoal < 100000000) return 100000000;
    
    // For very high goals, multiply by 2
    return currentGoal * 2;
  }

  void _addEvent(GameEvent event) {
    final currentEvents = ref.read(gameEventsProvider);
    final newEvents = [event, ...currentEvents];
    
    // Keep only last 10 events
    if (newEvents.length > 10) {
      newEvents.removeRange(10, newEvents.length);
    }
    
    ref.read(gameEventsProvider.notifier).state = newEvents;
  }

  void _logActivity(Activity activity) {
    final currentLog = state.activityLog ?? ActivityLog.initial();
    final updatedLog = currentLog.addActivity(activity);
    state = state.copyWith(activityLog: updatedLog);
    
    // Also generate a random event based on current game state
    _checkForRandomEvents();
  }

  void _checkForRandomEvents() {
    // TODO: Fix random event conflict - enhanced vs regular service
    // final randomEvent = RandomEventService.checkForRandomEvent(state.day, state.heat);
    
    // if (randomEvent != null) {
    //   // Create an activity log entry for the random event
    //   final randomEventActivity = Activity.randomEvent(
    //     eventTitle: randomEvent.title,
    //     eventDescription: randomEvent.description,
    //     eventEmoji: randomEvent.icon,
    //     metadata: {'eventId': randomEvent.id},
    //   );
    //   
    //   // Log the random event activity
    //   final currentLog = state.activityLog ?? ActivityLog.initial();
    //   final updatedLog = currentLog.addActivity(randomEventActivity);
    //   state = state.copyWith(activityLog: updatedLog);
    //   
    //   // Add to event feed as well
    //   _addEvent(GameEvent(
    //     type: 'random',
    //     message: '${randomEvent.icon} ${randomEvent.description}',
    //   ));
    // }
  }

  void updateSettings(Map<String, dynamic> newSettings) {
    final updatedSettings = Map<String, dynamic>.from(state.settings);
    updatedSettings.addAll(newSettings);
    
    state = state.copyWith(settings: updatedSettings);
    _saveGame();
  }

  void applyRandomEventEffects(Map<String, dynamic> effects) {
    final newCash = effects['cash'] ?? state.cash;
    final newHeat = effects['heat'] ?? state.heat;
    
    // Apply temporary effects
    final newSettings = Map<String, dynamic>.from(state.settings);
    if (effects.containsKey('tempCapacityBonus')) {
      newSettings['tempCapacityBonus'] = effects['tempCapacityBonus'];
      newSettings['tempEffectDuration'] = effects['tempEffectDuration'];
    }
    
    state = state.copyWith(
      cash: newCash.clamp(0, double.infinity).toInt(),
      heat: newHeat.clamp(0, 100).toInt(),
      settings: newSettings,
    );
    
    _saveGame();
  }

  // Weapon purchase method
  void purchaseWeapon(String weaponId, int price) {
    if (state.cash < price) return;
    
    // Update weapons inventory
    final newWeapons = Map<String, int>.from(state.weapons);
    newWeapons[weaponId] = (newWeapons[weaponId] ?? 0) + 1;
    
    // Increase federal heat significantly
    final newHeat = (state.heat + 15).clamp(0, 100);
    
    // Update statistics
    final newStats = Map<String, dynamic>.from(state.statistics);
    newStats['weaponsPurchased'] = (newStats['weaponsPurchased'] ?? 0) + 1;
    newStats['weaponsValue'] = (newStats['weaponsValue'] ?? 0) + price;
    
    // Play weapon purchase sound effect
    AudioService().playSoundEffect(SoundEffect.weapons);
    
    state = state.copyWith(
      cash: state.cash - price,
      weapons: newWeapons,
      heat: newHeat,
      statistics: newStats,
    );
    
    _addEvent(GameEvent(
      type: 'weapon',
      message: '🔫 Weapon purchased - Federal heat increased!',
      cashImpact: -price,
    ));
    
    _saveGame();
  }

  // Prison operation method
  void startPrisonOperation(String operationId, int startupCost) {
    if (state.cash < startupCost || !state.inPrison) return;
    
    // Update prison data
    final newPrisonData = Map<String, dynamic>.from(state.prisonData);
    final activeOps = List<String>.from(newPrisonData['activeOperations'] ?? []);
    
    if (!activeOps.contains(operationId)) {
      activeOps.add(operationId);
      newPrisonData['activeOperations'] = activeOps;
    }
    
    state = state.copyWith(
      cash: state.cash - startupCost,
      prisonData: newPrisonData,
    );
    
    _addEvent(GameEvent(
      type: 'prison',
      message: '🏢 Prison operation started - Stay under the radar!',
      cashImpact: -startupCost,
    ));
    
    _saveGame();
  }

  // Gang warfare methods
  void spendCash(int amount) {
    if (state.cash >= amount) {
      state = state.copyWith(cash: state.cash - amount);
      _saveGame();
    }
  }

  void recruitGangMember(String memberName, int cost) {
    if (state.cash >= cost) {
      state = state.copyWith(cash: state.cash - cost);
      _addEvent(GameEvent(
        type: 'gang',
        message: '👥 $memberName joined your crew!',
        cashImpact: -cost,
      ));
      _saveGame();
    }
  }

  void executeHit(String targetName, int cost) {
    if (state.cash >= cost) {
      state = state.copyWith(
        cash: state.cash - cost,
        heat: state.heat + 15,
      );
      _addEvent(GameEvent(
        type: 'hit',
        message: '🎯 Hit executed on $targetName - Heat increased!',
        cashImpact: -cost,
      ));
      _saveGame();
    }
  }

  void expandTerritory(String territoryName, int cost) {
    if (state.cash >= cost) {
      state = state.copyWith(cash: state.cash - cost);
      _addEvent(GameEvent(
        type: 'territory',
        message: '🗺️ Expanded into $territoryName territory!',
        cashImpact: -cost,
      ));
      _saveGame();
    }
  }

  // Gang management methods
  void createGang(String gangName) {
    if (state.playerGang != null) return; // Gang already exists
    
    final newGang = PlayerGang.initial(gangName);
    final newWarfare = GangWarfare.initial();
    
    state = state.copyWith(
      playerGang: newGang,
      gangWarfare: newWarfare,
    );
    
    _addEvent(GameEvent(
      type: 'gang',
      message: '👥 Founded gang: "$gangName"!',
      cashImpact: 0,
    ));
    
    _saveGame();
  }

  void renameGang(String newName) {
    final gang = state.playerGang;
    if (gang == null) return;
    
    state = state.copyWith(
      playerGang: gang.copyWith(name: newName),
    );
    
    _addEvent(GameEvent(
      type: 'gang',
      message: '🏷️ Gang renamed to: "$newName"',
      cashImpact: 0,
    ));
    
    _saveGame();
  }

  void startGangWar(String rivalGangId) {
    final warfare = state.gangWarfare;
    final gang = state.playerGang;
    if (warfare == null || gang == null) return;
    
    final rival = warfare.rivals[rivalGangId];
    if (rival == null) return;
    
    // Calculate war outcome based on gang power vs rival strength
    final playerPower = gang.power + gang.members * 2;
    final rivalPower = rival.strength + rival.territoryControl * 10;
    
    final random = Random();
    final playerRoll = random.nextInt(100) + playerPower;
    final rivalRoll = random.nextInt(100) + rivalPower;
    
    bool playerWins = playerRoll > rivalRoll;
    
    // Update federal heat for gang warfare
    final currentMeter = state.federalMeter ?? FederalMeter.initial();
    final newMeter = FederalMeterService.updateMeter(
      currentMeter,
      'gang_warfare',
      value: 10,
    );
    
    if (playerWins) {
      // Player wins
      final payout = rival.strength * 100;
      final newGang = gang.copyWith(
        totalWins: gang.totalWins + 1,
        power: gang.power + 5,
        totalRevenue: gang.totalRevenue + payout,
        lastActive: DateTime.now(),
      );
      
      state = state.copyWith(
        cash: state.cash + payout,
        playerGang: newGang,
        federalMeter: newMeter,
      );
      
      _addEvent(GameEvent(
        type: 'gang_war',
        message: '🏆 Victory against ${rival.name}! Earned ${Formatters.money(payout)}',
        cashImpact: payout,
      ));
    } else {
      // Player loses
      final loss = gang.power * 50;
      final newGang = gang.copyWith(
        totalLosses: gang.totalLosses + 1,
        power: (gang.power - 2).clamp(1, 100),
        lastActive: DateTime.now(),
      );
      
      state = state.copyWith(
        cash: (state.cash - loss).clamp(0, state.cash),
        playerGang: newGang,
        federalMeter: newMeter,
      );
      
      _addEvent(GameEvent(
        type: 'gang_war',
        message: '💀 Defeated by ${rival.name}! Lost ${Formatters.money(loss)}',
        cashImpact: -loss,
      ));
    }
    
    _saveGame();
  }

  void recruitGangMembers(int count, int costPerMember) {
    final gang = state.playerGang;
    if (gang == null) return;
    
    final totalCost = count * costPerMember;
    if (state.cash < totalCost) return;
    
    final newGang = gang.copyWith(
      members: gang.members + count,
      power: gang.power + count,
      lastActive: DateTime.now(),
    );
    
    state = state.copyWith(
      cash: state.cash - totalCost,
      playerGang: newGang,
    );
    
    _addEvent(GameEvent(
      type: 'gang',
      message: '👥 Recruited $count new gang members!',
      cashImpact: -totalCost,
    ));
    
    _saveGame();
  }

  void improveGangLoyalty(int cost) {
    final gang = state.playerGang;
    if (gang == null || state.cash < cost) return;
    
    final newGang = gang.copyWith(
      loyalty: (gang.loyalty + 10).clamp(0, 100),
      lastActive: DateTime.now(),
    );
    
    state = state.copyWith(
      cash: state.cash - cost,
      playerGang: newGang,
    );
    
    _addEvent(GameEvent(
      type: 'gang',
      message: '🤝 Improved gang loyalty and morale!',
      cashImpact: -cost,
    ));
    
    _saveGame();
  }

  // Asset management methods
  void purchaseVehicle(String vehicleName, int cost) {
    if (state.cash >= cost) {
      state = state.copyWith(cash: state.cash - cost);
      _addEvent(GameEvent(
        type: 'vehicle',
        message: '🚗 Purchased $vehicleName!',
        cashImpact: -cost,
      ));
      _saveGame();
    }
  }

  void purchaseProperty(String propertyName, int cost) {
    if (state.cash >= cost) {
      state = state.copyWith(cash: state.cash - cost);
      _addEvent(GameEvent(
        type: 'property',
        message: '🏠 Acquired $propertyName property!',
        cashImpact: -cost,
      ));
      _saveGame();
    }
  }

  void purchaseLuxury(String luxuryName, int cost) {
    if (state.cash >= cost) {
      state = state.copyWith(cash: state.cash - cost);
      _addEvent(GameEvent(
        type: 'luxury',
        message: '💎 Bought $luxuryName luxury item!',
        cashImpact: -cost,
      ));
      _saveGame();
    }
  }

  // Bribery methods
  void bribeOfficial(String officialName, int cost) {
    if (state.cash >= cost) {
      final newHeat = (state.heat * 0.7).round(); // Reduce heat significantly
      state = state.copyWith(
        cash: state.cash - cost,
        heat: newHeat,
      );
      _addEvent(GameEvent(
        type: 'bribery',
        message: '💰 Bribed $officialName - Heat reduced!',
        cashImpact: -cost,
      ));
      _saveGame();
    }
  }

  // Vehicle theft method
  void stealVehicle(String vehicleName, int cost) {
    if (state.cash >= cost) {
      state = state.copyWith(
        cash: state.cash - cost,
        heat: state.heat + 10,
      );
      _addEvent(GameEvent(
        type: 'theft',
        message: '🥷 Successfully stole $vehicleName! Heat increased!',
        cashImpact: -cost,
      ));
      _saveGame();
    }
  }

  // Combat methods
  void startHeist(String heistName, int cost) {
    if (state.cash >= cost) {
      final success = DateTime.now().millisecond % 3 != 0; // 66% success rate
      if (success) {
        final payout = cost * 3; // 3x return on successful heist
        state = state.copyWith(
          cash: state.cash - cost + payout,
          heat: state.heat + 25,
        );
        _addEvent(GameEvent(
          type: 'heist',
          message: '💰 $heistName successful! Earned \$${payout - cost}!',
          cashImpact: payout - cost,
        ));
      } else {
        state = state.copyWith(
          cash: state.cash - cost,
          heat: state.heat + 15,
        );
        _addEvent(GameEvent(
          type: 'heist',
          message: '❌ $heistName failed! Lost investment!',
          cashImpact: -cost,
        ));
      }
      _saveGame();
    }
  }

  void buyWeapon(String weaponName, int cost) {
    if (state.cash >= cost) {
      // Play weapon purchase sound effect
      AudioService().playSoundEffect(SoundEffect.weapons);
      
      state = state.copyWith(cash: state.cash - cost);
      _addEvent(GameEvent(
        type: 'weapon',
        message: '🔫 Purchased $weaponName!',
        cashImpact: -cost,
      ));
      _saveGame();
    }
  }

  // Contract completion method
  void completeContract(int cashGain, Map<String, int> newStash) {
    // Play contract completion sound effect
    AudioService().playSoundEffect(SoundEffect.money);
    
    state = state.copyWith(
      cash: state.cash + cashGain,
      stash: Map<String, int>.from(newStash),
    );
    
    _addEvent(GameEvent(
      type: 'contract',
      message: '📋 Contract completed! Earned ${Formatters.money(cashGain)}',
      cashImpact: cashGain,
    ));
    
    _saveGame();
  }

  // Federal meter methods
  void bribeOfficials(int cost) {
    if (state.cash < cost) return;

    // Initialize federal meter if not present
    final currentMeter = state.federalMeter ?? FederalMeter.initial();
    
    // Apply bribe using federal service
    final newMeter = FederalMeterService.applyBribe(currentMeter, cost);
    
    state = state.copyWith(
      cash: state.cash - cost,
      federalMeter: newMeter,
    );
    
    _addEvent(GameEvent(
      type: 'federal',
      message: '💰 Officials bribed - Federal heat reduced',
      cashImpact: -cost,
    ));
    
    _saveGame();
  }

  void layLowFederal() {
    // Initialize federal meter if not present
    final currentMeter = state.federalMeter ?? FederalMeter.initial();
    
    // Apply laying low using federal service
    final newMeter = FederalMeterService.applyLyingLow(currentMeter);
    
    state = state.copyWith(
      federalMeter: newMeter,
    );
    
    _addEvent(GameEvent(
      type: 'federal',
      message: '🕶️ Laying low - Federal heat reduced significantly',
      cashImpact: 0,
    ));
    
    _saveGame();
  }

  void executeFederalOperation(FederalOperation operation) {
    if (state.cash < operation.cost) return;

    // Initialize federal meter if not present
    final currentMeter = state.federalMeter ?? FederalMeter.initial();
    
    // Calculate success rate based on current heat level
    final baseSuccessRate = 70;
    final heatPenalty = currentMeter.level; // Reduce success by heat level
    final finalSuccessRate = (baseSuccessRate - heatPenalty).clamp(10, 90);
    final success = DateTime.now().millisecond % 100 < finalSuccessRate;
    
    // Always increase heat significantly - no free money
    final heatIncrease = operation.federalHeatIncrease;
    final actualHeatIncrease = success ? heatIncrease : (heatIncrease * 1.8).round();
    
    if (success) {
      // Update federal meter with operation heat
      final newMeter = FederalMeterService.updateMeter(
        currentMeter, 
        'federal_operation',
        value: actualHeatIncrease,
      );
      
      // Apply heat level penalties to payout
      final heatMultiplier = 1.0 - (currentMeter.level * 0.01); // 1% reduction per heat level
      final adjustedPayout = (operation.payout * heatMultiplier).round();
      
      state = state.copyWith(
        cash: state.cash - operation.cost + adjustedPayout,
        federalMeter: newMeter,
        energy: (state.energy - 5).clamp(0, 100), // Operations are exhausting
      );
      
      _addEvent(GameEvent(
        type: 'federal',
        message: '🎯 ${operation.name} successful! Earned ${Formatters.money(adjustedPayout)} (+${actualHeatIncrease} heat)',
        cashImpact: adjustedPayout - operation.cost,
      ));

      // Check for milestone achievement
      _checkMilestones();

      // Chance of immediate consequences at high heat
      if (currentMeter.level > 60 && DateTime.now().millisecond % 100 < 25) {
        _triggerFederalConsequence(operation);
      }
    } else {
      // Failed operation - lose money, gain massive heat, and face consequences
      final newMeter = FederalMeterService.updateMeter(
        currentMeter,
        'federal_operation',
        value: actualHeatIncrease,
      );
      
      // Failure consequences
      final penalty = (operation.cost * 0.5).round(); // Lose half investment on failure
      
      state = state.copyWith(
        cash: (state.cash - operation.cost - penalty).clamp(0, state.cash),
        federalMeter: newMeter,
        energy: (state.energy - 15).clamp(0, 100), // Major energy hit
      );
      
      _addEvent(GameEvent(
        type: 'federal',
        message: '❌ ${operation.name} FAILED! Lost ${Formatters.money(operation.cost + penalty)} (+${actualHeatIncrease} heat)',
        cashImpact: -(operation.cost + penalty),
      ));

      // High chance of immediate federal response on failure
      if (DateTime.now().millisecond % 100 < 60) {
        _triggerFederalConsequence(operation, failure: true);
      }
    }
    
    _saveGame();
  }

  void _triggerFederalConsequence(FederalOperation operation, {bool failure = false}) {
    final random = DateTime.now().millisecond % 100;
    
    if (random < 30) {
      // Asset seizure
      final seized = (state.cash * 0.15).round();
      state = state.copyWith(cash: (state.cash - seized).clamp(0, state.cash));
      _addEvent(GameEvent(
        type: 'federal',
        message: '🚨 Federal assets seized! Lost ${Formatters.money(seized)}',
        cashImpact: -seized,
      ));
    } else if (random < 50) {
      // Federal investigation increases heat further
      final currentMeter = state.federalMeter ?? FederalMeter.initial();
      final newMeter = FederalMeterService.updateMeter(
        currentMeter,
        'investigation',
        value: 15,
      );
      state = state.copyWith(federalMeter: newMeter);
      _addEvent(GameEvent(
        type: 'federal',
        message: '🕵️ Federal investigation launched! Major heat increase!',
        cashImpact: 0,
      ));
    } else if (random < 70) {
      // Capacity reduction (equipment seized)
      final newCapacity = (state.capacity * 0.8).round();
      state = state.copyWith(capacity: newCapacity);
      _addEvent(GameEvent(
        type: 'federal',
        message: '📦 Equipment seized by authorities! Capacity reduced!',
        cashImpact: 0,
      ));
    } else {
      // Energy drain from stress
      state = state.copyWith(energy: (state.energy - 20).clamp(0, 100));
      _addEvent(GameEvent(
        type: 'federal',
        message: '😰 Federal pressure causing stress! Energy depleted!',
        cashImpact: 0,
      ));
    }
  }

  // Crew management methods
  void hireCrew(CrewMemberRank rank) {
    if (state.cash < rank.hireCost) return;

    final crew = state.crew ?? Crew.initial();
    if (crew.isFull) return;

    // Generate a crew member
    final template = CrewTemplates.templates.firstWhere(
      (t) => t['rank'] == rank,
      orElse: () => CrewTemplates.templates.first,
    );

    final random = Random();
    final names = List<String>.from(template['names']);
    final name = names[random.nextInt(names.length)];
    
    final newMember = CrewMember(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      rank: rank,
      loyalty: 75.0 + random.nextDouble() * 20, // 75-95% starting loyalty
      hiredDate: DateTime.now(),
      skills: Map<String, double>.from(template['skills']),
      specialty: template['specialty'],
    );

    final newCrewMembers = List<CrewMember>.from(crew.members)..add(newMember);
    final newCrew = crew.copyWith(members: newCrewMembers);

    state = state.copyWith(
      cash: state.cash - rank.hireCost,
      crew: newCrew,
    );

    _addEvent(GameEvent(
      type: 'crew',
      message: '👥 Hired ${newMember.name} (${rank.name})',
      cashImpact: -rank.hireCost,
    ));

    _saveGame();
  }

  void fireCrew(String memberId) {
    final crew = state.crew ?? Crew.initial();
    final newCrewMembers = crew.members.where((m) => m.id != memberId).toList();
    final newCrew = crew.copyWith(members: newCrewMembers);

    final firedMember = crew.members.firstWhere((m) => m.id == memberId);

    state = state.copyWith(crew: newCrew);

    _addEvent(GameEvent(
      type: 'crew',
      message: '❌ Fired ${firedMember.name}',
      cashImpact: 0,
    ));

    _saveGame();
  }

  void expandTerritoryNew(TerritoryType type, String name) {
    final cost = type.cost;
    if (state.cash < cost) return;

    final territoryControl = state.territoryControl ?? TerritoryControl.initial();
    final newTerritory = Territory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      type: type,
      controlLevel: 25.0, // Start with basic control
      acquiredDate: DateTime.now(),
      underAttack: false,
    );

    final newTerritories = [...territoryControl.territories, newTerritory];
    final newTerritoryControl = territoryControl.copyWith(territories: newTerritories);

    state = state.copyWith(
      cash: state.cash - cost,
      territoryControl: newTerritoryControl,
    );

    _addEvent(GameEvent(
      type: 'territory',
      message: '🏢 Expanded to ${newTerritory.name}',
      cashImpact: -cost,
    ));

    _saveGame();
  }

  void unlockPrestigeBonus(String bonusId) {
    final prestige = state.prestigeSystem ?? PrestigeSystem.initial();
    final bonus = PrestigeBonusTemplates.all.firstWhere(
      (b) => b.id == bonusId,
      orElse: () => PrestigeBonusTemplates.all.first,
    );

    if (prestige.reputation < bonus.cost || 
        prestige.unlockedBonuses.contains(bonusId)) return;

    final newUnlockedBonuses = [...prestige.unlockedBonuses, bonusId];
    final newPrestige = prestige.copyWith(
      reputation: prestige.reputation - bonus.cost,
      unlockedBonuses: newUnlockedBonuses,
    );

    state = state.copyWith(prestigeSystem: newPrestige);

    _addEvent(GameEvent(
      type: 'prestige',
      message: '⭐ Unlocked ${bonus.name}',
      cashImpact: 0,
    ));

    _saveGame();
  }

  // Lawyer System Methods
  void hireLawyer(LawyerTier tier) {
    final retainerCost = tier.retainerCost;
    
    if (state.cash < retainerCost) {
      _addEvent(GameEvent(
        type: 'negative',
        message: '💸 Insufficient funds to hire ${tier.name}',
      ));
      return;
    }

    final legalSystem = state.legalSystem ?? const LegalSystem();
    
    // Create new retainer
    final newRetainer = LawyerRetainer(
      lawyerId: 'lawyer_${tier.name.toLowerCase().replaceAll(' ', '_')}',
      tier: tier,
      hiredDate: DateTime.now(),
      retainerPaid: retainerCost,
    );

    // Update legal system
    final updatedLegalSystem = legalSystem.copyWith(
      currentRetainer: newRetainer,
      totalLegalFees: legalSystem.totalLegalFees + retainerCost,
    );

    state = state.copyWith(
      cash: state.cash - retainerCost,
      legalSystem: updatedLegalSystem,
    );

    _addEvent(GameEvent(
      type: 'positive',
      message: '⚖️ Hired ${tier.name} for \$${Formatters.money(retainerCost)}',
      cashImpact: -retainerCost,
    ));

    _saveGame();
  }

  void fireLawyer() {
    final legalSystem = state.legalSystem;
    if (legalSystem?.currentRetainer == null) return;

    final firedRetainer = legalSystem!.currentRetainer!.copyWith(isActive: false);
    final newHistory = [...legalSystem.retainerHistory, firedRetainer];

    final updatedLegalSystem = legalSystem.copyWith(
      currentRetainer: null,
      retainerHistory: newHistory,
    );

    state = state.copyWith(legalSystem: updatedLegalSystem);

    _addEvent(GameEvent(
      type: 'negative',
      message: '⚖️ Fired ${firedRetainer.tier.name}',
    ));

    _saveGame();
  }

  void payCourtFine(int amount, String reason) {
    if (state.cash < amount) {
      _addEvent(GameEvent(
        type: 'negative',
        message: '💸 Insufficient funds to pay court fine',
      ));
      return;
    }

    final legalSystem = state.legalSystem ?? const LegalSystem();
    final newFines = Map<String, int>.from(legalSystem.finesPaid);
    newFines[reason] = (newFines[reason] ?? 0) + amount;

    final updatedLegalSystem = legalSystem.copyWith(
      courtBalance: legalSystem.courtBalance + amount,
      finesPaid: newFines,
      totalLegalFees: legalSystem.totalLegalFees + amount,
    );

    state = state.copyWith(
      cash: state.cash - amount,
      legalSystem: updatedLegalSystem,
    );

    _addEvent(GameEvent(
      type: 'negative',
      message: '⚖️ Paid \$${Formatters.money(amount)} fine for $reason',
      cashImpact: -amount,
    ));

    _saveGame();
  }

  void payBail(int amount, String caseId) {
    if (state.cash < amount) {
      _addEvent(GameEvent(
        type: 'negative',
        message: '💸 Insufficient funds to pay bail',
      ));
      return;
    }

    final legalSystem = state.legalSystem ?? const LegalSystem();
    final newBails = Map<String, int>.from(legalSystem.bailsPaid);
    newBails[caseId] = amount;

    final updatedLegalSystem = legalSystem.copyWith(
      bailsPaid: newBails,
      totalLegalFees: legalSystem.totalLegalFees + amount,
    );

    state = state.copyWith(
      cash: state.cash - amount,
      legalSystem: updatedLegalSystem,
    );

    _addEvent(GameEvent(
      type: 'negative',
      message: '⚖️ Paid \$${Formatters.money(amount)} bail',
      cashImpact: -amount,
    ));

    _saveGame();
  }

  double getLawyerSuccessBonus() {
    final legalSystem = state.legalSystem;
    if (legalSystem?.currentRetainer == null) {
      return LawyerTier.publicDefender.successRate; // Default to public defender rate
    }
    return legalSystem!.currentRetainer!.tier.successRate;
  }

  // Character System Methods
  Future<void> setCharacter(CharacterAppearance character) async {
    state = state.copyWith(character: character);
    await _saveGame();
  }

  // New Save Game System Methods
  Future<void> createNewGame(CharacterAppearance character) async {
    // Create fresh game state with character
    final newGameState = SharedPrefsStorage.createInitialGameState()
        .copyWith(character: character);
    
    // Create save game data
    final saveData = SaveGameData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      characterName: '${character.firstName} ${character.lastName}',
      character: character,
      gameState: newGameState,
      lastPlayed: DateTime.now(),
      created: DateTime.now(),
    );
    
    // Save the new game
    await SharedPrefsStorage.createNewSaveGame(saveData);
    
    // Update current state
    state = newGameState;
    
    // Reset events and prices
    ref.read(gameEventsProvider.notifier).state = [];
    _updatePrices();
  }

  Future<void> loadSaveGame(String saveId) async {
    final saveData = await SharedPrefsStorage.loadSaveGame(saveId);
    if (saveData != null) {
      // Update save's last played time
      final updatedSave = saveData.copyWith(lastPlayed: DateTime.now());
      await SharedPrefsStorage.saveSaveGame(updatedSave);
      
      // Load the game state
      state = saveData.gameState;
      ref.read(gameEventsProvider.notifier).state = [];
      _updatePrices();
    }
  }

  Future<void> newGameFromMenu() async {
    // Save current game before starting new one
    await _saveCurrentGame();
    
    // Navigate to character creation
    // This method is called from a "New Game" button in the home screen
  }

  Future<void> _saveCurrentGame() async {
    if (state.character != null) {
      final saveData = SaveGameData(
        id: await SharedPrefsStorage.getCurrentSaveId() ?? 
             DateTime.now().millisecondsSinceEpoch.toString(),
        characterName: '${state.character!.firstName} ${state.character!.lastName}',
        character: state.character!,
        gameState: state,
        lastPlayed: DateTime.now(),
        created: DateTime.now(),
      );
      
      await SharedPrefsStorage.saveSaveGame(saveData);
    }
  }

  // Update meta features with current game state (achievements, stats, etc.)
  void _updateMetaFeatures() {
    try {
      // Simple approach - just trigger meta features to refresh
      // The meta features will check game state when needed
      ref.read(metaFeaturesProvider.notifier);
    } catch (e) {
      // Silently handle meta features update errors
      print('Meta features update error: $e');
    }
  }

  // Track minigame performance
  void updateMinigameStats(String minigame, bool success, double time) {
    final minigameStats = ref.read(minigameStatsProvider.notifier);
    final currentStats = minigameStats.state;
    
    final gameStats = Map<String, dynamic>.from(currentStats[minigame] ?? {});
    gameStats['attempts'] = (gameStats['attempts'] ?? 0) + 1;
    if (success) {
      gameStats['successes'] = (gameStats['successes'] ?? 0) + 1;
    }
    
    if (time > 0 && (gameStats['bestTime'] == 0.0 || time < gameStats['bestTime'])) {
      gameStats['bestTime'] = time;
    }
    
    final newStats = Map<String, Map<String, dynamic>>.from(currentStats);
    newStats[minigame] = gameStats;
    minigameStats.state = newStats;
  }

  // Get success rate for a minigame
  double getMinigameSuccessRate(String minigame) {
    final stats = ref.read(minigameStatsProvider)[minigame];
    if (stats == null) return 0.0;
    
    final attempts = stats['attempts'] ?? 0;
    final successes = stats['successes'] ?? 0;
    
    return attempts > 0 ? successes / attempts : 0.0;
  }

  // Business integration methods
  void updateBusinessFeatures() {
    try {
      // Business features will automatically sync with game state
      print('Business features synced with game state');
    } catch (e) {
      print('Business features update error: $e');
    }
  }

  // Track legitimate business income
  void addLegitimateIncome(int amount, String source) {
    final newStats = Map<String, dynamic>.from(state.statistics);
    newStats['legitimateIncome'] = (newStats['legitimateIncome'] ?? 0) + amount;
    newStats['legitimateTransactions'] = (newStats['legitimateTransactions'] ?? 0) + 1;
    
    state = state.copyWith(
      cash: state.cash + amount,
      statistics: newStats,
    );
    
    _addEvent(GameEvent(
      type: 'business',
      message: '💼 Legitimate income: ${Formatters.money(amount)} from $source',
      cashImpact: amount,
    ));
    
    updateBusinessFeatures();
    _saveGame();
  }

  // Universal achievement tracking across all features
  void checkUniversalAchievements() {
    final newStats = Map<String, dynamic>.from(state.statistics);
    final newUnlocked = Set<String>.from(state.unlockedAchievements);
    bool hasNewAchievements = false;
    
    // Business achievements
    final legitIncome = newStats['legitimateIncome'] ?? 0;
    if (legitIncome >= 10000 && !newUnlocked.contains('business_mogul')) {
      newUnlocked.add('business_mogul');
      hasNewAchievements = true;
      _addEvent(GameEvent(
        type: 'achievement',
        message: '🏆 Achievement Unlocked: Business Mogul!',
        cashImpact: 0,
      ));
    }
    
    // Character development achievements
    final totalExperience = newStats['totalExperience'] ?? 0;
    if (totalExperience >= 1000 && !newUnlocked.contains('experienced_operator')) {
      newUnlocked.add('experienced_operator');
      hasNewAchievements = true;
      _addEvent(GameEvent(
        type: 'achievement',
        message: '🏆 Achievement Unlocked: Experienced Operator!',
        cashImpact: 0,
      ));
    }
    
    // Minigame achievements
    final minigameWins = newStats['minigameWins'] ?? 0;
    if (minigameWins >= 50 && !newUnlocked.contains('game_master')) {
      newUnlocked.add('game_master');
      hasNewAchievements = true;
      _addEvent(GameEvent(
        type: 'achievement',
        message: '🏆 Achievement Unlocked: Game Master!',
        cashImpact: 0,
      ));
    }
    
    // Multi-feature achievements
    final hasAdvancedFeatures = newStats['legitimateIncome'] != null && 
                                 newStats['totalExperience'] != null && 
                                 newStats['minigameWins'] != null;
    if (hasAdvancedFeatures && !newUnlocked.contains('feature_explorer')) {
      newUnlocked.add('feature_explorer');
      hasNewAchievements = true;
      _addEvent(GameEvent(
        type: 'achievement',
        message: '🏆 Achievement Unlocked: Feature Explorer!',
        cashImpact: 0,
      ));
    }
    
    // Update state if new achievements were unlocked
    if (hasNewAchievements) {
      state = state.copyWith(unlockedAchievements: newUnlocked);
    }
  }

  void gainExperience(String skillType, int points) {
    try {
      // Update total experience
      final newStats = Map<String, dynamic>.from(state.statistics);
      newStats['totalExperience'] = (newStats['totalExperience'] ?? 0) + points;
      
      // Ensure players have skill points to start with
      if ((newStats['skillPoints'] ?? 0) == 0) {
        newStats['skillPoints'] = 25; // Starting skill points
      }
      
      state = state.copyWith(statistics: newStats);
      
      // Character development will handle experience internally
      print('Gained $points experience in $skillType');
      
      checkUniversalAchievements();
      _saveGame();
    } catch (e) {
      print('Character development update error: $e');
    }
  }

  // Add skill points (called when completing activities)
  void addSkillPoints(int points) {
    try {
      final newStats = Map<String, dynamic>.from(state.statistics);
      newStats['skillPoints'] = (newStats['skillPoints'] ?? 0) + points;
      
      state = state.copyWith(statistics: newStats);
      _saveGame();
    } catch (e) {
      print('Skill points update error: $e');
    }
  }

  // Update specific statistic
  void updateStatistic(String key, dynamic value) {
    try {
      final newStats = Map<String, dynamic>.from(state.statistics);
      newStats[key] = value;
      
      state = state.copyWith(statistics: newStats);
      _saveGame();
    } catch (e) {
      print('Statistic update error: $e');
    }
  }

  // Update multiple statistics at once
  void updateStatistics(Map<String, dynamic> updates) {
    try {
      final newStats = Map<String, dynamic>.from(state.statistics);
      
      // Ensure starting skill points exist
      if (!newStats.containsKey('skillPoints')) {
        newStats['skillPoints'] = 25;
      }
      
      // Initialize skill categories if they don't exist
      final skillCategories = [
        'criminal', 'business', 'social', 'physical', 'mental'
      ];
      
      for (String category in skillCategories) {
        if (!newStats.containsKey('${category}_category_level')) {
          newStats['${category}_category_level'] = 1;
        }
      }
      
      // Apply the updates
      updates.forEach((key, value) {
        newStats[key] = value;
        print('📊 Updated $key to $value');
      });
      
      state = state.copyWith(statistics: newStats);
      print('💾 Statistics saved successfully');
      _saveGame();
    } catch (e) {
      print('Statistics update error: $e');
    }
  }

  // Relationship improvement method
  void improveRelationship(String relationshipType, int improvementAmount) {
    try {
      final newStats = Map<String, dynamic>.from(state.statistics);
      
      // Get current relationship level (default to reasonable starting values)
      int currentLevel = 0;
      switch (relationshipType) {
        case 'familyTrust':
          currentLevel = newStats['familyTrust'] ?? 60;
          break;
        case 'crewLoyalty':
          currentLevel = newStats['crewLoyalty'] ?? 75;
          break;
        case 'policeRelations':
          currentLevel = newStats['policeRelations'] ?? 20;
          break;
        case 'businessContacts':
          currentLevel = newStats['businessContacts'] ?? 45;
          break;
        case 'undergroundNetwork':
          currentLevel = newStats['undergroundNetwork'] ?? 80;
          break;
      }
      
      // Improve relationship (max 100)
      int newLevel = (currentLevel + improvementAmount).clamp(0, 100);
      newStats[relationshipType] = newLevel;
      
      state = state.copyWith(statistics: newStats);
      
      print('Improved $relationshipType from $currentLevel to $newLevel');
      
      checkUniversalAchievements();
      _saveGame();
    } catch (e) {
      print('Relationship improvement error: $e');
    }
  }

  // Health improvement method
  void improveHealth(String healthType, int improvementAmount) {
    try {
      final newStats = Map<String, dynamic>.from(state.statistics);
      
      // Get current health level (default to reasonable starting values)
      int currentLevel = 0;
      switch (healthType) {
        case 'physicalHealth':
          currentLevel = newStats['physicalHealth'] ?? 85;
          break;
        case 'mentalHealth':
          currentLevel = newStats['mentalHealth'] ?? 80;
          break;
        case 'fitness':
          currentLevel = newStats['fitness'] ?? 70;
          break;
        case 'energy':
          currentLevel = newStats['energy'] ?? 90;
          break;
        case 'stressLevel':
          // Stress is opposite - we want to reduce it
          currentLevel = newStats['stressLevel'] ?? 25;
          int newLevel = (currentLevel - improvementAmount).clamp(0, 100);
          newStats[healthType] = newLevel;
          state = state.copyWith(statistics: newStats);
          print('Reduced $healthType from $currentLevel to $newLevel');
          checkUniversalAchievements();
          _saveGame();
          return; // Early return for stress
      }
      
      // Improve health stat (max 100)
      int newLevel = (currentLevel + improvementAmount).clamp(0, 100);
      newStats[healthType] = newLevel;
      
      state = state.copyWith(statistics: newStats);
      
      print('Improved $healthType from $currentLevel to $newLevel');
      
      checkUniversalAchievements();
      _saveGame();
    } catch (e) {
      print('Health improvement error: $e');
    }
  }

  // Reputation improvement method
  void improveReputation(String reputationType, int improvementAmount) {
    try {
      final newStats = Map<String, dynamic>.from(state.statistics);
      
      // Get current reputation level (default to reasonable starting values)
      int currentLevel = 0;
      switch (reputationType) {
        case 'streetCred':
          currentLevel = newStats['streetCred'] ?? 0;
          break;
        case 'businessRep':
          currentLevel = newStats['businessRep'] ?? 0;
          break;
        case 'respect':
          currentLevel = newStats['respect'] ?? 0;
          break;
        case 'notoriety':
          currentLevel = newStats['notoriety'] ?? 0;
          break;
      }
      
      // Improve reputation (max 200 for most stats)
      int newLevel = (currentLevel + improvementAmount).clamp(0, 200);
      newStats[reputationType] = newLevel;
      
      state = state.copyWith(statistics: newStats);
      
      print('Improved $reputationType from $currentLevel to $newLevel');
      
      checkUniversalAchievements();
      _saveGame();
    } catch (e) {
      print('Reputation improvement error: $e');
    }
  }

  // Heat reduction method
  void reduceHeat(int reductionAmount) {
    try {
      final currentHeat = state.heat;
      final newHeat = (currentHeat - reductionAmount).clamp(0, 100);
      
      state = state.copyWith(heat: newHeat);
      
      print('Reduced heat from $currentHeat to $newHeat');
      
      checkUniversalAchievements();
      _saveGame();
    } catch (e) {
      print('Heat reduction error: $e');
    }
  }
}
