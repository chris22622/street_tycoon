import 'dart:math';

class FederalAgency {
  final String name;
  final String abbreviation;
  final String description;
  final String icon;
  final int investigationThreshold;
  final int raidThreshold;
  final double dangerMultiplier;
  final Map<String, dynamic> specialties;

  const FederalAgency({
    required this.name,
    required this.abbreviation,
    required this.description,
    required this.icon,
    required this.investigationThreshold,
    required this.raidThreshold,
    required this.dangerMultiplier,
    required this.specialties,
  });

  // Additional getters for UI compatibility
  String get fullName => name;
  List<String> get focusAreas {
    final areas = <String>[];
    if (abbreviation == 'DEA') {
      areas.addAll(['Drug Trafficking', 'Distribution Networks', 'Money Laundering']);
    } else if (abbreviation == 'FBI') {
      areas.addAll(['Organized Crime', 'Racketeering', 'Interstate Commerce']);
    } else if (abbreviation == 'ATF') {
      areas.addAll(['Firearms Trafficking', 'Explosives', 'Violent Crime']);
    } else if (abbreviation == 'IRS-CI') {
      areas.addAll(['Tax Evasion', 'Financial Crimes', 'Asset Forfeiture']);
    }
    return areas;
  }
}

class Weapon {
  final String id;
  final String name;
  final String description;
  final String icon;
  final int price;
  final int damage;
  final int reliability;
  final int concealability;
  final String category;
  final Map<String, dynamic> stats;

  const Weapon({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.price,
    required this.damage,
    required this.reliability,
    required this.concealability,
    required this.category,
    required this.stats,
  });
}

class FederalInvestigation {
  final String agencyId;
  final int intensity;
  final int duration;
  final DateTime startDate;
  final String reason;
  final Map<String, dynamic> evidence;

  const FederalInvestigation({
    required this.agencyId,
    required this.intensity,
    required this.duration,
    required this.startDate,
    required this.reason,
    required this.evidence,
  });
}

class FederalService {
  static final Random _random = Random();
  
  static List<FederalAgency> getAgencies() {
    return [
      const FederalAgency(
        name: 'Drug Enforcement Administration',
        abbreviation: 'DEA',
        description: 'Focuses on large-scale drug operations',
        icon: '💊',
        investigationThreshold: 50000, // $50k in drug sales
        raidThreshold: 100000,
        dangerMultiplier: 1.5,
        specialties: {
          'drugFocus': true,
          'surveillanceBonus': 0.3,
          'evidenceThreshold': 0.7,
        },
      ),
      
      const FederalAgency(
        name: 'Federal Bureau of Investigation',
        abbreviation: 'FBI',
        description: 'Investigates organized crime and racketeering',
        icon: '🕵️',
        investigationThreshold: 75000,
        raidThreshold: 150000,
        dangerMultiplier: 2.0,
        specialties: {
          'organizationFocus': true,
          'wiretapBonus': 0.4,
          'informantNetwork': 0.5,
        },
      ),
      
      const FederalAgency(
        name: 'Bureau of Alcohol, Tobacco, Firearms and Explosives',
        abbreviation: 'ATF',
        description: 'Handles weapons and explosives trafficking',
        icon: '💥',
        investigationThreshold: 25000, // Lower threshold for weapons
        raidThreshold: 50000,
        dangerMultiplier: 1.8,
        specialties: {
          'weaponsFocus': true,
          'firearmTracing': 0.6,
          'explosiveDetection': 0.8,
        },
      ),
      
      const FederalAgency(
        name: 'Internal Revenue Service Criminal Investigation',
        abbreviation: 'IRS-CI',
        description: 'Pursues financial crimes and tax evasion',
        icon: '💰',
        investigationThreshold: 200000, // High cash threshold
        raidThreshold: 500000,
        dangerMultiplier: 1.2,
        specialties: {
          'financialFocus': true,
          'assetForfeiture': 0.9,
          'taxEvasion': 0.7,
        },
      ),
    ];
  }
  
