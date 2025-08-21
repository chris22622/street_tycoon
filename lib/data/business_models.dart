// Business Features Models
import 'package:flutter/foundation.dart';

@immutable
class StockInvestment {
  final String symbol;
  final String companyName;
  final double currentPrice;
  final double purchasePrice;
  final int shares;
  final DateTime purchaseDate;
  final Map<String, double> historicalPrices;
  final double dividendYield;
  final String riskLevel; // 'low', 'medium', 'high'

  const StockInvestment({
    required this.symbol,
    required this.companyName,
    required this.currentPrice,
    required this.purchasePrice,
    required this.shares,
    required this.purchaseDate,
    required this.historicalPrices,
    required this.dividendYield,
    required this.riskLevel,
  });

  StockInvestment copyWith({
    String? symbol,
    String? companyName,
    double? currentPrice,
    double? purchasePrice,
    int? shares,
    DateTime? purchaseDate,
    Map<String, double>? historicalPrices,
    double? dividendYield,
    String? riskLevel,
  }) {
    return StockInvestment(
      symbol: symbol ?? this.symbol,
      companyName: companyName ?? this.companyName,
      currentPrice: currentPrice ?? this.currentPrice,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      shares: shares ?? this.shares,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      historicalPrices: historicalPrices ?? this.historicalPrices,
      dividendYield: dividendYield ?? this.dividendYield,
      riskLevel: riskLevel ?? this.riskLevel,
    );
  }

  double get totalValue => currentPrice * shares;
  double get profitLoss => (currentPrice - purchasePrice) * shares;
  double get profitLossPercentage => ((currentPrice - purchasePrice) / purchasePrice) * 100;
}

@immutable
class CryptocurrencyHolding {
  final String symbol;
  final String name;
  final double amount;
  final double averagePurchasePrice;
  final double currentPrice;
  final DateTime lastPurchase;
  final Map<String, double> volatilityHistory;
  final String walletType; // 'hot', 'cold', 'exchange'

  const CryptocurrencyHolding({
    required this.symbol,
    required this.name,
    required this.amount,
    required this.averagePurchasePrice,
    required this.currentPrice,
    required this.lastPurchase,
    required this.volatilityHistory,
    required this.walletType,
  });

  CryptocurrencyHolding copyWith({
    String? symbol,
    String? name,
    double? amount,
    double? averagePurchasePrice,
    double? currentPrice,
    DateTime? lastPurchase,
    Map<String, double>? volatilityHistory,
    String? walletType,
  }) {
    return CryptocurrencyHolding(
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      averagePurchasePrice: averagePurchasePrice ?? this.averagePurchasePrice,
      currentPrice: currentPrice ?? this.currentPrice,
      lastPurchase: lastPurchase ?? this.lastPurchase,
      volatilityHistory: volatilityHistory ?? this.volatilityHistory,
      walletType: walletType ?? this.walletType,
    );
  }

  double get totalValue => amount * currentPrice;
  double get profitLoss => amount * (currentPrice - averagePurchasePrice);
}

@immutable
class LegitimateeBusiness {
  final String id;
  final String name;
  final String type; // 'restaurant', 'car_wash', 'nightclub', 'construction'
  final int level;
  final double monthlyRevenue;
  final double monthlyCosts;
  final double suspicionLevel; // 0-100
  final Map<String, int> employees;
  final List<String> licenses;
  final bool isOperational;
  final String address;

  const LegitimateeBusiness({
    required this.id,
    required this.name,
    required this.type,
    required this.level,
    required this.monthlyRevenue,
    required this.monthlyCosts,
    required this.suspicionLevel,
    required this.employees,
    required this.licenses,
    this.isOperational = true,
    required this.address,
  });

