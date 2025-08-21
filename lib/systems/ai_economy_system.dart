import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';

enum MarketState {
  stable,
  bullish,
  bearish,
  volatile,
  crash,
  boom,
}

enum EconomicFactor {
  lawEnforcement,
  competition,
  demand,
  supply,
  seasonality,
  events,
  reputation,
  territory,
}

enum CustomerType {
  casual,
  regular,
  addicted,
  dealer,
  tourist,
  rich,
  desperate,
}

class MarketData {
  final String drugType;
  final double basePrice;
  final double currentPrice;
  final double demand;
  final double supply;
  final double volatility;
  final MarketState state;
  final List<double> priceHistory;
  final Map<EconomicFactor, double> factors;
  final DateTime lastUpdate;

  const MarketData({
    required this.drugType,
    required this.basePrice,
    required this.currentPrice,
    required this.demand,
    required this.supply,
    required this.volatility,
    required this.state,
    required this.priceHistory,
    required this.factors,
    required this.lastUpdate,
  });
}

class EconomicEvent {
  final String id;
  final String name;
  final String description;
  final EconomicFactor primaryFactor;
  final Map<String, double> drugPriceMultipliers;
  final Duration duration;
  final DateTime startTime;
  final bool isActive;
  final double severity;

  const EconomicEvent({
    required this.id,
    required this.name,
    required this.description,
    required this.primaryFactor,
    required this.drugPriceMultipliers,
    required this.duration,
    required this.startTime,
    required this.isActive,
    required this.severity,
  });
}

class Customer {
  final String id;
  final CustomerType type;
  final String name;
  final Offset location;
  final Map<String, double> preferences; // drug_type -> preference
  final double budget;
  final double loyaltyToPlayer;
  final double riskTolerance;
  final DateTime lastPurchase;
  final List<String> purchaseHistory;
  final bool isUndercover;

  const Customer({
    required this.id,
    required this.type,
    required this.name,
    required this.location,
    required this.preferences,
    required this.budget,
    required this.loyaltyToPlayer,
    required this.riskTolerance,
    required this.lastPurchase,
    required this.purchaseHistory,
    required this.isUndercover,
  });
}

class Competitor {
  final String id;
  final String name;
  final Offset territory;
  final double marketShare;
  final double aggressiveness;
  final Map<String, double> prices;
  final double reputation;
  final double resources;
  final List<String> strategies;
  final bool isHostile;

  const Competitor({
    required this.id,
    required this.name,
    required this.territory,
    required this.marketShare,
    required this.aggressiveness,
    required this.prices,
    required this.reputation,
    required this.resources,
    required this.strategies,
    required this.isHostile,
  });
}

class AIEconomySystem {
  static final AIEconomySystem _instance = AIEconomySystem._internal();
  factory AIEconomySystem() => _instance;
  AIEconomySystem._internal();

  final Map<String, MarketData> _markets = {};
  final Map<String, Customer> _customers = {};
  final Map<String, Competitor> _competitors = {};
  final Map<String, EconomicEvent> _activeEvents = {};
  final List<EconomicEvent> _eventHistory = [];
  Timer? _economyTimer;
  
  static const int _maxPriceHistory = 100;
  static const Duration _updateInterval = Duration(minutes: 1);
  
  // Base market configuration
  static const Map<String, double> _basePrices = {
    'marijuana': 15.0,      // per gram
    'cocaine': 80.0,        // per gram
    'heroin': 100.0,        // per gram
    'methamphetamine': 50.0,// per gram
    'ecstasy': 20.0,        // per pill
    'lsd': 15.0,           // per tab
    'fentanyl': 200.0,     // per gram
  };