  static List<Weapon> getAvailableWeapons() {
    return [
      // Pistols
      const Weapon(
        id: 'glock_17',
        name: 'Glock 17',
        description: 'Reliable 9mm pistol, police standard',
        icon: '🔫',
        price: 800,
        damage: 25,
        reliability: 95,
        concealability: 70,
        category: 'Pistol',
        stats: {'capacity': 17, 'range': 'short'},
      ),
      
      const Weapon(
        id: 'desert_eagle',
        name: 'Desert Eagle .50',
        description: 'High-powered intimidation piece',
        icon: '💥',
        price: 2500,
        damage: 50,
        reliability: 80,
        concealability: 40,
        category: 'Pistol',
        stats: {'capacity': 7, 'range': 'medium', 'intimidation': 90},
      ),
      
      // Submachine Guns
      const Weapon(
        id: 'mac_10',
        name: 'MAC-10',
        description: 'Compact full-auto street sweeper',
        icon: '🔫',
        price: 1500,
        damage: 30,
        reliability: 70,
        concealability: 80,
        category: 'SMG',
        stats: {'capacity': 32, 'range': 'short', 'fullAuto': true},
      ),
      
      const Weapon(
        id: 'uzi',
        name: 'Uzi 9mm',
        description: 'Classic submachine gun',
        icon: '🔫',
        price: 2200,
        damage: 35,
        reliability: 85,
        concealability: 65,
        category: 'SMG',
        stats: {'capacity': 25, 'range': 'medium', 'fullAuto': true},
      ),
      
      // Assault Rifles
      const Weapon(
        id: 'ak_47',
        name: 'AK-47',
        description: 'Legendary assault rifle, built to last',
        icon: '🔫',
        price: 3500,
        damage: 45,
        reliability: 95,
        concealability: 20,
        category: 'Rifle',
        stats: {'capacity': 30, 'range': 'long', 'penetration': 80},
      ),
      
      const Weapon(
        id: 'ar_15',
        name: 'AR-15',
        description: 'Modular tactical rifle system',
        icon: '🔫',
        price: 2800,
        damage: 40,
        reliability: 90,
        concealability: 25,
        category: 'Rifle',
        stats: {'capacity': 30, 'range': 'long', 'accuracy': 85},
      ),
      
      // Shotguns
      const Weapon(
        id: 'sawed_off',
        name: 'Sawed-off Shotgun',
        description: 'Close-range devastation',
        icon: '💥',
        price: 600,
        damage: 60,
        reliability: 85,
        concealability: 60,
        category: 'Shotgun',
        stats: {'capacity': 2, 'range': 'close', 'spread': true},
      ),
      
      // Heavy Weapons
      const Weapon(
        id: 'rpg_7',
        name: 'RPG-7',
        description: 'Rocket-propelled grenade launcher',
        icon: '💥',
        price: 15000,
        damage: 100,
        reliability: 75,
        concealability: 5,
        category: 'Heavy',
        stats: {'capacity': 1, 'range': 'long', 'explosive': true, 'heatGeneration': 50},
      ),
      
      // Protection
      const Weapon(
        id: 'kevlar_vest',
        name: 'Kevlar Vest',
        description: 'Bullet-resistant body armor',
        icon: '🛡️',
        price: 1200,
        damage: 0,
        reliability: 95,
        concealability: 50,
        category: 'Protection',
        stats: {'protection': 40, 'durability': 100},
      ),
    ];
  }
  
