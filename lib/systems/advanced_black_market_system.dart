import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

// Advanced Black Market System
// Feature #22: Ultra-comprehensive underground marketplace with
// illegal goods, black market dealers, contraband trading, and underground economy

enum ContrabandType {
  weapons,
  explosives,
  stolenGoods,
  illegalDrugs,
  counterfeitMoney,
  humanTrafficking,
  organTrafficking,
  informationBroker,
  hitmanServices,
  corruptionServices,
  stolenVehicles,
  forbiddenTechnology
}

enum DealerType {
  streetDealer,
  undergroundBroker,
  cartellConnected,
  internationalSmuggler,
  corruptOfficial,
  techSpecialist,
  weaponsExpert,
  informationBroker
}

enum MarketHeat {
  cold,
  cool,
  warm,
  hot,
  burning
}

enum TransactionRisk {
  minimal,
  low,
  moderate,
  high,
  extreme
}

class ContrabandItem {
  final String id;
  final String name;
  final ContrabandType type;
  final double basePrice;
  final double currentPrice;
  final int quantity;
  final TransactionRisk risk;
  final double profitMargin;
  final List<String> requirements;
  final Map<String, dynamic> properties;
  final bool isAvailable;
  final DateTime? lastUpdated;

  ContrabandItem({
    required this.id,
    required this.name,
    required this.type,
    required this.basePrice,
    required this.currentPrice,
    this.quantity = 0,
    this.risk = TransactionRisk.moderate,
    this.profitMargin = 0.5,
    this.requirements = const [],
    this.properties = const {},
    this.isAvailable = true,
    this.lastUpdated,
  });

