import 'dart:math';
import 'dart:math' as math;
import 'gang_war_service.dart';
import 'assets_service.dart';
import 'federal_service.dart';

class CombatLoadout {
  final List<Weapon> weapons;
  final String armor;
  final Map<String, dynamic> equipment;
  final List<String> consumables; // medkits, stims, etc.

  const CombatLoadout({
    required this.weapons,
    required this.armor,
    required this.equipment,
    required this.consumables,
  });

  int get totalFirepower => weapons.fold(0, (sum, weapon) => sum + weapon.damage);
  int get totalAccuracy => weapons.isEmpty ? 0 : weapons.map((w) => w.reliability).reduce((a, b) => a + b) ~/ weapons.length;
}

class HeistTarget {
  final String id;
  final String name;
  final String type; // bank, armored_truck, warehouse, mansion, casino, federal_facility
  final String location;
  final int difficulty; // 1-100
  final Map<String, int> security; // guards, cameras, alarms, etc.
  final Map<String, int> rewards; // cash, drugs, weapons, intel
  final Map<String, int> requirements; // min_crew, min_firepower, special_equipment
  final List<String> approachOptions; // stealth, loud, smart, brute_force
  final bool isAvailable;
  final DateTime? cooldownEnd;

  const HeistTarget({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    required this.difficulty,
    required this.security,
    required this.rewards,
    required this.requirements,
    required this.approachOptions,
    required this.isAvailable,
    this.cooldownEnd,
  });

  bool get onCooldown => cooldownEnd != null && DateTime.now().isBefore(cooldownEnd!);
}

class HeistPlan {
  final String id;
  final HeistTarget target;
  final String approach;
  final List<GangMember> crew;
  final Map<String, CombatLoadout> loadouts; // member_id: loadout
  final Map<String, String> roleAssignments; // member_id: role
  final DateTime plannedTime;
  final Map<String, dynamic> specialPreparations;

  const HeistPlan({
    required this.id,
    required this.target,
    required this.approach,
    required this.crew,
    required this.loadouts,
    required this.roleAssignments,
    required this.plannedTime,
    required this.specialPreparations,
  });
}

class CombatEncounter {
  final String id;
  final String type; // gang_fight, police_shootout, heist_combat, territory_defense
  final String location;
  final List<GangMember> allies;
  final List<Map<String, dynamic>> enemies;
  final Map<String, dynamic> environment; // cover, hazards, escape_routes
  final bool isActive;
  final int turnCount;

  const CombatEncounter({
    required this.id,
    required this.type,
    required this.location,
    required this.allies,
    required this.enemies,
    required this.environment,
    required this.isActive,
    required this.turnCount,
  });
}

class CombatHeistService {
  static final Random _random = Random();

