import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

// Advanced Real Estate Empire System
// Feature #23: Ultra-comprehensive property management with
// real estate acquisition, property development, rental income, and empire expansion

enum PropertyType {
  residential,
  commercial,
  industrial,
  luxury,
  warehouse,
  nightclub,
  casino,
  hotel,
  safehouse,
  fronts,
  offshore,
  penthouse
}

enum PropertyCondition {
  ruins,
  poor,
  fair,
  good,
  excellent,
  luxury
}

enum PropertyStatus {
  available,
  owned,
  rented,
  underDevelopment,
  seized,
  abandoned,
  hidden
}

enum DevelopmentType {
  renovation,
  expansion,
  securityUpgrade,
  luxuryUpgrade,
  hiddenFeatures,
  defensiveModifications,
  businessFront,
  moneyLaunderingFacility
}

class RealEstateProperty {
  final String id;
  final String name;
  final PropertyType type;
  final String address;
  final double squareFeet;
  final double purchasePrice;
  final double currentValue;
  final double monthlyIncome;
  final double monthlyExpenses;
  final PropertyCondition condition;
  final PropertyStatus status;
  final List<String> features;
  final Map<String, dynamic> hiddenFeatures;
  final DateTime purchaseDate;
  final double appreciationRate;
  final bool isLaunderingFacility;
  final double securityLevel;
  final List<DevelopmentType> developments;

  RealEstateProperty({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.squareFeet,
    required this.purchasePrice,
    required this.currentValue,
    this.monthlyIncome = 0.0,
    this.monthlyExpenses = 0.0,
    this.condition = PropertyCondition.fair,
    this.status = PropertyStatus.available,
    this.features = const [],
    this.hiddenFeatures = const {},
    required this.purchaseDate,
    this.appreciationRate = 0.05,
    this.isLaunderingFacility = false,
    this.securityLevel = 0.5,
    this.developments = const [],
  });

  RealEstateProperty copyWith({
    String? id,
    String? name,
    PropertyType? type,
    String? address,
    double? squareFeet,
    double? purchasePrice,
    double? currentValue,
    double? monthlyIncome,
    double? monthlyExpenses,
    PropertyCondition? condition,
    PropertyStatus? status,
    List<String>? features,
    Map<String, dynamic>? hiddenFeatures,
    DateTime? purchaseDate,
    double? appreciationRate,
    bool? isLaunderingFacility,
    double? securityLevel,
    List<DevelopmentType>? developments,
  }) {
    return RealEstateProperty(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      address: address ?? this.address,
      squareFeet: squareFeet ?? this.squareFeet,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      currentValue: currentValue ?? this.currentValue,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      monthlyExpenses: monthlyExpenses ?? this.monthlyExpenses,
      condition: condition ?? this.condition,
      status: status ?? this.status,
      features: features ?? this.features,
      hiddenFeatures: hiddenFeatures ?? this.hiddenFeatures,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      appreciationRate: appreciationRate ?? this.appreciationRate,
      isLaunderingFacility: isLaunderingFacility ?? this.isLaunderingFacility,
      securityLevel: securityLevel ?? this.securityLevel,
      developments: developments ?? this.developments,
    );
  }

  double get netMonthlyIncome => monthlyIncome - monthlyExpenses;
  double get roi => netMonthlyIncome * 12 / purchasePrice;
  double get totalInvestment => purchasePrice + (developments.length * 50000);
  double get equityValue => currentValue - totalInvestment;
  
  double get conditionMultiplier {
    switch (condition) {
      case PropertyCondition.ruins:
        return 0.3;
      case PropertyCondition.poor:
        return 0.6;
      case PropertyCondition.fair:
        return 1.0;
      case PropertyCondition.good:
        return 1.3;
      case PropertyCondition.excellent:
        return 1.6;
      case PropertyCondition.luxury:
        return 2.0;
    }
  }
}

class PropertyDevelopment {
  final String id;
  final String propertyId;
  final DevelopmentType type;
  final double cost;
  final int durationDays;
  final DateTime startDate;
  final DateTime? completionDate;
  final bool isCompleted;
  final Map<String, dynamic> specifications;

  PropertyDevelopment({
    required this.id,
    required this.propertyId,
    required this.type,
    required this.cost,
    required this.durationDays,
    required this.startDate,
    this.completionDate,
    this.isCompleted = false,
    this.specifications = const {},
  });

  PropertyDevelopment copyWith({
    String? id,
    String? propertyId,
    DevelopmentType? type,
    double? cost,
    int? durationDays,
    DateTime? startDate,
    DateTime? completionDate,
    bool? isCompleted,
    Map<String, dynamic>? specifications,
  }) {
    return PropertyDevelopment(
      id: id ?? this.id,
      propertyId: propertyId ?? this.propertyId,
      type: type ?? this.type,
      cost: cost ?? this.cost,
      durationDays: durationDays ?? this.durationDays,
      startDate: startDate ?? this.startDate,
      completionDate: completionDate ?? this.completionDate,
      isCompleted: isCompleted ?? this.isCompleted,
      specifications: specifications ?? this.specifications,
    );
  }

