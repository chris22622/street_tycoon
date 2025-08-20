import 'dart:math';
import 'gang_war_service.dart';
import 'assets_service.dart';
import 'bribery_service.dart';

class EmpireStatus {
  final int totalNetWorth;
  final int monthlyIncome;
  final int territoryCount;
  final int gangSize;
  final int vehicleCount;
  final int propertyCount;
  final int corruptOfficials;
  final List<String> operationalStates;
  final int reputation;
  final int federalHeat;
  final String empireRank;

  const EmpireStatus({
    required this.totalNetWorth,
    required this.monthlyIncome,
    required this.territoryCount,
    required this.gangSize,
    required this.vehicleCount,
    required this.propertyCount,
    required this.corruptOfficials,
    required this.operationalStates,
    required this.reputation,
    required this.federalHeat,
    required this.empireRank,
  });
}

class EmpireEvent {
  final String id;
  final String type;
  final String title;
  final String description;
  final DateTime timestamp;
  final Map<String, dynamic> effects;
  final List<Map<String, dynamic>> options;
  final bool requiresResponse;
  final int priority; // 1-10, 10 being most urgent

  const EmpireEvent({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.effects,
    required this.options,
    required this.requiresResponse,
    required this.priority,
  });
}

class MasterCriminalService {
  static final Random _random = Random();

  // Calculate comprehensive empire status
  static EmpireStatus calculateEmpireStatus(Map<String, dynamic> gameState) {
    // Extract data from game state
    final cash = gameState['money'] ?? 0;
    final gangMembers = (gameState['gang_members'] as List<GangMember>?) ?? [];
    final territories = (gameState['territories'] as List<Territory>?) ?? [];
    final vehicles = (gameState['vehicles'] as List<Vehicle>?) ?? [];
    final properties = (gameState['properties'] as List<Property>?) ?? [];
    final corruptOfficials = (gameState['corrupt_officials'] as List<CorruptOfficial>?) ?? [];
    final operationalStates = (gameState['operational_states'] as List<String>?) ?? ['home'];
    final reputation = gameState['reputation'] ?? 0;
    final federalHeat = gameState['federal_heat'] ?? 0;

    // Calculate total net worth
    int totalNetWorth = cash as int;
    totalNetWorth += vehicles.fold(0, (sum, v) => sum + v.price);
    totalNetWorth += properties.fold(0, (sum, p) => sum + p.price);
    
    // Calculate monthly income
    int monthlyIncome = 0;
    monthlyIncome += properties.fold(0, (sum, p) => sum + p.monthlyIncome);
    // Calculate territory income based on profit multiplier (simplified)
    monthlyIncome += territories.fold(0, (sum, t) => sum + (t.profitMultiplier * 1000));
    
    // Determine empire rank
    String empireRank = _determineEmpireRank(totalNetWorth, reputation, operationalStates.length);

    return EmpireStatus(
      totalNetWorth: totalNetWorth,
      monthlyIncome: monthlyIncome,
      territoryCount: territories.length,
      gangSize: gangMembers.length,
      vehicleCount: vehicles.length,
      propertyCount: properties.length,
      corruptOfficials: corruptOfficials.length,
      operationalStates: operationalStates,
      reputation: reputation as int,
      federalHeat: federalHeat as int,
      empireRank: empireRank,
    );
  }

  // Generate empire-wide events
  static EmpireEvent? generateEmpireEvent(EmpireStatus status, Map<String, dynamic> gameState) {
    if (_random.nextDouble() > 0.25) return null; // 25% chance

    final eventTypes = [
      'federal_raid_coordinated',
      'gang_alliance_opportunity',
      'interstate_expansion_chance',
      'corruption_scandal',
      'territory_war_escalation',
      'asset_seizure_threat',
      'informant_network_compromise',
      'heist_opportunity_intel',
      'cartel_contact_offer',
      'witness_protection_breach',
    ];

    final eventType = eventTypes[_random.nextInt(eventTypes.length)];
    return _createEmpireEvent(eventType, status, gameState);
  }

