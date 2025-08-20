import 'dart:math';

class GangMember {
  final String id;
  final String name;
  final String nickname;
  final String role;
  final String icon;
  final int loyalty;
  final int skill;
  final int heat;
  final int experience;
  final Map<String, int> stats;
  final List<String> specialties;
  final bool isPlayerControlled;
  final int recruitmentCost;
  final int dailyUpkeep;

  const GangMember({
    required this.id,
    required this.name,
    required this.nickname,
    required this.role,
    required this.icon,
    required this.loyalty,
    required this.skill,
    required this.heat,
    required this.experience,
    required this.stats,
    required this.specialties,
    required this.isPlayerControlled,
    required this.recruitmentCost,
    required this.dailyUpkeep,
  });

  // Combat effectiveness
  int get combatPower => stats['combat'] ?? 0;
  int get stealth => stats['stealth'] ?? 0;
  int get intelligence => stats['intelligence'] ?? 0;
  int get intimidation => stats['intimidation'] ?? 0;
}

class RivalGang {
  final String id;
  final String name;
  final String leader;
  final String territory;
  final String state;
  final String icon;
  final int strength;
  final int reputation;
  final int territory_control;
  final List<String> controlledAreas;
  final Map<String, dynamic> operations;
  final List<GangMember> members;
  final Map<String, int> relationships; // Relations with other gangs
  final bool isHostile;

  const RivalGang({
    required this.id,
    required this.name,
    required this.leader,
    required this.territory,
    required this.state,
    required this.icon,
    required this.strength,
    required this.reputation,
    required this.territory_control,
    required this.controlledAreas,
    required this.operations,
    required this.members,
    required this.relationships,
    required this.isHostile,
  });
}

class Territory {
  final String id;
  final String name;
  final String city;
  final String state;
  final String controlledBy; // Gang ID or 'neutral'
  final int profitMultiplier;
  final int difficulty;
  final Map<String, int> resources;
  final List<String> specialFeatures;
  final bool isContested;

  const Territory({
    required this.id,
    required this.name,
    required this.city,
    required this.state,
    required this.controlledBy,
    required this.profitMultiplier,
    required this.difficulty,
    required this.resources,
    required this.specialFeatures,
    required this.isContested,
  });
}

class GangWarService {
  static final Random _random = Random();

  // Get available gang members for recruitment
  static List<GangMember> getAvailableRecruits() {
    return [
      // Street Soldiers
      const GangMember(
        id: 'soldier_1',
        name: 'Marcus "Ghost" Johnson',
        nickname: 'Ghost',
        role: 'Soldier',
        icon: '🔫',
        loyalty: 60,
        skill: 70,
        heat: 30,
        experience: 50,
        stats: {
          'combat': 80,
          'stealth': 70,
          'intelligence': 40,
          'intimidation': 75,
          'driving': 60,
        },
        specialties: ['Drive-by', 'Armed Robbery', 'Intimidation'],
        isPlayerControlled: false,
        recruitmentCost: 5000,
        dailyUpkeep: 200,
      ),
      
      // Enforcers
      const GangMember(
        id: 'enforcer_1',
        name: 'Big Mike "The Bull" Rodriguez',
        nickname: 'The Bull',
        role: 'Enforcer',
        icon: '💪',
        loyalty: 80,
        skill: 85,
        heat: 50,
        experience: 70,
        stats: {
          'combat': 95,
          'stealth': 30,
          'intelligence': 50,
          'intimidation': 90,
          'driving': 40,
        },
        specialties: ['Muscle', 'Collection', 'Territory Defense'],
        isPlayerControlled: false,
        recruitmentCost: 8000,
        dailyUpkeep: 350,
      ),
      
      // Assassins
      const GangMember(
        id: 'assassin_1',
        name: 'Elena "Viper" Santos',
        nickname: 'Viper',
        role: 'Assassin',
        icon: '🗡️',
        loyalty: 50,
        skill: 95,
        heat: 70,
        experience: 90,
        stats: {
          'combat': 90,
          'stealth': 95,
          'intelligence': 80,
          'intimidation': 60,
          'driving': 70,
        },
        specialties: ['Assassination', 'Infiltration', 'Poisons'],
        isPlayerControlled: false,
        recruitmentCost: 15000,
        dailyUpkeep: 500,
      ),
      
      // Lieutenants
      const GangMember(
        id: 'lieutenant_1',
        name: 'Tony "The Brain" Castellano',
        nickname: 'The Brain',
        role: 'Lieutenant',
        icon: '🧠',
        loyalty: 90,
        skill: 80,
        heat: 40,
        experience: 80,
        stats: {
          'combat': 60,
          'stealth': 70,
          'intelligence': 95,
          'intimidation': 70,
          'driving': 60,
        },
        specialties: ['Strategy', 'Money Laundering', 'Corruption'],
        isPlayerControlled: false,
        recruitmentCost: 20000,
        dailyUpkeep: 750,
      ),
      
      // Drivers
      const GangMember(
        id: 'driver_1',
        name: 'Rico "Speed" Morales',
        nickname: 'Speed',
        role: 'Wheelman',
        icon: '🏎️',
        loyalty: 70,
        skill: 90,
        heat: 35,
        experience: 60,
        stats: {
          'combat': 50,
          'stealth': 60,
          'intelligence': 60,
          'intimidation': 40,
          'driving': 95,
        },
        specialties: ['Getaway Driving', 'Racing', 'Car Theft'],
        isPlayerControlled: false,
        recruitmentCost: 7000,
        dailyUpkeep: 300,
      ),
      
      // Dealers
      const GangMember(
        id: 'dealer_1',
        name: 'Jasmine "J-Money" Williams',
        nickname: 'J-Money',
        role: 'Dealer',
        icon: '💰',
        loyalty: 65,
        skill: 75,
        heat: 60,
        experience: 55,
        stats: {
          'combat': 40,
          'stealth': 80,
          'intelligence': 85,
          'intimidation': 50,
          'driving': 55,
        },
        specialties: ['Drug Sales', 'Customer Network', 'Street Intel'],
        isPlayerControlled: false,
        recruitmentCost: 6000,
        dailyUpkeep: 250,
      ),
    ];
  }

