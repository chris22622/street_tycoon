import 'dart:math';

class Contact {
  final String id;
  final String name;
  final String type; // dealer, enforcer, informant, corrupt_official, money_launderer
  final String location;
  final int trustLevel; // 0-100
  final int skillLevel; // 0-100
  final Map<String, int> services; // service_type: price
  final bool isCompromised;
  final DateTime lastContact;
  final String phoneNumber;
  final Map<String, dynamic> specialties;

  const Contact({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    required this.trustLevel,
    required this.skillLevel,
    required this.services,
    required this.isCompromised,
    required this.lastContact,
    required this.phoneNumber,
    required this.specialties,
  });

  Contact copyWith({
    String? id,
    String? name,
    String? type,
    String? location,
    int? trustLevel,
    int? skillLevel,
    Map<String, int>? services,
    bool? isCompromised,
    DateTime? lastContact,
    String? phoneNumber,
    Map<String, dynamic>? specialties,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      location: location ?? this.location,
      trustLevel: trustLevel ?? this.trustLevel,
      skillLevel: skillLevel ?? this.skillLevel,
      services: services ?? this.services,
      isCompromised: isCompromised ?? this.isCompromised,
      lastContact: lastContact ?? this.lastContact,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      specialties: specialties ?? this.specialties,
    );
  }
}

class Intelligence {
  final String id;
  final String type; // police_raid, gang_movement, market_change, opportunity
  final String title;
  final String description;
  final int reliability; // 0-100
  final int urgency; // 0-100 (how time-sensitive)
  final DateTime timeReceived;
  final DateTime? expiresAt;
  final String source; // contact_id or 'surveillance'
  final Map<String, dynamic> actionableData;
  final bool isRead;

  const Intelligence({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.reliability,
    required this.urgency,
    required this.timeReceived,
    this.expiresAt,
    required this.source,
    required this.actionableData,
    required this.isRead,
  });

  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);
  
  Intelligence copyWith({
    String? id,
    String? type,
    String? title,
    String? description,
    int? reliability,
    int? urgency,
    DateTime? timeReceived,
    DateTime? expiresAt,
    String? source,
    Map<String, dynamic>? actionableData,
    bool? isRead,
  }) {
    return Intelligence(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      reliability: reliability ?? this.reliability,
      urgency: urgency ?? this.urgency,
      timeReceived: timeReceived ?? this.timeReceived,
      expiresAt: expiresAt ?? this.expiresAt,
      source: source ?? this.source,
      actionableData: actionableData ?? this.actionableData,
      isRead: isRead ?? this.isRead,
    );
  }
}

class Surveillance {
  final String id;
  final String target; // area, person, or operation
  final String type; // electronic, physical, informant
  final int duration; // days
  final int cost;
  final Map<String, dynamic> equipment;
  final DateTime startDate;
  final int effectiveness; // 0-100
  final bool isActive;

  const Surveillance({
    required this.id,
    required this.target,
    required this.type,
    required this.duration,
    required this.cost,
    required this.equipment,
    required this.startDate,
    required this.effectiveness,
    required this.isActive,
  });

  bool get isExpired => DateTime.now().difference(startDate).inDays >= duration;
  
  Surveillance copyWith({
    String? id,
    String? target,
    String? type,
    int? duration,
    int? cost,
    Map<String, dynamic>? equipment,
    DateTime? startDate,
    int? effectiveness,
    bool? isActive,
  }) {
    return Surveillance(
      id: id ?? this.id,
      target: target ?? this.target,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      cost: cost ?? this.cost,
      equipment: equipment ?? this.equipment,
      startDate: startDate ?? this.startDate,
      effectiveness: effectiveness ?? this.effectiveness,
      isActive: isActive ?? this.isActive,
    );
  }
}

class CrimeNetworkService {
  static final Random _random = Random();

