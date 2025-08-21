import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

// Advanced Legal System
// Feature #21: Ultra-comprehensive legal mechanics with court cases,
// lawyers, legal consequences, and judicial corruption

enum CrimeType {
  drugPossession,
  drugTrafficking,
  drugManufacturing,
  assault,
  murder,
  extortion,
  moneyLaundering,
  racketeering,
  corruption,
  taxEvasion,
  armsDealing,
  humanTrafficking
}

enum CaseSeverity {
  misdemeanor,
  felony,
  majorFelony,
  federal,
  rico
}

enum CourtType {
  municipal,
  district,
  superior,
  federal,
  supreme
}

enum LawyerType {
  publicDefender,
  privateCriminal,
  corporateLawyer,
  federalSpecialist,
  corruptLawyer
}

enum CaseStatus {
  investigation,
  arrested,
  charged,
  trial,
  sentencing,
  appeal,
  closed
}

class LegalCase {
  final String id;
  final String playerId;
  final CrimeType crimeType;
  final CaseSeverity severity;
  final CourtType courtType;
  final CaseStatus status;
  final DateTime dateCharged;
  final DateTime? trialDate;
  final DateTime? sentenceDate;
  final List<String> charges;
  final List<String> evidence;
  final double evidenceStrength;
  final String? assignedLawyer;
  final String? prosecutorId;
  final String? judgeId;
  final Map<String, dynamic> caseDetails;
  final double corruptionLevel;
  final bool isActive;

  LegalCase({
    required this.id,
    required this.playerId,
    required this.crimeType,
    required this.severity,
    required this.courtType,
    this.status = CaseStatus.investigation,
    required this.dateCharged,
    this.trialDate,
    this.sentenceDate,
    this.charges = const [],
    this.evidence = const [],
    this.evidenceStrength = 0.5,
    this.assignedLawyer,
    this.prosecutorId,
    this.judgeId,
    this.caseDetails = const {},
    this.corruptionLevel = 0.0,
    this.isActive = true,
  });

  LegalCase copyWith({
    String? id,
    String? playerId,
    CrimeType? crimeType,
    CaseSeverity? severity,
    CourtType? courtType,
    CaseStatus? status,
    DateTime? dateCharged,
    DateTime? trialDate,
    DateTime? sentenceDate,
    List<String>? charges,
    List<String>? evidence,
    double? evidenceStrength,
    String? assignedLawyer,
    String? prosecutorId,
    String? judgeId,
    Map<String, dynamic>? caseDetails,
    double? corruptionLevel,
    bool? isActive,
  }) {
    return LegalCase(
      id: id ?? this.id,
      playerId: playerId ?? this.playerId,
      crimeType: crimeType ?? this.crimeType,
      severity: severity ?? this.severity,
      courtType: courtType ?? this.courtType,
      status: status ?? this.status,
      dateCharged: dateCharged ?? this.dateCharged,
      trialDate: trialDate ?? this.trialDate,
      sentenceDate: sentenceDate ?? this.sentenceDate,
      charges: charges ?? this.charges,
      evidence: evidence ?? this.evidence,
      evidenceStrength: evidenceStrength ?? this.evidenceStrength,
      assignedLawyer: assignedLawyer ?? this.assignedLawyer,
      prosecutorId: prosecutorId ?? this.prosecutorId,
      judgeId: judgeId ?? this.judgeId,
      caseDetails: caseDetails ?? this.caseDetails,
      corruptionLevel: corruptionLevel ?? this.corruptionLevel,
      isActive: isActive ?? this.isActive,
    );
  }

  double get convictionProbability {
    double base = evidenceStrength;
    
    // Severity modifier
    switch (severity) {
      case CaseSeverity.misdemeanor:
        base *= 0.8;
        break;
      case CaseSeverity.felony:
        base *= 1.0;
        break;
      case CaseSeverity.majorFelony:
        base *= 1.2;
        break;
      case CaseSeverity.federal:
        base *= 1.4;
        break;
      case CaseSeverity.rico:
        base *= 1.6;
        break;
    }
    
    // Corruption reduces conviction probability
    base *= (1.0 - corruptionLevel);
    
    return base.clamp(0.0, 1.0);
  }

  int get potentialSentenceYears {
    int baseYears = 1;
    
    switch (crimeType) {
      case CrimeType.drugPossession:
        baseYears = 1;
        break;
      case CrimeType.drugTrafficking:
        baseYears = 5;
        break;
      case CrimeType.drugManufacturing:
        baseYears = 8;
        break;
      case CrimeType.assault:
        baseYears = 2;
        break;
      case CrimeType.murder:
        baseYears = 25;
        break;
      case CrimeType.extortion:
        baseYears = 3;
        break;
      case CrimeType.moneyLaundering:
        baseYears = 10;
        break;
      case CrimeType.racketeering:
        baseYears = 15;
        break;
      case CrimeType.corruption:
        baseYears = 5;
        break;
      case CrimeType.taxEvasion:
        baseYears = 3;
        break;
      case CrimeType.armsDealing:
        baseYears = 12;
        break;
      case CrimeType.humanTrafficking:
        baseYears = 20;
        break;
    }
    
    // Multiply by severity
    switch (severity) {
      case CaseSeverity.misdemeanor:
        baseYears = (baseYears * 0.3).round();
        break;
      case CaseSeverity.felony:
        break;
      case CaseSeverity.majorFelony:
        baseYears = (baseYears * 1.5).round();
        break;
      case CaseSeverity.federal:
        baseYears = (baseYears * 2.0).round();
        break;
      case CaseSeverity.rico:
        baseYears = (baseYears * 3.0).round();
        break;
    }
    
    return baseYears;
  }
}

