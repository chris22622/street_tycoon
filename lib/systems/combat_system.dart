import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';

enum WeaponType {
  fists,
  knife,
  baseball_bat,
  pistol,
  shotgun,
  assault_rifle,
  sniper_rifle,
  explosives,
}

enum CombatStyle {
  aggressive,
  defensive,
  stealth,
  berserker,
  tactical,
  hit_and_run,
}

enum BodyPart {
  head,
  torso,
  leftArm,
  rightArm,
  leftLeg,
  rightLeg,
}

enum InjuryType {
  bruise,
  cut,
  bullet,
  fracture,
  burn,
  stab,
}

class Weapon {
  final WeaponType type;
  final String name;
  final double damage;
  final double accuracy;
  final double range;
  final double fireRate;
  final int ammoCapacity;
  final double reloadTime;
  final double concealment;
  final double price;
  final List<String> attachments;
  final double durability;

  const Weapon({
    required this.type,
    required this.name,
    required this.damage,
    required this.accuracy,
    required this.range,
    required this.fireRate,
    required this.ammoCapacity,
    required this.reloadTime,
    required this.concealment,
    required this.price,
    required this.attachments,
    required this.durability,
  });
}

class Combatant {
  final String id;
  final String name;
  final Offset position;
  final double health;
  final double maxHealth;
  final double armor;
  final Map<String, double> skills; // marksmanship, melee, explosives, etc.
  final List<Weapon> weapons;
  final Weapon? currentWeapon;
  final CombatStyle combatStyle;
  final double morale;
  final bool isPlayer;
  final Map<BodyPart, List<Injury>> injuries;
  final double stamina;
  final bool isInCover;
  final double alertness;

  const Combatant({
    required this.id,
    required this.name,
    required this.position,
    required this.health,
    required this.maxHealth,
    required this.armor,
    required this.skills,
    required this.weapons,
    required this.currentWeapon,
    required this.combatStyle,
    required this.morale,
    required this.isPlayer,
    required this.injuries,
    required this.stamina,
    required this.isInCover,
    required this.alertness,
  });
}

class Injury {
  final InjuryType type;
  final BodyPart bodyPart;
  final double severity;
  final DateTime timestamp;
  final bool isBleeding;
  final double painLevel;
  final Duration healTime;

  const Injury({
    required this.type,
    required this.bodyPart,
    required this.severity,
    required this.timestamp,
    required this.isBleeding,
    required this.painLevel,
    required this.healTime,
  });
}

class CombatAction {
  final String id;
  final String performerId;
  final String? targetId;
  final String actionType; // shoot, melee, move, reload, etc.
  final Offset? targetPosition;
  final DateTime timestamp;
  final bool wasSuccessful;
  final double damage;
  final BodyPart? hitLocation;

  const CombatAction({
    required this.id,
    required this.performerId,
    this.targetId,
    required this.actionType,
    this.targetPosition,
    required this.timestamp,
    required this.wasSuccessful,
    required this.damage,
    this.hitLocation,
  });
}

class CombatZone {
  final String id;
  final String name;
  final Rect bounds;
  final List<Rect> coverPoints;
  final List<Rect> obstacles;
  final double visibility;
  final String terrain; // urban, indoor, alley, etc.
  final List<Offset> spawnPoints;
  final bool isPublic;
  final double policeResponseTime;

  const CombatZone({
    required this.id,
    required this.name,
    required this.bounds,
    required this.coverPoints,
    required this.obstacles,
    required this.visibility,
    required this.terrain,
    required this.spawnPoints,
    required this.isPublic,
    required this.policeResponseTime,
  });
}

class CombatSystem {
  static final CombatSystem _instance = CombatSystem._internal();
  factory CombatSystem() => _instance;
  CombatSystem._internal();

  final Map<String, Combatant> _combatants = {};
  final Map<String, CombatZone> _combatZones = {};
  final List<CombatAction> _combatHistory = [];
  String? _activeCombatZone;
  Timer? _combatTimer;
  bool _combatActive = false;

