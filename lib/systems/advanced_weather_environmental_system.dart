import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

// Advanced Weather and Environmental System
// Feature #26: Ultra-comprehensive weather simulation with
// environmental effects, natural disasters, climate impact on operations, and seasonal variations

enum WeatherType {
  sunny,
  cloudy,
  rainy,
  stormy,
  snowy,
  foggy,
  windy,
  extreme
}

enum Season {
  spring,
  summer,
  autumn,
  winter
}

enum NaturalDisaster {
  hurricane,
  tornado,
  earthquake,
  flood,
  wildfire,
  blizzard,
  heatwave,
  drought
}

enum ClimateZone {
  tropical,
  subtropical,
  temperate,
  continental,
  arctic,
  desert,
  mediterranean,
  oceanic
}

class WeatherCondition {
  final String id;
  final WeatherType type;
  final double temperature; // in Celsius
  final double humidity; // 0.0 to 1.0
  final double precipitation; // mm per hour
  final double windSpeed; // km/h
  final double visibility; // km
  final double pressure; // hPa
  final DateTime timestamp;
  final ClimateZone climateZone;

  WeatherCondition({
    required this.id,
    required this.type,
    required this.temperature,
    required this.humidity,
    required this.precipitation,
    required this.windSpeed,
    required this.visibility,
    required this.pressure,
    required this.timestamp,
    required this.climateZone,
  });

  WeatherCondition copyWith({
    String? id,
    WeatherType? type,
    double? temperature,
    double? humidity,
    double? precipitation,
    double? windSpeed,
    double? visibility,
    double? pressure,
    DateTime? timestamp,
    ClimateZone? climateZone,
  }) {
    return WeatherCondition(
      id: id ?? this.id,
      type: type ?? this.type,
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      precipitation: precipitation ?? this.precipitation,
      windSpeed: windSpeed ?? this.windSpeed,
      visibility: visibility ?? this.visibility,
      pressure: pressure ?? this.pressure,
      timestamp: timestamp ?? this.timestamp,
      climateZone: climateZone ?? this.climateZone,
    );
  }

  double get comfortIndex {
    // Calculate comfort based on temperature and humidity
    final tempFactor = 1.0 - (temperature - 22).abs() / 30;
    final humidityFactor = 1.0 - (humidity - 0.5).abs() * 2;
    return (tempFactor * humidityFactor).clamp(0.0, 1.0);
  }

  bool get isSevere => windSpeed > 60 || precipitation > 20 || temperature < -10 || temperature > 40;
  bool get isGoodVisibility => visibility > 5;
  String get description => _getWeatherDescription();

  String _getWeatherDescription() {
    if (isSevere) {
      return 'Severe ${type.name}';
    }
    return type.name.toUpperCase();
  }
}

class EnvironmentalHazard {
  final String id;
  final NaturalDisaster type;
  final String location;
  final double severity; // 0.0 to 1.0
  final double radius; // affected area in km
  final DateTime startTime;
  final Duration duration;
  final bool isActive;
  final Map<String, double> operationalImpact;

  EnvironmentalHazard({
    required this.id,
    required this.type,
    required this.location,
    required this.severity,
    required this.radius,
    required this.startTime,
    required this.duration,
    this.isActive = true,
    required this.operationalImpact,
  });

  EnvironmentalHazard copyWith({
    String? id,
    NaturalDisaster? type,
    String? location,
    double? severity,
    double? radius,
    DateTime? startTime,
    Duration? duration,
    bool? isActive,
    Map<String, double>? operationalImpact,
  }) {
    return EnvironmentalHazard(
      id: id ?? this.id,
      type: type ?? this.type,
      location: location ?? this.location,
      severity: severity ?? this.severity,
      radius: radius ?? this.radius,
      startTime: startTime ?? this.startTime,
      duration: duration ?? this.duration,
      isActive: isActive ?? this.isActive,
      operationalImpact: operationalImpact ?? this.operationalImpact,
    );
  }

  DateTime get endTime => startTime.add(duration);
  bool get isExpired => DateTime.now().isAfter(endTime);
  double get timeRemaining => endTime.difference(DateTime.now()).inHours.toDouble();
  String get riskLevel => severity > 0.8 ? 'EXTREME' : severity > 0.6 ? 'HIGH' : severity > 0.4 ? 'MODERATE' : 'LOW';
}

class SeasonalPattern {
  final Season season;
  final ClimateZone climateZone;
  final Map<WeatherType, double> weatherProbabilities;
  final double averageTemperature;
  final double temperatureVariation;
  final double averageHumidity;
  final double precipitationFactor;
  final Map<String, double> operationalModifiers;

  SeasonalPattern({
    required this.season,
    required this.climateZone,
    required this.weatherProbabilities,
    required this.averageTemperature,
    required this.temperatureVariation,
    required this.averageHumidity,
    required this.precipitationFactor,
    required this.operationalModifiers,
  });
}

class ClimateImpact {
  final String id;
  final String operationType;
  final WeatherType affectedWeather;
  final double impactMultiplier;
  final String description;
  final bool isPositive;

  ClimateImpact({
    required this.id,
    required this.operationType,
    required this.affectedWeather,
    required this.impactMultiplier,
    required this.description,
    this.isPositive = false,
  });
}

class WeatherAlert {
  final String id;
  final String title;
  final String message;
  final WeatherType weatherType;
  final double severity;
  final DateTime issueTime;
  final Duration validFor;
  final List<String> affectedAreas;
  final Map<String, String> recommendations;

  WeatherAlert({
    required this.id,
    required this.title,
    required this.message,
    required this.weatherType,
    required this.severity,
    required this.issueTime,
    required this.validFor,
    required this.affectedAreas,
    required this.recommendations,
  });

  bool get isActive => DateTime.now().isBefore(issueTime.add(validFor));
  String get urgencyLevel => severity > 0.8 ? 'URGENT' : severity > 0.6 ? 'WARNING' : 'WATCH';
}

