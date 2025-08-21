import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

// Advanced Police & Law Enforcement System
// Feature #14: Ultra-comprehensive law enforcement with multiple agencies,
// investigation systems, witness mechanics, evidence collection, and corruption

enum CrimeType {
  drugTrafficking,
  assault,
  murder,
  racketeering,
  moneyLaundering,
  extortion,
  arson,
  kidnapping,
  cybercrime,
  terrorism
}

enum LawEnforcementAgency {
  localPolice,
  stateTroopers,
  fbi,
  dea,
  atf,
  irs,
  marshals,
  customs,
  secretService,
  nsa
}

enum InvestigationPhase {
  initial,
  gathering,
  analysis,
  pursuit,
  arrest,
  trial,
  closed
}

enum EvidenceType {
  physical,
  digital,
  witness,
  financial,
  surveillance,
  forensic,
  circumstantial,
  documentary
}

enum CorruptionLevel {
  none,
  minimal,
  moderate,
  high,
  extreme
}

enum InvestigationResult {
  dismissed,
  probation,
  fines,
  shortSentence,
  longSentence,
  lifeInPrison,
  deathPenalty
}

class Evidence {
  final String id;
  final EvidenceType type;
  final String description;
  final double strength;
  final DateTime discoveredAt;
  final String sourceId;
  final bool contaminated;
  final Map<String, dynamic> metadata;

  Evidence({
    required this.id,
    required this.type,
    required this.description,
    required this.strength,
    required this.discoveredAt,
    required this.sourceId,
    this.contaminated = false,
    this.metadata = const {},
  });
}

class Witness {
  final String id;
  final String name;
  final double credibility;
  final double cooperation;
  final bool inProtection;
  final List<String> testimony;
  final double fearLevel;
  final bool bribed;
  final bool threatened;
  final Map<String, dynamic> profile;

  Witness({
    required this.id,
    required this.name,
    required this.credibility,
    required this.cooperation,
    this.inProtection = false,
    this.testimony = const [],
    this.fearLevel = 0.0,
    this.bribed = false,
    this.threatened = false,
    this.profile = const {},
  });

  Witness copyWith({
    String? id,
    String? name,
    double? credibility,
    double? cooperation,
    bool? inProtection,
    List<String>? testimony,
    double? fearLevel,
    bool? bribed,
    bool? threatened,
    Map<String, dynamic>? profile,
  }) {
    return Witness(
      id: id ?? this.id,
      name: name ?? this.name,
      credibility: credibility ?? this.credibility,
      cooperation: cooperation ?? this.cooperation,
      inProtection: inProtection ?? this.inProtection,
      testimony: testimony ?? this.testimony,
      fearLevel: fearLevel ?? this.fearLevel,
      bribed: bribed ?? this.bribed,
      threatened: threatened ?? this.threatened,
      profile: profile ?? this.profile,
    );
  }
}

class Investigation {
  final String id;
  final CrimeType crimeType;
  final LawEnforcementAgency leadAgency;
  final List<LawEnforcementAgency> participatingAgencies;
  final InvestigationPhase phase;
  final double progress;
  final List<Evidence> evidence;
  final List<Witness> witnesses;
  final String targetId;
  final DateTime startDate;
  final DateTime? endDate;
  final double priority;
  final double budget;
  final Map<String, dynamic> notes;

  Investigation({
    required this.id,
    required this.crimeType,
    required this.leadAgency,
    this.participatingAgencies = const [],
    required this.phase,
    required this.progress,
    this.evidence = const [],
    this.witnesses = const [],
    required this.targetId,
    required this.startDate,
    this.endDate,
    required this.priority,
    required this.budget,
    this.notes = const {},
  });

  Investigation copyWith({
    String? id,
    CrimeType? crimeType,
    LawEnforcementAgency? leadAgency,
    List<LawEnforcementAgency>? participatingAgencies,
    InvestigationPhase? phase,
    double? progress,
    List<Evidence>? evidence,
    List<Witness>? witnesses,
    String? targetId,
    DateTime? startDate,
    DateTime? endDate,
    double? priority,
    double? budget,
    Map<String, dynamic>? notes,
  }) {
    return Investigation(
      id: id ?? this.id,
      crimeType: crimeType ?? this.crimeType,
      leadAgency: leadAgency ?? this.leadAgency,
      participatingAgencies: participatingAgencies ?? this.participatingAgencies,
      phase: phase ?? this.phase,
      progress: progress ?? this.progress,
      evidence: evidence ?? this.evidence,
      witnesses: witnesses ?? this.witnesses,
      targetId: targetId ?? this.targetId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      priority: priority ?? this.priority,
      budget: budget ?? this.budget,
      notes: notes ?? this.notes,
    );
  }
}