  // Create specific empire events
  static EmpireEvent _createEmpireEvent(String type, EmpireStatus status, Map<String, dynamic> gameState) {
    switch (type) {
      case 'federal_raid_coordinated':
        return EmpireEvent(
          id: 'empire_${DateTime.now().millisecondsSinceEpoch}',
          type: 'federal_raid_coordinated',
          title: '🚨 FEDERAL TASK FORCE RAID',
          description: 'Multiple federal agencies are coordinating simultaneous raids on your operations across ${status.operationalStates.length} states. You have 6 hours to respond.',
          timestamp: DateTime.now(),
          effects: {
            'threatened_assets': status.propertyCount,
            'at_risk_members': status.gangSize ~/ 2,
            'potential_losses': status.totalNetWorth ~/ 4,
          },
          options: [
            {
              'text': 'Emergency Evacuation Protocol',
              'action': 'emergency_evacuation',
              'cost': 500000,
              'description': 'Evacuate all operations and go underground',
              'success_chance': 80,
            },
            {
              'text': 'Federal Bribery Operation',
              'action': 'federal_bribery',
              'cost': 2000000,
              'description': 'Attempt to buy off federal task force leaders',
              'success_chance': 40,
            },
            {
              'text': 'Fight Back - All Out War',
              'action': 'federal_war',
              'cost': 100000,
              'description': 'Engage in armed resistance against federal forces',
              'success_chance': 15,
            },
            {
              'text': 'Sacrifice Minor Operations',
              'action': 'sacrifice_operations',
              'cost': 0,
              'description': 'Let them take small operations to protect the empire',
              'success_chance': 90,
            },
          ],
          requiresResponse: true,
          priority: 10,
        );

      case 'gang_alliance_opportunity':
        final alliances = ['Shadow Phoenix Syndicate', 'Northern Wolf Pack', 'Golden Dragon Family', 'Silver Serpent Clan'];
        final alliance = alliances[_random.nextInt(alliances.length)];
        return EmpireEvent(
          id: 'empire_${DateTime.now().millisecondsSinceEpoch}',
          type: 'gang_alliance_opportunity',
          title: '🤝 Criminal Alliance Proposal',
          description: 'The $alliance has approached you with a proposal for a strategic alliance. They control international smuggling routes and offer protection.',
          timestamp: DateTime.now(),
          effects: {
            'alliance_name': alliance,
            'territory_bonus': 3,
            'protection_level': 50,
            'supply_access': true,
          },
          options: [
            {
              'text': 'Accept Alliance',
              'action': 'accept_alliance',
              'cost': 1000000,
              'description': 'Pay tribute and gain access to international operations',
              'success_chance': 95,
            },
            {
              'text': 'Negotiate Terms',
              'action': 'negotiate_alliance',
              'cost': 250000,
              'description': 'Try to get better terms before committing',
              'success_chance': 70,
            },
            {
              'text': 'Decline Respectfully',
              'action': 'decline_alliance',
              'cost': 0,
              'description': 'Politely decline and maintain independence',
              'success_chance': 85,
            },
            {
              'text': 'Challenge Their Authority',
              'action': 'challenge_alliance',
              'cost': 50000,
              'description': 'Show them you\'re not intimidated - risky but respected',
              'success_chance': 30,
            },
          ],
          requiresResponse: true,
          priority: 7,
        );

      case 'interstate_expansion_chance':
        final newStates = ['Washington', 'Oregon', 'Louisiana', 'Virginia', 'Colorado'];
        final targetState = newStates[_random.nextInt(newStates.length)];
        return EmpireEvent(
          id: 'empire_${DateTime.now().millisecondsSinceEpoch}',
          type: 'interstate_expansion_chance',
          title: '🗺️ Expansion Opportunity',
          description: 'Your contacts have identified a power vacuum in $targetState. Local gangs are weak and ripe for takeover.',
          timestamp: DateTime.now(),
          effects: {
            'target_state': targetState,
            'expansion_difficulty': _random.nextInt(30) + 40,
            'potential_territories': _random.nextInt(3) + 2,
            'monthly_income_potential': _random.nextInt(100000) + 50000,
          },
          options: [
            {
              'text': 'Full Scale Invasion',
              'action': 'full_invasion',
              'cost': 2000000,
              'description': 'Send in heavy crew to take over immediately',
              'success_chance': 80,
            },
            {
              'text': 'Stealth Infiltration',
              'action': 'stealth_infiltration',
              'cost': 500000,
              'description': 'Slowly build influence before revealing presence',
              'success_chance': 90,
            },
            {
              'text': 'Local Partnership',
              'action': 'local_partnership',
              'cost': 1000000,
              'description': 'Partner with existing gangs instead of conquering',
              'success_chance': 75,
            },
            {
              'text': 'Wait and Watch',
              'action': 'wait_and_watch',
              'cost': 0,
              'description': 'Monitor the situation for better timing',
              'success_chance': 100,
            },
          ],
          requiresResponse: false,
          priority: 6,
        );

      case 'corruption_scandal':
        return EmpireEvent(
          id: 'empire_${DateTime.now().millisecondsSinceEpoch}',
          type: 'corruption_scandal',
          title: '📰 Corruption Scandal Breaking',
          description: 'Media has uncovered evidence of police corruption in your operations. Several of your corrupt officials are at risk of exposure.',
          timestamp: DateTime.now(),
          effects: {
            'threatened_officials': status.corruptOfficials ~/ 2,
            'heat_increase': 75,
            'media_attention': true,
          },
          options: [
            {
              'text': 'Eliminate Witnesses',
              'action': 'eliminate_witnesses',
              'cost': 750000,
              'description': 'Silence the journalists and witnesses permanently',
              'success_chance': 60,
            },
            {
              'text': 'Media Manipulation Campaign',
              'action': 'media_manipulation',
              'cost': 1500000,
              'description': 'Launch counter-narrative and discredit reports',
              'success_chance': 70,
            },
            {
              'text': 'Scapegoat Operation',
              'action': 'scapegoat_operation',
              'cost': 500000,
              'description': 'Sacrifice low-level corrupt officials to protect the network',
              'success_chance': 85,
            },
            {
              'text': 'Go Underground',
              'action': 'go_underground',
              'cost': 250000,
              'description': 'Temporarily halt all corruption operations',
              'success_chance': 95,
            },
          ],
          requiresResponse: true,
          priority: 8,
        );

      case 'heist_opportunity_intel':
        final targets = [
          {'name': 'Federal Reserve Branch', 'value': 50000000, 'difficulty': 95},
          {'name': 'Diamond Exchange', 'value': 25000000, 'difficulty': 85},
          {'name': 'Cryptocurrency Exchange', 'value': 100000000, 'difficulty': 90},
          {'name': 'Art Museum Vault', 'value': 15000000, 'difficulty': 75},
        ];
        final target = targets[_random.nextInt(targets.length)];
        
        return EmpireEvent(
          id: 'empire_${DateTime.now().millisecondsSinceEpoch}',
          type: 'heist_opportunity_intel',
          title: '💎 Ultra High-Value Heist Intel',
          description: 'Your network has obtained inside information about a once-in-a-lifetime heist opportunity: ${target['name']}. Estimated value: \$${(target['value'] as int).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
          timestamp: DateTime.now(),
          effects: {
            'target_name': target['name'],
            'estimated_value': target['value'],
            'difficulty_rating': target['difficulty'],
            'time_window': '72 hours',
          },
          options: [
            {
              'text': 'Assemble Elite Crew',
              'action': 'elite_heist',
              'cost': 5000000,
              'description': 'Recruit the best crew money can buy for this job',
              'success_chance': 70,
            },
            {
              'text': 'Use Existing Gang',
              'action': 'gang_heist',
              'cost': 1000000,
              'description': 'Use your current gang members for the heist',
              'success_chance': 40,
            },
            {
              'text': 'Sell Intel to Rivals',
              'action': 'sell_intel',
              'cost': 0,
              'description': 'Sell the information instead of taking the risk',
              'success_chance': 100,
            },
            {
              'text': 'Too Risky - Pass',
              'action': 'pass_heist',
              'cost': 0,
              'description': 'The risk isn\'t worth the reward',
              'success_chance': 100,
            },
          ],
          requiresResponse: false,
          priority: 5,
        );

      default:
        return EmpireEvent(
          id: 'empire_${DateTime.now().millisecondsSinceEpoch}',
          type: 'general_event',
          title: '📊 Empire Update',
          description: 'General empire development event.',
          timestamp: DateTime.now(),
          effects: {},
          options: [],
          requiresResponse: false,
          priority: 1,
        );
    }
  }

