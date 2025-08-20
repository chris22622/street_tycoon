import 'dart:math';

class CorruptOfficial {
  final String id;
  final String name;
  final String position;
  final String department;
  final String icon;
  final int greedLevel; // 1-100, how much they want for bribes
  final int influence; // 1-100, how much they can help
  final int loyalty; // 1-100, how trustworthy they are
  final int suspicion; // 0-100, how suspicious they are of you
  final Map<String, int> services; // What they can provide
  final bool isCompromised; // If they've been caught

  const CorruptOfficial({
    required this.id,
    required this.name,
    required this.position,
    required this.department,
    required this.icon,
    required this.greedLevel,
    required this.influence,
    required this.loyalty,
    required this.suspicion,
    required this.services,
    required this.isCompromised,
  });
}

class BriberyService {
  static final Random _random = Random();

  // Available corrupt officials to bribe
  static List<CorruptOfficial> getCorruptOfficials() {
    return [
      // Police
      const CorruptOfficial(
        id: 'detective_murphy',
        name: 'Detective Mike Murphy',
        position: 'Detective',
        department: 'Police Department',
        icon: '👮',
        greedLevel: 70,
        influence: 80,
        loyalty: 60,
        suspicion: 30,
        services: {
          'evidence_disposal': 15000,
          'case_delay': 8000,
          'witness_intimidation': 12000,
          'police_tip_off': 5000,
        },
        isCompromised: false,
      ),
      
      const CorruptOfficial(
        id: 'sergeant_rodriguez',
        name: 'Sergeant Maria Rodriguez',
        position: 'Patrol Sergeant',
        department: 'Police Department',
        icon: '👮‍♀️',
        greedLevel: 50,
        influence: 60,
        loyalty: 80,
        suspicion: 20,
        services: {
          'patrol_avoidance': 3000,
          'traffic_stop_immunity': 2000,
          'minor_charges_dropped': 5000,
          'early_warning': 1000,
        },
        isCompromised: false,
      ),
      
      const CorruptOfficial(
        id: 'chief_williams',
        name: 'Police Chief Robert Williams',
        position: 'Police Chief',
        department: 'Police Department',
        icon: '👨‍✈️',
        greedLevel: 95,
        influence: 95,
        loyalty: 40,
        suspicion: 70,
        services: {
          'major_case_dismissal': 50000,
          'departmental_protection': 25000,
          'evidence_tampering': 30000,
          'witness_protection': 20000,
        },
        isCompromised: false,
      ),
      
      // Federal Agents
      const CorruptOfficial(
        id: 'agent_clark',
        name: 'DEA Agent John Clark',
        position: 'Special Agent',
        department: 'DEA',
        icon: '🕵️‍♂️',
        greedLevel: 85,
        influence: 90,
        loyalty: 30,
        suspicion: 80,
        services: {
          'drug_case_sabotage': 75000,
          'federal_investigation_delay': 40000,
          'informant_protection': 35000,
          'evidence_planting_rival': 60000,
        },
        isCompromised: false,
      ),
      
      // Judges
      const CorruptOfficial(
        id: 'judge_peterson',
        name: 'Judge Harold Peterson',
        position: 'Circuit Judge',
        department: 'County Court',
        icon: '⚖️',
        greedLevel: 80,
        influence: 85,
        loyalty: 50,
        suspicion: 60,
        services: {
          'reduced_sentence': 40000,
          'case_dismissal': 80000,
          'bail_reduction': 15000,
          'favorable_ruling': 25000,
        },
        isCompromised: false,
      ),
      
      // Politicians
      const CorruptOfficial(
        id: 'councilman_davis',
        name: 'Councilman Michael Davis',
        position: 'City Councilman',
        department: 'City Council',
        icon: '🏛️',
        greedLevel: 60,
        influence: 70,
        loyalty: 70,
        suspicion: 40,
        services: {
          'zoning_permits': 20000,
          'business_licenses': 10000,
          'police_budget_cuts': 30000,
          'city_contracts': 25000,
        },
        isCompromised: false,
      ),
      
      // Prison Guards
      const CorruptOfficial(
        id: 'guard_thompson',
        name: 'Guard Kevin Thompson',
        position: 'Correctional Officer',
        department: 'State Prison',
        icon: '👨‍💼',
        greedLevel: 40,
        influence: 50,
        loyalty: 90,
        suspicion: 10,
        services: {
          'contraband_smuggling': 5000,
          'cell_privileges': 2000,
          'protection_arrangement': 8000,
          'early_release_paperwork': 15000,
        },
        isCompromised: false,
      ),
      
      // Federal Prosecutors
      const CorruptOfficial(
        id: 'prosecutor_anderson',
        name: 'Federal Prosecutor Lisa Anderson',
        position: 'U.S. Attorney',
        department: 'U.S. Attorney\'s Office',
        icon: '👩‍💼',
        greedLevel: 90,
        influence: 95,
        loyalty: 25,
        suspicion: 85,
        services: {
          'federal_charges_dropped': 100000,
          'plea_deal_favorable': 60000,
          'investigation_misdirection': 80000,
          'witness_relocation': 45000,
        },
        isCompromised: false,
      ),
    ];
  }

