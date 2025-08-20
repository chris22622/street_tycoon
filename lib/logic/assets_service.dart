import 'dart:math';

class Vehicle {
  final String id;
  final String name;
  final String category;
  final String icon;
  final int price;
  final int speed;
  final int armor;
  final int capacity;
  final int stealth;
  final bool isStolen;
  final Map<String, dynamic> features;
  final String description;

  const Vehicle({
    required this.id,
    required this.name,
    required this.category,
    required this.icon,
    required this.price,
    required this.speed,
    required this.armor,
    required this.capacity,
    required this.stealth,
    required this.isStolen,
    required this.features,
    required this.description,
  });

  // Combat effectiveness for drive-bys
  int get combatEffectiveness => (speed + armor) ~/ 2;
  // Escape capability
  int get escapeRating => (speed + stealth) ~/ 2;
}

class Property {
  final String id;
  final String name;
  final String type;
  final String location;
  final String state;
  final String icon;
  final int price;
  final int monthlyIncome;
  final int capacity;
  final int securityLevel;
  final Map<String, dynamic> features;
  final List<String> operations;
  final String description;

  const Property({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    required this.state,
    required this.icon,
    required this.price,
    required this.monthlyIncome,
    required this.capacity,
    required this.securityLevel,
    required this.features,
    required this.operations,
    required this.description,
  });

  // Money laundering capacity
  int get launderingCapacity => monthlyIncome * 2;
  // Storage for drugs/weapons
  int get storageCapacity => capacity;
}

class LuxuryItem {
  final String id;
  final String name;
  final String category;
  final String icon;
  final int price;
  final int prestigeValue;
  final Map<String, dynamic> effects;
  final String description;

  const LuxuryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.icon,
    required this.price,
    required this.prestigeValue,
    required this.effects,
    required this.description,
  });
}

class AssetsService {
  static final Random _random = Random();

  // Available vehicles for purchase
  static List<Vehicle> getAvailableVehicles() {
    return [
      // Starter Cars
      const Vehicle(
        id: 'honda_civic',
        name: 'Honda Civic',
        category: 'Economy',
        icon: '🚗',
        price: 15000,
        speed: 60,
        armor: 20,
        capacity: 4,
        stealth: 80,
        isStolen: false,
        features: {'fuel_efficient': true, 'common': true},
        description: 'Reliable and inconspicuous. Perfect for low-key operations.',
      ),
      
      const Vehicle(
        id: 'toyota_camry',
        name: 'Toyota Camry',
        category: 'Sedan',
        icon: '🚙',
        price: 25000,
        speed: 65,
        armor: 25,
        capacity: 5,
        stealth: 85,
        isStolen: false,
        features: {'reliable': true, 'family_car': true},
        description: 'Blends in anywhere. Family car exterior, criminal interior.',
      ),
      
      // Sports Cars
      const Vehicle(
        id: 'mustang_gt',
        name: 'Ford Mustang GT',
        category: 'Sports',
        icon: '🏎️',
        price: 45000,
        speed: 85,
        armor: 40,
        capacity: 2,
        stealth: 40,
        isStolen: false,
        features: {'fast_acceleration': true, 'loud': true},
        description: 'Fast and loud. Great for getaways, terrible for stealth.',
      ),
      
      const Vehicle(
        id: 'bmw_m3',
        name: 'BMW M3',
        category: 'Luxury Sports',
        icon: '🚗',
        price: 70000,
        speed: 90,
        armor: 45,
        capacity: 4,
        stealth: 50,
        isStolen: false,
        features: {'luxury': true, 'performance': true},
        description: 'Status symbol with serious speed. Attracts attention.',
      ),
      
      // SUVs
      const Vehicle(
        id: 'escalade',
        name: 'Cadillac Escalade',
        category: 'Luxury SUV',
        icon: '🚛',
        price: 85000,
        speed: 70,
        armor: 80,
        capacity: 8,
        stealth: 30,
        isStolen: false,
        features: {'intimidating': true, 'bulletproof_option': true, 'crew_transport': true},
        description: 'Moves the whole crew in style. Bulletproof options available.',
      ),
      
      const Vehicle(
        id: 'suburban',
        name: 'Chevrolet Suburban',
        category: 'SUV',
        icon: '🚐',
        price: 55000,
        speed: 65,
        armor: 60,
        capacity: 9,
        stealth: 60,
        isStolen: false,
        features: {'large_capacity': true, 'family_vehicle': true},
        description: 'Perfect for moving crew and equipment. Looks innocent.',
      ),
      
      // Motorcycles
      const Vehicle(
        id: 'hayabusa',
        name: 'Suzuki Hayabusa',
        category: 'Motorcycle',
        icon: '🏍️',
        price: 20000,
        speed: 95,
        armor: 10,
        capacity: 1,
        stealth: 70,
        isStolen: false,
        features: {'extreme_speed': true, 'lane_splitting': true},
        description: 'Fastest escape vehicle. One rider only, maximum speed.',
      ),
      
      // Armored Vehicles
      const Vehicle(
        id: 'armored_truck',
        name: 'Armored Cash Truck',
        category: 'Armored',
        icon: '🚚',
        price: 150000,
        speed: 45,
        armor: 95,
        capacity: 6,
        stealth: 10,
        isStolen: true, // Only available stolen
        features: {'bulletproof': true, 'vault': true, 'police_attention': true},
        description: 'Mobile fortress. Extremely conspicuous but nearly invincible.',
      ),
      
      // Exotic Cars
      const Vehicle(
        id: 'lamborghini',
        name: 'Lamborghini Aventador',
        category: 'Supercar',
        icon: '🏎️',
        price: 400000,
        speed: 98,
        armor: 30,
        capacity: 2,
        stealth: 5,
        isStolen: false,
        features: {'ultra_luxury': true, 'extreme_attention': true, 'status_symbol': true},
        description: 'The ultimate flex. Everyone will know you\'ve made it.',
      ),
    ];
  }

