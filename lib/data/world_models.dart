// World Building Models
import 'package:flutter/foundation.dart';

@immutable
class City {
  final String id;
  final String name;
  final String country;
  final List<String> districts;
  final Map<String, double> economicModifiers;
  final Map<String, double> riskModifiers;
  final List<String> availableGoods;
  final String description;
  final bool isUnlocked;
  final int unlockCost;

  const City({
    required this.id,
    required this.name,
    required this.country,
    required this.districts,
    required this.economicModifiers,
    required this.riskModifiers,
    required this.availableGoods,
    required this.description,
    this.isUnlocked = false,
    this.unlockCost = 100000,
  });

  City copyWith({
    String? id,
    String? name,
    String? country,
    List<String>? districts,
    Map<String, double>? economicModifiers,
    Map<String, double>? riskModifiers,
    List<String>? availableGoods,
    String? description,
    bool? isUnlocked,
    int? unlockCost,
  }) {
    return City(
      id: id ?? this.id,
      name: name ?? this.name,
      country: country ?? this.country,
      districts: districts ?? this.districts,
      economicModifiers: economicModifiers ?? this.economicModifiers,
      riskModifiers: riskModifiers ?? this.riskModifiers,
      availableGoods: availableGoods ?? this.availableGoods,
      description: description ?? this.description,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockCost: unlockCost ?? this.unlockCost,
    );
  }
}

@immutable
class TimePeriod {
  final String id;
  final String name;
  final int startYear;
  final int endYear;
  final Map<String, double> priceModifiers;
  final List<String> availableTechnology;
  final List<HistoricalEvent> events;
  final String description;
  final bool isUnlocked;

  const TimePeriod({
    required this.id,
    required this.name,
    required this.startYear,
    required this.endYear,
    required this.priceModifiers,
    required this.availableTechnology,
    required this.events,
    required this.description,
    this.isUnlocked = false,
  });

  TimePeriod copyWith({
    String? id,
    String? name,
    int? startYear,
    int? endYear,
    Map<String, double>? priceModifiers,
    List<String>? availableTechnology,
    List<HistoricalEvent>? events,
    String? description,
    bool? isUnlocked,
  }) {
    return TimePeriod(
      id: id ?? this.id,
      name: name ?? this.name,
      startYear: startYear ?? this.startYear,
      endYear: endYear ?? this.endYear,
      priceModifiers: priceModifiers ?? this.priceModifiers,
      availableTechnology: availableTechnology ?? this.availableTechnology,
      events: events ?? this.events,
      description: description ?? this.description,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }
}

@immutable
class HistoricalEvent {
  final String id;
  final String name;
  final String description;
  final DateTime triggerDate;
  final Map<String, double> marketEffects;
  final Map<String, double> heatEffects;
  final List<String> affectedCities;
  final int duration; // in days
  final bool isTriggered;

  const HistoricalEvent({
    required this.id,
    required this.name,
    required this.description,
    required this.triggerDate,
    required this.marketEffects,
    required this.heatEffects,
    required this.affectedCities,
    required this.duration,
    this.isTriggered = false,
  });

  HistoricalEvent copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? triggerDate,
    Map<String, double>? marketEffects,
    Map<String, double>? heatEffects,
    List<String>? affectedCities,
    int? duration,
    bool? isTriggered,
  }) {
    return HistoricalEvent(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      triggerDate: triggerDate ?? this.triggerDate,
      marketEffects: marketEffects ?? this.marketEffects,
      heatEffects: heatEffects ?? this.heatEffects,
      affectedCities: affectedCities ?? this.affectedCities,
      duration: duration ?? this.duration,
      isTriggered: isTriggered ?? this.isTriggered,
    );
  }
}

@immutable
class Season {
  final String id;
  final String name;
  final Map<String, double> marketModifiers;
  final List<String> specialEvents;
  final String description;

  const Season({
    required this.id,
    required this.name,
    required this.marketModifiers,
    required this.specialEvents,
    required this.description,
  });
}

@immutable
class InternationalRoute {
  final String id;
  final String fromCity;
  final String toCity;
  final String routeType; // 'sea', 'air', 'land'
  final double riskMultiplier;
  final double profitMultiplier;
  final List<String> requiredAssets;
  final int cost;
  final int duration; // in hours
  final bool isUnlocked;

  const InternationalRoute({
    required this.id,
    required this.fromCity,
    required this.toCity,
    required this.routeType,
    required this.riskMultiplier,
    required this.profitMultiplier,
    required this.requiredAssets,
    required this.cost,
    required this.duration,
    this.isUnlocked = false,
  });

  InternationalRoute copyWith({
    String? id,
    String? fromCity,
    String? toCity,
    String? routeType,
    double? riskMultiplier,
    double? profitMultiplier,
    List<String>? requiredAssets,
    int? cost,
    int? duration,
    bool? isUnlocked,
  }) {
    return InternationalRoute(
      id: id ?? this.id,
      fromCity: fromCity ?? this.fromCity,
      toCity: toCity ?? this.toCity,
      routeType: routeType ?? this.routeType,
      riskMultiplier: riskMultiplier ?? this.riskMultiplier,
      profitMultiplier: profitMultiplier ?? this.profitMultiplier,
      requiredAssets: requiredAssets ?? this.requiredAssets,
      cost: cost ?? this.cost,
      duration: duration ?? this.duration,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }
}