  // Calculate bribe success chance
  static double calculateBribeSuccessChance(
    CorruptOfficial official,
    int bribeAmount,
    String serviceType,
    Map<String, dynamic> playerReputation,
  ) {
    // Base success chance
    double baseChance = 0.3;
    
    // Bribe amount factor
    final expectedAmount = official.services[serviceType] ?? 10000;
    final amountRatio = bribeAmount / expectedAmount;
    
    if (amountRatio >= 1.5) {
      baseChance += 0.4; // 150%+ of expected = +40%
    } else if (amountRatio >= 1.0) {
      baseChance += 0.2; // 100%+ of expected = +20%
    } else if (amountRatio >= 0.7) {
      baseChance += 0.1; // 70%+ of expected = +10%
    } else {
      baseChance -= 0.3; // Less than 70% = -30%
    }
    
    // Official's greed level (higher greed = easier to bribe)
    baseChance += (official.greedLevel / 100.0) * 0.3;
    
    // Official's suspicion level (higher suspicion = harder to bribe)
    baseChance -= (official.suspicion / 100.0) * 0.4;
    
    // Player reputation factors
    final playerHeat = (playerReputation['heat'] ?? 0) / 100.0;
    final playerMoney = (playerReputation['money'] ?? 0) / 1000000.0; // Money in millions
    final playerConnections = (playerReputation['connections'] ?? 0) / 10.0;
    
    baseChance -= playerHeat * 0.2; // High heat makes officials nervous
    baseChance += playerMoney * 0.1; // Rich players are more attractive
    baseChance += playerConnections * 0.05; // Connections help
    
    return baseChance.clamp(0.05, 0.95); // 5% minimum, 95% maximum
  }

  // Execute bribe attempt
  static Map<String, dynamic> executeBribe(
    CorruptOfficial official,
    int bribeAmount,
    String serviceType,
    Map<String, dynamic> playerReputation,
  ) {
    final successChance = calculateBribeSuccessChance(official, bribeAmount, serviceType, playerReputation);
    final success = _random.nextDouble() < successChance;
    
    Map<String, dynamic> result = {
      'success': success,
      'money_spent': bribeAmount,
      'service_provided': success ? serviceType : null,
      'official_loyalty_change': 0,
      'official_suspicion_change': 0,
      'heat_change': 0,
      'investigation_risk': false,
      'message': '',
    };
    
    if (success) {
      // Successful bribe
      result['official_loyalty_change'] = _random.nextInt(20) + 10; // +10 to +30 loyalty
      result['official_suspicion_change'] = -(_random.nextInt(10) + 5); // -5 to -15 suspicion
      result['heat_change'] = -(_random.nextInt(15) + 5); // -5 to -20 heat
      
      // Service-specific effects
      switch (serviceType) {
        case 'evidence_disposal':
          result['evidence_destroyed'] = true;
          result['case_strength_reduced'] = 50;
          break;
        case 'case_delay':
          result['case_delayed_days'] = _random.nextInt(30) + 14; // 2-6 weeks
          break;
        case 'witness_intimidation':
          result['witness_silenced'] = true;
          result['case_strength_reduced'] = 30;
          break;
        case 'patrol_avoidance':
          result['patrol_immunity_days'] = 7;
          break;
        case 'major_case_dismissal':
          result['case_dismissed'] = true;
          result['charges_dropped'] = true;
          break;
      }
      
      result['message'] = '💰 ${official.name} accepted the bribe. ${_getServiceDescription(serviceType)} activated.';
      
    } else {
      // Failed bribe
      result['official_suspicion_change'] = _random.nextInt(30) + 20; // +20 to +50 suspicion
      result['heat_change'] = _random.nextInt(25) + 15; // +15 to +40 heat
      result['investigation_risk'] = _random.nextDouble() < 0.6; // 60% chance of investigation
      
      // Chance of arrest
      if (_random.nextDouble() < 0.3) { // 30% chance
        result['arrested_for_bribery'] = true;
        result['bribery_charges'] = true;
        result['message'] = '🚨 Bribery attempt failed! ${official.name} reported you to authorities. You\'ve been arrested for attempted bribery.';
      } else {
        result['message'] = '❌ ${official.name} rejected the bribe. Your reputation with law enforcement has been damaged.';
      }
      
      // Official might become compromised
      if (_random.nextDouble() < 0.2) { // 20% chance
        result['official_compromised'] = true;
        result['message'] += ' ${official.name} is now under internal investigation.';
      }
    }
    
    return result;
  }