class Lawyer {
  final String id;
  final String name;
  final LawyerType type;
  final double experience;
  final double winRate;
  final double corruptionWillingness;
  final double hourlyRate;
  final List<String> specialties;
  final int casesWon;
  final int casesLost;
  final double reputation;
  final bool isAvailable;
  final Map<String, dynamic> personalData;

  Lawyer({
    required this.id,
    required this.name,
    required this.type,
    this.experience = 0.5,
    this.winRate = 0.5,
    this.corruptionWillingness = 0.0,
    this.hourlyRate = 500.0,
    this.specialties = const [],
    this.casesWon = 0,
    this.casesLost = 0,
    this.reputation = 0.5,
    this.isAvailable = true,
    this.personalData = const {},
  });

  Lawyer copyWith({
    String? id,
    String? name,
    LawyerType? type,
    double? experience,
    double? winRate,
    double? corruptionWillingness,
    double? hourlyRate,
    List<String>? specialties,
    int? casesWon,
    int? casesLost,
    double? reputation,
    bool? isAvailable,
    Map<String, dynamic>? personalData,
  }) {
    return Lawyer(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      experience: experience ?? this.experience,
      winRate: winRate ?? this.winRate,
      corruptionWillingness: corruptionWillingness ?? this.corruptionWillingness,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      specialties: specialties ?? this.specialties,
      casesWon: casesWon ?? this.casesWon,
      casesLost: casesLost ?? this.casesLost,
      reputation: reputation ?? this.reputation,
      isAvailable: isAvailable ?? this.isAvailable,
      personalData: personalData ?? this.personalData,
    );
  }

  double get totalCases => (casesWon + casesLost).toDouble();
  double get actualWinRate => totalCases > 0 ? casesWon / totalCases : 0.5;
  double get competencyScore => (experience + actualWinRate + reputation) / 3.0;
}

class Judge {
  final String id;
  final String name;
  final CourtType courtType;
  final double experience;
  final double corruption;
  final double strictness;
  final double fairness;
  final List<String> biases;
  final Map<String, double> sentencingTendencies;
  final int casesOverseen;

  Judge({
    required this.id,
    required this.name,
    required this.courtType,
    this.experience = 0.5,
    this.corruption = 0.0,
    this.strictness = 0.5,
    this.fairness = 0.8,
    this.biases = const [],
    this.sentencingTendencies = const {},
    this.casesOverseen = 0,
  });

  double get sentencingModifier {
    return strictness - corruption + fairness;
  }
}

class Sentence {
  final String id;
  final String caseId;
  final int prisonYears;
  final double fineAmount;
  final int communityServiceHours;
  final List<String> conditions;
  final bool isAppealed;
  final DateTime dateIssued;
  final DateTime? releaseDate;

  Sentence({
    required this.id,
    required this.caseId,
    this.prisonYears = 0,
    this.fineAmount = 0.0,
    this.communityServiceHours = 0,
    this.conditions = const [],
    this.isAppealed = false,
    required this.dateIssued,
    this.releaseDate,
  });
}

class AdvancedLegalSystem extends ChangeNotifier {
  static final AdvancedLegalSystem _instance = AdvancedLegalSystem._internal();
  factory AdvancedLegalSystem() => _instance;
  AdvancedLegalSystem._internal() {
    _initializeSystem();
  }

  final Map<String, LegalCase> _cases = {};
  final Map<String, Lawyer> _lawyers = {};
  final Map<String, Judge> _judges = {};
  final Map<String, Sentence> _sentences = {};
  
  String? _playerId;
  int _totalCases = 0;
  int _activeCases = 0;
  double _legalHeat = 0.0;
  double _corruptionLevel = 0.3;
  String? _currentLawyer;
  
  Timer? _systemTimer;
  final math.Random _random = math.Random();

  // Getters
  Map<String, LegalCase> get cases => Map.unmodifiable(_cases);
  Map<String, Lawyer> get lawyers => Map.unmodifiable(_lawyers);
  Map<String, Judge> get judges => Map.unmodifiable(_judges);
  Map<String, Sentence> get sentences => Map.unmodifiable(_sentences);
  String? get playerId => _playerId;
  int get totalCases => _totalCases;
  int get activeCases => _activeCases;
  double get legalHeat => _legalHeat;
  double get corruptionLevel => _corruptionLevel;
  String? get currentLawyer => _currentLawyer;

  void _initializeSystem() {
    _playerId = 'player_${DateTime.now().millisecondsSinceEpoch}';
    _generateLawyers();
    _generateJudges();
    _startSystemTimer();
  }

