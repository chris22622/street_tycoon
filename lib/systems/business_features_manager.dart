// Advanced Business Features System
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';
import '../data/business_models.dart';

class BusinessFeaturesState {
  final Map<String, StockInvestment> stockPortfolio;
  final Map<String, CryptocurrencyHolding> cryptoPortfolio;
  final Map<String, LegitimateeBusiness> legitimateBusinesses;
  final Map<String, PoliticalInfluence> politicalConnections;
  final Map<String, MediaOutlet> mediaEmpire;
  final Map<String, TechnologyResearch> researchProjects;
  final Map<String, SupplyChain> supplyChains;
  final Map<String, QualityControl> qualityControls;
  final double totalLiquidAssets;
  final double totalNetWorth;

  const BusinessFeaturesState({
    required this.stockPortfolio,
    required this.cryptoPortfolio,
    required this.legitimateBusinesses,
    required this.politicalConnections,
    required this.mediaEmpire,
    required this.researchProjects,
    required this.supplyChains,
    required this.qualityControls,
    this.totalLiquidAssets = 0.0,
    this.totalNetWorth = 0.0,
  });

  BusinessFeaturesState copyWith({
    Map<String, StockInvestment>? stockPortfolio,
    Map<String, CryptocurrencyHolding>? cryptoPortfolio,
    Map<String, LegitimateeBusiness>? legitimateBusinesses,
    Map<String, PoliticalInfluence>? politicalConnections,
    Map<String, MediaOutlet>? mediaEmpire,
    Map<String, TechnologyResearch>? researchProjects,
    Map<String, SupplyChain>? supplyChains,
    Map<String, QualityControl>? qualityControls,
    double? totalLiquidAssets,
    double? totalNetWorth,
  }) {
    return BusinessFeaturesState(
      stockPortfolio: stockPortfolio ?? this.stockPortfolio,
      cryptoPortfolio: cryptoPortfolio ?? this.cryptoPortfolio,
      legitimateBusinesses: legitimateBusinesses ?? this.legitimateBusinesses,
      politicalConnections: politicalConnections ?? this.politicalConnections,
      mediaEmpire: mediaEmpire ?? this.mediaEmpire,
      researchProjects: researchProjects ?? this.researchProjects,
      supplyChains: supplyChains ?? this.supplyChains,
      qualityControls: qualityControls ?? this.qualityControls,
      totalLiquidAssets: totalLiquidAssets ?? this.totalLiquidAssets,
      totalNetWorth: totalNetWorth ?? this.totalNetWorth,
    );
  }
}

class BusinessFeaturesManager extends StateNotifier<BusinessFeaturesState> {
  BusinessFeaturesManager() : super(const BusinessFeaturesState(
    stockPortfolio: {},
    cryptoPortfolio: {},
    legitimateBusinesses: {},
    politicalConnections: {},
    mediaEmpire: {},
    researchProjects: {},
    supplyChains: {},
    qualityControls: {},
  ));

  final Random _random = Random();

  // Stock Market Operations
  void buyStock(String symbol, int shares, double pricePerShare) {
    final existing = state.stockPortfolio[symbol];
    
    if (existing != null) {
      // Average down the purchase price
      final totalShares = existing.shares + shares;
      final totalCost = (existing.shares * existing.purchasePrice) + (shares * pricePerShare);
      final newAveragePrice = totalCost / totalShares;
      
      final updated = existing.copyWith(
        shares: totalShares,
        purchasePrice: newAveragePrice,
        currentPrice: pricePerShare,
      );
      
      state = state.copyWith(
        stockPortfolio: {...state.stockPortfolio, symbol: updated},
      );
    } else {
      final company = _getCompanyName(symbol);
      final newInvestment = StockInvestment(
        symbol: symbol,
        companyName: company,
        currentPrice: pricePerShare,
        purchasePrice: pricePerShare,
        shares: shares,
        purchaseDate: DateTime.now(),
        historicalPrices: {DateTime.now().toIso8601String(): pricePerShare},
        dividendYield: _random.nextDouble() * 0.05, // 0-5% dividend
        riskLevel: _determineRiskLevel(symbol),
      );
      
      state = state.copyWith(
        stockPortfolio: {...state.stockPortfolio, symbol: newInvestment},
      );
    }
    
    _updateNetWorth();
  }