  DateTime get expectedCompletion => startDate.add(Duration(days: durationDays));
  bool get isOverdue => !isCompleted && DateTime.now().isAfter(expectedCompletion);
  double get progressPercentage {
    if (isCompleted) return 1.0;
    
    final elapsed = DateTime.now().difference(startDate).inDays;
    return (elapsed / durationDays).clamp(0.0, 1.0);
  }
}

class RealEstateTenant {
  final String id;
  final String name;
  final String propertyId;
  final double monthlyRent;
  final DateTime leaseStart;
  final DateTime leaseEnd;
  final double securityDeposit;
  final bool isReliable;
  final double paymentHistory;
  final Map<String, dynamic> tenantData;

  RealEstateTenant({
    required this.id,
    required this.name,
    required this.propertyId,
    required this.monthlyRent,
    required this.leaseStart,
    required this.leaseEnd,
    this.securityDeposit = 0.0,
    this.isReliable = true,
    this.paymentHistory = 1.0,
    this.tenantData = const {},
  });

  bool get isLeaseActive => DateTime.now().isBefore(leaseEnd);
  bool get isLeaseExpiringSoon => 
      leaseEnd.difference(DateTime.now()).inDays <= 30;
}

class PropertyTransaction {
  final String id;
  final String propertyId;
  final String type; // purchase, sale, rental
  final double amount;
  final DateTime date;
  final String? counterparty;
  final Map<String, dynamic> details;

  PropertyTransaction({
    required this.id,
    required this.propertyId,
    required this.type,
    required this.amount,
    required this.date,
    this.counterparty,
    this.details = const {},
  });
}

class AdvancedRealEstateSystem extends ChangeNotifier {
  static final AdvancedRealEstateSystem _instance = AdvancedRealEstateSystem._internal();
  factory AdvancedRealEstateSystem() => _instance;
  AdvancedRealEstateSystem._internal() {
    _initializeSystem();
  }

  final Map<String, RealEstateProperty> _properties = {};
  final Map<String, PropertyDevelopment> _developments = {};
  final Map<String, RealEstateTenant> _tenants = {};
  final Map<String, PropertyTransaction> _transactions = {};
  
  String? _playerId;
  double _totalPortfolioValue = 0.0;
  double _monthlyRentalIncome = 0.0;
  double _monthlyExpenses = 0.0;
  int _totalProperties = 0;
  double _liquidityRatio = 0.8;
  double _empireReputation = 0.5;
  
  Timer? _systemTimer;
  final math.Random _random = math.Random();

  // Getters
  Map<String, RealEstateProperty> get properties => Map.unmodifiable(_properties);
  Map<String, PropertyDevelopment> get developments => Map.unmodifiable(_developments);
  Map<String, RealEstateTenant> get tenants => Map.unmodifiable(_tenants);
  Map<String, PropertyTransaction> get transactions => Map.unmodifiable(_transactions);
  String? get playerId => _playerId;
  double get totalPortfolioValue => _totalPortfolioValue;
  double get monthlyRentalIncome => _monthlyRentalIncome;
  double get monthlyExpenses => _monthlyExpenses;
  double get netMonthlyIncome => _monthlyRentalIncome - _monthlyExpenses;
  int get totalProperties => _totalProperties;
  double get liquidityRatio => _liquidityRatio;
  double get empireReputation => _empireReputation;

  void _initializeSystem() {
    _playerId = 'player_${DateTime.now().millisecondsSinceEpoch}';
    _generateAvailableProperties();
    _startSystemTimer();
  }

  void _generateAvailableProperties() {
    final propertyDefinitions = _getPropertyDefinitions();
    
    for (final property in propertyDefinitions) {
      _properties[property.id] = property;
    }
  }

