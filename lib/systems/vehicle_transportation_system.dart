import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';

enum VehicleType {
  motorcycle,
  sedan,
  suv,
  sports_car,
  truck,
  van,
  limousine,
  helicopter,
  boat,
  armored_car,
}

enum VehicleCondition {
  excellent,
  good,
  fair,
  poor,
  damaged,
  destroyed,
}

enum ModificationType {
  engine_upgrade,
  armor_plating,
  bulletproof_glass,
  hidden_compartments,
  nitrous_system,
  surveillance_equipment,
  communication_array,
  weapon_systems,
  stealth_coating,
  tracking_blocker,
}

enum PursuitLevel {
  none,
  low,
  medium,
  high,
  maximum,
}

class Vehicle {
  final String id;
  final String name;
  final VehicleType type;
  final double speed;
  final double acceleration;
  final double handling;
  final double durability;
  final double fuel;
  final double maxFuel;
  final VehicleCondition condition;
  final double suspicionLevel;
  final List<ModificationType> modifications;
  final double cargoCapacity;
  final double hiddenCapacity;
  final bool isStolen;
  final String? registeredOwner;
  final DateTime? lastMaintenance;
  final List<String> damageHistory;
  final double value;
  final Color color;
  final String licensePlate;

  const Vehicle({
    required this.id,
    required this.name,
    required this.type,
    required this.speed,
    required this.acceleration,
    required this.handling,
    required this.durability,
    required this.fuel,
    required this.maxFuel,
    required this.condition,
    required this.suspicionLevel,
    required this.modifications,
    required this.cargoCapacity,
    required this.hiddenCapacity,
    required this.isStolen,
    this.registeredOwner,
    this.lastMaintenance,
    required this.damageHistory,
    required this.value,
    required this.color,
    required this.licensePlate,
  });
}

class Route {
  final String id;
  final String name;
  final List<Offset> waypoints;
  final double distance;
  final double difficulty;
  final double risk;
  final List<String> hazards;
  final double averageSpeed;
  final bool requiresSpecialVehicle;
  final Map<String, double> tollCosts;

  const Route({
    required this.id,
    required this.name,
    required this.waypoints,
    required this.distance,
    required this.difficulty,
    required this.risk,
    required this.hazards,
    required this.averageSpeed,
    required this.requiresSpecialVehicle,
    required this.tollCosts,
  });
}

class Trip {
  final String id;
  final String vehicleId;
  final String routeId;
  final Offset startLocation;
  final Offset targetLocation;
  final DateTime startTime;
  final DateTime? arrivalTime;
  final double progress;
  final List<String> cargo;
  final PursuitLevel pursuitLevel;
  final bool isActive;
  final double fuelUsed;
  final List<String> incidents;

  const Trip({
    required this.id,
    required this.vehicleId,
    required this.routeId,
    required this.startLocation,
    required this.targetLocation,
    required this.startTime,
    this.arrivalTime,
    required this.progress,
    required this.cargo,
    required this.pursuitLevel,
    required this.isActive,
    required this.fuelUsed,
    required this.incidents,
  });
}

class PolicePursuit {
  final String id;
  final String targetVehicleId;
  final PursuitLevel level;
  final double intensity;
  final List<String> pursuingUnits;
  final DateTime startTime;
  final Offset lastKnownPosition;
  final double heatLevel;
  final bool hasRoadblocks;
  final bool hasHelicopterSupport;
  final List<String> tactics;

  const PolicePursuit({
    required this.id,
    required this.targetVehicleId,
    required this.level,
    required this.intensity,
    required this.pursuingUnits,
    required this.startTime,
    required this.lastKnownPosition,
    required this.heatLevel,
    required this.hasRoadblocks,
    required this.hasHelicopterSupport,
    required this.tactics,
  });
}

class VehicleTransportationSystem {
  static final VehicleTransportationSystem _instance = VehicleTransportationSystem._internal();
  factory VehicleTransportationSystem() => _instance;
  VehicleTransportationSystem._internal();

  final Map<String, Vehicle> _vehicles = {};
  final Map<String, Route> _routes = {};
  final Map<String, Trip> _activeTrips = {};
  final Map<String, PolicePursuit> _activePursuits = {};
  final List<Trip> _completedTrips = [];
  
  String? _currentVehicle;
  Offset _currentLocation = const Offset(100, 100);
  Timer? _transportTimer;

