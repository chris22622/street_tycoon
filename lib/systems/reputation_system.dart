import 'package:flutter/material.dart';
import 'dart:math' as math;

enum ReputationType {
  street,
  gang,
  police,
  business,
  underground,
  international,
}

enum ReputationTier {
  unknown,
  smallTime,
  recognized,
  respected,
  feared,
  legendary,
}

class ReputationEvent {
  final String id;
  final String description;
  final ReputationType type;
  final double impact;
  final DateTime timestamp;
  final Map<String, dynamic> details;
  final bool isPublic;

  const ReputationEvent({
    required this.id,
    required this.description,
    required this.type,
    required this.impact,
    required this.timestamp,
    required this.details,
    required this.isPublic,
  });
}

class ReputationModifier {
  final String source;
  final double multiplier;
  final Duration duration;
  final DateTime applied;
  final String reason;

  const ReputationModifier({
    required this.source,
    required this.multiplier,
    required this.duration,
    required this.applied,
    required this.reason,
  });
}

class ReputationSystem {
  static final ReputationSystem _instance = ReputationSystem._internal();
  factory ReputationSystem() => _instance;
  ReputationSystem._internal();

  final Map<ReputationType, double> _reputationScores = {
    ReputationType.street: 0.0,
    ReputationType.gang: 0.0,
    ReputationType.police: 0.0,
    ReputationType.business: 0.0,
    ReputationType.underground: 0.0,
    ReputationType.international: 0.0,
  };

  final List<ReputationEvent> _reputationHistory = [];
  final List<ReputationModifier> _activeModifiers = [];

  // Titles and nicknames
  final List<String> _currentTitles = [];
  final Map<ReputationType, List<String>> _availableTitles = {
    ReputationType.street: [
      'The Nobody',
      'Corner Kid',
      'Block Runner',
      'Street Legend',
      'King of the Streets',
      'Urban Myth',
    ],
    ReputationType.gang: [
      'Outsider',
      'Associate',
      'Made Man',
      'Lieutenant',
      'Boss',
      'Godfather',
    ],
    ReputationType.police: [
      'Clean',
      'Person of Interest',
      'Suspect',
      'Most Wanted',
      'Public Enemy',
      'Ghost',
    ],
    ReputationType.business: [
      'Nobody',
      'Small Investor',
      'Business Owner',
      'Corporate Player',
      'Mogul',
      'Kingpin',
    ],
    ReputationType.underground: [
      'Unknown',
      'Whispered Name',
      'Connected',
      'Well Known',
      'Feared',
      'The Boogeyman',
    ],
    ReputationType.international: [
      'Local',
      'Regional',
      'National',
      'International',
      'Global Player',
      'Shadow Empire',
    ],
  };

  void initialize() {
    _updateTitles();
  }

  void addReputationEvent(
    String description,
    ReputationType type,
    double impact, {
    Map<String, dynamic>? details,
    bool isPublic = true,
    bool applyDecay = true,
  }) {
    final event = ReputationEvent(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      description: description,
      type: type,
      impact: impact,
      timestamp: DateTime.now(),
      details: details ?? {},
      isPublic: isPublic,
    );

    _reputationHistory.add(event);

    // Apply the reputation change with modifiers
    double finalImpact = impact;
    
    // Apply active modifiers
    for (final modifier in _activeModifiers) {
      if (_isModifierActive(modifier)) {
        finalImpact *= modifier.multiplier;
      }
    }

    // Apply cross-reputation effects
    _applyCrossEffects(type, finalImpact);
    
    // Update the primary reputation
    _reputationScores[type] = (_reputationScores[type]! + finalImpact).clamp(-100.0, 100.0);

    // Update titles
    _updateTitles();

    // Trigger consequences
    _triggerReputationConsequences(type, finalImpact);

    // Keep history manageable
    if (_reputationHistory.length > 100) {
      _reputationHistory.removeAt(0);
    }
  }