  // Get protection level from corrupt officials
  static int calculateProtectionLevel(List<CorruptOfficial> corruptOfficials) {
    int totalProtection = 0;
    
    for (var official in corruptOfficials) {
      if (!official.isCompromised) {
        totalProtection += (official.influence * official.loyalty) ~/ 100;
      }
    }
    
    return totalProtection.clamp(0, 100);
  }

  // Generate corruption events
  static Map<String, dynamic>? generateCorruptionEvent(
    List<CorruptOfficial> corruptOfficials,
    Map<String, dynamic> playerStatus,
  ) {
    if (_random.nextDouble() > 0.25) return null; // 25% chance
    
    final events = [
      'official_demands_payment',
      'official_compromised',
      'new_official_available',
      'investigation_leak',
      'protection_expired',
      'rival_bribing_same_official',
    ];
    
    final eventType = events[_random.nextInt(events.length)];
    
    switch (eventType) {
      case 'official_demands_payment':
        if (corruptOfficials.isNotEmpty) {
          final official = corruptOfficials[_random.nextInt(corruptOfficials.length)];
          final demandAmount = _random.nextInt(20000) + 5000;
          
          return {
            'type': 'official_demands_payment',
            'title': '💰 Payment Demanded',
            'message': '${official.name} is demanding \$${demandAmount} to keep quiet about your operations.',
            'official': official.id,
            'amount': demandAmount,
            'threat_level': _random.nextInt(50) + 30,
            'options': [
              {'text': 'Pay Up', 'action': 'pay', 'cost': demandAmount},
              {'text': 'Negotiate', 'action': 'negotiate', 'cost': demandAmount ~/ 2},
              {'text': 'Refuse & Threaten', 'action': 'threaten', 'cost': 0},
              {'text': 'Eliminate Threat', 'action': 'eliminate', 'cost': 15000},
            ],
          };
        }
        break;
        
      case 'official_compromised':
        if (corruptOfficials.isNotEmpty) {
          final official = corruptOfficials[_random.nextInt(corruptOfficials.length)];
          
          return {
            'type': 'official_compromised',
            'title': '🚨 Official Compromised',
            'message': '${official.name} has been caught in an internal investigation. They can no longer provide protection.',
            'official': official.id,
            'heat_increase': _random.nextInt(30) + 20,
            'investigation_risk': true,
            'options': [
              {'text': 'Cut All Ties', 'action': 'cut_ties', 'cost': 0},
              {'text': 'Try to Help Them', 'action': 'help', 'cost': 25000},
              {'text': 'Eliminate Evidence', 'action': 'eliminate_evidence', 'cost': 10000},
            ],
          };
        }
        break;
        
      case 'investigation_leak':
        if (corruptOfficials.isNotEmpty) {
          final official = corruptOfficials[_random.nextInt(corruptOfficials.length)];
          
          return {
            'type': 'investigation_leak',
            'title': '📢 Inside Information',
            'message': '${official.name} has leaked information about an upcoming federal operation targeting you.',
            'official': official.id,
            'operation_type': ['raid', 'surveillance', 'arrest_warrant', 'asset_seizure'][_random.nextInt(4)],
            'time_to_prepare': _random.nextInt(48) + 12, // 12-60 hours
            'options': [
              {'text': 'Prepare Defenses', 'action': 'prepare', 'cost': 20000},
              {'text': 'Go Underground', 'action': 'underground', 'cost': 5000},
              {'text': 'Counter-Operation', 'action': 'counter', 'cost': 50000},
              {'text': 'Ignore Warning', 'action': 'ignore', 'cost': 0},
            ],
          };
        }
        break;
    }
    
    return null;
  }

  // Helper function to get service descriptions
  static String _getServiceDescription(String serviceType) {
    switch (serviceType) {
      case 'evidence_disposal':
        return 'Key evidence has been "lost"';
      case 'case_delay':
        return 'Your case has been delayed indefinitely';
      case 'witness_intimidation':
        return 'Star witness has "changed their mind"';
      case 'patrol_avoidance':
        return 'Police patrols will avoid your areas';
      case 'major_case_dismissal':
        return 'All major charges have been dismissed';
      case 'reduced_sentence':
        return 'Sentence has been significantly reduced';
      case 'contraband_smuggling':
        return 'Contraband delivery successful';
      default:
        return 'Service completed successfully';
    }
  }

  // Calculate daily corruption costs
  static int calculateDailyCorruptionCosts(List<CorruptOfficial> corruptOfficials) {
    int dailyCost = 0;
    
    for (var official in corruptOfficials) {
      if (!official.isCompromised) {
        // Officials with higher influence cost more to maintain
        dailyCost += (official.influence * official.greedLevel) ~/ 20;
      }
    }
    
    return dailyCost;
  }

  // Get available officials by department
  static List<CorruptOfficial> getOfficialsByDepartment(String department) {
    return getCorruptOfficials()
        .where((official) => official.department == department)
        .toList();
  }
}
