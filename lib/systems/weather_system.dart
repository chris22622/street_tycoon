import 'package:flutter/material.dart';
import 'dart:math' as math;

enum WeatherType {
  clear,
  cloudy,
  rainy,
  stormy,
  snowy,
  foggy,
  windy,
  heatwave,
  blizzard,
  hurricane,
}

class WeatherData {
  final WeatherType type;
  final String name;
  final String description;
  final double temperature; // Celsius
  final double humidity; // 0-1
  final double windSpeed; // km/h
  final double visibility; // km
  final Color skyColor;
  final List<Color> cloudColors;
  final double precipitationIntensity; // 0-1
  final Map<String, double> gameEffects; // Effects on game mechanics

  const WeatherData({
    required this.type,
    required this.name,
    required this.description,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.visibility,
    required this.skyColor,
    required this.cloudColors,
    required this.precipitationIntensity,
    required this.gameEffects,
  });
}

class WeatherSystem {
  static final WeatherSystem _instance = WeatherSystem._internal();
  factory WeatherSystem() => _instance;
  WeatherSystem._internal();

  WeatherData _currentWeather = _weatherTypes[WeatherType.clear]!;
  final List<WeatherData> _forecast = [];
  final math.Random _random = math.Random();
  DateTime _lastUpdate = DateTime.now();
  
