import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models.dart';
import '../../providers.dart';
import '../../util/formatters.dart';

class GoalProgressPill extends ConsumerWidget {
  final GameState gameState;

  const GoalProgressPill({
    super.key,
    required this.gameState,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prices = ref.watch(currentPricesProvider);
    final netWorth = _calculateNetWorth(prices);
    final progress = netWorth / gameState.goalNetWorth;
    final theme = Theme.of(context);
    
    Color progressColor;
    if (progress >= 1.0) {
      progressColor = Colors.green;
    } else if (progress >= 0.7) {
      progressColor = Colors.orange;
    } else {
      progressColor = theme.colorScheme.primary;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: progressColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Net Worth',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (progress >= 1.0)
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 20,
                ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${Formatters.money(netWorth)}',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: progressColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '/ ${Formatters.money(gameState.goalNetWorth)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: theme.colorScheme.outline.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${(progress * 100).toStringAsFixed(1)}% of goal',
            style: theme.textTheme.bodySmall?.copyWith(
              color: progressColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  int _calculateNetWorth(Map<String, int> prices) {
    int stashValue = 0;
    
    for (final entry in gameState.stash.entries) {
      final price = prices[entry.key] ?? 0;
      stashValue += price * entry.value;
    }
    
    return gameState.cash + gameState.bank + stashValue;
  }
}