  // Determine empire rank based on power metrics
  static String _determineEmpireRank(int netWorth, int reputation, int stateCount) {
    int powerScore = 0;
    
    // Net worth scoring
    if (netWorth >= 100000000) powerScore += 40;      // $100M+
    else if (netWorth >= 50000000) powerScore += 30;  // $50M+
    else if (netWorth >= 10000000) powerScore += 20;  // $10M+
    else if (netWorth >= 1000000) powerScore += 10;   // $1M+
    
    // Reputation scoring
    if (reputation >= 1000) powerScore += 30;         // Legendary
    else if (reputation >= 500) powerScore += 20;     // Notorious
    else if (reputation >= 250) powerScore += 15;     // Known
    else if (reputation >= 100) powerScore += 10;     // Small-time
    
    // Multi-state operations
    if (stateCount >= 8) powerScore += 30;            // National
    else if (stateCount >= 5) powerScore += 20;       // Regional
    else if (stateCount >= 3) powerScore += 15;       // Multi-state
    else if (stateCount >= 2) powerScore += 10;       // Bi-state
    
    // Determine rank
    if (powerScore >= 90) return '👑 Criminal Emperor';
    else if (powerScore >= 75) return '🏰 Crime Lord';
    else if (powerScore >= 60) return '⚡ Kingpin';
    else if (powerScore >= 45) return '💼 Boss';
    else if (powerScore >= 30) return '🔫 Lieutenant';
    else if (powerScore >= 20) return '💊 Dealer';
    else if (powerScore >= 10) return '🏃 Runner';
    else return '🤏 Small-time';
  }

