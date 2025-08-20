import 'dart:math';
import 'assets_service.dart';
import 'gang_war_service.dart';

class State {
  final String id;
  final String name;
  final String abbreviation;
  final String icon;
  final Map<String, int> lawEnforcementStrength;
  final Map<String, double> drugPrices; // Price multipliers
  final List<String> majorCities;
  final Map<String, dynamic> features;
  final int travelCost;
  final int operationalDifficulty; // 1-100

  const State({
    required this.id,
    required this.name,
    required this.abbreviation,
    required this.icon,
    required this.lawEnforcementStrength,
    required this.drugPrices,
    required this.majorCities,
    required this.features,
    required this.travelCost,
    required this.operationalDifficulty,
  });
}

class InterstateRoute {
  final String id;
  final String fromState;
  final String toState;
  final int distance; // Miles
  final int travelTime; // Hours
  final int riskLevel; // 1-100
  final Map<String, dynamic> checkpoints;
  final List<String> hazards;

  const InterstateRoute({
    required this.id,
    required this.fromState,
    required this.toState,
    required this.distance,
    required this.travelTime,
    required this.riskLevel,
    required this.checkpoints,
    required this.hazards,
  });
}

class InterstateOperationsService {
  static final Random _random = Random();

  // Get all available states for operations
  static List<State> getAvailableStates() {
    return [
      // California - High prices, high law enforcement
      const State(
        id: 'california',
        name: 'California',
        abbreviation: 'CA',
        icon: '🌴',
        lawEnforcementStrength: {
          'police': 85,
          'dea': 90,
          'fbi': 80,
          'atf': 75,
        },
        drugPrices: {
          'weed': 0.8, // Cheaper due to legalization
          'cocaine': 1.4, // More expensive due to demand
          'heroin': 1.6,
          'meth': 1.2,
          'fentanyl': 1.8,
        },
        majorCities: ['Los Angeles', 'San Francisco', 'San Diego', 'Oakland'],
        features: {
          'legal_weed': true,
          'high_demand': true,
          'gang_territories': true,
          'border_access': true,
        },
        travelCost: 500,
        operationalDifficulty: 85,
      ),

      // Texas - Border state, good for smuggling
      const State(
        id: 'texas',
        name: 'Texas',
        abbreviation: 'TX',
        icon: '🤠',
        lawEnforcementStrength: {
          'police': 75,
          'dea': 95, // High due to border
          'fbi': 70,
          'atf': 80,
        },
        drugPrices: {
          'weed': 1.1,
          'cocaine': 0.7, // Cheaper due to border proximity
          'heroin': 0.8,
          'meth': 0.9,
          'fentanyl': 1.0,
        },
        majorCities: ['Houston', 'Dallas', 'Austin', 'San Antonio'],
        features: {
          'border_access': true,
          'gun_friendly': true,
          'oil_money': true,
          'conservative': true,
        },
        travelCost: 300,
        operationalDifficulty: 70,
      ),

      // Florida - International smuggling hub
      const State(
        id: 'florida',
        name: 'Florida',
        abbreviation: 'FL',
        icon: '🐊',
        lawEnforcementStrength: {
          'police': 70,
          'dea': 88, // High due to Miami connection
          'fbi': 75,
          'atf': 65,
        },
        drugPrices: {
          'weed': 1.0,
          'cocaine': 0.6, // Very cheap due to Miami connection
          'heroin': 1.1,
          'meth': 1.3,
          'fentanyl': 1.2,
        },
        majorCities: ['Miami', 'Tampa', 'Orlando', 'Jacksonville'],
        features: {
          'international_access': true,
          'party_scene': true,
          'tourism': true,
          'corruption': true,
        },
        travelCost: 400,
        operationalDifficulty: 65,
      ),

      // New York - High prices, heavy law enforcement
      const State(
        id: 'new_york',
        name: 'New York',
        abbreviation: 'NY',
        icon: '🗽',
        lawEnforcementStrength: {
          'police': 95, // NYPD is massive
          'dea': 85,
          'fbi': 90,
          'atf': 80,
        },
        drugPrices: {
          'weed': 1.5, // Expensive urban market
          'cocaine': 1.8,
          'heroin': 1.4,
          'meth': 1.6,
          'fentanyl': 1.9,
        },
        majorCities: ['New York City', 'Buffalo', 'Rochester', 'Syracuse'],
        features: {
          'high_prices': true,
          'dense_population': true,
          'financial_center': true,
          'heavy_surveillance': true,
        },
        travelCost: 600,
        operationalDifficulty: 90,
      ),

      // Illinois - Chicago gang territory
      const State(
        id: 'illinois',
        name: 'Illinois',
        abbreviation: 'IL',
        icon: '🌾',
        lawEnforcementStrength: {
          'police': 80,
          'dea': 75,
          'fbi': 85,
          'atf': 90, // High due to gun violence
        },
        drugPrices: {
          'weed': 1.2,
          'cocaine': 1.1,
          'heroin': 0.9, // Cheaper due to local supply
          'meth': 1.0,
          'fentanyl': 0.8,
        },
        majorCities: ['Chicago', 'Aurora', 'Peoria', 'Rockford'],
        features: {
          'gang_wars': true,
          'gun_violence': true,
          'corruption': true,
          'transport_hub': true,
        },
        travelCost: 350,
        operationalDifficulty: 75,
      ),

      // Nevada - Las Vegas money laundering
      const State(
        id: 'nevada',
        name: 'Nevada',
        abbreviation: 'NV',
        icon: '🎰',
        lawEnforcementStrength: {
          'police': 60,
          'dea': 70,
          'fbi': 65,
          'atf': 55,
        },
        drugPrices: {
          'weed': 0.9,
          'cocaine': 1.3,
          'heroin': 1.2,
          'meth': 1.1,
          'fentanyl': 1.4,
        },
        majorCities: ['Las Vegas', 'Reno', 'Henderson'],
        features: {
          'gambling': true,
          'money_laundering': true,
          'tourism': true,
          'desert_isolation': true,
        },
        travelCost: 250,
        operationalDifficulty: 55,
      ),

      // Georgia - Atlanta hub
      const State(
        id: 'georgia',
        name: 'Georgia',
        abbreviation: 'GA',
        icon: '🍑',
        lawEnforcementStrength: {
          'police': 70,
          'dea': 80,
          'fbi': 75,
          'atf': 70,
        },
        drugPrices: {
          'weed': 1.1,
          'cocaine': 1.0,
          'heroin': 1.1,
          'meth': 0.9,
          'fentanyl': 1.0,
        },
        majorCities: ['Atlanta', 'Augusta', 'Columbus', 'Savannah'],
        features: {
          'rap_scene': true,
          'transport_hub': true,
          'southern_culture': true,
          'gang_activity': true,
        },
        travelCost: 300,
        operationalDifficulty: 65,
      ),

      // Arizona - Border smuggling
      const State(
        id: 'arizona',
        name: 'Arizona',
        abbreviation: 'AZ',
        icon: '🌵',
        lawEnforcementStrength: {
          'police': 65,
          'dea': 90, // High border enforcement
          'fbi': 70,
          'atf': 75,
        },
        drugPrices: {
          'weed': 1.0,
          'cocaine': 0.8, // Border proximity
          'heroin': 0.7,
          'meth': 0.8,
          'fentanyl': 0.9,
        },
        majorCities: ['Phoenix', 'Tucson', 'Mesa', 'Scottsdale'],
        features: {
          'border_smuggling': true,
          'desert_routes': true,
          'cartel_presence': true,
          'gun_running': true,
        },
        travelCost: 250,
        operationalDifficulty: 80,
      ),
    ];
  }