  // Available properties
  static List<Property> getAvailableProperties() {
    return [
      // Safe Houses
      const Property(
        id: 'apartment_1',
        name: 'Downtown Apartment',
        type: 'Safe House',
        location: 'Downtown',
        state: 'California',
        icon: '🏠',
        price: 80000,
        monthlyIncome: 0,
        capacity: 50,
        securityLevel: 30,
        features: {'low_profile': true, 'city_access': true},
        operations: ['stash_house', 'meeting_point'],
        description: 'Inconspicuous apartment for laying low and storing product.',
      ),
      
      const Property(
        id: 'warehouse_1',
        name: 'Industrial Warehouse',
        type: 'Storage',
        location: 'Industrial District',
        state: 'California',
        icon: '🏭',
        price: 200000,
        monthlyIncome: 0,
        capacity: 500,
        securityLevel: 60,
        features: {'large_capacity': true, 'vehicle_access': true},
        operations: ['drug_lab', 'weapons_cache', 'chop_shop'],
        description: 'Massive storage space. Perfect for major operations.',
      ),
      
      // Legitimate Businesses (Money Laundering)
      const Property(
        id: 'car_wash',
        name: 'Sunset Car Wash',
        type: 'Business',
        location: 'Suburbs',
        state: 'California',
        icon: '🚿',
        price: 150000,
        monthlyIncome: 8000,
        capacity: 20,
        securityLevel: 40,
        features: {'money_laundering': true, 'legitimate': true},
        operations: ['money_laundering', 'front_business'],
        description: 'Perfect front business. Clean money, dirty secrets.',
      ),
      
      const Property(
        id: 'restaurant',
        name: 'Tony\'s Pizza',
        type: 'Restaurant',
        location: 'Little Italy',
        state: 'New York',
        icon: '🍕',
        price: 300000,
        monthlyIncome: 15000,
        capacity: 30,
        securityLevel: 50,
        features: {'money_laundering': true, 'meeting_place': true},
        operations: ['money_laundering', 'meetings', 'front_business'],
        description: 'Classic mob restaurant. Great for meetings and laundering.',
      ),
      
      const Property(
        id: 'strip_club',
        name: 'Diamond Dolls',
        type: 'Entertainment',
        location: 'Red Light District',
        state: 'Nevada',
        icon: '💃',
        price: 500000,
        monthlyIncome: 25000,
        capacity: 40,
        securityLevel: 70,
        features: {'high_income': true, 'party_spot': true, 'vip_access': true},
        operations: ['money_laundering', 'prostitution', 'drug_sales', 'meetings'],
        description: 'High-end strip club. Money flows like water here.',
      ),
      
      // Luxury Properties
      const Property(
        id: 'penthouse',
        name: 'Downtown Penthouse',
        type: 'Luxury Residence',
        location: 'Downtown High-Rise',
        state: 'California',
        icon: '🏢',
        price: 2000000,
        monthlyIncome: 0,
        capacity: 100,
        securityLevel: 90,
        features: {'ultimate_luxury': true, 'panoramic_views': true, 'prestige': true},
        operations: ['headquarters', 'luxury_meetings', 'safe_house'],
        description: 'The ultimate criminal headquarters. Sky-high luxury.',
      ),
      
      const Property(
        id: 'mansion',
        name: 'Beverly Hills Mansion',
        type: 'Mansion',
        location: 'Beverly Hills',
        state: 'California',
        icon: '🏰',
        price: 5000000,
        monthlyIncome: 0,
        capacity: 200,
        securityLevel: 95,
        features: {'ultimate_prestige': true, 'private_security': true, 'entertainment': true},
        operations: ['headquarters', 'parties', 'meetings', 'safe_house'],
        description: 'Criminal empire headquarters. The pinnacle of success.',
      ),
      
      // Specialized Properties
      const Property(
        id: 'nightclub',
        name: 'Club Inferno',
        type: 'Nightclub',
        location: 'Entertainment District',
        state: 'Florida',
        icon: '🎭',
        price: 750000,
        monthlyIncome: 30000,
        capacity: 60,
        securityLevel: 60,
        features: {'party_central': true, 'drug_sales_hub': true, 'networking': true},
        operations: ['drug_sales', 'money_laundering', 'networking', 'parties'],
        description: 'Where the party never stops and the money never sleeps.',
      ),
      
      const Property(
        id: 'gun_shop',
        name: 'Patriot Arms',
        type: 'Gun Store',
        location: 'Industrial',
        state: 'Texas',
        icon: '🔫',
        price: 400000,
        monthlyIncome: 12000,
        capacity: 80,
        securityLevel: 80,
        features: {'weapons_access': true, 'legal_front': true},
        operations: ['weapons_dealing', 'front_business'],
        description: 'Legal gun store with illegal backroom deals.',
      ),
    ];
  }