  static const Map<VehicleType, Map<String, dynamic>> _vehicleTemplates = {
    VehicleType.motorcycle: {
      'name': 'Street Bike',
      'speed': 95.0,
      'acceleration': 85.0,
      'handling': 90.0,
      'durability': 40.0,
      'maxFuel': 15.0,
      'cargoCapacity': 50.0,
      'hiddenCapacity': 10.0,
      'value': 8000.0,
      'suspicionLevel': 0.2,
    },
    
    VehicleType.sedan: {
      'name': 'Family Sedan',
      'speed': 70.0,
      'acceleration': 60.0,
      'handling': 70.0,
      'durability': 70.0,
      'maxFuel': 60.0,
      'cargoCapacity': 400.0,
      'hiddenCapacity': 100.0,
      'value': 25000.0,
      'suspicionLevel': 0.1,
    },
    
    VehicleType.suv: {
      'name': 'Urban SUV',
      'speed': 65.0,
      'acceleration': 55.0,
      'handling': 60.0,
      'durability': 80.0,
      'maxFuel': 80.0,
      'cargoCapacity': 800.0,
      'hiddenCapacity': 200.0,
      'value': 45000.0,
      'suspicionLevel': 0.15,
    },
    
    VehicleType.sports_car: {
      'name': 'Performance Coupe',
      'speed': 100.0,
      'acceleration': 95.0,
      'handling': 85.0,
      'durability': 50.0,
      'maxFuel': 50.0,
      'cargoCapacity': 200.0,
      'hiddenCapacity': 50.0,
      'value': 80000.0,
      'suspicionLevel': 0.6,
    },
    
    VehicleType.truck: {
      'name': 'Cargo Truck',
      'speed': 50.0,
      'acceleration': 30.0,
      'handling': 40.0,
      'durability': 95.0,
      'maxFuel': 200.0,
      'cargoCapacity': 5000.0,
      'hiddenCapacity': 1000.0,
      'value': 75000.0,
      'suspicionLevel': 0.3,
    },
    
    VehicleType.van: {
      'name': 'Panel Van',
      'speed': 60.0,
      'acceleration': 45.0,
      'handling': 55.0,
      'durability': 75.0,
      'maxFuel': 70.0,
      'cargoCapacity': 2000.0,
      'hiddenCapacity': 500.0,
      'value': 35000.0,
      'suspicionLevel': 0.4,
    },
    
    VehicleType.limousine: {
      'name': 'Executive Limousine',
      'speed': 55.0,
      'acceleration': 40.0,
      'handling': 50.0,
      'durability': 85.0,
      'maxFuel': 100.0,
      'cargoCapacity': 300.0,
      'hiddenCapacity': 150.0,
      'value': 120000.0,
      'suspicionLevel': 0.8,
    },
    
    VehicleType.helicopter: {
      'name': 'Light Helicopter',
      'speed': 120.0,
      'acceleration': 70.0,
      'handling': 95.0,
      'durability': 60.0,
      'maxFuel': 300.0,
      'cargoCapacity': 500.0,
      'hiddenCapacity': 100.0,
      'value': 2000000.0,
      'suspicionLevel': 0.9,
    },
    
    VehicleType.boat: {
      'name': 'Speed Boat',
      'speed': 85.0,
      'acceleration': 75.0,
      'handling': 80.0,
      'durability': 65.0,
      'maxFuel': 150.0,
      'cargoCapacity': 1000.0,
      'hiddenCapacity': 300.0,
      'value': 150000.0,
      'suspicionLevel': 0.5,
    },
    
    VehicleType.armored_car: {
      'name': 'Armored Vehicle',
      'speed': 45.0,
      'acceleration': 25.0,
      'handling': 35.0,
      'durability': 100.0,
      'maxFuel': 120.0,
      'cargoCapacity': 1500.0,
      'hiddenCapacity': 800.0,
      'value': 500000.0,
      'suspicionLevel': 0.95,
    },
  };

  void initialize() {
    _setupInitialVehicles();
    _setupRoutes();
    _startTransportTimer();
  }

  void dispose() {
    _transportTimer?.cancel();
  }

  void _setupInitialVehicles() {
    // Start with a basic sedan
    final sedanTemplate = _vehicleTemplates[VehicleType.sedan]!;
    final sedan = Vehicle(
      id: 'starter_sedan',
      name: sedanTemplate['name'],
      type: VehicleType.sedan,
      speed: sedanTemplate['speed'],
      acceleration: sedanTemplate['acceleration'],
      handling: sedanTemplate['handling'],
      durability: sedanTemplate['durability'],
      fuel: sedanTemplate['maxFuel'],
      maxFuel: sedanTemplate['maxFuel'],
      condition: VehicleCondition.good,
      suspicionLevel: sedanTemplate['suspicionLevel'],
      modifications: [],
      cargoCapacity: sedanTemplate['cargoCapacity'],
      hiddenCapacity: sedanTemplate['hiddenCapacity'],
      isStolen: false,
      registeredOwner: 'Player',
      lastMaintenance: DateTime.now().subtract(const Duration(days: 30)),
      damageHistory: [],
      value: sedanTemplate['value'],
      color: Colors.blue,
      licensePlate: _generateLicensePlate(),
    );

    _vehicles[sedan.id] = sedan;
    _currentVehicle = sedan.id;
  }

  String _generateLicensePlate() {
    final random = math.Random();
    final letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final numbers = '0123456789';
    
    String plate = '';
    for (int i = 0; i < 3; i++) {
      plate += letters[random.nextInt(letters.length)];
    }
    plate += '-';
    for (int i = 0; i < 3; i++) {
      plate += numbers[random.nextInt(numbers.length)];
    }
    
    return plate;
  }