  static const Map<CustomerType, Map<String, double>> _customerPreferences = {
    CustomerType.casual: {
      'marijuana': 0.8,
      'ecstasy': 0.6,
      'cocaine': 0.3,
    },
    CustomerType.regular: {
      'marijuana': 0.7,
      'cocaine': 0.8,
      'methamphetamine': 0.6,
      'ecstasy': 0.5,
    },
    CustomerType.addicted: {
      'heroin': 0.9,
      'fentanyl': 0.8,
      'methamphetamine': 0.9,
      'cocaine': 0.7,
    },
    CustomerType.dealer: {
      'cocaine': 0.9,
      'heroin': 0.8,
      'methamphetamine': 0.8,
      'marijuana': 0.9,
    },
    CustomerType.tourist: {
      'marijuana': 0.9,
      'ecstasy': 0.7,
      'cocaine': 0.5,
    },
    CustomerType.rich: {
      'cocaine': 0.9,
      'ecstasy': 0.7,
      'lsd': 0.6,
    },
    CustomerType.desperate: {
      'heroin': 0.8,
      'fentanyl': 0.9,
      'methamphetamine': 0.7,
    },
  };

  void initialize() {
    _initializeMarkets();
    _generateCustomers();
    _generateCompetitors();
    _startEconomyTimer();
    _triggerRandomEvent();
  }

  void dispose() {
    _economyTimer?.cancel();
  }

  void _initializeMarkets() {
    for (final entry in _basePrices.entries) {
      final drugType = entry.key;
      final basePrice = entry.value;
      
      _markets[drugType] = MarketData(
        drugType: drugType,
        basePrice: basePrice,
        currentPrice: basePrice,
        demand: 0.5 + math.Random().nextDouble() * 0.5, // 0.5-1.0
        supply: 0.3 + math.Random().nextDouble() * 0.4, // 0.3-0.7
        volatility: 0.1 + math.Random().nextDouble() * 0.3, // 0.1-0.4
        state: MarketState.stable,
        priceHistory: [basePrice],
        factors: {
          for (final factor in EconomicFactor.values)
            factor: 0.5 + math.Random().nextDouble() * 0.5,
        },
        lastUpdate: DateTime.now(),
      );
    }
  }

  void _generateCustomers() {
    final random = math.Random();
    final names = [
      'Alex', 'Jamie', 'Chris', 'Taylor', 'Jordan', 'Casey', 'Morgan',
      'Riley', 'Avery', 'Quinn', 'Blake', 'Drew', 'Sage', 'River',
      'Phoenix', 'Reese', 'Dakota', 'Skyler', 'Emery', 'Finley'
    ];
    
    for (int i = 0; i < 50; i++) {
      final type = CustomerType.values[random.nextInt(CustomerType.values.length)];
      final preferences = Map<String, double>.from(_customerPreferences[type] ?? {});
      
      // Add some randomization to preferences
      for (final drug in preferences.keys) {
        preferences[drug] = (preferences[drug]! + (random.nextDouble() - 0.5) * 0.3).clamp(0.0, 1.0);
      }
      
      final customer = Customer(
        id: 'customer_$i',
        type: type,
        name: names[random.nextInt(names.length)] + ' ${random.nextInt(999)}',
        location: Offset(
          random.nextDouble() * 800,
          random.nextDouble() * 600,
        ),
        preferences: preferences,
        budget: _getCustomerBudget(type, random),
        loyaltyToPlayer: random.nextDouble(),
        riskTolerance: random.nextDouble(),
        lastPurchase: DateTime.now().subtract(Duration(days: random.nextInt(30))),
        purchaseHistory: [],
        isUndercover: random.nextDouble() < 0.05, // 5% chance undercover cop
      );
      
      _customers[customer.id] = customer;
    }
  }

  double _getCustomerBudget(CustomerType type, math.Random random) {
    switch (type) {
      case CustomerType.casual:
        return 50 + random.nextDouble() * 200;
      case CustomerType.regular:
        return 200 + random.nextDouble() * 500;
      case CustomerType.addicted:
        return 20 + random.nextDouble() * 100;
      case CustomerType.dealer:
        return 1000 + random.nextDouble() * 5000;
      case CustomerType.tourist:
        return 100 + random.nextDouble() * 300;
      case CustomerType.rich:
        return 500 + random.nextDouble() * 2000;
      case CustomerType.desperate:
        return 10 + random.nextDouble() * 50;
    }
  }

