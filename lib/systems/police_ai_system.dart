import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';

enum PoliceUnit {
  patrol,
  detective,
  swat,
  undercover,
  narcotics,
  helicopter,
  k9,
  cyber,
}

enum AlertLevel {
  none,
  low,
  medium,
  high,
  critical,
  manhunt,
}

enum InvestigationStatus {
  cold,
  active,
  hot,
  raid,
  closed,
}

class PoliceOfficer {
  final String id;
  final String name;
  final PoliceUnit unit;
  final double suspicion;
  final double corruption;
  final double skill;
  final double aggression;
  final Offset position;
  final String currentAssignment;
  final List<String> knownDealers;
  final double payoff;

  const PoliceOfficer({
    required this.id,
    required this.name,
    required this.unit,
    required this.suspicion,
    required this.corruption,
    required this.skill,
    required this.aggression,
    required this.position,
    required this.currentAssignment,
    required this.knownDealers,
    required this.payoff,
  });
}

class Investigation {
  final String id;
  final String target;
  final InvestigationStatus status;
  final double progress;
  final List<String> evidence;
  final DateTime startDate;
  final String leadOfficer;
  final double priority;
  final Map<String, dynamic> intelligence;

  const Investigation({
    required this.id,
    required this.target,
    required this.status,
    required this.progress,
    required this.evidence,
    required this.startDate,
    required this.leadOfficer,
    required this.priority,
    required this.intelligence,
  });
}

class PoliceAISystem {
  static final PoliceAISystem _instance = PoliceAISystem._internal();
  factory PoliceAISystem() => _instance;
  PoliceAISystem._internal();

  AlertLevel _currentAlertLevel = AlertLevel.none;
  final Map<String, PoliceOfficer> _officers = {};
  final Map<String, Investigation> _investigations = {};
  final List<Offset> _patrolRoutes = [];
  Timer? _aiUpdateTimer;
  double _playerHeat = 0.0;
  final Map<String, DateTime> _lastSightings = {};
  
  // Intelligence gathering
  final Map<String, List<String>> _suspiciousActivities = {};
  final Map<String, double> _locationSuspicion = {};
  
  void initialize() {
    _setupInitialOfficers();
    _createPatrolRoutes();
    _startInvestigations();
    _startAIUpdates();
  }

  void dispose() {
    _aiUpdateTimer?.cancel();
  }

  void _setupInitialOfficers() {
    final officers = [
      PoliceOfficer(
        id: 'martinez_001',
        name: 'Detective Sarah Martinez',
        unit: PoliceUnit.detective,
        suspicion: 0.8,
        corruption: 0.1,
        skill: 0.9,
        aggression: 0.6,
        position: const Offset(200, 200),
        currentAssignment: 'narcotics_investigation',
        knownDealers: ['street_corner_dealer', 'nightclub_supplier'],
        payoff: 0.0,
      ),
      
      PoliceOfficer(
        id: 'johnson_002',
        name: 'Officer Mike Johnson',
        unit: PoliceUnit.patrol,
        suspicion: 0.5,
        corruption: 0.3,
        skill: 0.6,
        aggression: 0.7,
        position: const Offset(150, 150),
        currentAssignment: 'downtown_patrol',
        knownDealers: [],
        payoff: 500.0,
      ),
      
      PoliceOfficer(
        id: 'rodriguez_003',
        name: 'Captain Elena Rodriguez',
        unit: PoliceUnit.narcotics,
        suspicion: 0.95,
        corruption: 0.05,
        skill: 0.95,
        aggression: 0.8,
        position: const Offset(175, 175),
        currentAssignment: 'major_bust_planning',
        knownDealers: ['high_level_supplier', 'money_launderer'],
        payoff: 0.0,
      ),
      
      PoliceOfficer(
        id: 'thompson_004',
        name: 'Officer Brad Thompson',
        unit: PoliceUnit.undercover,
        suspicion: 0.7,
        corruption: 0.4,
        skill: 0.8,
        aggression: 0.4,
        position: const Offset(250, 250),
        currentAssignment: 'gang_infiltration',
        knownDealers: ['gang_lieutenant'],
        payoff: 1000.0,
      ),
      
      PoliceOfficer(
        id: 'swat_leader_005',
        name: 'Sergeant Jake Wilson',
        unit: PoliceUnit.swat,
        suspicion: 0.6,
        corruption: 0.0,
        skill: 0.85,
        aggression: 0.95,
        position: const Offset(300, 200),
        currentAssignment: 'standby',
        knownDealers: [],
        payoff: 0.0,
      ),
    ];

    for (final officer in officers) {
      _officers[officer.id] = officer;
    }
  }