  // Get available interstate routes
  static List<InterstateRoute> getInterstateRoutes() {
    return [
      // California to Nevada (Easy route)
      const InterstateRoute(
        id: 'ca_to_nv',
        fromState: 'california',
        toState: 'nevada',
        distance: 275,
        travelTime: 4,
        riskLevel: 30,
        checkpoints: {'border_patrol': false, 'state_police': true, 'weigh_stations': true},
        hazards: ['State Police', 'Random Searches'],
      ),

      // Texas to Arizona (Border route)
      const InterstateRoute(
        id: 'tx_to_az',
        fromState: 'texas',
        toState: 'arizona',
        distance: 580,
        travelTime: 8,
        riskLevel: 70,
        checkpoints: {'border_patrol': true, 'state_police': true, 'dea_checkpoints': true},
        hazards: ['Border Patrol', 'DEA Checkpoints', 'Cartel Territory'],
      ),

      // Florida to Georgia (I-75 corridor)
      const InterstateRoute(
        id: 'fl_to_ga',
        fromState: 'florida',
        toState: 'georgia',
        distance: 350,
        travelTime: 5,
        riskLevel: 45,
        checkpoints: {'state_police': true, 'agricultural_inspection': true},
        hazards: ['State Police', 'Agricultural Checkpoints'],
      ),

      // Illinois to New York (High surveillance)
      const InterstateRoute(
        id: 'il_to_ny',
        fromState: 'illinois',
        toState: 'new_york',
        distance: 790,
        travelTime: 12,
        riskLevel: 85,
        checkpoints: {'state_police': true, 'toll_surveillance': true, 'federal_monitoring': true},
        hazards: ['Heavy Surveillance', 'Toll Camera', 'Federal Monitoring'],
      ),

      // California to Texas (Long haul)
      const InterstateRoute(
        id: 'ca_to_tx',
        fromState: 'california',
        toState: 'texas',
        distance: 1200,
        travelTime: 18,
        riskLevel: 60,
        checkpoints: {'border_patrol': true, 'state_police': true, 'agricultural_inspection': true},
        hazards: ['Border Patrol', 'Desert Conditions', 'Multiple State Lines'],
      ),
    ];
  }