  // Get available heist targets
  static List<HeistTarget> getAvailableHeistTargets() {
    return [
      // Low-tier targets
      const HeistTarget(
        id: 'corner_store',
        name: 'Corner Store Robbery',
        type: 'store',
        location: 'East Side',
        difficulty: 15,
        security: {'guards': 0, 'cameras': 1, 'alarms': 1, 'police_response': 20},
        rewards: {'cash': 5000, 'reputation': 10},
        requirements: {'min_crew': 1, 'min_firepower': 20},
        approachOptions: ['stealth', 'loud'],
        isAvailable: true,
      ),

      const HeistTarget(
        id: 'drug_stash_house',
        name: 'Rival Drug Stash',
        type: 'stash_house',
        location: 'Industrial District',
        difficulty: 35,
        security: {'guards': 3, 'cameras': 2, 'alarms': 1, 'dogs': 1},
        rewards: {'cash': 25000, 'drugs': 50, 'weapons': 2},
        requirements: {'min_crew': 3, 'min_firepower': 60, 'stealth_gear': 1},
        approachOptions: ['stealth', 'loud', 'smart'],
        isAvailable: true,
      ),

      // Mid-tier targets
      const HeistTarget(
        id: 'armored_truck',
        name: 'Armored Truck Heist',
        type: 'armored_truck',
        location: 'Financial District',
        difficulty: 55,
        security: {'guards': 4, 'armor': 80, 'weapons': 60, 'police_response': 45},
        rewards: {'cash': 150000, 'reputation': 50},
        requirements: {'min_crew': 4, 'min_firepower': 120, 'explosives': 1, 'getaway_vehicle': 1},
        approachOptions: ['loud', 'smart'],
        isAvailable: true,
      ),

      const HeistTarget(
        id: 'casino_vault',
        name: 'Casino Underground Vault',
        type: 'casino',
        location: 'Vegas Strip',
        difficulty: 70,
        security: {'guards': 8, 'cameras': 20, 'electronic_locks': 5, 'vault_security': 90},
        rewards: {'cash': 500000, 'reputation': 100, 'intel': 1},
        requirements: {'min_crew': 6, 'hacker': 1, 'inside_man': 1, 'specialized_equipment': 3},
        approachOptions: ['stealth', 'smart'],
        isAvailable: true,
      ),

      // High-tier targets
      const HeistTarget(
        id: 'federal_evidence',
        name: 'Federal Evidence Warehouse',
        type: 'federal_facility',
        location: 'Government District',
        difficulty: 90,
        security: {'federal_agents': 12, 'electronic_security': 95, 'backup_response': 90},
        rewards: {'intel': 5, 'reputation': 200, 'federal_heat_reduction': 50},
        requirements: {'min_crew': 8, 'federal_clearance': 1, 'emp_device': 1, 'extraction_plan': 1},
        approachOptions: ['stealth', 'smart'],
        isAvailable: true,
      ),

      const HeistTarget(
        id: 'cartel_compound',
        name: 'Cartel Money Compound',
        type: 'compound',
        location: 'Border Territory',
        difficulty: 85,
        security: {'sicarios': 15, 'heavy_weapons': 80, 'fortifications': 70, 'attack_dogs': 5},
        rewards: {'cash': 2000000, 'drugs': 500, 'weapons': 20, 'cartel_connections': 1},
        requirements: {'min_crew': 10, 'heavy_weapons': 3, 'armored_vehicle': 1, 'cartel_intel': 1},
        approachOptions: ['loud', 'smart'],
        isAvailable: true,
      ),
    ];
  }

  // Plan a heist
  static HeistPlan createHeistPlan(
    HeistTarget target,
    String approach,
    List<GangMember> availableCrew,
    Map<String, List<Weapon>> availableWeapons,
  ) {
    // Select optimal crew based on requirements and approach
    final selectedCrew = _selectOptimalCrew(target, approach, availableCrew);
    final roleAssignments = _assignRoles(target, approach, selectedCrew);
    final loadouts = _createLoadouts(selectedCrew, availableWeapons, approach);
    
    return HeistPlan(
      id: 'heist_${DateTime.now().millisecondsSinceEpoch}',
      target: target,
      approach: approach,
      crew: selectedCrew,
      loadouts: loadouts,
      roleAssignments: roleAssignments,
      plannedTime: DateTime.now().add(Duration(hours: _random.nextInt(12) + 6)), // 6-18 hours prep
      specialPreparations: _getSpecialPreparations(target, approach),
    );
  }

  // Execute heist
  static Map<String, dynamic> executeHeist(HeistPlan plan) {
    Map<String, dynamic> result = {
      'success': false,
      'rewards': <String, int>{},
      'casualties': <String>[],
      'crew_experience': <String, int>{},
      'heat_increase': 0,
      'reputation_gain': 0,
      'complications': <String>[],
      'narrative': <String>[],
    };

    result['narrative'].add('🎯 ${plan.target.name} - ${plan.approach.toUpperCase()} approach');
    
    // Phase 1: Infiltration/Initial Contact
    final infiltrationSuccess = _executeInfiltration(plan, result);
    if (!infiltrationSuccess && plan.approach == 'stealth') {
      result['narrative'].add('🚨 Stealth approach failed! Going loud...');
      plan = plan.copyWith(approach: 'loud'); // Fall back to loud approach
    }

    // Phase 2: Primary Objective
    final objectiveSuccess = _executePrimaryObjective(plan, result);
    
    // Phase 3: Escape
    final escapeSuccess = _executeEscape(plan, result);
    
    // Determine overall success
    result['success'] = objectiveSuccess && escapeSuccess;
    
    // Calculate final rewards and consequences
    if (result['success']) {
      result['rewards'] = _calculateRewards(plan.target, plan.approach, plan.crew.length);
      result['reputation_gain'] = plan.target.rewards['reputation'] ?? 0;
      result['narrative'].add('✅ Heist successful! Crew escapes with the goods.');
    } else {
      result['rewards'] = _calculatePartialRewards(plan.target, result['narrative']);
      result['reputation_gain'] = (plan.target.rewards['reputation'] ?? 0) ~/ 3; // Reduced reputation
      result['narrative'].add('❌ Heist failed. Some crew members may be arrested or injured.');
    }
    
    // Heat and law enforcement response
    result['heat_increase'] = _calculateHeatIncrease(plan.target, plan.approach, result['success']);
    
    // Crew experience and casualties
    result['crew_experience'] = _calculateCrewExperience(plan.crew, result['success']);
    result['casualties'] = _determineCasualties(plan.crew, plan.target.difficulty, result['success']);
    
    return result;
  }