  ContrabandItem copyWith({
    String? id,
    String? name,
    ContrabandType? type,
    double? basePrice,
    double? currentPrice,
    int? quantity,
    TransactionRisk? risk,
    double? profitMargin,
    List<String>? requirements,
    Map<String, dynamic>? properties,
    bool? isAvailable,
    DateTime? lastUpdated,
  }) {
    return ContrabandItem(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      basePrice: basePrice ?? this.basePrice,
      currentPrice: currentPrice ?? this.currentPrice,
      quantity: quantity ?? this.quantity,
      risk: risk ?? this.risk,
      profitMargin: profitMargin ?? this.profitMargin,
      requirements: requirements ?? this.requirements,
      properties: properties ?? this.properties,
      isAvailable: isAvailable ?? this.isAvailable,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  double get riskMultiplier {
    switch (risk) {
      case TransactionRisk.minimal:
        return 1.0;
      case TransactionRisk.low:
        return 1.2;
      case TransactionRisk.moderate:
        return 1.5;
      case TransactionRisk.high:
        return 2.0;
      case TransactionRisk.extreme:
        return 3.0;
    }
  }

  double get adjustedPrice => currentPrice * riskMultiplier;
}

class BlackMarketDealer {
  final String id;
  final String name;
  final DealerType type;
  final double reputation;
  final double reliability;
  final double priceModifier;
  final List<ContrabandType> specialties;
  final Map<String, ContrabandItem> inventory;
  final double trustLevel;
  final bool isActive;
  final DateTime? lastContact;
  final Map<String, dynamic> dealerData;

  BlackMarketDealer({
    required this.id,
    required this.name,
    required this.type,
    this.reputation = 0.5,
    this.reliability = 0.5,
    this.priceModifier = 1.0,
    this.specialties = const [],
    this.inventory = const {},
    this.trustLevel = 0.0,
    this.isActive = true,
    this.lastContact,
    this.dealerData = const {},
  });

  BlackMarketDealer copyWith({
    String? id,
    String? name,
    DealerType? type,
    double? reputation,
    double? reliability,
    double? priceModifier,
    List<ContrabandType>? specialties,
    Map<String, ContrabandItem>? inventory,
    double? trustLevel,
    bool? isActive,
    DateTime? lastContact,
    Map<String, dynamic>? dealerData,
  }) {
    return BlackMarketDealer(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      reputation: reputation ?? this.reputation,
      reliability: reliability ?? this.reliability,
      priceModifier: priceModifier ?? this.priceModifier,
      specialties: specialties ?? this.specialties,
      inventory: inventory ?? this.inventory,
      trustLevel: trustLevel ?? this.trustLevel,
      isActive: isActive ?? this.isActive,
      lastContact: lastContact ?? this.lastContact,
      dealerData: dealerData ?? this.dealerData,
    );
  }

  double get dealQuality {
    return (reputation + reliability + trustLevel) / 3.0;
  }

  bool canProvide(ContrabandType type) {
    return specialties.contains(type) && isActive;
  }
}

class BlackMarketTransaction {
  final String id;
  final String dealerId;
  final String itemId;
  final int quantity;
  final double totalPrice;
  final TransactionRisk risk;
  final DateTime timestamp;
  final bool isSuccessful;
  final String? failureReason;
  final Map<String, dynamic> details;

  BlackMarketTransaction({
    required this.id,
    required this.dealerId,
    required this.itemId,
    required this.quantity,
    required this.totalPrice,
    required this.risk,
    required this.timestamp,
    this.isSuccessful = true,
    this.failureReason,
    this.details = const {},
  });
}

class MarketIntelligence {
  final String id;
  final ContrabandType type;
  final String information;
  final double reliability;
  final double value;
  final DateTime expiration;
  final String source;

  MarketIntelligence({
    required this.id,
    required this.type,
    required this.information,
    this.reliability = 0.5,
    this.value = 1000.0,
    required this.expiration,
    required this.source,
  });

  bool get isValid => DateTime.now().isBefore(expiration);
}

class AdvancedBlackMarketSystem extends ChangeNotifier {
  static final AdvancedBlackMarketSystem _instance = AdvancedBlackMarketSystem._internal();
  factory AdvancedBlackMarketSystem() => _instance;
  AdvancedBlackMarketSystem._internal() {
    _initializeSystem();
  }

  final Map<String, BlackMarketDealer> _dealers = {};
  final Map<String, ContrabandItem> _contraband = {};
  final Map<String, BlackMarketTransaction> _transactions = {};
  final Map<String, MarketIntelligence> _intelligence = {};
  
  String? _playerId;
  MarketHeat _marketHeat = MarketHeat.cool;
  double _playerReputation = 0.5;
  double _policeAwareness = 0.3;
  int _totalTransactions = 0;
  double _totalVolume = 0.0;
  
  Timer? _systemTimer;
  final math.Random _random = math.Random();

  // Getters
  Map<String, BlackMarketDealer> get dealers => Map.unmodifiable(_dealers);
  Map<String, ContrabandItem> get contraband => Map.unmodifiable(_contraband);
  Map<String, BlackMarketTransaction> get transactions => Map.unmodifiable(_transactions);
  Map<String, MarketIntelligence> get intelligence => Map.unmodifiable(_intelligence);
  String? get playerId => _playerId;
  MarketHeat get marketHeat => _marketHeat;
  double get playerReputation => _playerReputation;
  double get policeAwareness => _policeAwareness;
  int get totalTransactions => _totalTransactions;
  double get totalVolume => _totalVolume;

  void _initializeSystem() {
    _playerId = 'player_${DateTime.now().millisecondsSinceEpoch}';
    _generateDealers();
    _generateContraband();
    _startSystemTimer();
  }

  void _generateDealers() {
    final dealerDefinitions = _getDealerDefinitions();
    
    for (final dealer in dealerDefinitions) {
      _dealers[dealer.id] = dealer;
    }
  }

  List<BlackMarketDealer> _getDealerDefinitions() {
    return [
      BlackMarketDealer(
        id: 'dealer_snake_eyes',
        name: 'Snake Eyes',
        type: DealerType.streetDealer,
        reputation: 0.6,
        reliability: 0.4,
        priceModifier: 0.8,
        specialties: [ContrabandType.weapons, ContrabandType.stolenGoods],
        trustLevel: 0.3,
        dealerData: {
          'location': 'Downtown Alley',
          'contact_method': 'Street corner',
          'warning_signs': ['Police patrol', 'Rival gangs'],
        },
      ),
      BlackMarketDealer(
        id: 'dealer_midnight_broker',
        name: 'The Midnight Broker',
        type: DealerType.undergroundBroker,
        reputation: 0.8,
        reliability: 0.9,
        priceModifier: 1.2,
        specialties: [ContrabandType.informationBroker, ContrabandType.corruptionServices],
        trustLevel: 0.7,
        dealerData: {
          'location': 'Underground network',
          'contact_method': 'Encrypted channels',
          'specialization': 'High-value intelligence',
        },
      ),
      BlackMarketDealer(
        id: 'dealer_cartel_contact',
        name: 'El Sombra',
        type: DealerType.cartellConnected,
        reputation: 0.9,
        reliability: 0.8,
        priceModifier: 1.5,
        specialties: [ContrabandType.illegalDrugs, ContrabandType.weapons, ContrabandType.explosives],
        trustLevel: 0.5,
        dealerData: {
          'location': 'Border region',
          'contact_method': 'Cartel connections',
          'risk_level': 'Extreme',
        },
      ),
      BlackMarketDealer(
        id: 'dealer_tech_ghost',
        name: 'TechGhost',
        type: DealerType.techSpecialist,
        reputation: 0.7,
        reliability: 0.9,
        priceModifier: 2.0,
        specialties: [ContrabandType.forbiddenTechnology, ContrabandType.counterfeitMoney],
        trustLevel: 0.8,
        dealerData: {
          'location': 'Dark web',
          'contact_method': 'Encrypted protocols',
          'specialization': 'Advanced technology',
        },
      ),
      BlackMarketDealer(
        id: 'dealer_shadow_trader',
        name: 'Shadow Trader',
        type: DealerType.internationalSmuggler,
        reputation: 0.95,
        reliability: 0.85,
        priceModifier: 3.0,
        specialties: [ContrabandType.humanTrafficking, ContrabandType.organTrafficking, ContrabandType.stolenVehicles],
        trustLevel: 0.4,
        dealerData: {
          'location': 'International networks',
          'contact_method': 'Secure channels',
          'warning': 'Extreme danger',
        },
      ),
    ];
  }

  void _generateContraband() {
    final contrabandDefinitions = _getContrabandDefinitions();
    
    for (final item in contrabandDefinitions) {
      _contraband[item.id] = item;
    }
    
    // Assign contraband to dealers
    _assignContrabandToDealers();
  }

  List<ContrabandItem> _getContrabandDefinitions() {
    return [
      // Weapons
      ContrabandItem(
        id: 'item_pistol_untraceable',
        name: 'Untraceable Pistol',
        type: ContrabandType.weapons,
        basePrice: 2500.0,
        currentPrice: 2500.0,
        quantity: 5,
        risk: TransactionRisk.high,
        requirements: ['street_connections'],
      ),
      ContrabandItem(
        id: 'item_assault_rifle',
        name: 'Military Assault Rifle',
        type: ContrabandType.weapons,
        basePrice: 8000.0,
        currentPrice: 8000.0,
        quantity: 2,
        risk: TransactionRisk.extreme,
        requirements: ['cartel_connections', 'high_reputation'],
      ),
      
      // Explosives
      ContrabandItem(
        id: 'item_plastic_explosive',
        name: 'C4 Plastic Explosive',
        type: ContrabandType.explosives,
        basePrice: 5000.0,
        currentPrice: 5000.0,
        quantity: 3,
        risk: TransactionRisk.extreme,
        requirements: ['military_connections'],
      ),
      
      // Stolen Goods
      ContrabandItem(
        id: 'item_luxury_watch',
        name: 'Stolen Luxury Watches',
        type: ContrabandType.stolenGoods,
        basePrice: 15000.0,
        currentPrice: 15000.0,
        quantity: 10,
        risk: TransactionRisk.moderate,
        requirements: ['fence_network'],
      ),
      
      // Illegal Drugs
      ContrabandItem(
        id: 'item_pure_cocaine',
        name: 'Pure Colombian Cocaine',
        type: ContrabandType.illegalDrugs,
        basePrice: 50000.0,
        currentPrice: 50000.0,
        quantity: 1,
        risk: TransactionRisk.extreme,
        requirements: ['cartel_connections'],
      ),
      
      // Counterfeit Money
      ContrabandItem(
        id: 'item_fake_bills',
        name: 'High-Quality Counterfeit Bills',
        type: ContrabandType.counterfeitMoney,
        basePrice: 10000.0,
        currentPrice: 10000.0,
        quantity: 20,
        risk: TransactionRisk.high,
        requirements: ['printing_connections'],
      ),
      
      // Information
      ContrabandItem(
        id: 'item_police_database',
        name: 'Police Database Access',
        type: ContrabandType.informationBroker,
        basePrice: 25000.0,
        currentPrice: 25000.0,
        quantity: 1,
        risk: TransactionRisk.extreme,
        requirements: ['corrupt_officials'],
      ),
      
      // Services
      ContrabandItem(
        id: 'item_hitman_contract',
        name: 'Professional Elimination',
        type: ContrabandType.hitmanServices,
        basePrice: 100000.0,
        currentPrice: 100000.0,
        quantity: 1,
        risk: TransactionRisk.extreme,
        requirements: ['criminal_network', 'high_trust'],
      ),
      
      // Technology
      ContrabandItem(
        id: 'item_hacking_tools',
        name: 'Advanced Hacking Suite',
        type: ContrabandType.forbiddenTechnology,
        basePrice: 35000.0,
        currentPrice: 35000.0,
        quantity: 2,
        risk: TransactionRisk.high,
        requirements: ['tech_connections'],
      ),
      
      // Vehicles
      ContrabandItem(
        id: 'item_stolen_supercar',
        name: 'Stolen Supercar (Clean Papers)',
        type: ContrabandType.stolenVehicles,
        basePrice: 200000.0,
        currentPrice: 200000.0,
        quantity: 1,
        risk: TransactionRisk.extreme,
        requirements: ['chop_shop_network'],
      ),
    ];
  }

  void _assignContrabandToDealers() {
    for (final dealer in _dealers.values) {
      final dealerInventory = <String, ContrabandItem>{};
      
      for (final item in _contraband.values) {
        if (dealer.specialties.contains(item.type) && _random.nextDouble() < 0.7) {
          // Adjust price based on dealer
          final adjustedItem = item.copyWith(
            currentPrice: item.basePrice * dealer.priceModifier,
            quantity: (_random.nextInt(5) + 1),
            lastUpdated: DateTime.now(),
          );
          
          dealerInventory[item.id] = adjustedItem;
        }
      }
      
      _dealers[dealer.id] = dealer.copyWith(inventory: dealerInventory);
    }
  }

  void _startSystemTimer() {
    _systemTimer?.cancel();
    _systemTimer = Timer.periodic(const Duration(seconds: 20), (_) {
      _updateMarketConditions();
      _updatePrices();
      _simulateMarketEvents();
      _updatePoliceAwareness();
      notifyListeners();
    });
  }

  // Market Operations
  BlackMarketTransaction? attemptTransaction(String dealerId, String itemId, int quantity) {
    final dealer = _dealers[dealerId];
    final item = dealer?.inventory[itemId];
    
    if (dealer == null || item == null || !item.isAvailable || item.quantity < quantity) {
      return null;
    }
    
    // Check requirements
    if (!_meetsRequirements(item.requirements)) {
      return null;
    }
    
    final totalPrice = item.adjustedPrice * quantity;
    final transactionId = 'trans_${DateTime.now().millisecondsSinceEpoch}';
    
    // Calculate success probability
    double successChance = dealer.reliability * (1.0 - _getHeatModifier());
    successChance *= _getReputationModifier();
    successChance = successChance.clamp(0.1, 0.95);
    
    final isSuccessful = _random.nextDouble() < successChance;
    
    final transaction = BlackMarketTransaction(
      id: transactionId,
      dealerId: dealerId,
      itemId: itemId,
      quantity: quantity,
      totalPrice: totalPrice,
      risk: item.risk,
      timestamp: DateTime.now(),
      isSuccessful: isSuccessful,
      failureReason: isSuccessful ? null : _getFailureReason(),
    );
    
    _transactions[transactionId] = transaction;
    
    if (isSuccessful) {
      _completeTransaction(dealerId, itemId, quantity, totalPrice);
    } else {
      _handleFailedTransaction(item.risk);
    }
    
    return transaction;
  }

  void _completeTransaction(String dealerId, String itemId, int quantity, double totalPrice) {
    final dealer = _dealers[dealerId]!;
    final item = dealer.inventory[itemId]!;
    
    // Update inventory
    final newInventory = Map<String, ContrabandItem>.from(dealer.inventory);
    newInventory[itemId] = item.copyWith(
      quantity: (item.quantity - quantity).clamp(0, item.quantity),
    );
    
    _dealers[dealerId] = dealer.copyWith(
      inventory: newInventory,
      lastContact: DateTime.now(),
      trustLevel: (dealer.trustLevel + 0.02).clamp(0.0, 1.0),
    );
    
    // Update player stats
    _totalTransactions++;
    _totalVolume += totalPrice;
    _playerReputation = (_playerReputation + 0.01).clamp(0.0, 1.0);
    
    // Increase police awareness based on transaction risk
    _increasePoliceAwareness(item.risk);
  }

  void _handleFailedTransaction(TransactionRisk risk) {
    // Failed transactions increase police awareness more
    _increasePoliceAwareness(risk, multiplier: 2.0);
    
    // Chance of legal consequences
    double legalRiskChance = 0.1;
    switch (risk) {
      case TransactionRisk.minimal:
        legalRiskChance = 0.05;
        break;
      case TransactionRisk.low:
        legalRiskChance = 0.1;
        break;
      case TransactionRisk.moderate:
        legalRiskChance = 0.2;
        break;
      case TransactionRisk.high:
        legalRiskChance = 0.4;
        break;
      case TransactionRisk.extreme:
        legalRiskChance = 0.6;
        break;
    }
    
    if (_random.nextDouble() < legalRiskChance) {
      _triggerLegalConsequences();
    }
  }

  bool _meetsRequirements(List<String> requirements) {
    // Simplified requirement check
    for (final requirement in requirements) {
      switch (requirement) {
        case 'high_reputation':
          if (_playerReputation < 0.7) return false;
          break;
        case 'high_trust':
          if (_playerReputation < 0.8) return false;
          break;
        case 'street_connections':
          if (_totalTransactions < 5) return false;
          break;
        default:
          // Other requirements assumed met for now
          break;
      }
    }
    return true;
  }

  double _getHeatModifier() {
    switch (_marketHeat) {
      case MarketHeat.cold:
        return 0.1;
      case MarketHeat.cool:
        return 0.2;
      case MarketHeat.warm:
        return 0.4;
      case MarketHeat.hot:
        return 0.6;
      case MarketHeat.burning:
        return 0.8;
    }
  }

  double _getReputationModifier() {
    return 0.5 + (_playerReputation * 0.5);
  }

  String _getFailureReason() {
    final reasons = [
      'Police raid interrupted transaction',
      'Dealer got cold feet',
      'Rival gang interference',
      'Goods confiscated',
      'Setup - informant involved',
      'Payment issues',
    ];
    return reasons[_random.nextInt(reasons.length)];
  }

  void _increasePoliceAwareness(TransactionRisk risk, {double multiplier = 1.0}) {
    double increase = 0.01 * multiplier;
    
    switch (risk) {
      case TransactionRisk.minimal:
        increase *= 0.5;
        break;
      case TransactionRisk.low:
        increase *= 1.0;
        break;
      case TransactionRisk.moderate:
        increase *= 1.5;
        break;
      case TransactionRisk.high:
        increase *= 2.0;
        break;
      case TransactionRisk.extreme:
        increase *= 3.0;
        break;
    }
    
    _policeAwareness = (_policeAwareness + increase).clamp(0.0, 1.0);
  }

  void _triggerLegalConsequences() {
    // Integration point with legal system
    // This would create legal cases based on black market activity
  }

  // Market Intelligence
  void purchaseIntelligence(String intelligenceId) {
    final intel = _intelligence[intelligenceId];
    if (intel != null && intel.isValid) {
      // Apply intelligence benefits
      _applyIntelligenceBenefits(intel);
    }
  }

  void _applyIntelligenceBenefits(MarketIntelligence intel) {
    switch (intel.type) {
      case ContrabandType.weapons:
        // Reduce weapon prices temporarily
        _adjustPricesForType(ContrabandType.weapons, 0.8, Duration(hours: 6));
        break;
      case ContrabandType.informationBroker:
        // Increase police awareness visibility
        break;
      default:
        break;
    }
  }

  void _adjustPricesForType(ContrabandType type, double modifier, Duration duration) {
    for (final dealer in _dealers.values) {
      final newInventory = <String, ContrabandItem>{};
      
      for (final item in dealer.inventory.values) {
        if (item.type == type) {
          newInventory[item.id] = item.copyWith(
            currentPrice: item.basePrice * modifier,
            lastUpdated: DateTime.now(),
          );
        } else {
          newInventory[item.id] = item;
        }
      }
      
      _dealers[dealer.id] = dealer.copyWith(inventory: newInventory);
    }
    
    // Reset prices after duration
    Timer(duration, () => _resetPricesForType(type));
  }

  void _resetPricesForType(ContrabandType type) {
    for (final dealer in _dealers.values) {
      final newInventory = <String, ContrabandItem>{};
      
      for (final item in dealer.inventory.values) {
        if (item.type == type) {
          newInventory[item.id] = item.copyWith(
            currentPrice: item.basePrice * dealer.priceModifier,
            lastUpdated: DateTime.now(),
          );
        } else {
          newInventory[item.id] = item;
        }
      }
      
      _dealers[dealer.id] = dealer.copyWith(inventory: newInventory);
    }
    
    notifyListeners();
  }

  // System Updates
  void _updateMarketConditions() {
    // Update market heat based on police awareness
    if (_policeAwareness > 0.8) {
      _marketHeat = MarketHeat.burning;
    } else if (_policeAwareness > 0.6) {
      _marketHeat = MarketHeat.hot;
    } else if (_policeAwareness > 0.4) {
      _marketHeat = MarketHeat.warm;
    } else if (_policeAwareness > 0.2) {
      _marketHeat = MarketHeat.cool;
    } else {
      _marketHeat = MarketHeat.cold;
    }
  }

  void _updatePrices() {
    for (final dealer in _dealers.values) {
      final newInventory = <String, ContrabandItem>{};
      
      for (final item in dealer.inventory.values) {
        // Random price fluctuations
        final fluctuation = 1.0 + (_random.nextDouble() - 0.5) * 0.2;
        final newPrice = (item.currentPrice * fluctuation).clamp(
          item.basePrice * 0.5,
          item.basePrice * 2.0,
        );
        
        newInventory[item.id] = item.copyWith(
          currentPrice: newPrice,
          lastUpdated: DateTime.now(),
        );
      }
      
      _dealers[dealer.id] = dealer.copyWith(inventory: newInventory);
    }
  }

  void _simulateMarketEvents() {
    if (_random.nextDouble() < 0.1) {
      _generateRandomMarketEvent();
    }
  }

  void _generateRandomMarketEvent() {
    final events = [
      'police_raid',
      'new_supplier',
      'gang_war_disruption',
      'border_crackdown',
      'corruption_scandal',
      'tech_breakthrough',
    ];
    
    final event = events[_random.nextInt(events.length)];
    _handleMarketEvent(event);
  }

  void _handleMarketEvent(String event) {
    switch (event) {
      case 'police_raid':
        _policeAwareness = (_policeAwareness + 0.2).clamp(0.0, 1.0);
        // Some dealers become unavailable
        final dealerIds = _dealers.keys.toList();
        if (dealerIds.isNotEmpty) {
          final targetDealer = dealerIds[_random.nextInt(dealerIds.length)];
          final dealer = _dealers[targetDealer]!;
          _dealers[targetDealer] = dealer.copyWith(isActive: false);
          
          // Reactivate after some time
          Timer(const Duration(minutes: 10), () {
            _dealers[targetDealer] = dealer.copyWith(isActive: true);
            notifyListeners();
          });
        }
        break;
        
      case 'new_supplier':
        // Random dealer gets new inventory
        final dealerIds = _dealers.keys.toList();
        if (dealerIds.isNotEmpty) {
          final targetDealer = dealerIds[_random.nextInt(dealerIds.length)];
          _restockDealer(targetDealer);
        }
        break;
        
      case 'gang_war_disruption':
        // Weapons and explosives prices increase
        _adjustPricesForType(ContrabandType.weapons, 1.5, Duration(hours: 2));
        _adjustPricesForType(ContrabandType.explosives, 1.8, Duration(hours: 2));
        break;
        
      case 'border_crackdown':
        // Drug prices increase, availability decreases
        _adjustPricesForType(ContrabandType.illegalDrugs, 2.0, Duration(hours: 4));
        break;
        
      case 'corruption_scandal':
        // Information and corruption services become more expensive
        _adjustPricesForType(ContrabandType.informationBroker, 1.5, Duration(hours: 3));
        _adjustPricesForType(ContrabandType.corruptionServices, 1.8, Duration(hours: 3));
        break;
        
      case 'tech_breakthrough':
        // Technology items become cheaper
        _adjustPricesForType(ContrabandType.forbiddenTechnology, 0.7, Duration(hours: 6));
        break;
    }
  }

  void _restockDealer(String dealerId) {
    final dealer = _dealers[dealerId];
    if (dealer == null) return;
    
    final newInventory = Map<String, ContrabandItem>.from(dealer.inventory);
    
    for (final item in _contraband.values) {
      if (dealer.specialties.contains(item.type)) {
        final existingItem = newInventory[item.id];
        if (existingItem != null) {
          newInventory[item.id] = existingItem.copyWith(
            quantity: existingItem.quantity + _random.nextInt(3) + 1,
          );
        }
      }
    }
    
    _dealers[dealerId] = dealer.copyWith(inventory: newInventory);
  }

  void _updatePoliceAwareness() {
    // Police awareness naturally decreases over time
    _policeAwareness = (_policeAwareness - 0.005).clamp(0.0, 1.0);
  }

  // Public Interface Methods
  List<BlackMarketDealer> getAvailableDealers() {
    return _dealers.values.where((d) => d.isActive).toList()
      ..sort((a, b) => b.dealQuality.compareTo(a.dealQuality));
  }

  List<ContrabandItem> getDealerInventory(String dealerId) {
    final dealer = _dealers[dealerId];
    return dealer?.inventory.values.where((item) => item.isAvailable && item.quantity > 0).toList() ?? [];
  }

  List<BlackMarketTransaction> getRecentTransactions({int limit = 10}) {
    final transactions = _transactions.values.toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    
    return transactions.take(limit).toList();
  }

  List<MarketIntelligence> getAvailableIntelligence() {
    return _intelligence.values.where((intel) => intel.isValid).toList()
      ..sort((a, b) => b.value.compareTo(a.value));
  }

  double calculateTransactionRisk(String dealerId, String itemId) {
    final dealer = _dealers[dealerId];
    final item = dealer?.inventory[itemId];
    
    if (dealer == null || item == null) return 1.0;
    
    double risk = item.riskMultiplier;
    risk *= (1.0 - dealer.reliability);
    risk *= _getHeatModifier();
    risk *= (1.0 + _policeAwareness);
    
    return risk.clamp(0.1, 10.0);
  }

  String getMarketStatus() {
    switch (_marketHeat) {
      case MarketHeat.cold:
        return 'Market is quiet - good for business';
      case MarketHeat.cool:
        return 'Normal market conditions';
      case MarketHeat.warm:
        return 'Increased police activity - be careful';
      case MarketHeat.hot:
        return 'High risk environment - avoid large transactions';
      case MarketHeat.burning:
        return 'EXTREME DANGER - market compromised';
    }
  }

  void dispose() {
    _systemTimer?.cancel();
    super.dispose();
  }
}

// Advanced Black Market Dashboard Widget
class AdvancedBlackMarketDashboardWidget extends StatefulWidget {
  const AdvancedBlackMarketDashboardWidget({super.key});

  @override
  State<AdvancedBlackMarketDashboardWidget> createState() => _AdvancedBlackMarketDashboardWidgetState();
}

class _AdvancedBlackMarketDashboardWidgetState extends State<AdvancedBlackMarketDashboardWidget>
    with TickerProviderStateMixin {
  final AdvancedBlackMarketSystem _blackMarket = AdvancedBlackMarketSystem();
  late TabController _tabController;
  String? _selectedDealer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _blackMarket,
      builder: (context, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                _buildStatsRow(),
                const SizedBox(height: 16),
                _buildMarketStatus(),
                const SizedBox(height: 16),
                _buildTabBar(),
                const SizedBox(height: 16),
                Expanded(child: _buildTabBarView()),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Icon(Icons.shopping_bag, color: Colors.red),
        const SizedBox(width: 8),
        const Text(
          'Black Market',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Icon(
          _getHeatIcon(_blackMarket.marketHeat),
          color: _getHeatColor(_blackMarket.marketHeat),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatCard('Reputation', '${(_blackMarket.playerReputation * 100).toInt()}%'),
        _buildStatCard('Transactions', '${_blackMarket.totalTransactions}'),
        _buildStatCard('Volume', '\$${(_blackMarket.totalVolume / 1000).toInt()}K'),
        _buildStatCard('Police Heat', '${(_blackMarket.policeAwareness * 100).toInt()}%'),
      ],
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Expanded(
      child: Card(
        color: Colors.red[50],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(label, style: const TextStyle(fontSize: 12)),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMarketStatus() {
    return Card(
      color: _getHeatColor(_blackMarket.marketHeat).withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(_getHeatIcon(_blackMarket.marketHeat), color: _getHeatColor(_blackMarket.marketHeat)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _blackMarket.getMarketStatus(),
                style: TextStyle(color: _getHeatColor(_blackMarket.marketHeat), fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      tabs: const [
        Tab(text: 'Dealers', icon: Icon(Icons.person)),
        Tab(text: 'Inventory', icon: Icon(Icons.inventory)),
        Tab(text: 'Transactions', icon: Icon(Icons.receipt)),
        Tab(text: 'Intelligence', icon: Icon(Icons.info)),
      ],
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildDealersTab(),
        _buildInventoryTab(),
        _buildTransactionsTab(),
        _buildIntelligenceTab(),
      ],
    );
  }

  Widget _buildDealersTab() {
    final dealers = _blackMarket.getAvailableDealers();
    
    return ListView.builder(
      itemCount: dealers.length,
      itemBuilder: (context, index) {
        final dealer = dealers[index];
        return _buildDealerCard(dealer);
      },
    );
  }

  Widget _buildDealerCard(BlackMarketDealer dealer) {
    final isSelected = _selectedDealer == dealer.id;
    
    return Card(
      color: isSelected ? Colors.red[100] : null,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: _getDealerTypeColor(dealer.type),
          child: Text(dealer.name[0]),
        ),
        title: Text(dealer.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${dealer.type.name} - Trust: ${(dealer.trustLevel * 100).toInt()}%'),
            Text('Reliability: ${(dealer.reliability * 100).toInt()}% - Quality: ${(dealer.dealQuality * 100).toInt()}%'),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Specialties: ${dealer.specialties.map((s) => s.name).join(', ')}'),
                const SizedBox(height: 8),
                Text('Price Modifier: ${(dealer.priceModifier * 100).toInt()}%'),
                const SizedBox(height: 8),
                Text('Location: ${dealer.dealerData['location'] ?? 'Unknown'}'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => setState(() => _selectedDealer = dealer.id),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Select Dealer'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _showDealerDetails(dealer),
                      child: const Text('Details'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryTab() {
    if (_selectedDealer == null) {
      return const Center(
        child: Text('Select a dealer first'),
      );
    }
    
    final inventory = _blackMarket.getDealerInventory(_selectedDealer!);
    
    return ListView.builder(
      itemCount: inventory.length,
      itemBuilder: (context, index) {
        final item = inventory[index];
        return _buildInventoryCard(item);
      },
    );
  }

  Widget _buildInventoryCard(ContrabandItem item) {
    return Card(
      child: ExpansionTile(
        leading: Icon(
          _getContrabandIcon(item.type),
          color: _getRiskColor(item.risk),
        ),
        title: Text(item.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price: \$${item.adjustedPrice.toInt()} (${item.risk.name} risk)'),
            Text('Available: ${item.quantity}'),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Base Price: \$${item.basePrice.toInt()}'),
                Text('Risk Level: ${item.risk.name}'),
                if (item.requirements.isNotEmpty)
                  Text('Requirements: ${item.requirements.join(', ')}'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(labelText: 'Quantity'),
                        keyboardType: TextInputType.number,
                        onSubmitted: (value) {
                          final quantity = int.tryParse(value) ?? 1;
                          _attemptPurchase(item.id, quantity);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _attemptPurchase(item.id, 1),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Buy'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsTab() {
    final transactions = _blackMarket.getRecentTransactions();
    
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return _buildTransactionCard(transaction);
      },
    );
  }

  Widget _buildTransactionCard(BlackMarketTransaction transaction) {
    return Card(
      color: transaction.isSuccessful ? Colors.green[50] : Colors.red[50],
      child: ListTile(
        leading: Icon(
          transaction.isSuccessful ? Icons.check_circle : Icons.error,
          color: transaction.isSuccessful ? Colors.green : Colors.red,
        ),
        title: Text('Transaction ${transaction.id.split('_').last}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Amount: \$${transaction.totalPrice.toInt()}'),
            Text('Risk: ${transaction.risk.name}'),
            if (!transaction.isSuccessful && transaction.failureReason != null)
              Text('Failed: ${transaction.failureReason}', style: const TextStyle(color: Colors.red)),
            Text('Date: ${_formatDate(transaction.timestamp)}'),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildIntelligenceTab() {
    final intelligence = _blackMarket.getAvailableIntelligence();
    
    return ListView.builder(
      itemCount: intelligence.length,
      itemBuilder: (context, index) {
        final intel = intelligence[index];
        return _buildIntelligenceCard(intel);
      },
    );
  }

  Widget _buildIntelligenceCard(MarketIntelligence intel) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.info, color: Colors.blue),
        title: Text('${intel.type.name} Intelligence'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(intel.information),
            Text('Value: \$${intel.value.toInt()}'),
            Text('Reliability: ${(intel.reliability * 100).toInt()}%'),
            Text('Expires: ${_formatDate(intel.expiration)}'),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () => _blackMarket.purchaseIntelligence(intel.id),
          child: const Text('Buy'),
        ),
        isThreeLine: true,
      ),
    );
  }

  void _attemptPurchase(String itemId, int quantity) {
    if (_selectedDealer == null) return;
    
    final transaction = _blackMarket.attemptTransaction(_selectedDealer!, itemId, quantity);
    
    if (transaction != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            transaction.isSuccessful 
              ? 'Transaction successful!' 
              : 'Transaction failed: ${transaction.failureReason}',
          ),
          backgroundColor: transaction.isSuccessful ? Colors.green : Colors.red,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transaction not possible'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _showDealerDetails(BlackMarketDealer dealer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(dealer.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${dealer.type.name}'),
            Text('Location: ${dealer.dealerData['location'] ?? 'Unknown'}'),
            Text('Contact: ${dealer.dealerData['contact_method'] ?? 'Unknown'}'),
            Text('Reputation: ${(dealer.reputation * 100).toInt()}%'),
            Text('Reliability: ${(dealer.reliability * 100).toInt()}%'),
            Text('Trust Level: ${(dealer.trustLevel * 100).toInt()}%'),
            if (dealer.dealerData['warning'] != null)
              Text('⚠️ ${dealer.dealerData['warning']}', style: const TextStyle(color: Colors.red)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Color _getHeatColor(MarketHeat heat) {
    switch (heat) {
      case MarketHeat.cold:
        return Colors.blue;
      case MarketHeat.cool:
        return Colors.green;
      case MarketHeat.warm:
        return Colors.orange;
      case MarketHeat.hot:
        return Colors.red;
      case MarketHeat.burning:
        return Colors.red[900]!;
    }
  }

  IconData _getHeatIcon(MarketHeat heat) {
    switch (heat) {
      case MarketHeat.cold:
        return Icons.ac_unit;
      case MarketHeat.cool:
        return Icons.check_circle;
      case MarketHeat.warm:
        return Icons.warning;
      case MarketHeat.hot:
        return Icons.local_fire_department;
      case MarketHeat.burning:
        return Icons.dangerous;
    }
  }

  Color _getDealerTypeColor(DealerType type) {
    switch (type) {
      case DealerType.streetDealer:
        return Colors.brown;
      case DealerType.undergroundBroker:
        return Colors.purple;
      case DealerType.cartellConnected:
        return Colors.red;
      case DealerType.internationalSmuggler:
        return Colors.black;
      case DealerType.corruptOfficial:
        return Colors.blue;
      case DealerType.techSpecialist:
        return Colors.cyan;
      case DealerType.weaponsExpert:
        return Colors.orange;
      case DealerType.informationBroker:
        return Colors.indigo;
    }
  }

  Color _getRiskColor(TransactionRisk risk) {
    switch (risk) {
      case TransactionRisk.minimal:
        return Colors.green;
      case TransactionRisk.low:
        return Colors.lightGreen;
      case TransactionRisk.moderate:
        return Colors.orange;
      case TransactionRisk.high:
        return Colors.red;
      case TransactionRisk.extreme:
        return Colors.red[900]!;
    }
  }

  IconData _getContrabandIcon(ContrabandType type) {
    switch (type) {
      case ContrabandType.weapons:
        return Icons.security;
      case ContrabandType.explosives:
        return Icons.fireplace;
      case ContrabandType.stolenGoods:
        return Icons.shopping_bag;
      case ContrabandType.illegalDrugs:
        return Icons.medication;
      case ContrabandType.counterfeitMoney:
        return Icons.attach_money;
      case ContrabandType.humanTrafficking:
        return Icons.person_off;
      case ContrabandType.organTrafficking:
        return Icons.health_and_safety;
      case ContrabandType.informationBroker:
        return Icons.info;
      case ContrabandType.hitmanServices:
        return Icons.dangerous;
      case ContrabandType.corruptionServices:
        return Icons.gavel;
      case ContrabandType.stolenVehicles:
        return Icons.directions_car;
      case ContrabandType.forbiddenTechnology:
        return Icons.computer;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