  void _applyCrossEffects(ReputationType primaryType, double impact) {
    switch (primaryType) {
      case ReputationType.street:
        // Street rep affects gang rep positively
        _reputationScores[ReputationType.gang] = 
            (_reputationScores[ReputationType.gang]! + impact * 0.3).clamp(-100.0, 100.0);
        // But negatively affects police rep
        _reputationScores[ReputationType.police] = 
            (_reputationScores[ReputationType.police]! - impact * 0.2).clamp(-100.0, 100.0);
        break;
        
      case ReputationType.gang:
        // Gang rep affects underground rep
        _reputationScores[ReputationType.underground] = 
            (_reputationScores[ReputationType.underground]! + impact * 0.4).clamp(-100.0, 100.0);
        // Strong negative effect on police rep
        _reputationScores[ReputationType.police] = 
            (_reputationScores[ReputationType.police]! - impact * 0.5).clamp(-100.0, 100.0);
        break;
        
      case ReputationType.business:
        // Business rep can help with international
        _reputationScores[ReputationType.international] = 
            (_reputationScores[ReputationType.international]! + impact * 0.3).clamp(-100.0, 100.0);
        // But too much can hurt street cred
        if (impact > 10) {
          _reputationScores[ReputationType.street] = 
              (_reputationScores[ReputationType.street]! - impact * 0.1).clamp(-100.0, 100.0);
        }
        break;
        
      case ReputationType.police:
        // Positive police rep hurts all criminal reps
        if (impact > 0) {
          _reputationScores[ReputationType.street] = 
              (_reputationScores[ReputationType.street]! - impact * 0.3).clamp(-100.0, 100.0);
          _reputationScores[ReputationType.gang] = 
              (_reputationScores[ReputationType.gang]! - impact * 0.4).clamp(-100.0, 100.0);
          _reputationScores[ReputationType.underground] = 
              (_reputationScores[ReputationType.underground]! - impact * 0.3).clamp(-100.0, 100.0);
        }
        break;
        
      case ReputationType.underground:
        // Underground rep affects international
        _reputationScores[ReputationType.international] = 
            (_reputationScores[ReputationType.international]! + impact * 0.2).clamp(-100.0, 100.0);
        break;
        
      case ReputationType.international:
        // International rep can boost business
        _reputationScores[ReputationType.business] = 
            (_reputationScores[ReputationType.business]! + impact * 0.2).clamp(-100.0, 100.0);
        break;
    }
  }

  void _triggerReputationConsequences(ReputationType type, double impact) {
    final currentScore = _reputationScores[type]!;
    final tier = _getReputationTier(currentScore);

    // Positive reputation consequences
    if (impact > 0 && tier.index >= ReputationTier.respected.index) {
      switch (type) {
        case ReputationType.street:
          _addModifier('street_respect', 1.2, const Duration(hours: 2), 'Street respect bonus');
          break;
        case ReputationType.gang:
          _addModifier('gang_protection', 0.8, const Duration(hours: 1), 'Gang protection');
          break;
        case ReputationType.business:
          _addModifier('business_network', 1.3, const Duration(hours: 3), 'Business connections');
          break;
        default:
          break;
      }
    }

    // Negative reputation consequences
    if (impact < 0 && currentScore < -50) {
      switch (type) {
        case ReputationType.police:
          _addModifier('wanted_heat', 1.5, const Duration(hours: 4), 'Increased police attention');
          break;
        case ReputationType.gang:
          _addModifier('gang_hostility', 0.7, const Duration(hours: 2), 'Gang hostility');
          break;
        default:
          break;
      }
    }
  }

  void _addModifier(String source, double multiplier, Duration duration, String reason) {
    final modifier = ReputationModifier(
      source: source,
      multiplier: multiplier,
      duration: duration,
      applied: DateTime.now(),
      reason: reason,
    );
    
    _activeModifiers.add(modifier);
    
    // Remove expired modifiers
    _cleanupModifiers();
  }

  void _cleanupModifiers() {
    _activeModifiers.removeWhere((modifier) => !_isModifierActive(modifier));
  }

  bool _isModifierActive(ReputationModifier modifier) {
    return DateTime.now().difference(modifier.applied) < modifier.duration;
  }

  void _updateTitles() {
    _currentTitles.clear();
    
    for (final type in ReputationType.values) {
      final score = _reputationScores[type]!;
      final tier = _getReputationTier(score);
      final titles = _availableTitles[type]!;
      
      if (tier.index < titles.length) {
        _currentTitles.add(titles[tier.index]);
      }
    }
  }

  ReputationTier _getReputationTier(double score) {
    if (score < -50) return ReputationTier.unknown;
    if (score < -10) return ReputationTier.unknown;
    if (score < 10) return ReputationTier.smallTime;
    if (score < 30) return ReputationTier.recognized;
    if (score < 60) return ReputationTier.respected;
    if (score < 85) return ReputationTier.feared;
    return ReputationTier.legendary;
  }

  // Public interface
  double getReputation(ReputationType type) => _reputationScores[type]!;
  
  ReputationTier getReputationTier(ReputationType type) => 
      _getReputationTier(_reputationScores[type]!);
  
  List<String> getCurrentTitles() => List.unmodifiable(_currentTitles);
  
