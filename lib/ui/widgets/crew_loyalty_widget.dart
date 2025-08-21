import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/crew_models.dart';
import '../../providers.dart';
import '../../util/formatters.dart';
import '../../services/audio_service.dart';

class CrewLoyaltyWidget extends ConsumerWidget {
  const CrewLoyaltyWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameControllerProvider);
    final crew = gameState.crew ?? Crew.initial();
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          // Crew overview card
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.group, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Crew Management',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getLoyaltyColor(crew.averageLoyalty),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${crew.size}/${crew.maxSize}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatChip(
                          'Loyalty: ${crew.averageLoyalty.round()}%',
                          _getLoyaltyColor(crew.averageLoyalty),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: _buildStatChip(
                          'Daily: ${Formatters.money(crew.dailyUpkeep)}',
                          Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Current crew members
          if (crew.members.isNotEmpty)
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Active Crew:',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ...crew.members.map((member) => _buildCrewMemberCard(member, ref)),
                  ],
                ),
              ),
            ),

          // Hiring section
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Recruitment:',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      if (crew.isFull)
                        const Text(
                          'Crew Full',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  if (!crew.isFull) _buildHiringOptions(gameState, ref),
                ],
              ),
            ),
          ),

          // Crew efficiency bonuses
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: _buildEfficiencyBonuses(crew, theme),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCrewMemberCard(CrewMember member, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: _getLoyaltyColor(member.loyalty).withOpacity(0.3)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Text(member.rank.icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  '${member.specialty} • ${member.loyalty.round()}% loyalty',
                  style: TextStyle(
                    fontSize: 10,
                    color: _getLoyaltyColor(member.loyalty),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                member.rank.name,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${Formatters.money(member.dailyUpkeep)}/day',
                style: const TextStyle(
                  fontSize: 9,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 24,
            height: 24,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => _fireMember(member, ref),
              icon: const Icon(Icons.close, size: 14, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHiringOptions(dynamic gameState, WidgetRef ref) {
    final availableRanks = [
      CrewMemberRank.recruit,
      CrewMemberRank.soldier,
      if (gameState.cash >= 25000) CrewMemberRank.lieutenant,
      if (gameState.cash >= 75000) CrewMemberRank.underboss,
    ];

    return Column(
      children: availableRanks.map((rank) {
        final canAfford = gameState.cash >= rank.hireCost;
        return Container(
          margin: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              Text(rank.icon, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${rank.name} - ${Formatters.money(rank.hireCost)}',
                  style: const TextStyle(fontSize: 11),
                ),
              ),
              SizedBox(
                height: 24,
                child: ElevatedButton(
                  onPressed: canAfford ? () => _hireMember(rank, ref) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getRankColor(rank),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  child: const Text(
                    'Hire',
                    style: TextStyle(fontSize: 9),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEfficiencyBonuses(Crew crew, ThemeData theme) {
    if (crew.members.isEmpty) {
      return const Text(
        'No crew bonuses active',
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    final activities = ['trading', 'protection', 'travel', 'heat_reduction'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Crew Bonuses:',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: activities.map((activity) {
            final bonus = crew.getEfficiencyBonus(activity);
            final bonusPercent = ((bonus - 1.0) * 100).round();
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: bonusPercent > 0 ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: bonusPercent > 0 ? Colors.green.withOpacity(0.3) : Colors.grey.withOpacity(0.3),
                ),
              ),
              child: Text(
                '${activity.replaceAll('_', ' ')}: +$bonusPercent%',
                style: TextStyle(
                  fontSize: 9,
                  color: bonusPercent > 0 ? Colors.green : Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _getLoyaltyColor(double loyalty) {
    if (loyalty >= 80) return Colors.green;
    if (loyalty >= 60) return Colors.blue;
    if (loyalty >= 40) return Colors.orange;
    return Colors.red;
  }

  Color _getRankColor(CrewMemberRank rank) {
    switch (rank) {
      case CrewMemberRank.recruit:
        return Colors.grey;
      case CrewMemberRank.soldier:
        return Colors.blue;
      case CrewMemberRank.lieutenant:
        return Colors.purple;
      case CrewMemberRank.underboss:
        return Colors.red;
    }
  }

  void _hireMember(CrewMemberRank rank, WidgetRef ref) {
    final gameController = ref.read(gameControllerProvider.notifier);
    
    // Play hiring sound
    AudioService().playSoundEffect(SoundEffect.buy);
    
    gameController.hireCrew(rank);
    
    // Show success message  
    // Note: Would need ScaffoldMessenger context
  }

  void _fireMember(CrewMember member, WidgetRef ref) {
    final gameController = ref.read(gameControllerProvider.notifier);
    
    gameController.fireCrew(member.id);
    
    // Note: Would need ScaffoldMessenger context for message
  }
}