  // Execute empire event response
  static Map<String, dynamic> executeEmpireEventResponse(
    EmpireEvent event,
    String chosenAction,
    Map<String, dynamic> gameState,
  ) {
    Map<String, dynamic> result = {
      'success': false,
      'message': '',
      'effects': <String, dynamic>{},
      'costs': <String, int>{},
      'rewards': <String, int>{},
      'narrative': <String>[],
    };

    // Find the chosen option
    final option = event.options.firstWhere(
      (opt) => opt['action'] == chosenAction,
      orElse: () => {'success_chance': 0, 'cost': 0},
    );

    final successChance = (option['success_chance'] as int) / 100.0;
    final cost = option['cost'] as int;
    final success = _random.nextDouble() < successChance;

    result['success'] = success;
    result['costs']['money'] = cost;

    // Event-specific outcomes
    switch (event.type) {
      case 'federal_raid_coordinated':
        if (chosenAction == 'emergency_evacuation' && success) {
          result['message'] = '✅ Successfully evacuated all operations before raids hit!';
          result['effects']['heat_reduction'] = 50;
          result['effects']['operations_saved'] = true;
          result['narrative'].add('Your emergency protocols worked perfectly. All crew and assets evacuated safely.');
        } else if (chosenAction == 'federal_bribery' && success) {
          result['message'] = '💰 Federal officials successfully bribed! Raids called off.';
          result['effects']['heat_reduction'] = 75;
          result['effects']['federal_protection'] = 30; // days
          result['narrative'].add('Money talks even at the federal level. The task force has been "redirected".');
        } else if (chosenAction == 'federal_war' && success) {
          result['message'] = '⚔️ Your crew fought off the feds! Massive reputation boost.';
          result['effects']['reputation_gain'] = 200;
          result['effects']['heat_increase'] = 100; // But more heat
          result['narrative'].add('The streets will remember this day. You went to war with the feds and won!');
        } else if (!success) {
          result['message'] = '🚨 Operation failed! Federal raids successful.';
          result['effects']['asset_losses'] = _random.nextInt(3) + 2;
          result['effects']['crew_arrested'] = _random.nextInt(5) + 3;
          result['effects']['heat_increase'] = 150;
          result['narrative'].add('The feds hit hard. Major losses across your empire.');
        }
        break;

      case 'gang_alliance_opportunity':
        if (chosenAction == 'accept_alliance' && success) {
          result['message'] = '🤝 Alliance formed! International operations now available.';
          result['effects']['alliance_active'] = true;
          result['effects']['territory_bonus'] = 3;
          result['effects']['protection_level'] = 50;
          result['effects']['international_access'] = true;
          result['narrative'].add('You are now part of an international criminal network.');
        } else if (chosenAction == 'challenge_alliance' && success) {
          result['message'] = '💪 Respect earned through strength! Alliance on your terms.';
          result['effects']['reputation_gain'] = 100;
          result['effects']['alliance_respect'] = true;
          result['narrative'].add('They respect strength. You\'ve earned a place at the table as an equal.');
        }
        break;

      case 'heist_opportunity_intel':
        if (chosenAction == 'elite_heist' && success) {
          final targetValue = event.effects['estimated_value'] as int;
          result['message'] = '💎 HEIST SUCCESS! Legendary score achieved.';
          result['rewards']['money'] = (targetValue * 0.7).toInt(); // 70% after expenses
          result['effects']['reputation_gain'] = 300;
          result['effects']['legendary_heist'] = true;
          result['narrative'].add('The heist of the century! Your name will be whispered in criminal circles forever.');
        } else if (chosenAction == 'sell_intel') {
          result['message'] = '📊 Intel sold to highest bidder.';
          result['rewards']['money'] = 2000000;
          result['effects']['reputation_gain'] = 25;
          result['narrative'].add('Sometimes the smart play is to let others take the risk.');
        }
        break;
    }

    return result;
  }