  String getPrimaryTitle() {
    if (_currentTitles.isEmpty) return 'Nobody';
    
    // Find the highest tier title
    double maxScore = -999;
    String primaryTitle = 'Nobody';
    
    for (final type in ReputationType.values) {
      final score = _reputationScores[type]!;
      if (score > maxScore) {
        maxScore = score;
        final tier = _getReputationTier(score);
        final titles = _availableTitles[type]!;
        if (tier.index < titles.length) {
          primaryTitle = titles[tier.index];
        }
      }
    }
    
    return primaryTitle;
  }

  List<ReputationEvent> getRecentEvents({int limit = 10}) {
    final sorted = List<ReputationEvent>.from(_reputationHistory);
    sorted.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return sorted.take(limit).toList();
  }

  Map<ReputationType, double> getAllReputations() => 
      Map.unmodifiable(_reputationScores);

  List<ReputationModifier> getActiveModifiers() {
    _cleanupModifiers();
    return List.unmodifiable(_activeModifiers);
  }

  double getReputationMultiplier(ReputationType type) {
    double multiplier = 1.0;
    _cleanupModifiers();
    
    for (final modifier in _activeModifiers) {
      multiplier *= modifier.multiplier;
    }
    
    return multiplier;
  }

  // Game-specific reputation actions
  void dealCompleted(double value, bool success, String location) {
    if (success) {
      final impact = math.min(value / 1000, 5.0); // Scale impact
      addReputationEvent(
        'Successful deal worth \$${value.toStringAsFixed(0)} in $location',
        ReputationType.street,
        impact,
        details: {'value': value, 'location': location},
      );
      
      if (value > 10000) {
        addReputationEvent(
          'Big money deal caught attention',
          ReputationType.underground,
          impact * 0.5,
        );
      }
    } else {
      addReputationEvent(
        'Failed deal in $location',
        ReputationType.street,
        -2.0,
        details: {'location': location},
      );
    }
  }

  void policeChaseConcluded(bool escaped, double duration) {
    if (escaped) {
      final impact = math.min(duration / 30, 8.0); // Max 8 points for long chase
      addReputationEvent(
        'Escaped police chase lasting ${duration.toStringAsFixed(1)} minutes',
        ReputationType.street,
        impact,
        details: {'duration': duration},
      );
      
      addReputationEvent(
        'Evaded law enforcement',
        ReputationType.police,
        -impact,
      );
    } else {
      addReputationEvent(
        'Caught by police after chase',
        ReputationType.street,
        -5.0,
      );
      
      addReputationEvent(
        'Apprehended',
        ReputationType.police,
        3.0,
      );
    }
  }

  void gangInteraction(String gangId, String action, bool positive) {
    final impact = positive ? 5.0 : -7.0;
    addReputationEvent(
      '${positive ? "Positive" : "Negative"} interaction with $gangId: $action',
      ReputationType.gang,
      impact,
      details: {'gang': gangId, 'action': action},
    );
  }

  void businessDeal(double amount, String type) {
    final impact = math.min(amount / 5000, 6.0);
    addReputationEvent(
      'Business transaction: $type worth \$${amount.toStringAsFixed(0)}',
      ReputationType.business,
      impact,
      details: {'amount': amount, 'type': type},
    );
  }

  void territoryAction(String territory, String action, bool success) {
    final impact = success ? 8.0 : -4.0;
    addReputationEvent(
      '${success ? "Successfully" : "Failed to"} $action in $territory',
      ReputationType.gang,
      impact,
      details: {'territory': territory, 'action': action},
    );
    
    if (success && action.contains('takeover')) {
      addReputationEvent(
        'Territory expansion',
        ReputationType.underground,
        5.0,
      );
    }
  }

  void criminalMastermind(String operation, double complexity) {
    final impact = complexity * 2;
    addReputationEvent(
      'Executed complex operation: $operation',
      ReputationType.underground,
      impact,
      details: {'operation': operation, 'complexity': complexity},
    );
    
    if (complexity > 5) {
      addReputationEvent(
        'Criminal mastermind operation',
        ReputationType.international,
        complexity,
      );
    }
  }

  // Reputation decay over time
  void applyTimeDecay() {
    for (final type in ReputationType.values) {
      final currentScore = _reputationScores[type]!;
      
      // Decay rate varies by reputation type
      double decayRate;
      switch (type) {
        case ReputationType.street:
          decayRate = 0.1; // Fast decay
          break;
        case ReputationType.police:
          decayRate = 0.05; // Slow decay
          break;
        case ReputationType.international:
          decayRate = 0.02; // Very slow decay
          break;
        default:
          decayRate = 0.08;
      }
      
      // Apply decay toward zero
      if (currentScore > 0) {
        _reputationScores[type] = math.max(0, currentScore - decayRate);
      } else if (currentScore < 0) {
        _reputationScores[type] = math.min(0, currentScore + decayRate);
      }
    }
    
    _updateTitles();
  }

