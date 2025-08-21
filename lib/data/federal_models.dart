enum FederalLevel {
  clear,     // 0-24: All clear
  watch,     // 25-49: Under surveillance  
  target,    // 50-74: Active target
  manhunt,   // 75-100: Federal manhunt
}

extension FederalLevelExtension on FederalLevel {
  String get name {
    switch (this) {
      case FederalLevel.clear:
        return 'CLEAR';
      case FederalLevel.watch:
        return 'WATCH';
      case FederalLevel.target:
        return 'TARGET';
      case FederalLevel.manhunt:
        return 'MANHUNT';
    }
  }

  String get description {
    switch (this) {
      case FederalLevel.clear:
        return 'Operating under the radar';
      case FederalLevel.watch:
        return 'FBI surveillance active';
      case FederalLevel.target:
        return 'Active federal investigation';
      case FederalLevel.manhunt:
        return 'FEDERAL MANHUNT - EXTREME DANGER';
    }
  }

  String get icon {
    switch (this) {
      case FederalLevel.clear:
        return '🟢';
      case FederalLevel.watch:
        return '🟡';
      case FederalLevel.target:
        return '🟠';
      case FederalLevel.manhunt:
        return '🔴';
    }
  }

  // Heat multipliers for different levels
  double get heatMultiplier {
    switch (this) {
      case FederalLevel.clear:
        return 1.0;
      case FederalLevel.watch:
        return 1.3;
      case FederalLevel.target:
        return 1.7;
      case FederalLevel.manhunt:
        return 2.5;
    }
  }

  // Price impact (negative = worse prices)
  double get priceImpact {
    switch (this) {
      case FederalLevel.clear:
        return 0.0;
      case FederalLevel.watch:
        return -0.05; // 5% worse prices
      case FederalLevel.target:
        return -0.15; // 15% worse prices
      case FederalLevel.manhunt:
        return -0.30; // 30% worse prices
    }
  }

  // Travel cost multiplier
  double get travelCostMultiplier {
    switch (this) {
      case FederalLevel.clear:
        return 1.0;
      case FederalLevel.watch:
        return 1.5;
      case FederalLevel.target:
        return 2.0;
      case FederalLevel.manhunt:
        return 3.0;
    }
  }

  // Random event probability multiplier
  double get eventRiskMultiplier {
    switch (this) {
      case FederalLevel.clear:
        return 0.8;
      case FederalLevel.watch:
        return 1.2;
      case FederalLevel.target:
        return 1.8;
      case FederalLevel.manhunt:
        return 2.5;
    }
  }
}

class FederalOperation {
  final String id;
  final String name;
  final String description;
  final int federalHeatIncrease;
  final int cost;
  final int payout;
  final FederalLevel requiredLevel;
  final String riskDescription;

  const FederalOperation({
    required this.id,
    required this.name,
    required this.description,
    required this.federalHeatIncrease,
    required this.cost,
    required this.payout,
    required this.requiredLevel,
    required this.riskDescription,
  });
}

class FederalMeter {
  final int level; // 0-100
  final FederalLevel status;
  final DateTime lastUpdate;
  final Map<String, int> activities; // Track what caused the heat
  final List<String> activeWarnings;

  const FederalMeter({
    required this.level,
    required this.status,
    required this.lastUpdate,
    required this.activities,
    required this.activeWarnings,
  });

  static FederalMeter initial() {
    return FederalMeter(
      level: 0,
      status: FederalLevel.clear,
      lastUpdate: DateTime.now(),
      activities: {},
      activeWarnings: [],
    );
  }

  FederalLevel get currentLevel {
    if (level >= 75) return FederalLevel.manhunt;
    if (level >= 50) return FederalLevel.target;
    if (level >= 25) return FederalLevel.watch;
    return FederalLevel.clear;
  }

  bool get isEscalating => level > 50;
  bool get isCritical => level >= 75;
  bool get canOperate => level < 90; // At 90+ federal heat, operations become too risky

