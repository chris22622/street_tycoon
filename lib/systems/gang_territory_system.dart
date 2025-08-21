import 'package:flutter/material.dart';
import 'dart:math' as math;

enum GangType {
  rivals,
  allies,
  neutral,
  hostile,
  law,
}

enum TerritoryStatus {
  contested,
  controlled,
  neutral,
  expanding,
  declining,
}

class Gang {
  final String id;
  final String name;
  final String description;
  final Color primaryColor;
  final Color secondaryColor;
  final String leader;
  final String specialty;
  final GangType relationship;
  final double strength;
  final double influence;
  final double aggression;
  final double wealth;
  final List<String> territories;
  final Map<String, double> drugPreferences;
  final List<String> weapons;
  final String headquarters;

  const Gang({
    required this.id,
    required this.name,
    required this.description,
    required this.primaryColor,
    required this.secondaryColor,
    required this.leader,
    required this.specialty,
    required this.relationship,
    required this.strength,
    required this.influence,
    required this.aggression,
    required this.wealth,
    required this.territories,
    required this.drugPreferences,
    required this.weapons,
    required this.headquarters,
  });
}

class Territory {
  final String id;
  final String name;
  final Offset position;
  final List<Offset> boundaries;
  final String controllingGang;
  final TerritoryStatus status;
  final double value;
  final double safetyLevel;
  final double policePresence;
  final Map<String, double> resources;
  final List<String> specialFeatures;
  final DateTime lastConflict;
  final double contestLevel;

  const Territory({
    required this.id,
    required this.name,
    required this.position,
    required this.boundaries,
    required this.controllingGang,
    required this.status,
    required this.value,
    required this.safetyLevel,
    required this.policePresence,
    required this.resources,
    required this.specialFeatures,
    required this.lastConflict,
    required this.contestLevel,
  });
}

class GangTerritorySystem {
  static final GangTerritorySystem _instance = GangTerritorySystem._internal();
  factory GangTerritorySystem() => _instance;
  GangTerritorySystem._internal();

  final Map<String, Gang> _gangs = {};
  final Map<String, Territory> _territories = {};
  final List<String> _activeConflicts = [];
  final Map<String, double> _playerReputation = {};
  