  void sellStock(String symbol, int shares) {
    final investment = state.stockPortfolio[symbol];
    if (investment == null || investment.shares < shares) return;

    if (investment.shares == shares) {
      final newPortfolio = Map<String, StockInvestment>.from(state.stockPortfolio);
      newPortfolio.remove(symbol);
      
      state = state.copyWith(stockPortfolio: newPortfolio);
    } else {
      final updated = investment.copyWith(shares: investment.shares - shares);
      state = state.copyWith(
        stockPortfolio: {...state.stockPortfolio, symbol: updated},
      );
    }
    
    _updateNetWorth();
  }

  // Cryptocurrency Operations
  void buyCrypto(String symbol, double amount, double pricePerUnit) {
    final existing = state.cryptoPortfolio[symbol];
    
    if (existing != null) {
      final totalAmount = existing.amount + amount;
      final totalCost = (existing.amount * existing.averagePurchasePrice) + (amount * pricePerUnit);
      final newAveragePrice = totalCost / totalAmount;
      
      final updated = existing.copyWith(
        amount: totalAmount,
        averagePurchasePrice: newAveragePrice,
        currentPrice: pricePerUnit,
        lastPurchase: DateTime.now(),
      );
      
      state = state.copyWith(
        cryptoPortfolio: {...state.cryptoPortfolio, symbol: updated},
      );
    } else {
      final newHolding = CryptocurrencyHolding(
        symbol: symbol,
        name: _getCryptoName(symbol),
        amount: amount,
        averagePurchasePrice: pricePerUnit,
        currentPrice: pricePerUnit,
        lastPurchase: DateTime.now(),
        volatilityHistory: {},
        walletType: 'hot', // Default to hot wallet
      );
      
      state = state.copyWith(
        cryptoPortfolio: {...state.cryptoPortfolio, symbol: newHolding},
      );
    }
    
    _updateNetWorth();
  }

  // Legitimate Business Operations
  void establishBusiness(String businessType, String name, String address) {
    final businessId = '${businessType}_${DateTime.now().millisecondsSinceEpoch}';
    
    final business = LegitimateeBusiness(
      id: businessId,
      name: name,
      type: businessType,
      level: 1,
      monthlyRevenue: _calculateInitialRevenue(businessType),
      monthlyCosts: _calculateInitialCosts(businessType),
      suspicionLevel: 0.0,
      employees: {'total': 5},
      licenses: [businessType],
      address: address,
    );
    
    state = state.copyWith(
      legitimateBusinesses: {...state.legitimateBusinesses, businessId: business},
    );
    
    _updateNetWorth();
  }

  void upgradeBusiness(String businessId) {
    final business = state.legitimateBusinesses[businessId];
    if (business == null) return;

    final upgraded = business.copyWith(
      level: business.level + 1,
      monthlyRevenue: business.monthlyRevenue * 1.5,
      monthlyCosts: business.monthlyCosts * 1.3,
    );

    state = state.copyWith(
      legitimateBusinesses: {...state.legitimateBusinesses, businessId: upgraded},
    );
  }

  // Political Influence Operations
  void corruptOfficial(String officialName, String position, String jurisdiction) {
    final officialId = '${officialName}_${position}'.replaceAll(' ', '_').toLowerCase();
    
    final influence = PoliticalInfluence(
      officialId: officialId,
      name: officialName,
      position: position,
      jurisdiction: jurisdiction,
      corruptionLevel: 10, // Start small
      relationshipLevel: 10,
      favorsOwed: [],
      servicesProvided: [],
      monthlyCost: _calculateCorruptionCost(position),
    );
    
    state = state.copyWith(
      politicalConnections: {...state.politicalConnections, officialId: influence},
    );
  }

