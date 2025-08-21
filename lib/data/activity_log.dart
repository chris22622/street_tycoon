import 'dart:math';

enum ActivityType {
  transaction,
  crime,
  travel,
  upgrade,
  layLow,
  endDay,
  randomEvent,
  skillGain,
  energyDepletion,
}

class ActivityLog {
  final List<Activity> activities;

  const ActivityLog({
    required this.activities,
  });

  factory ActivityLog.initial() {
    return const ActivityLog(activities: []);
  }

  ActivityLog addActivity(Activity activity) {
    final newActivities = [activity, ...activities];
    // Keep only the last 200 activities to prevent memory issues
    final limitedActivities = newActivities.take(200).toList();
    return ActivityLog(activities: limitedActivities);
  }

  List<Activity> get recentActivities => activities.take(50).toList();

  List<Activity> get todaysActivities {
    final today = DateTime.now();
    return activities.where((activity) {
      return activity.timestamp.day == today.day &&
             activity.timestamp.month == today.month &&
             activity.timestamp.year == today.year;
    }).toList();
  }

  List<Activity> getActivitiesByType(ActivityType type) {
    return activities.where((activity) => activity.type == type).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'activities': activities.map((a) => a.toJson()).toList(),
    };
  }

  factory ActivityLog.fromJson(Map<String, dynamic> json) {
    return ActivityLog(
      activities: (json['activities'] as List<dynamic>?)
          ?.map((a) => Activity.fromJson(a))
          .toList() ?? [],
    );
  }
}

class Activity {
  final String id;
  final ActivityType type;
  final String title;
  final String description;
  final String? emoji;
  final int? cashImpact;
  final int? energyImpact;
  final int? heatImpact;
  final Map<String, dynamic>? metadata;
  final DateTime timestamp;
  final bool isSuccess;

  const Activity({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    this.emoji,
    this.cashImpact,
    this.energyImpact,
    this.heatImpact,
    this.metadata,
    required this.timestamp,
    this.isSuccess = true,
  });