  void _generateCompetitors() {
    final competitorNames = [
      'The Cartel',
      'Street Kings',
      'Shadow Syndicate',
      'Urban Lions',
      'Night Wolves',
      'City Runners',
      'Black Market Inc',
      'Underground Empire',
    ];
    
    final random = math.Random();
    
    for (int i = 0; i < 5; i++) {
      final name = competitorNames[random.nextInt(competitorNames.length)];
      final aggressiveness = random.nextDouble();
      
      final prices = <String, double>{};
      for (final drug in _basePrices.keys) {
        final basePrice = _basePrices[drug]!;
        prices[drug] = basePrice * (0.7 + random.nextDouble() * 0.6); // 70%-130% of base
      }
      
      final competitor = Competitor(
        id: 'competitor_$i',
        name: name,
        territory: Offset(
          random.nextDouble() * 800,
          random.nextDouble() * 600,
        ),
        marketShare: 0.1 + random.nextDouble() * 0.3,
        aggressiveness: aggressiveness,
        prices: prices,
        reputation: random.nextDouble(),
        resources: 10000 + random.nextDouble() * 50000,
        strategies: _generateCompetitorStrategies(aggressiveness, random),
        isHostile: random.nextDouble() < 0.3,
      );
      
      _competitors[competitor.id] = competitor;
    }
  }

  List<String> _generateCompetitorStrategies(double aggressiveness, math.Random random) {
    final allStrategies = [
      'price_cutting',
      'quality_focus',
      'territory_expansion',
      'customer_loyalty',
      'product_diversification',
      'supply_disruption',
      'information_warfare',
      'violence_intimidation',
    ];
    
    final strategies = <String>[];
    final numStrategies = 2 + (aggressiveness * 4).round();
    
    for (int i = 0; i < numStrategies && strategies.length < allStrategies.length; i++) {
      final strategy = allStrategies[random.nextInt(allStrategies.length)];
      if (!strategies.contains(strategy)) {
        strategies.add(strategy);
      }
    }
    
    return strategies;
  }

  void _startEconomyTimer() {
    _economyTimer = Timer.periodic(_updateInterval, (timer) {
      _updateMarkets();
      _updateCustomers();
      _updateCompetitors();
      _processEvents();
      
      // Chance for new random event
      if (math.Random().nextDouble() < 0.1) { // 10% chance per update
        _triggerRandomEvent();
      }
    });
  }

  void _updateMarkets() {
    final random = math.Random();
    
    for (final drugType in _markets.keys) {
      final market = _markets[drugType]!;
      
      // Calculate new price based on supply/demand and external factors
      final supplyDemandRatio = market.supply / market.demand;
      final baseMultiplier = 1.0 / (supplyDemandRatio * 0.8 + 0.2);
      
      // Apply economic factors
      double factorMultiplier = 1.0;
      for (final factor in market.factors.entries) {
        factorMultiplier *= (0.5 + factor.value);
      }
      factorMultiplier = factorMultiplier / EconomicFactor.values.length;
      
      // Apply event effects
      double eventMultiplier = 1.0;
      for (final event in _activeEvents.values) {
        if (event.drugPriceMultipliers.containsKey(drugType)) {
          eventMultiplier *= event.drugPriceMultipliers[drugType]!;
        }
      }
      
      // Add volatility
      final volatilityChange = (random.nextDouble() - 0.5) * market.volatility;
      
      final newPrice = market.basePrice * baseMultiplier * factorMultiplier * eventMultiplier * (1.0 + volatilityChange);
      
      // Update price history
      final newHistory = List<double>.from(market.priceHistory)..add(newPrice);
      if (newHistory.length > _maxPriceHistory) {
        newHistory.removeAt(0);
      }
      
      // Determine market state
      final priceChange = newPrice - market.currentPrice;
      final MarketState newState;
      if (priceChange.abs() < market.currentPrice * 0.05) {
        newState = MarketState.stable;
      } else if (priceChange > market.currentPrice * 0.2) {
        newState = MarketState.boom;
      } else if (priceChange < -market.currentPrice * 0.2) {
        newState = MarketState.crash;
      } else if (priceChange > 0) {
        newState = MarketState.bullish;
      } else {
        newState = MarketState.bearish;
      }
      
      // Update demand and supply
      final newDemand = (market.demand + (random.nextDouble() - 0.5) * 0.1).clamp(0.1, 2.0);
      final newSupply = (market.supply + (random.nextDouble() - 0.5) * 0.1).clamp(0.1, 2.0);
      
      _markets[drugType] = MarketData(
        drugType: drugType,
        basePrice: market.basePrice,
        currentPrice: newPrice,
        demand: newDemand,
        supply: newSupply,
        volatility: market.volatility,
        state: newState,
        priceHistory: newHistory,
        factors: market.factors,
        lastUpdate: DateTime.now(),
      );
    }
  }

