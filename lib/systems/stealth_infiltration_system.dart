import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';

enum StealthState {
  hidden,
  suspicious,
  detected,
  searching,
  alert,
  calm,
}

enum NoiseLevel {
  silent,
  quiet,
  normal,
  loud,
  very_loud,
}

enum LightLevel {
  pitch_black,
  very_dark,
  dark,
  dim,
  normal,
  bright,
  very_bright,
}

enum InfiltrationObjective {
  steal_item,
  plant_device,
  gather_intel,
  sabotage,
  assassination,
  escape,
  surveillance,
}

class Guard {
  final String id;
  final String name;
  final Offset position;
  final Offset patrolStart;
  final Offset patrolEnd;
  final double alertness;
  final double visionRange;
  final double hearingRange;
  final double patrolSpeed;
  final List<Offset> patrolPath;
  final int currentPatrolIndex;
  final StealthState state;
  final double suspicionLevel;
  final DateTime lastSeenTarget;
  final Offset? lastKnownTargetPosition;
  final double faceDirection; // in radians
  final double visionAngle; // in radians

  const Guard({
    required this.id,
    required this.name,
    required this.position,
    required this.patrolStart,
    required this.patrolEnd,
    required this.alertness,
    required this.visionRange,
    required this.hearingRange,
    required this.patrolSpeed,
    required this.patrolPath,
    required this.currentPatrolIndex,
    required this.state,
    required this.suspicionLevel,
    required this.lastSeenTarget,
    this.lastKnownTargetPosition,
    required this.faceDirection,
    required this.visionAngle,
  });
}

class SecurityCamera {
  final String id;
  final Offset position;
  final double range;
  final double sweepAngle;
  final double currentAngle;
  final double rotationSpeed;
  final bool isActive;
  final bool hasNightVision;
  final double detectionSensitivity;
  final List<Offset> blindSpots;

  const SecurityCamera({
    required this.id,
    required this.position,
    required this.range,
    required this.sweepAngle,
    required this.currentAngle,
    required this.rotationSpeed,
    required this.isActive,
    required this.hasNightVision,
    required this.detectionSensitivity,
    required this.blindSpots,
  });
}

class StealthZone {
  final String id;
  final String name;
  final Rect bounds;
  final LightLevel lightLevel;
  final NoiseLevel ambientNoise;
  final List<Rect> coverAreas;
  final List<Rect> shadowAreas;
  final List<Offset> ventilationShafts;
  final List<Offset> climbableWalls;
  final Map<String, double> securityLevel; // area_id -> security_level

  const StealthZone({
    required this.id,
    required this.name,
    required this.bounds,
    required this.lightLevel,
    required this.ambientNoise,
    required this.coverAreas,
    required this.shadowAreas,
    required this.ventilationShafts,
    required this.climbableWalls,
    required this.securityLevel,
  });
}

class StealthAction {
  final String id;
  final String type; // move, hide, distract, disable, etc.
  final Offset? targetPosition;
  final String? targetId;
  final Duration executionTime;
  final double noiseGenerated;
  final double riskLevel;
  final bool requiresTools;
  final List<String> requirements;

  const StealthAction({
    required this.id,
    required this.type,
    this.targetPosition,
    this.targetId,
    required this.executionTime,
    required this.noiseGenerated,
    required this.riskLevel,
    required this.requiresTools,
    required this.requirements,
  });
}

class Distraction {
  final String id;
  final Offset position;
  final double radius;
  final Duration duration;
  final NoiseLevel noiseLevel;
  final DateTime startTime;
  final bool isActive;
  final String type; // sound, visual, smell, etc.

  const Distraction({
    required this.id,
    required this.position,
    required this.radius,
    required this.duration,
    required this.noiseLevel,
    required this.startTime,
    required this.isActive,
    required this.type,
  });
}

class StealthInfiltrationSystem {
  static final StealthInfiltrationSystem _instance = StealthInfiltrationSystem._internal();
  factory StealthInfiltrationSystem() => _instance;
  StealthInfiltrationSystem._internal();

  final Map<String, Guard> _guards = {};
  final Map<String, SecurityCamera> _cameras = {};
  final Map<String, StealthZone> _zones = {};
  final Map<String, Distraction> _activeDistractions = {};
  final List<StealthAction> _actionHistory = [];
  