  static const Map<WeatherType, WeatherData> _weatherTypes = {
    WeatherType.clear: WeatherData(
      type: WeatherType.clear,
      name: 'Clear Skies',
      description: 'Perfect weather for business operations',
      temperature: 25.0,
      humidity: 0.3,
      windSpeed: 5.0,
      visibility: 20.0,
      skyColor: Color(0xFF87CEEB),
      cloudColors: [Color(0xFFFFFFFF), Color(0xFFF0F8FF)],
      precipitationIntensity: 0.0,
      gameEffects: {
        'customerTraffic': 1.2,
        'policeActivity': 1.0,
        'dealSuccess': 1.1,
        'transportSpeed': 1.0,
      },
    ),
    WeatherType.cloudy: WeatherData(
      type: WeatherType.cloudy,
      name: 'Overcast',
      description: 'Good cover for suspicious activities',
      temperature: 20.0,
      humidity: 0.6,
      windSpeed: 10.0,
      visibility: 15.0,
      skyColor: Color(0xFF708090),
      cloudColors: [Color(0xFFD3D3D3), Color(0xFFA9A9A9)],
      precipitationIntensity: 0.0,
      gameEffects: {
        'customerTraffic': 0.9,
        'policeActivity': 0.8,
        'dealSuccess': 1.3,
        'transportSpeed': 1.0,
      },
    ),
    WeatherType.rainy: WeatherData(
      type: WeatherType.rainy,
      name: 'Rain',
      description: 'Fewer people on streets, but good for hiding evidence',
      temperature: 15.0,
      humidity: 0.9,
      windSpeed: 15.0,
      visibility: 8.0,
      skyColor: Color(0xFF2F4F4F),
      cloudColors: [Color(0xFF696969), Color(0xFF2F4F4F)],
      precipitationIntensity: 0.7,
      gameEffects: {
        'customerTraffic': 0.6,
        'policeActivity': 0.6,
        'dealSuccess': 0.8,
        'transportSpeed': 0.7,
      },
    ),
    WeatherType.stormy: WeatherData(
      type: WeatherType.stormy,
      name: 'Thunderstorm',
      description: 'Dangerous conditions but minimal law enforcement',
      temperature: 18.0,
      humidity: 0.95,
      windSpeed: 40.0,
      visibility: 3.0,
      skyColor: Color(0xFF191970),
      cloudColors: [Color(0xFF2F2F2F), Color(0xFF000000)],
      precipitationIntensity: 1.0,
      gameEffects: {
        'customerTraffic': 0.3,
        'policeActivity': 0.2,
        'dealSuccess': 0.5,
        'transportSpeed': 0.4,
      },
    ),
    WeatherType.snowy: WeatherData(
      type: WeatherType.snowy,
      name: 'Snowfall',
      description: 'Winter conditions slow everything down',
      temperature: -5.0,
      humidity: 0.8,
      windSpeed: 20.0,
      visibility: 5.0,
      skyColor: Color(0xFFE6E6FA),
      cloudColors: [Color(0xFFF5F5F5), Color(0xFFDCDCDC)],
      precipitationIntensity: 0.6,
      gameEffects: {
        'customerTraffic': 0.4,
        'policeActivity': 0.5,
        'dealSuccess': 0.7,
        'transportSpeed': 0.3,
      },
    ),
    WeatherType.foggy: WeatherData(
      type: WeatherType.foggy,
      name: 'Dense Fog',
      description: 'Perfect cover for covert operations',
      temperature: 12.0,
      humidity: 1.0,
      windSpeed: 3.0,
      visibility: 1.0,
      skyColor: Color(0xFFF5F5DC),
      cloudColors: [Color(0xFFFFFFFF), Color(0xFFF0F0F0)],
      precipitationIntensity: 0.1,
      gameEffects: {
        'customerTraffic': 0.5,
        'policeActivity': 0.3,
        'dealSuccess': 1.5,
        'transportSpeed': 0.2,
      },
    ),
    WeatherType.windy: WeatherData(
      type: WeatherType.windy,
      name: 'Strong Winds',
      description: 'High winds make outdoor deals difficult',
      temperature: 22.0,
      humidity: 0.4,
      windSpeed: 60.0,
      visibility: 12.0,
      skyColor: Color(0xFF87CEEB),
      cloudColors: [Color(0xFFFFFFFF), Color(0xFFB0C4DE)],
      precipitationIntensity: 0.0,
      gameEffects: {
        'customerTraffic': 0.7,
        'policeActivity': 0.9,
        'dealSuccess': 0.6,
        'transportSpeed': 0.8,
      },
    ),
    WeatherType.heatwave: WeatherData(
      type: WeatherType.heatwave,
      name: 'Extreme Heat',
      description: 'Scorching temperatures increase aggression',
      temperature: 45.0,
      humidity: 0.2,
      windSpeed: 2.0,
      visibility: 15.0,
      skyColor: Color(0xFFFF6347),
      cloudColors: [Color(0xFFFFE4E1), Color(0xFFFF7F50)],
      precipitationIntensity: 0.0,
      gameEffects: {
        'customerTraffic': 0.6,
        'policeActivity': 1.3,
        'dealSuccess': 0.9,
        'transportSpeed': 0.8,
      },
    ),
    WeatherType.blizzard: WeatherData(
      type: WeatherType.blizzard,
      name: 'Blizzard',
      description: 'Extreme winter conditions shut down the city',
      temperature: -20.0,
      humidity: 0.9,
      windSpeed: 80.0,
      visibility: 0.5,
      skyColor: Color(0xFF4B0082),
      cloudColors: [Color(0xFF8B8B8B), Color(0xFF2F2F2F)],
      precipitationIntensity: 1.0,
      gameEffects: {
        'customerTraffic': 0.1,
        'policeActivity': 0.1,
        'dealSuccess': 0.2,
        'transportSpeed': 0.1,
      },
    ),
    WeatherType.hurricane: WeatherData(
      type: WeatherType.hurricane,
      name: 'Hurricane',
      description: 'Catastrophic weather conditions',
      temperature: 30.0,
      humidity: 1.0,
      windSpeed: 150.0,
      visibility: 2.0,
      skyColor: Color(0xFF8B4513),
      cloudColors: [Color(0xFF000000), Color(0xFF2F2F2F)],
      precipitationIntensity: 1.0,
      gameEffects: {
        'customerTraffic': 0.05,
        'policeActivity': 0.05,
        'dealSuccess': 0.1,
        'transportSpeed': 0.05,
      },
    ),
  };

  WeatherData get currentWeather => _currentWeather;
  List<WeatherData> get forecast => List.unmodifiable(_forecast);

  void initialize() {
    _generateForecast();
    _updateWeather();
  }

  void _generateForecast() {
    _forecast.clear();
    WeatherType currentType = _currentWeather.type;
    
    for (int i = 0; i < 7; i++) {
      // Weather transitions based on current weather
      final nextType = _getNextWeatherType(currentType);
      _forecast.add(_weatherTypes[nextType]!);
      currentType = nextType;
    }
  }