  void _updateCustomers() {
    final random = math.Random();
    
    for (final customerId in _customers.keys) {
      final customer = _customers[customerId]!;
      
      // Update customer preferences slightly over time
      final newPreferences = Map<String, double>.from(customer.preferences);
      for (final drug in newPreferences.keys) {
        final change = (random.nextDouble() - 0.5) * 0.02;
        newPreferences[drug] = (newPreferences[drug]! + change).clamp(0.0, 1.0);
      }
      
      // Update budget based on customer type
      double budgetChange = 0.0;
      switch (customer.type) {
        case CustomerType.dealer:
          budgetChange = customer.budget * (random.nextDouble() - 0.3) * 0.1; // Can lose money
          break;
        case CustomerType.rich:
          budgetChange = customer.budget * random.nextDouble() * 0.05; // Generally gain
          break;
        case CustomerType.addicted:
          budgetChange = -customer.budget * random.nextDouble() * 0.02; // Generally lose
          break;
        default:
          budgetChange = customer.budget * (random.nextDouble() - 0.5) * 0.03;
      }
      
      final newBudget = (customer.budget + budgetChange).clamp(0.0, double.infinity);
      
      _customers[customerId] = Customer(
        id: customer.id,
        type: customer.type,
        name: customer.name,
        location: customer.location,
        preferences: newPreferences,
        budget: newBudget,
        loyaltyToPlayer: customer.loyaltyToPlayer,
        riskTolerance: customer.riskTolerance,
        lastPurchase: customer.lastPurchase,
        purchaseHistory: customer.purchaseHistory,
        isUndercover: customer.isUndercover,
      );
    }
  }

  void _updateCompetitors() {
    final random = math.Random();
    
    for (final competitorId in _competitors.keys) {
      final competitor = _competitors[competitorId]!;
      
      // Update competitor prices based on their strategies
      final newPrices = Map<String, double>.from(competitor.prices);
      
      for (final drug in newPrices.keys) {
        final marketPrice = _markets[drug]?.currentPrice ?? _basePrices[drug]!;
        
        if (competitor.strategies.contains('price_cutting')) {
          newPrices[drug] = marketPrice * 0.9; // Undercut by 10%
        } else if (competitor.strategies.contains('quality_focus')) {
          newPrices[drug] = marketPrice * 1.2; // Premium pricing
        } else {
          // Follow market with some variation
          newPrices[drug] = marketPrice * (0.95 + random.nextDouble() * 0.1);
        }
      }
      
      // Update market share based on performance
      double shareChange = 0.0;
      if (competitor.strategies.contains('territory_expansion')) {
        shareChange += 0.005;
      }
      if (competitor.strategies.contains('customer_loyalty')) {
        shareChange += 0.003;
      }
      if (competitor.strategies.contains('violence_intimidation')) {
        shareChange += 0.007 - 0.01; // Short-term gain, long-term loss
      }
      
      shareChange += (random.nextDouble() - 0.5) * 0.01; // Random variation
      
      final newMarketShare = (competitor.marketShare + shareChange).clamp(0.0, 0.8);
      
      _competitors[competitorId] = Competitor(
        id: competitor.id,
        name: competitor.name,
        territory: competitor.territory,
        marketShare: newMarketShare,
        aggressiveness: competitor.aggressiveness,
        prices: newPrices,
        reputation: competitor.reputation,
        resources: competitor.resources,
        strategies: competitor.strategies,
        isHostile: competitor.isHostile,
      );
    }
  }

  void _processEvents() {
    final now = DateTime.now();
    final expiredEvents = <String>[];
    
    for (final eventId in _activeEvents.keys) {
      final event = _activeEvents[eventId]!;
      if (now.difference(event.startTime) >= event.duration) {
        expiredEvents.add(eventId);
        _eventHistory.add(event);
      }
    }
    
    for (final eventId in expiredEvents) {
      _activeEvents.remove(eventId);
    }
  }

