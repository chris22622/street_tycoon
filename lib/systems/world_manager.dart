// World Management System
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/world_models.dart';
import '../data/expanded_constants.dart';

class WorldState {
  final String currentCityId;
  final String currentTimePeriod;
  final Season currentSeason;
  final List<City> unlockedCities;
  final List<HistoricalEvent> activeEvents;
  final Map<String, double> globalModifiers;
  final DateTime gameTime;

  const WorldState({
    this.currentCityId = 'chicago',
    this.currentTimePeriod = '1980s',
    required this.currentSeason,
    required this.unlockedCities,
    required this.activeEvents,
    required this.globalModifiers,
    required this.gameTime,
  });

  WorldState copyWith({
    String? currentCityId,
    String? currentTimePeriod,
    Season? currentSeason,
    List<City>? unlockedCities,
    List<HistoricalEvent>? activeEvents,
    Map<String, double>? globalModifiers,
    DateTime? gameTime,
  }) {
    return WorldState(
      currentCityId: currentCityId ?? this.currentCityId,
      currentTimePeriod: currentTimePeriod ?? this.currentTimePeriod,
      currentSeason: currentSeason ?? this.currentSeason,
      unlockedCities: unlockedCities ?? this.unlockedCities,
      activeEvents: activeEvents ?? this.activeEvents,
      globalModifiers: globalModifiers ?? this.globalModifiers,
      gameTime: gameTime ?? this.gameTime,
    );
  }
}

class WorldManager extends StateNotifier<WorldState> {
  WorldManager() : super(WorldState(
    currentSeason: const Season(
      id: 'spring',
      name: 'Spring',
      marketModifiers: {'demand': 1.0, 'prices': 1.0},
      specialEvents: ['Spring Festival'],
      description: 'A time of new beginnings and fresh opportunities.',
    ),
    unlockedCities: [CITIES.first], // Start with Chicago unlocked
    activeEvents: [],
    globalModifiers: {},
    gameTime: DateTime(1980, 3, 1), // Start in March 1980
  ));

  City? getCurrentCity() {
    try {
      return CITIES.firstWhere((city) => city.id == state.currentCityId);
    } catch (e) {
      return null;
    }
  }

  TimePeriod? getCurrentTimePeriod() {
    try {
      return TIME_PERIODS.firstWhere((period) => period.id == state.currentTimePeriod);
    } catch (e) {
      return null;
    }
  }

  bool canUnlockCity(String cityId) {
    final city = CITIES.where((c) => c.id == cityId).firstOrNull;
    if (city == null || city.isUnlocked) return false;
    
    // Check if player has enough money (this would need to be passed in)
    return true; // Simplified for now
  }

  void unlockCity(String cityId) {
    final cityIndex = CITIES.indexWhere((c) => c.id == cityId);
    if (cityIndex == -1) return;

    final city = CITIES[cityIndex];
    final unlockedCity = city.copyWith(isUnlocked: true);
    
    state = state.copyWith(
      unlockedCities: [...state.unlockedCities, unlockedCity],
    );
  }

  void travelToCity(String cityId) {
    if (state.unlockedCities.any((city) => city.id == cityId)) {
      state = state.copyWith(currentCityId: cityId);
    }
  }

