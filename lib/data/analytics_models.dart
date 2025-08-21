// Analytics & Strategy Models
import 'package:flutter/foundation.dart';

@immutable
class BusinessIntelligence {
  final String id;
  final Map<String, List<double>> priceHistory;
  final Map<String, double> demandForecasts;
  final Map<String, double> supplyAnalysis;
  final Map<String, double> competitorPrices;
  final Map<String, double> marketTrends;
  final DateTime lastUpdated;
  final double accuracy; // 0-100
  final List<String> insights;

  const BusinessIntelligence({
    required this.id,
    required this.priceHistory,
    required this.demandForecasts,
    required this.supplyAnalysis,
    required this.competitorPrices,
    required this.marketTrends,
    required this.lastUpdated,
    required this.accuracy,
    required this.insights,
  });

  BusinessIntelligence copyWith({
    String? id,
    Map<String, List<double>>? priceHistory,
    Map<String, double>? demandForecasts,
    Map<String, double>? supplyAnalysis,
    Map<String, double>? competitorPrices,
    Map<String, double>? marketTrends,
    DateTime? lastUpdated,
    double? accuracy,
    List<String>? insights,
  }) {
    return BusinessIntelligence(
      id: id ?? this.id,
      priceHistory: priceHistory ?? this.priceHistory,
      demandForecasts: demandForecasts ?? this.demandForecasts,
      supplyAnalysis: supplyAnalysis ?? this.supplyAnalysis,
      competitorPrices: competitorPrices ?? this.competitorPrices,
      marketTrends: marketTrends ?? this.marketTrends,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      accuracy: accuracy ?? this.accuracy,
      insights: insights ?? this.insights,
    );
  }
}

@immutable
class PredictiveModel {
  final String id;
  final String type; // 'price', 'demand', 'law_enforcement', 'competition'
  final Map<String, double> parameters;
  final List<String> inputFactors;
  final Map<String, double> historicalAccuracy;
  final DateTime trainingDate;
  final Map<String, dynamic> predictions;
  final double confidenceLevel;
  final int forecastHorizon; // days

  const PredictiveModel({
    required this.id,
    required this.type,
    required this.parameters,
    required this.inputFactors,
    required this.historicalAccuracy,
    required this.trainingDate,
    required this.predictions,
    required this.confidenceLevel,
    required this.forecastHorizon,
  });

  PredictiveModel copyWith({
    String? id,
    String? type,
    Map<String, double>? parameters,
    List<String>? inputFactors,
    Map<String, double>? historicalAccuracy,
    DateTime? trainingDate,
    Map<String, dynamic>? predictions,
    double? confidenceLevel,
    int? forecastHorizon,
  }) {
    return PredictiveModel(
      id: id ?? this.id,
      type: type ?? this.type,
      parameters: parameters ?? this.parameters,
      inputFactors: inputFactors ?? this.inputFactors,
      historicalAccuracy: historicalAccuracy ?? this.historicalAccuracy,
      trainingDate: trainingDate ?? this.trainingDate,
      predictions: predictions ?? this.predictions,
      confidenceLevel: confidenceLevel ?? this.confidenceLevel,
      forecastHorizon: forecastHorizon ?? this.forecastHorizon,
    );
  }
}

@immutable
class RiskAssessment {
  final String operationId;
  final String operationType;
  final Map<String, double> riskFactors;
  final double overallRiskScore; // 0-100
  final String riskLevel; // 'low', 'medium', 'high', 'extreme'
  final List<String> mitigationStrategies;
  final Map<String, double> contingencyPlans;
  final double expectedReturn;
  final double riskAdjustedReturn;

  const RiskAssessment({
    required this.operationId,
    required this.operationType,
    required this.riskFactors,
    required this.overallRiskScore,
    required this.riskLevel,
    required this.mitigationStrategies,
    required this.contingencyPlans,
    required this.expectedReturn,
    required this.riskAdjustedReturn,
  });

  RiskAssessment copyWith({
    String? operationId,
    String? operationType,
    Map<String, double>? riskFactors,
    double? overallRiskScore,
    String? riskLevel,
    List<String>? mitigationStrategies,
    Map<String, double>? contingencyPlans,
    double? expectedReturn,
    double? riskAdjustedReturn,
  }) {
    return RiskAssessment(
      operationId: operationId ?? this.operationId,
      operationType: operationType ?? this.operationType,
      riskFactors: riskFactors ?? this.riskFactors,
      overallRiskScore: overallRiskScore ?? this.overallRiskScore,
      riskLevel: riskLevel ?? this.riskLevel,
      mitigationStrategies: mitigationStrategies ?? this.mitigationStrategies,
      contingencyPlans: contingencyPlans ?? this.contingencyPlans,
      expectedReturn: expectedReturn ?? this.expectedReturn,
      riskAdjustedReturn: riskAdjustedReturn ?? this.riskAdjustedReturn,
    );
  }
}

@immutable
class ProfitOptimization {
  final String id;
  final Map<String, double> currentStrategy;
  final Map<String, double> optimizedStrategy;
  final double currentProfit;
  final double projectedProfit;
  final double improvementPercentage;
  final List<String> recommendations;
  final Map<String, double> sensitivityAnalysis;
  final List<String> constraints;

  const ProfitOptimization({
    required this.id,
    required this.currentStrategy,
    required this.optimizedStrategy,
    required this.currentProfit,
    required this.projectedProfit,
    required this.improvementPercentage,
    required this.recommendations,
    required this.sensitivityAnalysis,
    required this.constraints,
  });