  // Calculate interstate travel risk
  static double calculateTravelRisk(
    InterstateRoute route,
    Map<String, int> cargoValue,
    Vehicle? vehicle,
    List<GangMember> crew,
  ) {
    double baseRisk = route.riskLevel / 100.0;
    
    // Cargo value increases risk
    final totalCargoValue = cargoValue.values.reduce((a, b) => a + b);
    baseRisk += (totalCargoValue / 1000000) * 0.2; // Each million adds 20% risk
    
    // Vehicle factors
    if (vehicle != null) {
      baseRisk -= (vehicle.stealth / 100.0) * 0.3; // Stealth reduces risk
      baseRisk += (vehicle.armor / 100.0) * 0.1; // Armor might attract attention
    }
    
    // Crew factors
    for (var member in crew) {
      baseRisk -= (member.stealth / 100.0) * 0.05; // Each stealthy member helps
    }
    
    return baseRisk.clamp(0.1, 0.95);
  }

  // Execute interstate travel
  static Map<String, dynamic> executeInterstateTravel(
    InterstateRoute route,
    Map<String, int> cargoValue,
    Vehicle? vehicle,
    List<GangMember> crew,
  ) {
    final risk = calculateTravelRisk(route, cargoValue, vehicle, crew);
    final encounterChance = risk * 0.7; // 70% of risk translates to encounter chance
    
    Map<String, dynamic> result = {
      'success': true,
      'encounters': [],
      'cargo_lost': {},
      'crew_arrested': [],
      'heat_increase': 0,
      'time_taken': route.travelTime,
      'message': '',
    };
    
    // Check for encounters during travel
    for (int hour = 0; hour < route.travelTime; hour++) {
      if (_random.nextDouble() < (encounterChance / route.travelTime)) {
        final encounter = _generateTravelEncounter(route, cargoValue, hour);
        result['encounters'].add(encounter);
        
        // Process encounter effects
        if (encounter['type'] == 'checkpoint') {
          if (_random.nextDouble() < 0.4) { // 40% chance of search
            result['cargo_lost'].addAll(encounter['cargo_seized'] ?? {});
            result['heat_increase'] += encounter['heat_increase'] ?? 0;
            
            if (_random.nextDouble() < 0.3) { // 30% chance of arrest
              final arrestedMember = crew.isNotEmpty ? crew[_random.nextInt(crew.length)] : null;
              if (arrestedMember != null) {
                result['crew_arrested'].add(arrestedMember.id);
              }
            }
          }
        }
      }
    }
    
    // Final success determination
    if (result['crew_arrested'].isNotEmpty || result['cargo_lost'].isNotEmpty) {
      result['success'] = false;
      result['message'] = '🚨 Interstate travel failed! Encountered law enforcement.';
    } else {
      result['message'] = '🛣️ Successfully traveled ${route.distance} miles to new territory.';
    }
    
    return result;
  }