  // Calculate daily decay (federal heat slowly decreases over time)
  int get dailyDecay {
    if (level >= 75) return 3; // Manhunt level decays slowly
    if (level >= 50) return 5; // Target level
    if (level >= 25) return 7; // Watch level  
    return 10; // Clear level decays fastest
  }

  FederalMeter copyWith({
    int? level,
    FederalLevel? status,
    DateTime? lastUpdate,
    Map<String, int>? activities,
    List<String>? activeWarnings,
  }) {
    return FederalMeter(
      level: level ?? this.level,
      status: status ?? this.status,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      activities: activities ?? this.activities,
      activeWarnings: activeWarnings ?? this.activeWarnings,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'status': status.index,
      'lastUpdate': lastUpdate.millisecondsSinceEpoch,
      'activities': activities,
      'activeWarnings': activeWarnings,
    };
  }

  factory FederalMeter.fromJson(Map<String, dynamic> json) {
    return FederalMeter(
      level: json['level'] ?? 0,
      status: FederalLevel.values[json['status'] ?? 0],
      lastUpdate: DateTime.fromMillisecondsSinceEpoch(json['lastUpdate'] ?? DateTime.now().millisecondsSinceEpoch),
      activities: Map<String, int>.from(json['activities'] ?? {}),
      activeWarnings: List<String>.from(json['activeWarnings'] ?? []),
    );
  }
}