  // Get rival gangs across different states
  static List<RivalGang> getRivalGangs() {
    return [
      // Los Angeles Gangs
      const RivalGang(
        id: 'crips_la',
        name: 'West Side Crips',
        leader: 'Big C',
        territory: 'South Central LA',
        state: 'California',
        icon: '🔵',
        strength: 85,
        reputation: 90,
        territory_control: 75,
        controlledAreas: ['Compton', 'Watts', 'Inglewood'],
        operations: {
          'drug_revenue': 50000,
          'protection_racket': 15000,
          'arms_dealing': 25000,
        },
        members: [],
        relationships: {
          'bloods_la': -90, // Enemy
          'mexican_mafia': -60,
          'black_guerillas': 20,
        },
        isHostile: true,
      ),
      
      const RivalGang(
        id: 'bloods_la',
        name: 'Piru Blood Gang',
        leader: 'Blood King',
        territory: 'East LA',
        state: 'California',
        icon: '🔴',
        strength: 80,
        reputation: 85,
        territory_control: 70,
        controlledAreas: ['East LA', 'Boyle Heights'],
        operations: {
          'drug_revenue': 45000,
          'protection_racket': 20000,
          'robbery': 10000,
        },
        members: [],
        relationships: {
          'crips_la': -90, // Enemy
          'mexican_mafia': -40,
          'latin_kings': 30,
        },
        isHostile: true,
      ),
      
      // Chicago Gangs
      const RivalGang(
        id: 'gd_chicago',
        name: 'Gangster Disciples',
        leader: 'King David',
        territory: 'South Side Chicago',
        state: 'Illinois',
        icon: '👑',
        strength: 90,
        reputation: 95,
        territory_control: 80,
        controlledAreas: ['Englewood', 'Auburn Gresham', 'Chatham'],
        operations: {
          'drug_revenue': 75000,
          'extortion': 30000,
          'human_trafficking': 40000,
        },
        members: [],
        relationships: {
          'bd_chicago': -95, // War
          'vice_lords': -70,
          'latin_kings': 10,
        },
        isHostile: true,
      ),
      
      // New York Gangs
      const RivalGang(
        id: 'latin_kings_ny',
        name: 'Almighty Latin King Nation',
        leader: 'King Tone',
        territory: 'Bronx',
        state: 'New York',
        icon: '👑',
        strength: 75,
        reputation: 80,
        territory_control: 65,
        controlledAreas: ['South Bronx', 'East Harlem'],
        operations: {
          'drug_revenue': 40000,
          'robbery': 15000,
          'fraud': 20000,
        },
        members: [],
        relationships: {
          'trinitarios': -80,
          'ms13': -60,
          'bloods_ny': 20,
        },
        isHostile: false,
      ),
      
      // Miami Gangs
      const RivalGang(
        id: 'zoe_pound',
        name: 'Zoe Pound',
        leader: 'Big Zoe',
        territory: 'Little Haiti',
        state: 'Florida',
        icon: '🇭🇹',
        strength: 70,
        reputation: 75,
        territory_control: 60,
        controlledAreas: ['Little Haiti', 'North Miami'],
        operations: {
          'drug_revenue': 35000,
          'gun_running': 25000,
          'money_laundering': 15000,
        },
        members: [],
        relationships: {
          'ms13': -70,
          'surenos': -50,
          'crips_miami': 30,
        },
        isHostile: false,
      ),
      
      // Atlanta Gangs
      const RivalGang(
        id: 'ysl_atlanta',
        name: 'Young Slime Life',
        leader: 'Young Thug',
        territory: 'Zone 6 Atlanta',
        state: 'Georgia',
        icon: '🐍',
        strength: 65,
        reputation: 70,
        territory_control: 55,
        controlledAreas: ['Zone 6', 'East Atlanta'],
        operations: {
          'drug_revenue': 30000,
          'fraud': 25000,
          'robbery': 10000,
        },
        members: [],
        relationships: {
          'gd_atlanta': -80,
          'bloods_atlanta': 40,
          'crips_atlanta': -30,
        },
        isHostile: false,
      ),
    ];
  }