  LegitimateeBusiness copyWith({
    String? id,
    String? name,
    String? type,
    int? level,
    double? monthlyRevenue,
    double? monthlyCosts,
    double? suspicionLevel,
    Map<String, int>? employees,
    List<String>? licenses,
    bool? isOperational,
    String? address,
  }) {
    return LegitimateeBusiness(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      level: level ?? this.level,
      monthlyRevenue: monthlyRevenue ?? this.monthlyRevenue,
      monthlyCosts: monthlyCosts ?? this.monthlyCosts,
      suspicionLevel: suspicionLevel ?? this.suspicionLevel,
      employees: employees ?? this.employees,
      licenses: licenses ?? this.licenses,
      isOperational: isOperational ?? this.isOperational,
      address: address ?? this.address,
    );
  }

  double get monthlyProfit => monthlyRevenue - monthlyCosts;
  double get launderingCapacity => monthlyRevenue * 0.3; // Can launder 30% of revenue
}

@immutable
class PoliticalInfluence {
  final String officialId;
  final String name;
  final String position;
  final String jurisdiction;
  final int corruptionLevel; // 0-100
  final int relationshipLevel; // 0-100
  final List<String> favorsOwed;
  final List<String> servicesProvided;
  final double monthlyCost;

  const PoliticalInfluence({
    required this.officialId,
    required this.name,
    required this.position,
    required this.jurisdiction,
    required this.corruptionLevel,
    required this.relationshipLevel,
    required this.favorsOwed,
    required this.servicesProvided,
    required this.monthlyCost,
  });

  PoliticalInfluence copyWith({
    String? officialId,
    String? name,
    String? position,
    String? jurisdiction,
    int? corruptionLevel,
    int? relationshipLevel,
    List<String>? favorsOwed,
    List<String>? servicesProvided,
    double? monthlyCost,
  }) {
    return PoliticalInfluence(
      officialId: officialId ?? this.officialId,
      name: name ?? this.name,
      position: position ?? this.position,
      jurisdiction: jurisdiction ?? this.jurisdiction,
      corruptionLevel: corruptionLevel ?? this.corruptionLevel,
      relationshipLevel: relationshipLevel ?? this.relationshipLevel,
      favorsOwed: favorsOwed ?? this.favorsOwed,
      servicesProvided: servicesProvided ?? this.servicesProvided,
      monthlyCost: monthlyCost ?? this.monthlyCost,
    );
  }
}

@immutable
class MediaOutlet {
  final String id;
  final String name;
  final String type; // 'newspaper', 'tv_station', 'radio', 'online'
  final int audience; // reach in thousands
  final double influence; // 0-100
  final int controlLevel; // 0-100, how much you control the narrative
  final double acquisitionCost;
  final double operatingCosts;
  final List<String> journalists;

  const MediaOutlet({
    required this.id,
    required this.name,
    required this.type,
    required this.audience,
    required this.influence,
    required this.controlLevel,
    required this.acquisitionCost,
    required this.operatingCosts,
    required this.journalists,
  });

  MediaOutlet copyWith({
    String? id,
    String? name,
    String? type,
    int? audience,
    double? influence,
    int? controlLevel,
    double? acquisitionCost,
    double? operatingCosts,
    List<String>? journalists,
  }) {
    return MediaOutlet(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      audience: audience ?? this.audience,
      influence: influence ?? this.influence,
      controlLevel: controlLevel ?? this.controlLevel,
      acquisitionCost: acquisitionCost ?? this.acquisitionCost,
      operatingCosts: operatingCosts ?? this.operatingCosts,
      journalists: journalists ?? this.journalists,
    );
  }
}

@immutable
class TechnologyResearch {
  final String id;
  final String name;
  final String category; // 'production', 'distribution', 'security', 'communication'
  final int level;
  final int progress;
  final int maxLevel;
  final Map<String, double> effects;
  final List<String> prerequisites;
  final int researchCost;
  final int timeRequired; // in days

  const TechnologyResearch({
    required this.id,
    required this.name,
    required this.category,
    required this.level,
    required this.progress,
    required this.maxLevel,
    required this.effects,
    required this.prerequisites,
    required this.researchCost,
    required this.timeRequired,
  });