  // Technology Research
  void startResearch(String technologyName, String category) {
    final researchId = '${technologyName}_research'.replaceAll(' ', '_').toLowerCase();
    
    final research = TechnologyResearch(
      id: researchId,
      name: technologyName,
      category: category,
      level: 1,
      progress: 0,
      maxLevel: 5,
      effects: _getTechnologyEffects(technologyName),
      prerequisites: [],
      researchCost: _calculateResearchCost(technologyName),
      timeRequired: _calculateResearchTime(technologyName),
    );
    
    state = state.copyWith(
      researchProjects: {...state.researchProjects, researchId: research},
    );
  }

  void advanceResearch(String researchId, int progressPoints) {
    final research = state.researchProjects[researchId];
    if (research == null) return;

    final newProgress = (research.progress + progressPoints).clamp(0, 100);
    var newLevel = research.level;
    var finalProgress = newProgress;

    if (newProgress >= 100 && research.level < research.maxLevel) {
      newLevel = research.level + 1;
      finalProgress = 0;
    }

    final updated = research.copyWith(
      level: newLevel,
      progress: finalProgress,
    );

    state = state.copyWith(
      researchProjects: {...state.researchProjects, researchId: updated},
    );
  }

  // Supply Chain Management
  void createSupplyChain(String id, List<String> sources, List<String> facilities, List<String> distribution) {
    final supplyChain = SupplyChain(
      id: id,
      sourceLocations: sources,
      processingFacilities: facilities,
      distributionPoints: distribution,
      efficiencyRatings: {
        for (String location in [...sources, ...facilities, ...distribution])
          location: 0.7 + (_random.nextDouble() * 0.3) // 70-100% efficiency
      },
      securityLevels: {
        for (String location in [...sources, ...facilities, ...distribution])
          location: 0.5 + (_random.nextDouble() * 0.5) // 50-100% security
      },
      totalCapacity: 1000.0,
      currentUtilization: 0.0,
      vulnerabilities: [],
    );
    
    state = state.copyWith(
      supplyChains: {...state.supplyChains, id: supplyChain},
    );
  }

  // Quality Control
  void establishQualityControl(String productId) {
    final qc = QualityControl(
      productId: productId,
      purity: 70.0 + (_random.nextDouble() * 25.0), // 70-95% purity
      consistency: 60.0 + (_random.nextDouble() * 35.0), // 60-95% consistency
      testResults: {
        'purity_test': 0.8,
        'consistency_test': 0.75,
        'contaminant_test': 0.9,
      },
      qualityIssues: [],
      lastTested: DateTime.now(),
      customerSatisfaction: 75.0,
      priceMultiplier: 1.0,
    );
    
    state = state.copyWith(
      qualityControls: {...state.qualityControls, productId: qc},
    );
  }

  // Market simulation methods
  void updateMarketPrices() {
    // Update stock prices
    final updatedStocks = <String, StockInvestment>{};
    for (final entry in state.stockPortfolio.entries) {
      final stock = entry.value;
      final priceChange = (_random.nextDouble() - 0.5) * 0.1; // -5% to +5%
      final newPrice = stock.currentPrice * (1 + priceChange);
      
      final updatedStock = stock.copyWith(
        currentPrice: newPrice,
        historicalPrices: {
          ...stock.historicalPrices,
          DateTime.now().toIso8601String(): newPrice,
        },
      );
      
      updatedStocks[entry.key] = updatedStock;
    }
    
    // Update crypto prices (more volatile)
    final updatedCrypto = <String, CryptocurrencyHolding>{};
    for (final entry in state.cryptoPortfolio.entries) {
      final crypto = entry.value;
      final priceChange = (_random.nextDouble() - 0.5) * 0.3; // -15% to +15%
      final newPrice = crypto.currentPrice * (1 + priceChange);
      
      final updatedCryptoHolding = crypto.copyWith(
        currentPrice: newPrice,
        volatilityHistory: {
          ...crypto.volatilityHistory,
          DateTime.now().toIso8601String(): priceChange.abs(),
        },
      );
      
      updatedCrypto[entry.key] = updatedCryptoHolding;
    }
    
    state = state.copyWith(
      stockPortfolio: updatedStocks,
      cryptoPortfolio: updatedCrypto,
    );
    
    _updateNetWorth();
  }