  // Get territories across different states
  static List<Territory> getTerritories() {
    return [
      // California
      const Territory(
        id: 'compton',
        name: 'Compton',
        city: 'Los Angeles',
        state: 'California',
        controlledBy: 'crips_la',
        profitMultiplier: 150,
        difficulty: 85,
        resources: {'drug_demand': 90, 'weapons_access': 80, 'police_presence': 70},
        specialFeatures: ['High Drug Demand', 'Gang Territory', 'Police Presence'],
        isContested: false,
      ),
      
      const Territory(
        id: 'watts',
        name: 'Watts',
        city: 'Los Angeles',
        state: 'California',
        controlledBy: 'crips_la',
        profitMultiplier: 130,
        difficulty: 80,
        resources: {'drug_demand': 85, 'weapons_access': 75, 'police_presence': 75},
        specialFeatures: ['Historic Gang Territory', 'High Crime'],
        isContested: false,
      ),
      
      // Illinois
      const Territory(
        id: 'englewood',
        name: 'Englewood',
        city: 'Chicago',
        state: 'Illinois',
        controlledBy: 'gd_chicago',
        profitMultiplier: 140,
        difficulty: 90,
        resources: {'drug_demand': 95, 'weapons_access': 85, 'police_presence': 80},
        specialFeatures: ['Murder Capital', 'Heavy Gang Activity'],
        isContested: true,
      ),
      
      // New York
      const Territory(
        id: 'south_bronx',
        name: 'South Bronx',
        city: 'New York',
        state: 'New York',
        controlledBy: 'latin_kings_ny',
        profitMultiplier: 120,
        difficulty: 75,
        resources: {'drug_demand': 80, 'weapons_access': 70, 'police_presence': 85},
        specialFeatures: ['Dense Population', 'Heavy Police Presence'],
        isContested: false,
      ),
      
      // Neutral territories (up for grabs)
      const Territory(
        id: 'baltimore',
        name: 'West Baltimore',
        city: 'Baltimore',
        state: 'Maryland',
        controlledBy: 'neutral',
        profitMultiplier: 110,
        difficulty: 70,
        resources: {'drug_demand': 85, 'weapons_access': 60, 'police_presence': 60},
        specialFeatures: ['High Addiction Rate', 'Vacant Houses'],
        isContested: true,
      ),
      
      const Territory(
        id: 'detroit',
        name: 'Southwest Detroit',
        city: 'Detroit',
        state: 'Michigan',
        controlledBy: 'neutral',
        profitMultiplier: 105,
        difficulty: 65,
        resources: {'drug_demand': 80, 'weapons_access': 70, 'police_presence': 50},
        specialFeatures: ['Economic Decline', 'Easy Territory'],
        isContested: false,
      ),
    ];
  }