  Offset _playerPosition = const Offset(0, 0);
  StealthState _playerStealthState = StealthState.hidden;
  double _playerVisibility = 0.0;
  double _playerNoiseLevel = 0.0;
  bool _playerInShadows = false;
  bool _playerInCover = false;
  String? _currentZone;
  
  Timer? _stealthTimer;
  final Duration _updateInterval = const Duration(milliseconds: 200);

  void initialize() {
    _setupStealthZones();
    _generateGuards();
    _generateCameras();
    _startStealthTimer();
  }

  void dispose() {
    _stealthTimer?.cancel();
  }

  void _setupStealthZones() {
    final zones = [
      StealthZone(
        id: 'warehouse_district',
        name: 'Warehouse District',
        bounds: const Rect.fromLTWH(0, 0, 400, 300),
        lightLevel: LightLevel.dark,
        ambientNoise: NoiseLevel.quiet,
        coverAreas: [
          const Rect.fromLTWH(50, 50, 40, 30),
          const Rect.fromLTWH(200, 100, 60, 40),
          const Rect.fromLTWH(300, 180, 50, 35),
        ],
        shadowAreas: [
          const Rect.fromLTWH(80, 200, 100, 50),
          const Rect.fromLTWH(250, 50, 80, 60),
        ],
        ventilationShafts: [
          const Offset(120, 30),
          const Offset(350, 120),
        ],
        climbableWalls: [
          const Offset(100, 0),
          const Offset(300, 0),
        ],
        securityLevel: {
          'perimeter': 0.3,
          'interior': 0.6,
          'restricted': 0.9,
        },
      ),
      
      StealthZone(
        id: 'office_building',
        name: 'Corporate Office',
        bounds: const Rect.fromLTWH(0, 0, 300, 400),
        lightLevel: LightLevel.normal,
        ambientNoise: NoiseLevel.normal,
        coverAreas: [
          const Rect.fromLTWH(30, 100, 50, 20), // Reception desk
          const Rect.fromLTWH(150, 200, 40, 30), // Office cubicles
          const Rect.fromLTWH(200, 350, 80, 25), // Conference table
        ],
        shadowAreas: [
          const Rect.fromLTWH(0, 300, 60, 40), // Stairwell
        ],
        ventilationShafts: [
          const Offset(150, 50),
          const Offset(250, 250),
        ],
        climbableWalls: [],
        securityLevel: {
          'lobby': 0.4,
          'offices': 0.2,
          'executive': 0.8,
          'server_room': 1.0,
        },
      ),
      
      StealthZone(
        id: 'gang_hideout',
        name: 'Gang Hideout',
        bounds: const Rect.fromLTWH(0, 0, 250, 200),
        lightLevel: LightLevel.dim,
        ambientNoise: NoiseLevel.loud,
        coverAreas: [
          const Rect.fromLTWH(40, 80, 30, 40),
          const Rect.fromLTWH(180, 50, 35, 25),
        ],
        shadowAreas: [
          const Rect.fromLTWH(200, 150, 50, 50),
          const Rect.fromLTWH(20, 20, 60, 30),
        ],
        ventilationShafts: [],
        climbableWalls: [
          const Offset(0, 100),
          const Offset(250, 80),
        ],
        securityLevel: {
          'entrance': 0.7,
          'main_room': 0.8,
          'boss_office': 0.95,
        },
      ),
    ];

    for (final zone in zones) {
      _zones[zone.id] = zone;
    }
  }