  void _createPatrolRoutes() {
    _patrolRoutes.addAll([
      const Offset(100, 100), // Police Station
      const Offset(200, 150), // Downtown
      const Offset(300, 200), // Business District
      const Offset(250, 300), // Residential
      const Offset(150, 250), // Entertainment
      const Offset(100, 200), // Industrial
    ]);
  }

  void _startInvestigations() {
    final investigations = [
      Investigation(
        id: 'operation_clean_sweep',
        target: 'major_drug_network',
        status: InvestigationStatus.active,
        progress: 0.4,
        evidence: ['wiretaps', 'financial_records', 'informant_tips'],
        startDate: DateTime.now().subtract(const Duration(days: 30)),
        leadOfficer: 'martinez_001',
        priority: 0.9,
        intelligence: {
          'known_locations': ['warehouse_district', 'nightclub_row'],
          'suspects': ['unknown_supplier', 'money_man'],
          'estimated_value': 500000,
        },
      ),
      
      Investigation(
        id: 'gang_violence_task_force',
        target: 'territorial_disputes',
        status: InvestigationStatus.hot,
        progress: 0.7,
        evidence: ['witness_statements', 'ballistics', 'surveillance'],
        startDate: DateTime.now().subtract(const Duration(days: 45)),
        leadOfficer: 'rodriguez_003',
        priority: 0.8,
        intelligence: {
          'gang_involvement': ['crimson_serpents', 'iron_brotherhood'],
          'weapons_cache': 'suspected',
          'next_conflict': 'imminent',
        },
      ),
    ];

    for (final investigation in investigations) {
      _investigations[investigation.id] = investigation;
    }
  }