  static FederalInvestigation? checkForInvestigation(
    Map<String, dynamic> gameStats,
    List<FederalInvestigation> activeInvestigations,
  ) {
    final agencies = getAgencies();
    final totalProfit = gameStats['totalProfit'] ?? 0;
    final weaponsPurchased = gameStats['weaponsPurchased'] ?? 0;
    final largestTransaction = gameStats['largestSale'] ?? 0;
    final heat = gameStats['currentHeat'] ?? 0;
    
    for (var agency in agencies) {
      // Skip if already investigating
      if (activeInvestigations.any((inv) => inv.agencyId == agency.abbreviation)) {
        continue;
      }
      
      bool shouldInvestigate = false;
      String reason = '';
      
      switch (agency.abbreviation) {
        case 'DEA':
          if (totalProfit > agency.investigationThreshold && heat > 60) {
            shouldInvestigate = true;
            reason = 'Large-scale drug trafficking operation detected';
          }
          break;
          
        case 'FBI':
          if (totalProfit > agency.investigationThreshold && largestTransaction > 25000) {
            shouldInvestigate = true;
            reason = 'Organized criminal enterprise investigation';
          }
          break;
          
        case 'ATF':
          if (weaponsPurchased > 3 || largestTransaction > agency.investigationThreshold) {
            shouldInvestigate = true;
            reason = 'Illegal weapons trafficking suspected';
          }
          break;
          
        case 'IRS-CI':
          if (totalProfit > agency.investigationThreshold) {
            shouldInvestigate = true;
            reason = 'Suspicious financial activity and tax evasion';
          }
          break;
      }
      
      if (shouldInvestigate && _random.nextInt(100) < _calculateInvestigationProbability(agency, gameStats)) {
        return FederalInvestigation(
          agencyId: agency.abbreviation,
          intensity: _random.nextInt(100) + 1,
          duration: _random.nextInt(30) + 14, // 2-6 weeks
          startDate: DateTime.now(),
          reason: reason,
          evidence: _generateEvidence(agency, gameStats),
        );
      }
    }
    
    return null;
  }
  
  static int _calculateInvestigationProbability(FederalAgency agency, Map<String, dynamic> stats) {
    final baseChance = 5; // 5% base chance
    final heat = stats['currentHeat'] ?? 0;
    final profit = stats['totalProfit'] ?? 0;
    
    var probability = baseChance;
    
    // Heat factor
    if (heat > 80) probability += 15;
    else if (heat > 60) probability += 10;
    else if (heat > 40) probability += 5;
    
    // Profit factor
    if (profit > agency.investigationThreshold * 3) probability += 20;
    else if (profit > agency.investigationThreshold * 2) probability += 10;
    else if (profit > agency.investigationThreshold) probability += 5;
    
    return probability.clamp(0, 80); // Max 80% chance
  }
  
  static Map<String, dynamic> _generateEvidence(FederalAgency agency, Map<String, dynamic> stats) {
    final evidence = <String, dynamic>{};
    
    switch (agency.abbreviation) {
      case 'DEA':
        evidence['drugSales'] = stats['totalSales'] ?? 0;
        evidence['surveillance'] = _random.nextInt(100);
        evidence['informants'] = _random.nextInt(3);
        break;
        
      case 'FBI':
        evidence['financialRecords'] = stats['totalProfit'] ?? 0;
        evidence['wiretaps'] = _random.nextInt(50);
        evidence['associates'] = _random.nextInt(5);
        break;
        
      case 'ATF':
        evidence['weaponsPurchases'] = stats['weaponsPurchased'] ?? 0;
        evidence['gunTraces'] = _random.nextInt(10);
        evidence['explosives'] = _random.nextInt(2);
        break;
        
      case 'IRS-CI':
        evidence['unreportedIncome'] = stats['totalProfit'] ?? 0;
        evidence['cashTransactions'] = stats['largestSale'] ?? 0;
        evidence['assetDiscrepancy'] = _random.nextInt(100000);
        break;
    }
    
    return evidence;
  }
  
  static Map<String, dynamic> simulateRaid(
    FederalInvestigation investigation,
    Map<String, dynamic> gameState,
  ) {
    final agency = getAgencies().firstWhere((a) => a.abbreviation == investigation.agencyId);
    final results = <String, dynamic>{};
    
    // Calculate raid success
    final evidence = investigation.evidence;
    final playerDefense = gameState['weapons']?.length ?? 0;
    final playerCash = gameState['cash'] ?? 0;
    
    final raidSuccess = _random.nextInt(100) + investigation.intensity;
    final escapeChance = playerDefense * 5 + _random.nextInt(50);
    
    if (raidSuccess > escapeChance) {
      // Raid successful
      results['outcome'] = 'arrested';
      results['charges'] = _generateCharges(agency, evidence);
      results['sentenceYears'] = _calculateSentence(results['charges']);
      results['assetSeizure'] = (playerCash * 0.8).round();
    } else {
      // Player escapes
      results['outcome'] = 'escaped';
      results['heatIncrease'] = 30 + investigation.intensity ~/ 2;
      results['assetSeizure'] = (playerCash * 0.3).round();
    }
    
    return results;
  }
  