  List<RealEstateProperty> _getPropertyDefinitions() {
    return [
      // Residential Properties
      RealEstateProperty(
        id: 'prop_downtown_apartment',
        name: 'Downtown Luxury Apartment',
        type: PropertyType.residential,
        address: '123 Main Street, Downtown',
        squareFeet: 1200.0,
        purchasePrice: 350000.0,
        currentValue: 350000.0,
        monthlyIncome: 2800.0,
        monthlyExpenses: 800.0,
        condition: PropertyCondition.good,
        purchaseDate: DateTime.now(),
        features: ['balcony', 'parking', 'security'],
      ),
      
      RealEstateProperty(
        id: 'prop_suburban_house',
        name: 'Suburban Family Home',
        type: PropertyType.residential,
        address: '456 Oak Drive, Suburbs',
        squareFeet: 2400.0,
        purchasePrice: 480000.0,
        currentValue: 480000.0,
        monthlyIncome: 3200.0,
        monthlyExpenses: 1200.0,
        condition: PropertyCondition.excellent,
        purchaseDate: DateTime.now(),
        features: ['garden', 'garage', 'basement'],
      ),
      
      // Commercial Properties
      RealEstateProperty(
        id: 'prop_office_building',
        name: 'Corporate Office Complex',
        type: PropertyType.commercial,
        address: '789 Business Blvd, Financial District',
        squareFeet: 15000.0,
        purchasePrice: 2500000.0,
        currentValue: 2500000.0,
        monthlyIncome: 18000.0,
        monthlyExpenses: 5000.0,
        condition: PropertyCondition.good,
        purchaseDate: DateTime.now(),
        features: ['elevator', 'parking_lot', 'conference_rooms'],
      ),
      
      RealEstateProperty(
        id: 'prop_shopping_center',
        name: 'Riverside Shopping Center',
        type: PropertyType.commercial,
        address: '321 Commerce Way, Riverside',
        squareFeet: 25000.0,
        purchasePrice: 4200000.0,
        currentValue: 4200000.0,
        monthlyIncome: 32000.0,
        monthlyExpenses: 8000.0,
        condition: PropertyCondition.fair,
        purchaseDate: DateTime.now(),
        features: ['food_court', 'anchor_stores', 'parking_garage'],
      ),
      
      // Industrial Properties
      RealEstateProperty(
        id: 'prop_warehouse_complex',
        name: 'Industrial Warehouse Complex',
        type: PropertyType.warehouse,
        address: '654 Industrial Road, Port District',
        squareFeet: 50000.0,
        purchasePrice: 1800000.0,
        currentValue: 1800000.0,
        monthlyIncome: 12000.0,
        monthlyExpenses: 3000.0,
        condition: PropertyCondition.good,
        purchaseDate: DateTime.now(),
        features: ['loading_docks', 'rail_access', 'security_fence'],
        hiddenFeatures: {'storage_capacity': 'unlimited', 'discrete_access': true},
      ),
      
      // Luxury Properties
      RealEstateProperty(
        id: 'prop_penthouse_suite',
        name: 'Executive Penthouse Suite',
        type: PropertyType.penthouse,
        address: '1 Skyline Tower, Elite District',
        squareFeet: 5000.0,
        purchasePrice: 8500000.0,
        currentValue: 8500000.0,
        monthlyIncome: 0.0, // Personal use
        monthlyExpenses: 2500.0,
        condition: PropertyCondition.luxury,
        purchaseDate: DateTime.now(),
        features: ['rooftop_terrace', 'private_elevator', 'smart_home', 'wine_cellar'],
        hiddenFeatures: {'panic_room': true, 'escape_routes': 3},
        securityLevel: 0.9,
      ),
      
      // Entertainment Properties
      RealEstateProperty(
        id: 'prop_nightclub_downtown',
        name: 'Neon Nights Club',
        type: PropertyType.nightclub,
        address: '888 Party Avenue, Entertainment District',
        squareFeet: 8000.0,
        purchasePrice: 3200000.0,
        currentValue: 3200000.0,
        monthlyIncome: 45000.0,
        monthlyExpenses: 15000.0,
        condition: PropertyCondition.excellent,
        purchaseDate: DateTime.now(),
        features: ['dance_floor', 'vip_rooms', 'full_bar', 'sound_system'],
        isLaunderingFacility: true,
      ),
      
      RealEstateProperty(
        id: 'prop_casino_riverside',
        name: 'Golden River Casino',
        type: PropertyType.casino,
        address: '777 Lucky Street, Riverside',
        squareFeet: 20000.0,
        purchasePrice: 12000000.0,
        currentValue: 12000000.0,
        monthlyIncome: 150000.0,
        monthlyExpenses: 50000.0,
        condition: PropertyCondition.luxury,
        purchaseDate: DateTime.now(),
        features: ['slot_machines', 'poker_rooms', 'restaurant', 'hotel_rooms'],
        isLaunderingFacility: true,
        securityLevel: 0.8,
      ),
      
      // Business Fronts
      RealEstateProperty(
        id: 'prop_laundromat_chain',
        name: 'Clean & Fresh Laundromat',
        type: PropertyType.fronts,
        address: '432 Wash Street, Various Locations',
        squareFeet: 3000.0,
        purchasePrice: 450000.0,
        currentValue: 450000.0,
        monthlyIncome: 8000.0,
        monthlyExpenses: 2000.0,
        condition: PropertyCondition.fair,
        purchaseDate: DateTime.now(),
        features: ['coin_operated', 'drop_off_service'],
        isLaunderingFacility: true,
        hiddenFeatures: {'cash_processing': 50000, 'investigation_risk': 0.1},
      ),
      
      // Safe Houses
      RealEstateProperty(
        id: 'prop_safehouse_rural',
        name: 'Remote Country Cabin',
        type: PropertyType.safehouse,
        address: 'Hidden Location, Rural County',
        squareFeet: 1800.0,
        purchasePrice: 280000.0,
        currentValue: 280000.0,
        monthlyIncome: 0.0,
        monthlyExpenses: 500.0,
        condition: PropertyCondition.good,
        status: PropertyStatus.hidden,
        purchaseDate: DateTime.now(),
        features: ['off_grid_power', 'water_well', 'generator'],
        hiddenFeatures: {'weapons_cache': true, 'escape_tunnel': true, 'surveillance': true},
        securityLevel: 0.95,
      ),
    ];
  }