  // Calculate hit success chance
  static double calculateHitSuccessChance(
    GangMember? hitman,
    GangMember target,
    String hitType, // 'personal', 'crew_member', 'hired_hitman'
    Map<String, dynamic> conditions,
  ) {
    double baseChance = 0.3; // 30% base chance
    
    // Hitman skill modifier
    if (hitman != null) {
      final combat = hitman.combatPower / 100.0;
      final stealth = hitman.stealth / 100.0;
      baseChance += (combat * 0.3) + (stealth * 0.4);
    }
    
    // Hit type modifiers
    switch (hitType) {
      case 'personal':
        baseChance += 0.2; // Player doing it personally
        break;
      case 'crew_member':
        baseChance += 0.1; // Crew member loyalty bonus
        break;
      case 'hired_hitman':
        baseChance += 0.3; // Professional hitman
        break;
    }
    
    // Target difficulty
    final targetSkill = target.skill / 100.0;
    baseChance -= (targetSkill * 0.3);
    
    // Environmental factors
    final location = conditions['location'] ?? 'street';
    switch (location) {
      case 'home':
        baseChance += 0.2;
        break;
      case 'club':
        baseChance -= 0.1;
        break;
      case 'street':
        baseChance += 0.1;
        break;
    }
    
    return baseChance.clamp(0.1, 0.9); // 10% minimum, 90% maximum
  }

  // Execute a hit
  static Map<String, dynamic> executeHit(
    GangMember? hitman,
    GangMember target,
    String targetGangId,
    String hitType,
    Map<String, dynamic> conditions,
  ) {
    final successChance = calculateHitSuccessChance(hitman, target, hitType, conditions);
    final success = _random.nextDouble() < successChance;
    
    Map<String, dynamic> result = {
      'success': success,
      'target_killed': success,
      'heat_increase': 0,
      'gang_retaliation': 0,
      'police_investigation': false,
      'witnesses': 0,
      'message': '',
    };
    
    if (success) {
      // Successful hit
      result['heat_increase'] = _random.nextInt(30) + 20; // 20-50 heat
      result['gang_retaliation'] = _random.nextInt(50) + 30; // 30-80 retaliation points
      result['witnesses'] = _random.nextInt(3);
      result['police_investigation'] = _random.nextDouble() < 0.4; // 40% chance
      
      final methods = ['drive-by', 'close_range', 'ambush', 'poisoned', 'accident'];
      final method = methods[_random.nextInt(methods.length)];
      
      result['message'] = '💀 ${target.nickname} has been eliminated via $method. Streets are talking...';
      
      // Weaken target gang
      result['gang_weakened'] = true;
      result['territory_vulnerability'] = 20; // 20% easier to take their territory
      
    } else {
      // Failed hit
      result['heat_increase'] = _random.nextInt(20) + 10; // 10-30 heat
      result['gang_retaliation'] = _random.nextInt(80) + 50; // 50-130 retaliation
      result['target_wounded'] = _random.nextDouble() < 0.6; // 60% chance target wounded
      result['hitman_caught'] = _random.nextDouble() < 0.3; // 30% chance hitman caught
      
      result['message'] = '⚠️ Hit on ${target.nickname} failed! They\'re now aware and seeking revenge...';
      
      if (result['hitman_caught'] && hitman != null) {
        result['member_arrested'] = hitman.id;
        result['message'] += ' ${hitman.nickname} was arrested!';
      }
    }
    
    return result;
  }

  // Calculate territory takeover chance
  static double calculateTakeoverChance(
    List<GangMember> attackingCrew,
    RivalGang defendingGang,
    Territory territory,
    Map<String, dynamic> resources,
  ) {
    // Attacking force strength
    int attackPower = 0;
    for (var member in attackingCrew) {
      attackPower += member.combatPower + member.intimidation;
    }
    
    // Defending force strength
    final defendPower = defendingGang.strength * (territory.difficulty / 100);
    
    // Base calculation
    double baseChance = (attackPower / (attackPower + defendPower));
    
    // Resource modifiers
    final weapons = resources['weapons'] ?? 0;
    final vehicles = resources['vehicles'] ?? 0;
    final bribes = resources['police_bribes'] ?? 0;
    
    baseChance += (weapons * 0.001); // Each weapon adds 0.1%
    baseChance += (vehicles * 0.002); // Each vehicle adds 0.2%
    baseChance += (bribes * 0.0001); // Each $100 in bribes adds 1%
    
    // Territory factors
    if (territory.isContested) {
      baseChance += 0.2; // Easier to take contested territory
    }
    
    return baseChance.clamp(0.05, 0.95); // 5% minimum, 95% maximum
  }