  void _generateGuards() {
    final guardData = [
      {
        'id': 'guard_1',
        'name': 'Security Guard',
        'zone': 'warehouse_district',
        'patrolPath': [
          const Offset(50, 150),
          const Offset(150, 150),
          const Offset(150, 250),
          const Offset(50, 250),
        ],
        'alertness': 0.6,
        'visionRange': 80.0,
        'hearingRange': 60.0,
      },
      {
        'id': 'guard_2',
        'name': 'Night Watchman',
        'zone': 'warehouse_district',
        'patrolPath': [
          const Offset(300, 100),
          const Offset(380, 100),
          const Offset(380, 200),
          const Offset(300, 200),
        ],
        'alertness': 0.4,
        'visionRange': 70.0,
        'hearingRange': 50.0,
      },
      {
        'id': 'office_security',
        'name': 'Office Security',
        'zone': 'office_building',
        'patrolPath': [
          const Offset(100, 50),
          const Offset(200, 50),
          const Offset(200, 150),
          const Offset(100, 150),
        ],
        'alertness': 0.7,
        'visionRange': 90.0,
        'hearingRange': 70.0,
      },
      {
        'id': 'gang_lookout',
        'name': 'Gang Lookout',
        'zone': 'gang_hideout',
        'patrolPath': [
          const Offset(125, 50),
          const Offset(200, 100),
          const Offset(125, 150),
          const Offset(50, 100),
        ],
        'alertness': 0.9,
        'visionRange': 100.0,
        'hearingRange': 80.0,
      },
    ];

    for (final data in guardData) {
      final patrolPath = data['patrolPath'] as List<Offset>;
      final guard = Guard(
        id: data['id'] as String,
        name: data['name'] as String,
        position: patrolPath.first,
        patrolStart: patrolPath.first,
        patrolEnd: patrolPath.last,
        alertness: data['alertness'] as double,
        visionRange: data['visionRange'] as double,
        hearingRange: data['hearingRange'] as double,
        patrolSpeed: 20.0,
        patrolPath: patrolPath,
        currentPatrolIndex: 0,
        state: StealthState.calm,
        suspicionLevel: 0.0,
        lastSeenTarget: DateTime.now().subtract(const Duration(hours: 1)),
        lastKnownTargetPosition: null,
        faceDirection: 0.0,
        visionAngle: math.pi / 3, // 60 degrees
      );
      
      _guards[guard.id] = guard;
    }
  }

  void _generateCameras() {
    final cameraData = [
      {
        'id': 'cam_warehouse_1',
        'position': const Offset(200, 50),
        'range': 120.0,
        'sweepAngle': math.pi, // 180 degrees
        'zone': 'warehouse_district',
      },
      {
        'id': 'cam_warehouse_2',
        'position': const Offset(350, 250),
        'range': 100.0,
        'sweepAngle': math.pi * 0.75, // 135 degrees
        'zone': 'warehouse_district',
      },
      {
        'id': 'cam_office_lobby',
        'position': const Offset(150, 100),
        'range': 80.0,
        'sweepAngle': math.pi * 0.5, // 90 degrees
        'zone': 'office_building',
      },
      {
        'id': 'cam_office_hall',
        'position': const Offset(250, 300),
        'range': 90.0,
        'sweepAngle': math.pi * 0.6, // 108 degrees
        'zone': 'office_building',
      },
    ];

    for (final data in cameraData) {
      final camera = SecurityCamera(
        id: data['id'] as String,
        position: data['position'] as Offset,
        range: data['range'] as double,
        sweepAngle: data['sweepAngle'] as double,
        currentAngle: 0.0,
        rotationSpeed: 0.02, // radians per update
        isActive: true,
        hasNightVision: math.Random().nextBool(),
        detectionSensitivity: 0.7,
        blindSpots: [],
      );
      
      _cameras[camera.id] = camera;
    }
  }

  void _startStealthTimer() {
    _stealthTimer = Timer.periodic(_updateInterval, (timer) {
      _updateStealth();
    });
  }

  void _updateStealth() {
    _updateGuards();
    _updateCameras();
    _updatePlayerDetection();
    _updateDistractions();
    _calculatePlayerVisibility();
  }

  void _updateGuards() {
    for (final guardId in _guards.keys) {
      final guard = _guards[guardId]!;
      
      // Update patrol
      final updatedGuard = _updateGuardPatrol(guard);
      
      // Update detection state
      final detectionUpdatedGuard = _updateGuardDetection(updatedGuard);
      
      _guards[guardId] = detectionUpdatedGuard;
    }
  }

