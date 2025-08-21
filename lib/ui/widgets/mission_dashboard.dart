import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../logic/mission_service.dart';
import '../../providers.dart';

class MissionDashboard extends ConsumerWidget {
  const MissionDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameControllerProvider);
    final stats = gameState.statistics;
    
    // Mock data for demonstration - in real implementation, this would come from game state
    final activeMissions = <Mission>[
      const Mission(
        id: 'first_steps',
        title: 'First Steps',
        description: 'Complete your first 5 transactions',
        difficulty: 'Easy',
        icon: '👟',
        objectives: {'totalTransactions': 5},
        rewards: {'cash': 500},
        isActive: true,
      ),
    ];
    
    final availableMissions = MissionService.getAvailableMissionsForPlayer(
      stats,
      {},
      activeMissions,
    ).take(3).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Reduced from 16.0
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.assignment, color: Theme.of(context).primaryColor, size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Missions',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _showAllMissions(context, ref),
                  icon: const Icon(Icons.list),
                  label: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Active Missions
            if (activeMissions.isNotEmpty) ...[
              Text(
                'Active Missions',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...activeMissions.map((mission) => _buildMissionCard(
                context, mission, stats, isActive: true
              )),
              const SizedBox(height: 16),
            ],
            
            // Available Missions
            if (availableMissions.isNotEmpty) ...[
              Text(
                'Available Missions',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...availableMissions.map((mission) => _buildMissionCard(
                context, mission, stats, isActive: false
              )),
            ],
            
            if (activeMissions.isEmpty && availableMissions.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 48,
                        color: Colors.green,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'All missions completed!',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'New missions coming soon...',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionCard(
    BuildContext context,
    Mission mission,
    Map<String, dynamic> stats,
    {required bool isActive}
  ) {
    final progress = _calculateProgress(mission, stats);
    final isCompleted = progress >= 1.0;
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: isActive 
        ? Theme.of(context).primaryColor.withOpacity(0.1)
        : null,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getDifficultyColor(mission.difficulty).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _getDifficultyColor(mission.difficulty).withOpacity(0.3),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      mission.icon,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              mission.title,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getDifficultyColor(mission.difficulty).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _getDifficultyColor(mission.difficulty).withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              mission.difficulty,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: _getDifficultyColor(mission.difficulty),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        mission.description,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            if (isActive) ...[
              const SizedBox(height: 12),
              
              // Progress bar
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey.withOpacity(0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isCompleted ? Colors.green : Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${(progress * 100).round()}%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isCompleted ? Colors.green : null,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Objectives
              ...mission.objectives.entries.map((objective) =>
                _buildObjectiveItem(context, objective, stats)
              ),
            ],
            
            // Rewards
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: mission.rewards.entries.map((reward) =>
                _buildRewardChip(context, reward)
              ).toList(),
            ),
            
            // Actions
            if (!isActive && !isCompleted) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _acceptMission(mission),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Accept Mission'),
                ),
              ),
            ] else if (isActive && isCompleted) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => _completeMission(mission),
                  icon: const Icon(Icons.check),
                  label: const Text('Claim Rewards'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildObjectiveItem(
    BuildContext context,
    MapEntry<String, dynamic> objective,
    Map<String, dynamic> stats,
  ) {
    final current = stats[objective.key] ?? 0;
    final required = objective.value;
    final isCompleted = current >= required;
    
    String description = '';
    switch (objective.key) {
      case 'totalTransactions':
        description = 'Complete $required transactions';
        break;
      case 'totalProfit':
        description = 'Earn \$${required.toStringAsFixed(0)} profit';
        break;
      case 'areasVisited':
        description = 'Visit $required areas';
        break;
      default:
        description = '${objective.key}: $required';
        break;
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: isCompleted ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isCompleted ? Colors.green : null,
                decoration: isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          Text(
            '$current / $required',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isCompleted ? Colors.green : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardChip(BuildContext context, MapEntry<String, dynamic> reward) {
    IconData icon = Icons.star;
    String label = '';
    
    switch (reward.key) {
      case 'cash':
        icon = Icons.attach_money;
        label = '\$${reward.value}';
        break;
      case 'experience':
        icon = Icons.trending_up;
        label = '${reward.value} XP';
        break;
      case 'capacityUpgrade':
        icon = Icons.inventory;
        label = '+${reward.value} capacity';
        break;
      default:
        label = '${reward.key}: ${reward.value}';
        break;
    }
    
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Easy':
        return Colors.green;
      case 'Medium':
        return Colors.orange;
      case 'Hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  double _calculateProgress(Mission mission, Map<String, dynamic> stats) {
    double totalProgress = 0;
    int objectiveCount = mission.objectives.length;
    
    for (var objective in mission.objectives.entries) {
      final current = stats[objective.key] ?? 0;
      final required = objective.value;
      final progress = (current / required).clamp(0.0, 1.0);
      totalProgress += progress;
    }
    
    return objectiveCount > 0 ? totalProgress / objectiveCount : 0;
  }

  void _acceptMission(Mission mission) {
    // In real implementation, this would update the game state
    print('Accepting mission: ${mission.title}');
  }

  void _completeMission(Mission mission) {
    // In real implementation, this would give rewards and mark as completed
    print('Completing mission: ${mission.title}');
  }

  void _showAllMissions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'All Missions',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  child: const MissionDashboard(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