class PoliceOfficer {
  final String id;
  final String name;
  final String rank;
  final LawEnforcementAgency agency;
  final double skill;
  final double corruption;
  final double suspicion;
  final bool undercover;
  final List<String> specialties;
  final Map<String, dynamic> stats;

  PoliceOfficer({
    required this.id,
    required this.name,
    required this.rank,
    required this.agency,
    required this.skill,
    this.corruption = 0.0,
    this.suspicion = 0.0,
    this.undercover = false,
    this.specialties = const [],
    this.stats = const {},
  });

  PoliceOfficer copyWith({
    String? id,
    String? name,
    String? rank,
    LawEnforcementAgency? agency,
    double? skill,
    double? corruption,
    double? suspicion,
    bool? undercover,
    List<String>? specialties,
    Map<String, dynamic>? stats,
  }) {
    return PoliceOfficer(
      id: id ?? this.id,
      name: name ?? this.name,
      rank: rank ?? this.rank,
      agency: agency ?? this.agency,
      skill: skill ?? this.skill,
      corruption: corruption ?? this.corruption,
      suspicion: suspicion ?? this.suspicion,
      undercover: undercover ?? this.undercover,
      specialties: specialties ?? this.specialties,
      stats: stats ?? this.stats,
    );
  }
}

class RaidOperation {
  final String id;
  final String targetLocation;
  final DateTime scheduledTime;
  final List<String> involvedOfficers;
  final List<LawEnforcementAgency> agencies;
  final double successChance;
  final bool warrantRequired;
  final bool hasWarrant;
  final Map<String, dynamic> intelligence;

  RaidOperation({
    required this.id,
    required this.targetLocation,
    required this.scheduledTime,
    required this.involvedOfficers,
    required this.agencies,
    required this.successChance,
    this.warrantRequired = true,
    this.hasWarrant = false,
    this.intelligence = const {},
  });
}

class AdvancedPoliceSystem extends ChangeNotifier {
  static final AdvancedPoliceSystem _instance = AdvancedPoliceSystem._internal();
  factory AdvancedPoliceSystem() => _instance;
  AdvancedPoliceSystem._internal() {
    _initializeSystem();
  }

  final Map<String, Investigation> _investigations = {};
  final Map<String, PoliceOfficer> _officers = {};
  final Map<String, Witness> _witnesses = {};
  final Map<String, Evidence> _evidence = {};
  final Map<String, RaidOperation> _plannedRaids = {};
  
  double _overallCorruption = 0.1;
  double _publicTrust = 0.7;
  double _policePresence = 0.5;
  int _totalCriminalsCaught = 0;
  int _totalInvestigations = 0;
  
  Timer? _systemTimer;
  final math.Random _random = math.Random();

  // Getters
  Map<String, Investigation> get investigations => Map.unmodifiable(_investigations);
  Map<String, PoliceOfficer> get officers => Map.unmodifiable(_officers);
  Map<String, Witness> get witnesses => Map.unmodifiable(_witnesses);
  Map<String, Evidence> get evidence => Map.unmodifiable(_evidence);
  Map<String, RaidOperation> get plannedRaids => Map.unmodifiable(_plannedRaids);
  double get overallCorruption => _overallCorruption;
  double get publicTrust => _publicTrust;
  double get policePresence => _policePresence;
  int get totalCriminalsCaught => _totalCriminalsCaught;
  int get totalInvestigations => _totalInvestigations;

  void _initializeSystem() {
    _generateInitialOfficers();
    _startSystemTimer();
  }

  void _generateInitialOfficers() {
    final agencyOfficerCounts = {
      LawEnforcementAgency.localPolice: 50,
      LawEnforcementAgency.stateTroopers: 25,
      LawEnforcementAgency.fbi: 15,
      LawEnforcementAgency.dea: 12,
      LawEnforcementAgency.atf: 8,
      LawEnforcementAgency.irs: 10,
      LawEnforcementAgency.marshals: 6,
      LawEnforcementAgency.customs: 8,
      LawEnforcementAgency.secretService: 4,
      LawEnforcementAgency.nsa: 3,
    };

    for (final entry in agencyOfficerCounts.entries) {
      for (int i = 0; i < entry.value; i++) {
        final officer = _generateOfficer(entry.key);
        _officers[officer.id] = officer;
      }
    }
  }