  Guard _updateGuardPatrol(Guard guard) {
    if (guard.state == StealthState.searching || guard.state == StealthState.alert) {
      // Don't patrol when searching or alert
      return guard;
    }

    final targetPoint = guard.patrolPath[guard.currentPatrolIndex];
    final distance = _getDistance(guard.position, targetPoint);
    
    if (distance < 5.0) {
      // Reached patrol point, move to next
      final nextIndex = (guard.currentPatrolIndex + 1) % guard.patrolPath.length;
      return Guard(
        id: guard.id,
        name: guard.name,
        position: guard.position,
        patrolStart: guard.patrolStart,
        patrolEnd: guard.patrolEnd,
        alertness: guard.alertness,
        visionRange: guard.visionRange,
        hearingRange: guard.hearingRange,
        patrolSpeed: guard.patrolSpeed,
        patrolPath: guard.patrolPath,
        currentPatrolIndex: nextIndex,
        state: guard.state,
        suspicionLevel: guard.suspicionLevel,
        lastSeenTarget: guard.lastSeenTarget,
        lastKnownTargetPosition: guard.lastKnownTargetPosition,
        faceDirection: guard.faceDirection,
        visionAngle: guard.visionAngle,
      );
    } else {
      // Move towards target point
      final direction = Offset(
        targetPoint.dx - guard.position.dx,
        targetPoint.dy - guard.position.dy,
      );
      final normalizedDirection = _normalizeVector(direction);
      final newPosition = Offset(
        guard.position.dx + normalizedDirection.dx * guard.patrolSpeed,
        guard.position.dy + normalizedDirection.dy * guard.patrolSpeed,
      );
      
      // Update face direction
      final faceDirection = math.atan2(direction.dy, direction.dx);
      
      return Guard(
        id: guard.id,
        name: guard.name,
        position: newPosition,
        patrolStart: guard.patrolStart,
        patrolEnd: guard.patrolEnd,
        alertness: guard.alertness,
        visionRange: guard.visionRange,
        hearingRange: guard.hearingRange,
        patrolSpeed: guard.patrolSpeed,
        patrolPath: guard.patrolPath,
        currentPatrolIndex: guard.currentPatrolIndex,
        state: guard.state,
        suspicionLevel: guard.suspicionLevel,
        lastSeenTarget: guard.lastSeenTarget,
        lastKnownTargetPosition: guard.lastKnownTargetPosition,
        faceDirection: faceDirection,
        visionAngle: guard.visionAngle,
      );
    }
  }

  Guard _updateGuardDetection(Guard guard) {
    final distanceToPlayer = _getDistance(guard.position, _playerPosition);
    
    // Check if player is in vision range
    if (distanceToPlayer <= guard.visionRange) {
      final angleToPlayer = math.atan2(
        _playerPosition.dy - guard.position.dy,
        _playerPosition.dx - guard.position.dx,
      );
      
      final angleDifference = (angleToPlayer - guard.faceDirection).abs();
      final normalizedAngleDiff = angleDifference > math.pi 
          ? 2 * math.pi - angleDifference 
          : angleDifference;
      
      if (normalizedAngleDiff <= guard.visionAngle / 2) {
        // Player is in vision cone
        double detectionChance = _calculateDetectionChance(guard, distanceToPlayer);
        
        if (detectionChance > 0.8) {
          // Player detected
          return _setGuardState(guard, StealthState.detected);
        } else if (detectionChance > 0.4) {
          // Player suspicious
          return _setGuardState(guard, StealthState.suspicious);
        }
      }
    }
    
    // Check if player is in hearing range
    if (distanceToPlayer <= guard.hearingRange && _playerNoiseLevel > 0.3) {
      final noiseDetectionChance = _playerNoiseLevel * guard.alertness;
      if (noiseDetectionChance > 0.6) {
        return _setGuardState(guard, StealthState.suspicious);
      }
    }
    
    // Decay suspicion over time
    if (guard.state == StealthState.suspicious && 
        DateTime.now().difference(guard.lastSeenTarget).inSeconds > 10) {
      return _setGuardState(guard, StealthState.calm);
    }
    
    return guard;
  }

  Guard _setGuardState(Guard guard, StealthState newState) {
    return Guard(
      id: guard.id,
      name: guard.name,
      position: guard.position,
      patrolStart: guard.patrolStart,
      patrolEnd: guard.patrolEnd,
      alertness: guard.alertness,
      visionRange: guard.visionRange,
      hearingRange: guard.hearingRange,
      patrolSpeed: guard.patrolSpeed,
      patrolPath: guard.patrolPath,
      currentPatrolIndex: guard.currentPatrolIndex,
      state: newState,
      suspicionLevel: newState == StealthState.detected ? 1.0 : 
                     newState == StealthState.suspicious ? 0.7 : 0.0,
      lastSeenTarget: newState != StealthState.calm ? DateTime.now() : guard.lastSeenTarget,
      lastKnownTargetPosition: newState != StealthState.calm ? _playerPosition : null,
      faceDirection: guard.faceDirection,
      visionAngle: guard.visionAngle,
    );
  }