  // Execute territory takeover
  static Map<String, dynamic> executeTerritoryTakeover(
    List<GangMember> attackingCrew,
    RivalGang defendingGang,
    Territory territory,
    Map<String, dynamic> resources,
  ) {
    final successChance = calculateTakeoverChance(attackingCrew, defendingGang, territory, resources);
    final success = _random.nextDouble() < successChance;
    
    Map<String, dynamic> result = {
      'success': success,
      'territory_captured': success,
      'casualties': [],
      'heat_increase': 0,
      'gang_war_triggered': false,
      'police_response': false,
      'message': '',
    };
    
    if (success) {
      // Successful takeover
      result['heat_increase'] = _random.nextInt(40) + 30; // 30-70 heat
      result['gang_war_triggered'] = _random.nextDouble() < 0.7; // 70% chance of war
      result['police_response'] = _random.nextDouble() < 0.5; // 50% chance
      
      // Calculate casualties
      final attackerCasualties = _random.nextInt(attackingCrew.length ~/ 3);
      final defenderCasualties = _random.nextInt(5) + 2;
      
      result['attacker_casualties'] = attackerCasualties;
      result['defender_casualties'] = defenderCasualties;
      result['territory_income'] = territory.profitMultiplier * 100; // Daily income
      
      result['message'] = '🏴‍☠️ ${territory.name} has been captured! ${defendingGang.name} suffered $defenderCasualties casualties. Territory now generates \$${result['territory_income']}/day.';
      
    } else {
      // Failed takeover
      result['heat_increase'] = _random.nextInt(60) + 40; // 40-100 heat
      result['gang_war_triggered'] = _random.nextDouble() < 0.9; // 90% chance of war
      result['police_response'] = _random.nextDouble() < 0.8; // 80% chance
      
      final attackerCasualties = _random.nextInt((attackingCrew.length ~/ 2)) + 1;
      result['attacker_casualties'] = attackerCasualties;
      
      result['message'] = '💀 Takeover of ${territory.name} failed! Lost $attackerCasualties crew members. ${defendingGang.name} is now on high alert.';
    }
    
    return result;
  }

  // Generate random gang events
  static Map<String, dynamic>? generateGangEvent(
    List<GangMember> playerCrew,
    List<RivalGang> rivalGangs,
    List<Territory> territories,
  ) {
    if (_random.nextDouble() > 0.3) return null; // 30% chance of event
    
    final events = [
      'rival_attack',
      'territory_challenge',
      'member_betrayal',
      'police_raid',
      'drug_deal_gone_wrong',
      'informant_discovered',
      'gang_alliance_offer',
      'territory_expansion_opportunity',
    ];
    
    final eventType = events[_random.nextInt(events.length)];
    
    switch (eventType) {
      case 'rival_attack':
        final attackingGang = rivalGangs[_random.nextInt(rivalGangs.length)];
        return {
          'type': 'rival_attack',
          'title': '⚔️ Gang Attack!',
          'message': '${attackingGang.name} is moving on your territory! ${attackingGang.leader} wants to send a message.',
          'attacker': attackingGang.id,
          'casualties_risk': _random.nextInt(3) + 1,
          'options': [
            {'text': 'Fight Back', 'action': 'defend', 'cost': 0},
            {'text': 'Pay Tribute', 'action': 'pay', 'cost': 5000},
            {'text': 'Call for Backup', 'action': 'backup', 'cost': 2000},
          ],
        };
        
      case 'territory_challenge':
        final neutralTerritories = territories.where((t) => t.controlledBy == 'neutral').toList();
        if (neutralTerritories.isNotEmpty) {
          final territory = neutralTerritories[_random.nextInt(neutralTerritories.length)];
          return {
            'type': 'territory_opportunity',
            'title': '🏴‍☠️ Territory Available',
            'message': '${territory.name} is up for grabs. Multiple crews are eyeing it. Move fast!',
            'territory': territory.id,
            'competition': _random.nextInt(3) + 1,
            'options': [
              {'text': 'Move In Now', 'action': 'claim', 'cost': 10000},
              {'text': 'Scout First', 'action': 'scout', 'cost': 1000},
              {'text': 'Ignore', 'action': 'ignore', 'cost': 0},
            ],
          };
        }
        break;
        
      case 'member_betrayal':
        if (playerCrew.isNotEmpty) {
          final traitor = playerCrew[_random.nextInt(playerCrew.length)];
          return {
            'type': 'member_betrayal',
            'title': '🐍 Betrayal!',
            'message': '${traitor.nickname} has been talking to the feds! They know about your operations.',
            'traitor': traitor.id,
            'heat_increase': _random.nextInt(30) + 20,
            'options': [
              {'text': 'Execute Traitor', 'action': 'execute', 'cost': 0},
              {'text': 'Exile Them', 'action': 'exile', 'cost': 0},
              {'text': 'Try to Turn Them', 'action': 'turn', 'cost': 5000},
            ],
          };
        }
        break;
    }
    
    return null;
  }
}
