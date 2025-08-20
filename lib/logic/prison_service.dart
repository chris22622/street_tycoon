import 'dart:math';

class PrisonFacility {
  final String id;
  final String name;
  final String description;
  final String securityLevel;
  final String icon;
  final Map<String, dynamic> characteristics;
  final Map<String, double> operationModifiers;

  const PrisonFacility({
    required this.id,
    required this.name,
    required this.description,
    required this.securityLevel,
    required this.icon,
    required this.characteristics,
    required this.operationModifiers,
  });

  // Additional getters for UI compatibility
  double get riskFactor => (operationModifiers['riskReduction'] ?? 0.0) * 100;
  double get profitMultiplier => operationModifiers['profitMultiplier'] ?? 1.0;
  int get maxOperations {
    switch (securityLevel) {
      case 'Minimum': return 5;
      case 'Medium': return 3;
      case 'Maximum': return 2;
      case 'Super Maximum': return 1;
      default: return 3;
    }
  }
}

class PrisonOperation {
  final String id;
  final String name;
  final String description;
  final String icon;
  final int baseProfitPerDay;
  final int riskLevel;
  final Map<String, dynamic> requirements;
  final List<String> possibleOutcomes;

  const PrisonOperation({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.baseProfitPerDay,
    required this.riskLevel,
    required this.requirements,
    required this.possibleOutcomes,
  });

  // Additional getters for UI compatibility
  int get dailyIncome => baseProfitPerDay;
  int get startupCost => requirements['startupCost'] ?? (baseProfitPerDay * 3);
}

class PrisonContact {
  final String id;
  final String name;
  final String role;
  final String description;
  final String icon;
  final int loyalty;
  final int influence;
  final Map<String, dynamic> services;
  final int recruitmentCost;

  const PrisonContact({
    required this.id,
    required this.name,
    required this.role,
    required this.description,
    required this.icon,
    required this.loyalty,
    required this.influence,
    required this.services,
    required this.recruitmentCost,
  });
}

class PrisonService {
  static final Random _random = Random();
  
  static List<PrisonFacility> getPrisonFacilities() {
    return [
      const PrisonFacility(
        id: 'county_jail',
        name: 'County Jail',
        description: 'Local detention facility for short sentences',
        securityLevel: 'Minimum',
        icon: '🏢',
        characteristics: {
          'population': 500,
          'corruption': 'high',
          'visitation': 'easy',
          'communication': 'monitored',
        },
        operationModifiers: {
          'profitMultiplier': 0.8,
          'riskReduction': 0.3,
          'contactEase': 0.9,
          'escapeChance': 0.2,
        },
      ),
      
      const PrisonFacility(
        id: 'state_pen',
        name: 'State Penitentiary',
        description: 'Medium security state prison',
        securityLevel: 'Medium',
        icon: '🏭',
        characteristics: {
          'population': 2000,
          'corruption': 'moderate',
          'visitation': 'limited',
          'communication': 'restricted',
        },
        operationModifiers: {
          'profitMultiplier': 1.0,
          'riskReduction': 0.1,
          'contactEase': 0.6,
          'escapeChance': 0.1,
        },
      ),
      
      const PrisonFacility(
        id: 'federal_prison',
        name: 'Federal Correctional Institution',
        description: 'Federal prison for serious offenders',
        securityLevel: 'High',
        icon: '🏰',
        characteristics: {
          'population': 1500,
          'corruption': 'low',
          'visitation': 'rare',
          'communication': 'heavily_monitored',
        },
        operationModifiers: {
          'profitMultiplier': 1.3,
          'riskReduction': -0.1,
          'contactEase': 0.4,
          'escapeChance': 0.05,
        },
      ),
      
      const PrisonFacility(
        id: 'supermax',
        name: 'ADX Florence (Supermax)',
        description: 'Maximum security federal prison',
        securityLevel: 'Supermax',
        icon: '🔒',
        characteristics: {
          'population': 400,
          'corruption': 'minimal',
          'visitation': 'none',
          'communication': 'prohibited',
        },
        operationModifiers: {
          'profitMultiplier': 0.3,
          'riskReduction': -0.5,
          'contactEase': 0.1,
          'escapeChance': 0.01,
        },
      ),
    ];
  }
  