  static const Map<String, Gang> _predefinedGangs = {
    'crimson_serpents': Gang(
      id: 'crimson_serpents',
      name: 'Crimson Serpents',
      description: 'Ruthless motorcycle gang controlling the industrial sector',
      primaryColor: Color(0xFFDC143C),
      secondaryColor: Color(0xFF8B0000),
      leader: 'Vincent "Viper" Rodriguez',
      specialty: 'Methamphetamine production and distribution',
      relationship: GangType.hostile,
      strength: 0.85,
      influence: 0.7,
      aggression: 0.9,
      wealth: 0.6,
      territories: ['industrial_north', 'factory_district', 'warehouse_zone'],
      drugPreferences: {'meth': 0.9, 'cocaine': 0.3, 'heroin': 0.1},
      weapons: ['assault_rifles', 'pistols', 'explosives'],
      headquarters: 'Abandoned Steel Mill',
    ),
    
    'golden_tigers': Gang(
      id: 'golden_tigers',
      name: 'Golden Tigers',
      description: 'Asian crime syndicate with sophisticated operations',
      primaryColor: Color(0xFFFFD700),
      secondaryColor: Color(0xFFB8860B),
      leader: 'Liu Wei "Dragon" Chen',
      specialty: 'High-end drug trafficking and money laundering',
      relationship: GangType.neutral,
      strength: 0.8,
      influence: 0.9,
      aggression: 0.6,
      wealth: 0.95,
      territories: ['chinatown', 'financial_district', 'harbor_east'],
      drugPreferences: {'cocaine': 0.8, 'heroin': 0.7, 'ecstasy': 0.6},
      weapons: ['submachine_guns', 'silenced_pistols', 'throwing_knives'],
      headquarters: 'Golden Palace Restaurant',
    ),
    
    'shadow_wolves': Gang(
      id: 'shadow_wolves',
      name: 'Shadow Wolves',
      description: 'Native American gang with deep street connections',
      primaryColor: Color(0xFF2F2F2F),
      secondaryColor: Color(0xFF708090),
      leader: 'Marcus "Lone Wolf" Blackhorse',
      specialty: 'Street-level distribution and protection rackets',
      relationship: GangType.allies,
      strength: 0.7,
      influence: 0.6,
      aggression: 0.7,
      wealth: 0.4,
      territories: ['downtown_east', 'residential_south', 'park_district'],
      drugPreferences: {'marijuana': 0.9, 'cocaine': 0.5, 'pills': 0.7},
      weapons: ['shotguns', 'pistols', 'melee_weapons'],
      headquarters: 'Sacred Ground Auto Shop',
    ),
    
    'neon_knights': Gang(
      id: 'neon_knights',
      name: 'Neon Knights',
      description: 'Tech-savvy gang controlling nightlife and cyber crime',
      primaryColor: Color(0xFFFF1493),
      secondaryColor: Color(0xFF00FFFF),
      leader: 'Alexis "Neon" Vasquez',
      specialty: 'Synthetic drugs and cyber operations',
      relationship: GangType.rivals,
      strength: 0.6,
      influence: 0.8,
      aggression: 0.5,
      wealth: 0.7,
      territories: ['entertainment_district', 'tech_quarter', 'nightclub_row'],
      drugPreferences: {'ecstasy': 0.9, 'lsd': 0.8, 'synthetic': 0.95},
      weapons: ['smart_guns', 'tasers', 'cyber_weapons'],
      headquarters: 'Neon Dreams Nightclub',
    ),
    
    'iron_brotherhood': Gang(
      id: 'iron_brotherhood',
      name: 'Iron Brotherhood',
      description: 'White supremacist prison gang with outside connections',
      primaryColor: Color(0xFF4B4B4D),
      secondaryColor: Color(0xFFFFFFFF),
      leader: 'Jake "Iron" Morrison',
      specialty: 'Weapons trafficking and violent enforcement',
      relationship: GangType.hostile,
      strength: 0.9,
      influence: 0.5,
      aggression: 0.95,
      wealth: 0.5,
      territories: ['prison_district', 'outskirts_west', 'abandoned_lots'],
      drugPreferences: {'meth': 0.8, 'heroin': 0.6, 'pills': 0.5},
      weapons: ['heavy_weapons', 'improvised_weapons', 'assault_rifles'],
      headquarters: 'Underground Bunker Complex',
    ),
  };

  void initialize() {
    _gangs.addAll(_predefinedGangs);
    _initializeTerritories();
    _setupInitialConflicts();
  }