  // Generate initial contacts network
  static List<Contact> generateInitialContacts() {
    return [
      // Street Dealers
      Contact(
        id: 'dealer_1',
        name: 'Lil Mike',
        type: 'dealer',
        location: 'Downtown',
        trustLevel: 65,
        skillLevel: 50,
        services: {'drug_sales': 100, 'street_info': 50},
        isCompromised: false,
        lastContact: DateTime.now().subtract(const Duration(days: 2)),
        phoneNumber: '555-0101',
        specialties: {'drug_types': ['weed', 'cocaine'], 'territory': 'south_side'},
      ),
      
      Contact(
        id: 'dealer_2',
        name: 'Big Tony',
        type: 'dealer',
        location: 'Industrial District',
        trustLevel: 80,
        skillLevel: 75,
        services: {'drug_sales': 200, 'muscle': 150, 'transport': 100},
        isCompromised: false,
        lastContact: DateTime.now().subtract(const Duration(days: 1)),
        phoneNumber: '555-0102',
        specialties: {'drug_types': ['heroin', 'meth'], 'connections': 'italian_mob'},
      ),

      // Informants
      Contact(
        id: 'informant_1',
        name: 'Snitchy Pete',
        type: 'informant',
        location: 'Police Station',
        trustLevel: 40, // Low trust because he's a snitch
        skillLevel: 85, // But good intel
        services: {'police_intel': 500, 'raid_warnings': 1000},
        isCompromised: false,
        lastContact: DateTime.now().subtract(const Duration(days: 5)),
        phoneNumber: '555-0201',
        specialties: {'access_level': 'desk_sergeant', 'departments': ['narcotics', 'vice']},
      ),

      // Corrupt Officials
      Contact(
        id: 'corrupt_1',
        name: 'Detective Rodriguez',
        type: 'corrupt_official',
        location: 'Central Precinct',
        trustLevel: 75,
        skillLevel: 90,
        services: {'case_dismissal': 5000, 'evidence_tampering': 10000, 'protection': 2000},
        isCompromised: false,
        lastContact: DateTime.now().subtract(const Duration(days: 7)),
        phoneNumber: '555-0301',
        specialties: {'rank': 'detective', 'department': 'narcotics', 'influence': 'medium'},
      ),

      // Money Launderers
      Contact(
        id: 'launderer_1',
        name: 'Clean Eddie',
        type: 'money_launderer',
        location: 'Financial District',
        trustLevel: 85,
        skillLevel: 95,
        services: {'money_cleaning': 100, 'offshore_accounts': 500, 'crypto_washing': 200}, // Per $1000
        isCompromised: false,
        lastContact: DateTime.now().subtract(const Duration(days: 3)),
        phoneNumber: '555-0401',
        specialties: {'methods': ['casinos', 'real_estate', 'crypto'], 'capacity': 500000},
      ),

      // Enforcers
      Contact(
        id: 'enforcer_1',
        name: 'Brass Knuckles Bill',
        type: 'enforcer',
        location: 'Warehouse District',
        trustLevel: 70,
        skillLevel: 80,
        services: {'intimidation': 500, 'debt_collection': 1000, 'elimination': 10000},
        isCompromised: false,
        lastContact: DateTime.now().subtract(const Duration(days: 4)),
        phoneNumber: '555-0501',
        specialties: {'weapons': ['melee', 'handguns'], 'methods': ['intimidation', 'violence']},
      ),
    ];
  }

  // Build trust with a contact
  static Contact buildTrust(Contact contact, int trustIncrease) {
    final newTrustLevel = (contact.trustLevel + trustIncrease).clamp(0, 100);
    return contact.copyWith(
      trustLevel: newTrustLevel,
      lastContact: DateTime.now(),
    );
  }

  // Contact becomes compromised
  static Contact compromiseContact(Contact contact) {
    return contact.copyWith(isCompromised: true);
  }

