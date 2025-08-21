import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers.dart';
import '../../data/activity_log.dart';

class ActivityLogSheet extends ConsumerWidget {
  const ActivityLogSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameControllerProvider);
    final activityLog = gameState.activityLog ?? ActivityLog.initial();
    
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.history, color: Colors.orange),
                    const SizedBox(width: 8),
                    const Text(
                      'Activity Log',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${activityLog.activities.length} entries',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              
              // Filter tabs
              _buildFilterTabs(context),
              
              // Activity list
              Expanded(
                child: activityLog.activities.isEmpty
                    ? _buildEmptyState(context)
                    : ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: activityLog.recentActivities.length,
                        itemBuilder: (context, index) {
                          final activity = activityLog.recentActivities[index];
                          return _buildActivityCard(context, activity, index == 0);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterTabs(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildFilterChip(context, 'All', true),
          const SizedBox(width: 8),
          _buildFilterChip(context, 'Trades', false),
          const SizedBox(width: 8),
          _buildFilterChip(context, 'Crimes', false),
          const SizedBox(width: 8),
          _buildFilterChip(context, 'Events', false),
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        // TODO: Implement filtering
      },
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? Theme.of(context).primaryColor : null,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No activities yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start trading, committing crimes, or traveling to see your activity history here.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(BuildContext context, Activity activity, bool isLatest) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isLatest 
            ? Theme.of(context).primaryColor.withOpacity(0.1)
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: isLatest 
            ? Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3))
            : Border.all(color: Theme.of(context).dividerColor, width: 0.5),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: _buildActivityIcon(context, activity),
        title: Row(
          children: [
            Expanded(
              child: Text(
                activity.title,
                style: TextStyle(
                  fontWeight: isLatest ? FontWeight.bold : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
            Text(
              activity.timeAgo,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
                fontSize: 11,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              activity.description,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (activity.impactText.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                activity.impactText,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _getImpactColor(context, activity),
                ),
              ),
            ],
          ],
        ),
        trailing: _buildActivityStatus(context, activity),
      ),
    );
  }

  Widget _buildActivityIcon(BuildContext context, Activity activity) {
    final iconData = _getActivityIconData(activity.type);
    final iconColor = _getActivityIconColor(context, activity);
    
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 20,
      ),
    );
  }

  Widget? _buildActivityStatus(BuildContext context, Activity activity) {
    if (activity.type == ActivityType.crime) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: activity.isSuccess ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          activity.isSuccess ? 'Success' : 'Failed',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: activity.isSuccess ? Colors.green : Colors.red,
          ),
        ),
      );
    }
    return null;
  }

  IconData _getActivityIconData(ActivityType type) {
    switch (type) {
      case ActivityType.transaction:
        return Icons.shopping_cart;
      case ActivityType.crime:
        return Icons.warning;
      case ActivityType.travel:
        return Icons.directions_car;
      case ActivityType.upgrade:
        return Icons.upgrade;
      case ActivityType.layLow:
        return Icons.spa;
      case ActivityType.endDay:
        return Icons.bedtime;
      case ActivityType.randomEvent:
        return Icons.event;
      case ActivityType.skillGain:
        return Icons.trending_up;
      case ActivityType.energyDepletion:
        return Icons.battery_alert;
    }
  }

  Color _getActivityIconColor(BuildContext context, Activity activity) {
    switch (activity.type) {
      case ActivityType.transaction:
        return Colors.blue;
      case ActivityType.crime:
        return activity.isSuccess ? Colors.green : Colors.red;
      case ActivityType.travel:
        return Colors.purple;
      case ActivityType.upgrade:
        return Colors.orange;
      case ActivityType.layLow:
        return Colors.teal;
      case ActivityType.endDay:
        return Colors.indigo;
      case ActivityType.randomEvent:
        return Colors.amber;
      case ActivityType.skillGain:
        return Colors.cyan;
      case ActivityType.energyDepletion:
        return Colors.grey;
    }
  }

  Color _getImpactColor(BuildContext context, Activity activity) {
    if (activity.cashImpact != null) {
      return activity.cashImpact! > 0 ? Colors.green : Colors.red;
    }
    return Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey;
  }
}