  void _generateLawyers() {
    final lawyerDefinitions = _getLawyerDefinitions();
    
    for (final lawyer in lawyerDefinitions) {
      _lawyers[lawyer.id] = lawyer;
    }
  }

  List<Lawyer> _getLawyerDefinitions() {
    return [
      Lawyer(
        id: 'lawyer_sarah_martinez',
        name: 'Sarah Martinez',
        type: LawyerType.publicDefender,
        experience: 0.4,
        winRate: 0.3,
        corruptionWillingness: 0.1,
        hourlyRate: 150.0,
        specialties: ['drug_crimes', 'assault'],
        reputation: 0.3,
      ),
      Lawyer(
        id: 'lawyer_james_blackwood',
        name: 'James Blackwood',
        type: LawyerType.privateCriminal,
        experience: 0.8,
        winRate: 0.7,
        corruptionWillingness: 0.4,
        hourlyRate: 1200.0,
        specialties: ['murder', 'racketeering', 'organized_crime'],
        casesWon: 45,
        casesLost: 18,
        reputation: 0.8,
      ),
      Lawyer(
        id: 'lawyer_elizabeth_stone',
        name: 'Elizabeth Stone',
        type: LawyerType.corporateLawyer,
        experience: 0.9,
        winRate: 0.8,
        corruptionWillingness: 0.6,
        hourlyRate: 2000.0,
        specialties: ['money_laundering', 'tax_evasion', 'corruption'],
        casesWon: 67,
        casesLost: 12,
        reputation: 0.9,
      ),
      Lawyer(
        id: 'lawyer_michael_graves',
        name: 'Michael Graves',
        type: LawyerType.federalSpecialist,
        experience: 0.95,
        winRate: 0.6,
        corruptionWillingness: 0.2,
        hourlyRate: 1500.0,
        specialties: ['federal_crimes', 'rico', 'trafficking'],
        casesWon: 89,
        casesLost: 34,
        reputation: 0.85,
      ),
      Lawyer(
        id: 'lawyer_victor_corrupt',
        name: 'Victor Serpentine',
        type: LawyerType.corruptLawyer,
        experience: 0.7,
        winRate: 0.9,
        corruptionWillingness: 0.95,
        hourlyRate: 3000.0,
        specialties: ['bribery', 'evidence_tampering', 'witness_intimidation'],
        casesWon: 156,
        casesLost: 8,
        reputation: 0.6, // Lower public reputation
      ),
    ];
  }

  void _generateJudges() {
    final judgeDefinitions = _getJudgeDefinitions();
    
    for (final judge in judgeDefinitions) {
      _judges[judge.id] = judge;
    }
  }

  List<Judge> _getJudgeDefinitions() {
    return [
      Judge(
        id: 'judge_robert_fairman',
        name: 'Judge Robert Fairman',
        courtType: CourtType.municipal,
        experience: 0.8,
        corruption: 0.1,
        strictness: 0.6,
        fairness: 0.9,
        biases: ['anti_drug'],
        sentencingTendencies: {'drug_crimes': 1.2, 'violent_crimes': 0.8},
        casesOverseen: 234,
      ),
      Judge(
        id: 'judge_maria_stern',
        name: 'Judge Maria Stern',
        courtType: CourtType.district,
        experience: 0.9,
        corruption: 0.05,
        strictness: 0.8,
        fairness: 0.95,
        biases: ['pro_victim'],
        sentencingTendencies: {'violent_crimes': 1.5, 'financial_crimes': 0.9},
        casesOverseen: 456,
      ),
      Judge(
        id: 'judge_thomas_corrupt',
        name: 'Judge Thomas Pocket',
        courtType: CourtType.superior,
        experience: 0.7,
        corruption: 0.8,
        strictness: 0.3,
        fairness: 0.4,
        biases: ['money_motivated'],
        sentencingTendencies: {'all_crimes': 0.5}, // Lenient when bribed
        casesOverseen: 123,
      ),
      Judge(
        id: 'judge_patricia_hammer',
        name: 'Judge Patricia Hammer',
        courtType: CourtType.federal,
        experience: 0.95,
        corruption: 0.02,
        strictness: 0.95,
        fairness: 0.9,
        biases: ['law_and_order'],
        sentencingTendencies: {'all_crimes': 1.3}, // Harsh sentences
        casesOverseen: 789,
      ),
    ];
  }