class AdvancedWeatherEnvironmentalSystem extends ChangeNotifier {
  static final AdvancedWeatherEnvironmentalSystem _instance = AdvancedWeatherEnvironmentalSystem._internal();
  factory AdvancedWeatherEnvironmentalSystem() => _instance;
  AdvancedWeatherEnvironmentalSystem._internal() {
    _initializeSystem();
  }

  final Map<String, WeatherCondition> _currentWeather = {};
  final Map<String, EnvironmentalHazard> _activeHazards = {};
  final Map<String, SeasonalPattern> _seasonalPatterns = {};
  final Map<String, ClimateImpact> _climateImpacts = {};
  final Map<String, WeatherAlert> _activeAlerts = {};
  final List<WeatherCondition> _weatherHistory = [];
  
  String? _playerId;
  Season _currentSeason = Season.spring;
  ClimateZone _primaryClimateZone = ClimateZone.temperate;
  double _globalTemperatureTrend = 0.0; // Climate change factor
  double _airQualityIndex = 0.7; // 0.0 to 1.0 (1.0 = excellent)
  double _environmentalDamage = 0.0; // Accumulated damage from operations
  
  Timer? _weatherTimer;
  Timer? _hazardTimer;
  Timer? _seasonTimer;
  final math.Random _random = math.Random();

  // Getters
  Map<String, WeatherCondition> get currentWeather => Map.unmodifiable(_currentWeather);
  Map<String, EnvironmentalHazard> get activeHazards => Map.unmodifiable(_activeHazards);
  Map<String, WeatherAlert> get activeAlerts => Map.unmodifiable(_activeAlerts);
  List<WeatherCondition> get weatherHistory => List.unmodifiable(_weatherHistory);
  String? get playerId => _playerId;
  Season get currentSeason => _currentSeason;
  ClimateZone get primaryClimateZone => _primaryClimateZone;
  double get globalTemperatureTrend => _globalTemperatureTrend;
  double get airQualityIndex => _airQualityIndex;
  double get environmentalDamage => _environmentalDamage;

  void _initializeSystem() {
    _playerId = 'weather_${DateTime.now().millisecondsSinceEpoch}';
    _initializeSeasonalPatterns();
    _initializeClimateImpacts();
    _generateInitialWeather();
    _startSystemTimers();
  }

  void _initializeSeasonalPatterns() {
    // Spring patterns for different climate zones
    _seasonalPatterns['spring_temperate'] = SeasonalPattern(
      season: Season.spring,
      climateZone: ClimateZone.temperate,
      weatherProbabilities: {
        WeatherType.sunny: 0.3,
        WeatherType.cloudy: 0.25,
        WeatherType.rainy: 0.3,
        WeatherType.stormy: 0.1,
        WeatherType.windy: 0.05,
      },
      averageTemperature: 15.0,
      temperatureVariation: 8.0,
      averageHumidity: 0.6,
      precipitationFactor: 1.2,
      operationalModifiers: {
        'drug_production': 1.0,
        'smuggling': 0.9,
        'territory_control': 1.1,
        'police_activity': 1.0,
      },
    );

    // Summer patterns
    _seasonalPatterns['summer_temperate'] = SeasonalPattern(
      season: Season.summer,
      climateZone: ClimateZone.temperate,
      weatherProbabilities: {
        WeatherType.sunny: 0.5,
        WeatherType.cloudy: 0.2,
        WeatherType.rainy: 0.15,
        WeatherType.stormy: 0.1,
        WeatherType.extreme: 0.05,
      },
      averageTemperature: 25.0,
      temperatureVariation: 6.0,
      averageHumidity: 0.5,
      precipitationFactor: 0.8,
      operationalModifiers: {
        'drug_production': 1.2,
        'smuggling': 1.1,
        'territory_control': 0.9,
        'police_activity': 1.2,
      },
    );

    // Tropical climate patterns
    _seasonalPatterns['summer_tropical'] = SeasonalPattern(
      season: Season.summer,
      climateZone: ClimateZone.tropical,
      weatherProbabilities: {
        WeatherType.sunny: 0.4,
        WeatherType.rainy: 0.3,
        WeatherType.stormy: 0.2,
        WeatherType.extreme: 0.1,
      },
      averageTemperature: 30.0,
      temperatureVariation: 4.0,
      averageHumidity: 0.8,
      precipitationFactor: 2.0,
      operationalModifiers: {
        'drug_production': 1.5, // Better growing conditions
        'smuggling': 0.8, // Harder due to storms
        'corruption': 1.2, // People need more money for AC
      },
    );
  }

  void _initializeClimateImpacts() {
    _climateImpacts['rain_smuggling'] = ClimateImpact(
      id: 'rain_smuggling',
      operationType: 'smuggling',
      affectedWeather: WeatherType.rainy,
      impactMultiplier: 0.7,
      description: 'Rain reduces visibility, making smuggling easier but slower',
      isPositive: false,
    );

    _climateImpacts['storm_production'] = ClimateImpact(
      id: 'storm_production',
      operationType: 'drug_production',
      affectedWeather: WeatherType.stormy,
      impactMultiplier: 0.5,
      description: 'Storms disrupt outdoor cultivation and lab operations',
      isPositive: false,
    );

    _climateImpacts['sunny_surveillance'] = ClimateImpact(
      id: 'sunny_surveillance',
      operationType: 'territory_control',
      affectedWeather: WeatherType.sunny,
      impactMultiplier: 1.3,
      description: 'Clear weather improves surveillance and territory monitoring',
      isPositive: true,
    );

    _climateImpacts['fog_stealth'] = ClimateImpact(
      id: 'fog_stealth',
      operationType: 'stealth_operations',
      affectedWeather: WeatherType.foggy,
      impactMultiplier: 1.5,
      description: 'Fog provides excellent cover for covert operations',
      isPositive: true,
    );

    _climateImpacts['heat_corruption'] = ClimateImpact(
      id: 'heat_corruption',
      operationType: 'corruption',
      affectedWeather: WeatherType.extreme,
      impactMultiplier: 1.4,
      description: 'Extreme heat makes officials more desperate for bribes',
      isPositive: true,
    );
  }