  // Initiate combat encounter
  static CombatEncounter initiateCombat(
    String type,
    String location,
    List<GangMember> allies,
    int enemyStrength,
  ) {
    final enemies = _generateEnemies(type, enemyStrength);
    final environment = _generateCombatEnvironment(location);
    
    return CombatEncounter(
      id: 'combat_${DateTime.now().millisecondsSinceEpoch}',
      type: type,
      location: location,
      allies: allies,
      enemies: enemies,
      environment: environment,
      isActive: true,
      turnCount: 0,
    );
  }

  // Process combat turn
  static Map<String, dynamic> processCombatTurn(
    CombatEncounter encounter,
    Map<String, String> actions, // member_id: action
  ) {
    Map<String, dynamic> turnResult = {
      'ally_actions': <Map<String, dynamic>>[],
      'enemy_actions': <Map<String, dynamic>>[],
      'casualties': <String>[],
      'combat_ended': false,
      'victor': '',
      'narrative': <String>[],
    };

    // Process ally actions
    for (var ally in encounter.allies) {
      final action = actions[ally.id] ?? 'attack';
      final actionResult = _processAction(ally, action, encounter);
      turnResult['ally_actions'].add(actionResult);
      turnResult['narrative'].addAll(actionResult['narrative'] as List<String>);
    }

    // Process enemy actions
    for (var enemy in encounter.enemies) {
      final enemyAction = _getEnemyAction(enemy, encounter);
      final actionResult = _processEnemyAction(enemy, enemyAction, encounter);
      turnResult['enemy_actions'].add(actionResult);
      turnResult['narrative'].addAll(actionResult['narrative'] as List<String>);
    }

    // Check combat end conditions
    final alliesAlive = encounter.allies.where((a) => a.stats['health'] != null && (a.stats['health'] as int) > 0).isNotEmpty;
    final enemiesAlive = encounter.enemies.where((e) => (e['health'] as int) > 0).isNotEmpty;
    
    if (!alliesAlive || !enemiesAlive) {
      turnResult['combat_ended'] = true;
      turnResult['victor'] = alliesAlive ? 'allies' : 'enemies';
    }

    return turnResult;
  }

  // Helper methods
  static List<GangMember> _selectOptimalCrew(
    HeistTarget target,
    String approach,
    List<GangMember> availableCrew,
  ) {
    final minCrewSize = target.requirements['min_crew'] ?? 1;
    final maxCrewSize = 8; // Practical limit
    
    // Sort crew by relevant skills for the approach
    availableCrew.sort((a, b) {
      int scoreA = _getCrewScore(a, approach);
      int scoreB = _getCrewScore(b, approach);
      return scoreB.compareTo(scoreA);
    });
    
    final optimalSize = math.min(
      math.max(minCrewSize, (target.difficulty / 15).ceil()),
      math.min(maxCrewSize, availableCrew.length),
    );
    
    return availableCrew.take(optimalSize).toList();
  }
  
  static int _getCrewScore(GangMember member, String approach) {
    switch (approach) {
      case 'stealth':
        return member.stealth + member.loyalty;
      case 'loud':
        return member.combatPower + (member.stats['aggression'] ?? 50);
      case 'smart':
        return member.intelligence + member.loyalty;
      default:
        return member.combatPower + member.stealth + member.intelligence;
    }
  }
  