  void _setupRoutes() {
    final routes = [
      Route(
        id: 'downtown_highway',
        name: 'Downtown Highway',
        waypoints: [
          const Offset(100, 100),
          const Offset(300, 150),
          const Offset(500, 200),
          const Offset(700, 250),
        ],
        distance: 25.0,
        difficulty: 0.3,
        risk: 0.4,
        hazards: ['traffic', 'police_patrols'],
        averageSpeed: 65.0,
        requiresSpecialVehicle: false,
        tollCosts: {'highway': 5.0},
      ),
      
      Route(
        id: 'industrial_backroads',
        name: 'Industrial Backroads',
        waypoints: [
          const Offset(100, 100),
          const Offset(150, 300),
          const Offset(400, 350),
          const Offset(600, 400),
        ],
        distance: 35.0,
        difficulty: 0.6,
        risk: 0.2,
        hazards: ['poor_roads', 'gangs'],
        averageSpeed: 40.0,
        requiresSpecialVehicle: false,
        tollCosts: {},
      ),
      
      Route(
        id: 'waterfront_smuggle',
        name: 'Waterfront Route',
        waypoints: [
          const Offset(50, 400),
          const Offset(200, 450),
          const Offset(400, 480),
          const Offset(600, 500),
        ],
        distance: 30.0,
        difficulty: 0.8,
        risk: 0.7,
        hazards: ['coast_guard', 'rough_waters', 'customs'],
        averageSpeed: 35.0,
        requiresSpecialVehicle: true, // Requires boat
        tollCosts: {'port_fee': 50.0},
      ),
      
      Route(
        id: 'mountain_pass',
        name: 'Mountain Pass',
        waypoints: [
          const Offset(200, 50),
          const Offset(350, 100),
          const Offset(500, 80),
          const Offset(650, 120),
        ],
        distance: 45.0,
        difficulty: 0.9,
        risk: 0.3,
        hazards: ['steep_roads', 'weather', 'wildlife'],
        averageSpeed: 30.0,
        requiresSpecialVehicle: false,
        tollCosts: {},
      ),
      
      Route(
        id: 'city_stealth',
        name: 'City Stealth Route',
        waypoints: [
          const Offset(150, 200),
          const Offset(250, 220),
          const Offset(350, 180),
          const Offset(450, 200),
        ],
        distance: 15.0,
        difficulty: 0.7,
        risk: 0.1,
        hazards: ['cameras', 'checkpoints'],
        averageSpeed: 25.0,
        requiresSpecialVehicle: false,
        tollCosts: {},
      ),
    ];

    for (final route in routes) {
      _routes[route.id] = route;
    }
  }