  void _startAIUpdates() {
    _aiUpdateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _updatePoliceAI();
    });
  }

  void _updatePoliceAI() {
    _updatePatrols();
    _updateInvestigations();
    _analyzePlayerActivity();
    _adjustAlertLevels();
    _deployUnits();
  }

  void _updatePatrols() {
    for (final officerId in _officers.keys) {
      final officer = _officers[officerId]!;
      
      if (officer.unit == PoliceUnit.patrol) {
        // Move patrol officers along routes
        _movePatrolOfficer(officerId);
      }
    }
  }

  void _movePatrolOfficer(String officerId) {
    final officer = _officers[officerId]!;
    final random = math.Random();
    
    // Choose next patrol point
    final nextPoint = _patrolRoutes[random.nextInt(_patrolRoutes.length)];
    
    _officers[officerId] = PoliceOfficer(
      id: officer.id,
      name: officer.name,
      unit: officer.unit,
      suspicion: officer.suspicion,
      corruption: officer.corruption,
      skill: officer.skill,
      aggression: officer.aggression,
      position: _moveTowards(officer.position, nextPoint, 10.0),
      currentAssignment: officer.currentAssignment,
      knownDealers: officer.knownDealers,
      payoff: officer.payoff,
    );
  }

  Offset _moveTowards(Offset from, Offset to, double speed) {
    final direction = to - from;
    final distance = direction.distance;
    
    if (distance <= speed) {
      return to;
    }
    
    final normalizedDirection = direction / distance;
    return from + (normalizedDirection * speed);
  }

  void _updateInvestigations() {
    for (final investigationId in _investigations.keys) {
      final investigation = _investigations[investigationId]!;
      
      if (investigation.status == InvestigationStatus.active) {
        _progressInvestigation(investigationId);
      }
    }
  }

  void _progressInvestigation(String investigationId) {
    final investigation = _investigations[investigationId]!;
    final leadOfficer = _officers[investigation.leadOfficer];
    
    if (leadOfficer == null) return;
    
    // Progress based on officer skill and evidence
    final progressRate = leadOfficer.skill * 0.01; // 1% per update for skilled officers
    final newProgress = (investigation.progress + progressRate).clamp(0.0, 1.0);
    
    InvestigationStatus newStatus = investigation.status;
    if (newProgress > 0.8) {
      newStatus = InvestigationStatus.raid;
    } else if (newProgress > 0.6) {
      newStatus = InvestigationStatus.hot;
    }
    
    _investigations[investigationId] = Investigation(
      id: investigation.id,
      target: investigation.target,
      status: newStatus,
      progress: newProgress,
      evidence: investigation.evidence,
      startDate: investigation.startDate,
      leadOfficer: investigation.leadOfficer,
      priority: investigation.priority,
      intelligence: investigation.intelligence,
    );
    
    if (newStatus == InvestigationStatus.raid) {
      _triggerRaid(investigationId);
    }
  }

  void _triggerRaid(String investigationId) {
    final investigation = _investigations[investigationId]!;
    debugPrint('POLICE RAID: ${investigation.target} - Investigation: ${investigation.id}');
    
    // Increase alert level dramatically
    _currentAlertLevel = AlertLevel.critical;
    
    // Deploy SWAT units
    _deploySwatTeam(investigation.intelligence['known_locations'] ?? []);
  }

  void _deploySwatTeam(List<String> locations) {
    final swatOfficers = _officers.values
        .where((officer) => officer.unit == PoliceUnit.swat)
        .toList();
    
    for (final officer in swatOfficers) {
      _officers[officer.id] = PoliceOfficer(
        id: officer.id,
        name: officer.name,
        unit: officer.unit,
        suspicion: officer.suspicion,
        corruption: officer.corruption,
        skill: officer.skill,
        aggression: officer.aggression,
        position: officer.position,
        currentAssignment: 'active_raid',
        knownDealers: officer.knownDealers,
        payoff: officer.payoff,
      );
    }
  }

  void _analyzePlayerActivity() {
    // Analyze patterns in player behavior
    final now = DateTime.now();
    
    // Reduce heat over time
    _playerHeat = (_playerHeat * 0.95).clamp(0.0, 100.0);
    
    // Check for recent suspicious activity
    final recentSightings = _lastSightings.entries
        .where((entry) => now.difference(entry.value).inMinutes < 30)
        .length;
    
    if (recentSightings > 3) {
      _playerHeat += 10.0;
      _addSuspiciousActivity('multiple_locations', 'rapid_movement');
    }
  }

  void _addSuspiciousActivity(String location, String activity) {
    if (!_suspiciousActivities.containsKey(location)) {
      _suspiciousActivities[location] = [];
    }
    _suspiciousActivities[location]!.add(activity);
    
    // Increase location suspicion
    _locationSuspicion[location] = (_locationSuspicion[location] ?? 0.0) + 1.0;
  }

  void _adjustAlertLevels() {
    if (_playerHeat > 80) {
      _currentAlertLevel = AlertLevel.manhunt;
    } else if (_playerHeat > 60) {
      _currentAlertLevel = AlertLevel.critical;
    } else if (_playerHeat > 40) {
      _currentAlertLevel = AlertLevel.high;
    } else if (_playerHeat > 20) {
      _currentAlertLevel = AlertLevel.medium;
    } else if (_playerHeat > 5) {
      _currentAlertLevel = AlertLevel.low;
    } else {
      _currentAlertLevel = AlertLevel.none;
    }
  }

  void _deployUnits() {
    switch (_currentAlertLevel) {
      case AlertLevel.manhunt:
        _deployAllUnits();
        break;
      case AlertLevel.critical:
        _deploySwatAndDetectives();
        break;
      case AlertLevel.high:
        _increasePatrols();
        break;
      case AlertLevel.medium:
        _deployUndercover();
        break;
      default:
        // Normal operations
        break;
    }
  }

  void _deployAllUnits() {
    for (final officerId in _officers.keys) {
      final officer = _officers[officerId]!;
      _officers[officerId] = PoliceOfficer(
        id: officer.id,
        name: officer.name,
        unit: officer.unit,
        suspicion: officer.suspicion,
        corruption: officer.corruption,
        skill: officer.skill,
        aggression: officer.aggression,
        position: officer.position,
        currentAssignment: 'manhunt_active',
        knownDealers: officer.knownDealers,
        payoff: officer.payoff,
      );
    }
  }

  void _deploySwatAndDetectives() {
    for (final officerId in _officers.keys) {
      final officer = _officers[officerId]!;
      if (officer.unit == PoliceUnit.swat || officer.unit == PoliceUnit.detective) {
        _officers[officerId] = PoliceOfficer(
          id: officer.id,
          name: officer.name,
          unit: officer.unit,
          suspicion: officer.suspicion,
          corruption: officer.corruption,
          skill: officer.skill,
          aggression: officer.aggression,
          position: officer.position,
          currentAssignment: 'high_priority_search',
          knownDealers: officer.knownDealers,
          payoff: officer.payoff,
        );
      }
    }
  }

  void _increasePatrols() {
    final patrolOfficers = _officers.values
        .where((officer) => officer.unit == PoliceUnit.patrol)
        .toList();
    
    for (final officer in patrolOfficers) {
      _officers[officer.id] = PoliceOfficer(
        id: officer.id,
        name: officer.name,
        unit: officer.unit,
        suspicion: officer.suspicion,
        corruption: officer.corruption,
        skill: officer.skill,
        aggression: officer.aggression,
        position: officer.position,
        currentAssignment: 'increased_patrol',
        knownDealers: officer.knownDealers,
        payoff: officer.payoff,
      );
    }
  }

  void _deployUndercover() {
    final undercoverOfficers = _officers.values
        .where((officer) => officer.unit == PoliceUnit.undercover)
        .toList();
    
    for (final officer in undercoverOfficers) {
      _officers[officer.id] = PoliceOfficer(
        id: officer.id,
        name: officer.name,
        unit: officer.unit,
        suspicion: officer.suspicion,
        corruption: officer.corruption,
        skill: officer.skill,
        aggression: officer.aggression,
        position: officer.position,
        currentAssignment: 'intelligence_gathering',
        knownDealers: officer.knownDealers,
        payoff: officer.payoff,
      );
    }
  }

  // Public interface methods
  AlertLevel get currentAlertLevel => _currentAlertLevel;
  double get playerHeat => _playerHeat;
  
  List<PoliceOfficer> get allOfficers => _officers.values.toList();
  List<Investigation> get activeInvestigations => _investigations.values
      .where((inv) => inv.status == InvestigationStatus.active || inv.status == InvestigationStatus.hot)
      .toList();

  void reportSuspiciousActivity(Offset location, String activity, double severity) {
    _playerHeat += severity;
    _lastSightings[location.toString()] = DateTime.now();
    _addSuspiciousActivity(location.toString(), activity);
  }

  void bribeOfficer(String officerId, double amount) {
    final officer = _officers[officerId];
    if (officer == null) return;
    
    if (officer.corruption > 0.3 && amount >= officer.payoff) {
      // Successful bribe
      _playerHeat = (_playerHeat * 0.8).clamp(0.0, 100.0);
      
      _officers[officerId] = PoliceOfficer(
        id: officer.id,
        name: officer.name,
        unit: officer.unit,
        suspicion: officer.suspicion * 0.7, // Reduced suspicion
        corruption: (officer.corruption + 0.1).clamp(0.0, 1.0),
        skill: officer.skill,
        aggression: officer.aggression,
        position: officer.position,
        currentAssignment: 'compromised',
        knownDealers: officer.knownDealers,
        payoff: officer.payoff * 1.2, // Increase future bribe amount
      );
    } else {
      // Failed bribe - increases heat significantly
      _playerHeat += 25.0;
      reportSuspiciousActivity(officer.position, 'attempted_bribery', 15.0);
    }
  }

  double getAreaRisk(Offset position) {
    double risk = 0.0;
    
    // Check nearby officers
    for (final officer in _officers.values) {
      final distance = (officer.position - position).distance;
      if (distance < 50) {
        risk += (50 - distance) / 50 * officer.suspicion;
      }
    }
    
    // Check location suspicion
    final locationKey = position.toString();
    risk += _locationSuspicion[locationKey] ?? 0.0;
    
    // Alert level modifier
    switch (_currentAlertLevel) {
      case AlertLevel.manhunt:
        risk *= 3.0;
        break;
      case AlertLevel.critical:
        risk *= 2.0;
        break;
      case AlertLevel.high:
        risk *= 1.5;
        break;
      default:
        break;
    }
    
    return risk.clamp(0.0, 100.0);
  }

  Map<String, dynamic> getPoliceStatus() {
    return {
      'alertLevel': _currentAlertLevel.toString().split('.').last,
      'playerHeat': _playerHeat,
      'activeOfficers': _officers.length,
      'activeInvestigations': activeInvestigations.length,
      'corruptOfficers': _officers.values.where((o) => o.corruption > 0.5).length,
      'lastActivity': _lastSightings.isNotEmpty 
          ? DateTime.now().difference(_lastSightings.values.last).inMinutes
          : null,
    };
  }

  List<String> getRecentActivities() {
    final activities = <String>[];
    
    for (final investigation in _investigations.values) {
      if (investigation.status == InvestigationStatus.hot) {
        activities.add('🔍 Hot investigation: ${investigation.target}');
      }
      if (investigation.status == InvestigationStatus.raid) {
        activities.add('🚨 RAID IN PROGRESS: ${investigation.target}');
      }
    }
    
    switch (_currentAlertLevel) {
      case AlertLevel.manhunt:
        activities.add('🚁 MANHUNT ACTIVE - ALL UNITS DEPLOYED');
        break;
      case AlertLevel.critical:
        activities.add('🚔 Critical alert - SWAT on standby');
        break;
      case AlertLevel.high:
        activities.add('⚠️ High alert - Increased patrols');
        break;
      default:
        break;
    }
    
    return activities;
  }
}