  static Map<String, String> _assignRoles(
    HeistTarget target,
    String approach,
    List<GangMember> crew,
  ) {
    Map<String, String> roles = {};
    List<String> availableRoles = [
      'leader',
      'demolitions',
      'hacker',
      'driver',
      'lookout',
      'muscle',
      'negotiator',
    ];
    
    // Assign leader (highest loyalty + intelligence)
    final leader = crew.reduce((a, b) => 
      (a.loyalty + a.intelligence) > (b.loyalty + b.intelligence) ? a : b
    );
    roles[leader.id] = 'leader';
    availableRoles.remove('leader');
    
    // Assign other roles based on skills
    for (var member in crew.where((m) => m.id != leader.id)) {
      String bestRole = 'muscle'; // Default role
      int bestScore = 0;
      
      for (var role in availableRoles) {
        int score = _getRoleScore(member, role);
        if (score > bestScore) {
          bestScore = score;
          bestRole = role;
        }
      }
      
      roles[member.id] = bestRole;
      availableRoles.remove(bestRole);
      
      if (availableRoles.isEmpty) break;
    }
    
    return roles;
  }
  
  static int _getRoleScore(GangMember member, String role) {
    switch (role) {
      case 'demolitions':
        return member.combatPower + (member.stats['aggression'] ?? 50);
      case 'hacker':
        return member.intelligence + member.stealth;
      case 'driver':
        return member.stealth + member.loyalty;
      case 'lookout':
        return member.stealth + member.intelligence;
      case 'negotiator':
        return member.intelligence + member.loyalty;
      default:
        return member.combatPower + (member.stats['aggression'] ?? 50);
    }
  }
  
  static Map<String, CombatLoadout> _createLoadouts(
    List<GangMember> crew,
    Map<String, List<Weapon>> availableWeapons,
    String approach,
  ) {
    Map<String, CombatLoadout> loadouts = {};
    
    for (var member in crew) {
      List<Weapon> selectedWeapons = [];
      
      // Select weapons based on approach and member skills
      if (approach == 'stealth') {
        // Prefer silenced weapons
        selectedWeapons.addAll(_selectStealthWeapons(availableWeapons, member));
      } else if (approach == 'loud') {
        // Prefer high-damage weapons
        selectedWeapons.addAll(_selectLoudWeapons(availableWeapons, member));
      } else {
        // Balanced loadout
        selectedWeapons.addAll(_selectBalancedWeapons(availableWeapons, member));
      }
      
      loadouts[member.id] = CombatLoadout(
        weapons: selectedWeapons,
        armor: _selectArmor(approach),
        equipment: _selectEquipment(approach, member),
        consumables: ['medkit', 'ammo'],
      );
    }
    
    return loadouts;
  }
  
  static List<Weapon> _selectStealthWeapons(Map<String, List<Weapon>> available, GangMember member) {
    // Implementation for stealth weapon selection
    return available['silenced']?.take(2).toList() ?? [];
  }
  
  static List<Weapon> _selectLoudWeapons(Map<String, List<Weapon>> available, GangMember member) {
    // Implementation for loud weapon selection
    return available['assault']?.take(2).toList() ?? [];
  }
  
  static List<Weapon> _selectBalancedWeapons(Map<String, List<Weapon>> available, GangMember member) {
    // Implementation for balanced weapon selection
    return available['handguns']?.take(1).toList() ?? [];
  }
  
  static String _selectArmor(String approach) {
    switch (approach) {
      case 'stealth':
        return 'light_vest';
      case 'loud':
        return 'heavy_armor';
      default:
        return 'tactical_vest';
    }
  }
  
  static Map<String, dynamic> _selectEquipment(String approach, GangMember member) {
    Map<String, dynamic> equipment = {};
    
    if (approach == 'stealth') {
      equipment['lockpicks'] = true;
      equipment['silencer'] = true;
      equipment['night_vision'] = true;
    } else if (approach == 'loud') {
      equipment['explosives'] = true;
      equipment['flash_bangs'] = true;
      equipment['breaching_charges'] = true;
    }
    
    return equipment;
  }
  
  static Map<String, dynamic> _getSpecialPreparations(HeistTarget target, String approach) {
    return {
      'intel_gathered': true,
      'escape_routes_scouted': true,
      'equipment_prepared': true,
      'timing_optimized': true,
    };
  }

  // Heist execution phases
  static bool _executeInfiltration(HeistPlan plan, Map<String, dynamic> result) {
    final infiltrationChance = _calculateInfiltrationChance(plan);
    final success = _random.nextDouble() < infiltrationChance;
    
    if (success) {
      result['narrative'].add('🚪 Successfully infiltrated ${plan.target.name}');
    } else {
      result['narrative'].add('🚨 Infiltration failed! Security alerted!');
      result['complications'].add('security_alert');
    }
    
    return success;
  }
  