  Map<String, dynamic> getReputationSummary() {
    _cleanupModifiers();
    
    return {
      'primaryTitle': getPrimaryTitle(),
      'allTitles': getCurrentTitles(),
      'reputations': getAllReputations(),
      'tiers': Map.fromEntries(
        ReputationType.values.map(
          (type) => MapEntry(type.toString(), getReputationTier(type).toString()),
        ),
      ),
      'activeModifiers': _activeModifiers.length,
      'recentEvents': getRecentEvents(limit: 5).length,
      'totalEvents': _reputationHistory.length,
    };
  }
}

// Reputation display widget
class ReputationWidget extends StatefulWidget {
  final bool expanded;
  final VoidCallback? onTap;

  const ReputationWidget({
    super.key,
    this.expanded = false,
    this.onTap,
  });

  @override
  State<ReputationWidget> createState() => _ReputationWidgetState();
}

class _ReputationWidgetState extends State<ReputationWidget> {
  final ReputationSystem _repSystem = ReputationSystem();

  @override
  void initState() {
    super.initState();
    _repSystem.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.8),
              Colors.purple.withOpacity(0.3),
            ],
          ),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.purple.withOpacity(0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.yellow,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _repSystem.getPrimaryTitle(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (widget.onTap != null)
                  Icon(
                    widget.expanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.white70,
                  ),
              ],
            ),
            
            if (widget.expanded) ...[
              const SizedBox(height: 12),
              
              // All reputations
              ...ReputationType.values.map((type) {
                final score = _repSystem.getReputation(type);
                final tier = _repSystem.getReputationTier(type);
                return _buildReputationBar(type, score, tier);
              }),
              
              const SizedBox(height: 8),
              
              // Recent events
              const Text(
                'Recent Events:',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              ..._repSystem.getRecentEvents(limit: 3).map((event) => 
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '• ${event.description}',
                    style: TextStyle(
                      color: event.impact > 0 ? Colors.green : Colors.red,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
              
              // Active modifiers
              if (_repSystem.getActiveModifiers().isNotEmpty) ...[
                const SizedBox(height: 8),
                const Text(
                  'Active Effects:',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ..._repSystem.getActiveModifiers().map((modifier) => 
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      '${modifier.reason} (${(modifier.multiplier * 100).toStringAsFixed(0)}%)',
                      style: TextStyle(
                        color: modifier.multiplier > 1.0 ? Colors.green : Colors.orange,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ] else ...[
              const SizedBox(height: 4),
              // Compact view - show top reputation
              _buildCompactReputationBar(_getTopReputationType(), _repSystem.getReputation(_getTopReputationType())),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildReputationBar(ReputationType type, double score, ReputationTier tier) {
    final color = _getReputationColor(type);
    final percentage = (score + 100) / 200; // Convert -100 to 100 range to 0-1
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getReputationTypeName(type),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                ),
              ),
              Text(
                '${score.toStringAsFixed(0)} (${tier.toString().split('.').last})',
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              widthFactor: percentage,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactReputationBar(ReputationType type, double score) {
    final color = _getReputationColor(type);
    final percentage = (score + 100) / 200;
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _getReputationTypeName(type),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
            Text(
              score.toStringAsFixed(0),
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            widthFactor: percentage,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  ReputationType _getTopReputationType() {
    double maxScore = -999;
    ReputationType topType = ReputationType.street;
    
    for (final type in ReputationType.values) {
      final score = _repSystem.getReputation(type);
      if (score > maxScore) {
        maxScore = score;
        topType = type;
      }
    }
    
    return topType;
  }

  Color _getReputationColor(ReputationType type) {
    switch (type) {
      case ReputationType.street:
        return Colors.orange;
      case ReputationType.gang:
        return Colors.red;
      case ReputationType.police:
        return Colors.blue;
      case ReputationType.business:
        return Colors.green;
      case ReputationType.underground:
        return Colors.purple;
      case ReputationType.international:
        return const Color(0xFFFFD700); // Gold color
    }
  }

  String _getReputationTypeName(ReputationType type) {
    switch (type) {
      case ReputationType.street:
        return 'Street';
      case ReputationType.gang:
        return 'Gang';
      case ReputationType.police:
        return 'Police';
      case ReputationType.business:
        return 'Business';
      case ReputationType.underground:
        return 'Underground';
      case ReputationType.international:
        return 'International';
    }
  }
}