  static List<PrisonOperation> getPrisonOperations() {
    return [
      const PrisonOperation(
        id: 'contraband_smuggling',
        name: 'Contraband Smuggling',
        description: 'Smuggle drugs, phones, and weapons into prison',
        icon: '📦',
        baseProfitPerDay: 150,
        riskLevel: 60,
        requirements: {'contacts': 1, 'reputation': 20},
        possibleOutcomes: ['profit', 'solitary', 'extended_sentence', 'contact_loss'],
      ),
      
      const PrisonOperation(
        id: 'protection_racket',
        name: 'Protection Racket',
        description: 'Offer protection services to vulnerable inmates',
        icon: '🛡️',
        baseProfitPerDay: 100,
        riskLevel: 40,
        requirements: {'muscle': 2, 'reputation': 30},
        possibleOutcomes: ['profit', 'gang_war', 'guard_attention', 'reputation_boost'],
      ),
      
      const PrisonOperation(
        id: 'gambling_ring',
        name: 'Prison Gambling',
        description: 'Run illegal gambling operations',
        icon: '🎲',
        baseProfitPerDay: 80,
        riskLevel: 30,
        requirements: {'reputation': 15, 'startup_cash': 500},
        possibleOutcomes: ['profit', 'debt_collection', 'guard_raid', 'expansion'],
      ),
      
      const PrisonOperation(
        id: 'commissary_control',
        name: 'Commissary Control',
        description: 'Control access to commissary goods',
        icon: '🏪',
        baseProfitPerDay: 200,
        riskLevel: 50,
        requirements: {'contacts': 3, 'reputation': 50},
        possibleOutcomes: ['profit', 'rival_gang', 'administration_notice', 'monopoly'],
      ),
      
      const PrisonOperation(
        id: 'outside_coordination',
        name: 'Outside Operations',
        description: 'Coordinate criminal activities on the outside',
        icon: '📞',
        baseProfitPerDay: 500,
        riskLevel: 80,
        requirements: {'communication_access': true, 'outside_crew': 3},
        possibleOutcomes: ['massive_profit', 'fbi_investigation', 'phone_loss', 'crew_arrest'],
      ),
      
      const PrisonOperation(
        id: 'drug_manufacturing',
        name: 'Prison Drug Lab',
        description: 'Manufacture drugs using prison resources',
        icon: '⚗️',
        baseProfitPerDay: 300,
        riskLevel: 90,
        requirements: {'chemistry_knowledge': true, 'secure_location': true},
        possibleOutcomes: ['high_profit', 'explosion', 'overdose_investigation', 'recipe_improvement'],
      ),
      
      const PrisonOperation(
        id: 'escape_planning',
        name: 'Escape Operations',
        description: 'Plan and execute prison escapes',
        icon: '🏃',
        baseProfitPerDay: 0,
        riskLevel: 100,
        requirements: {'reputation': 80, 'contacts': 5, 'patience': 90},
        possibleOutcomes: ['freedom', 'death', 'supermax_transfer', 'legend_status'],
      ),
    ];
  }
  