  double _calculateDetectionChance(Guard guard, double distance) {
    double baseChance = guard.alertness;
    
    // Distance factor
    final distanceFactor = 1.0 - (distance / guard.visionRange);
    baseChance *= distanceFactor;
    
    // Light level factor
    final currentZone = _zones[_currentZone];
    if (currentZone != null) {
      final lightFactor = _getLightDetectionMultiplier(currentZone.lightLevel);
      baseChance *= lightFactor;
    }
    
    // Shadow factor
    if (_playerInShadows) {
      baseChance *= 0.3;
    }
    
    // Cover factor
    if (_playerInCover) {
      baseChance *= 0.5;
    }
    
    // Movement factor
    baseChance *= (1.0 + _playerNoiseLevel);
    
    return baseChance.clamp(0.0, 1.0);
  }

  double _getLightDetectionMultiplier(LightLevel lightLevel) {
    switch (lightLevel) {
      case LightLevel.pitch_black:
        return 0.1;
      case LightLevel.very_dark:
        return 0.3;
      case LightLevel.dark:
        return 0.5;
      case LightLevel.dim:
        return 0.7;
      case LightLevel.normal:
        return 1.0;
      case LightLevel.bright:
        return 1.3;
      case LightLevel.very_bright:
        return 1.5;
    }
  }

  void _updateCameras() {
    for (final cameraId in _cameras.keys) {
      final camera = _cameras[cameraId]!;
      
      if (!camera.isActive) continue;
      
      // Update rotation
      final newAngle = camera.currentAngle + camera.rotationSpeed;
      final normalizedAngle = newAngle % (2 * math.pi);
      
      // Check if player is in camera view
      final distanceToPlayer = _getDistance(camera.position, _playerPosition);
      if (distanceToPlayer <= camera.range) {
        final angleToPlayer = math.atan2(
          _playerPosition.dy - camera.position.dy,
          _playerPosition.dx - camera.position.dx,
        );
        
        final angleDifference = (angleToPlayer - normalizedAngle).abs();
        final normalizedAngleDiff = angleDifference > math.pi 
            ? 2 * math.pi - angleDifference 
            : angleDifference;
        
        if (normalizedAngleDiff <= camera.sweepAngle / 2) {
          // Player is in camera view
          double detectionChance = camera.detectionSensitivity;
          
          // Apply light level modifier
          final currentZone = _zones[_currentZone];
          if (currentZone != null) {
            if (camera.hasNightVision) {
              detectionChance *= 1.2;
            } else {
              detectionChance *= _getLightDetectionMultiplier(currentZone.lightLevel);
            }
          }
          
          // Apply cover/shadow modifiers
          if (_playerInShadows && !camera.hasNightVision) {
            detectionChance *= 0.4;
          }
          if (_playerInCover) {
            detectionChance *= 0.6;
          }
          
          if (detectionChance > 0.7) {
            _triggerCameraAlert(camera);
          }
        }
      }
      
      // Update camera
      _cameras[cameraId] = SecurityCamera(
        id: camera.id,
        position: camera.position,
        range: camera.range,
        sweepAngle: camera.sweepAngle,
        currentAngle: normalizedAngle,
        rotationSpeed: camera.rotationSpeed,
        isActive: camera.isActive,
        hasNightVision: camera.hasNightVision,
        detectionSensitivity: camera.detectionSensitivity,
        blindSpots: camera.blindSpots,
      );
    }
  }

  void _triggerCameraAlert(SecurityCamera camera) {
    // Alert nearby guards
    for (final guardId in _guards.keys) {
      final guard = _guards[guardId]!;
      final distanceToCamera = _getDistance(guard.position, camera.position);
      
      if (distanceToCamera < 100.0) {
        _guards[guardId] = _setGuardState(guard, StealthState.alert);
      }
    }
    
    debugPrint('Camera ${camera.id} detected player!');
  }

  void _updatePlayerDetection() {
    // Count how many guards can see the player
    int detectingGuards = 0;
    int suspiciousGuards = 0;
    
    for (final guard in _guards.values) {
      if (guard.state == StealthState.detected) {
        detectingGuards++;
      } else if (guard.state == StealthState.suspicious) {
        suspiciousGuards++;
      }
    }
    
    // Update player stealth state
    if (detectingGuards > 0) {
      _playerStealthState = StealthState.detected;
    } else if (suspiciousGuards > 0) {
      _playerStealthState = StealthState.suspicious;
    } else {
      _playerStealthState = StealthState.hidden;
    }
  }