  // Calculate empire power level for various systems
  static int calculateEmpirePowerLevel(EmpireStatus status) {
    int powerLevel = 0;
    
    // Financial power (40% of total)
    powerLevel += (status.totalNetWorth / 1000000).clamp(0, 40).toInt();
    
    // Territory control (25% of total)
    powerLevel += (status.territoryCount * 2).clamp(0, 25);
    
    // Gang strength (20% of total)
    powerLevel += (status.gangSize * 1.5).clamp(0, 20).toInt();
    
    // Multi-state operations (15% of total)
    powerLevel += (status.operationalStates.length * 2).clamp(0, 15);
    
    return powerLevel.clamp(1, 100);
  }

  // Generate end-game scenarios
  static Map<String, dynamic>? generateEndGameScenario(EmpireStatus status) {
    final powerLevel = calculateEmpirePowerLevel(status);
    
    if (powerLevel < 80) return null; // Not ready for endgame
    
    final scenarios = [
      'federal_takedown_attempt',
      'criminal_organization_war',
      'government_deal_offer',
      'international_expansion',
      'retirement_exit_strategy',
    ];
    
    final scenario = scenarios[_random.nextInt(scenarios.length)];
    
    switch (scenario) {
      case 'federal_takedown_attempt':
        return {
          'type': 'federal_takedown_attempt',
          'title': '🎯 FEDERAL OPERATION: LAST STAND',
          'description': 'The government has had enough. A massive federal operation involving FBI, DEA, ATF, and military assets is being assembled to take down your empire once and for all.',
          'threat_level': 100,
          'time_limit': '48 hours',
          'success_requirements': {
            'corrupt_officials': 10,
            'federal_protection_level': 75,
            'gang_strength': 500,
            'emergency_fund': 50000000,
          },
        };
        
      case 'criminal_organization_war':
        return {
          'type': 'criminal_organization_war',
          'title': '⚔️ THE ULTIMATE GANG WAR',
          'description': 'All major criminal organizations have united against you. This is the war to end all wars - winner takes control of the entire underworld.',
          'threat_level': 95,
          'enemy_strength': 1000,
          'prize': 'Complete criminal underworld control',
        };
        
      case 'government_deal_offer':
        return {
          'type': 'government_deal_offer',
          'title': '🏛️ GOVERNMENT IMMUNITY DEAL',
          'description': 'The government offers you complete immunity and witness protection in exchange for intelligence on international criminal networks.',
          'offer_value': 'Complete immunity + \$100M settlement',
          'requirement': 'Betray all criminal contacts and allies',
        };
        
      default:
        return null;
    }
  }
}

// Extension for EmpireStatus
extension EmpireStatusExtension on EmpireStatus {
  Map<String, dynamic> toMap() {
    return {
      'total_net_worth': totalNetWorth,
      'monthly_income': monthlyIncome,
      'territory_count': territoryCount,
      'gang_size': gangSize,
      'vehicle_count': vehicleCount,
      'property_count': propertyCount,
      'corrupt_officials': corruptOfficials,
      'operational_states': operationalStates,
      'reputation': reputation,
      'federal_heat': federalHeat,
      'empire_rank': empireRank,
    };
  }
}