  // Available luxury items
  static List<LuxuryItem> getLuxuryItems() {
    return [
      // Jewelry
      const LuxuryItem(
        id: 'diamond_chain',
        name: 'Diamond Chain',
        category: 'Jewelry',
        icon: '💎',
        price: 50000,
        prestigeValue: 25,
        effects: {'intimidation': 10, 'recruitment_bonus': 5},
        description: 'Iced out chain that commands respect on the streets.',
      ),
      
      const LuxuryItem(
        id: 'rolex_watch',
        name: 'Rolex Submariner',
        category: 'Watches',
        icon: '⌚',
        price: 15000,
        prestigeValue: 15,
        effects: {'prestige': 10, 'business_meetings': 5},
        description: 'Timeless luxury that opens doors.',
      ),
      
      const LuxuryItem(
        id: 'gold_grill',
        name: 'Gold Grill',
        category: 'Jewelry',
        icon: '🦷',
        price: 25000,
        prestigeValue: 20,
        effects: {'street_cred': 15, 'intimidation': 5},
        description: 'Show everyone you\'ve got money to burn.',
      ),
      
      // Electronics
      const LuxuryItem(
        id: 'custom_phone',
        name: 'Encrypted Smartphone',
        category: 'Electronics',
        icon: '📱',
        price: 10000,
        prestigeValue: 5,
        effects: {'security': 20, 'communication': 15},
        description: 'Military-grade encryption for sensitive communications.',
      ),
      
      // Fashion
      const LuxuryItem(
        id: 'designer_suit',
        name: 'Armani Suit',
        category: 'Clothing',
        icon: '🤵',
        price: 8000,
        prestigeValue: 12,
        effects: {'business_meetings': 10, 'court_appearance': 15},
        description: 'Look professional even when you\'re not.',
      ),
      
      const LuxuryItem(
        id: 'designer_shoes',
        name: 'Louboutin Shoes',
        category: 'Footwear',
        icon: '👠',
        price: 1500,
        prestigeValue: 8,
        effects: {'style': 10},
        description: 'Red bottoms that show you\'ve made it.',
      ),
      
      // Art & Collectibles
      const LuxuryItem(
        id: 'painting',
        name: 'Stolen Picasso',
        category: 'Art',
        icon: '🖼️',
        price: 2000000,
        prestigeValue: 100,
        effects: {'prestige': 50, 'laundering_tool': true},
        description: 'Priceless art with a questionable past.',
      ),
    ];
  }

  // Calculate vehicle theft difficulty
  static double calculateTheftDifficulty(Vehicle vehicle, Map<String, dynamic> playerStats) {
    double baseDifficulty = 0.3;
    
    // Vehicle factors
    baseDifficulty += (vehicle.price / 100000) * 0.2; // More expensive = harder
    baseDifficulty += (100 - vehicle.stealth) / 100 * 0.3; // Less stealthy = harder
    
    // Player skill factors
    final playerSkill = (playerStats['theft_skill'] ?? 0) / 100.0;
    baseDifficulty -= playerSkill * 0.4;
    
    // Equipment bonuses
    final hasTools = playerStats['has_theft_tools'] ?? false;
    if (hasTools) baseDifficulty -= 0.2;
    
    return baseDifficulty.clamp(0.1, 0.9);
  }