  void _initializeTerritories() {
    final territories = [
      Territory(
        id: 'downtown_central',
        name: 'Downtown Central',
        position: const Offset(200, 200),
        boundaries: [
          const Offset(150, 150),
          const Offset(250, 150),
          const Offset(250, 250),
          const Offset(150, 250),
        ],
        controllingGang: 'neutral',
        status: TerritoryStatus.contested,
        value: 100000,
        safetyLevel: 0.3,
        policePresence: 0.8,
        resources: {'customers': 0.9, 'money_laundering': 0.8, 'corruption': 0.6},
        specialFeatures: ['police_station', 'bank', 'city_hall'],
        lastConflict: DateTime.now().subtract(const Duration(hours: 6)),
        contestLevel: 0.7,
      ),
      
      Territory(
        id: 'industrial_north',
        name: 'Industrial North',
        position: const Offset(200, 100),
        boundaries: [
          const Offset(100, 50),
          const Offset(300, 50),
          const Offset(300, 150),
          const Offset(100, 150),
        ],
        controllingGang: 'crimson_serpents',
        status: TerritoryStatus.controlled,
        value: 75000,
        safetyLevel: 0.2,
        policePresence: 0.3,
        resources: {'production': 0.9, 'storage': 0.8, 'transport': 0.7},
        specialFeatures: ['factories', 'warehouses', 'rail_yard'],
        lastConflict: DateTime.now().subtract(const Duration(days: 14)),
        contestLevel: 0.2,
      ),
      
      Territory(
        id: 'chinatown',
        name: 'Chinatown',
        position: const Offset(300, 200),
        boundaries: [
          const Offset(275, 175),
          const Offset(325, 175),
          const Offset(325, 225),
          const Offset(275, 225),
        ],
        controllingGang: 'golden_tigers',
        status: TerritoryStatus.controlled,
        value: 85000,
        safetyLevel: 0.6,
        policePresence: 0.4,
        resources: {'money_laundering': 0.9, 'high_end_clients': 0.8, 'imports': 0.9},
        specialFeatures: ['restaurants', 'import_businesses', 'cultural_center'],
        lastConflict: DateTime.now().subtract(const Duration(days: 30)),
        contestLevel: 0.1,
      ),
      
      Territory(
        id: 'entertainment_district',
        name: 'Entertainment District',
        position: const Offset(150, 250),
        boundaries: [
          const Offset(100, 225),
          const Offset(200, 225),
          const Offset(200, 275),
          const Offset(100, 275),
        ],
        controllingGang: 'neon_knights',
        status: TerritoryStatus.controlled,
        value: 90000,
        safetyLevel: 0.4,
        policePresence: 0.5,
        resources: {'nightlife': 0.9, 'party_drugs': 0.8, 'tech': 0.7},
        specialFeatures: ['nightclubs', 'casinos', 'theaters'],
        lastConflict: DateTime.now().subtract(const Duration(days: 7)),
        contestLevel: 0.3,
      ),
      
      Territory(
        id: 'residential_south',
        name: 'Residential South',
        position: const Offset(200, 300),
        boundaries: [
          const Offset(150, 275),
          const Offset(250, 275),
          const Offset(250, 325),
          const Offset(150, 325),
        ],
        controllingGang: 'shadow_wolves',
        status: TerritoryStatus.controlled,
        value: 50000,
        safetyLevel: 0.7,
        policePresence: 0.6,
        resources: {'street_dealers': 0.7, 'safe_houses': 0.8, 'community': 0.9},
        specialFeatures: ['schools', 'community_center', 'low_income_housing'],
        lastConflict: DateTime.now().subtract(const Duration(days: 21)),
        contestLevel: 0.2,
      ),
    ];

    for (final territory in territories) {
      _territories[territory.id] = territory;
    }
  }

  void _setupInitialConflicts() {
    _activeConflicts.addAll([
      'downtown_central',
      'border_industrial_entertainment',
    ]);
  }

  Gang? getGang(String gangId) => _gangs[gangId];
  Territory? getTerritory(String territoryId) => _territories[territoryId];
  
  List<Gang> getAllGangs() => _gangs.values.toList();
  List<Territory> getAllTerritories() => _territories.values.toList();
  
  List<Gang> getHostileGangs() => _gangs.values
      .where((gang) => gang.relationship == GangType.hostile)
      .toList();
  
  List<Gang> getAlliedGangs() => _gangs.values
      .where((gang) => gang.relationship == GangType.allies)
      .toList();

  List<Territory> getContestedTerritories() => _territories.values
      .where((territory) => territory.status == TerritoryStatus.contested)
      .toList();

  List<Territory> getTerritoriesControlledBy(String gangId) => _territories.values
      .where((territory) => territory.controllingGang == gangId)
      .toList();

  double getPlayerReputationWith(String gangId) => _playerReputation[gangId] ?? 0.0;

  void adjustPlayerReputation(String gangId, double change) {
    _playerReputation[gangId] = (_playerReputation[gangId] ?? 0.0) + change;
    _playerReputation[gangId] = _playerReputation[gangId]!.clamp(-100.0, 100.0);
  }