  void _startSystemTimer() {
    _systemTimer?.cancel();
    _systemTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _updatePropertyValues();
      _collectRentalIncome();
      _processOngoingDevelopments();
      _simulateMarketEvents();
      _updatePortfolioMetrics();
      notifyListeners();
    });
  }

  // Property Management
  bool purchaseProperty(String propertyId) {
    final property = _properties[propertyId];
    if (property == null || property.status != PropertyStatus.available) {
      return false;
    }
    
    // Check if player can afford it (simplified)
    // In real implementation, would check player's cash
    
    _properties[propertyId] = property.copyWith(
      status: PropertyStatus.owned,
      purchaseDate: DateTime.now(),
    );
    
    // Record transaction
    final transactionId = 'trans_${DateTime.now().millisecondsSinceEpoch}';
    _transactions[transactionId] = PropertyTransaction(
      id: transactionId,
      propertyId: propertyId,
      type: 'purchase',
      amount: property.purchasePrice,
      date: DateTime.now(),
    );
    
    _totalProperties++;
    _empireReputation = (_empireReputation + 0.02).clamp(0.0, 1.0);
    
    return true;
  }

  bool sellProperty(String propertyId) {
    final property = _properties[propertyId];
    if (property == null || property.status != PropertyStatus.owned) {
      return false;
    }
    
    final salePrice = property.currentValue * 0.95; // 5% transaction costs
    
    _properties[propertyId] = property.copyWith(
      status: PropertyStatus.available,
    );
    
    // Record transaction
    final transactionId = 'trans_${DateTime.now().millisecondsSinceEpoch}';
    _transactions[transactionId] = PropertyTransaction(
      id: transactionId,
      propertyId: propertyId,
      type: 'sale',
      amount: salePrice,
      date: DateTime.now(),
    );
    
    _totalProperties--;
    
    return true;
  }

  // Property Development
  String? startDevelopment(String propertyId, DevelopmentType type) {
    final property = _properties[propertyId];
    if (property == null || property.status != PropertyStatus.owned) {
      return null;
    }
    
    final developmentCost = _calculateDevelopmentCost(type, property);
    final developmentDuration = _calculateDevelopmentDuration(type);
    
    final developmentId = 'dev_${DateTime.now().millisecondsSinceEpoch}';
    
    _developments[developmentId] = PropertyDevelopment(
      id: developmentId,
      propertyId: propertyId,
      type: type,
      cost: developmentCost,
      durationDays: developmentDuration,
      startDate: DateTime.now(),
    );
    
    // Update property status
    _properties[propertyId] = property.copyWith(
      status: PropertyStatus.underDevelopment,
    );
    
    return developmentId;
  }

  double _calculateDevelopmentCost(DevelopmentType type, RealEstateProperty property) {
    double baseCost = property.squareFeet * 50; // $50 per sq ft base
    
    switch (type) {
      case DevelopmentType.renovation:
        return baseCost * 1.0;
      case DevelopmentType.expansion:
        return baseCost * 2.0;
      case DevelopmentType.securityUpgrade:
        return baseCost * 0.5;
      case DevelopmentType.luxuryUpgrade:
        return baseCost * 3.0;
      case DevelopmentType.hiddenFeatures:
        return baseCost * 1.5;
      case DevelopmentType.defensiveModifications:
        return baseCost * 2.5;
      case DevelopmentType.businessFront:
        return baseCost * 1.2;
      case DevelopmentType.moneyLaunderingFacility:
        return baseCost * 4.0;
    }
  }

  int _calculateDevelopmentDuration(DevelopmentType type) {
    switch (type) {
      case DevelopmentType.renovation:
        return 30;
      case DevelopmentType.expansion:
        return 90;
      case DevelopmentType.securityUpgrade:
        return 14;
      case DevelopmentType.luxuryUpgrade:
        return 60;
      case DevelopmentType.hiddenFeatures:
        return 45;
      case DevelopmentType.defensiveModifications:
        return 75;
      case DevelopmentType.businessFront:
        return 21;
      case DevelopmentType.moneyLaunderingFacility:
        return 120;
    }
  }

  void _completeDevelopment(String developmentId) {
    final development = _developments[developmentId];
    if (development == null || development.isCompleted) return;
    
    final property = _properties[development.propertyId];
    if (property == null) return;
    
    // Apply development effects
    RealEstateProperty updatedProperty = _applyDevelopmentEffects(property, development);
    
    _properties[development.propertyId] = updatedProperty.copyWith(
      status: PropertyStatus.owned,
      developments: [...property.developments, development.type],
    );
    
    _developments[developmentId] = development.copyWith(
      isCompleted: true,
      completionDate: DateTime.now(),
    );
  }

  RealEstateProperty _applyDevelopmentEffects(RealEstateProperty property, PropertyDevelopment development) {
    switch (development.type) {
      case DevelopmentType.renovation:
        return property.copyWith(
          condition: PropertyCondition.values[
            (property.condition.index + 1).clamp(0, PropertyCondition.values.length - 1)
          ],
          currentValue: property.currentValue * 1.15,
          monthlyIncome: property.monthlyIncome * 1.1,
        );
        
      case DevelopmentType.expansion:
        return property.copyWith(
          squareFeet: property.squareFeet * 1.3,
          currentValue: property.currentValue * 1.25,
          monthlyIncome: property.monthlyIncome * 1.2,
          monthlyExpenses: property.monthlyExpenses * 1.1,
        );
        
      case DevelopmentType.securityUpgrade:
        return property.copyWith(
          securityLevel: (property.securityLevel + 0.2).clamp(0.0, 1.0),
          currentValue: property.currentValue * 1.05,
          features: [...property.features, 'advanced_security'],
        );
        
      case DevelopmentType.luxuryUpgrade:
        return property.copyWith(
          condition: PropertyCondition.luxury,
          currentValue: property.currentValue * 1.5,
          monthlyIncome: property.monthlyIncome * 1.4,
          monthlyExpenses: property.monthlyExpenses * 1.2,
          features: [...property.features, 'luxury_amenities'],
        );
        
      case DevelopmentType.hiddenFeatures:
        return property.copyWith(
          currentValue: property.currentValue * 1.1,
          securityLevel: (property.securityLevel + 0.3).clamp(0.0, 1.0),
          hiddenFeatures: {
            ...property.hiddenFeatures,
            'secret_rooms': true,
            'hidden_storage': true,
          },
        );
        
      case DevelopmentType.businessFront:
        return property.copyWith(
          isLaunderingFacility: true,
          monthlyIncome: property.monthlyIncome * 1.3,
          hiddenFeatures: {
            ...property.hiddenFeatures,
            'legitimate_business': true,
            'cash_processing': 25000,
          },
        );
        
      case DevelopmentType.moneyLaunderingFacility:
        return property.copyWith(
          isLaunderingFacility: true,
          monthlyIncome: property.monthlyIncome * 2.0,
          securityLevel: (property.securityLevel + 0.4).clamp(0.0, 1.0),
          hiddenFeatures: {
            ...property.hiddenFeatures,
            'cash_processing': 100000,
            'financial_records': 'encrypted',
            'investigation_countermeasures': true,
          },
        );
        
      default:
        return property;
    }
  }

  // Tenant Management
  void addTenant(String propertyId, String tenantName, double monthlyRent) {
    final property = _properties[propertyId];
    if (property == null || property.status != PropertyStatus.owned) return;
    
    final tenantId = 'tenant_${DateTime.now().millisecondsSinceEpoch}';
    
    _tenants[tenantId] = RealEstateTenant(
      id: tenantId,
      name: tenantName,
      propertyId: propertyId,
      monthlyRent: monthlyRent,
      leaseStart: DateTime.now(),
      leaseEnd: DateTime.now().add(const Duration(days: 365)),
      securityDeposit: monthlyRent * 2,
      isReliable: _random.nextDouble() > 0.3,
      paymentHistory: 0.8 + _random.nextDouble() * 0.2,
    );
    
    // Update property status and income
    _properties[propertyId] = property.copyWith(
      status: PropertyStatus.rented,
      monthlyIncome: monthlyRent,
    );
  }

  void evictTenant(String tenantId) {
    final tenant = _tenants[tenantId];
    if (tenant == null) return;
    
    final property = _properties[tenant.propertyId];
    if (property != null) {
      _properties[tenant.propertyId] = property.copyWith(
        status: PropertyStatus.owned,
        monthlyIncome: 0.0,
      );
    }
    
    _tenants.remove(tenantId);
  }

  // System Updates
  void _updatePropertyValues() {
    for (final propertyId in _properties.keys.toList()) {
      final property = _properties[propertyId]!;
      
      if (property.status == PropertyStatus.owned || property.status == PropertyStatus.rented) {
        // Market appreciation with some randomness
        final marketChange = 1.0 + (property.appreciationRate / 12) + (_random.nextDouble() - 0.5) * 0.02;
        
        _properties[propertyId] = property.copyWith(
          currentValue: property.currentValue * marketChange,
        );
      }
    }
  }

  void _collectRentalIncome() {
    // Simplified rental collection
    // In real implementation, would process individual tenant payments
    for (final tenant in _tenants.values) {
      if (tenant.isLeaseActive) {
        final paymentSuccess = tenant.isReliable && _random.nextDouble() < tenant.paymentHistory;
        
        if (paymentSuccess) {
          // Record rental income transaction
          final transactionId = 'rent_${DateTime.now().millisecondsSinceEpoch}';
          _transactions[transactionId] = PropertyTransaction(
            id: transactionId,
            propertyId: tenant.propertyId,
            type: 'rental',
            amount: tenant.monthlyRent,
            date: DateTime.now(),
            counterparty: tenant.name,
          );
        }
      }
    }
  }

  void _processOngoingDevelopments() {
    for (final developmentId in _developments.keys.toList()) {
      final development = _developments[developmentId]!;
      
      if (!development.isCompleted && 
          DateTime.now().isAfter(development.expectedCompletion)) {
        _completeDevelopment(developmentId);
      }
    }
  }

  void _simulateMarketEvents() {
    if (_random.nextDouble() < 0.05) {
      _generateRandomMarketEvent();
    }
  }

  void _generateRandomMarketEvent() {
    final events = [
      'market_boom',
      'market_crash',
      'gentrification',
      'tax_assessment',
      'zoning_changes',
      'natural_disaster',
    ];
    
    final event = events[_random.nextInt(events.length)];
    _handleMarketEvent(event);
  }

  void _handleMarketEvent(String event) {
    switch (event) {
      case 'market_boom':
        // All property values increase
        for (final propertyId in _properties.keys.toList()) {
          final property = _properties[propertyId]!;
          _properties[propertyId] = property.copyWith(
            currentValue: property.currentValue * 1.15,
            appreciationRate: (property.appreciationRate + 0.02).clamp(0.0, 0.2),
          );
        }
        break;
        
      case 'market_crash':
        // Property values decrease
        for (final propertyId in _properties.keys.toList()) {
          final property = _properties[propertyId]!;
          _properties[propertyId] = property.copyWith(
            currentValue: property.currentValue * 0.85,
            appreciationRate: (property.appreciationRate - 0.03).clamp(-0.1, 0.2),
          );
        }
        break;
        
      case 'gentrification':
        // Residential properties in certain areas increase in value
        final residentialProperties = _properties.values
            .where((p) => p.type == PropertyType.residential)
            .toList();
        
        for (final property in residentialProperties) {
          if (_random.nextDouble() < 0.3) {
            _properties[property.id] = property.copyWith(
              currentValue: property.currentValue * 1.25,
              monthlyIncome: property.monthlyIncome * 1.2,
            );
          }
        }
        break;
        
      case 'tax_assessment':
        // Increase monthly expenses for all properties
        for (final propertyId in _properties.keys.toList()) {
          final property = _properties[propertyId]!;
          _properties[propertyId] = property.copyWith(
            monthlyExpenses: property.monthlyExpenses * 1.1,
          );
        }
        break;
    }
  }

  void _updatePortfolioMetrics() {
    _totalPortfolioValue = 0.0;
    _monthlyRentalIncome = 0.0;
    _monthlyExpenses = 0.0;
    _totalProperties = 0;
    
    for (final property in _properties.values) {
      if (property.status == PropertyStatus.owned || property.status == PropertyStatus.rented) {
        _totalPortfolioValue += property.currentValue;
        _monthlyRentalIncome += property.monthlyIncome;
        _monthlyExpenses += property.monthlyExpenses;
        _totalProperties++;
      }
    }
    
    // Calculate liquidity ratio
    final liquidAssets = _totalPortfolioValue * 0.1; // Assume 10% can be quickly liquidated
    final totalInvestment = _properties.values
        .where((p) => p.status == PropertyStatus.owned || p.status == PropertyStatus.rented)
        .fold(0.0, (sum, p) => sum + p.totalInvestment);
    
    _liquidityRatio = liquidAssets / (totalInvestment > 0 ? totalInvestment : 1);
  }

  // Public Interface Methods
  List<RealEstateProperty> getAvailableProperties() {
    return _properties.values
        .where((p) => p.status == PropertyStatus.available)
        .toList()
      ..sort((a, b) => a.purchasePrice.compareTo(b.purchasePrice));
  }

  List<RealEstateProperty> getOwnedProperties() {
    return _properties.values
        .where((p) => p.status == PropertyStatus.owned || p.status == PropertyStatus.rented)
        .toList()
      ..sort((a, b) => b.currentValue.compareTo(a.currentValue));
  }

  List<PropertyDevelopment> getActiveAevelopments() {
    return _developments.values
        .where((d) => !d.isCompleted)
        .toList()
      ..sort((a, b) => a.expectedCompletion.compareTo(b.expectedCompletion));
  }

  List<RealEstateTenant> getActiveTenants() {
    return _tenants.values
        .where((t) => t.isLeaseActive)
        .toList()
      ..sort((a, b) => a.leaseEnd.compareTo(b.leaseEnd));
  }

  List<PropertyTransaction> getRecentTransactions({int limit = 20}) {
    return _transactions.values
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date))
      ..take(limit);
  }

  double calculatePropertyROI(String propertyId) {
    final property = _properties[propertyId];
    return property?.roi ?? 0.0;
  }

  double calculatePortfolioROI() {
    if (_totalPortfolioValue == 0) return 0.0;
    return (_monthlyRentalIncome * 12) / _totalPortfolioValue;
  }

  List<RealEstateProperty> getLaunderingFacilities() {
    return _properties.values
        .where((p) => p.isLaunderingFacility && 
               (p.status == PropertyStatus.owned || p.status == PropertyStatus.rented))
        .toList();
  }

  double getTotalLaunderingCapacity() {
    return getLaunderingFacilities()
        .fold(0.0, (sum, property) {
          final capacity = property.hiddenFeatures['cash_processing'] ?? 0;
          return sum + (capacity is num ? capacity.toDouble() : 0);
        });
  }

  void dispose() {
    _systemTimer?.cancel();
    super.dispose();
  }
}