  // Generate intelligence from contacts
  static Intelligence? generateIntelligence(List<Contact> contacts) {
    if (_random.nextDouble() > 0.4) return null; // 40% chance
    
    final availableContacts = contacts.where((c) => !c.isCompromised).toList();
    if (availableContacts.isEmpty) return null;
    
    final source = availableContacts[_random.nextInt(availableContacts.length)];
    final reliability = (source.trustLevel + source.skillLevel) ~/ 2;
    
    final intelTypes = [
      'police_raid',
      'gang_movement',
      'market_opportunity',
      'rival_weakness',
      'federal_investigation',
      'territory_change',
    ];
    
    final intelType = intelTypes[_random.nextInt(intelTypes.length)];
    
    switch (intelType) {
      case 'police_raid':
        return Intelligence(
          id: 'intel_${DateTime.now().millisecondsSinceEpoch}',
          type: 'police_raid',
          title: '🚨 Upcoming Police Raid',
          description: 'Police planning raid on ${_getRandomLocation()} in next 24-48 hours.',
          reliability: reliability,
          urgency: 90,
          timeReceived: DateTime.now(),
          expiresAt: DateTime.now().add(const Duration(hours: 48)),
          source: source.id,
          actionableData: {
            'location': _getRandomLocation(),
            'raid_time': '2-4 AM',
            'officers_involved': _random.nextInt(20) + 10,
            'departments': ['narcotics', 'swat'],
          },
          isRead: false,
        );
        
      case 'gang_movement':
        return Intelligence(
          id: 'intel_${DateTime.now().millisecondsSinceEpoch}',
          type: 'gang_movement',
          title: '👥 Gang Territory Shift',
          description: 'Rival gang making moves on ${_getRandomLocation()}. Opportunity or threat.',
          reliability: reliability,
          urgency: 70,
          timeReceived: DateTime.now(),
          expiresAt: DateTime.now().add(const Duration(days: 3)),
          source: source.id,
          actionableData: {
            'gang_name': _getRandomGangName(),
            'territory': _getRandomLocation(),
            'strength': _random.nextInt(50) + 25,
            'intentions': ['takeover', 'expansion', 'retaliation'][_random.nextInt(3)],
          },
          isRead: false,
        );
        
      case 'market_opportunity':
        return Intelligence(
          id: 'intel_${DateTime.now().millisecondsSinceEpoch}',
          type: 'market_opportunity',
          title: '💰 Market Opportunity',
          description: 'High demand for drugs in ${_getRandomLocation()}. Prices up 200%.',
          reliability: reliability,
          urgency: 60,
          timeReceived: DateTime.now(),
          expiresAt: DateTime.now().add(const Duration(days: 7)),
          source: source.id,
          actionableData: {
            'location': _getRandomLocation(),
            'drug_type': ['cocaine', 'heroin', 'meth', 'fentanyl'][_random.nextInt(4)],
            'price_multiplier': 2.0 + (_random.nextDouble() * 1.0),
            'duration_days': _random.nextInt(10) + 3,
          },
          isRead: false,
        );
        
      default:
        return Intelligence(
          id: 'intel_${DateTime.now().millisecondsSinceEpoch}',
          type: intelType,
          title: '📊 Street Intelligence',
          description: 'General intelligence about criminal activities in the area.',
          reliability: reliability,
          urgency: 40,
          timeReceived: DateTime.now(),
          expiresAt: DateTime.now().add(const Duration(days: 5)),
          source: source.id,
          actionableData: {},
          isRead: false,
        );
    }
  }

  // Set up surveillance operation
  static Surveillance createSurveillance(
    String target,
    String type,
    int duration,
    Map<String, dynamic> equipment,
  ) {
    int baseCost = 1000;
    int effectiveness = 50;
    
    // Type affects cost and effectiveness
    switch (type) {
      case 'electronic':
        baseCost = 5000;
        effectiveness = 80;
        break;
      case 'physical':
        baseCost = 2000;
        effectiveness = 70;
        break;
      case 'informant':
        baseCost = 500;
        effectiveness = 60;
        break;
    }
    
    // Equipment affects effectiveness and cost
    if (equipment['cameras'] == true) {
      baseCost += 2000;
      effectiveness += 15;
    }
    if (equipment['wiretaps'] == true) {
      baseCost += 3000;
      effectiveness += 20;
    }
    if (equipment['gps_tracking'] == true) {
      baseCost += 1500;
      effectiveness += 10;
    }
    
    final totalCost = (baseCost * duration).toInt();
    
    return Surveillance(
      id: 'surveillance_${DateTime.now().millisecondsSinceEpoch}',
      target: target,
      type: type,
      duration: duration,
      cost: totalCost,
      equipment: equipment,
      startDate: DateTime.now(),
      effectiveness: effectiveness.clamp(20, 95),
      isActive: true,
    );
  }