  bool isAreaSafe(Offset position) {
    for (final territory in _territories.values) {
      if (_isPointInTerritory(position, territory)) {
        return territory.safetyLevel > 0.5;
      }
    }
    return false;
  }

  Gang? getControllingGang(Offset position) {
    for (final territory in _territories.values) {
      if (_isPointInTerritory(position, territory)) {
        return _gangs[territory.controllingGang];
      }
    }
    return null;
  }

  double getPolicePresence(Offset position) {
    for (final territory in _territories.values) {
      if (_isPointInTerritory(position, territory)) {
        return territory.policePresence;
      }
    }
    return 0.5; // Default police presence
  }

  bool _isPointInTerritory(Offset point, Territory territory) {
    // Simple bounding box check for now
    final bounds = territory.boundaries;
    if (bounds.isEmpty) return false;
    
    double minX = bounds.first.dx;
    double maxX = bounds.first.dx;
    double minY = bounds.first.dy;
    double maxY = bounds.first.dy;
    
    for (final boundary in bounds) {
      minX = math.min(minX, boundary.dx);
      maxX = math.max(maxX, boundary.dx);
      minY = math.min(minY, boundary.dy);
      maxY = math.max(maxY, boundary.dy);
    }
    
    return point.dx >= minX && point.dx <= maxX && 
           point.dy >= minY && point.dy <= maxY;
  }

  void triggerGangWar(String gangId1, String gangId2, String territoryId) {
    final gang1 = _gangs[gangId1];
    final gang2 = _gangs[gangId2];
    final territory = _territories[territoryId];
    
    if (gang1 == null || gang2 == null || territory == null) return;
    
    // Calculate war outcome based on gang strengths
    final gang1Power = gang1.strength * gang1.aggression;
    final gang2Power = gang2.strength * gang2.aggression;
    
    final random = math.Random();
    final randomFactor = 0.8 + (random.nextDouble() * 0.4); // 0.8 to 1.2
    
    final gang1FinalPower = gang1Power * randomFactor;
    final gang2FinalPower = gang2Power * randomFactor;
    
    String winner;
    if (gang1FinalPower > gang2FinalPower) {
      winner = gangId1;
    } else {
      winner = gangId2;
    }
    
    // Update territory control
    _territories[territoryId] = Territory(
      id: territory.id,
      name: territory.name,
      position: territory.position,
      boundaries: territory.boundaries,
      controllingGang: winner,
      status: TerritoryStatus.controlled,
      value: territory.value,
      safetyLevel: territory.safetyLevel * 0.7, // War reduces safety
      policePresence: territory.policePresence * 1.2, // Increases police response
      resources: territory.resources,
      specialFeatures: territory.specialFeatures,
      lastConflict: DateTime.now(),
      contestLevel: 0.1,
    );
    
    // Adjust gang relationships
    if (winner == gangId1) {
      adjustPlayerReputation(gangId1, 10);
      adjustPlayerReputation(gangId2, -15);
    } else {
      adjustPlayerReputation(gangId1, -15);
      adjustPlayerReputation(gangId2, 10);
    }
  }

  Map<String, dynamic> getTerritoryInfo(Offset position) {
    for (final territory in _territories.values) {
      if (_isPointInTerritory(position, territory)) {
        final gang = _gangs[territory.controllingGang];
        return {
          'territory': territory.name,
          'controllingGang': gang?.name ?? 'Neutral',
          'gangColor': gang?.primaryColor ?? Colors.grey,
          'safetyLevel': territory.safetyLevel,
          'policePresence': territory.policePresence,
          'status': territory.status.toString().split('.').last,
          'value': territory.value,
          'contestLevel': territory.contestLevel,
          'lastConflict': territory.lastConflict,
          'specialFeatures': territory.specialFeatures,
        };
      }
    }
    return {
      'territory': 'Unknown Area',
      'controllingGang': 'None',
      'gangColor': Colors.grey,
      'safetyLevel': 0.5,
      'policePresence': 0.5,
      'status': 'neutral',
      'value': 0,
      'contestLevel': 0.0,
      'lastConflict': DateTime.now(),
      'specialFeatures': <String>[],
    };
  }