  void _generateInitialWeather() {
    final locations = ['downtown', 'port', 'industrial', 'suburbs', 'countryside'];
    
    for (final location in locations) {
      _currentWeather[location] = _generateWeatherForLocation(location);
    }
  }

  WeatherCondition _generateWeatherForLocation(String location) {
    final weatherId = 'weather_${location}_${DateTime.now().millisecondsSinceEpoch}';
    final pattern = _getSeasonalPattern(_currentSeason, _primaryClimateZone);
    
    // Select weather type based on probabilities
    final weatherType = _selectWeatherType(pattern.weatherProbabilities);
    
    // Generate weather parameters
    final temperature = _generateTemperature(pattern, weatherType);
    final humidity = _generateHumidity(pattern, weatherType);
    final precipitation = _generatePrecipitation(weatherType, pattern.precipitationFactor);
    final windSpeed = _generateWindSpeed(weatherType);
    final visibility = _generateVisibility(weatherType, precipitation);
    final pressure = _generatePressure(weatherType);

    return WeatherCondition(
      id: weatherId,
      type: weatherType,
      temperature: temperature,
      humidity: humidity,
      precipitation: precipitation,
      windSpeed: windSpeed,
      visibility: visibility,
      pressure: pressure,
      timestamp: DateTime.now(),
      climateZone: _primaryClimateZone,
    );
  }

  SeasonalPattern _getSeasonalPattern(Season season, ClimateZone climate) {
    final key = '${season.name}_${climate.name}';
    return _seasonalPatterns[key] ?? _seasonalPatterns['spring_temperate']!;
  }

  WeatherType _selectWeatherType(Map<WeatherType, double> probabilities) {
    double randomValue = _random.nextDouble();
    double cumulativeProbability = 0.0;
    
    for (final entry in probabilities.entries) {
      cumulativeProbability += entry.value;
      if (randomValue <= cumulativeProbability) {
        return entry.key;
      }
    }
    
    return WeatherType.sunny; // Fallback
  }

  double _generateTemperature(SeasonalPattern pattern, WeatherType weatherType) {
    double baseTemp = pattern.averageTemperature + _globalTemperatureTrend;
    
    // Weather type modifiers
    switch (weatherType) {
      case WeatherType.sunny:
        baseTemp += 3.0;
        break;
      case WeatherType.rainy:
        baseTemp -= 2.0;
        break;
      case WeatherType.stormy:
        baseTemp -= 3.0;
        break;
      case WeatherType.snowy:
        baseTemp = -5.0 + _random.nextDouble() * 10;
        break;
      case WeatherType.extreme:
        baseTemp += (_random.nextBool() ? 10.0 : -10.0);
        break;
      default:
        break;
    }
    
    // Add random variation
    baseTemp += (_random.nextDouble() - 0.5) * pattern.temperatureVariation;
    
    return baseTemp;
  }

  double _generateHumidity(SeasonalPattern pattern, WeatherType weatherType) {
    double baseHumidity = pattern.averageHumidity;
    
    switch (weatherType) {
      case WeatherType.rainy:
      case WeatherType.stormy:
        baseHumidity = 0.8 + _random.nextDouble() * 0.2;
        break;
      case WeatherType.sunny:
        baseHumidity = 0.3 + _random.nextDouble() * 0.4;
        break;
      case WeatherType.foggy:
        baseHumidity = 0.9 + _random.nextDouble() * 0.1;
        break;
      default:
        baseHumidity += (_random.nextDouble() - 0.5) * 0.3;
        break;
    }
    
    return baseHumidity.clamp(0.0, 1.0);
  }

  double _generatePrecipitation(WeatherType weatherType, double factor) {
    switch (weatherType) {
      case WeatherType.sunny:
      case WeatherType.cloudy:
        return 0.0;
      case WeatherType.rainy:
        return (2.0 + _random.nextDouble() * 8.0) * factor;
      case WeatherType.stormy:
        return (10.0 + _random.nextDouble() * 20.0) * factor;
      case WeatherType.snowy:
        return (1.0 + _random.nextDouble() * 5.0) * factor;
      case WeatherType.extreme:
        return (5.0 + _random.nextDouble() * 50.0) * factor;
      default:
        return 0.0;
    }
  }

  double _generateWindSpeed(WeatherType weatherType) {
    switch (weatherType) {
      case WeatherType.windy:
        return 30.0 + _random.nextDouble() * 30.0;
      case WeatherType.stormy:
        return 50.0 + _random.nextDouble() * 50.0;
      case WeatherType.extreme:
        return 80.0 + _random.nextDouble() * 50.0;
      default:
        return 5.0 + _random.nextDouble() * 15.0;
    }
  }

  double _generateVisibility(WeatherType weatherType, double precipitation) {
    switch (weatherType) {
      case WeatherType.foggy:
        return 0.5 + _random.nextDouble() * 2.0;
      case WeatherType.rainy:
        return math.max(2.0, 10.0 - precipitation);
      case WeatherType.stormy:
        return math.max(1.0, 5.0 - precipitation * 0.5);
      case WeatherType.snowy:
        return math.max(1.0, 8.0 - precipitation * 2);
      default:
        return 10.0 + _random.nextDouble() * 20.0;
    }
  }

  double _generatePressure(WeatherType weatherType) {
    switch (weatherType) {
      case WeatherType.stormy:
        return 980.0 + _random.nextDouble() * 20.0;
      case WeatherType.sunny:
        return 1020.0 + _random.nextDouble() * 20.0;
      default:
        return 1000.0 + _random.nextDouble() * 30.0;
    }
  }