  static const Map<WeaponType, Weapon> _weaponTemplates = {
    WeaponType.fists: Weapon(
      type: WeaponType.fists,
      name: 'Fists',
      damage: 15.0,
      accuracy: 0.8,
      range: 1.0,
      fireRate: 2.0,
      ammoCapacity: 0,
      reloadTime: 0.0,
      concealment: 1.0,
      price: 0.0,
      attachments: [],
      durability: 1.0,
    ),
    
    WeaponType.knife: Weapon(
      type: WeaponType.knife,
      name: 'Combat Knife',
      damage: 35.0,
      accuracy: 0.9,
      range: 1.5,
      fireRate: 1.5,
      ammoCapacity: 0,
      reloadTime: 0.0,
      concealment: 0.9,
      price: 50.0,
      attachments: [],
      durability: 0.95,
    ),
    
    WeaponType.baseball_bat: Weapon(
      type: WeaponType.baseball_bat,
      name: 'Baseball Bat',
      damage: 45.0,
      accuracy: 0.7,
      range: 2.0,
      fireRate: 1.0,
      ammoCapacity: 0,
      reloadTime: 0.0,
      concealment: 0.3,
      price: 30.0,
      attachments: [],
      durability: 0.9,
    ),
    
    WeaponType.pistol: Weapon(
      type: WeaponType.pistol,
      name: 'Glock 17',
      damage: 40.0,
      accuracy: 0.75,
      range: 50.0,
      fireRate: 3.0,
      ammoCapacity: 17,
      reloadTime: 2.0,
      concealment: 0.8,
      price: 500.0,
      attachments: ['silencer', 'laser_sight'],
      durability: 0.95,
    ),
    
    WeaponType.shotgun: Weapon(
      type: WeaponType.shotgun,
      name: 'Mossberg 500',
      damage: 90.0,
      accuracy: 0.6,
      range: 30.0,
      fireRate: 0.8,
      ammoCapacity: 8,
      reloadTime: 4.0,
      concealment: 0.2,
      price: 800.0,
      attachments: ['tactical_light'],
      durability: 0.98,
    ),
    
    WeaponType.assault_rifle: Weapon(
      type: WeaponType.assault_rifle,
      name: 'AK-47',
      damage: 65.0,
      accuracy: 0.7,
      range: 100.0,
      fireRate: 10.0,
      ammoCapacity: 30,
      reloadTime: 3.0,
      concealment: 0.1,
      price: 2000.0,
      attachments: ['scope', 'foregrip', 'extended_mag'],
      durability: 0.92,
    ),
    
    WeaponType.sniper_rifle: Weapon(
      type: WeaponType.sniper_rifle,
      name: 'Barrett M82',
      damage: 200.0,
      accuracy: 0.95,
      range: 500.0,
      fireRate: 0.3,
      ammoCapacity: 10,
      reloadTime: 5.0,
      concealment: 0.05,
      price: 8000.0,
      attachments: ['high_power_scope', 'bipod'],
      durability: 0.99,
    ),
  };

  void initialize() {
    _setupCombatZones();
    _initializePlayerCombatant();
  }

  void dispose() {
    _combatTimer?.cancel();
  }

  void _setupCombatZones() {
    final zones = [
      CombatZone(
        id: 'dark_alley',
        name: 'Dark Alley',
        bounds: const Rect.fromLTWH(0, 0, 200, 100),
        coverPoints: [
          const Rect.fromLTWH(50, 20, 20, 60),
          const Rect.fromLTWH(130, 10, 15, 40),
        ],
        obstacles: [
          const Rect.fromLTWH(80, 30, 30, 20),
        ],
        visibility: 0.3,
        terrain: 'urban',
        spawnPoints: [
          const Offset(10, 50),
          const Offset(190, 50),
        ],
        isPublic: false,
        policeResponseTime: 8.0,
      ),
      
      CombatZone(
        id: 'warehouse',
        name: 'Abandoned Warehouse',
        bounds: const Rect.fromLTWH(0, 0, 300, 200),
        coverPoints: [
          const Rect.fromLTWH(50, 50, 40, 30),
          const Rect.fromLTWH(200, 80, 35, 40),
          const Rect.fromLTWH(100, 150, 50, 20),
        ],
        obstacles: [
          const Rect.fromLTWH(120, 60, 60, 80),
        ],
        visibility: 0.7,
        terrain: 'indoor',
        spawnPoints: [
          const Offset(20, 100),
          const Offset(280, 100),
          const Offset(150, 20),
          const Offset(150, 180),
        ],
        isPublic: false,
        policeResponseTime: 12.0,
      ),
      
      CombatZone(
        id: 'street_corner',
        name: 'Street Corner',
        bounds: const Rect.fromLTWH(0, 0, 250, 150),
        coverPoints: [
          const Rect.fromLTWH(30, 30, 25, 15), // Car
          const Rect.fromLTWH(180, 100, 20, 30), // Mailbox
        ],
        obstacles: [],
        visibility: 0.9,
        terrain: 'urban',
        spawnPoints: [
          const Offset(25, 75),
          const Offset(225, 75),
        ],
        isPublic: true,
        policeResponseTime: 3.0,
      ),
    ];

    for (final zone in zones) {
      _combatZones[zone.id] = zone;
    }
  }