  PoliceOfficer _generateOfficer(LawEnforcementAgency agency) {
    final ranks = _getRanksForAgency(agency);
    final specialties = _getSpecialtiesForAgency(agency);
    
    return PoliceOfficer(
      id: 'officer_${DateTime.now().millisecondsSinceEpoch}_${_random.nextInt(1000)}',
      name: _generateOfficerName(),
      rank: ranks[_random.nextInt(ranks.length)],
      agency: agency,
      skill: 0.3 + (_random.nextDouble() * 0.7),
      corruption: _random.nextDouble() * 0.3,
      suspicion: _random.nextDouble() * 0.2,
      undercover: _random.nextDouble() < 0.05,
      specialties: _selectRandomSpecialties(specialties),
      stats: {
        'casesWorked': _random.nextInt(50),
        'successRate': 0.4 + (_random.nextDouble() * 0.5),
        'yearsService': _random.nextInt(25),
      },
    );
  }

  List<String> _getRanksForAgency(LawEnforcementAgency agency) {
    switch (agency) {
      case LawEnforcementAgency.localPolice:
        return ['Officer', 'Detective', 'Sergeant', 'Lieutenant', 'Captain', 'Chief'];
      case LawEnforcementAgency.fbi:
        return ['Special Agent', 'Senior Agent', 'Supervisory Agent', 'Assistant Director', 'Deputy Director'];
      case LawEnforcementAgency.dea:
        return ['Agent', 'Senior Agent', 'Group Supervisor', 'Assistant Regional Director'];
      default:
        return ['Agent', 'Senior Agent', 'Supervisor', 'Director'];
    }
  }

  List<String> _getSpecialtiesForAgency(LawEnforcementAgency agency) {
    switch (agency) {
      case LawEnforcementAgency.localPolice:
        return ['Traffic', 'Narcotics', 'Homicide', 'Robbery', 'Vice', 'Gang Unit'];
      case LawEnforcementAgency.fbi:
        return ['Counterterrorism', 'Organized Crime', 'White Collar', 'Cybercrime', 'Public Corruption'];
      case LawEnforcementAgency.dea:
        return ['Drug Trafficking', 'Money Laundering', 'International Operations', 'Laboratory Analysis'];
      case LawEnforcementAgency.atf:
        return ['Firearms', 'Explosives', 'Arson Investigation', 'Gang Enforcement'];
      case LawEnforcementAgency.irs:
        return ['Tax Evasion', 'Financial Crimes', 'Criminal Investigation'];
      default:
        return ['General Investigation', 'Surveillance', 'Intelligence'];
    }
  }

  String _generateOfficerName() {
    final firstNames = ['John', 'Jane', 'Michael', 'Sarah', 'David', 'Lisa', 'Robert', 'Mary', 'James', 'Jennifer'];
    final lastNames = ['Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis', 'Rodriguez', 'Martinez'];
    
    return '${firstNames[_random.nextInt(firstNames.length)]} ${lastNames[_random.nextInt(lastNames.length)]}';
  }

  List<String> _selectRandomSpecialties(List<String> available) {
    final count = 1 + _random.nextInt(3);
    final selected = <String>[];
    final shuffled = List<String>.from(available)..shuffle(_random);
    
    for (int i = 0; i < count && i < shuffled.length; i++) {
      selected.add(shuffled[i]);
    }
    
    return selected;
  }