  void _updateDistractions() {
    final now = DateTime.now();
    final expiredDistractions = <String>[];
    
    for (final distractionId in _activeDistractions.keys) {
      final distraction = _activeDistractions[distractionId]!;
      
      if (now.difference(distraction.startTime) >= distraction.duration) {
        expiredDistractions.add(distractionId);
      } else {
        // Apply distraction effects to nearby guards
        for (final guardId in _guards.keys) {
          final guard = _guards[guardId]!;
          final distanceToDistraction = _getDistance(guard.position, distraction.position);
          
          if (distanceToDistraction <= distraction.radius) {
            // Move guard towards distraction
            _moveGuardTowards(guardId, distraction.position);
          }
        }
      }
    }
    
    // Remove expired distractions
    for (final id in expiredDistractions) {
      _activeDistractions.remove(id);
    }
  }

  void _moveGuardTowards(String guardId, Offset target) {
    final guard = _guards[guardId]!;
    final direction = Offset(
      target.dx - guard.position.dx,
      target.dy - guard.position.dy,
    );
    final normalizedDirection = _normalizeVector(direction);
    final newPosition = Offset(
      guard.position.dx + normalizedDirection.dx * guard.patrolSpeed * 0.5,
      guard.position.dy + normalizedDirection.dy * guard.patrolSpeed * 0.5,
    );
    
    _guards[guardId] = Guard(
      id: guard.id,
      name: guard.name,
      position: newPosition,
      patrolStart: guard.patrolStart,
      patrolEnd: guard.patrolEnd,
      alertness: guard.alertness,
      visionRange: guard.visionRange,
      hearingRange: guard.hearingRange,
      patrolSpeed: guard.patrolSpeed,
      patrolPath: guard.patrolPath,
      currentPatrolIndex: guard.currentPatrolIndex,
      state: StealthState.searching,
      suspicionLevel: guard.suspicionLevel,
      lastSeenTarget: guard.lastSeenTarget,
      lastKnownTargetPosition: guard.lastKnownTargetPosition,
      faceDirection: math.atan2(direction.dy, direction.dx),
      visionAngle: guard.visionAngle,
    );
  }

  void _calculatePlayerVisibility() {
    double visibility = 0.5; // Base visibility
    
    // Apply zone modifiers
    final currentZone = _zones[_currentZone];
    if (currentZone != null) {
      // Light level modifier
      switch (currentZone.lightLevel) {
        case LightLevel.pitch_black:
          visibility *= 0.1;
          break;
        case LightLevel.very_dark:
          visibility *= 0.3;
          break;
        case LightLevel.dark:
          visibility *= 0.5;
          break;
        case LightLevel.dim:
          visibility *= 0.7;
          break;
        case LightLevel.normal:
          visibility *= 1.0;
          break;
        case LightLevel.bright:
          visibility *= 1.3;
          break;
        case LightLevel.very_bright:
          visibility *= 1.5;
          break;
      }
    }
    
    // Cover modifier
    if (_playerInCover) {
      visibility *= 0.3;
    }
    
    // Shadow modifier
    if (_playerInShadows) {
      visibility *= 0.2;
    }
    
    // Movement modifier
    visibility *= (1.0 + _playerNoiseLevel);
    
    _playerVisibility = visibility.clamp(0.0, 2.0);
  }

  // Player actions
  void movePlayer(Offset newPosition) {
    final oldPosition = _playerPosition;
    _playerPosition = newPosition;
    
    // Calculate movement speed to determine noise
    final distance = _getDistance(oldPosition, newPosition);
    _playerNoiseLevel = (distance / 10.0).clamp(0.0, 1.0);
    
    // Check if player is in cover or shadows
    _updatePlayerEnvironmentStatus();
    
    // Record action
    final action = StealthAction(
      id: 'move_${DateTime.now().millisecondsSinceEpoch}',
      type: 'move',
      targetPosition: newPosition,
      executionTime: const Duration(milliseconds: 500),
      noiseGenerated: _playerNoiseLevel,
      riskLevel: _playerVisibility,
      requiresTools: false,
      requirements: [],
    );
    
    _actionHistory.add(action);
  }

  void _updatePlayerEnvironmentStatus() {
    final currentZone = _zones[_currentZone];
    if (currentZone == null) return;
    
    // Check if in cover
    _playerInCover = currentZone.coverAreas.any((cover) => cover.contains(_playerPosition));
    
    // Check if in shadows
    _playerInShadows = currentZone.shadowAreas.any((shadow) => shadow.contains(_playerPosition));
  }