  List<String> getGangActivities(String gangId) {
    final gang = _gangs[gangId];
    if (gang == null) return [];
    
    final activities = <String>[];
    
    // Generate activities based on gang properties
    if (gang.aggression > 0.7) {
      activities.add('Planning territorial expansion');
      activities.add('Recruiting muscle for operations');
    }
    
    if (gang.wealth > 0.6) {
      activities.add('Money laundering operations');
      activities.add('Bribing city officials');
    }
    
    if (gang.influence > 0.7) {
      activities.add('Negotiating with suppliers');
      activities.add('Expanding corruption network');
    }
    
    // Add drug-specific activities
    for (final drug in gang.drugPreferences.keys) {
      if (gang.drugPreferences[drug]! > 0.5) {
        activities.add('Increasing $drug distribution');
      }
    }
    
    return activities;
  }

  void updateGangDynamics() {
    // Simulate gang power shifts over time
    for (final gangId in _gangs.keys) {
      final gang = _gangs[gangId]!;
      final territories = getTerritoriesControlledBy(gangId);
      
      // Gang strength influenced by territory control
      final strengthModifier = 1.0 + (territories.length * 0.1);
      final wealthModifier = 1.0 + (territories.fold<double>(0, (sum, t) => sum + t.value) / 100000);
      
      // Apply reputation effects
      final reputation = getPlayerReputationWith(gangId);
      double finalModifier = strengthModifier;
      if (reputation > 50) {
        finalModifier *= 1.1; // Allied gangs get stronger
      } else if (reputation < -50) {
        finalModifier *= 0.9; // Hostile gangs get weaker (player interference)
      }
      
      // Random events can affect gang status
      final random = math.Random();
      if (random.nextDouble() < 0.1) { // 10% chance of random event
        final eventType = random.nextInt(3);
        switch (eventType) {
          case 0: // Leadership change
            debugPrint('${gang.name} has new leadership! (Modifier: ${finalModifier.toStringAsFixed(2)})');
            break;
          case 1: // Major bust
            debugPrint('${gang.name} suffered a major police bust! (Wealth: ${wealthModifier.toStringAsFixed(2)})');
            break;
          case 2: // Successful operation
            debugPrint('${gang.name} completed a successful operation!');
            break;
        }
      }
    }
  }
}

// Gang Territory Map Widget
class GangTerritoryMapWidget extends StatefulWidget {
  final double width;
  final double height;
  final Offset? playerPosition;
  final Function(Offset)? onTap;

  const GangTerritoryMapWidget({
    super.key,
    required this.width,
    required this.height,
    this.playerPosition,
    this.onTap,
  });

  @override
  State<GangTerritoryMapWidget> createState() => _GangTerritoryMapWidgetState();
}

class _GangTerritoryMapWidgetState extends State<GangTerritoryMapWidget> {
  final GangTerritorySystem _territorySystem = GangTerritorySystem();

  @override
  void initState() {
    super.initState();
    _territorySystem.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {
        if (widget.onTap != null) {
          final position = details.localPosition;
          widget.onTap!(position);
        }
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          border: Border.all(color: Colors.white24),
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomPaint(
          size: Size(widget.width, widget.height),
          painter: _GangTerritoryPainter(
            territorySystem: _territorySystem,
            playerPosition: widget.playerPosition,
          ),
        ),
      ),
    );
  }
}

class _GangTerritoryPainter extends CustomPainter {
  final GangTerritorySystem territorySystem;
  final Offset? playerPosition;