  // Generate random travel encounter
  static Map<String, dynamic> _generateTravelEncounter(
    InterstateRoute route,
    Map<String, int> cargoValue,
    int hour,
  ) {
    final encounterTypes = [
      'checkpoint',
      'state_police_patrol',
      'rival_gang',
      'mechanical_breakdown',
      'witness_incident',
    ];
    
    final encounterType = encounterTypes[_random.nextInt(encounterTypes.length)];
    
    switch (encounterType) {
      case 'checkpoint':
        return {
          'type': 'checkpoint',
          'time': hour,
          'checkpoint_type': route.checkpoints.keys.elementAt(_random.nextInt(route.checkpoints.length)),
          'search_chance': _random.nextInt(60) + 20, // 20-80%
          'cargo_seized': _random.nextDouble() < 0.5 ? {'drugs': cargoValue['drugs'] ?? 0} : {},
          'heat_increase': _random.nextInt(30) + 20,
        };
        
      case 'state_police_patrol':
        return {
          'type': 'state_police_patrol',
          'time': hour,
          'pursuit_level': _random.nextInt(3) + 1, // 1-3
          'escape_chance': _random.nextInt(40) + 40, // 40-80%
          'heat_increase': _random.nextInt(25) + 15,
        };
        
      case 'rival_gang':
        return {
          'type': 'rival_gang',
          'time': hour,
          'gang_strength': _random.nextInt(50) + 30,
          'demands_tribute': _random.nextDouble() < 0.6,
          'tribute_amount': _random.nextInt(20000) + 5000,
          'violence_risk': _random.nextInt(70) + 20,
        };
        
      default:
        return {
          'type': encounterType,
          'time': hour,
          'severity': _random.nextInt(50) + 25,
        };
    }
  }

  // Calculate state operation profitability
  static double calculateStateProfitability(
    State state,
    String operationType,
    Map<String, dynamic> playerAssets,
  ) {
    double baseProfitability = 1.0;
    
    // Drug price factors
    if (operationType == 'drug_dealing') {
      final drugPriceMultiplier = state.drugPrices.values.reduce((a, b) => a + b) / state.drugPrices.length;
      baseProfitability *= drugPriceMultiplier;
    }
    
    // Law enforcement difficulty
    final avgLawEnforcement = state.lawEnforcementStrength.values.reduce((a, b) => a + b) / state.lawEnforcementStrength.length;
    baseProfitability -= (avgLawEnforcement / 100.0) * 0.3; // Strong law enforcement reduces profit
    
    // State features
    if (state.features['high_demand'] == true) baseProfitability += 0.3;
    if (state.features['corruption'] == true) baseProfitability += 0.2;
    if (state.features['gang_wars'] == true) baseProfitability -= 0.2;
    if (state.features['heavy_surveillance'] == true) baseProfitability -= 0.3;
    
    // Player assets in state
    final playerPresence = (playerAssets['properties_in_state'] ?? 0) / 10.0;
    baseProfitability += playerPresence * 0.1; // Each property adds 10% profit
    
    return baseProfitability.clamp(0.3, 3.0); // 30% to 300% profitability
  }