  bool createDistraction(Offset position, String type) {
    final distractionId = 'distraction_${DateTime.now().millisecondsSinceEpoch}';
    
    NoiseLevel noiseLevel;
    double radius;
    Duration duration;
    
    switch (type) {
      case 'thrown_object':
        noiseLevel = NoiseLevel.normal;
        radius = 50.0;
        duration = const Duration(seconds: 5);
        break;
      case 'explosive':
        noiseLevel = NoiseLevel.very_loud;
        radius = 150.0;
        duration = const Duration(seconds: 15);
        break;
      case 'radio':
        noiseLevel = NoiseLevel.loud;
        radius = 80.0;
        duration = const Duration(seconds: 10);
        break;
      default:
        return false;
    }
    
    final distraction = Distraction(
      id: distractionId,
      position: position,
      radius: radius,
      duration: duration,
      noiseLevel: noiseLevel,
      startTime: DateTime.now(),
      isActive: true,
      type: type,
    );
    
    _activeDistractions[distractionId] = distraction;
    
    debugPrint('Created $type distraction at ${position.dx}, ${position.dy}');
    return true;
  }

  bool disableCamera(String cameraId) {
    final camera = _cameras[cameraId];
    if (camera == null) return false;
    
    _cameras[cameraId] = SecurityCamera(
      id: camera.id,
      position: camera.position,
      range: camera.range,
      sweepAngle: camera.sweepAngle,
      currentAngle: camera.currentAngle,
      rotationSpeed: camera.rotationSpeed,
      isActive: false,
      hasNightVision: camera.hasNightVision,
      detectionSensitivity: camera.detectionSensitivity,
      blindSpots: camera.blindSpots,
    );
    
    debugPrint('Disabled camera $cameraId');
    return true;
  }

  void hideInCover() {
    _playerInCover = true;
    _playerNoiseLevel = 0.0;
    
    final action = StealthAction(
      id: 'hide_${DateTime.now().millisecondsSinceEpoch}',
      type: 'hide',
      executionTime: const Duration(seconds: 2),
      noiseGenerated: 0.0,
      riskLevel: 0.1,
      requiresTools: false,
      requirements: [],
    );
    
    _actionHistory.add(action);
  }

  void enterZone(String zoneId) {
    if (_zones.containsKey(zoneId)) {
      _currentZone = zoneId;
      _updatePlayerEnvironmentStatus();
      debugPrint('Entered zone: $zoneId');
    }
  }

  // Utility functions
  double _getDistance(Offset pos1, Offset pos2) {
    return math.sqrt(
      math.pow(pos1.dx - pos2.dx, 2) + math.pow(pos1.dy - pos2.dy, 2),
    );
  }

  Offset _normalizeVector(Offset vector) {
    final length = math.sqrt(vector.dx * vector.dx + vector.dy * vector.dy);
    if (length == 0) return const Offset(0, 0);
    return Offset(vector.dx / length, vector.dy / length);
  }

  // Public interface
  StealthState get playerStealthState => _playerStealthState;
  double get playerVisibility => _playerVisibility;
  double get playerNoiseLevel => _playerNoiseLevel;
  bool get playerInCover => _playerInCover;
  bool get playerInShadows => _playerInShadows;
  Offset get playerPosition => _playerPosition;
  
  List<Guard> getGuards() => _guards.values.toList();
  List<SecurityCamera> getCameras() => _cameras.values.toList();
  List<StealthZone> getZones() => _zones.values.toList();
  List<Distraction> getActiveDistractions() => _activeDistractions.values.toList();
  List<StealthAction> getActionHistory() => List.unmodifiable(_actionHistory);
  
  StealthZone? getCurrentZone() => _currentZone != null ? _zones[_currentZone!] : null;
  
  int getDetectedGuardCount() => _guards.values.where((g) => g.state == StealthState.detected).length;
  int getSuspiciousGuardCount() => _guards.values.where((g) => g.state == StealthState.suspicious).length;
  
  bool isPlayerDetected() => _playerStealthState == StealthState.detected;
  bool isPlayerSuspicious() => _playerStealthState == StealthState.suspicious;
}

// Stealth status widget
class StealthStatusWidget extends StatefulWidget {
  const StealthStatusWidget({super.key});

  @override
  State<StealthStatusWidget> createState() => _StealthStatusWidgetState();
}

