import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/prestige_models.dart';
import '../../providers.dart';
import '../../services/audio_service.dart';

class PrestigeSystemWidget extends ConsumerWidget {
  const PrestigeSystemWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameControllerProvider);
    final prestige = gameState.prestigeSystem ?? PrestigeSystem.initial();
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          // Prestige overview card
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        prestige.currentLevel.icon,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${prestige.currentLevel.name} Status',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${prestige.reputation} Reputation',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.purple,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getLevelColor(prestige.currentLevel),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${(prestige.currentLevel.bonusMultiplier * 100 - 100).round()}% Bonus',
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
                  
                  // Progress to next level
                  if (prestige.nextLevel != prestige.currentLevel) ...[
                    Row(
                      children: [
                        Text(
                          'Progress to ${prestige.nextLevel.name}:',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                        ),
                        const Spacer(),
                        Text(
                          '${prestige.reputationToNextLevel} needed',
                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: prestige.progressToNextLevel,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation(_getLevelColor(prestige.nextLevel)),
                    ),
                  ] else ...[
                    const Row(
                      children: [
                        Icon(Icons.stars, color: Colors.amber, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'Maximum Prestige Level Reached!',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Current level perks
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Perks:',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ...prestige.currentLevel.perks.map((perk) => 
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, size: 12, color: Colors.green),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              perk,
                              style: const TextStyle(fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Available prestige bonuses
          if (prestige.availableBonuses.isNotEmpty)
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available Bonuses:',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ...prestige.availableBonuses.map((bonus) => 
                      _buildBonusCard(bonus, prestige, ref)),
                  ],
                ),
              ),
            ),

          // Unlocked bonuses
          if (prestige.unlockedBonuses.isNotEmpty)
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Unlocked Bonuses:',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ...prestige.unlockedBonuses.map((bonusId) {
                      final bonus = PrestigeBonusTemplates.all.firstWhere(
                        (b) => b.id == bonusId,
                        orElse: () => PrestigeBonusTemplates.all.first,
                      );
                      return _buildUnlockedBonusCard(bonus);
                    }),
                  ],
                ),
              ),
            ),

          // Achievements
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Achievements:',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (prestige.achievements.isEmpty)
                    const Text(
                      'No achievements yet. Complete contracts and expand your empire!',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    )
                  else
                    ...prestige.achievements.entries.map((entry) => 
                      _buildAchievementCard(entry.key, entry.value)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBonusCard(PrestigeBonus bonus, PrestigeSystem prestige, WidgetRef ref) {
    final canAfford = prestige.reputation >= bonus.cost;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: _getLevelColor(bonus.requiredLevel).withOpacity(0.3)),
        borderRadius: BorderRadius.circular(6),
        color: canAfford ? null : Colors.grey[100],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bonus.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: canAfford ? null : Colors.grey,
                  ),
                ),
                Text(
                  bonus.description,
                  style: TextStyle(
                    fontSize: 10,
                    color: canAfford ? Colors.grey[600] : Colors.grey,
                  ),
                ),
                Text(
                  'Cost: ${bonus.cost} reputation',
                  style: TextStyle(
                    fontSize: 9,
                    color: canAfford ? Colors.purple : Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 24,
            child: ElevatedButton(
              onPressed: canAfford ? () => _unlockBonus(bonus, ref) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _getLevelColor(bonus.requiredLevel),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: const Text(
                'Unlock',
                style: TextStyle(fontSize: 9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnlockedBonusCard(PrestigeBonus bonus) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: _getLevelColor(bonus.requiredLevel).withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: _getLevelColor(bonus.requiredLevel).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.stars,
            size: 14,
            color: _getLevelColor(bonus.requiredLevel),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bonus.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
                Text(
                  bonus.description,
                  style: const TextStyle(fontSize: 9, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(String achievement, int count) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.emoji_events, size: 14, color: Colors.amber),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              achievement,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
            ),
          ),
          if (count > 1)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'x$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getLevelColor(PrestigeLevel level) {
    switch (level) {
      case PrestigeLevel.amateur:
        return Colors.brown;
      case PrestigeLevel.professional:
        return Colors.blue;
      case PrestigeLevel.kingpin:
        return Colors.purple;
      case PrestigeLevel.legend:
        return Colors.amber;
    }
  }

  void _unlockBonus(PrestigeBonus bonus, WidgetRef ref) {
    final gameController = ref.read(gameControllerProvider.notifier);
    
    // Play unlock sound
    AudioService().playSoundEffect(SoundEffect.buy);
    
    gameController.unlockPrestigeBonus(bonus.id);
  }
}