  // Get state-specific opportunities
  static List<Map<String, dynamic>> getStateOpportunities(State state) {
    List<Map<String, dynamic>> opportunities = [];
    
    // State-specific opportunities based on features
    if (state.features['border_access'] == true) {
      opportunities.add({
        'type': 'smuggling_operation',
        'title': 'Border Smuggling Route',
        'description': 'Establish a permanent smuggling route across the border.',
        'investment': 100000,
        'monthly_income': 50000,
        'risk_level': 80,
      });
    }
    
    if (state.features['money_laundering'] == true) {
      opportunities.add({
        'type': 'casino_operation',
        'title': 'Casino Money Laundering',
        'description': 'Use casinos to clean large amounts of dirty money.',
        'investment': 250000,
        'monthly_income': 75000,
        'risk_level': 40,
      });
    }
    
    if (state.features['gang_territories'] == true) {
      opportunities.add({
        'type': 'territory_war',
        'title': 'Gang Territory Takeover',
        'description': 'Challenge existing gangs for control of lucrative territories.',
        'investment': 75000,
        'monthly_income': 40000,
        'risk_level': 90,
      });
    }
    
    if (state.features['gun_friendly'] == true) {
      opportunities.add({
        'type': 'gun_running',
        'title': 'Interstate Gun Running',
        'description': 'Buy guns legally here and sell illegally in strict states.',
        'investment': 50000,
        'monthly_income': 30000,
        'risk_level': 60,
      });
    }
    
    return opportunities;
  }

  // Generate interstate event
  static Map<String, dynamic>? generateInterstateEvent(
    List<State> operationalStates,
    Map<String, dynamic> playerStatus,
  ) {
    if (_random.nextDouble() > 0.3) return null; // 30% chance
    
    final events = [
      'multi_state_investigation',
      'interstate_gang_war',
      'federal_task_force',
      'border_crackdown',
      'state_cooperation',
    ];
    
    final eventType = events[_random.nextInt(events.length)];
    final affectedState = operationalStates[_random.nextInt(operationalStates.length)];
    
    switch (eventType) {
      case 'multi_state_investigation':
        return {
          'type': 'multi_state_investigation',
          'title': '🚨 Multi-State Investigation',
          'message': 'Federal agencies are coordinating a multi-state investigation into your operations.',
          'affected_states': operationalStates.map((s) => s.id).toList(),
          'heat_increase': _random.nextInt(40) + 30,
          'duration_days': _random.nextInt(30) + 14,
          'options': [
            {'text': 'Go Underground', 'action': 'underground', 'cost': 50000},
            {'text': 'Bribe Federal Officials', 'action': 'federal_bribe', 'cost': 200000},
            {'text': 'Abandon Some States', 'action': 'abandon_states', 'cost': 0},
          ],
        };
        
      case 'interstate_gang_war':
        return {
          'type': 'interstate_gang_war',
          'title': '⚔️ Interstate Gang War',
          'message': 'A major gang war has erupted across state lines. Choose your side or stay neutral.',
          'affected_state': affectedState.id,
          'war_intensity': _random.nextInt(70) + 30,
          'potential_gains': _random.nextInt(100000) + 50000,
          'options': [
            {'text': 'Join the War', 'action': 'join_war', 'cost': 25000},
            {'text': 'Supply Both Sides', 'action': 'supply_both', 'cost': 10000},
            {'text': 'Stay Neutral', 'action': 'neutral', 'cost': 0},
          ],
        };
    }
    
    return null;
  }
}