  static bool _executePrimaryObjective(HeistPlan plan, Map<String, dynamic> result) {
    final objectiveChance = _calculateObjectiveChance(plan);
    final success = _random.nextDouble() < objectiveChance;
    
    if (success) {
      result['narrative'].add('💰 Primary objective completed successfully');
    } else {
      result['narrative'].add('❌ Failed to complete primary objective');
      result['complications'].add('objective_failed');
    }
    
    return success;
  }
  
  static bool _executeEscape(HeistPlan plan, Map<String, dynamic> result) {
    final escapeChance = _calculateEscapeChance(plan);
    final success = _random.nextDouble() < escapeChance;
    
    if (success) {
      result['narrative'].add('🏃 Successfully escaped the scene');
    } else {
      result['narrative'].add('🚔 Police response too quick! Difficult escape!');
      result['complications'].add('difficult_escape');
    }
    
    return success;
  }

  // Calculation methods
  static double _calculateInfiltrationChance(HeistPlan plan) {
    double baseChance = 0.7;
    
    // Approach affects infiltration
    switch (plan.approach) {
      case 'stealth':
        baseChance = 0.9;
        break;
      case 'loud':
        baseChance = 0.3; // Loud approach doesn't care about stealth
        break;
      case 'smart':
        baseChance = 0.8;
        break;
    }
    
    // Crew stealth affects success
    final avgStealth = plan.crew.map((m) => m.stealth).reduce((a, b) => a + b) / plan.crew.length;
    baseChance += (avgStealth / 100.0) * 0.2;
    
    // Target difficulty affects success
    baseChance -= (plan.target.difficulty / 100.0) * 0.3;
    
    return baseChance.clamp(0.1, 0.95);
  }
  
  static double _calculateObjectiveChance(HeistPlan plan) {
    double baseChance = 0.6;
    
    // Crew skills affect objective success
    final avgSkill = plan.crew.map((m) => (m.combatPower + m.intelligence + m.stealth) / 3).reduce((a, b) => a + b) / plan.crew.length;
    baseChance += (avgSkill / 100.0) * 0.3;
    
    // Target difficulty affects success
    baseChance -= (plan.target.difficulty / 100.0) * 0.4;
    
    return baseChance.clamp(0.1, 0.9);
  }
  
  static double _calculateEscapeChance(HeistPlan plan) {
    double baseChance = 0.75;
    
    // Police response affects escape difficulty
    final policeResponse = plan.target.security['police_response'] ?? 30;
    baseChance -= (policeResponse / 100.0) * 0.3;
    
    // Driver skill affects escape
    final driver = plan.crew.firstWhere(
      (m) => plan.roleAssignments[m.id] == 'driver',
      orElse: () => plan.crew.first,
    );
    baseChance += (driver.stealth / 100.0) * 0.2;
    
    return baseChance.clamp(0.2, 0.95);
  }

  static Map<String, int> _calculateRewards(HeistTarget target, String approach, int crewSize) {
    Map<String, int> rewards = Map.from(target.rewards);
    
    // Approach affects rewards
    if (approach == 'stealth') {
      // Stealth approach gets bonus for not alerting authorities
      rewards = rewards.map((key, value) => MapEntry(key, (value * 1.2).toInt()));
    } else if (approach == 'loud') {
      // Loud approach might damage some rewards
      rewards = rewards.map((key, value) => MapEntry(key, (value * 0.9).toInt()));
    }
    
    // Split rewards among crew (player gets leader's share)
    final leaderShare = 0.4; // Player gets 40%
    // final crewShare = 0.6 / (crewSize - 1); // Rest split among crew - for future crew payout implementation
    
    rewards = rewards.map((key, value) => MapEntry(key, (value * leaderShare).toInt()));
    
    return rewards;
  }
  
  static Map<String, int> _calculatePartialRewards(HeistTarget target, List<String> narrative) {
    Map<String, int> rewards = Map.from(target.rewards);
    
    // Reduce rewards based on failure severity
    final reductionFactor = 0.3; // Get 30% of full rewards on failure
    rewards = rewards.map((key, value) => MapEntry(key, (value * reductionFactor).toInt()));
    
    return rewards;
  }
  
  static int _calculateHeatIncrease(HeistTarget target, String approach, bool success) {
    int baseHeat = target.difficulty;
    
    if (!success) {
      baseHeat = (baseHeat * 1.5).toInt(); // Failed heists generate more heat
    }
    
    if (approach == 'loud') {
      baseHeat = (baseHeat * 1.3).toInt(); // Loud approaches generate more heat
    }
    
    return baseHeat;
  }
  