  void advanceTime(int days) {
    final newTime = state.gameTime.add(Duration(days: days));
    
    // Check for season changes
    final currentMonth = newTime.month;
    Season newSeason = state.currentSeason;
    
    if (currentMonth >= 3 && currentMonth <= 5) {
      newSeason = const Season(
        id: 'spring',
        name: 'Spring',
        marketModifiers: {'demand': 1.0, 'prices': 1.0},
        specialEvents: ['Spring Festival'],
        description: 'A time of new beginnings.',
      );
    } else if (currentMonth >= 6 && currentMonth <= 8) {
      newSeason = const Season(
        id: 'summer',
        name: 'Summer',
        marketModifiers: {'demand': 1.2, 'prices': 1.1},
        specialEvents: ['Beach Party Sales', 'Festival Circuit'],
        description: 'High season for party drugs.',
      );
    } else if (currentMonth >= 9 && currentMonth <= 11) {
      newSeason = const Season(
        id: 'fall',
        name: 'Fall',
        marketModifiers: {'demand': 0.9, 'prices': 1.0},
        specialEvents: ['Back to School Rush'],
        description: 'Students return, different market dynamics.',
      );
    } else {
      newSeason = const Season(
        id: 'winter',
        name: 'Winter',
        marketModifiers: {'demand': 1.1, 'prices': 1.2},
        specialEvents: ['Holiday Demand Spike'],
        description: 'Cold weather drives indoor drug use.',
      );
    }

    state = state.copyWith(
      gameTime: newTime,
      currentSeason: newSeason,
    );
    
    _checkForHistoricalEvents(newTime);
  }

  void _checkForHistoricalEvents(DateTime currentTime) {
    // Check if any historical events should trigger
    final potentialEvents = _getHistoricalEventsForPeriod(currentTime);
    
    for (final event in potentialEvents) {
      if (!event.isTriggered && 
          currentTime.isAfter(event.triggerDate) &&
          !state.activeEvents.any((e) => e.id == event.id)) {
        
        final triggeredEvent = event.copyWith(isTriggered: true);
        state = state.copyWith(
          activeEvents: [...state.activeEvents, triggeredEvent],
        );
      }
    }
  }

  List<HistoricalEvent> _getHistoricalEventsForPeriod(DateTime time) {
    // This would contain actual historical events based on the time period
    if (time.year >= 1980 && time.year <= 1989) {
      return [
        HistoricalEvent(
          id: 'crack_epidemic_start',
          name: 'Crack Epidemic Begins',
          description: 'Crack cocaine floods the streets, changing the drug market forever.',
          triggerDate: DateTime(1982, 1, 1),
          marketEffects: {'Crack Cocaine': -0.7, 'Cocaine (Powder)': 0.3},
          heatEffects: {'all_cities': 0.2},
          affectedCities: ['chicago', 'nyc', 'la'],
          duration: 2555, // ~7 years
        ),
        HistoricalEvent(
          id: 'war_on_drugs_announced',
          name: 'War on Drugs Announced',
          description: 'Reagan announces the War on Drugs, increasing law enforcement.',
          triggerDate: DateTime(1982, 10, 14),
          marketEffects: {'all': 0.15}, // Prices increase due to increased risk
          heatEffects: {'all_cities': 0.3},
          affectedCities: ['chicago', 'nyc', 'la', 'miami'],
          duration: 365,
        ),
      ];
    }
    return [];
  }

  Map<String, double> getCurrentModifiers() {
    final cityModifiers = getCurrentCity()?.economicModifiers ?? {};
    final timePeriodModifiers = getCurrentTimePeriod()?.priceModifiers ?? {};
    final seasonModifiers = state.currentSeason.marketModifiers;
    
    // Combine all modifiers
    final combinedModifiers = <String, double>{};
    
    // Apply city modifiers
    cityModifiers.forEach((key, value) {
      combinedModifiers[key] = (combinedModifiers[key] ?? 1.0) * value;
    });
    
    // Apply time period modifiers
    timePeriodModifiers.forEach((key, value) {
      combinedModifiers[key] = (combinedModifiers[key] ?? 1.0) * value;
    });
    
    // Apply season modifiers
    seasonModifiers.forEach((key, value) {
      combinedModifiers[key] = (combinedModifiers[key] ?? 1.0) * value;
    });
    
    // Apply event modifiers
    for (final event in state.activeEvents) {
      event.marketEffects.forEach((key, value) {
        combinedModifiers[key] = (combinedModifiers[key] ?? 1.0) * (1.0 + value);
      });
    }
    
    return combinedModifiers;
  }
}

final worldManagerProvider = StateNotifierProvider<WorldManager, WorldState>((ref) {
  return WorldManager();
});