  void _initializePlayerCombatant() {
    final player = Combatant(
      id: 'player',
      name: 'Player',
      position: const Offset(0, 0),
      health: 100.0,
      maxHealth: 100.0,
      armor: 0.0,
      skills: {
        'marksmanship': 0.5,
        'melee': 0.4,
        'explosives': 0.2,
        'stealth': 0.3,
        'athletics': 0.6,
        'first_aid': 0.3,
      },
      weapons: [_weaponTemplates[WeaponType.fists]!],
      currentWeapon: _weaponTemplates[WeaponType.fists],
      combatStyle: CombatStyle.tactical,
      morale: 0.8,
      isPlayer: true,
      injuries: {},
      stamina: 100.0,
      isInCover: false,
      alertness: 0.7,
    );

    _combatants[player.id] = player;
  }

  bool startCombat(String zoneId, List<String> enemyIds) {
    final zone = _combatZones[zoneId];
    if (zone == null || _combatActive) return false;

    _activeCombatZone = zoneId;
    _combatActive = true;

    // Position combatants
    _positionCombatants(zone, enemyIds);

    // Start combat timer
    _combatTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _updateCombat();
    });

    debugPrint('Combat started in ${zone.name}');
    return true;
  }

  void _positionCombatants(CombatZone zone, List<String> enemyIds) {
    final random = math.Random();
    final spawnPoints = List<Offset>.from(zone.spawnPoints);

    // Position player
    final player = _combatants['player'];
    if (player != null && spawnPoints.isNotEmpty) {
      final playerSpawn = spawnPoints.removeAt(random.nextInt(spawnPoints.length));
      _combatants['player'] = Combatant(
        id: player.id,
        name: player.name,
        position: playerSpawn,
        health: player.health,
        maxHealth: player.maxHealth,
        armor: player.armor,
        skills: player.skills,
        weapons: player.weapons,
        currentWeapon: player.currentWeapon,
        combatStyle: player.combatStyle,
        morale: player.morale,
        isPlayer: player.isPlayer,
        injuries: player.injuries,
        stamina: player.stamina,
        isInCover: player.isInCover,
        alertness: player.alertness,
      );
    }

    // Position enemies
    for (final enemyId in enemyIds) {
      if (spawnPoints.isNotEmpty) {
        final enemySpawn = spawnPoints.removeAt(random.nextInt(spawnPoints.length));
        final enemy = _generateEnemy(enemyId, enemySpawn);
        _combatants[enemyId] = enemy;
      }
    }
  }

  Combatant _generateEnemy(String id, Offset position) {
    final random = math.Random();
    final names = ['Thug', 'Gangster', 'Enforcer', 'Hitman', 'Boss'];
    
    final weapons = [
      _weaponTemplates[WeaponType.fists]!,
      if (random.nextDouble() > 0.3) _weaponTemplates[WeaponType.knife]!,
      if (random.nextDouble() > 0.6) _weaponTemplates[WeaponType.pistol]!,
      if (random.nextDouble() > 0.8) _weaponTemplates[WeaponType.shotgun]!,
    ];

    return Combatant(
      id: id,
      name: names[random.nextInt(names.length)],
      position: position,
      health: 80.0 + random.nextDouble() * 40.0,
      maxHealth: 100.0,
      armor: random.nextDouble() * 20.0,
      skills: {
        'marksmanship': 0.3 + random.nextDouble() * 0.4,
        'melee': 0.3 + random.nextDouble() * 0.4,
        'explosives': random.nextDouble() * 0.3,
        'stealth': 0.2 + random.nextDouble() * 0.3,
        'athletics': 0.4 + random.nextDouble() * 0.4,
        'first_aid': random.nextDouble() * 0.2,
      },
      weapons: weapons,
      currentWeapon: weapons.isNotEmpty ? weapons.last : _weaponTemplates[WeaponType.fists]!,
      combatStyle: CombatStyle.values[random.nextInt(CombatStyle.values.length)],
      morale: 0.6 + random.nextDouble() * 0.3,
      isPlayer: false,
      injuries: {},
      stamina: 80.0 + random.nextDouble() * 20.0,
      isInCover: false,
      alertness: 0.5 + random.nextDouble() * 0.4,
    );
  }

  void _updateCombat() {
    if (!_combatActive) return;

    // Process AI actions for each combatant
    for (final combatantId in _combatants.keys) {
      final combatant = _combatants[combatantId];
      if (combatant == null || combatant.isPlayer || combatant.health <= 0) continue;

      _processAIAction(combatant);
    }

    // Check win/lose conditions
    _checkCombatEnd();
  }

  void _processAIAction(Combatant combatant) {
    final random = math.Random();
    final zone = _combatZones[_activeCombatZone!]!;
    
    // Find nearest enemy
    final enemies = _combatants.values.where((c) => 
      c.id != combatant.id && c.health > 0 && 
      (c.isPlayer || !combatant.isPlayer)
    ).toList();
    
    if (enemies.isEmpty) return;
    
    enemies.sort((a, b) {
      final distA = _getDistance(combatant.position, a.position);
      final distB = _getDistance(combatant.position, b.position);
      return distA.compareTo(distB);
    });
    
    final target = enemies.first;
    final distance = _getDistance(combatant.position, target.position);
    final weapon = combatant.currentWeapon!;
    
    // Decide action based on combat style and situation
    String action = 'move';
    
    if (distance <= weapon.range && _hasLineOfSight(combatant.position, target.position, zone)) {
      if (weapon.type == WeaponType.fists || weapon.type == WeaponType.knife || weapon.type == WeaponType.baseball_bat) {
        action = 'melee';
      } else {
        action = 'shoot';
      }
    } else if (distance > weapon.range * 0.7) {
      action = 'move';
    } else if (!combatant.isInCover && random.nextDouble() < 0.3) {
      action = 'take_cover';
    }
    
    _executeCombatAction(combatant, target, action);
  }

  void _executeCombatAction(Combatant attacker, Combatant target, String actionType) {
    final weapon = attacker.currentWeapon!;
    
    bool success = false;
    double damage = 0.0;
    BodyPart? hitLocation;
    
    switch (actionType) {
      case 'shoot':
        success = _calculateShootingSuccess(attacker, target, weapon);
        if (success) {
          damage = _calculateDamage(weapon, attacker);
          hitLocation = _selectHitLocation();
        }
        break;
        
      case 'melee':
        success = _calculateMeleeSuccess(attacker, target, weapon);
        if (success) {
          damage = _calculateDamage(weapon, attacker);
          hitLocation = _selectHitLocation();
        }
        break;
        
      case 'move':
        success = true;
        _moveTowardsTarget(attacker, target);
        break;
        
      case 'take_cover':
        success = _takeCover(attacker);
        break;
    }
    
    if (success && damage > 0) {
      _applyDamage(target, damage, hitLocation!, weapon);
    }
    
    // Record action
    final action = CombatAction(
      id: 'action_${DateTime.now().millisecondsSinceEpoch}',
      performerId: attacker.id,
      targetId: target.id,
      actionType: actionType,
      targetPosition: target.position,
      timestamp: DateTime.now(),
      wasSuccessful: success,
      damage: damage,
      hitLocation: hitLocation,
    );
    
    _combatHistory.add(action);
  }

  bool _calculateShootingSuccess(Combatant attacker, Combatant target, Weapon weapon) {
    final distance = _getDistance(attacker.position, target.position);
    final skillLevel = attacker.skills['marksmanship'] ?? 0.5;
    final zone = _combatZones[_activeCombatZone!]!;
    
    double accuracy = weapon.accuracy * skillLevel;
    
    // Distance penalty
    if (distance > weapon.range * 0.5) {
      accuracy *= 0.7;
    }
    if (distance > weapon.range * 0.8) {
      accuracy *= 0.5;
    }
    
    // Cover penalty
    if (target.isInCover) {
      accuracy *= 0.4;
    }
    
    // Visibility penalty
    accuracy *= zone.visibility;
    
    // Injury penalty
    final totalInjuries = attacker.injuries.values.expand((list) => list).length;
    accuracy *= math.pow(0.9, totalInjuries).toDouble();
    
    return math.Random().nextDouble() < accuracy;
  }

  bool _calculateMeleeSuccess(Combatant attacker, Combatant target, Weapon weapon) {
    final skillLevel = attacker.skills['melee'] ?? 0.5;
    final distance = _getDistance(attacker.position, target.position);
    
    if (distance > weapon.range) return false;
    
    double accuracy = weapon.accuracy * skillLevel;
    
    // Target's defensive skill
    final targetDefense = target.skills['melee'] ?? 0.3;
    accuracy *= (1.0 - targetDefense * 0.3);
    
    return math.Random().nextDouble() < accuracy;
  }

  double _calculateDamage(Weapon weapon, Combatant attacker) {
    final skillBonus = (attacker.skills['marksmanship'] ?? 0.5) * 0.3;
    final randomFactor = 0.8 + math.Random().nextDouble() * 0.4;
    
    return weapon.damage * (1.0 + skillBonus) * randomFactor;
  }

  BodyPart _selectHitLocation() {
    final random = math.Random();
    final roll = random.nextDouble();
    
    if (roll < 0.1) return BodyPart.head;
    if (roll < 0.5) return BodyPart.torso;
    if (roll < 0.65) return BodyPart.leftArm;
    if (roll < 0.8) return BodyPart.rightArm;
    if (roll < 0.9) return BodyPart.leftLeg;
    return BodyPart.rightLeg;
  }

  void _applyDamage(Combatant target, double damage, BodyPart hitLocation, Weapon weapon) {
    // Calculate final damage after armor
    final armorReduction = target.armor * 0.01; // 1% reduction per armor point
    final finalDamage = damage * (1.0 - armorReduction);
    
    // Apply location modifier
    double locationMultiplier = 1.0;
    switch (hitLocation) {
      case BodyPart.head:
        locationMultiplier = 2.0;
        break;
      case BodyPart.torso:
        locationMultiplier = 1.2;
        break;
      default:
        locationMultiplier = 0.8;
    }
    
    final actualDamage = finalDamage * locationMultiplier;
    
    // Update health
    final newHealth = (target.health - actualDamage).clamp(0.0, target.maxHealth);
    
    // Create injury
    final injury = _createInjury(weapon, hitLocation, actualDamage);
    final injuries = Map<BodyPart, List<Injury>>.from(target.injuries);
    injuries[hitLocation] = (injuries[hitLocation] ?? [])..add(injury);
    
    // Update combatant
    _combatants[target.id] = Combatant(
      id: target.id,
      name: target.name,
      position: target.position,
      health: newHealth,
      maxHealth: target.maxHealth,
      armor: target.armor,
      skills: target.skills,
      weapons: target.weapons,
      currentWeapon: target.currentWeapon,
      combatStyle: target.combatStyle,
      morale: target.morale,
      isPlayer: target.isPlayer,
      injuries: injuries,
      stamina: target.stamina,
      isInCover: target.isInCover,
      alertness: target.alertness,
    );
    
    debugPrint('${target.name} took ${actualDamage.toStringAsFixed(1)} damage to ${hitLocation.toString()}');
  }

  Injury _createInjury(Weapon weapon, BodyPart bodyPart, double damage) {
    InjuryType type;
    switch (weapon.type) {
      case WeaponType.fists:
        type = InjuryType.bruise;
        break;
      case WeaponType.knife:
        type = InjuryType.stab;
        break;
      case WeaponType.baseball_bat:
        type = damage > 30 ? InjuryType.fracture : InjuryType.bruise;
        break;
      default:
        type = InjuryType.bullet;
    }
    
    return Injury(
      type: type,
      bodyPart: bodyPart,
      severity: (damage / 50.0).clamp(0.0, 1.0),
      timestamp: DateTime.now(),
      isBleeding: type == InjuryType.bullet || type == InjuryType.stab || type == InjuryType.cut,
      painLevel: (damage / 30.0).clamp(0.0, 1.0),
      healTime: Duration(hours: (damage / 10.0).round()),
    );
  }

  void _moveTowardsTarget(Combatant combatant, Combatant target) {
    final direction = Offset(
      target.position.dx - combatant.position.dx,
      target.position.dy - combatant.position.dy,
    );
    
    final distance = math.sqrt(direction.dx * direction.dx + direction.dy * direction.dy);
    if (distance == 0) return;
    
    final normalizedDirection = Offset(direction.dx / distance, direction.dy / distance);
    final moveDistance = 10.0; // Move 10 units
    
    final newPosition = Offset(
      combatant.position.dx + normalizedDirection.dx * moveDistance,
      combatant.position.dy + normalizedDirection.dy * moveDistance,
    );
    
    // Update position
    _combatants[combatant.id] = Combatant(
      id: combatant.id,
      name: combatant.name,
      position: newPosition,
      health: combatant.health,
      maxHealth: combatant.maxHealth,
      armor: combatant.armor,
      skills: combatant.skills,
      weapons: combatant.weapons,
      currentWeapon: combatant.currentWeapon,
      combatStyle: combatant.combatStyle,
      morale: combatant.morale,
      isPlayer: combatant.isPlayer,
      injuries: combatant.injuries,
      stamina: combatant.stamina,
      isInCover: combatant.isInCover,
      alertness: combatant.alertness,
    );
  }

  bool _takeCover(Combatant combatant) {
    final zone = _combatZones[_activeCombatZone!]!;
    
    // Find nearest cover
    double nearestDistance = double.infinity;
    Rect? nearestCover;
    
    for (final cover in zone.coverPoints) {
      final coverCenter = cover.center;
      final distance = _getDistance(combatant.position, coverCenter);
      if (distance < nearestDistance) {
        nearestDistance = distance;
        nearestCover = cover;
      }
    }
    
    if (nearestCover != null && nearestDistance < 30.0) {
      // Move to cover
      _combatants[combatant.id] = Combatant(
        id: combatant.id,
        name: combatant.name,
        position: nearestCover.center,
        health: combatant.health,
        maxHealth: combatant.maxHealth,
        armor: combatant.armor,
        skills: combatant.skills,
        weapons: combatant.weapons,
        currentWeapon: combatant.currentWeapon,
        combatStyle: combatant.combatStyle,
        morale: combatant.morale,
        isPlayer: combatant.isPlayer,
        injuries: combatant.injuries,
        stamina: combatant.stamina,
        isInCover: true,
        alertness: combatant.alertness,
      );
      return true;
    }
    
    return false;
  }

  double _getDistance(Offset pos1, Offset pos2) {
    return math.sqrt(
      math.pow(pos1.dx - pos2.dx, 2) + math.pow(pos1.dy - pos2.dy, 2),
    );
  }

  bool _hasLineOfSight(Offset from, Offset to, CombatZone zone) {
    // Simple line of sight check - could be more sophisticated
    for (final obstacle in zone.obstacles) {
      if (_lineIntersectsRect(from, to, obstacle)) {
        return false;
      }
    }
    return true;
  }

  bool _lineIntersectsRect(Offset start, Offset end, Rect rect) {
    // Simplified line-rectangle intersection
    return rect.contains(start) || rect.contains(end);
  }

  void _checkCombatEnd() {
    final aliveCombatants = _combatants.values.where((c) => c.health > 0).toList();
    final aliveEnemies = aliveCombatants.where((c) => !c.isPlayer).toList();
    final alivePlayer = aliveCombatants.where((c) => c.isPlayer).toList();
    
    if (aliveEnemies.isEmpty) {
      _endCombat(true); // Player wins
    } else if (alivePlayer.isEmpty) {
      _endCombat(false); // Player loses
    }
  }

  void _endCombat(bool playerWon) {
    _combatActive = false;
    _combatTimer?.cancel();
    _activeCombatZone = null;
    
    // Remove dead enemies
    final deadEnemies = _combatants.keys.where((id) => 
      !_combatants[id]!.isPlayer && _combatants[id]!.health <= 0
    ).toList();
    
    for (final id in deadEnemies) {
      _combatants.remove(id);
    }
    
    debugPrint('Combat ended - Player ${playerWon ? 'won' : 'lost'}');
  }

  // Player actions
  bool playerShoot(String targetId) {
    final player = _combatants['player'];
    final target = _combatants[targetId];
    
    if (player == null || target == null || !_combatActive) return false;
    
    _executeCombatAction(player, target, 'shoot');
    return true;
  }

  bool playerMelee(String targetId) {
    final player = _combatants['player'];
    final target = _combatants[targetId];
    
    if (player == null || target == null || !_combatActive) return false;
    
    _executeCombatAction(player, target, 'melee');
    return true;
  }

  bool playerTakeCover() {
    final player = _combatants['player'];
    if (player == null || !_combatActive) return false;
    
    return _takeCover(player);
  }

  void playerMoveTo(Offset position) {
    final player = _combatants['player'];
    if (player == null || !_combatActive) return;
    
    _combatants['player'] = Combatant(
      id: player.id,
      name: player.name,
      position: position,
      health: player.health,
      maxHealth: player.maxHealth,
      armor: player.armor,
      skills: player.skills,
      weapons: player.weapons,
      currentWeapon: player.currentWeapon,
      combatStyle: player.combatStyle,
      morale: player.morale,
      isPlayer: player.isPlayer,
      injuries: player.injuries,
      stamina: player.stamina,
      isInCover: false, // Moving breaks cover
      alertness: player.alertness,
    );
  }

  // Public interface
  bool get isCombatActive => _combatActive;
  List<Combatant> getCombatants() => _combatants.values.toList();
  List<CombatAction> getCombatHistory() => List.unmodifiable(_combatHistory);
  CombatZone? getActiveCombatZone() => _activeCombatZone != null ? _combatZones[_activeCombatZone!] : null;
  List<CombatZone> getAvailableCombatZones() => _combatZones.values.toList();
  
  Combatant? getPlayer() => _combatants['player'];
  List<Combatant> getEnemies() => _combatants.values.where((c) => !c.isPlayer).toList();
  
  void addWeaponToPlayer(WeaponType weaponType) {
    final player = _combatants['player'];
    final weapon = _weaponTemplates[weaponType];
    
    if (player != null && weapon != null) {
      final newWeapons = List<Weapon>.from(player.weapons)..add(weapon);
      
      _combatants['player'] = Combatant(
        id: player.id,
        name: player.name,
        position: player.position,
        health: player.health,
        maxHealth: player.maxHealth,
        armor: player.armor,
        skills: player.skills,
        weapons: newWeapons,
        currentWeapon: weapon, // Switch to new weapon
        combatStyle: player.combatStyle,
        morale: player.morale,
        isPlayer: player.isPlayer,
        injuries: player.injuries,
        stamina: player.stamina,
        isInCover: player.isInCover,
        alertness: player.alertness,
      );
    }
  }
  
  List<Weapon> getAvailableWeapons() => _weaponTemplates.values.toList();
}

