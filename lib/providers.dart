import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/models.dart';
import 'data/storage.dart';
import 'data/constants.dart';
import 'logic/price_engine.dart';
import 'logic/heat_service.dart';
import 'logic/enforcement.dart';
import 'logic/upgrade_service.dart';
import 'logic/bank_service.dart';
import 'logic/achievement_service.dart';
import 'logic/random_event_service.dart';

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
  }

  Future<void> _saveGame() async {
    await SharedPrefsStorage.saveGameState(state);
  }

  void _updatePrices() {
    final prices = PriceEngine.getDailyPrices(state.area, state.trend);
    ref.read(currentPricesProvider.notifier).state = prices;
  }

  void newGame() {
    state = SharedPrefsStorage.createInitialGameState();
    ref.read(gameEventsProvider.notifier).state = [];
    _updatePrices();
    _saveGame();
  }

  void travel(String newArea) {
    if (newArea == state.area || state.cash < TRAVEL_COST) return;
    
    state = state.copyWith(
      area: newArea,
      cash: state.cash - TRAVEL_COST,
    );
    
    _updatePrices();
    _addEvent(GameEvent(
      type: 'travel',
      message: 'Traveled to $newArea',
      cashImpact: -TRAVEL_COST,
    ));
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
    
    state = state.copyWith(
      cash: state.cash - totalCost,
      stash: newStash,
      heat: newHeat,
      habits: newHabits,
      statistics: newStats,
    );
    
    _addEvent(GameEvent(
      type: 'buy',
      message: 'Bought $quantity $item for \$${totalCost.toStringAsFixed(0)}',
      cashImpact: -totalCost,
    ));
    
    // Check for achievements
    final newAchievements = AchievementService.checkAllAchievements(newStats, state.unlockedAchievements);
    if (newAchievements.isNotEmpty) {
      final newUnlocked = Set<String>.from(state.unlockedAchievements);
      for (var achievement in newAchievements) {
        newUnlocked.add(achievement.id);
        _addEvent(GameEvent(
          type: 'achievement',
          message: '🏆 Achievement unlocked: ${achievement.title}',
          cashImpact: 0,
        ));
      }
      // Update state with new achievements
      state = state.copyWith(unlockedAchievements: newUnlocked);
    }
    
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
    
    state = state.copyWith(
      cash: state.cash + totalValue,
      stash: newStash,
      heat: newHeat,
      habits: newHabits,
      statistics: newStats,
    );
    
    _addEvent(GameEvent(
      type: 'sell',
      message: 'Sold $quantity $item for \$${totalValue.toStringAsFixed(0)}',
      cashImpact: totalValue,
    ));
    
    // Check for achievements
    final newAchievements = AchievementService.checkAllAchievements(newStats, state.unlockedAchievements);
    if (newAchievements.isNotEmpty) {
      final newUnlocked = Set<String>.from(state.unlockedAchievements);
      for (var achievement in newAchievements) {
        newUnlocked.add(achievement.id);
        _addEvent(GameEvent(
          type: 'achievement',
          message: '🏆 Achievement unlocked: ${achievement.title}',
          cashImpact: 0,
        ));
      }
      // Update state with new achievements
      state = state.copyWith(unlockedAchievements: newUnlocked);
    }
    
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
      message: 'Deposited \$${amount.toStringAsFixed(0)}',
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
      message: 'Withdrew \$${amount.toStringAsFixed(0)}',
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
    
    _addEvent(GameEvent(
      type: 'laylow',
      message: 'Laid low, reduced heat by $heatReduction',
      cashImpact: -cost,
      heatImpact: -heatReduction,
    ));
    _saveGame();
  }

  Future<void> endDay() async {
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
    final outcome = EnforcementService.rollCourt(case_, state.rapSheet, lawyerLevel);
    
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
    // Heat decay
    final safehouseLevel = state.upgrades['safehouse'] ?? 0;
    final newHeat = HeatService.nightlyDecay(state.heat, safehouseLevel);
    
    // Trend drift
    final newTrend = PriceEngine.updateTrends(state.trend);
    
    // Bank interest
    final interest = BankService.calculateDailyInterest(state.bank);
    
    // Update habits
    final newHabits = Map<String, int>.from(state.habits);
    newHabits['days'] = (newHabits['days'] ?? 0) + 1;
    
    state = state.copyWith(
      day: state.day + 1,
      heat: newHeat,
      trend: newTrend,
      bank: state.bank + interest,
      habits: newHabits,
    );
    
    if (interest > 0) {
      _addEvent(GameEvent(
        type: 'positive',
        message: 'Bank interest: \$${interest.toStringAsFixed(0)}',
        cashImpact: interest,
      ));
    }
    
    // Update prices for new day
    _updatePrices();
    
    // Check for random events
    final randomEvent = RandomEventService.checkForRandomEvent(state.day, state.heat);
    if (randomEvent != null) {
      // Store event to be shown in UI
      final newSettings = Map<String, dynamic>.from(state.settings);
      newSettings['pendingEvent'] = randomEvent.id;
      state = state.copyWith(settings: newSettings);
      
      _addEvent(GameEvent(
        type: 'event',
        message: '⚡ ${randomEvent.title}: ${randomEvent.description}',
        cashImpact: 0,
      ));
    }
    
    // Check for game end
    _checkGameEnd();
    
    _saveGame();
  }

  void _checkGameEnd() {
    final currentNetWorth = _calculateNetWorth();
    
    if (currentNetWorth >= state.goalNetWorth) {
      _addEvent(GameEvent(
        type: 'positive',
        message: 'WINNER! Goal achieved: \$${currentNetWorth.toStringAsFixed(0)}',
      ));
    } else if (state.day > state.daysLimit) {
      _addEvent(GameEvent(
        type: 'negative',
        message: 'Time up! Final net worth: \$${currentNetWorth.toStringAsFixed(0)}',
      ));
    }
  }

  int _calculateNetWorth() {
    final prices = ref.read(currentPricesProvider);
    int stashValue = 0;
    
    for (final entry in state.stash.entries) {
      final price = prices[entry.key] ?? 0;
      stashValue += price * entry.value;
    }
    
    return state.cash + state.bank + stashValue;
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
      state = state.copyWith(cash: state.cash - cost);
      _addEvent(GameEvent(
        type: 'weapon',
        message: '🔫 Purchased $weaponName!',
        cashImpact: -cost,
      ));
      _saveGame();
    }
  }
}