  void _startSystemTimer() {
    _systemTimer?.cancel();
    _systemTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _updateInvestigations();
      _updateCorruption();
      _updatePublicTrust();
      _generateRandomEvents();
      notifyListeners();
    });
  }

  // Investigation Management
  String startInvestigation({
    required String targetId,
    required CrimeType crimeType,
    LawEnforcementAgency? preferredAgency,
    double priority = 0.5,
  }) {
    final agency = preferredAgency ?? _selectAppropriateAgency(crimeType);
    final investigationId = 'inv_${DateTime.now().millisecondsSinceEpoch}';
    
    final investigation = Investigation(
      id: investigationId,
      crimeType: crimeType,
      leadAgency: agency,
      participatingAgencies: _getParticipatingAgencies(crimeType, agency),
      phase: InvestigationPhase.initial,
      progress: 0.0,
      targetId: targetId,
      startDate: DateTime.now(),
      priority: priority,
      budget: _calculateInvestigationBudget(crimeType, agency),
    );
    
    _investigations[investigationId] = investigation;
    _totalInvestigations++;
    
    notifyListeners();
    return investigationId;
  }

  LawEnforcementAgency _selectAppropriateAgency(CrimeType crimeType) {
    switch (crimeType) {
      case CrimeType.drugTrafficking:
        return _random.nextDouble() < 0.7 ? LawEnforcementAgency.dea : LawEnforcementAgency.localPolice;
      case CrimeType.moneyLaundering:
        return _random.nextDouble() < 0.6 ? LawEnforcementAgency.irs : LawEnforcementAgency.fbi;
      case CrimeType.terrorism:
        return LawEnforcementAgency.fbi;
      case CrimeType.cybercrime:
        return _random.nextDouble() < 0.8 ? LawEnforcementAgency.fbi : LawEnforcementAgency.secretService;
      case CrimeType.racketeering:
        return LawEnforcementAgency.fbi;
      default:
        return LawEnforcementAgency.localPolice;
    }
  }

  List<LawEnforcementAgency> _getParticipatingAgencies(CrimeType crimeType, LawEnforcementAgency leadAgency) {
    final agencies = <LawEnforcementAgency>[];
    
    // Always include local police for support
    if (leadAgency != LawEnforcementAgency.localPolice) {
      agencies.add(LawEnforcementAgency.localPolice);
    }
    
    // Add relevant agencies based on crime type
    switch (crimeType) {
      case CrimeType.drugTrafficking:
        if (leadAgency != LawEnforcementAgency.dea) agencies.add(LawEnforcementAgency.dea);
        if (_random.nextDouble() < 0.3) agencies.add(LawEnforcementAgency.customs);
        break;
      case CrimeType.moneyLaundering:
        if (leadAgency != LawEnforcementAgency.irs) agencies.add(LawEnforcementAgency.irs);
        if (leadAgency != LawEnforcementAgency.fbi) agencies.add(LawEnforcementAgency.fbi);
        break;
      case CrimeType.arson:
        agencies.add(LawEnforcementAgency.atf);
        break;
      default:
        break;
    }
    
    return agencies;
  }

  double _calculateInvestigationBudget(CrimeType crimeType, LawEnforcementAgency agency) {
    double baseBudget = 50000.0;
    
    // Adjust based on crime type
    switch (crimeType) {
      case CrimeType.terrorism:
        baseBudget *= 5.0;
        break;
      case CrimeType.racketeering:
        baseBudget *= 3.0;
        break;
      case CrimeType.moneyLaundering:
        baseBudget *= 2.5;
        break;
      case CrimeType.drugTrafficking:
        baseBudget *= 2.0;
        break;
      default:
        break;
    }
    
    // Adjust based on agency
    switch (agency) {
      case LawEnforcementAgency.fbi:
      case LawEnforcementAgency.nsa:
        baseBudget *= 1.5;
        break;
      case LawEnforcementAgency.localPolice:
        baseBudget *= 0.6;
        break;
      default:
        break;
    }
    
    return baseBudget * (0.5 + _random.nextDouble());
  }

  void _updateInvestigations() {
    for (final investigation in _investigations.values.toList()) {
      if (investigation.phase == InvestigationPhase.closed) continue;
      
      _progressInvestigation(investigation.id);
    }
  }

  void _progressInvestigation(String investigationId) {
    final investigation = _investigations[investigationId];
    if (investigation == null) return;
    
    final progressRate = _calculateProgressRate(investigation);
    final newProgress = (investigation.progress + progressRate).clamp(0.0, 1.0);
    
    // Check for phase transitions
    InvestigationPhase newPhase = investigation.phase;
    if (newProgress >= 0.2 && investigation.phase == InvestigationPhase.initial) {
      newPhase = InvestigationPhase.gathering;
      _generateEvidence(investigationId);
    } else if (newProgress >= 0.5 && investigation.phase == InvestigationPhase.gathering) {
      newPhase = InvestigationPhase.analysis;
      _generateWitnesses(investigationId);
    } else if (newProgress >= 0.8 && investigation.phase == InvestigationPhase.analysis) {
      newPhase = InvestigationPhase.pursuit;
      _planRaid(investigationId);
    } else if (newProgress >= 1.0 && investigation.phase == InvestigationPhase.pursuit) {
      newPhase = InvestigationPhase.arrest;
      _executeArrest(investigationId);
    }
    
    _investigations[investigationId] = investigation.copyWith(
      progress: newProgress,
      phase: newPhase,
    );
  }

  double _calculateProgressRate(Investigation investigation) {
    double baseRate = 0.01;
    
    // Agency efficiency
    switch (investigation.leadAgency) {
      case LawEnforcementAgency.fbi:
        baseRate *= 1.5;
        break;
      case LawEnforcementAgency.localPolice:
        baseRate *= 0.8;
        break;
      default:
        break;
    }
    
    // Priority factor
    baseRate *= (0.5 + investigation.priority);
    
    // Corruption hindrance
    baseRate *= (1.0 - (_overallCorruption * 0.5));
    
    // Evidence quality boost
    if (investigation.evidence.isNotEmpty) {
      final avgEvidenceStrength = investigation.evidence
          .map((e) => e.strength)
          .reduce((a, b) => a + b) / investigation.evidence.length;
      baseRate *= (1.0 + avgEvidenceStrength);
    }
    
    // Random factor
    baseRate *= (0.5 + _random.nextDouble());
    
    return baseRate;
  }

  void _generateEvidence(String investigationId) {
    final investigation = _investigations[investigationId];
    if (investigation == null) return;
    
    final evidenceTypes = [
      EvidenceType.physical,
      EvidenceType.digital,
      EvidenceType.surveillance,
      EvidenceType.financial,
      EvidenceType.forensic,
    ];
    
    final evidenceType = evidenceTypes[_random.nextInt(evidenceTypes.length)];
    final evidenceId = 'evidence_${DateTime.now().millisecondsSinceEpoch}';
    
    final evidence = Evidence(
      id: evidenceId,
      type: evidenceType,
      description: _generateEvidenceDescription(evidenceType, investigation.crimeType),
      strength: 0.3 + (_random.nextDouble() * 0.7),
      discoveredAt: DateTime.now(),
      sourceId: investigation.targetId,
      contaminated: _random.nextDouble() < 0.1,
      metadata: {
        'investigationId': investigationId,
        'discoveryMethod': _getDiscoveryMethod(evidenceType),
      },
    );
    
    _evidence[evidenceId] = evidence;
    
    final updatedEvidence = List<Evidence>.from(investigation.evidence)..add(evidence);
    _investigations[investigationId] = investigation.copyWith(evidence: updatedEvidence);
  }

  String _generateEvidenceDescription(EvidenceType type, CrimeType crimeType) {
    switch (type) {
      case EvidenceType.physical:
        return 'Physical evidence collected from crime scene';
      case EvidenceType.digital:
        return 'Digital communications and transaction records';
      case EvidenceType.surveillance:
        return 'Video surveillance footage';
      case EvidenceType.financial:
        return 'Bank records and financial transactions';
      case EvidenceType.forensic:
        return 'Forensic analysis results';
      default:
        return 'Evidence related to ${crimeType.name}';
    }
  }

  String _getDiscoveryMethod(EvidenceType type) {
    switch (type) {
      case EvidenceType.physical:
        return 'Crime scene investigation';
      case EvidenceType.digital:
        return 'Digital forensics';
      case EvidenceType.surveillance:
        return 'Security camera analysis';
      case EvidenceType.financial:
        return 'Financial audit';
      case EvidenceType.forensic:
        return 'Laboratory analysis';
      default:
        return 'Standard investigation';
    }
  }

  void _generateWitnesses(String investigationId) {
    final investigation = _investigations[investigationId];
    if (investigation == null) return;
    
    final witnessCount = 1 + _random.nextInt(3);
    final newWitnesses = <Witness>[];
    
    for (int i = 0; i < witnessCount; i++) {
      final witnessId = 'witness_${DateTime.now().millisecondsSinceEpoch}_$i';
      
      final witness = Witness(
        id: witnessId,
        name: _generateWitnessName(),
        credibility: 0.2 + (_random.nextDouble() * 0.8),
        cooperation: 0.1 + (_random.nextDouble() * 0.9),
        inProtection: _random.nextDouble() < 0.2,
        testimony: _generateTestimony(investigation.crimeType),
        fearLevel: _random.nextDouble(),
        bribed: _random.nextDouble() < (_overallCorruption * 0.3),
        threatened: _random.nextDouble() < 0.15,
        profile: {
          'age': 18 + _random.nextInt(62),
          'occupation': _generateOccupation(),
          'relationship': _generateRelationship(),
        },
      );
      
      _witnesses[witnessId] = witness;
      newWitnesses.add(witness);
    }
    
    final updatedWitnesses = List<Witness>.from(investigation.witnesses)..addAll(newWitnesses);
    _investigations[investigationId] = investigation.copyWith(witnesses: updatedWitnesses);
  }

  String _generateWitnessName() {
    final names = ['Alex Johnson', 'Maria Rodriguez', 'James Wilson', 'Sarah Davis', 'Michael Brown'];
    return names[_random.nextInt(names.length)];
  }

  List<String> _generateTestimony(CrimeType crimeType) {
    final testimonies = <String>[];
    
    switch (crimeType) {
      case CrimeType.drugTrafficking:
        testimonies.addAll([
          'Witnessed drug exchange',
          'Saw suspicious packages being moved',
          'Observed repeated meetings at location',
        ]);
        break;
      case CrimeType.murder:
        testimonies.addAll([
          'Heard gunshots at time of incident',
          'Saw suspect leaving scene',
          'Witnessed argument before incident',
        ]);
        break;
      default:
        testimonies.add('Witnessed suspicious activity');
        break;
    }
    
    return [testimonies[_random.nextInt(testimonies.length)]];
  }

  String _generateOccupation() {
    final occupations = ['Store clerk', 'Taxi driver', 'Student', 'Office worker', 'Unemployed', 'Retiree'];
    return occupations[_random.nextInt(occupations.length)];
  }

  String _generateRelationship() {
    final relationships = ['Bystander', 'Neighbor', 'Employee', 'Customer', 'Acquaintance'];
    return relationships[_random.nextInt(relationships.length)];
  }

  void _planRaid(String investigationId) {
    final investigation = _investigations[investigationId];
    if (investigation == null) return;
    
    final raidId = 'raid_${DateTime.now().millisecondsSinceEpoch}';
    final scheduledTime = DateTime.now().add(Duration(hours: 1 + _random.nextInt(24)));
    
    final raid = RaidOperation(
      id: raidId,
      targetLocation: 'Location_${investigation.targetId}',
      scheduledTime: scheduledTime,
      involvedOfficers: _selectRaidOfficers(investigation.leadAgency),
      agencies: [investigation.leadAgency, ...investigation.participatingAgencies],
      successChance: _calculateRaidSuccessChance(investigation),
      warrantRequired: _requiresWarrant(investigation.crimeType),
      hasWarrant: true, // Assume warrant obtained
      intelligence: {
        'investigationId': investigationId,
        'evidenceCount': investigation.evidence.length,
        'witnessCount': investigation.witnesses.length,
      },
    );
    
    _plannedRaids[raidId] = raid;
  }

  List<String> _selectRaidOfficers(LawEnforcementAgency agency) {
    final availableOfficers = _officers.values
        .where((o) => o.agency == agency || o.agency == LawEnforcementAgency.localPolice)
        .toList();
    
    final selectedCount = 3 + _random.nextInt(8);
    final selected = <String>[];
    
    for (int i = 0; i < selectedCount && i < availableOfficers.length; i++) {
      selected.add(availableOfficers[i].id);
    }
    
    return selected;
  }

  double _calculateRaidSuccessChance(Investigation investigation) {
    double baseChance = 0.6;
    
    // Evidence quality
    if (investigation.evidence.isNotEmpty) {
      final avgEvidenceStrength = investigation.evidence
          .map((e) => e.strength)
          .reduce((a, b) => a + b) / investigation.evidence.length;
      baseChance += avgEvidenceStrength * 0.2;
    }
    
    // Witness cooperation
    if (investigation.witnesses.isNotEmpty) {
      final avgCooperation = investigation.witnesses
          .map((w) => w.cooperation)
          .reduce((a, b) => a + b) / investigation.witnesses.length;
      baseChance += avgCooperation * 0.15;
    }
    
    // Corruption factor
    baseChance -= _overallCorruption * 0.3;
    
    return baseChance.clamp(0.1, 0.95);
  }

  bool _requiresWarrant(CrimeType crimeType) {
    // Some crimes may allow warrantless arrests under certain circumstances
    return ![CrimeType.terrorism].contains(crimeType) || _random.nextDouble() < 0.9;
  }

  void _executeArrest(String investigationId) {
    final investigation = _investigations[investigationId];
    if (investigation == null) return;
    
    final raid = _plannedRaids.values
        .where((r) => r.intelligence['investigationId'] == investigationId)
        .firstOrNull;
    
    final successChance = raid?.successChance ?? 0.5;
    final success = _random.nextDouble() < successChance;
    
    if (success) {
      _totalCriminalsCaught++;
      _investigations[investigationId] = investigation.copyWith(
        phase: InvestigationPhase.trial,
        progress: 1.0,
        endDate: DateTime.now(),
      );
    } else {
      // Investigation failed - target escaped
      _investigations[investigationId] = investigation.copyWith(
        phase: InvestigationPhase.closed,
        progress: 0.8,
        endDate: DateTime.now(),
      );
    }
  }

  void _updateCorruption() {
    // Corruption naturally fluctuates
    final change = (_random.nextDouble() - 0.5) * 0.001;
    _overallCorruption = (_overallCorruption + change).clamp(0.0, 1.0);
    
    // Update individual officer corruption
    for (final officerId in _officers.keys.toList()) {
      final officer = _officers[officerId]!;
      final corruptionChange = (_random.nextDouble() - 0.5) * 0.002;
      
      _officers[officerId] = officer.copyWith(
        corruption: (officer.corruption + corruptionChange).clamp(0.0, 1.0),
      );
    }
  }

  void _updatePublicTrust() {
    // Public trust affected by police performance
    double change = 0.0;
    
    // Successful investigations increase trust
    final recentSuccesses = _investigations.values
        .where((inv) => inv.phase == InvestigationPhase.trial && 
               inv.endDate != null &&
               DateTime.now().difference(inv.endDate!).inDays < 30)
        .length;
    
    change += recentSuccesses * 0.001;
    
    // Corruption decreases trust
    change -= _overallCorruption * 0.002;
    
    // Random events
    change += (_random.nextDouble() - 0.5) * 0.001;
    
    _publicTrust = (_publicTrust + change).clamp(0.0, 1.0);
  }

  void _generateRandomEvents() {
    if (_random.nextDouble() < 0.01) {
      _generateCorruptionEvent();
    }
    
    if (_random.nextDouble() < 0.005) {
      _generateWitnessEvent();
    }
    
    if (_random.nextDouble() < 0.008) {
      _generateEvidenceEvent();
    }
  }

  void _generateCorruptionEvent() {
    final officer = _officers.values.elementAt(_random.nextInt(_officers.length));
    
    if (_random.nextDouble() < 0.5) {
      // Officer exposed for corruption
      _officers[officer.id] = officer.copyWith(
        corruption: (officer.corruption + 0.2).clamp(0.0, 1.0),
        suspicion: (officer.suspicion + 0.3).clamp(0.0, 1.0),
      );
      _publicTrust = (_publicTrust - 0.02).clamp(0.0, 1.0);
    } else {
      // Officer commended for integrity
      _officers[officer.id] = officer.copyWith(
        corruption: (officer.corruption - 0.1).clamp(0.0, 1.0),
      );
      _publicTrust = (_publicTrust + 0.01).clamp(0.0, 1.0);
    }
  }

  void _generateWitnessEvent() {
    if (_witnesses.isEmpty) return;
    
    final witness = _witnesses.values.elementAt(_random.nextInt(_witnesses.length));
    
    if (_random.nextDouble() < 0.3) {
      // Witness intimidated
      _witnesses[witness.id] = witness.copyWith(
        fearLevel: (witness.fearLevel + 0.3).clamp(0.0, 1.0),
        cooperation: (witness.cooperation - 0.2).clamp(0.0, 1.0),
        threatened: true,
      );
    } else if (_random.nextDouble() < 0.2) {
      // Witness bribed
      _witnesses[witness.id] = witness.copyWith(
        cooperation: (witness.cooperation - 0.4).clamp(0.0, 1.0),
        bribed: true,
      );
    }
  }

  void _generateEvidenceEvent() {
    if (_evidence.isEmpty) return;
    
    final evidence = _evidence.values.elementAt(_random.nextInt(_evidence.length));
    
    if (_random.nextDouble() < 0.1) {
      // Evidence contaminated
      _evidence[evidence.id] = Evidence(
        id: evidence.id,
        type: evidence.type,
        description: evidence.description,
        strength: evidence.strength * 0.5,
        discoveredAt: evidence.discoveredAt,
        sourceId: evidence.sourceId,
        contaminated: true,
        metadata: evidence.metadata,
      );
    }
  }

  // Public interface methods
  bool bribeOfficer(String officerId, double amount) {
    final officer = _officers[officerId];
    if (officer == null) return false;
    
    final successChance = 0.3 + (officer.corruption * 0.5) - (officer.skill * 0.2);
    
    if (_random.nextDouble() < successChance) {
      _officers[officerId] = officer.copyWith(
        corruption: (officer.corruption + 0.1).clamp(0.0, 1.0),
      );
      return true;
    } else {
      // Bribe rejected, officer becomes suspicious
      _officers[officerId] = officer.copyWith(
        suspicion: (officer.suspicion + 0.2).clamp(0.0, 1.0),
      );
      return false;
    }
  }

  bool intimidateWitness(String witnessId) {
    final witness = _witnesses[witnessId];
    if (witness == null) return false;
    
    final successChance = 0.4 - (witness.credibility * 0.3);
    
    if (_random.nextDouble() < successChance) {
      _witnesses[witnessId] = witness.copyWith(
        fearLevel: (witness.fearLevel + 0.4).clamp(0.0, 1.0),
        cooperation: (witness.cooperation - 0.3).clamp(0.0, 1.0),
        threatened: true,
      );
      return true;
    }
    
    return false;
  }

  void destroyEvidence(String evidenceId) {
    _evidence.remove(evidenceId);
    
    // Remove from investigations
    for (final investigationId in _investigations.keys.toList()) {
      final investigation = _investigations[investigationId]!;
      final updatedEvidence = investigation.evidence
          .where((e) => e.id != evidenceId)
          .toList();
      
      if (updatedEvidence.length != investigation.evidence.length) {
        _investigations[investigationId] = investigation.copyWith(
          evidence: updatedEvidence,
        );
      }
    }
    
    notifyListeners();
  }

  List<Investigation> getInvestigationsTargeting(String targetId) {
    return _investigations.values
        .where((inv) => inv.targetId == targetId)
        .toList();
  }

  double getInvestigationThreat(String targetId) {
    final investigations = getInvestigationsTargeting(targetId);
    if (investigations.isEmpty) return 0.0;
    
    return investigations
        .map((inv) => inv.progress * inv.priority)
        .reduce((a, b) => a > b ? a : b);
  }

  void dispose() {
    _systemTimer?.cancel();
    super.dispose();
  }
}