  // Get surveillance results
  static List<Intelligence> getSurveillanceResults(Surveillance surveillance) {
    if (!surveillance.isActive || surveillance.isExpired) return [];
    
    final results = <Intelligence>[];
    final numResults = (surveillance.effectiveness / 20).floor(); // 1-4 results based on effectiveness
    
    for (int i = 0; i < numResults; i++) {
      final intel = Intelligence(
        id: 'surveillance_intel_${DateTime.now().millisecondsSinceEpoch}_$i',
        type: 'surveillance_result',
        title: '📷 Surveillance Intel',
        description: 'Intelligence gathered from surveillance of ${surveillance.target}',
        reliability: surveillance.effectiveness,
        urgency: 50,
        timeReceived: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(days: 14)),
        source: 'surveillance',
        actionableData: {
          'target': surveillance.target,
          'surveillance_type': surveillance.type,
          'findings': _generateSurveillanceFindings(surveillance.target),
        },
        isRead: false,
      );
      results.add(intel);
    }
    
    return results;
  }

  // Find new contacts through existing network
  static Contact? findNewContact(List<Contact> existingContacts, String desiredType) {
    final referrer = existingContacts.where((c) => c.trustLevel > 70 && !c.isCompromised).toList();
    if (referrer.isEmpty) return null;
    
    final contactTypes = {
      'dealer': ['Street Dealer', 'Supply Connect', 'Corner Boy'],
      'informant': ['Inside Source', 'Leak', 'Mole'],
      'corrupt_official': ['Dirty Cop', 'Bought Judge', 'Paid Official'],
      'money_launderer': ['Cleaner', 'Washer', 'Offshore Handler'],
      'enforcer': ['Muscle', 'Hitman', 'Enforcer'],
    };
    
    final names = [
      'Quick', 'Smooth', 'Sharp', 'Cold', 'Fast', 'Silent', 'Heavy', 'Slick',
      'Tommy', 'Johnny', 'Rico', 'Vince', 'Marco', 'Eddie', 'Paulie', 'Sal'
    ];
    
    final locations = [
      'Downtown', 'Uptown', 'East Side', 'West Side', 'Industrial', 'Waterfront',
      'Financial District', 'Suburbs', 'Airport Area', 'Port District'
    ];
    
    return Contact(
      id: 'contact_${DateTime.now().millisecondsSinceEpoch}',
      name: '${names[_random.nextInt(names.length)]} ${contactTypes[desiredType]![_random.nextInt(contactTypes[desiredType]!.length)]}',
      type: desiredType,
      location: locations[_random.nextInt(locations.length)],
      trustLevel: _random.nextInt(30) + 40, // 40-70 starting trust
      skillLevel: _random.nextInt(40) + 50, // 50-90 skill
      services: _generateContactServices(desiredType),
      isCompromised: false,
      lastContact: DateTime.now(),
      phoneNumber: '555-${_random.nextInt(9000) + 1000}',
      specialties: _generateContactSpecialties(desiredType),
    );
  }

  // Helper functions
  static String _getRandomLocation() {
    final locations = [
      'Downtown District', 'East Side Projects', 'West End', 'Harbor Area',
      'Industrial Zone', 'Uptown', 'Financial District', 'Airport Road',
      'Riverside', 'Hillside', 'Old Town', 'New Development'
    ];
    return locations[_random.nextInt(locations.length)];
  }
  
  static String _getRandomGangName() {
    final gangs = [
      'Blood Brothers', 'Iron Wolves', 'Street Kings', 'Shadow Crew',
      'Night Riders', 'Urban Warriors', 'Concrete Jungle', 'City Serpents'
    ];
    return gangs[_random.nextInt(gangs.length)];
  }
  
  static Map<String, int> _generateContactServices(String type) {
    switch (type) {
      case 'dealer':
        return {'drug_sales': 100 + _random.nextInt(200), 'street_info': 50 + _random.nextInt(100)};
      case 'informant':
        return {'police_intel': 500 + _random.nextInt(1000), 'raid_warnings': 1000 + _random.nextInt(1500)};
      case 'corrupt_official':
        return {'protection': 2000 + _random.nextInt(3000), 'case_dismissal': 5000 + _random.nextInt(10000)};
      case 'money_launderer':
        return {'money_cleaning': 100 + _random.nextInt(200), 'offshore_accounts': 500 + _random.nextInt(1000)};
      case 'enforcer':
        return {'intimidation': 500 + _random.nextInt(1000), 'debt_collection': 1000 + _random.nextInt(2000)};
      default:
        return {};
    }
  }
  
  static Map<String, dynamic> _generateContactSpecialties(String type) {
    switch (type) {
      case 'dealer':
        return {
          'drug_types': ['weed', 'cocaine', 'heroin', 'meth']..shuffle(),
          'territory': _getRandomLocation(),
        };
      case 'informant':
        return {
          'access_level': ['patrol', 'desk_sergeant', 'detective', 'lieutenant'][_random.nextInt(4)],
          'departments': ['narcotics', 'vice', 'gang_unit', 'patrol']..shuffle(),
        };
      default:
        return {};
    }
  }
  
  static Map<String, dynamic> _generateSurveillanceFindings(String target) {
    return {
      'activity_level': _random.nextInt(100),
      'patterns': ['High activity 2-4 AM', 'Multiple vehicles daily', 'Frequent visitors'],
      'vulnerabilities': ['Poor security', 'Predictable schedule', 'Limited escape routes'],
      'opportunities': ['Supply delivery Tuesdays', 'Light security weekends', 'Money transport Fridays'],
    };
  }

  // Contact management
  static Map<String, dynamic> useContactService(
    Contact contact,
    String service,
    Map<String, dynamic> parameters,
  ) {
    if (contact.isCompromised) {
      return {
        'success': false,
        'message': '🚨 Contact is compromised! Cannot use their services.',
        'heat_increase': 25,
      };
    }
    
    if (!contact.services.containsKey(service)) {
      return {
        'success': false,
        'message': 'Contact does not offer this service.',
        'heat_increase': 0,
      };
    }
    
    final serviceCost = contact.services[service]!;
    final successChance = (contact.trustLevel + contact.skillLevel) / 200.0;
    
    if (_random.nextDouble() < successChance) {
      return {
        'success': true,
        'message': '✅ Service completed successfully.',
        'cost': serviceCost,
        'trust_change': _random.nextInt(5) + 1,
        'results': _getServiceResults(service, parameters),
      };
    } else {
      return {
        'success': false,
        'message': '❌ Service failed. Contact may be unreliable.',
        'cost': serviceCost ~/ 2, // Half cost for failed service
        'trust_change': -(_random.nextInt(10) + 5),
        'heat_increase': _random.nextInt(20) + 10,
      };
    }
  }
  
  static Map<String, dynamic> _getServiceResults(String service, Map<String, dynamic> parameters) {
    switch (service) {
      case 'drug_sales':
        return {
          'units_sold': parameters['quantity'] ?? 0,
          'profit': (parameters['quantity'] ?? 0) * 100,
        };
      case 'police_intel':
        return {
          'intel_received': generateIntelligence([])?.toMap() ?? {},
        };
      default:
        return {};
    }
  }
}

// Extension to convert Intelligence to Map for storage
extension IntelligenceExtension on Intelligence {
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'description': description,
      'reliability': reliability,
      'urgency': urgency,
      'timeReceived': timeReceived.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'source': source,
      'actionableData': actionableData,
      'isRead': isRead,
    };
  }
}