  void _startSystemTimers() {
    _weatherTimer?.cancel();
    _hazardTimer?.cancel();
    _seasonTimer?.cancel();
    
    // Update weather every 30 seconds
    _weatherTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _updateWeather();
      _updateAirQuality();
      notifyListeners();
    });
    
    // Check for natural disasters every 2 minutes
    _hazardTimer = Timer.periodic(const Duration(minutes: 2), (_) {
      _checkForNaturalDisasters();
      _updateActiveHazards();
      notifyListeners();
    });
    
    // Update season every 30 seconds (accelerated time)
    _seasonTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _updateSeason();
      notifyListeners();
    });
  }

  void _updateWeather() {
    for (final location in _currentWeather.keys.toList()) {
      // 30% chance to change weather per update
      if (_random.nextDouble() < 0.3) {
        _currentWeather[location] = _generateWeatherForLocation(location);
        
        // Add to history
        _weatherHistory.add(_currentWeather[location]!);
        
        // Keep only last 100 records
        if (_weatherHistory.length > 100) {
          _weatherHistory.removeAt(0);
        }
      }
    }
    
    // Check for weather alerts
    _checkForWeatherAlerts();
  }

  void _checkForWeatherAlerts() {
    for (final entry in _currentWeather.entries) {
      final location = entry.key;
      final weather = entry.value;
      
      if (weather.isSevere) {
        final alertId = 'alert_${location}_${DateTime.now().millisecondsSinceEpoch}';
        
        _activeAlerts[alertId] = WeatherAlert(
          id: alertId,
          title: 'Severe Weather Warning',
          message: 'Severe ${weather.type.name} conditions detected in $location',
          weatherType: weather.type,
          severity: _calculateWeatherSeverity(weather),
          issueTime: DateTime.now(),
          validFor: const Duration(hours: 2),
          affectedAreas: [location],
          recommendations: _getWeatherRecommendations(weather.type),
        );
      }
    }
    
    // Remove expired alerts
    _activeAlerts.removeWhere((key, alert) => !alert.isActive);
  }

  double _calculateWeatherSeverity(WeatherCondition weather) {
    double severity = 0.0;
    
    // Temperature severity
    if (weather.temperature < -10 || weather.temperature > 40) {
      severity += 0.3;
    }
    
    // Wind severity
    if (weather.windSpeed > 60) {
      severity += 0.3;
    }
    
    // Precipitation severity
    if (weather.precipitation > 20) {
      severity += 0.3;
    }
    
    // Visibility severity
    if (weather.visibility < 2) {
      severity += 0.1;
    }
    
    return severity.clamp(0.0, 1.0);
  }

  Map<String, String> _getWeatherRecommendations(WeatherType weatherType) {
    switch (weatherType) {
      case WeatherType.stormy:
        return {
          'operations': 'Suspend outdoor operations',
          'smuggling': 'Delay shipments until conditions improve',
          'security': 'Increase indoor security measures',
        };
      case WeatherType.extreme:
        return {
          'operations': 'All operations to safe mode',
          'personnel': 'Ensure all crew have shelter',
          'equipment': 'Secure all equipment',
        };
      case WeatherType.foggy:
        return {
          'smuggling': 'Excellent conditions for stealth operations',
          'surveillance': 'Limited visibility - increase patrols',
        };
      default:
        return {
          'general': 'Monitor conditions and adjust operations accordingly',
        };
    }
  }

  void _checkForNaturalDisasters() {
    // Random chance of natural disasters based on season and climate
    final disasterChance = _calculateDisasterProbability();
    
    if (_random.nextDouble() < disasterChance) {
      _generateNaturalDisaster();
    }
  }

  double _calculateDisasterProbability() {
    double baseProbability = 0.01; // 1% base chance
    
    // Season modifiers
    switch (_currentSeason) {
      case Season.summer:
        baseProbability *= 1.5; // More hurricanes, wildfires
        break;
      case Season.winter:
        baseProbability *= 1.2; // More blizzards
        break;
      default:
        break;
    }
    
    // Climate zone modifiers
    switch (_primaryClimateZone) {
      case ClimateZone.tropical:
        baseProbability *= 2.0; // More hurricanes
        break;
      case ClimateZone.continental:
        baseProbability *= 1.3; // More extreme weather
        break;
      default:
        break;
    }
    
    // Global warming effect
    baseProbability *= (1.0 + _globalTemperatureTrend * 0.1);
    
    return baseProbability;
  }

  void _generateNaturalDisaster() {
    final disasterTypes = _getSeasonalDisasters(_currentSeason, _primaryClimateZone);
    final disasterType = disasterTypes[_random.nextInt(disasterTypes.length)];
    
    final hazardId = 'hazard_${DateTime.now().millisecondsSinceEpoch}';
    final severity = 0.3 + _random.nextDouble() * 0.7; // 0.3 to 1.0
    final radius = _getDisasterRadius(disasterType, severity);
    final duration = _getDisasterDuration(disasterType, severity);
    
    _activeHazards[hazardId] = EnvironmentalHazard(
      id: hazardId,
      type: disasterType,
      location: _getRandomLocation(),
      severity: severity,
      radius: radius,
      startTime: DateTime.now(),
      duration: duration,
      operationalImpact: _calculateDisasterImpact(disasterType, severity),
    );
  }

  List<NaturalDisaster> _getSeasonalDisasters(Season season, ClimateZone climate) {
    switch (season) {
      case Season.summer:
        switch (climate) {
          case ClimateZone.tropical:
            return [NaturalDisaster.hurricane, NaturalDisaster.flood, NaturalDisaster.wildfire];
          case ClimateZone.temperate:
            return [NaturalDisaster.tornado, NaturalDisaster.wildfire, NaturalDisaster.heatwave];
          default:
            return [NaturalDisaster.wildfire, NaturalDisaster.heatwave];
        }
      case Season.winter:
        return [NaturalDisaster.blizzard, NaturalDisaster.earthquake];
      default:
        return [NaturalDisaster.earthquake, NaturalDisaster.flood, NaturalDisaster.tornado];
    }
  }

  double _getDisasterRadius(NaturalDisaster disaster, double severity) {
    final baseRadius = {
      NaturalDisaster.hurricane: 200.0,
      NaturalDisaster.tornado: 5.0,
      NaturalDisaster.earthquake: 100.0,
      NaturalDisaster.flood: 50.0,
      NaturalDisaster.wildfire: 30.0,
      NaturalDisaster.blizzard: 150.0,
      NaturalDisaster.heatwave: 500.0,
      NaturalDisaster.drought: 1000.0,
    };
    
    return (baseRadius[disaster] ?? 10.0) * severity;
  }

  Duration _getDisasterDuration(NaturalDisaster disaster, double severity) {
    final baseDuration = {
      NaturalDisaster.hurricane: Duration(hours: 12),
      NaturalDisaster.tornado: Duration(minutes: 30),
      NaturalDisaster.earthquake: Duration(minutes: 5),
      NaturalDisaster.flood: Duration(days: 3),
      NaturalDisaster.wildfire: Duration(days: 7),
      NaturalDisaster.blizzard: Duration(days: 2),
      NaturalDisaster.heatwave: Duration(days: 5),
      NaturalDisaster.drought: Duration(days: 30),
    };
    
    final base = baseDuration[disaster] ?? const Duration(hours: 1);
    return Duration(
      milliseconds: (base.inMilliseconds * (0.5 + severity)).round(),
    );
  }

  Map<String, double> _calculateDisasterImpact(NaturalDisaster disaster, double severity) {
    final impacts = <String, double>{};
    
    switch (disaster) {
      case NaturalDisaster.hurricane:
        impacts['smuggling'] = 0.1 * severity;
        impacts['drug_production'] = 0.2 * severity;
        impacts['territory_control'] = 0.3 * severity;
        impacts['infrastructure_damage'] = 0.8 * severity;
        break;
      case NaturalDisaster.earthquake:
        impacts['all_operations'] = 0.5 * severity;
        impacts['infrastructure_damage'] = 0.9 * severity;
        impacts['supply_chain'] = 0.7 * severity;
        break;
      case NaturalDisaster.wildfire:
        impacts['drug_production'] = 0.8 * severity;
        impacts['territory_control'] = 0.4 * severity;
        impacts['air_quality'] = 0.9 * severity;
        break;
      case NaturalDisaster.flood:
        impacts['smuggling'] = 0.6 * severity;
        impacts['storage'] = 0.8 * severity;
        impacts['transportation'] = 0.7 * severity;
        break;
      default:
        impacts['general_operations'] = 0.3 * severity;
        break;
    }
    
    return impacts;
  }

  String _getRandomLocation() {
    final locations = ['downtown', 'port', 'industrial', 'suburbs', 'countryside'];
    return locations[_random.nextInt(locations.length)];
  }

  void _updateActiveHazards() {
    // Remove expired hazards
    _activeHazards.removeWhere((key, hazard) => hazard.isExpired);
    
    // Update environmental damage
    for (final hazard in _activeHazards.values) {
      if (hazard.isActive) {
        _environmentalDamage += hazard.severity * 0.001;
      }
    }
    
    _environmentalDamage = _environmentalDamage.clamp(0.0, 1.0);
  }

  void _updateAirQuality() {
    // Air quality affected by weather and operations
    double qualityChange = 0.0;
    
    // Weather effects
    for (final weather in _currentWeather.values) {
      if (weather.type == WeatherType.rainy) {
        qualityChange += 0.01; // Rain cleans air
      } else if (weather.type == WeatherType.windy) {
        qualityChange += 0.005; // Wind disperses pollutants
      }
    }
    
    // Natural degradation from operations
    qualityChange -= _environmentalDamage * 0.001;
    
    // Active disasters effect
    for (final hazard in _activeHazards.values) {
      if (hazard.type == NaturalDisaster.wildfire) {
        qualityChange -= 0.02;
      }
    }
    
    _airQualityIndex = (_airQualityIndex + qualityChange).clamp(0.0, 1.0);
  }

  void _updateSeason() {
    // Simplified season progression (every 30 seconds = 1 week game time)
    final weeksSinceSpring = DateTime.now().millisecondsSinceEpoch ~/ 30000;
    final seasonIndex = (weeksSinceSpring ~/ 13) % 4; // 13 weeks per season
    
    final newSeason = Season.values[seasonIndex];
    if (newSeason != _currentSeason) {
      _currentSeason = newSeason;
      
      // Climate change progression
      _globalTemperatureTrend += 0.01; // 0.01°C per season change
      _globalTemperatureTrend = _globalTemperatureTrend.clamp(0.0, 5.0);
    }
  }

  // Public Interface Methods
  WeatherCondition? getWeatherForLocation(String location) {
    return _currentWeather[location];
  }

  List<EnvironmentalHazard> getActiveHazardsForLocation(String location) {
    return _activeHazards.values
        .where((hazard) => hazard.isActive && hazard.location == location)
        .toList()
      ..sort((a, b) => b.severity.compareTo(a.severity));
  }

  List<WeatherAlert> getActiveAlertsForLocation(String location) {
    return _activeAlerts.values
        .where((alert) => alert.isActive && alert.affectedAreas.contains(location))
        .toList()
      ..sort((a, b) => b.severity.compareTo(a.severity));
  }

  Map<String, double> getWeatherImpactForOperation(String operationType, String location) {
    final weather = _currentWeather[location];
    if (weather == null) return {};
    
    final impacts = <String, double>{};
    
    // Check climate impacts
    for (final impact in _climateImpacts.values) {
      if (impact.operationType == operationType && impact.affectedWeather == weather.type) {
        impacts[impact.description] = impact.impactMultiplier;
      }
    }
    
    // Check disaster impacts
    for (final hazard in getActiveHazardsForLocation(location)) {
      for (final entry in hazard.operationalImpact.entries) {
        if (entry.key == operationType || entry.key == 'all_operations') {
          impacts['Disaster: ${hazard.type.name}'] = 1.0 - entry.value;
        }
      }
    }
    
    return impacts;
  }

  double getOverallWeatherImpact(String operationType, String location) {
    final impacts = getWeatherImpactForOperation(operationType, location);
    if (impacts.isEmpty) return 1.0;
    
    double totalImpact = 1.0;
    for (final multiplier in impacts.values) {
      totalImpact *= multiplier;
    }
    
    return totalImpact.clamp(0.1, 2.0);
  }

  List<WeatherCondition> getWeatherForecast(String location, {int days = 7}) {
    // Simplified forecast generation
    final forecast = <WeatherCondition>[];
    final currentWeather = _currentWeather[location];
    
    if (currentWeather == null) return forecast;
    
    for (int i = 1; i <= days; i++) {
      final forecastWeather = _generateWeatherForLocation(location);
      forecast.add(forecastWeather.copyWith(
        id: 'forecast_${location}_$i',
        timestamp: DateTime.now().add(Duration(days: i)),
      ));
    }
    
    return forecast;
  }

  Map<String, dynamic> getEnvironmentalStats() {
    return {
      'airQuality': _airQualityIndex,
      'environmentalDamage': _environmentalDamage,
      'globalTemperatureTrend': _globalTemperatureTrend,
      'currentSeason': _currentSeason.name,
      'primaryClimate': _primaryClimateZone.name,
      'activeHazards': _activeHazards.length,
      'activeAlerts': _activeAlerts.length,
      'averageTemperature': _currentWeather.values.isEmpty ? 0.0 :
          _currentWeather.values.map((w) => w.temperature).reduce((a, b) => a + b) / _currentWeather.length,
    };
  }

  void addEnvironmentalDamage(double damage) {
    _environmentalDamage = (_environmentalDamage + damage).clamp(0.0, 1.0);
    
    // Environmental damage affects air quality
    _airQualityIndex = (_airQualityIndex - damage * 0.5).clamp(0.0, 1.0);
  }

  void implementEnvironmentalProtection(double investment) {
    // Investment in environmental protection reduces damage
    final protection = investment / 100000; // $100k for full protection
    _environmentalDamage = (_environmentalDamage - protection).clamp(0.0, 1.0);
    _airQualityIndex = (_airQualityIndex + protection * 0.5).clamp(0.0, 1.0);
  }

  void dispose() {
    _weatherTimer?.cancel();
    _hazardTimer?.cancel();
    _seasonTimer?.cancel();
    super.dispose();
  }
}