  // Execute vehicle theft
  static Map<String, dynamic> executeVehicleTheft(Vehicle vehicle, Map<String, dynamic> playerStats) {
    final difficulty = calculateTheftDifficulty(vehicle, playerStats);
    final success = _random.nextDouble() > difficulty;
    
    Map<String, dynamic> result = {
      'success': success,
      'vehicle_stolen': success,
      'heat_increase': 0,
      'police_chase': false,
      'time_taken': 0,
      'message': '',
    };
    
    if (success) {
      result['heat_increase'] = _random.nextInt(20) + 10; // 10-30 heat
      result['police_chase'] = _random.nextDouble() < 0.3; // 30% chance
      result['time_taken'] = _random.nextInt(10) + 5; // 5-15 minutes
      result['message'] = '🚗 Successfully stole ${vehicle.name}! Time to move fast.';
      
      if (result['police_chase']) {
        result['message'] += ' Police are in pursuit!';
        result['heat_increase'] += 20;
      }
    } else {
      result['heat_increase'] = _random.nextInt(30) + 20; // 20-50 heat
      result['police_alerted'] = true;
      result['arrest_chance'] = _random.nextDouble() < 0.4; // 40% arrest chance
      result['message'] = '🚨 Vehicle theft failed! Alarm triggered, police responding.';
      
      if (result['arrest_chance']) {
        result['arrested'] = true;
        result['message'] += ' You\'ve been arrested!';
      }
    }
    
    return result;
  }

  // Calculate property income with criminal operations
  static int calculatePropertyIncome(Property property, Map<String, dynamic> operations) {
    int baseIncome = property.monthlyIncome;
    int criminalIncome = 0;
    
    // Add criminal operation income
    for (String operation in property.operations) {
      switch (operation) {
        case 'drug_sales':
          criminalIncome += (((operations['drug_volume'] ?? 0) as num) * 50).toInt();
          break;
        case 'money_laundering':
          criminalIncome += (((operations['dirty_money'] ?? 0) as num) ~/ 10); // 10% laundering fee
          break;
        case 'prostitution':
          criminalIncome += (((operations['girls'] ?? 0) as num) * 500).toInt();
          break;
        case 'weapons_dealing':
          criminalIncome += (((operations['weapons_sold'] ?? 0) as num) * 200).toInt();
          break;
      }
    }
    
    return baseIncome + criminalIncome;
  }

  // Generate property-based events
  static Map<String, dynamic>? generatePropertyEvent(Property property) {
    if (_random.nextDouble() > 0.2) return null; // 20% chance
    
    final events = [
      'police_raid',
      'rival_attack',
      'customer_complaint',
      'equipment_malfunction',
      'opportunity',
      'inspection',
    ];
    
    final eventType = events[_random.nextInt(events.length)];
    
    switch (eventType) {
      case 'police_raid':
        return {
          'type': 'police_raid',
          'title': '🚔 Police Raid!',
          'message': 'Police are raiding ${property.name}! They\'re looking for evidence.',
          'property': property.id,
          'evidence_risk': _random.nextInt(50) + 20,
          'options': [
            {'text': 'Destroy Evidence', 'action': 'destroy_evidence', 'cost': 10000},
            {'text': 'Bribe Officers', 'action': 'bribe', 'cost': 25000},
            {'text': 'Take the Heat', 'action': 'accept', 'cost': 0},
          ],
        };
        
      case 'rival_attack':
        return {
          'type': 'rival_property_attack',
          'title': '⚔️ Property Under Attack!',
          'message': 'Rival gang is hitting ${property.name}! They\'re trying to damage your operations.',
          'property': property.id,
          'damage_risk': _random.nextInt(30) + 20,
          'options': [
            {'text': 'Defend Property', 'action': 'defend', 'cost': 5000},
            {'text': 'Hire Security', 'action': 'security', 'cost': 15000},
            {'text': 'Abandon for Now', 'action': 'abandon', 'cost': 0},
          ],
        };
        
      case 'opportunity':
        return {
          'type': 'property_opportunity',
          'title': '💰 Business Opportunity',
          'message': 'High-value client wants to use ${property.name} for a major operation. Big money, big risk.',
          'property': property.id,
          'potential_income': _random.nextInt(50000) + 20000,
          'heat_risk': _random.nextInt(30) + 10,
          'options': [
            {'text': 'Take the Deal', 'action': 'accept_deal', 'cost': 0},
            {'text': 'Negotiate Terms', 'action': 'negotiate', 'cost': 2000},
            {'text': 'Decline', 'action': 'decline', 'cost': 0},
          ],
        };
    }
    
    return null;
  }
}