// Advanced Police Status Widget
class AdvancedPoliceStatusWidget extends StatefulWidget {
  const AdvancedPoliceStatusWidget({super.key});

  @override
  State<AdvancedPoliceStatusWidget> createState() => _AdvancedPoliceStatusWidgetState();
}

class _AdvancedPoliceStatusWidgetState extends State<AdvancedPoliceStatusWidget> {
  final AdvancedPoliceSystem _policeSystem = AdvancedPoliceSystem();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _policeSystem,
      builder: (context, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Advanced Police System',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildStatusGrid(),
                const SizedBox(height: 16),
                _buildInvestigationsList(),
                const SizedBox(height: 16),
                _buildCorruptionIndicator(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 3,
      children: [
        _buildStatusCard('Active Investigations', '${_policeSystem.investigations.length}', Icons.search),
        _buildStatusCard('Total Officers', '${_policeSystem.officers.length}', Icons.security),
        _buildStatusCard('Public Trust', '${(_policeSystem.publicTrust * 100).toInt()}%', Icons.favorite),
        _buildStatusCard('Criminals Caught', '${_policeSystem.totalCriminalsCaught}', Icons.lock),
      ],
    );
  }

  Widget _buildStatusCard(String title, String value, IconData icon) {
    return Card(
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(fontSize: 10)),
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildInvestigationsList() {
    final activeInvestigations = _policeSystem.investigations.values
        .where((inv) => inv.phase != InvestigationPhase.closed)
        .take(3)
        .toList();

    if (activeInvestigations.isEmpty) {
      return const Text('No active investigations');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Active Investigations:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...activeInvestigations.map((inv) => _buildInvestigationTile(inv)),
      ],
    );
  }