  void _triggerRandomEvent() {
    final random = math.Random();
    final events = [
      _createPoliceRaidEvent(),
      _createSupplyShortageEvent(),
      _createDemandSurgeEvent(),
      _createCompetitorWarEvent(),
      _createSeasonalEvent(),
      _createNewsEvent(),
    ];
    
    final event = events[random.nextInt(events.length)];
    _activeEvents[event.id] = event;
    
    debugPrint('Economic Event: ${event.name} - ${event.description}');
  }

  EconomicEvent _createPoliceRaidEvent() {
    return EconomicEvent(
      id: 'police_raid_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Police Crackdown',
      description: 'Increased police activity raises prices and reduces supply',
      primaryFactor: EconomicFactor.lawEnforcement,
      drugPriceMultipliers: {
        for (final drug in _basePrices.keys)
          drug: 1.2 + math.Random().nextDouble() * 0.3,
      },
      duration: const Duration(hours: 6),
      startTime: DateTime.now(),
      isActive: true,
      severity: 0.7,
    );
  }

  EconomicEvent _createSupplyShortageEvent() {
    final drug = _basePrices.keys.elementAt(math.Random().nextInt(_basePrices.length));
    return EconomicEvent(
      id: 'shortage_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Supply Shortage',
      description: 'Major supplier busted, $drug prices spike',
      primaryFactor: EconomicFactor.supply,
      drugPriceMultipliers: {drug: 2.0 + math.Random().nextDouble()},
      duration: const Duration(hours: 12),
      startTime: DateTime.now(),
      isActive: true,
      severity: 0.8,
    );
  }

  EconomicEvent _createDemandSurgeEvent() {
    final drug = _basePrices.keys.elementAt(math.Random().nextInt(_basePrices.length));
    return EconomicEvent(
      id: 'surge_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Demand Surge',
      description: 'Major event increases demand for $drug',
      primaryFactor: EconomicFactor.demand,
      drugPriceMultipliers: {drug: 1.5 + math.Random().nextDouble() * 0.5},
      duration: const Duration(hours: 4),
      startTime: DateTime.now(),
      isActive: true,
      severity: 0.6,
    );
  }

  EconomicEvent _createCompetitorWarEvent() {
    return EconomicEvent(
      id: 'war_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Territory War',
      description: 'Gang war disrupts market stability',
      primaryFactor: EconomicFactor.competition,
      drugPriceMultipliers: {
        for (final drug in _basePrices.keys)
          drug: 0.8 + math.Random().nextDouble() * 0.4,
      },
      duration: const Duration(hours: 8),
      startTime: DateTime.now(),
      isActive: true,
      severity: 0.9,
    );
  }

  EconomicEvent _createSeasonalEvent() {
    return EconomicEvent(
      id: 'seasonal_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Seasonal Change',
      description: 'Season affects drug preferences and availability',
      primaryFactor: EconomicFactor.seasonality,
      drugPriceMultipliers: {
        'ecstasy': 1.3, // Party season
        'marijuana': 0.9, // More available
      },
      duration: const Duration(days: 1),
      startTime: DateTime.now(),
      isActive: true,
      severity: 0.3,
    );
  }

  EconomicEvent _createNewsEvent() {
    return EconomicEvent(
      id: 'news_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Media Coverage',
      description: 'News story affects public perception and demand',
      primaryFactor: EconomicFactor.events,
      drugPriceMultipliers: {
        for (final drug in _basePrices.keys)
          drug: 0.9 + math.Random().nextDouble() * 0.2,
      },
      duration: const Duration(hours: 3),
      startTime: DateTime.now(),
      isActive: true,
      severity: 0.4,
    );
  }

  // Public interface
  MarketData? getMarketData(String drugType) => _markets[drugType];
  List<MarketData> getAllMarkets() => _markets.values.toList();
  List<Customer> getCustomers() => _customers.values.toList();
  List<Competitor> getCompetitors() => _competitors.values.toList();
  List<EconomicEvent> getActiveEvents() => _activeEvents.values.toList();
  List<EconomicEvent> getEventHistory() => List.unmodifiable(_eventHistory);
  