// Advanced Weather Dashboard Widget
class AdvancedWeatherEnvironmentalDashboardWidget extends StatefulWidget {
  const AdvancedWeatherEnvironmentalDashboardWidget({super.key});

  @override
  State<AdvancedWeatherEnvironmentalDashboardWidget> createState() => _AdvancedWeatherEnvironmentalDashboardWidgetState();
}

class _AdvancedWeatherEnvironmentalDashboardWidgetState extends State<AdvancedWeatherEnvironmentalDashboardWidget>
    with TickerProviderStateMixin {
  final AdvancedWeatherEnvironmentalSystem _weatherSystem = AdvancedWeatherEnvironmentalSystem();
  late TabController _tabController;
  String _selectedLocation = 'downtown';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _weatherSystem,
      builder: (context, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                _buildEnvironmentalOverview(),
                const SizedBox(height: 16),
                _buildTabBar(),
                const SizedBox(height: 16),
                Expanded(child: _buildTabBarView()),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(_getSeasonIcon(_weatherSystem.currentSeason), color: _getSeasonColor(_weatherSystem.currentSeason)),
        const SizedBox(width: 8),
        const Text(
          'Weather & Environment',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Text('${_weatherSystem.currentSeason.name.toUpperCase()} | ${_weatherSystem.primaryClimateZone.name}'),
      ],
    );
  }

  Widget _buildEnvironmentalOverview() {
    final stats = _weatherSystem.getEnvironmentalStats();
    
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                _buildMetricCard('Air Quality', '${(stats['airQuality'] * 100).toInt()}%'),
                _buildMetricCard('Env. Damage', '${(stats['environmentalDamage'] * 100).toInt()}%'),
                _buildMetricCard('Temp Trend', '+${stats['globalTemperatureTrend'].toStringAsFixed(1)}°C'),
                _buildMetricCard('Hazards', '${stats['activeHazards']}'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Air Quality Index', style: TextStyle(fontWeight: FontWeight.bold)),
                      LinearProgressIndicator(
                        value: stats['airQuality'],
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          stats['airQuality'] > 0.7 ? Colors.green : 
                          stats['airQuality'] > 0.4 ? Colors.orange : Colors.red,
                        ),
                      ),
                      Text(_getAirQualityDescription(stats['airQuality'])),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Environmental Health', style: TextStyle(fontWeight: FontWeight.bold)),
                      LinearProgressIndicator(
                        value: 1.0 - stats['environmentalDamage'],
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          stats['environmentalDamage'] < 0.3 ? Colors.green : 
                          stats['environmentalDamage'] < 0.6 ? Colors.orange : Colors.red,
                        ),
                      ),
                      Text(_getEnvironmentalHealthDescription(stats['environmentalDamage'])),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String label, String value) {
    return Expanded(
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(label, style: const TextStyle(fontSize: 12)),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      tabs: const [
        Tab(text: 'Current', icon: Icon(Icons.wb_sunny)),
        Tab(text: 'Hazards', icon: Icon(Icons.warning)),
        Tab(text: 'Forecast', icon: Icon(Icons.schedule)),
        Tab(text: 'Impacts', icon: Icon(Icons.business)),
      ],
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildCurrentWeatherTab(),
        _buildHazardsTab(),
        _buildForecastTab(),
        _buildImpactsTab(),
      ],
    );
  }

  Widget _buildCurrentWeatherTab() {
    return Column(
      children: [
        _buildLocationSelector(),
        const SizedBox(height: 16),
        Expanded(child: _buildCurrentWeatherDetails()),
      ],
    );
  }

  Widget _buildLocationSelector() {
    final locations = ['downtown', 'port', 'industrial', 'suburbs', 'countryside'];
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Text('Location: ', style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: DropdownButton<String>(
                value: _selectedLocation,
                isExpanded: true,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedLocation = value;
                    });
                  }
                },
                items: locations.map((location) {
                  return DropdownMenuItem(
                    value: location,
                    child: Text(location.toUpperCase()),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentWeatherDetails() {
    final weather = _weatherSystem.getWeatherForLocation(_selectedLocation);
    if (weather == null) {
      return const Center(child: Text('No weather data available'));
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getWeatherIcon(weather.type),
                  size: 48,
                  color: _getWeatherColor(weather.type),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        weather.description,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${weather.temperature.toStringAsFixed(1)}°C',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildWeatherDetailsGrid(weather),
            const SizedBox(height: 20),
            _buildComfortIndex(weather),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherDetailsGrid(WeatherCondition weather) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: 3,
      children: [
        _buildWeatherDetail('Humidity', '${(weather.humidity * 100).toInt()}%'),
        _buildWeatherDetail('Wind Speed', '${weather.windSpeed.toInt()} km/h'),
        _buildWeatherDetail('Precipitation', '${weather.precipitation.toStringAsFixed(1)} mm/h'),
        _buildWeatherDetail('Visibility', '${weather.visibility.toStringAsFixed(1)} km'),
        _buildWeatherDetail('Pressure', '${weather.pressure.toInt()} hPa'),
        _buildWeatherDetail('Climate', weather.climateZone.name),
      ],
    );
  }

  Widget _buildWeatherDetail(String label, String value) {
    return Card(
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            Text(value, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildComfortIndex(WeatherCondition weather) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Comfort Index', style: TextStyle(fontWeight: FontWeight.bold)),
        LinearProgressIndicator(
          value: weather.comfortIndex,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            weather.comfortIndex > 0.7 ? Colors.green :
            weather.comfortIndex > 0.4 ? Colors.orange : Colors.red,
          ),
        ),
        Text('${(weather.comfortIndex * 100).toInt()}% - ${_getComfortDescription(weather.comfortIndex)}'),
      ],
    );
  }

  Widget _buildHazardsTab() {
    final hazards = _weatherSystem.getActiveHazardsForLocation(_selectedLocation);
    final alerts = _weatherSystem.getActiveAlertsForLocation(_selectedLocation);
    
    return ListView(
      children: [
        if (alerts.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Active Alerts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ...alerts.map((alert) => _buildAlertCard(alert)),
        ],
        if (hazards.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Environmental Hazards', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ...hazards.map((hazard) => _buildHazardCard(hazard)),
        ],
        if (alerts.isEmpty && hazards.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text('No active hazards or alerts for this location'),
            ),
          ),
      ],
    );
  }

  Widget _buildAlertCard(WeatherAlert alert) {
    return Card(
      color: _getAlertColor(alert.severity),
      child: ListTile(
        leading: Icon(
          Icons.warning,
          color: alert.severity > 0.7 ? Colors.red : Colors.orange,
        ),
        title: Text(alert.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(alert.message),
            Text('Urgency: ${alert.urgencyLevel}'),
            Text('Valid until: ${alert.issueTime.add(alert.validFor).toString().substring(0, 16)}'),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildHazardCard(EnvironmentalHazard hazard) {
    return Card(
      color: _getHazardColor(hazard.severity),
      child: ListTile(
        leading: Icon(
          _getHazardIcon(hazard.type),
          color: hazard.severity > 0.7 ? Colors.red : Colors.orange,
        ),
        title: Text('${hazard.type.name.toUpperCase()} - ${hazard.riskLevel}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Location: ${hazard.location}'),
            Text('Severity: ${(hazard.severity * 100).toInt()}%'),
            Text('Radius: ${hazard.radius.toInt()} km'),
            Text('Time Remaining: ${hazard.timeRemaining.toInt()} hours'),
            LinearProgressIndicator(
              value: hazard.severity,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                hazard.severity > 0.7 ? Colors.red : Colors.orange,
              ),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildForecastTab() {
    final forecast = _weatherSystem.getWeatherForecast(_selectedLocation);
    
    return ListView.builder(
      itemCount: forecast.length,
      itemBuilder: (context, index) {
        final weather = forecast[index];
        return _buildForecastCard(weather, index + 1);
      },
    );
  }

  Widget _buildForecastCard(WeatherCondition weather, int dayAhead) {
    return Card(
      child: ListTile(
        leading: Icon(
          _getWeatherIcon(weather.type),
          color: _getWeatherColor(weather.type),
        ),
        title: Text('Day +$dayAhead - ${weather.type.name}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Temperature: ${weather.temperature.toStringAsFixed(1)}°C'),
            Text('Humidity: ${(weather.humidity * 100).toInt()}%'),
            Text('Precipitation: ${weather.precipitation.toStringAsFixed(1)} mm/h'),
            Text('Wind: ${weather.windSpeed.toInt()} km/h'),
          ],
        ),
        trailing: weather.isSevere ? const Icon(Icons.warning, color: Colors.red) : null,
        isThreeLine: true,
      ),
    );
  }

  Widget _buildImpactsTab() {
    final operations = ['drug_production', 'smuggling', 'territory_control', 'money_laundering'];
    
    return ListView(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Environmental Protection', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => _showEnvironmentalProtectionDialog(),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Invest in Protection'),
                ),
              ],
            ),
          ),
        ),
        ...operations.map((operation) => _buildOperationImpactCard(operation)),
      ],
    );
  }

  Widget _buildOperationImpactCard(String operation) {
    final impacts = _weatherSystem.getWeatherImpactForOperation(operation, _selectedLocation);
    final overallImpact = _weatherSystem.getOverallWeatherImpact(operation, _selectedLocation);
    
    return Card(
      color: overallImpact < 0.8 ? Colors.red[50] : 
             overallImpact > 1.2 ? Colors.green[50] : null,
      child: ExpansionTile(
        leading: Icon(
          _getOperationIcon(operation),
          color: overallImpact < 0.8 ? Colors.red : 
                 overallImpact > 1.2 ? Colors.green : Colors.grey,
        ),
        title: Text(operation.replaceAll('_', ' ').toUpperCase()),
        subtitle: Text('Overall Impact: ${(overallImpact * 100).toInt()}%'),
        children: [
          if (impacts.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No significant weather impacts'),
            ),
          ...impacts.entries.map((entry) => ListTile(
            title: Text(entry.key),
            trailing: Text(
              '${(entry.value * 100).toInt()}%',
              style: TextStyle(
                color: entry.value < 1.0 ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          )),
        ],
      ),
    );
  }

  void _showEnvironmentalProtectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Environmental Protection'),
        content: const Text('Invest in environmental protection measures to reduce damage and improve air quality.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _weatherSystem.implementEnvironmentalProtection(50000);
              Navigator.of(context).pop();
            },
            child: const Text('\$50K'),
          ),
          ElevatedButton(
            onPressed: () {
              _weatherSystem.implementEnvironmentalProtection(100000);
              Navigator.of(context).pop();
            },
            child: const Text('\$100K'),
          ),
        ],
      ),
    );
  }

  IconData _getSeasonIcon(Season season) {
    switch (season) {
      case Season.spring: return Icons.local_florist;
      case Season.summer: return Icons.wb_sunny;
      case Season.autumn: return Icons.nature;
      case Season.winter: return Icons.ac_unit;
    }
  }

  Color _getSeasonColor(Season season) {
    switch (season) {
      case Season.spring: return Colors.green;
      case Season.summer: return Colors.yellow;
      case Season.autumn: return Colors.orange;
      case Season.winter: return Colors.blue;
    }
  }

  IconData _getWeatherIcon(WeatherType weather) {
    switch (weather) {
      case WeatherType.sunny: return Icons.wb_sunny;
      case WeatherType.cloudy: return Icons.wb_cloudy;
      case WeatherType.rainy: return Icons.umbrella;
      case WeatherType.stormy: return Icons.thunderstorm;
      case WeatherType.snowy: return Icons.ac_unit;
      case WeatherType.foggy: return Icons.cloud;
      case WeatherType.windy: return Icons.air;
      case WeatherType.extreme: return Icons.warning;
    }
  }

  Color _getWeatherColor(WeatherType weather) {
    switch (weather) {
      case WeatherType.sunny: return Colors.orange;
      case WeatherType.cloudy: return Colors.grey;
      case WeatherType.rainy: return Colors.blue;
      case WeatherType.stormy: return Colors.purple;
      case WeatherType.snowy: return Colors.lightBlue;
      case WeatherType.foggy: return Colors.blueGrey;
      case WeatherType.windy: return Colors.cyan;
      case WeatherType.extreme: return Colors.red;
    }
  }

  IconData _getHazardIcon(NaturalDisaster hazard) {
    switch (hazard) {
      case NaturalDisaster.hurricane: return Icons.cyclone;
      case NaturalDisaster.tornado: return Icons.tornado;
      case NaturalDisaster.earthquake: return Icons.landscape;
      case NaturalDisaster.flood: return Icons.water;
      case NaturalDisaster.wildfire: return Icons.local_fire_department;
      case NaturalDisaster.blizzard: return Icons.severe_cold;
      case NaturalDisaster.heatwave: return Icons.whatshot;
      case NaturalDisaster.drought: return Icons.water_drop_outlined;
    }
  }

  IconData _getOperationIcon(String operation) {
    switch (operation) {
      case 'drug_production': return Icons.local_pharmacy;
      case 'smuggling': return Icons.local_shipping;
      case 'territory_control': return Icons.location_on;
      case 'money_laundering': return Icons.attach_money;
      default: return Icons.business;
    }
  }

  Color _getAlertColor(double severity) {
    return severity > 0.7 ? Colors.red[100] : Colors.orange[100];
  }

  Color _getHazardColor(double severity) {
    return severity > 0.7 ? Colors.red[100] : Colors.orange[100];
  }

  String _getAirQualityDescription(double quality) {
    if (quality > 0.8) return 'Excellent';
    if (quality > 0.6) return 'Good';
    if (quality > 0.4) return 'Moderate';
    if (quality > 0.2) return 'Poor';
    return 'Hazardous';
  }

  String _getEnvironmentalHealthDescription(double damage) {
    if (damage < 0.2) return 'Healthy';
    if (damage < 0.4) return 'Moderate Impact';
    if (damage < 0.6) return 'Damaged';
    if (damage < 0.8) return 'Severely Damaged';
    return 'Critical';
  }

  String _getComfortDescription(double comfort) {
    if (comfort > 0.8) return 'Very Comfortable';
    if (comfort > 0.6) return 'Comfortable';
    if (comfort > 0.4) return 'Moderate';
    if (comfort > 0.2) return 'Uncomfortable';
    return 'Very Uncomfortable';
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