  _GangTerritoryPainter({
    required this.territorySystem,
    this.playerPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw territories
    for (final territory in territorySystem.getAllTerritories()) {
      _drawTerritory(canvas, territory, size);
    }
    
    // Draw gang headquarters
    for (final gang in territorySystem.getAllGangs()) {
      _drawGangHQ(canvas, gang, size);
    }
    
    // Draw player position
    if (playerPosition != null) {
      _drawPlayer(canvas, playerPosition!, size);
    }
    
    // Draw conflicts
    _drawActiveConflicts(canvas, size);
  }

  void _drawTerritory(Canvas canvas, Territory territory, Size size) {
    final gang = territorySystem.getGang(territory.controllingGang);
    
    // Territory fill
    final fillPaint = Paint()
      ..color = (gang?.primaryColor ?? Colors.grey).withOpacity(0.3)
      ..style = PaintingStyle.fill;
    
    // Territory border
    final borderPaint = Paint()
      ..color = gang?.primaryColor ?? Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = territory.status == TerritoryStatus.contested ? 3.0 : 1.5;
    
    if (territory.status == TerritoryStatus.contested) {
      // Animated dashed border for contested territories
      borderPaint.strokeWidth = 2.0;
      final dashPaint = Paint()
        ..color = Colors.red
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      canvas.drawPath(_createTerritoryPath(territory), dashPaint);
    }
    
    final path = _createTerritoryPath(territory);
    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, borderPaint);
    
    // Territory name
    final textPainter = TextPainter(
      text: TextSpan(
        text: territory.name,
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        territory.position.dx - textPainter.width / 2,
        territory.position.dy - textPainter.height / 2,
      ),
    );
    
    // Safety indicator
    final safetyColor = Color.lerp(Colors.red, Colors.green, territory.safetyLevel)!;
    final safetyPaint = Paint()
      ..color = safetyColor
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      Offset(territory.position.dx + 30, territory.position.dy - 20),
      5,
      safetyPaint,
    );
  }

  Path _createTerritoryPath(Territory territory) {
    final path = Path();
    if (territory.boundaries.isNotEmpty) {
      path.moveTo(territory.boundaries.first.dx, territory.boundaries.first.dy);
      for (int i = 1; i < territory.boundaries.length; i++) {
        path.lineTo(territory.boundaries[i].dx, territory.boundaries[i].dy);
      }
      path.close();
    }
    return path;
  }

  void _drawGangHQ(Canvas canvas, Gang gang, Size size) {
    // Find gang's primary territory for HQ location
    final territories = territorySystem.getTerritoriesControlledBy(gang.id);
    if (territories.isEmpty) return;
    
    final hqPosition = territories.first.position;
    
    // HQ building
    final hqPaint = Paint()
      ..color = gang.primaryColor
      ..style = PaintingStyle.fill;
    
    final hqRect = Rect.fromCenter(
      center: hqPosition,
      width: 16,
      height: 16,
    );
    
    canvas.drawRect(hqRect, hqPaint);
    
    // Gang symbol
    final symbolPaint = Paint()
      ..color = gang.secondaryColor
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(hqPosition, 6, symbolPaint);
    
    // Gang initial
    final initialPainter = TextPainter(
      text: TextSpan(
        text: gang.name[0],
        style: const TextStyle(
          color: Colors.white,
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    initialPainter.layout();
    initialPainter.paint(
      canvas,
      Offset(
        hqPosition.dx - initialPainter.width / 2,
        hqPosition.dy - initialPainter.height / 2,
      ),
    );
  }

  void _drawPlayer(Canvas canvas, Offset position, Size size) {
    final playerPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(position, 8, playerPaint);
    
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    canvas.drawCircle(position, 8, borderPaint);
  }

  void _drawActiveConflicts(Canvas canvas, Size size) {
    // Draw conflict zones with pulsing effect
    final conflictPaint = Paint()
      ..color = Colors.red.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    
    for (final territory in territorySystem.getAllTerritories()) {
      if (territory.status == TerritoryStatus.contested) {
        canvas.drawCircle(territory.position, 25, conflictPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