  double getPriceFor(String drugType) => _markets[drugType]?.currentPrice ?? 0.0;
  
  List<Customer> getCustomersNear(Offset location, double radius) {
    return _customers.values.where((customer) {
      final distance = math.sqrt(
        math.pow(customer.location.dx - location.dx, 2) +
        math.pow(customer.location.dy - location.dy, 2),
      );
      return distance <= radius;
    }).toList();
  }
  
  List<Customer> getInterestedCustomers(String drugType) {
    return _customers.values.where((customer) {
      return customer.preferences.containsKey(drugType) &&
             customer.preferences[drugType]! > 0.3;
    }).toList();
  }
  
  double getCompetitorPrice(String drugType) {
    double totalPrice = 0.0;
    double totalShare = 0.0;
    
    for (final competitor in _competitors.values) {
      if (competitor.prices.containsKey(drugType)) {
        totalPrice += competitor.prices[drugType]! * competitor.marketShare;
        totalShare += competitor.marketShare;
      }
    }
    
    return totalShare > 0 ? totalPrice / totalShare : getPriceFor(drugType);
  }
  
  MarketState getOverallMarketState() {
    final states = _markets.values.map((m) => m.state).toList();
    
    // Return most common state
    final stateCounts = <MarketState, int>{};
    for (final state in states) {
      stateCounts[state] = (stateCounts[state] ?? 0) + 1;
    }
    
    return stateCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }
}

// Economy status widget
class EconomyStatusWidget extends StatefulWidget {
  const EconomyStatusWidget({super.key});

  @override
  State<EconomyStatusWidget> createState() => _EconomyStatusWidgetState();
}

class _EconomyStatusWidgetState extends State<EconomyStatusWidget> {
  final AIEconomySystem _economy = AIEconomySystem();
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    _economy.initialize();
    _updateTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final markets = _economy.getAllMarkets();
    final events = _economy.getActiveEvents();
    final overallState = _economy.getOverallMarketState();
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.trending_up,
                color: _getStateColor(overallState),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Market Status: ${_getStateText(overallState)}',
                style: TextStyle(
                  color: _getStateColor(overallState),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          if (events.isNotEmpty) ...[
            const Text(
              'Active Events:',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            ...events.take(3).map((event) => Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '• ${event.name}',
                style: TextStyle(
                  color: _getSeverityColor(event.severity),
                  fontSize: 11,
                ),
              ),
            )),
            const SizedBox(height: 8),
          ],
          
          const Text(
            'Top Markets:',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          ...markets.take(4).map((market) {
            final priceChange = market.priceHistory.length > 1
                ? market.currentPrice - market.priceHistory[market.priceHistory.length - 2]
                : 0.0;
            final changePercent = market.priceHistory.length > 1
                ? (priceChange / market.priceHistory[market.priceHistory.length - 2]) * 100
                : 0.0;
            
            return Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      market.drugType,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  Text(
                    '\$${market.currentPrice.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${changePercent >= 0 ? '+' : ''}${changePercent.toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: changePercent >= 0 ? Colors.green : Colors.red,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Color _getStateColor(MarketState state) {
    switch (state) {
      case MarketState.stable:
        return Colors.blue;
      case MarketState.bullish:
        return Colors.green;
      case MarketState.bearish:
        return Colors.orange;
      case MarketState.volatile:
        return Colors.yellow;
      case MarketState.crash:
        return Colors.red;
      case MarketState.boom:
        return Colors.purple;
    }
  }

  String _getStateText(MarketState state) {
    switch (state) {
      case MarketState.stable:
        return 'Stable';
      case MarketState.bullish:
        return 'Rising';
      case MarketState.bearish:
        return 'Falling';
      case MarketState.volatile:
        return 'Volatile';
      case MarketState.crash:
        return 'Crashing';
      case MarketState.boom:
        return 'Booming';
    }
  }

  Color _getSeverityColor(double severity) {
    if (severity < 0.3) return Colors.green;
    if (severity < 0.6) return Colors.yellow;
    if (severity < 0.8) return Colors.orange;
    return Colors.red;
  }
}