  void _startSystemTimer() {
    _systemTimer?.cancel();
    _systemTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      _processCases();
      _updateLegalHeat();
      _simulateLegalEvents();
      notifyListeners();
    });
  }

  // Case Management
  String createLegalCase(CrimeType crimeType, List<String> evidence, {
    double evidenceStrength = 0.5,
    Map<String, dynamic>? details,
  }) {
    final caseId = 'case_${DateTime.now().millisecondsSinceEpoch}';
    final severity = _determineCaseSeverity(crimeType, evidence);
    final courtType = _determineCourtType(severity);
    
    final legalCase = LegalCase(
      id: caseId,
      playerId: _playerId!,
      crimeType: crimeType,
      severity: severity,
      courtType: courtType,
      dateCharged: DateTime.now(),
      charges: _generateCharges(crimeType, severity),
      evidence: evidence,
      evidenceStrength: evidenceStrength,
      caseDetails: details ?? {},
    );

    _cases[caseId] = legalCase;
    _totalCases++;
    _activeCases++;
    _legalHeat += 0.1;

    // Assign prosecutor and judge
    _assignProsecutorAndJudge(caseId);
    
    // Schedule trial date
    _scheduleTrialDate(caseId);
    
    return caseId;
  }

  CaseSeverity _determineCaseSeverity(CrimeType crimeType, List<String> evidence) {
    switch (crimeType) {
      case CrimeType.drugPossession:
        return evidence.length > 2 ? CaseSeverity.felony : CaseSeverity.misdemeanor;
      case CrimeType.drugTrafficking:
        return evidence.length > 3 ? CaseSeverity.majorFelony : CaseSeverity.felony;
      case CrimeType.drugManufacturing:
        return CaseSeverity.majorFelony;
      case CrimeType.assault:
        return CaseSeverity.misdemeanor;
      case CrimeType.murder:
        return CaseSeverity.majorFelony;
      case CrimeType.extortion:
        return CaseSeverity.felony;
      case CrimeType.moneyLaundering:
        return evidence.length > 4 ? CaseSeverity.federal : CaseSeverity.majorFelony;
      case CrimeType.racketeering:
        return CaseSeverity.rico;
      case CrimeType.corruption:
        return CaseSeverity.federal;
      case CrimeType.taxEvasion:
        return CaseSeverity.federal;
      case CrimeType.armsDealing:
        return CaseSeverity.federal;
      case CrimeType.humanTrafficking:
        return CaseSeverity.federal;
    }
  }

  CourtType _determineCourtType(CaseSeverity severity) {
    switch (severity) {
      case CaseSeverity.misdemeanor:
        return CourtType.municipal;
      case CaseSeverity.felony:
        return CourtType.district;
      case CaseSeverity.majorFelony:
        return CourtType.superior;
      case CaseSeverity.federal:
      case CaseSeverity.rico:
        return CourtType.federal;
    }
  }

  List<String> _generateCharges(CrimeType crimeType, CaseSeverity severity) {
    List<String> charges = [crimeType.name];
    
    // Add additional charges based on severity
    switch (severity) {
      case CaseSeverity.majorFelony:
        charges.add('conspiracy');
        break;
      case CaseSeverity.federal:
        charges.addAll(['federal_conspiracy', 'interstate_commerce_violation']);
        break;
      case CaseSeverity.rico:
        charges.addAll(['racketeering', 'criminal_enterprise', 'conspiracy']);
        break;
      default:
        break;
    }
    
    return charges;
  }

  void _assignProsecutorAndJudge(String caseId) {
    final legalCase = _cases[caseId]!;
    
    // Find appropriate judge for court type
    final availableJudges = _judges.values
        .where((judge) => judge.courtType == legalCase.courtType)
        .toList();
    
    if (availableJudges.isNotEmpty) {
      final assignedJudge = availableJudges[_random.nextInt(availableJudges.length)];
      
      _cases[caseId] = legalCase.copyWith(
        judgeId: assignedJudge.id,
        prosecutorId: 'prosecutor_${_random.nextInt(10)}',
      );
    }
  }

  void _scheduleTrialDate(String caseId) {
    final legalCase = _cases[caseId]!;
    
    // Trial date based on court type and backlog
    int daysUntilTrial = 30;
    
    switch (legalCase.courtType) {
      case CourtType.municipal:
        daysUntilTrial = 14;
        break;
      case CourtType.district:
        daysUntilTrial = 30;
        break;
      case CourtType.superior:
        daysUntilTrial = 60;
        break;
      case CourtType.federal:
        daysUntilTrial = 90;
        break;
      case CourtType.supreme:
        daysUntilTrial = 180;
        break;
    }
    
    final trialDate = DateTime.now().add(Duration(days: daysUntilTrial + _random.nextInt(14)));
    
    _cases[caseId] = legalCase.copyWith(
      trialDate: trialDate,
      status: CaseStatus.charged,
    );
  }

  // Lawyer Management
  void hireLawyer(String lawyerId) {
    final lawyer = _lawyers[lawyerId];
    if (lawyer != null && lawyer.isAvailable) {
      _currentLawyer = lawyerId;
      
      _lawyers[lawyerId] = lawyer.copyWith(isAvailable: false);
    }
  }

  void fireLawyer() {
    if (_currentLawyer != null) {
      final lawyer = _lawyers[_currentLawyer!];
      if (lawyer != null) {
        _lawyers[_currentLawyer!] = lawyer.copyWith(isAvailable: true);
      }
      _currentLawyer = null;
    }
  }

  // Corruption and Bribery
  bool attemptBribery(String caseId, double amount, String target) {
    final legalCase = _cases[caseId];
    if (legalCase == null) return false;
    
    double successChance = 0.0;
    
    if (target == 'judge') {
      final judge = _judges[legalCase.judgeId];
      if (judge != null) {
        successChance = judge.corruption * (amount / 50000.0);
      }
    } else if (target == 'prosecutor') {
      successChance = _corruptionLevel * (amount / 25000.0);
    }
    
    successChance = successChance.clamp(0.0, 0.9);
    
    if (_random.nextDouble() < successChance) {
      // Successful bribery
      _cases[caseId] = legalCase.copyWith(
        corruptionLevel: (legalCase.corruptionLevel + 0.3).clamp(0.0, 1.0),
        evidenceStrength: (legalCase.evidenceStrength - 0.2).clamp(0.0, 1.0),
      );
      return true;
    } else {
      // Failed bribery - increases legal heat
      _legalHeat += 0.2;
      
      // Chance of additional charges
      if (_random.nextDouble() < 0.3) {
        createLegalCase(CrimeType.corruption, ['bribery_attempt'], evidenceStrength: 0.7);
      }
      
      return false;
    }
  }

  void tamperWithEvidence(String caseId) {
    final legalCase = _cases[caseId];
    final lawyer = _currentLawyer != null ? _lawyers[_currentLawyer!] : null;
    
    if (legalCase != null && lawyer != null && lawyer.corruptionWillingness > 0.5) {
      double successChance = lawyer.corruptionWillingness * 0.6;
      
      if (_random.nextDouble() < successChance) {
        // Successful tampering
        _cases[caseId] = legalCase.copyWith(
          evidenceStrength: (legalCase.evidenceStrength - 0.3).clamp(0.0, 1.0),
          evidence: legalCase.evidence.where((e) => !e.contains('key_evidence')).toList(),
        );
      } else {
        // Failed tampering - severe consequences
        _legalHeat += 0.4;
        createLegalCase(CrimeType.corruption, ['evidence_tampering'], evidenceStrength: 0.8);
      }
    }
  }

  // Trial System
  void conductTrial(String caseId) {
    final legalCase = _cases[caseId];
    if (legalCase == null || legalCase.status != CaseStatus.charged) return;
    
    _cases[caseId] = legalCase.copyWith(status: CaseStatus.trial);
    
    // Schedule trial outcome
    Timer(const Duration(seconds: 5), () {
      _resolveTrialOutcome(caseId);
    });
  }

  void _resolveTrialOutcome(String caseId) {
    final legalCase = _cases[caseId];
    if (legalCase == null) return;
    
    final lawyer = _currentLawyer != null ? _lawyers[_currentLawyer!] : null;
    final judge = _judges[legalCase.judgeId];
    
    // Calculate conviction probability
    double convictionChance = legalCase.convictionProbability;
    
    // Lawyer impact
    if (lawyer != null) {
      convictionChance *= (1.0 - lawyer.competencyScore * 0.5);
    } else {
      // No lawyer penalty
      convictionChance *= 1.3;
    }
    
    // Judge impact
    if (judge != null) {
      convictionChance *= (judge.fairness + judge.strictness) / 2.0;
    }
    
    convictionChance = convictionChance.clamp(0.1, 0.9);
    
    if (_random.nextDouble() < convictionChance) {
      // Convicted
      _issueSentence(caseId, true);
      
      // Update lawyer record
      if (lawyer != null) {
        _lawyers[_currentLawyer!] = lawyer.copyWith(
          casesLost: lawyer.casesLost + 1,
        );
      }
    } else {
      // Acquitted
      _cases[caseId] = legalCase.copyWith(
        status: CaseStatus.closed,
        isActive: false,
      );
      
      _activeCases--;
      
      // Update lawyer record
      if (lawyer != null) {
        _lawyers[_currentLawyer!] = lawyer.copyWith(
          casesWon: lawyer.casesWon + 1,
        );
      }
    }
  }

  void _issueSentence(String caseId, bool isConvicted) {
    final legalCase = _cases[caseId]!;
    final judge = _judges[legalCase.judgeId];
    
    if (isConvicted) {
      int prisonYears = legalCase.potentialSentenceYears;
      double fineAmount = prisonYears * 10000.0;
      
      // Judge modifiers
      if (judge != null) {
        prisonYears = (prisonYears * judge.sentencingModifier).round();
        fineAmount *= judge.sentencingModifier;
      }
      
      // Corruption reduces sentence
      prisonYears = (prisonYears * (1.0 - legalCase.corruptionLevel)).round();
      fineAmount *= (1.0 - legalCase.corruptionLevel);
      
      final sentenceId = 'sentence_${DateTime.now().millisecondsSinceEpoch}';
      
      _sentences[sentenceId] = Sentence(
        id: sentenceId,
        caseId: caseId,
        prisonYears: prisonYears,
        fineAmount: fineAmount,
        dateIssued: DateTime.now(),
        releaseDate: prisonYears > 0 ? DateTime.now().add(Duration(days: prisonYears * 365)) : null,
      );
      
      _cases[caseId] = legalCase.copyWith(
        status: CaseStatus.sentencing,
        sentenceDate: DateTime.now(),
      );
    }
    
    _activeCases--;
  }

  // System Updates
  void _processCases() {
    for (final caseId in _cases.keys.toList()) {
      final legalCase = _cases[caseId]!;
      
      // Auto-conduct trials when trial date arrives
      if (legalCase.status == CaseStatus.charged && 
          legalCase.trialDate != null &&
          DateTime.now().isAfter(legalCase.trialDate!)) {
        conductTrial(caseId);
      }
    }
  }

  void _updateLegalHeat() {
    // Legal heat naturally decreases over time
    _legalHeat = (_legalHeat - 0.01).clamp(0.0, 1.0);
    
    // Active cases increase heat
    _legalHeat += _activeCases * 0.005;
  }

  void _simulateLegalEvents() {
    if (_random.nextDouble() < 0.05) {
      _generateRandomLegalEvent();
    }
  }

  void _generateRandomLegalEvent() {
    final events = [
      'police_investigation',
      'witness_testimony',
      'evidence_discovery',
      'plea_bargain_offer',
      'corruption_scandal',
    ];
    
    final event = events[_random.nextInt(events.length)];
    _handleRandomLegalEvent(event);
  }

  void _handleRandomLegalEvent(String event) {
    switch (event) {
      case 'police_investigation':
        _legalHeat += 0.1;
        break;
      case 'witness_testimony':
        // Find active case and strengthen evidence
        final activeCases = _cases.values.where((c) => c.isActive).toList();
        if (activeCases.isNotEmpty) {
          final targetCase = activeCases[_random.nextInt(activeCases.length)];
          _cases[targetCase.id] = targetCase.copyWith(
            evidenceStrength: (targetCase.evidenceStrength + 0.2).clamp(0.0, 1.0),
            evidence: [...targetCase.evidence, 'witness_testimony'],
          );
        }
        break;
      case 'evidence_discovery':
        // Create new case with strong evidence
        createLegalCase(
          CrimeType.values[_random.nextInt(CrimeType.values.length)],
          ['discovered_evidence', 'police_raid'],
          evidenceStrength: 0.8,
        );
        break;
      case 'plea_bargain_offer':
        // Offer plea bargain for active cases
        final activeCases = _cases.values.where((c) => c.isActive && c.status == CaseStatus.charged).toList();
        if (activeCases.isNotEmpty) {
          final targetCase = activeCases[_random.nextInt(activeCases.length)];
          // Auto-accept if evidence is strong
          if (targetCase.evidenceStrength > 0.7) {
            _issueSentence(targetCase.id, true);
          }
        }
        break;
      case 'corruption_scandal':
        _corruptionLevel = (_corruptionLevel + 0.1).clamp(0.0, 1.0);
        break;
    }
  }

  // Public Interface Methods
  List<LegalCase> getActiveCases() {
    return _cases.values.where((c) => c.isActive).toList()
      ..sort((a, b) => b.dateCharged.compareTo(a.dateCharged));
  }

  List<Lawyer> getAvailableLawyers() {
    return _lawyers.values.where((l) => l.isAvailable).toList()
      ..sort((a, b) => b.competencyScore.compareTo(a.competencyScore));
  }

  List<Sentence> getActiveSentences() {
    return _sentences.values.toList()
      ..sort((a, b) => b.dateIssued.compareTo(a.dateIssued));
  }

  Lawyer? getCurrentLawyer() {
    return _currentLawyer != null ? _lawyers[_currentLawyer!] : null;
  }

  double calculateLawyerCost(String lawyerId, String caseId) {
    final lawyer = _lawyers[lawyerId];
    final legalCase = _cases[caseId];
    
    if (lawyer == null || legalCase == null) return 0.0;
    
    double estimatedHours = 20.0; // Base hours
    
    // More complex cases require more hours
    switch (legalCase.severity) {
      case CaseSeverity.misdemeanor:
        estimatedHours = 10.0;
        break;
      case CaseSeverity.felony:
        estimatedHours = 30.0;
        break;
      case CaseSeverity.majorFelony:
        estimatedHours = 60.0;
        break;
      case CaseSeverity.federal:
        estimatedHours = 100.0;
        break;
      case CaseSeverity.rico:
        estimatedHours = 150.0;
        break;
    }
    
    return estimatedHours * lawyer.hourlyRate;
  }

  bool canAppealCase(String caseId) {
    final legalCase = _cases[caseId];
    return legalCase != null && 
           legalCase.status == CaseStatus.sentencing &&
           !_sentences.values.any((s) => s.caseId == caseId && s.isAppealed);
  }

  void appealCase(String caseId) {
    final sentence = _sentences.values.where((s) => s.caseId == caseId).firstOrNull;
    if (sentence != null && canAppealCase(caseId)) {
      // Appeal reduces sentence by 20-50%
      final reduction = 0.2 + _random.nextDouble() * 0.3;
      
      _sentences[sentence.id] = Sentence(
        id: sentence.id,
        caseId: sentence.caseId,
        prisonYears: (sentence.prisonYears * (1.0 - reduction)).round(),
        fineAmount: sentence.fineAmount * (1.0 - reduction),
        communityServiceHours: sentence.communityServiceHours,
        conditions: sentence.conditions,
        isAppealed: true,
        dateIssued: sentence.dateIssued,
        releaseDate: sentence.releaseDate,
      );
    }
  }

  void dispose() {
    _systemTimer?.cancel();
    super.dispose();
  }
}