  static List<String> _generateCharges(FederalAgency agency, Map<String, dynamic> evidence) {
    final charges = <String>[];
    
    switch (agency.abbreviation) {
      case 'DEA':
        charges.add('Drug Trafficking (21 USC 841)');
        charges.add('Conspiracy to Distribute (21 USC 846)');
        if (evidence['drugSales'] > 100000) {
          charges.add('Continuing Criminal Enterprise (21 USC 848)');
        }
        break;
        
      case 'FBI':
        charges.add('Racketeering (RICO)');
        charges.add('Money Laundering (18 USC 1956)');
        charges.add('Criminal Enterprise');
        break;
        
      case 'ATF':
        charges.add('Illegal Firearms Trafficking (18 USC 922)');
        charges.add('Possession of Unregistered Firearms');
        if (evidence['explosives'] > 0) {
          charges.add('Explosive Devices (18 USC 842)');
        }
        break;
        
      case 'IRS-CI':
        charges.add('Tax Evasion (26 USC 7201)');
        charges.add('Money Laundering (31 USC 5324)');
        charges.add('Structuring Transactions');
        break;
    }
    
    return charges;
  }
  
  static int _calculateSentence(List<String> charges) {
    int totalYears = 0;
    
    for (var charge in charges) {
      if (charge.contains('Drug Trafficking')) totalYears += 10;
      if (charge.contains('Conspiracy')) totalYears += 5;
      if (charge.contains('Criminal Enterprise') || charge.contains('RICO')) totalYears += 20;
      if (charge.contains('Money Laundering')) totalYears += 7;
      if (charge.contains('Firearms')) totalYears += 5;
      if (charge.contains('Explosive')) totalYears += 15;
      if (charge.contains('Tax Evasion')) totalYears += 3;
    }
    
    return totalYears.clamp(5, 99); // 5 years minimum, life maximum (99 years)
  }

  // Get all agencies (for UI)
  static List<FederalAgency> getAllAgencies() => getAgencies();

  // Calculate overall heat level (1-5)
  static int calculateOverallHeatLevel(int totalSales, int weaponsValue, Map<String, int> weapons) {
    double totalHeat = 0;
    final agencies = getAgencies();
    
    for (final agency in agencies) {
      final chance = calculateInvestigationChance(agency, totalSales, weaponsValue, weapons);
      totalHeat += chance * agency.dangerMultiplier;
    }
    
    if (totalHeat < 0.2) return 1;
    if (totalHeat < 0.5) return 2;
    if (totalHeat < 1.0) return 3;
    if (totalHeat < 2.0) return 4;
    return 5;
  }

  // Calculate investigation chance for a specific agency
  static double calculateInvestigationChance(
    FederalAgency agency, 
    int totalSales, 
    int weaponsValue, 
    Map<String, int> weapons
  ) {
    double baseChance = 0.0;
    
    // Base calculation based on agency thresholds
    if (agency.abbreviation == 'DEA') {
      baseChance = (totalSales / agency.investigationThreshold).clamp(0.0, 1.0);
    } else if (agency.abbreviation == 'ATF') {
      baseChance = (weaponsValue / agency.investigationThreshold).clamp(0.0, 1.0);
    } else if (agency.abbreviation == 'FBI') {
      final totalActivity = totalSales + weaponsValue;
      baseChance = (totalActivity / agency.investigationThreshold).clamp(0.0, 1.0);
    } else if (agency.abbreviation == 'IRS-CI') {
      // IRS focuses on unreported income
      final estimatedUnreported = totalSales * 0.8; // Assume 80% unreported
      baseChance = (estimatedUnreported / agency.investigationThreshold).clamp(0.0, 1.0);
    }
    
    // Apply specialty multipliers
    if (agency.abbreviation == 'ATF' && weapons.isNotEmpty) {
      final weaponsFocus = agency.specialties['weaponsFocus'] as bool? ?? false;
      if (weaponsFocus) {
        baseChance *= 1.5;
      }
    }
    
    return (baseChance * agency.dangerMultiplier).clamp(0.0, 1.0);
  }
}