  Widget _buildInvestigationTile(Investigation investigation) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        dense: true,
        leading: Icon(_getInvestigationIcon(investigation.crimeType)),
        title: Text(_getCrimeTypeName(investigation.crimeType)),
        subtitle: Text('${_getAgencyName(investigation.leadAgency)} - ${_getPhaseName(investigation.phase)}'),
        trailing: SizedBox(
          width: 50,
          child: LinearProgressIndicator(
            value: investigation.progress,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              _getProgressColor(investigation.progress),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCorruptionIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Corruption Level:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: _policeSystem.overallCorruption,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            _policeSystem.overallCorruption < 0.3 ? Colors.green :
            _policeSystem.overallCorruption < 0.6 ? Colors.orange : Colors.red,
          ),
        ),
        const SizedBox(height: 4),
        Text('${(_policeSystem.overallCorruption * 100).toInt()}%'),
      ],
    );
  }

  IconData _getInvestigationIcon(CrimeType crimeType) {
    switch (crimeType) {
      case CrimeType.drugTrafficking:
        return Icons.medication;
      case CrimeType.murder:
        return Icons.dangerous;
      case CrimeType.terrorism:
        return Icons.warning;
      case CrimeType.moneyLaundering:
        return Icons.account_balance;
      case CrimeType.cybercrime:
        return Icons.computer;
      default:
        return Icons.gavel;
    }
  }

  String _getCrimeTypeName(CrimeType crimeType) {
    return crimeType.name.split('').map((c) => 
      c == c.toUpperCase() && crimeType.name.indexOf(c) > 0 ? ' $c' : c
    ).join('').split(' ').map((word) => 
      word[0].toUpperCase() + word.substring(1)
    ).join(' ');
  }

  String _getAgencyName(LawEnforcementAgency agency) {
    switch (agency) {
      case LawEnforcementAgency.localPolice:
        return 'Police';
      case LawEnforcementAgency.fbi:
        return 'FBI';
      case LawEnforcementAgency.dea:
        return 'DEA';
      case LawEnforcementAgency.atf:
        return 'ATF';
      case LawEnforcementAgency.irs:
        return 'IRS';
      default:
        return agency.name.toUpperCase();
    }
  }

  String _getPhaseName(InvestigationPhase phase) {
    switch (phase) {
      case InvestigationPhase.initial:
        return 'Starting';
      case InvestigationPhase.gathering:
        return 'Gathering';
      case InvestigationPhase.analysis:
        return 'Analysis';
      case InvestigationPhase.pursuit:
        return 'Pursuit';
      case InvestigationPhase.arrest:
        return 'Arrest';
      case InvestigationPhase.trial:
        return 'Trial';
      case InvestigationPhase.closed:
        return 'Closed';
    }
  }

  Color _getProgressColor(double progress) {
    if (progress < 0.3) return Colors.green;
    if (progress < 0.7) return Colors.orange;
    return Colors.red;
  }
}