  static List<PrisonContact> getPrisonContacts() {
    return [
      const PrisonContact(
        id: 'corrupt_guard',
        name: 'Officer Martinez',
        role: 'Corrupt Guard',
        description: 'Prison guard willing to look the other way for the right price',
        icon: '👮',
        loyalty: 60,
        influence: 40,
        services: {
          'contraband_delivery': 200,
          'special_privileges': 150,
          'information': 100,
          'protection': 300,
        },
        recruitmentCost: 2000,
      ),
      
      const PrisonContact(
        id: 'gang_leader',
        name: 'Big Mike',
        role: 'Gang Leader',
        description: 'Influential inmate who controls a significant crew',
        icon: '👑',
        loyalty: 80,
        influence: 90,
        services: {
          'muscle': 500,
          'territory_control': 800,
          'gang_protection': 600,
          'recruitment': 400,
        },
        recruitmentCost: 5000,
      ),
      
      const PrisonContact(
        id: 'prison_doctor',
        name: 'Dr. Stevens',
        role: 'Medical Staff',
        description: 'Prison doctor who can provide medical exemptions',
        icon: '⚕️',
        loyalty: 40,
        influence: 60,
        services: {
          'medical_exemption': 1000,
          'drug_access': 300,
          'fake_illness': 200,
          'medical_transfer': 2000,
        },
        recruitmentCost: 3000,
      ),
      
      const PrisonContact(
        id: 'kitchen_boss',
        name: 'Chef Rodriguez',
        role: 'Kitchen Supervisor',
        description: 'Controls food distribution and kitchen access',
        icon: '👨‍🍳',
        loyalty: 70,
        influence: 50,
        services: {
          'food_smuggling': 150,
          'kitchen_access': 100,
          'poisoning': 500,
          'meeting_space': 200,
        },
        recruitmentCost: 1500,
      ),
      
      const PrisonContact(
        id: 'lawyer_contact',
        name: 'Attorney Johnson',
        role: 'Legal Counsel',
        description: 'Outside lawyer who handles appeals and communications',
        icon: '⚖️',
        loyalty: 50,
        influence: 70,
        services: {
          'appeal_filing': 5000,
          'outside_communication': 300,
          'evidence_tampering': 2000,
          'sentence_reduction': 10000,
        },
        recruitmentCost: 8000,
      ),
      
      const PrisonContact(
        id: 'warden_assistant',
        name: 'Ms. Thompson',
        role: 'Administrative Staff',
        description: 'Warden\'s assistant with access to sensitive information',
        icon: '💼',
        loyalty: 30,
        influence: 80,
        services: {
          'record_modification': 3000,
          'transfer_request': 2500,
          'visitation_extension': 500,
          'confidential_info': 1000,
        },
        recruitmentCost: 6000,
      ),
    ];
  }
  
  static PrisonFacility determinePrisonPlacement(List<String> charges, int sentenceYears) {
    final facilities = getPrisonFacilities();
    
    // Determine security level based on charges and sentence
    if (charges.any((c) => c.contains('Explosive') || c.contains('Criminal Enterprise')) || sentenceYears > 25) {
      return facilities.firstWhere((f) => f.id == 'supermax');
    } else if (charges.any((c) => c.contains('Federal')) || sentenceYears > 10) {
      return facilities.firstWhere((f) => f.id == 'federal_prison');
    } else if (sentenceYears > 3) {
      return facilities.firstWhere((f) => f.id == 'state_pen');
    } else {
      return facilities.firstWhere((f) => f.id == 'county_jail');
    }
  }
  
  static Map<String, dynamic> simulatePrisonDay(
    PrisonFacility facility,
    List<PrisonOperation> activeOperations,
    List<PrisonContact> contacts,
    Map<String, dynamic> prisonStats,
  ) {
    final results = <String, dynamic>{
      'dailyProfit': 0,
      'riskEvents': <String>[],
      'opportunityEvents': <String>[],
      'reputationChange': 0,
    };
    
    for (var operation in activeOperations) {
      final baseProfit = operation.baseProfitPerDay;
      final facilityModifier = facility.operationModifiers['profitMultiplier'] ?? 1.0;
      final dailyProfit = (baseProfit * facilityModifier).round();
      
      results['dailyProfit'] += dailyProfit;
      
      // Check for random events
      final riskRoll = _random.nextInt(100);
      final adjustedRisk = (operation.riskLevel * (1 - (facility.operationModifiers['riskReduction'] ?? 0))).round();
      
      if (riskRoll < adjustedRisk) {
        final outcome = operation.possibleOutcomes[_random.nextInt(operation.possibleOutcomes.length)];
        results['riskEvents'].add('${operation.name}: $outcome');
        
        // Apply outcome effects
        switch (outcome) {
          case 'solitary':
            results['solitaryDays'] = 7 + _random.nextInt(14);
            break;
          case 'extended_sentence':
            results['sentenceExtension'] = 1 + _random.nextInt(3);
            break;
          case 'reputation_boost':
            results['reputationChange'] += 10;
            break;
          case 'massive_profit':
            results['dailyProfit'] *= 3;
            break;
        }
      }
    }
    
    return results;
  }
  