// Police status widget
class PoliceStatusWidget extends StatefulWidget {
  const PoliceStatusWidget({super.key});

  @override
  State<PoliceStatusWidget> createState() => _PoliceStatusWidgetState();
}

class _PoliceStatusWidgetState extends State<PoliceStatusWidget> {
  final PoliceAISystem _policeSystem = PoliceAISystem();
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    _policeSystem.initialize();
    _updateTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
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
    final status = _policeSystem.getPoliceStatus();
    final activities = _policeSystem.getRecentActivities();
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getAlertColor(_policeSystem.currentAlertLevel),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_police,
                color: _getAlertColor(_policeSystem.currentAlertLevel),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Police Status',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          _buildStatusRow('Alert Level', status['alertLevel']),
          _buildStatusRow('Heat Level', '${status['playerHeat'].toStringAsFixed(0)}%'),
          _buildStatusRow('Active Units', '${status['activeOfficers']}'),
          _buildStatusRow('Investigations', '${status['activeInvestigations']}'),
          _buildStatusRow('Corrupt Officers', '${status['corruptOfficers']}'),
          
          if (activities.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Text(
              'Recent Activity:',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            ...activities.map((activity) => Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                activity,
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 10,
                ),
              ),
            )),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getAlertColor(AlertLevel level) {
    switch (level) {
      case AlertLevel.none:
        return Colors.green;
      case AlertLevel.low:
        return Colors.yellow;
      case AlertLevel.medium:
        return Colors.orange;
      case AlertLevel.high:
        return Colors.red;
      case AlertLevel.critical:
        return Colors.purple;
      case AlertLevel.manhunt:
        return Colors.white;
    }
  }
}