  factory Activity.transaction({
    required String item,
    required String transactionType,
    required int quantity,
    required int pricePerUnit,
    required int totalAmount,
    required String area,
  }) {
    final isProfit = transactionType == 'sell';
    final emoji = _getItemEmoji(item);
    final action = transactionType == 'buy' ? 'Bought' : 'Sold';
    
    return Activity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: ActivityType.transaction,
      title: '$action $item',
      description: '$emoji $action ${quantity}x $item @ \$${_formatCurrency(pricePerUnit)} each in $area',
      emoji: emoji,
      cashImpact: isProfit ? totalAmount : -totalAmount,
      energyImpact: -2,
      timestamp: DateTime.now(),
      isSuccess: true,
      metadata: {
        'item': item,
        'quantity': quantity,
        'pricePerUnit': pricePerUnit,
        'area': area,
        'transactionType': transactionType,
      },
    );
  }

  factory Activity.crime({
    required String crimeName,
    required bool success,
    required int payout,
    required int energyCost,
    required int heatGain,
    required String outcome,
    Map<String, int>? skillGains,
  }) {
    return Activity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: ActivityType.crime,
      title: success ? '$crimeName - Success!' : '$crimeName - Failed',
      description: outcome,
      emoji: success ? '💰' : '🚨',
      cashImpact: success ? payout : 0,
      energyImpact: -energyCost,
      heatImpact: heatGain,
      timestamp: DateTime.now(),
      isSuccess: success,
      metadata: {
        'crimeName': crimeName,
        'skillGains': skillGains ?? {},
        'baseReward': payout,
      },
    );
  }

  factory Activity.travel({
    required String fromArea,
    required String toArea,
    required int energyCost,
  }) {
    return Activity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: ActivityType.travel,
      title: 'Traveled to $toArea',
      description: '🚗 Traveled from $fromArea to $toArea',
      emoji: '🚗',
      energyImpact: -energyCost,
      timestamp: DateTime.now(),
      isSuccess: true,
      metadata: {
        'fromArea': fromArea,
        'toArea': toArea,
      },
    );
  }

  factory Activity.upgrade({
    required String upgradeName,
    required int cost,
    required String effect,
  }) {
    return Activity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: ActivityType.upgrade,
      title: 'Purchased $upgradeName',
      description: '⬆️ $upgradeName: $effect',
      emoji: '⬆️',
      cashImpact: -cost,
      timestamp: DateTime.now(),
      isSuccess: true,
      metadata: {
        'upgradeName': upgradeName,
        'effect': effect,
      },
    );
  }

  factory Activity.layLow({
    required int cost,
    required int heatReduction,
  }) {
    return Activity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: ActivityType.layLow,
      title: 'Laid Low',
      description: '🏠 Paid \$${_formatCurrency(cost)} to reduce heat by $heatReduction',
      emoji: '🏠',
      cashImpact: -cost,
      heatImpact: -heatReduction,
      energyImpact: -5,
      timestamp: DateTime.now(),
      isSuccess: true,
    );
  }

  factory Activity.endDay({
    required int day,
    required int energyRestored,
  }) {
    return Activity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: ActivityType.endDay,
      title: 'Day $day Complete',
      description: '🌙 Ended day $day. Restored $energyRestored energy.',
      emoji: '🌙',
      energyImpact: energyRestored,
      timestamp: DateTime.now(),
      isSuccess: true,
      metadata: {
        'day': day,
      },
    );
  }

  factory Activity.randomEvent({
    required String eventTitle,
    required String eventDescription,
    required String eventEmoji,
    int? cashImpact,
    int? heatImpact,
    int? energyImpact,
    Map<String, dynamic>? metadata,
  }) {
    return Activity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: ActivityType.randomEvent,
      title: eventTitle,
      description: '$eventEmoji $eventDescription',
      emoji: eventEmoji,
      cashImpact: cashImpact,
      heatImpact: heatImpact,
      energyImpact: energyImpact,
      timestamp: DateTime.now(),
      isSuccess: (cashImpact ?? 0) >= 0,
      metadata: metadata,
    );
  }

  factory Activity.skillGain({
    required String skillName,
    required int previousLevel,
    required int newLevel,
  }) {
    return Activity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: ActivityType.skillGain,
      title: '$skillName Improved!',
      description: '📈 $skillName increased from level $previousLevel to $newLevel',
      emoji: '📈',
      timestamp: DateTime.now(),
      isSuccess: true,
      metadata: {
        'skillName': skillName,
        'previousLevel': previousLevel,
        'newLevel': newLevel,
      },
    );
  }

  factory Activity.energyDepletion() {
    return Activity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: ActivityType.energyDepletion,
      title: 'Energy Depleted',
      description: '😴 You\'re exhausted! Automatically ending the day...',
      emoji: '😴',
      timestamp: DateTime.now(),
      isSuccess: false,
    );
  }

  String get impactText {
    final impacts = <String>[];
    
    if (cashImpact != null && cashImpact != 0) {
      final sign = cashImpact! > 0 ? '+' : '';
      impacts.add('$sign\$${_formatCurrency(cashImpact!.abs())}');
    }
    
    if (energyImpact != null && energyImpact != 0) {
      final sign = energyImpact! > 0 ? '+' : '';
      impacts.add('${sign}${energyImpact}⚡');
    }
    
    if (heatImpact != null && heatImpact != 0) {
      final sign = heatImpact! > 0 ? '+' : '';
      impacts.add('${sign}${heatImpact}🔥');
    }
    
    return impacts.join(' ');
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  static String _getItemEmoji(String item) {
    switch (item.toLowerCase()) {
      case 'weed': return '🌿';
      case 'speed': return '⚡';
      case 'ludes': return '💊';
      case 'acid': return '🧪';
      case 'pcp': return '☠️';
      case 'heroin': return '💉';
      case 'cocaine': return '❄️';
      case 'ecstasy': return '💙';
      default: return '📦';
    }
  }

  static String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.index,
      'title': title,
      'description': description,
      'emoji': emoji,
      'cashImpact': cashImpact,
      'energyImpact': energyImpact,
      'heatImpact': heatImpact,
      'metadata': metadata,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'isSuccess': isSuccess,
    };
  }

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      type: ActivityType.values[json['type']],
      title: json['title'],
      description: json['description'],
      emoji: json['emoji'],
      cashImpact: json['cashImpact'],
      energyImpact: json['energyImpact'],
      heatImpact: json['heatImpact'],
      metadata: json['metadata'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
      isSuccess: json['isSuccess'] ?? true,
    );
  }
}