  void _updateNetWorth() {
    double stockValue = 0.0;
    for (final stock in state.stockPortfolio.values) {
      stockValue += stock.totalValue;
    }
    
    double cryptoValue = 0.0;
    for (final crypto in state.cryptoPortfolio.values) {
      cryptoValue += crypto.totalValue;
    }
    
    double businessValue = 0.0;
    for (final business in state.legitimateBusinesses.values) {
      businessValue += business.monthlyRevenue * 12; // Simple valuation
    }
    
    final totalNetWorth = stockValue + cryptoValue + businessValue + state.totalLiquidAssets;
    
    state = state.copyWith(totalNetWorth: totalNetWorth);
  }

  // Helper methods
  String _getCompanyName(String symbol) {
    const companyNames = {
      'AAPL': 'Apple Inc.',
      'GOOGL': 'Alphabet Inc.',
      'MSFT': 'Microsoft Corporation',
      'AMZN': 'Amazon.com Inc.',
      'TSLA': 'Tesla Inc.',
    };
    return companyNames[symbol] ?? '$symbol Corp.';
  }

  String _getCryptoName(String symbol) {
    const cryptoNames = {
      'BTC': 'Bitcoin',
      'ETH': 'Ethereum',
      'BNB': 'Binance Coin',
      'XRP': 'Ripple',
      'ADA': 'Cardano',
    };
    return cryptoNames[symbol] ?? symbol;
  }

  String _determineRiskLevel(String symbol) {
    const highRisk = ['TSLA', 'NVDA', 'AMD'];
    const lowRisk = ['AAPL', 'MSFT', 'JPM'];
    
    if (highRisk.contains(symbol)) return 'high';
    if (lowRisk.contains(symbol)) return 'low';
    return 'medium';
  }

  double _calculateInitialRevenue(String businessType) {
    const revenueMap = {
      'Restaurant': 50000.0,
      'Car Wash': 20000.0,
      'Nightclub': 80000.0,
      'Construction Company': 120000.0,
      'Import/Export': 200000.0,
    };
    return revenueMap[businessType] ?? 30000.0;
  }

  double _calculateInitialCosts(String businessType) {
    const costMap = {
      'Restaurant': 35000.0,
      'Car Wash': 12000.0,
      'Nightclub': 60000.0,
      'Construction Company': 90000.0,
      'Import/Export': 150000.0,
    };
    return costMap[businessType] ?? 20000.0;
  }

  double _calculateCorruptionCost(String position) {
    const costMap = {
      'Mayor': 50000.0,
      'Police Chief': 30000.0,
      'Judge': 75000.0,
      'Prosecutor': 40000.0,
      'City Council': 20000.0,
    };
    return costMap[position] ?? 25000.0;
  }

  Map<String, double> _getTechnologyEffects(String technologyName) {
    const effectsMap = {
      'Advanced Chemistry': {'production_efficiency': 0.2, 'purity_bonus': 0.15},
      'Secure Communications': {'heat_reduction': 0.1, 'coordination_bonus': 0.15},
      'Market Analysis AI': {'price_prediction': 0.3, 'demand_forecast': 0.25},
      'Supply Chain Optimization': {'logistics_efficiency': 0.2, 'cost_reduction': 0.1},
    };
    return effectsMap[technologyName] ?? {'general_bonus': 0.1};
  }

  int _calculateResearchCost(String technologyName) {
    const costMap = {
      'Advanced Chemistry': 500000,
      'Secure Communications': 300000,
      'Market Analysis AI': 750000,
      'Supply Chain Optimization': 400000,
    };
    return costMap[technologyName] ?? 200000;
  }

  int _calculateResearchTime(String technologyName) {
    const timeMap = {
      'Advanced Chemistry': 180, // days
      'Secure Communications': 120,
      'Market Analysis AI': 240,
      'Supply Chain Optimization': 150,
    };
    return timeMap[technologyName] ?? 90;
  }
}

final businessFeaturesProvider = StateNotifierProvider<BusinessFeaturesManager, BusinessFeaturesState>((ref) {
  return BusinessFeaturesManager();
});