// Advanced Legal Dashboard Widget
class AdvancedLegalDashboardWidget extends StatefulWidget {
  const AdvancedLegalDashboardWidget({super.key});

  @override
  State<AdvancedLegalDashboardWidget> createState() => _AdvancedLegalDashboardWidgetState();
}

class _AdvancedLegalDashboardWidgetState extends State<AdvancedLegalDashboardWidget>
    with TickerProviderStateMixin {
  final AdvancedLegalSystem _legalSystem = AdvancedLegalSystem();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _legalSystem,
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
    final currentLawyer = _legalSystem.getCurrentLawyer();
    
    return Row(
      children: [
        const Text(
          'Legal Affairs',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        if (currentLawyer != null) ...[
          const Icon(Icons.gavel, color: Colors.blue),
          const SizedBox(width: 8),
          Text('Lawyer: ${currentLawyer.name}'),
        ],
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatCard('Total Cases', '${_legalSystem.totalCases}'),
        _buildStatCard('Active Cases', '${_legalSystem.activeCases}'),
        _buildStatCard('Legal Heat', '${(_legalSystem.legalHeat * 100).toInt()}%'),
        _buildStatCard('Corruption', '${(_legalSystem.corruptionLevel * 100).toInt()}%'),
      ],
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Expanded(
      child: Card(
        color: Colors.amber[50],
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
      tabs: const [
        Tab(text: 'Cases', icon: Icon(Icons.folder)),
        Tab(text: 'Lawyers', icon: Icon(Icons.person)),
        Tab(text: 'Sentences', icon: Icon(Icons.gavel)),
        Tab(text: 'Corruption', icon: Icon(Icons.money_off)),
      ],
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildCasesTab(),
        _buildLawyersTab(),
        _buildSentencesTab(),
        _buildCorruptionTab(),
      ],
    );
  }

  Widget _buildCasesTab() {
    final cases = _legalSystem.getActiveCases();
    
    return ListView.builder(
      itemCount: cases.length,
      itemBuilder: (context, index) {
        final legalCase = cases[index];
        return _buildCaseCard(legalCase);
      },
    );
  }

  Widget _buildCaseCard(LegalCase legalCase) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ExpansionTile(
        leading: Icon(
          _getCrimeTypeIcon(legalCase.crimeType),
          color: _getSeverityColor(legalCase.severity),
        ),
        title: Text('${legalCase.crimeType.name} Case'),
        subtitle: Text('${legalCase.severity.name} - ${legalCase.status.name}'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Charges: ${legalCase.charges.join(', ')}'),
                const SizedBox(height: 8),
                Text('Evidence Strength: ${(legalCase.evidenceStrength * 100).toInt()}%'),
                Text('Conviction Probability: ${(legalCase.convictionProbability * 100).toInt()}%'),
                const SizedBox(height: 8),
                if (legalCase.trialDate != null)
                  Text('Trial Date: ${_formatDate(legalCase.trialDate!)}'),
                const SizedBox(height: 8),
                _buildCaseActions(legalCase),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaseActions(LegalCase legalCase) {
    return Wrap(
      spacing: 8,
      children: [
        if (legalCase.status == CaseStatus.charged)
          ElevatedButton(
            onPressed: () => _legalSystem.conductTrial(legalCase.id),
            child: const Text('Go to Trial'),
          ),
        if (_legalSystem.canAppealCase(legalCase.id))
          ElevatedButton(
            onPressed: () => _legalSystem.appealCase(legalCase.id),
            child: const Text('Appeal'),
          ),
        ElevatedButton(
          onPressed: () => _showBriberyDialog(legalCase),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Bribe'),
        ),
      ],
    );
  }

  Widget _buildLawyersTab() {
    final lawyers = _legalSystem.getAvailableLawyers();
    final currentLawyer = _legalSystem.getCurrentLawyer();
    
    return Column(
      children: [
        if (currentLawyer != null) ...[
          Card(
            color: Colors.blue[50],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Current Lawyer', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('${currentLawyer.name} (${currentLawyer.type.name})'),
                  Text('Win Rate: ${(currentLawyer.actualWinRate * 100).toInt()}%'),
                  Text('Rate: \$${currentLawyer.hourlyRate}/hour'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _legalSystem.fireLawyer(),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Fire Lawyer'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        Expanded(
          child: ListView.builder(
            itemCount: lawyers.length,
            itemBuilder: (context, index) {
              final lawyer = lawyers[index];
              return _buildLawyerCard(lawyer);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLawyerCard(Lawyer lawyer) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getLawyerTypeColor(lawyer.type),
          child: Text(lawyer.name[0]),
        ),
        title: Text(lawyer.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${lawyer.type.name} - \$${lawyer.hourlyRate}/hour'),
            Text('Win Rate: ${(lawyer.actualWinRate * 100).toInt()}% (${lawyer.casesWon}W/${lawyer.casesLost}L)'),
            Text('Competency: ${(lawyer.competencyScore * 100).toInt()}%'),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () => _legalSystem.hireLawyer(lawyer.id),
          child: const Text('Hire'),
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildSentencesTab() {
    final sentences = _legalSystem.getActiveSentences();
    
    return ListView.builder(
      itemCount: sentences.length,
      itemBuilder: (context, index) {
        final sentence = sentences[index];
        return _buildSentenceCard(sentence);
      },
    );
  }

  Widget _buildSentenceCard(Sentence sentence) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.gavel, color: Colors.red),
        title: Text('Case ${sentence.caseId.split('_').last}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (sentence.prisonYears > 0)
              Text('Prison: ${sentence.prisonYears} years'),
            if (sentence.fineAmount > 0)
              Text('Fine: \$${sentence.fineAmount.toInt()}'),
            if (sentence.communityServiceHours > 0)
              Text('Community Service: ${sentence.communityServiceHours} hours'),
            Text('Issued: ${_formatDate(sentence.dateIssued)}'),
            if (sentence.isAppealed)
              const Text('APPEALED', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildCorruptionTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Corruption Level', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: _legalSystem.corruptionLevel,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                  const SizedBox(height: 8),
                  Text('${(_legalSystem.corruptionLevel * 100).toInt()}% - ${_getCorruptionLevel(_legalSystem.corruptionLevel)}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Corruption Activities', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildCorruptionOption('Judge Bribery', 'Bribe judges for favorable outcomes', Icons.account_balance),
          _buildCorruptionOption('Evidence Tampering', 'Tamper with evidence in your favor', Icons.delete_forever),
          _buildCorruptionOption('Witness Intimidation', 'Intimidate witnesses to change testimony', Icons.visibility_off),
          _buildCorruptionOption('Prosecutor Bribery', 'Bribe prosecutors to reduce charges', Icons.person),
        ],
      ),
    );
  }

  Widget _buildCorruptionOption(String title, String description, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.red),
        title: Text(title),
        subtitle: Text(description),
        trailing: ElevatedButton(
          onPressed: () => _showCorruptionDialog(title),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Execute'),
        ),
      ),
    );
  }

  void _showBriberyDialog(LegalCase legalCase) {
    final amountController = TextEditingController();
    String target = 'judge';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Attempt Bribery'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('This is illegal and risky. Proceed with caution.'),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: target,
                decoration: const InputDecoration(labelText: 'Target'),
                items: const [
                  DropdownMenuItem(value: 'judge', child: Text('Judge')),
                  DropdownMenuItem(value: 'prosecutor', child: Text('Prosecutor')),
                ],
                onChanged: (value) => setState(() => target = value!),
              ),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(labelText: 'Bribe Amount (\$)'),
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
                final amount = double.tryParse(amountController.text) ?? 0;
                final success = _legalSystem.attemptBribery(legalCase.id, amount, target);
                
                Navigator.of(context).pop();
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 'Bribery successful!' : 'Bribery failed!'),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Bribe'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCorruptionDialog(String activity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(activity),
        content: const Text('This feature requires specific case context and higher corruption levels.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Color _getCrimeTypeColor(CrimeType type) {
    switch (type) {
      case CrimeType.drugPossession:
        return Colors.orange;
      case CrimeType.drugTrafficking:
        return Colors.red;
      case CrimeType.murder:
        return Colors.red[900]!;
      case CrimeType.moneyLaundering:
        return Colors.green;
      case CrimeType.corruption:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Color _getSeverityColor(CaseSeverity severity) {
    switch (severity) {
      case CaseSeverity.misdemeanor:
        return Colors.yellow;
      case CaseSeverity.felony:
        return Colors.orange;
      case CaseSeverity.majorFelony:
        return Colors.red;
      case CaseSeverity.federal:
        return Colors.purple;
      case CaseSeverity.rico:
        return Colors.red[900]!;
    }
  }

  Color _getLawyerTypeColor(LawyerType type) {
    switch (type) {
      case LawyerType.publicDefender:
        return Colors.blue;
      case LawyerType.privateCriminal:
        return Colors.green;
      case LawyerType.corporateLawyer:
        return Colors.purple;
      case LawyerType.federalSpecialist:
        return Colors.indigo;
      case LawyerType.corruptLawyer:
        return Colors.red;
    }
  }

  IconData _getCrimeTypeIcon(CrimeType type) {
    switch (type) {
      case CrimeType.drugPossession:
      case CrimeType.drugTrafficking:
      case CrimeType.drugManufacturing:
        return Icons.medication;
      case CrimeType.assault:
        return Icons.warning;
      case CrimeType.murder:
        return Icons.dangerous;
      case CrimeType.extortion:
        return Icons.money_off;
      case CrimeType.moneyLaundering:
        return Icons.account_balance;
      case CrimeType.racketeering:
        return Icons.group;
      case CrimeType.corruption:
        return Icons.gavel;
      case CrimeType.taxEvasion:
        return Icons.receipt;
      case CrimeType.armsDealing:
        return Icons.security;
      case CrimeType.humanTrafficking:
        return Icons.person_off;
    }
  }

  String _getCorruptionLevel(double level) {
    if (level < 0.2) return 'Clean';
    if (level < 0.4) return 'Minor Corruption';
    if (level < 0.6) return 'Moderate Corruption';
    if (level < 0.8) return 'High Corruption';
    return 'Total Corruption';
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