  WeatherType _getNextWeatherType(WeatherType current) {
    // Realistic weather transitions
    switch (current) {
      case WeatherType.clear:
        final chance = _random.nextDouble();
        if (chance < 0.6) return WeatherType.clear;
        if (chance < 0.8) return WeatherType.cloudy;
        if (chance < 0.95) return WeatherType.windy;
        return WeatherType.rainy;
        
      case WeatherType.cloudy:
        final chance = _random.nextDouble();
        if (chance < 0.4) return WeatherType.cloudy;
        if (chance < 0.6) return WeatherType.clear;
        if (chance < 0.8) return WeatherType.rainy;
        if (chance < 0.95) return WeatherType.foggy;
        return WeatherType.stormy;
        
      case WeatherType.rainy:
        final chance = _random.nextDouble();
        if (chance < 0.5) return WeatherType.rainy;
        if (chance < 0.7) return WeatherType.cloudy;
        if (chance < 0.85) return WeatherType.stormy;
        if (chance < 0.95) return WeatherType.foggy;
        return WeatherType.clear;
        
      case WeatherType.stormy:
        final chance = _random.nextDouble();
        if (chance < 0.3) return WeatherType.stormy;
        if (chance < 0.6) return WeatherType.rainy;
        if (chance < 0.8) return WeatherType.cloudy;
        if (chance < 0.95) return WeatherType.windy;
        return WeatherType.clear;
        
      case WeatherType.snowy:
        final chance = _random.nextDouble();
        if (chance < 0.6) return WeatherType.snowy;
        if (chance < 0.8) return WeatherType.cloudy;
        if (chance < 0.95) return WeatherType.blizzard;
        return WeatherType.clear;
        
      case WeatherType.foggy:
        final chance = _random.nextDouble();
        if (chance < 0.4) return WeatherType.foggy;
        if (chance < 0.7) return WeatherType.cloudy;
        if (chance < 0.9) return WeatherType.clear;
        return WeatherType.rainy;
        
      case WeatherType.windy:
        final chance = _random.nextDouble();
        if (chance < 0.4) return WeatherType.windy;
        if (chance < 0.6) return WeatherType.clear;
        if (chance < 0.8) return WeatherType.cloudy;
        if (chance < 0.95) return WeatherType.stormy;
        return WeatherType.heatwave;
        
      case WeatherType.heatwave:
        final chance = _random.nextDouble();
        if (chance < 0.5) return WeatherType.heatwave;
        if (chance < 0.7) return WeatherType.clear;
        if (chance < 0.9) return WeatherType.windy;
        return WeatherType.stormy;
        
      case WeatherType.blizzard:
        final chance = _random.nextDouble();
        if (chance < 0.3) return WeatherType.blizzard;
        if (chance < 0.7) return WeatherType.snowy;
        if (chance < 0.9) return WeatherType.cloudy;
        return WeatherType.clear;
        
      case WeatherType.hurricane:
        final chance = _random.nextDouble();
        if (chance < 0.2) return WeatherType.hurricane;
        if (chance < 0.5) return WeatherType.stormy;
        if (chance < 0.8) return WeatherType.rainy;
        return WeatherType.windy;
    }
  }

  void _updateWeather() {
    final now = DateTime.now();
    if (now.difference(_lastUpdate).inHours >= 6) { // Weather changes every 6 hours
      if (_forecast.isNotEmpty) {
        _currentWeather = _forecast.removeAt(0);
        _forecast.add(_weatherTypes[_getNextWeatherType(_forecast.last.type)]!);
        _lastUpdate = now;
      }
    }
  }

  void forceWeatherChange(WeatherType newWeather) {
    _currentWeather = _weatherTypes[newWeather]!;
    _generateForecast();
  }

  double getGameEffect(String effectName) {
    return _currentWeather.gameEffects[effectName] ?? 1.0;
  }

  String getWeatherDescription() {
    return '${_currentWeather.name}: ${_currentWeather.description}';
  }

  Map<String, dynamic> getWeatherStats() {
    return {
      'temperature': '${_currentWeather.temperature.toStringAsFixed(1)}°C',
      'humidity': '${(_currentWeather.humidity * 100).toStringAsFixed(0)}%',
      'windSpeed': '${_currentWeather.windSpeed.toStringAsFixed(1)} km/h',
      'visibility': '${_currentWeather.visibility.toStringAsFixed(1)} km',
    };
  }
}

class WeatherWidget extends StatefulWidget {
  final double size;
  final bool showDetails;
  final bool showEffects;

  const WeatherWidget({
    super.key,
    this.size = 200,
    this.showDetails = true,
    this.showEffects = false,
  });

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _precipitationController;
  final WeatherSystem _weatherSystem = WeatherSystem();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    
    _precipitationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _weatherSystem.initialize();
    