// Advanced Real Estate Dashboard Widget
class AdvancedRealEstateDashboardWidget extends StatefulWidget {
  const AdvancedRealEstateDashboardWidget({super.key});

  @override
  State<AdvancedRealEstateDashboardWidget> createState() => _AdvancedRealEstateDashboardWidgetState();
}

class _AdvancedRealEstateDashboardWidgetState extends State<AdvancedRealEstateDashboardWidget>
    with TickerProviderStateMixin {
  final AdvancedRealEstateSystem _realEstate = AdvancedRealEstateSystem();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _realEstate,
      builder: (context, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                _buildPortfolioMetrics(),
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
        const Icon(Icons.business, color: Colors.green),
        const SizedBox(width: 8),
        const Text(
          'Real Estate Empire',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Text('Portfolio: \$${(_realEstate.totalPortfolioValue / 1000000).toStringAsFixed(1)}M'),
      ],
    );
  }

  Widget _buildPortfolioMetrics() {
    return Card(
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                _buildMetricCard('Total Value', '\$${(_realEstate.totalPortfolioValue / 1000).toInt()}K'),
                _buildMetricCard('Properties', '${_realEstate.totalProperties}'),
                _buildMetricCard('Monthly Income', '\$${_realEstate.netMonthlyIncome.toInt()}'),
                _buildMetricCard('ROI', '${(_realEstate.calculatePortfolioROI() * 100).toStringAsFixed(1)}%'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Empire Reputation', style: TextStyle(fontWeight: FontWeight.bold)),
                      LinearProgressIndicator(
                        value: _realEstate.empireReputation,
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                      Text('${(_realEstate.empireReputation * 100).toInt()}%'),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Liquidity Ratio', style: TextStyle(fontWeight: FontWeight.bold)),
                      LinearProgressIndicator(
                        value: _realEstate.liquidityRatio,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _realEstate.liquidityRatio > 0.5 ? Colors.green : Colors.orange,
                        ),
                      ),
                      Text('${(_realEstate.liquidityRatio * 100).toInt()}%'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String label, String value) {
    return Expanded(
      child: Card(
        color: Colors.white,
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

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      tabs: const [
        Tab(text: 'Portfolio', icon: Icon(Icons.home)),
        Tab(text: 'Market', icon: Icon(Icons.store)),
        Tab(text: 'Development', icon: Icon(Icons.construction)),
        Tab(text: 'Tenants', icon: Icon(Icons.people)),
        Tab(text: 'Laundering', icon: Icon(Icons.money_off)),
      ],
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildPortfolioTab(),
        _buildMarketTab(),
        _buildDevelopmentTab(),
        _buildTenantsTab(),
        _buildLaunderingTab(),
      ],
    );
  }

  Widget _buildPortfolioTab() {
    final properties = _realEstate.getOwnedProperties();
    
    return ListView.builder(
      itemCount: properties.length,
      itemBuilder: (context, index) {
        final property = properties[index];
        return _buildPropertyCard(property, isOwned: true);
      },
    );
  }

  Widget _buildMarketTab() {
    final properties = _realEstate.getAvailableProperties();
    
    return ListView.builder(
      itemCount: properties.length,
      itemBuilder: (context, index) {
        final property = properties[index];
        return _buildPropertyCard(property, isOwned: false);
      },
    );
  }

  Widget _buildPropertyCard(RealEstateProperty property, {required bool isOwned}) {
    return Card(
      child: ExpansionTile(
        leading: Icon(
          _getPropertyTypeIcon(property.type),
          color: _getPropertyTypeColor(property.type),
        ),
        title: Text(property.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${property.address}'),
            Text('${property.squareFeet.toInt()} sq ft - ${property.condition.name}'),
            if (isOwned)
              Text('ROI: ${(property.roi * 100).toStringAsFixed(1)}% - Value: \$${property.currentValue.toInt()}')
            else
              Text('Price: \$${property.purchasePrice.toInt()}'),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isOwned) ...[
                  Text('Purchase Price: \$${property.purchasePrice.toInt()}'),
                  Text('Current Value: \$${property.currentValue.toInt()}'),
                  Text('Monthly Income: \$${property.monthlyIncome.toInt()}'),
                  Text('Monthly Expenses: \$${property.monthlyExpenses.toInt()}'),
                  Text('Net Monthly: \$${property.netMonthlyIncome.toInt()}'),
                  if (property.isLaunderingFacility)
                    const Text('💰 Money Laundering Facility', style: TextStyle(color: Colors.red)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      ElevatedButton(
                        onPressed: () => _showDevelopmentOptions(property),
                        child: const Text('Develop'),
                      ),
                      ElevatedButton(
                        onPressed: () => _sellProperty(property.id),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text('Sell'),
                      ),
                      if (property.status == PropertyStatus.owned)
                        ElevatedButton(
                          onPressed: () => _addTenant(property.id),
                          child: const Text('Add Tenant'),
                        ),
                    ],
                  ),
                ] else ...[
                  Text('Purchase Price: \$${property.purchasePrice.toInt()}'),
                  Text('Monthly Income Potential: \$${property.monthlyIncome.toInt()}'),
                  Text('Features: ${property.features.join(', ')}'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _purchaseProperty(property.id),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Purchase'),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDevelopmentTab() {
    final developments = _realEstate.getActiveAevelopments();
    
    return ListView.builder(
      itemCount: developments.length,
      itemBuilder: (context, index) {
        final development = developments[index];
        return _buildDevelopmentCard(development);
      },
    );
  }

  Widget _buildDevelopmentCard(PropertyDevelopment development) {
    final property = _realEstate.properties[development.propertyId];
    
    return Card(
      child: ListTile(
        leading: CircularProgressIndicator(
          value: development.progressPercentage,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            development.isOverdue ? Colors.red : Colors.blue,
          ),
        ),
        title: Text('${development.type.name} - ${property?.name ?? 'Unknown'}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cost: \$${development.cost.toInt()}'),
            Text('Expected Completion: ${_formatDate(development.expectedCompletion)}'),
            Text('Progress: ${(development.progressPercentage * 100).toInt()}%'),
            if (development.isOverdue)
              const Text('OVERDUE', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildTenantsTab() {
    final tenants = _realEstate.getActiveTenants();
    
    return ListView.builder(
      itemCount: tenants.length,
      itemBuilder: (context, index) {
        final tenant = tenants[index];
        return _buildTenantCard(tenant);
      },
    );
  }

  Widget _buildTenantCard(RealEstateTenant tenant) {
    final property = _realEstate.properties[tenant.propertyId];
    
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: tenant.isReliable ? Colors.green : Colors.orange,
          child: Text(tenant.name[0]),
        ),
        title: Text(tenant.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Property: ${property?.name ?? 'Unknown'}'),
            Text('Rent: \$${tenant.monthlyRent.toInt()}/month'),
            Text('Lease Ends: ${_formatDate(tenant.leaseEnd)}'),
            Text('Payment History: ${(tenant.paymentHistory * 100).toInt()}%'),
            if (tenant.isLeaseExpiringSoon)
              const Text('LEASE EXPIRING SOON', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.remove_circle, color: Colors.red),
          onPressed: () => _evictTenant(tenant.id),
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildLaunderingTab() {
    final facilities = _realEstate.getLaunderingFacilities();
    final totalCapacity = _realEstate.getTotalLaunderingCapacity();
    
    return Column(
      children: [
        Card(
          color: Colors.red[50],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(Icons.money_off, color: Colors.red),
                const SizedBox(width: 8),
                Text('Total Laundering Capacity: \$${totalCapacity.toInt()}/month'),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: facilities.length,
            itemBuilder: (context, index) {
              final facility = facilities[index];
              return _buildLaunderingFacilityCard(facility);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLaunderingFacilityCard(RealEstateProperty facility) {
    final capacity = facility.hiddenFeatures['cash_processing'] ?? 0;
    final risk = facility.hiddenFeatures['investigation_risk'] ?? 0.5;
    
    return Card(
      child: ListTile(
        leading: const Icon(Icons.money_off, color: Colors.red),
        title: Text(facility.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Capacity: \$${capacity}/month'),
            Text('Investigation Risk: ${(risk * 100).toInt()}%'),
            Text('Security Level: ${(facility.securityLevel * 100).toInt()}%'),
          ],
        ),
        trailing: Text('${facility.type.name}'),
        isThreeLine: true,
      ),
    );
  }

  void _purchaseProperty(String propertyId) {
    final success = _realEstate.purchaseProperty(propertyId);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? 'Property purchased successfully!' : 'Purchase failed'),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  void _sellProperty(String propertyId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sell Property'),
        content: const Text('Are you sure you want to sell this property?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _realEstate.sellProperty(propertyId);
              Navigator.of(context).pop();
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Property sold'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sell'),
          ),
        ],
      ),
    );
  }

  void _showDevelopmentOptions(RealEstateProperty property) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Develop ${property.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: DevelopmentType.values.map((type) {
            final cost = _realEstate._calculateDevelopmentCost(type, property);
            final duration = _realEstate._calculateDevelopmentDuration(type);
            
            return ListTile(
              title: Text(type.name),
              subtitle: Text('Cost: \$${cost.toInt()} - Duration: ${duration} days'),
              onTap: () {
                _realEstate.startDevelopment(property.id, type);
                Navigator.of(context).pop();
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${type.name} development started'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _addTenant(String propertyId) {
    final nameController = TextEditingController();
    final rentController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Tenant'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Tenant Name'),
            ),
            TextField(
              controller: rentController,
              decoration: const InputDecoration(labelText: 'Monthly Rent'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text;
              final rent = double.tryParse(rentController.text) ?? 0;
              
              if (name.isNotEmpty && rent > 0) {
                _realEstate.addTenant(propertyId, name, rent);
                Navigator.of(context).pop();
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tenant added successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _evictTenant(String tenantId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Evict Tenant'),
        content: const Text('Are you sure you want to evict this tenant?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _realEstate.evictTenant(tenantId);
              Navigator.of(context).pop();
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tenant evicted'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Evict'),
          ),
        ],
      ),
    );
  }

  Color _getPropertyTypeColor(PropertyType type) {
    switch (type) {
      case PropertyType.residential:
        return Colors.blue;
      case PropertyType.commercial:
        return Colors.green;
      case PropertyType.industrial:
        return Colors.orange;
      case PropertyType.luxury:
        return Colors.purple;
      case PropertyType.warehouse:
        return Colors.brown;
      case PropertyType.nightclub:
        return Colors.pink;
      case PropertyType.casino:
        return Colors.red;
      case PropertyType.hotel:
        return Colors.teal;
      case PropertyType.safehouse:
        return Colors.black;
      case PropertyType.fronts:
        return Colors.grey;
      case PropertyType.offshore:
        return Colors.cyan;
      case PropertyType.penthouse:
        return Colors.amber;
    }
  }

  IconData _getPropertyTypeIcon(PropertyType type) {
    switch (type) {
      case PropertyType.residential:
        return Icons.home;
      case PropertyType.commercial:
        return Icons.business;
      case PropertyType.industrial:
        return Icons.factory;
      case PropertyType.luxury:
        return Icons.diamond;
      case PropertyType.warehouse:
        return Icons.warehouse;
      case PropertyType.nightclub:
        return Icons.nightlife;
      case PropertyType.casino:
        return Icons.casino;
      case PropertyType.hotel:
        return Icons.hotel;
      case PropertyType.safehouse:
        return Icons.security;
      case PropertyType.fronts:
        return Icons.store;
      case PropertyType.offshore:
        return Icons.sailing;
      case PropertyType.penthouse:
        return Icons.apartment;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