  void _startTransportTimer() {
    _transportTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _updateTransport();
    });
  }

  void _updateTransport() {
    _updateActiveTrips();
    _updatePursuits();
    _updateVehicleConditions();
  }

  void _updateActiveTrips() {
    final completedTripIds = <String>[];
    
    for (final tripId in _activeTrips.keys) {
      final trip = _activeTrips[tripId]!;
      final vehicle = _vehicles[trip.vehicleId];
      final route = _routes[trip.routeId];
      
      if (vehicle == null || route == null) continue;
      
      final elapsed = DateTime.now().difference(trip.startTime);
      final estimatedTime = _calculateTripTime(route, vehicle);
      final progress = (elapsed.inMilliseconds / estimatedTime.inMilliseconds).clamp(0.0, 1.0);
      
      if (progress >= 1.0) {
        // Trip completed
        completedTripIds.add(tripId);
        _completeTrip(trip, vehicle, route);
      } else {
        // Update progress and check for incidents
        final updatedTrip = _updateTripProgress(trip, progress, vehicle, route);
        _activeTrips[tripId] = updatedTrip;
        
        // Update current location for player vehicle
        if (trip.vehicleId == _currentVehicle) {
          _updateCurrentLocation(trip, route, progress);
        }
      }
    }
    
    // Remove completed trips
    for (final tripId in completedTripIds) {
      _activeTrips.remove(tripId);
    }
  }

  Duration _calculateTripTime(Route route, Vehicle vehicle) {
    final baseTime = (route.distance / route.averageSpeed) * 60; // minutes
    final vehicleSpeedFactor = vehicle.speed / 70.0; // 70 is average speed
    final conditionFactor = _getConditionMultiplier(vehicle.condition);
    final modificationFactor = _getModificationSpeedBonus(vehicle.modifications);
    
    final finalTime = baseTime / (vehicleSpeedFactor * conditionFactor * modificationFactor);
    
    return Duration(minutes: finalTime.round());
  }

  double _getConditionMultiplier(VehicleCondition condition) {
    switch (condition) {
      case VehicleCondition.excellent:
        return 1.2;
      case VehicleCondition.good:
        return 1.0;
      case VehicleCondition.fair:
        return 0.8;
      case VehicleCondition.poor:
        return 0.6;
      case VehicleCondition.damaged:
        return 0.4;
      case VehicleCondition.destroyed:
        return 0.0;
    }
  }

  double _getModificationSpeedBonus(List<ModificationType> modifications) {
    double bonus = 1.0;
    
    if (modifications.contains(ModificationType.engine_upgrade)) {
      bonus += 0.3;
    }
    if (modifications.contains(ModificationType.nitrous_system)) {
      bonus += 0.5;
    }
    
    return bonus;
  }

  Trip _updateTripProgress(Trip trip, double progress, Vehicle vehicle, Route route) {
    final random = math.Random();
    final newIncidents = List<String>.from(trip.incidents);
    
    // Check for random incidents
    if (random.nextDouble() < route.risk * 0.1) {
      final incident = _generateRandomIncident(route, vehicle);
      if (incident != null) {
        newIncidents.add(incident);
        
        // Start pursuit if incident is serious
        if (incident.contains('police') || incident.contains('spotted')) {
          _startPursuit(trip.vehicleId, PursuitLevel.low);
        }
      }
    }
    
    // Calculate fuel usage
    final fuelRate = vehicle.maxFuel / (route.distance * 2); // Fuel per unit distance
    final fuelUsed = trip.fuelUsed + (fuelRate * 0.1);
    
    return Trip(
      id: trip.id,
      vehicleId: trip.vehicleId,
      routeId: trip.routeId,
      startLocation: trip.startLocation,
      targetLocation: trip.targetLocation,
      startTime: trip.startTime,
      arrivalTime: trip.arrivalTime,
      progress: progress,
      cargo: trip.cargo,
      pursuitLevel: trip.pursuitLevel,
      isActive: trip.isActive,
      fuelUsed: fuelUsed,
      incidents: newIncidents,
    );
  }

  String? _generateRandomIncident(Route route, Vehicle vehicle) {
    final random = math.Random();
    final incidents = <String>[];
    
    // Route-specific incidents
    for (final hazard in route.hazards) {
      switch (hazard) {
        case 'traffic':
          incidents.add('Heavy traffic delays');
          break;
        case 'police_patrols':
          incidents.add('Police patrol spotted');
          break;
        case 'gangs':
          incidents.add('Gang territory encounter');
          break;
        case 'cameras':
          incidents.add('Speed camera flash');
          break;
        case 'checkpoints':
          incidents.add('Police checkpoint ahead');
          break;
        case 'coast_guard':
          incidents.add('Coast guard patrol');
          break;
        case 'weather':
          incidents.add('Severe weather conditions');
          break;
      }
    }
    
    if (incidents.isEmpty) return null;
    
    return incidents[random.nextInt(incidents.length)];
  }

  void _updateCurrentLocation(Trip trip, Route route, double progress) {
    if (route.waypoints.isEmpty) return;
    
    final totalSegments = route.waypoints.length - 1;
    final segmentProgress = progress * totalSegments;
    final currentSegment = segmentProgress.floor().clamp(0, totalSegments - 1);
    final segmentLocalProgress = segmentProgress - currentSegment;
    
    final startPoint = route.waypoints[currentSegment];
    final endPoint = route.waypoints[currentSegment + 1];
    
    _currentLocation = Offset(
      startPoint.dx + (endPoint.dx - startPoint.dx) * segmentLocalProgress,
      startPoint.dy + (endPoint.dy - startPoint.dy) * segmentLocalProgress,
    );
  }

  void _completeTrip(Trip trip, Vehicle vehicle, Route route) {
    final completedTrip = Trip(
      id: trip.id,
      vehicleId: trip.vehicleId,
      routeId: trip.routeId,
      startLocation: trip.startLocation,
      targetLocation: trip.targetLocation,
      startTime: trip.startTime,
      arrivalTime: DateTime.now(),
      progress: 1.0,
      cargo: trip.cargo,
      pursuitLevel: trip.pursuitLevel,
      isActive: false,
      fuelUsed: trip.fuelUsed,
      incidents: trip.incidents,
    );
    
    _completedTrips.add(completedTrip);
    
    // Update vehicle fuel
    _updateVehicleFuel(vehicle.id, -trip.fuelUsed);
    
    // Add wear and tear
    _addVehicleWear(vehicle.id, route.difficulty);
    
    debugPrint('Trip completed: ${route.name} in ${completedTrip.arrivalTime!.difference(trip.startTime).inMinutes} minutes');
  }

  void _updateVehicleFuel(String vehicleId, double fuelChange) {
    final vehicle = _vehicles[vehicleId];
    if (vehicle == null) return;
    
    final newFuel = (vehicle.fuel + fuelChange).clamp(0.0, vehicle.maxFuel);
    
    _vehicles[vehicleId] = Vehicle(
      id: vehicle.id,
      name: vehicle.name,
      type: vehicle.type,
      speed: vehicle.speed,
      acceleration: vehicle.acceleration,
      handling: vehicle.handling,
      durability: vehicle.durability,
      fuel: newFuel,
      maxFuel: vehicle.maxFuel,
      condition: vehicle.condition,
      suspicionLevel: vehicle.suspicionLevel,
      modifications: vehicle.modifications,
      cargoCapacity: vehicle.cargoCapacity,
      hiddenCapacity: vehicle.hiddenCapacity,
      isStolen: vehicle.isStolen,
      registeredOwner: vehicle.registeredOwner,
      lastMaintenance: vehicle.lastMaintenance,
      damageHistory: vehicle.damageHistory,
      value: vehicle.value,
      color: vehicle.color,
      licensePlate: vehicle.licensePlate,
    );
  }

  void _addVehicleWear(String vehicleId, double wearAmount) {
    final vehicle = _vehicles[vehicleId];
    if (vehicle == null) return;
    
    final random = math.Random();
    final wearChance = wearAmount * 0.1;
    
    if (random.nextDouble() < wearChance) {
      VehicleCondition newCondition = vehicle.condition;
      
      switch (vehicle.condition) {
        case VehicleCondition.excellent:
          newCondition = VehicleCondition.good;
          break;
        case VehicleCondition.good:
          newCondition = VehicleCondition.fair;
          break;
        case VehicleCondition.fair:
          newCondition = VehicleCondition.poor;
          break;
        case VehicleCondition.poor:
          newCondition = VehicleCondition.damaged;
          break;
        default:
          return;
      }
      
      final newDamageHistory = List<String>.from(vehicle.damageHistory)
        ..add('Wear from ${DateTime.now().toIso8601String()}');
      
      _vehicles[vehicleId] = Vehicle(
        id: vehicle.id,
        name: vehicle.name,
        type: vehicle.type,
        speed: vehicle.speed,
        acceleration: vehicle.acceleration,
        handling: vehicle.handling,
        durability: vehicle.durability,
        fuel: vehicle.fuel,
        maxFuel: vehicle.maxFuel,
        condition: newCondition,
        suspicionLevel: vehicle.suspicionLevel,
        modifications: vehicle.modifications,
        cargoCapacity: vehicle.cargoCapacity,
        hiddenCapacity: vehicle.hiddenCapacity,
        isStolen: vehicle.isStolen,
        registeredOwner: vehicle.registeredOwner,
        lastMaintenance: vehicle.lastMaintenance,
        damageHistory: newDamageHistory,
        value: vehicle.value,
        color: vehicle.color,
        licensePlate: vehicle.licensePlate,
      );
    }
  }

  void _updatePursuits() {
    final endedPursuits = <String>[];
    
    for (final pursuitId in _activePursuits.keys) {
      final pursuit = _activePursuits[pursuitId]!;
      final elapsed = DateTime.now().difference(pursuit.startTime);
      
      // Pursuits naturally decay over time
      if (elapsed.inMinutes > 30) {
        endedPursuits.add(pursuitId);
        debugPrint('Pursuit ${pursuitId} ended - lost the trail');
      } else {
        // Update pursuit intensity
        final decayRate = 0.02;
        final newIntensity = (pursuit.intensity - decayRate).clamp(0.0, 1.0);
        
        if (newIntensity <= 0.1) {
          endedPursuits.add(pursuitId);
          debugPrint('Pursuit ${pursuitId} ended - intensity too low');
        } else {
          _activePursuits[pursuitId] = PolicePursuit(
            id: pursuit.id,
            targetVehicleId: pursuit.targetVehicleId,
            level: pursuit.level,
            intensity: newIntensity,
            pursuingUnits: pursuit.pursuingUnits,
            startTime: pursuit.startTime,
            lastKnownPosition: pursuit.lastKnownPosition,
            heatLevel: pursuit.heatLevel,
            hasRoadblocks: pursuit.hasRoadblocks,
            hasHelicopterSupport: pursuit.hasHelicopterSupport,
            tactics: pursuit.tactics,
          );
        }
      }
    }
    
    // Remove ended pursuits
    for (final pursuitId in endedPursuits) {
      _activePursuits.remove(pursuitId);
    }
  }

  void _updateVehicleConditions() {
    // Vehicles naturally degrade over time without maintenance
    final now = DateTime.now();
    
    for (final vehicleId in _vehicles.keys) {
      final vehicle = _vehicles[vehicleId]!;
      
      if (vehicle.lastMaintenance != null) {
        final daysSinceMaintenance = now.difference(vehicle.lastMaintenance!).inDays;
        
        if (daysSinceMaintenance > 60) { // 2 months without maintenance
          _addVehicleWear(vehicleId, 0.1);
        }
      }
    }
  }

  void _startPursuit(String vehicleId, PursuitLevel level) {
    if (_activePursuits.values.any((p) => p.targetVehicleId == vehicleId)) {
      return; // Already being pursued
    }
    
    final pursuitId = 'pursuit_${DateTime.now().millisecondsSinceEpoch}';
    
    final units = <String>[];
    switch (level) {
      case PursuitLevel.low:
        units.addAll(['patrol_car_1']);
        break;
      case PursuitLevel.medium:
        units.addAll(['patrol_car_1', 'patrol_car_2']);
        break;
      case PursuitLevel.high:
        units.addAll(['patrol_car_1', 'patrol_car_2', 'swat_unit']);
        break;
      case PursuitLevel.maximum:
        units.addAll(['patrol_car_1', 'patrol_car_2', 'swat_unit', 'helicopter']);
        break;
      default:
        return;
    }
    
    final pursuit = PolicePursuit(
      id: pursuitId,
      targetVehicleId: vehicleId,
      level: level,
      intensity: 0.8,
      pursuingUnits: units,
      startTime: DateTime.now(),
      lastKnownPosition: _currentLocation,
      heatLevel: level.index * 0.25,
      hasRoadblocks: level.index >= 2,
      hasHelicopterSupport: level.index >= 3,
      tactics: ['standard_pursuit'],
    );
    
    _activePursuits[pursuitId] = pursuit;
    
    debugPrint('Police pursuit started: Level ${level.toString()}');
  }

  // Player actions
  bool startTrip(String routeId, List<String> cargo) {
    if (_currentVehicle == null) {
      debugPrint('No vehicle selected');
      return false;
    }
    
    final vehicle = _vehicles[_currentVehicle!];
    final route = _routes[routeId];
    
    if (vehicle == null || route == null) {
      debugPrint('Vehicle or route not found');
      return false;
    }
    
    if (vehicle.fuel < route.distance * 0.1) {
      debugPrint('Insufficient fuel for trip');
      return false;
    }
    
    if (route.requiresSpecialVehicle && !_canUseRoute(vehicle, route)) {
      debugPrint('Vehicle not suitable for this route');
      return false;
    }
    
    final tripId = 'trip_${DateTime.now().millisecondsSinceEpoch}';
    final trip = Trip(
      id: tripId,
      vehicleId: vehicle.id,
      routeId: route.id,
      startLocation: _currentLocation,
      targetLocation: route.waypoints.last,
      startTime: DateTime.now(),
      progress: 0.0,
      cargo: cargo,
      pursuitLevel: PursuitLevel.none,
      isActive: true,
      fuelUsed: 0.0,
      incidents: [],
    );
    
    _activeTrips[tripId] = trip;
    
    debugPrint('Started trip on ${route.name} with ${cargo.length} cargo items');
    return true;
  }

  bool _canUseRoute(Vehicle vehicle, Route route) {
    if (route.id == 'waterfront_smuggle') {
      return vehicle.type == VehicleType.boat;
    }
    return true;
  }

  bool purchaseVehicle(VehicleType type) {
    final template = _vehicleTemplates[type];
    if (template == null) return false;
    
    final cost = template['value'] as double;
    // Assume player has money - in real game, check and deduct money
    
    final vehicleId = 'vehicle_${DateTime.now().millisecondsSinceEpoch}';
    final vehicle = Vehicle(
      id: vehicleId,
      name: template['name'],
      type: type,
      speed: template['speed'],
      acceleration: template['acceleration'],
      handling: template['handling'],
      durability: template['durability'],
      fuel: template['maxFuel'],
      maxFuel: template['maxFuel'],
      condition: VehicleCondition.excellent,
      suspicionLevel: template['suspicionLevel'],
      modifications: [],
      cargoCapacity: template['cargoCapacity'],
      hiddenCapacity: template['hiddenCapacity'],
      isStolen: false,
      registeredOwner: 'Player',
      lastMaintenance: DateTime.now(),
      damageHistory: [],
      value: template['value'],
      color: _getRandomColor(),
      licensePlate: _generateLicensePlate(),
    );
    
    _vehicles[vehicleId] = vehicle;
    _currentVehicle = vehicleId;
    
    debugPrint('Purchased ${vehicle.name} for \$${cost.toStringAsFixed(2)}');
    return true;
  }

  Color _getRandomColor() {
    final colors = [
      Colors.red, Colors.blue, Colors.green, Colors.black,
      Colors.white, Colors.grey, Colors.grey[300]!, Colors.yellow,
    ];
    return colors[math.Random().nextInt(colors.length)];
  }

  bool modifyVehicle(String vehicleId, ModificationType modification) {
    final vehicle = _vehicles[vehicleId];
    if (vehicle == null || vehicle.modifications.contains(modification)) {
      return false;
    }
    
    _getModificationCost(modification);
    // Assume player has money - in real game, check and deduct money
    
    final newModifications = List<ModificationType>.from(vehicle.modifications)
      ..add(modification);
    
    _vehicles[vehicleId] = Vehicle(
      id: vehicle.id,
      name: vehicle.name,
      type: vehicle.type,
      speed: vehicle.speed,
      acceleration: vehicle.acceleration,
      handling: vehicle.handling,
      durability: vehicle.durability,
      fuel: vehicle.fuel,
      maxFuel: vehicle.maxFuel,
      condition: vehicle.condition,
      suspicionLevel: vehicle.suspicionLevel,
      modifications: newModifications,
      cargoCapacity: vehicle.cargoCapacity,
      hiddenCapacity: vehicle.hiddenCapacity + _getModificationCapacityBonus(modification),
      isStolen: vehicle.isStolen,
      registeredOwner: vehicle.registeredOwner,
      lastMaintenance: vehicle.lastMaintenance,
      damageHistory: vehicle.damageHistory,
      value: vehicle.value,
      color: vehicle.color,
      licensePlate: vehicle.licensePlate,
    );
    
    debugPrint('Added ${modification.toString()} to ${vehicle.name}');
    return true;
  }

  double _getModificationCost(ModificationType modification) {
    switch (modification) {
      case ModificationType.engine_upgrade:
        return 15000.0;
      case ModificationType.armor_plating:
        return 25000.0;
      case ModificationType.bulletproof_glass:
        return 12000.0;
      case ModificationType.hidden_compartments:
        return 8000.0;
      case ModificationType.nitrous_system:
        return 10000.0;
      case ModificationType.surveillance_equipment:
        return 20000.0;
      case ModificationType.communication_array:
        return 15000.0;
      case ModificationType.weapon_systems:
        return 50000.0;
      case ModificationType.stealth_coating:
        return 35000.0;
      case ModificationType.tracking_blocker:
        return 18000.0;
    }
  }

  double _getModificationCapacityBonus(ModificationType modification) {
    switch (modification) {
      case ModificationType.hidden_compartments:
        return 200.0;
      default:
        return 0.0;
    }
  }

  bool refuelVehicle(String vehicleId) {
    final vehicle = _vehicles[vehicleId];
    if (vehicle == null) return false;
    
    final fuelNeeded = vehicle.maxFuel - vehicle.fuel;
    final cost = fuelNeeded * 3.0; // $3 per fuel unit
    
    _updateVehicleFuel(vehicleId, fuelNeeded);
    
    debugPrint('Refueled ${vehicle.name} for \$${cost.toStringAsFixed(2)}');
    return true;
  }

  bool repairVehicle(String vehicleId) {
    final vehicle = _vehicles[vehicleId];
    if (vehicle == null || vehicle.condition == VehicleCondition.excellent) {
      return false;
    }
    
    final cost = _getRepairCost(vehicle.condition);
    
    _vehicles[vehicleId] = Vehicle(
      id: vehicle.id,
      name: vehicle.name,
      type: vehicle.type,
      speed: vehicle.speed,
      acceleration: vehicle.acceleration,
      handling: vehicle.handling,
      durability: vehicle.durability,
      fuel: vehicle.fuel,
      maxFuel: vehicle.maxFuel,
      condition: VehicleCondition.excellent,
      suspicionLevel: vehicle.suspicionLevel,
      modifications: vehicle.modifications,
      cargoCapacity: vehicle.cargoCapacity,
      hiddenCapacity: vehicle.hiddenCapacity,
      isStolen: vehicle.isStolen,
      registeredOwner: vehicle.registeredOwner,
      lastMaintenance: DateTime.now(),
      damageHistory: vehicle.damageHistory,
      value: vehicle.value,
      color: vehicle.color,
      licensePlate: vehicle.licensePlate,
    );
    
    debugPrint('Repaired ${vehicle.name} for \$${cost.toStringAsFixed(2)}');
    return true;
  }

  double _getRepairCost(VehicleCondition condition) {
    switch (condition) {
      case VehicleCondition.good:
        return 500.0;
      case VehicleCondition.fair:
        return 1500.0;
      case VehicleCondition.poor:
        return 5000.0;
      case VehicleCondition.damaged:
        return 15000.0;
      case VehicleCondition.destroyed:
        return 50000.0;
      default:
        return 0.0;
    }
  }

  void switchVehicle(String vehicleId) {
    if (_vehicles.containsKey(vehicleId)) {
      _currentVehicle = vehicleId;
      debugPrint('Switched to ${_vehicles[vehicleId]!.name}');
    }
  }

  // Public interface
  Vehicle? get currentVehicle => _currentVehicle != null ? _vehicles[_currentVehicle!] : null;
  Offset get currentLocation => _currentLocation;
  
  List<Vehicle> getVehicles() => _vehicles.values.toList();
  List<Route> getRoutes() => _routes.values.toList();
  List<Trip> getActiveTrips() => _activeTrips.values.toList();
  List<Trip> getCompletedTrips() => List.unmodifiable(_completedTrips);
  List<PolicePursuit> getActivePursuits() => _activePursuits.values.toList();
  
  List<Vehicle> getAvailableVehicles() => _vehicles.values.where((v) => 
    v.condition != VehicleCondition.destroyed && v.fuel > 0).toList();
  
  bool get isBeingPursued => _activePursuits.values
      .any((p) => p.targetVehicleId == _currentVehicle);
  
  PursuitLevel get currentPursuitLevel => _activePursuits.values
      .where((p) => p.targetVehicleId == _currentVehicle)
      .map((p) => p.level)
      .fold(PursuitLevel.none, (max, level) => level.index > max.index ? level : max);
  
  bool get hasActiveTrip => _activeTrips.values.any((t) => t.vehicleId == _currentVehicle);
  
  Trip? getCurrentTrip() => _activeTrips.values
      .where((t) => t.vehicleId == _currentVehicle)
      .isNotEmpty 
          ? _activeTrips.values.where((t) => t.vehicleId == _currentVehicle).first 
          : null;
  
  double getVehicleCost(VehicleType type) => _vehicleTemplates[type]?['value'] ?? 0.0;
  
  List<VehicleType> getAvailableVehicleTypes() => _vehicleTemplates.keys.toList();
  
  List<ModificationType> getAvailableModifications(String vehicleId) {
    final vehicle = _vehicles[vehicleId];
    if (vehicle == null) return [];
    
    return ModificationType.values
        .where((mod) => !vehicle.modifications.contains(mod))
        .toList();
  }
}