class _StealthStatusWidgetState extends State<StealthStatusWidget> {
  final StealthInfiltrationSystem _stealth = StealthInfiltrationSystem();
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    _stealth.initialize();
    _stealth.enterZone('warehouse_district');
    _updateTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
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
    final stealthState = _stealth.playerStealthState;
    final visibility = _stealth.playerVisibility;
    final noiseLevel = _stealth.playerNoiseLevel;
    final inCover = _stealth.playerInCover;
    final inShadows = _stealth.playerInShadows;
    final detectedGuards = _stealth.getDetectedGuardCount();
    final suspiciousGuards = _stealth.getSuspiciousGuardCount();
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _getStealthColor(stealthState).withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                _getStealthIcon(stealthState),
                color: _getStealthColor(stealthState),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Stealth: ${_getStealthText(stealthState)}',
                style: TextStyle(
                  color: _getStealthColor(stealthState),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          Row(
            children: [
              const Text('Visibility: ', style: TextStyle(color: Colors.white70, fontSize: 12)),
              Expanded(
                child: LinearProgressIndicator(
                  value: (visibility / 2.0).clamp(0.0, 1.0),
                  backgroundColor: Colors.grey[800],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    visibility < 0.3 ? Colors.green : 
                    visibility < 0.7 ? Colors.yellow : Colors.red,
                  ),
                ),
              ),
              Text(
                ' ${(visibility * 100).toStringAsFixed(0)}%',
                style: const TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ],
          ),
          
          const SizedBox(height: 4),
          
          Row(
            children: [
              const Text('Noise: ', style: TextStyle(color: Colors.white70, fontSize: 12)),
              Expanded(
                child: LinearProgressIndicator(
                  value: noiseLevel.clamp(0.0, 1.0),
                  backgroundColor: Colors.grey[800],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    noiseLevel < 0.3 ? Colors.green : 
                    noiseLevel < 0.7 ? Colors.yellow : Colors.red,
                  ),
                ),
              ),
              Text(
                ' ${(noiseLevel * 100).toStringAsFixed(0)}%',
                style: const TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Row(
            children: [
              if (inCover) ...[
                const Icon(Icons.shield, color: Colors.blue, size: 14),
                const Text(' Cover', style: TextStyle(color: Colors.blue, fontSize: 11)),
                const SizedBox(width: 8),
              ],
              if (inShadows) ...[
                const Icon(Icons.visibility_off, color: Colors.purple, size: 14),
                const Text(' Shadows', style: TextStyle(color: Colors.purple, fontSize: 11)),
              ],
            ],
          ),
          
          if (detectedGuards > 0 || suspiciousGuards > 0) ...[
            const SizedBox(height: 8),
            if (detectedGuards > 0)
              Text(
                'Detected by: $detectedGuards guards',
                style: const TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            if (suspiciousGuards > 0)
              Text(
                'Suspicious: $suspiciousGuards guards',
                style: const TextStyle(color: Colors.orange, fontSize: 11),
              ),
          ],
          
          const SizedBox(height: 8),
          
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _stealth.hideInCover(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    padding: const EdgeInsets.symmetric(vertical: 4),
                  ),
                  child: const Text('Hide', style: TextStyle(fontSize: 10)),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _stealth.createDistraction(
                    Offset(_stealth.playerPosition.dx + 50, _stealth.playerPosition.dy),
                    'thrown_object',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[700],
                    padding: const EdgeInsets.symmetric(vertical: 4),
                  ),
                  child: const Text('Distract', style: TextStyle(fontSize: 10)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStealthColor(StealthState state) {
    switch (state) {
      case StealthState.hidden:
        return Colors.green;
      case StealthState.suspicious:
        return Colors.orange;
      case StealthState.detected:
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  IconData _getStealthIcon(StealthState state) {
    switch (state) {
      case StealthState.hidden:
        return Icons.visibility_off;
      case StealthState.suspicious:
        return Icons.warning;
      case StealthState.detected:
        return Icons.error;
      default:
        return Icons.remove_red_eye;
    }
  }

  String _getStealthText(StealthState state) {
    switch (state) {
      case StealthState.hidden:
        return 'Hidden';
      case StealthState.suspicious:
        return 'Suspicious';
      case StealthState.detected:
        return 'DETECTED';
      case StealthState.searching:
        return 'Searching';
      case StealthState.alert:
        return 'Alert';
      case StealthState.calm:
        return 'Calm';
    }
  }
}