// Predefined federal operations that become available at different levels
class FederalOperations {
  static const List<FederalOperation> operations = [
    // CLEAR Level Operations (Low risk, low reward)
    FederalOperation(
      id: 'smuggle_small',
      name: 'Small Smuggling Run',
      description: 'Move small quantities across state lines',
      federalHeatIncrease: 8,
      cost: 500,
      payout: 1200,
      requiredLevel: FederalLevel.clear,
      riskDescription: 'Low risk - unlikely to be detected',
    ),
    
    FederalOperation(
      id: 'fake_documents',
      name: 'Document Forgery',
      description: 'Create false identification papers',
      federalHeatIncrease: 10,
      cost: 800,
      payout: 2000,
      requiredLevel: FederalLevel.clear,
      riskDescription: 'Moderate risk - federal crime',
    ),

    FederalOperation(
      id: 'identity_theft',
      name: 'Identity Theft Ring',
      description: 'Steal and sell personal information',
      federalHeatIncrease: 9,
      cost: 600,
      payout: 1500,
      requiredLevel: FederalLevel.clear,
      riskDescription: 'Low risk - cybercrime division',
    ),

    FederalOperation(
      id: 'tax_evasion',
      name: 'Tax Evasion Scheme',
      description: 'Set up offshore accounts to avoid taxes',
      federalHeatIncrease: 12,
      cost: 1000,
      payout: 2500,
      requiredLevel: FederalLevel.clear,
      riskDescription: 'Moderate risk - IRS investigation',
    ),

    FederalOperation(
      id: 'credit_fraud',
      name: 'Credit Card Fraud',
      description: 'Run fraudulent credit card operations',
      federalHeatIncrease: 11,
      cost: 700,
      payout: 1800,
      requiredLevel: FederalLevel.clear,
      riskDescription: 'Moderate risk - financial crimes',
    ),

    FederalOperation(
      id: 'postal_scam',
      name: 'Mail Fraud Scheme',
      description: 'Use postal service for fraudulent activities',
      federalHeatIncrease: 13,
      cost: 900,
      payout: 2200,
      requiredLevel: FederalLevel.clear,
      riskDescription: 'Moderate risk - postal inspection service',
    ),

    FederalOperation(
      id: 'wire_fraud',
      name: 'Wire Fraud Operation',
      description: 'Electronic financial fraud schemes',
      federalHeatIncrease: 10,
      cost: 750,
      payout: 1900,
      requiredLevel: FederalLevel.clear,
      riskDescription: 'Moderate risk - FBI financial unit',
    ),

    FederalOperation(
      id: 'counterfeit_goods',
      name: 'Counterfeit Goods Trade',
      description: 'Manufacture and sell fake branded products',
      federalHeatIncrease: 9,
      cost: 650,
      payout: 1600,
      requiredLevel: FederalLevel.clear,
      riskDescription: 'Low risk - trademark violations',
    ),

    FederalOperation(
      id: 'bankruptcy_fraud',
      name: 'Bankruptcy Fraud',
      description: 'Hide assets during bankruptcy proceedings',
      federalHeatIncrease: 14,
      cost: 1200,
      payout: 2800,
      requiredLevel: FederalLevel.clear,
      riskDescription: 'High risk - federal court jurisdiction',
    ),

    FederalOperation(
      id: 'securities_fraud',
      name: 'Securities Fraud',
      description: 'Manipulate stock prices and insider trading',
      federalHeatIncrease: 15,
      cost: 1500,
      payout: 3200,
      requiredLevel: FederalLevel.clear,
      riskDescription: 'High risk - SEC investigation',
    ),

    // WATCH Level Operations (Medium risk, medium reward)
    FederalOperation(
      id: 'money_laundering',
      name: 'Money Laundering',
      description: 'Clean dirty money through shell companies',
      federalHeatIncrease: 18,
      cost: 2000,
      payout: 5000,
      requiredLevel: FederalLevel.watch,
      riskDescription: 'High risk - FBI financial crimes unit',
    ),

    FederalOperation(
      id: 'interstate_trafficking',
      name: 'Interstate Trafficking',
      description: 'Large-scale smuggling operation',
      federalHeatIncrease: 22,
      cost: 3500,
      payout: 8500,
      requiredLevel: FederalLevel.watch,
      riskDescription: 'Very high risk - federal trafficking charges',
    ),

    FederalOperation(
      id: 'arms_dealing',
      name: 'Illegal Arms Trading',
      description: 'Sell weapons across state lines',
      federalHeatIncrease: 25,
      cost: 4000,
      payout: 9500,
      requiredLevel: FederalLevel.watch,
      riskDescription: 'Very high risk - ATF involvement',
    ),

    FederalOperation(
      id: 'cyber_attack',
      name: 'Corporate Cyber Attack',
      description: 'Hack into federal databases',
      federalHeatIncrease: 28,
      cost: 5000,
      payout: 12000,
      requiredLevel: FederalLevel.watch,
      riskDescription: 'Extreme risk - cyber terrorism charges',
    ),

    FederalOperation(
      id: 'bribery_ring',
      name: 'Government Bribery',
      description: 'Corrupt federal officials',
      federalHeatIncrease: 24,
      cost: 3000,
      payout: 7500,
      requiredLevel: FederalLevel.watch,
      riskDescription: 'High risk - public corruption unit',
    ),

    FederalOperation(
      id: 'immigration_fraud',
      name: 'Immigration Fraud',
      description: 'Forge immigration documents',
      federalHeatIncrease: 20,
      cost: 2500,
      payout: 6000,
      requiredLevel: FederalLevel.watch,
      riskDescription: 'High risk - ICE investigation',
    ),

    FederalOperation(
      id: 'prison_break',
      name: 'Federal Prison Break',
      description: 'Help break someone out of federal prison',
      federalHeatIncrease: 30,
      cost: 6000,
      payout: 15000,
      requiredLevel: FederalLevel.watch,
      riskDescription: 'Extreme risk - federal marshals',
    ),

    FederalOperation(
      id: 'drug_cartel',
      name: 'Drug Cartel Connection',
      description: 'Establish connections with international cartels',
      federalHeatIncrease: 26,
      cost: 4500,
      payout: 11000,
      requiredLevel: FederalLevel.watch,
      riskDescription: 'Very high risk - DEA task force',
    ),

    FederalOperation(
      id: 'political_corruption',
      name: 'Political Corruption',
      description: 'Influence federal elections and policies',
      federalHeatIncrease: 27,
      cost: 5500,
      payout: 13000,
      requiredLevel: FederalLevel.watch,
      riskDescription: 'Extreme risk - election fraud unit',
    ),

    FederalOperation(
      id: 'healthcare_fraud',
      name: 'Medicare Fraud Scheme',
      description: 'Defraud federal healthcare programs',
      federalHeatIncrease: 21,
      cost: 3200,
      payout: 7800,
      requiredLevel: FederalLevel.watch,
      riskDescription: 'High risk - HHS investigation',
    ),

    // TARGET Level Operations (High risk, high reward)
    FederalOperation(
      id: 'federal_heist',
      name: 'Federal Building Heist',
      description: 'Rob a federal facility',
      federalHeatIncrease: 35,
      cost: 10000,
      payout: 30000,
      requiredLevel: FederalLevel.target,
      riskDescription: 'EXTREME RISK - federal terrorism charges',
    ),

    FederalOperation(
      id: 'witness_intimidation',
      name: 'Witness Intimidation',
      description: 'Silence federal witnesses',
      federalHeatIncrease: 32,
      cost: 5000,
      payout: 15000,
      requiredLevel: FederalLevel.target,
      riskDescription: 'EXTREME RISK - obstruction of justice',
    ),

    FederalOperation(
      id: 'federal_judge_bribe',
      name: 'Federal Judge Bribery',
      description: 'Corrupt a federal judge',
      federalHeatIncrease: 40,
      cost: 15000,
      payout: 40000,
      requiredLevel: FederalLevel.target,
      riskDescription: 'MAXIMUM RISK - judicial corruption',
    ),

    FederalOperation(
      id: 'evidence_destruction',
      name: 'Evidence Destruction',
      description: 'Destroy evidence from federal cases',
      federalHeatIncrease: 38,
      cost: 8000,
      payout: 25000,
      requiredLevel: FederalLevel.target,
      riskDescription: 'EXTREME RISK - obstruction of justice',
    ),

    FederalOperation(
      id: 'federal_informant',
      name: 'Eliminate Federal Informant',
      description: 'Remove threat from federal informant',
      federalHeatIncrease: 42,
      cost: 12000,
      payout: 35000,
      requiredLevel: FederalLevel.target,
      riskDescription: 'MAXIMUM RISK - witness tampering',
    ),

    FederalOperation(
      id: 'missile_theft',
      name: 'Military Weapons Theft',
      description: 'Steal weapons from military base',
      federalHeatIncrease: 45,
      cost: 20000,
      payout: 50000,
      requiredLevel: FederalLevel.target,
      riskDescription: 'MAXIMUM RISK - national security threat',
    ),

    FederalOperation(
      id: 'government_blackmail',
      name: 'Government Blackmail',
      description: 'Blackmail high-ranking officials',
      federalHeatIncrease: 39,
      cost: 10000,
      payout: 30000,
      requiredLevel: FederalLevel.target,
      riskDescription: 'MAXIMUM RISK - national security',
    ),

    FederalOperation(
      id: 'international_espionage',
      name: 'International Espionage',
      description: 'Sell state secrets to foreign powers',
      federalHeatIncrease: 44,
      cost: 18000,
      payout: 45000,
      requiredLevel: FederalLevel.target,
      riskDescription: 'MAXIMUM RISK - treason charges',
    ),

    FederalOperation(
      id: 'fbi_infiltration',
      name: 'FBI Office Infiltration',
      description: 'Plant someone inside federal law enforcement',
      federalHeatIncrease: 41,
      cost: 16000,
      payout: 42000,
      requiredLevel: FederalLevel.target,
      riskDescription: 'MAXIMUM RISK - law enforcement corruption',
    ),

    FederalOperation(
      id: 'airport_heist',
      name: 'International Airport Heist',
      description: 'Rob federal customs and cargo',
      federalHeatIncrease: 36,
      cost: 11000,
      payout: 32000,
      requiredLevel: FederalLevel.target,
      riskDescription: 'EXTREME RISK - airport security breach',
    ),

    // MANHUNT Level Operations (Extreme risk, extreme reward)
    FederalOperation(
      id: 'agent_elimination',
      name: 'Federal Agent Elimination',
      description: 'Remove federal agent threat',
      federalHeatIncrease: 50,
      cost: 25000,
      payout: 75000,
      requiredLevel: FederalLevel.manhunt,
      riskDescription: 'MAXIMUM RISK - killing federal agents',
    ),

    FederalOperation(
      id: 'courthouse_bombing',
      name: 'Courthouse Operation',
      description: 'Destroy federal evidence',
      federalHeatIncrease: 55,
      cost: 50000,
      payout: 150000,
      requiredLevel: FederalLevel.manhunt,
      riskDescription: 'MAXIMUM RISK - domestic terrorism',
    ),

    FederalOperation(
      id: 'federal_building_assault',
      name: 'Federal Building Assault',
      description: 'Full-scale attack on federal facility',
      federalHeatIncrease: 60,
      cost: 75000,
      payout: 200000,
      requiredLevel: FederalLevel.manhunt,
      riskDescription: 'MAXIMUM RISK - domestic terrorism',
    ),

    FederalOperation(
      id: 'mass_prison_break',
      name: 'Mass Prison Break',
      description: 'Break out multiple federal prisoners',
      federalHeatIncrease: 58,
      cost: 60000,
      payout: 180000,
      requiredLevel: FederalLevel.manhunt,
      riskDescription: 'MAXIMUM RISK - federal prison riot',
    ),

    FederalOperation(
      id: 'nuclear_theft',
      name: 'Nuclear Material Theft',
      description: 'Steal radioactive materials',
      federalHeatIncrease: 70,
      cost: 100000,
      payout: 500000,
      requiredLevel: FederalLevel.manhunt,
      riskDescription: 'ULTIMATE RISK - nuclear terrorism',
    ),

    FederalOperation(
      id: 'presidential_threat',
      name: 'Presidential Threat',
      description: 'Threaten high-level government officials',
      federalHeatIncrease: 65,
      cost: 80000,
      payout: 300000,
      requiredLevel: FederalLevel.manhunt,
      riskDescription: 'ULTIMATE RISK - secret service involvement',
    ),

    FederalOperation(
      id: 'military_base_raid',
      name: 'Military Base Raid',
      description: 'Attack and rob military installation',
      federalHeatIncrease: 62,
      cost: 70000,
      payout: 250000,
      requiredLevel: FederalLevel.manhunt,
      riskDescription: 'ULTIMATE RISK - military engagement',
    ),

    FederalOperation(
      id: 'pentagon_hack',
      name: 'Pentagon Cyber Attack',
      description: 'Hack into highest security government systems',
      federalHeatIncrease: 68,
      cost: 90000,
      payout: 400000,
      requiredLevel: FederalLevel.manhunt,
      riskDescription: 'ULTIMATE RISK - national security breach',
    ),

    FederalOperation(
      id: 'constitution_theft',
      name: 'National Archives Heist',
      description: 'Steal priceless national documents',
      federalHeatIncrease: 66,
      cost: 85000,
      payout: 350000,
      requiredLevel: FederalLevel.manhunt,
      riskDescription: 'ULTIMATE RISK - cultural terrorism',
    ),

    FederalOperation(
      id: 'supreme_court_breach',
      name: 'Supreme Court Breach',
      description: 'Infiltrate the highest court in the land',
      federalHeatIncrease: 63,
      cost: 77000,
      payout: 280000,
      requiredLevel: FederalLevel.manhunt,
      riskDescription: 'ULTIMATE RISK - constitutional crisis',
    ),
  ];

  static List<FederalOperation> getAvailableOperations(FederalLevel currentLevel) {
    return operations.where((op) {
      // Operations are available at their required level and all higher levels
      switch (currentLevel) {
        case FederalLevel.clear:
          return op.requiredLevel == FederalLevel.clear;
        case FederalLevel.watch:
          return op.requiredLevel == FederalLevel.clear || 
                 op.requiredLevel == FederalLevel.watch;
        case FederalLevel.target:
          return op.requiredLevel != FederalLevel.manhunt;
        case FederalLevel.manhunt:
          return true; // All operations available at manhunt level
      }
    }).toList();
  }
}