// Combat status widget
class CombatStatusWidget extends StatefulWidget {
  const CombatStatusWidget({super.key});

  @override
  State<CombatStatusWidget> createState() => _CombatStatusWidgetState();
}

class _CombatStatusWidgetState extends State<CombatStatusWidget> {
  final CombatSystem _combat = CombatSystem();
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    _combat.initialize();
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
    final isActive = _combat.isCombatActive;
    final player = _combat.getPlayer();
    final enemies = _combat.getEnemies();
    
    if (!isActive || player == null) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.3),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Text(
          'No Active Combat',
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      );
    }
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.warning,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'COMBAT ACTIVE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          Text(
            'Health: ${player.health.toStringAsFixed(0)}/${player.maxHealth.toStringAsFixed(0)}',
            style: TextStyle(
              color: player.health > 50 ? Colors.green : Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          LinearProgressIndicator(
            value: player.health / player.maxHealth,
            backgroundColor: Colors.grey[800],
            valueColor: AlwaysStoppedAnimation<Color>(
              player.health > 50 ? Colors.green : Colors.red,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Weapon: ${player.currentWeapon?.name ?? 'None'}',
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
          
          Text(
            'Enemies: ${enemies.length}',
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
          
          if (player.injuries.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'Injuries: ${player.injuries.values.expand((list) => list).length}',
              style: const TextStyle(color: Colors.orange, fontSize: 11),
            ),
          ],
          
          const SizedBox(height: 8),
          
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: enemies.isNotEmpty ? () => _combat.playerShoot(enemies.first.id) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[700],
                    padding: const EdgeInsets.symmetric(vertical: 4),
                  ),
                  child: const Text('Shoot', style: TextStyle(fontSize: 10)),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _combat.playerTakeCover(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    padding: const EdgeInsets.symmetric(vertical: 4),
                  ),
                  child: const Text('Cover', style: TextStyle(fontSize: 10)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