  static bool checkParoleEligibility(int daysSentenced, int totalSentenceDays, Map<String, dynamic> prisonRecord) {
    final timeServed = daysSentenced / totalSentenceDays;
    final goodBehavior = prisonRecord['disciplinaryActions'] ?? 0;
    final programParticipation = prisonRecord['programsCompleted'] ?? 0;
    
    // Basic eligibility: served at least 1/3 of sentence
    if (timeServed < 0.33) return false;
    
    // Good behavior bonus
    if (goodBehavior < 3 && programParticipation > 2 && timeServed > 0.5) return true;
    
    // Standard parole eligibility
    return timeServed > 0.66 && goodBehavior < 5;
  }
  
  static int calculateParoleChance(Map<String, dynamic> prisonRecord, List<PrisonContact> contacts) {
    int baseChance = 30;
    
    // Good behavior
    final disciplinary = (prisonRecord['disciplinaryActions'] ?? 0) as num;
    baseChance -= (disciplinary * 5).toInt();
    
    // Program participation
    final programs = (prisonRecord['programsCompleted'] ?? 0) as num;
    baseChance += (programs * 10).toInt();
    
    // Legal help
    final hasLawyer = contacts.any((c) => c.role == 'Legal Counsel');
    if (hasLawyer) baseChance += 20;
    
    // Reputation (can hurt or help)
    final reputation = prisonRecord['reputation'] ?? 0;
    if (reputation > 80) baseChance -= 15; // Too notorious
    if (reputation < 20) baseChance += 10; // Keeps low profile
    
    return baseChance.clamp(5, 85);
  }

  // Get current facility from prison data
  static PrisonFacility getCurrentFacility(Map<String, dynamic> prisonData) {
    final facilityId = prisonData['currentFacility'] ?? 'county_jail';
    final facilities = getPrisonFacilities();
    return facilities.firstWhere(
      (facility) => facility.id == facilityId,
      orElse: () => facilities.first,
    );
  }

  // Get available operations for a facility
  static List<PrisonOperation> getAvailableOperations(PrisonFacility facility) {
    final allOperations = getPrisonOperations();
    // Filter operations based on facility security level
    return allOperations.where((operation) {
      final minSecurity = operation.requirements['minSecurityLevel'] as String?;
      if (minSecurity == null) return true;
      
      switch (facility.securityLevel) {
        case 'Minimum':
          return ['Minimum'].contains(minSecurity);
        case 'Medium':
          return ['Minimum', 'Medium'].contains(minSecurity);
        case 'Maximum':
          return ['Minimum', 'Medium', 'Maximum'].contains(minSecurity);
        case 'Super Maximum':
          return true; // Can do any operation
        default:
          return true;
      }
    }).toList();
  }

  // Get active operations from prison data
  static List<PrisonOperation> getActiveOperations(Map<String, dynamic> prisonData) {
    final activeOpIds = (prisonData['activeOperations'] as List<dynamic>?) ?? [];
    final allOperations = getPrisonOperations();
    
    return allOperations.where((operation) => 
      activeOpIds.contains(operation.id)
    ).toList();
  }
}