  static Map<String, int> _calculateCrewExperience(List<GangMember> crew, bool success) {
    Map<String, int> experience = {};
    
    final baseExp = success ? 50 : 25;
    
    for (var member in crew) {
      experience[member.id] = baseExp + _random.nextInt(25);
    }
    
    return experience;
  }
  
  static List<String> _determineCasualties(List<GangMember> crew, int difficulty, bool success) {
    List<String> casualties = [];
    
    final casualtyChance = success ? (difficulty / 500.0) : (difficulty / 200.0);
    
    for (var member in crew) {
      if (_random.nextDouble() < casualtyChance) {
        casualties.add(member.id);
      }
    }
    
    return casualties;
  }

  // Combat system methods
  static List<Map<String, dynamic>> _generateEnemies(String type, int strength) {
    List<Map<String, dynamic>> enemies = [];
    
    switch (type) {
      case 'gang_fight':
        final numEnemies = (strength / 20).clamp(2, 8).toInt();
        for (int i = 0; i < numEnemies; i++) {
          enemies.add({
            'id': 'enemy_$i',
            'name': 'Gang Member ${i + 1}',
            'health': 80 + _random.nextInt(40),
            'armor': 20 + _random.nextInt(30),
            'weapons': ['pistol', 'knife'],
            'accuracy': 60 + _random.nextInt(20),
            'aggression': 70 + _random.nextInt(30),
          });
        }
        break;
        
      case 'police_shootout':
        final numOfficers = (strength / 25).clamp(2, 6).toInt();
        for (int i = 0; i < numOfficers; i++) {
          enemies.add({
            'id': 'officer_$i',
            'name': 'Police Officer ${i + 1}',
            'health': 100 + _random.nextInt(20),
            'armor': 50 + _random.nextInt(30),
            'weapons': ['service_pistol', 'taser'],
            'accuracy': 75 + _random.nextInt(15),
            'training': 80 + _random.nextInt(20),
          });
        }
        break;
    }
    
    return enemies;
  }
  
  static Map<String, dynamic> _generateCombatEnvironment(String location) {
    return {
      'cover_available': _random.nextDouble() > 0.3,
      'escape_routes': _random.nextInt(3) + 1,
      'civilians_present': _random.nextDouble() > 0.6,
      'lighting': ['dim', 'normal', 'bright'][_random.nextInt(3)],
      'weather': ['clear', 'rain', 'fog'][_random.nextInt(3)],
      'terrain': 'urban',
    };
  }
  
  static Map<String, dynamic> _processAction(
    GangMember member,
    String action,
    CombatEncounter encounter,
  ) {
    // Implementation for processing member combat actions
    return {
      'member_id': member.id,
      'action': action,
      'success': _random.nextDouble() > 0.5,
      'damage_dealt': _random.nextInt(30) + 10,
      'narrative': ['${member.name} ${action}s!'],
    };
  }
  
  static String _getEnemyAction(Map<String, dynamic> enemy, CombatEncounter encounter) {
    final actions = ['attack', 'take_cover', 'reload', 'call_backup'];
    return actions[_random.nextInt(actions.length)];
  }
  
  static Map<String, dynamic> _processEnemyAction(
    Map<String, dynamic> enemy,
    String action,
    CombatEncounter encounter,
  ) {
    return {
      'enemy_id': enemy['id'],
      'action': action,
      'success': _random.nextDouble() > 0.4,
      'damage_dealt': _random.nextInt(25) + 5,
      'narrative': ['${enemy['name']} ${action}s!'],
    };
  }
}

// Extension for HeistPlan copyWith method
extension HeistPlanExtension on HeistPlan {
  HeistPlan copyWith({
    String? id,
    HeistTarget? target,
    String? approach,
    List<GangMember>? crew,
    Map<String, CombatLoadout>? loadouts,
    Map<String, String>? roleAssignments,
    DateTime? plannedTime,
    Map<String, dynamic>? specialPreparations,
  }) {
    return HeistPlan(
      id: id ?? this.id,
      target: target ?? this.target,
      approach: approach ?? this.approach,
      crew: crew ?? this.crew,
      loadouts: loadouts ?? this.loadouts,
      roleAssignments: roleAssignments ?? this.roleAssignments,
      plannedTime: plannedTime ?? this.plannedTime,
      specialPreparations: specialPreparations ?? this.specialPreparations,
    );
  }
}