  TechnologyResearch copyWith({
    String? id,
    String? name,
    String? category,
    int? level,
    int? progress,
    int? maxLevel,
    Map<String, double>? effects,
    List<String>? prerequisites,
    int? researchCost,
    int? timeRequired,
  }) {
    return TechnologyResearch(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      level: level ?? this.level,
      progress: progress ?? this.progress,
      maxLevel: maxLevel ?? this.maxLevel,
      effects: effects ?? this.effects,
      prerequisites: prerequisites ?? this.prerequisites,
      researchCost: researchCost ?? this.researchCost,
      timeRequired: timeRequired ?? this.timeRequired,
    );
  }
}

@immutable
class SupplyChain {
  final String id;
  final List<String> sourceLocations;
  final List<String> processingFacilities;
  final List<String> distributionPoints;
  final Map<String, double> efficiencyRatings;
  final Map<String, double> securityLevels;
  final double totalCapacity;
  final double currentUtilization;
  final List<String> vulnerabilities;

  const SupplyChain({
    required this.id,
    required this.sourceLocations,
    required this.processingFacilities,
    required this.distributionPoints,
    required this.efficiencyRatings,
    required this.securityLevels,
    required this.totalCapacity,
    required this.currentUtilization,
    required this.vulnerabilities,
  });

  SupplyChain copyWith({
    String? id,
    List<String>? sourceLocations,
    List<String>? processingFacilities,
    List<String>? distributionPoints,
    Map<String, double>? efficiencyRatings,
    Map<String, double>? securityLevels,
    double? totalCapacity,
    double? currentUtilization,
    List<String>? vulnerabilities,
  }) {
    return SupplyChain(
      id: id ?? this.id,
      sourceLocations: sourceLocations ?? this.sourceLocations,
      processingFacilities: processingFacilities ?? this.processingFacilities,
      distributionPoints: distributionPoints ?? this.distributionPoints,
      efficiencyRatings: efficiencyRatings ?? this.efficiencyRatings,
      securityLevels: securityLevels ?? this.securityLevels,
      totalCapacity: totalCapacity ?? this.totalCapacity,
      currentUtilization: currentUtilization ?? this.currentUtilization,
      vulnerabilities: vulnerabilities ?? this.vulnerabilities,
    );
  }

  double get efficiency => efficiencyRatings.values.fold(0.0, (a, b) => a + b) / efficiencyRatings.length;
  double get security => securityLevels.values.fold(0.0, (a, b) => a + b) / securityLevels.length;
}

@immutable
class QualityControl {
  final String productId;
  final double purity; // 0-100
  final double consistency; // 0-100
  final Map<String, double> testResults;
  final List<String> qualityIssues;
  final DateTime lastTested;
  final double customerSatisfaction; // 0-100
  final double priceMultiplier; // based on quality

  const QualityControl({
    required this.productId,
    required this.purity,
    required this.consistency,
    required this.testResults,
    required this.qualityIssues,
    required this.lastTested,
    required this.customerSatisfaction,
    required this.priceMultiplier,
  });

  QualityControl copyWith({
    String? productId,
    double? purity,
    double? consistency,
    Map<String, double>? testResults,
    List<String>? qualityIssues,
    DateTime? lastTested,
    double? customerSatisfaction,
    double? priceMultiplier,
  }) {
    return QualityControl(
      productId: productId ?? this.productId,
      purity: purity ?? this.purity,
      consistency: consistency ?? this.consistency,
      testResults: testResults ?? this.testResults,
      qualityIssues: qualityIssues ?? this.qualityIssues,
      lastTested: lastTested ?? this.lastTested,
      customerSatisfaction: customerSatisfaction ?? this.customerSatisfaction,
      priceMultiplier: priceMultiplier ?? this.priceMultiplier,
    );
  }

  double get overallQuality => (purity + consistency + customerSatisfaction) / 3;
}