// Vehicle status widget
class VehicleStatusWidget extends StatefulWidget {
  const VehicleStatusWidget({super.key});

  @override
  State<VehicleStatusWidget> createState() => _VehicleStatusWidgetState();
}

class _VehicleStatusWidgetState extends State<VehicleStatusWidget> {
  final VehicleTransportationSystem _transport = VehicleTransportationSystem();
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    _transport.initialize();
    _updateTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentVehicle = _transport.currentVehicle;
    final currentTrip = _transport.getCurrentTrip();
    final pursuitLevel = _transport.currentPursuitLevel;
    final isBeingPursued = _transport.isBeingPursued;
    
    if (currentVehicle == null) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Text(
          'No Vehicle',
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      );
    }
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _getVehicleColor(currentVehicle).withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                _getVehicleIcon(currentVehicle.type),
                color: _getVehicleColor(currentVehicle),
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  currentVehicle.name,
                  style: TextStyle(
                    color: _getVehicleColor(currentVehicle),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Condition: ${_getConditionText(currentVehicle.condition)}',
                      style: TextStyle(
                        color: _getConditionColor(currentVehicle.condition),
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      'Fuel: ${currentVehicle.fuel.toStringAsFixed(0)}/${currentVehicle.maxFuel.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: currentVehicle.fuel > currentVehicle.maxFuel * 0.3 ? Colors.green : Colors.red,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Mods: ${currentVehicle.modifications.length}',
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                  Text(
                    currentVehicle.licensePlate,
                    style: const TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 4),
          
          LinearProgressIndicator(
            value: currentVehicle.fuel / currentVehicle.maxFuel,
            backgroundColor: Colors.grey[800],
            valueColor: AlwaysStoppedAnimation<Color>(
              currentVehicle.fuel > currentVehicle.maxFuel * 0.5 ? Colors.green : 
              currentVehicle.fuel > currentVehicle.maxFuel * 0.2 ? Colors.orange : Colors.red,
            ),
          ),
          
          if (isBeingPursued) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_police, color: Colors.red, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'PURSUIT: ${_getPursuitText(pursuitLevel)}',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          if (currentTrip != null) ...[
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'In Transit: ${(currentTrip.progress * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(color: Colors.blue, fontSize: 11, fontWeight: FontWeight.bold),
                ),
                LinearProgressIndicator(
                  value: currentTrip.progress,
                  backgroundColor: Colors.grey[800],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                if (currentTrip.cargo.isNotEmpty)
                  Text(
                    'Cargo: ${currentTrip.cargo.length} items',
                    style: const TextStyle(color: Colors.white70, fontSize: 10),
                  ),
              ],
            ),
          ],
          
          const SizedBox(height: 8),
          
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: currentVehicle.fuel < currentVehicle.maxFuel
                      ? () => _transport.refuelVehicle(currentVehicle.id)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    padding: const EdgeInsets.symmetric(vertical: 4),
                  ),
                  child: const Text('Refuel', style: TextStyle(fontSize: 10)),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: ElevatedButton(
                  onPressed: currentVehicle.condition != VehicleCondition.excellent
                      ? () => _transport.repairVehicle(currentVehicle.id)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[700],
                    padding: const EdgeInsets.symmetric(vertical: 4),
                  ),
                  child: const Text('Repair', style: TextStyle(fontSize: 10)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getVehicleColor(Vehicle vehicle) {
    switch (vehicle.type) {
      case VehicleType.motorcycle:
        return Colors.orange;
      case VehicleType.sports_car:
        return Colors.red;
      case VehicleType.helicopter:
        return Colors.purple;
      case VehicleType.boat:
        return Colors.blue;
      case VehicleType.armored_car:
        return Colors.grey;
      default:
        return Colors.green;
    }
  }

  IconData _getVehicleIcon(VehicleType type) {
    switch (type) {
      case VehicleType.motorcycle:
        return Icons.motorcycle;
      case VehicleType.helicopter:
        return Icons.flight;
      case VehicleType.boat:
        return Icons.directions_boat;
      case VehicleType.truck:
        return Icons.local_shipping;
      default:
        return Icons.directions_car;
    }
  }

  Color _getConditionColor(VehicleCondition condition) {
    switch (condition) {
      case VehicleCondition.excellent:
        return Colors.green;
      case VehicleCondition.good:
        return Colors.lightGreen;
      case VehicleCondition.fair:
        return Colors.yellow;
      case VehicleCondition.poor:
        return Colors.orange;
      case VehicleCondition.damaged:
        return Colors.red;
      case VehicleCondition.destroyed:
        return Colors.grey;
    }
  }

  String _getConditionText(VehicleCondition condition) {
    switch (condition) {
      case VehicleCondition.excellent:
        return 'Excellent';
      case VehicleCondition.good:
        return 'Good';
      case VehicleCondition.fair:
        return 'Fair';
      case VehicleCondition.poor:
        return 'Poor';
      case VehicleCondition.damaged:
        return 'Damaged';
      case VehicleCondition.destroyed:
        return 'Destroyed';
    }
  }

  String _getPursuitText(PursuitLevel level) {
    switch (level) {
      case PursuitLevel.low:
        return 'LOW';
      case PursuitLevel.medium:
        return 'MEDIUM';
      case PursuitLevel.high:
        return 'HIGH';
      case PursuitLevel.maximum:
        return 'MAXIMUM';
      default:
        return 'NONE';
    }
  }
}