    // Update weather periodically
    Future.delayed(const Duration(minutes: 1), _checkWeatherUpdate);
  }

  void _checkWeatherUpdate() {
    if (mounted) {
      setState(() {
        _weatherSystem._updateWeather();
      });
      Future.delayed(const Duration(minutes: 1), _checkWeatherUpdate);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _precipitationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weather = _weatherSystem.currentWeather;
    
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            weather.skyColor,
            weather.skyColor.withOpacity(0.7),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Animated background
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _WeatherBackgroundPainter(
                  weather: weather,
                  animationValue: _animationController.value,
                ),
              );
            },
          ),
          
          // Precipitation effects
          if (weather.precipitationIntensity > 0)
            AnimatedBuilder(
              animation: _precipitationController,
              builder: (context, child) {
                return CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: _PrecipitationPainter(
                    weather: weather,
                    animationValue: _precipitationController.value,
                  ),
                );
              },
            ),
          
          // Weather info overlay
          if (widget.showDetails)
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      weather.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${weather.temperature.toStringAsFixed(1)}°C',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    if (widget.showEffects) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Traffic: ${(weather.gameEffects['customerTraffic']! * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _WeatherBackgroundPainter extends CustomPainter {
  final WeatherData weather;
  final double animationValue;

  _WeatherBackgroundPainter({
    required this.weather,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Draw animated clouds
    _drawClouds(canvas, size);
    
    // Draw weather-specific effects
    switch (weather.type) {
      case WeatherType.clear:
        _drawSun(canvas, center, size);
        break;
      case WeatherType.cloudy:
      case WeatherType.foggy:
        _drawHeavyClouds(canvas, size);
        break;
      case WeatherType.stormy:
        _drawLightning(canvas, size);
        break;
      case WeatherType.heatwave:
        _drawHeatWaves(canvas, size);
        break;
      case WeatherType.windy:
        _drawWindLines(canvas, size);
        break;
      default:
        break;
    }
  }

  void _drawSun(Canvas canvas, Offset center, Size size) {
    final sunPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFD700),
          const Color(0xFFFFA500),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: 30));
    
    // Rotating sun
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(animationValue * 2 * math.pi);
    
    // Sun rays
    final rayPaint = Paint()
      ..color = const Color(0xFFFFD700)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi) / 4;
      final startRadius = 35;
      final endRadius = 50;
      final start = Offset(
        math.cos(angle) * startRadius,
        math.sin(angle) * startRadius,
      );
      final end = Offset(
        math.cos(angle) * endRadius,
        math.sin(angle) * endRadius,
      );
      canvas.drawLine(start, end, rayPaint);
    }
    
    canvas.restore();
    
    // Sun body
    canvas.drawCircle(center, 25, sunPaint);
  }

  void _drawClouds(Canvas canvas, Size size) {
    final cloudPaint = Paint()
      ..color = weather.cloudColors.first.withOpacity(0.8)
      ..style = PaintingStyle.fill;
    
    // Animated cloud positions
    final cloud1X = (animationValue * size.width * 0.2) % (size.width + 100) - 50;
    final cloud2X = ((animationValue + 0.5) * size.width * 0.15) % (size.width + 80) - 40;
    
    _drawCloud(canvas, Offset(cloud1X, size.height * 0.2), 40, cloudPaint);
    _drawCloud(canvas, Offset(cloud2X, size.height * 0.4), 30, cloudPaint);
  }

  void _drawCloud(Canvas canvas, Offset position, double size, Paint paint) {
    canvas.drawCircle(position, size, paint);
    canvas.drawCircle(Offset(position.dx + size * 0.8, position.dy), size * 0.8, paint);
    canvas.drawCircle(Offset(position.dx + size * 1.4, position.dy), size * 0.6, paint);
    canvas.drawCircle(Offset(position.dx + size * 0.4, position.dy - size * 0.5), size * 0.7, paint);
    canvas.drawCircle(Offset(position.dx + size, position.dy - size * 0.3), size * 0.5, paint);
  }

  void _drawHeavyClouds(Canvas canvas, Size size) {
    final darkCloudPaint = Paint()
      ..color = weather.cloudColors.last.withOpacity(0.9)
      ..style = PaintingStyle.fill;
    
    for (int i = 0; i < 3; i++) {
      final x = (size.width / 3) * i + (animationValue * 20 - 10);
      final y = size.height * 0.3 + math.sin(animationValue * 2 * math.pi + i) * 10;
      _drawCloud(canvas, Offset(x, y), 50, darkCloudPaint);
    }
  }

  void _drawLightning(Canvas canvas, Size size) {
    if ((animationValue * 10) % 1 < 0.1) { // Flash occasionally
      final lightningPaint = Paint()
        ..color = const Color(0xFFFFFFFF)
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;
      
      final lightningPath = Path();
      lightningPath.moveTo(size.width * 0.4, size.height * 0.2);
      lightningPath.lineTo(size.width * 0.45, size.height * 0.4);
      lightningPath.lineTo(size.width * 0.35, size.height * 0.4);
      lightningPath.lineTo(size.width * 0.4, size.height * 0.7);
      
      canvas.drawPath(lightningPath, lightningPaint);
    }
  }

  void _drawHeatWaves(Canvas canvas, Size size) {
    final heatPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFFFF4500).withOpacity(0.3),
          const Color(0xFFFFD700).withOpacity(0.2),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    for (int i = 0; i < 10; i++) {
      final x = (size.width / 10) * i;
      final path = Path();
      path.moveTo(x, size.height);
      
      for (double y = size.height; y >= 0; y -= 10) {
        final waveX = x + math.sin((y / 20) + animationValue * 4 * math.pi) * 5;
        path.lineTo(waveX, y);
      }
      
      canvas.drawPath(path, heatPaint);
    }
  }

  void _drawWindLines(Canvas canvas, Size size) {
    final windPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    
    for (int i = 0; i < 15; i++) {
      final y = (size.height / 15) * i;
      final progress = (animationValue * 2 + i * 0.1) % 1;
      final startX = progress * size.width - 50;
      final endX = startX + 30;
      
      if (startX > -50 && startX < size.width) {
        canvas.drawLine(
          Offset(startX, y),
          Offset(endX, y),
          windPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _PrecipitationPainter extends CustomPainter {
  final WeatherData weather;
  final double animationValue;

  _PrecipitationPainter({
    required this.weather,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    switch (weather.type) {
      case WeatherType.rainy:
      case WeatherType.stormy:
        _drawRain(canvas, size);
        break;
      case WeatherType.snowy:
      case WeatherType.blizzard:
        _drawSnow(canvas, size);
        break;
      case WeatherType.foggy:
        _drawFog(canvas, size);
        break;
      default:
        break;
    }
  }

  void _drawRain(Canvas canvas, Size size) {
    final rainPaint = Paint()
      ..color = Colors.blue.withOpacity(0.6)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    
    final dropCount = (weather.precipitationIntensity * 100).round();
    
    for (int i = 0; i < dropCount; i++) {
      final x = (i * 137.5) % size.width; // Pseudo-random distribution
      final baseY = (animationValue * size.height * 2 + i * 17.3) % (size.height + 50) - 50;
      final windOffset = weather.windSpeed * 0.1;
      
      canvas.drawLine(
        Offset(x + windOffset, baseY),
        Offset(x + windOffset, baseY + 15),
        rainPaint,
      );
    }
  }

  void _drawSnow(Canvas canvas, Size size) {
    final snowPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.fill;
    
    final flakeCount = (weather.precipitationIntensity * 50).round();
    
    for (int i = 0; i < flakeCount; i++) {
      final x = (i * 137.5) % size.width;
      final baseY = (animationValue * size.height * 0.5 + i * 23.7) % (size.height + 20) - 20;
      final swayX = x + math.sin(animationValue * 2 * math.pi + i) * 10;
      
      _drawSnowflake(canvas, Offset(swayX, baseY), 3 + (i % 3), snowPaint);
    }
  }

  void _drawSnowflake(Canvas canvas, Offset center, double size, Paint paint) {
    canvas.drawCircle(center, size, paint);
    
    // Simple snowflake arms
    final armPaint = Paint()
      ..color = paint.color
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
    
    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi) / 3;
      final endX = center.dx + math.cos(angle) * size;
      final endY = center.dy + math.sin(angle) * size;
      canvas.drawLine(center, Offset(endX, endY), armPaint);
    }
  }

  void _drawFog(Canvas canvas, Size size) {
    final fogPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withOpacity(0.1),
          Colors.white.withOpacity(0.4),
          Colors.white.withOpacity(0.2),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;
    
    // Multiple fog layers
    for (int layer = 0; layer < 3; layer++) {
      final layerY = size.height * 0.7 + layer * 20;
      final waveHeight = 15 + layer * 5;
      
      final path = Path();
      path.moveTo(0, layerY);
      
      for (double x = 0; x <= size.width; x += 5) {
        final y = layerY + math.sin((x / 30) + animationValue * 2 * math.pi + layer) * waveHeight;
        path.lineTo(x, y);
      }
      
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
      
      canvas.drawPath(path, fogPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