  ProfitOptimization copyWith({
    String? id,
    Map<String, double>? currentStrategy,
    Map<String, double>? optimizedStrategy,
    double? currentProfit,
    double? projectedProfit,
    double? improvementPercentage,
    List<String>? recommendations,
    Map<String, double>? sensitivityAnalysis,
    List<String>? constraints,
  }) {
    return ProfitOptimization(
      id: id ?? this.id,
      currentStrategy: currentStrategy ?? this.currentStrategy,
      optimizedStrategy: optimizedStrategy ?? this.optimizedStrategy,
      currentProfit: currentProfit ?? this.currentProfit,
      projectedProfit: projectedProfit ?? this.projectedProfit,
      improvementPercentage: improvementPercentage ?? this.improvementPercentage,
      recommendations: recommendations ?? this.recommendations,
      sensitivityAnalysis: sensitivityAnalysis ?? this.sensitivityAnalysis,
      constraints: constraints ?? this.constraints,
    );
  }
}

@immutable
class CompetitionAnalysis {
  final String competitorId;
  final String name;
  final Map<String, double> marketShare;
  final Map<String, int> operations;
  final Map<String, double> pricing;
  final List<String> territories;
  final double threat_level; // 0-100
  final Map<String, String> strategies;
  final List<String> weaknesses;
  final List<String> strengths;

  const CompetitionAnalysis({
    required this.competitorId,
    required this.name,
    required this.marketShare,
    required this.operations,
    required this.pricing,
    required this.territories,
    required this.threat_level,
    required this.strategies,
    required this.weaknesses,
    required this.strengths,
  });

  CompetitionAnalysis copyWith({
    String? competitorId,
    String? name,
    Map<String, double>? marketShare,
    Map<String, int>? operations,
    Map<String, double>? pricing,
    List<String>? territories,
    double? threat_level,
    Map<String, String>? strategies,
    List<String>? weaknesses,
    List<String>? strengths,
  }) {
    return CompetitionAnalysis(
      competitorId: competitorId ?? this.competitorId,
      name: name ?? this.name,
      marketShare: marketShare ?? this.marketShare,
      operations: operations ?? this.operations,
      pricing: pricing ?? this.pricing,
      territories: territories ?? this.territories,
      threat_level: threat_level ?? this.threat_level,
      strategies: strategies ?? this.strategies,
      weaknesses: weaknesses ?? this.weaknesses,
      strengths: strengths ?? this.strengths,
    );
  }
}

@immutable
class MarketResearch {
  final String researchId;
  final String focusArea; // 'customer_behavior', 'demand_patterns', 'price_sensitivity'
  final Map<String, dynamic> data;
  final Map<String, double> customerSegments;
  final Map<String, int> demandDrivers;
  final List<String> trends;
  final DateTime researchDate;
  final double reliability; // 0-100
  final int sampleSize;

  const MarketResearch({
    required this.researchId,
    required this.focusArea,
    required this.data,
    required this.customerSegments,
    required this.demandDrivers,
    required this.trends,
    required this.researchDate,
    required this.reliability,
    required this.sampleSize,
  });

  MarketResearch copyWith({
    String? researchId,
    String? focusArea,
    Map<String, dynamic>? data,
    Map<String, double>? customerSegments,
    Map<String, int>? demandDrivers,
    List<String>? trends,
    DateTime? researchDate,
    double? reliability,
    int? sampleSize,
  }) {
    return MarketResearch(
      researchId: researchId ?? this.researchId,
      focusArea: focusArea ?? this.focusArea,
      data: data ?? this.data,
      customerSegments: customerSegments ?? this.customerSegments,
      demandDrivers: demandDrivers ?? this.demandDrivers,
      trends: trends ?? this.trends,
      researchDate: researchDate ?? this.researchDate,
      reliability: reliability ?? this.reliability,
      sampleSize: sampleSize ?? this.sampleSize,
    );
  }
}

@immutable
class FinancialPlanning {
  final String planId;
  final String timeframe; // 'short_term', 'medium_term', 'long_term'
  final Map<String, double> investments;
  final Map<String, double> expenses;
  final Map<String, double> revenues;
  final double emergencyFund;
  final List<String> goals;
  final Map<String, double> riskAllocation;
  final double expectedReturn;
  final DateTime reviewDate;

  const FinancialPlanning({
    required this.planId,
    required this.timeframe,
    required this.investments,
    required this.expenses,
    required this.revenues,
    required this.emergencyFund,
    required this.goals,
    required this.riskAllocation,
    required this.expectedReturn,
    required this.reviewDate,
  });

  FinancialPlanning copyWith({
    String? planId,
    String? timeframe,
    Map<String, double>? investments,
    Map<String, double>? expenses,
    Map<String, double>? revenues,
    double? emergencyFund,
    List<String>? goals,
    Map<String, double>? riskAllocation,
    double? expectedReturn,
    DateTime? reviewDate,
  }) {
    return FinancialPlanning(
      planId: planId ?? this.planId,
      timeframe: timeframe ?? this.timeframe,
      investments: investments ?? this.investments,
      expenses: expenses ?? this.expenses,
      revenues: revenues ?? this.revenues,
      emergencyFund: emergencyFund ?? this.emergencyFund,
      goals: goals ?? this.goals,
      riskAllocation: riskAllocation ?? this.riskAllocation,
      expectedReturn: expectedReturn ?? this.expectedReturn,
      reviewDate: reviewDate ?? this.reviewDate,
    );
  }

  double get netCashFlow => revenues.values.fold(0.0, (a, b) => a + b) - expenses.values.fold(0.0, (a, b) => a + b);
  double get totalInvestments => investments.values.fold(0.0, (a, b) => a + b);
}
