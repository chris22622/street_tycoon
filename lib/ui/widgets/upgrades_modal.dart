import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers.dart';
import '../../logic/upgrade_service.dart';
import '../../util/formatters.dart';

class UpgradesModal extends ConsumerWidget {
  const UpgradesModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameControllerProvider);
    
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.upgrade),
                  const SizedBox(width: 8),
                  Text(
                    'Upgrades',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            
            // Upgrades list
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _UpgradeCard(
                      title: 'Duffel Bag',
                      description: UpgradeService.getDuffelDescription(gameState.upgrades['duffel'] ?? 0),
                      currentLevel: gameState.upgrades['duffel'] ?? 0,
                      cost: UpgradeService.getDuffelCost(gameState.upgrades['duffel'] ?? 0),
                      canAfford: ref.read(gameControllerProvider.notifier).canBuyUpgrade('duffel'),
                      onBuy: () => ref.read(gameControllerProvider.notifier).buyUpgrade('duffel'),
                    ),
                    const SizedBox(height: 16),
                    _UpgradeCard(
                      title: 'Safehouse',
                      description: UpgradeService.getSafehouseDescription(gameState.upgrades['safehouse'] ?? 0),
                      currentLevel: gameState.upgrades['safehouse'] ?? 0,
                      cost: UpgradeService.getSafehouseCost(gameState.upgrades['safehouse'] ?? 0),
                      canAfford: ref.read(gameControllerProvider.notifier).canBuyUpgrade('safehouse'),
                      onBuy: () => ref.read(gameControllerProvider.notifier).buyUpgrade('safehouse'),
                    ),
                    const SizedBox(height: 16),
                    _UpgradeCard(
                      title: 'Lawyer Retainer',
                      description: UpgradeService.getLawyerDescription(gameState.upgrades['lawyer'] ?? 0),
                      currentLevel: gameState.upgrades['lawyer'] ?? 0,
                      cost: UpgradeService.getLawyerCost(gameState.upgrades['lawyer'] ?? 0),
                      canAfford: ref.read(gameControllerProvider.notifier).canBuyUpgrade('lawyer'),
                      onBuy: () => ref.read(gameControllerProvider.notifier).buyUpgrade('lawyer'),
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
}

class _UpgradeCard extends StatelessWidget {
  final String title;
  final String description;
  final int currentLevel;
  final int cost;
  final bool canAfford;
  final VoidCallback onBuy;

  const _UpgradeCard({
    required this.title,
    required this.description,
    required this.currentLevel,
    required this.cost,
    required this.canAfford,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMaxLevel = UpgradeService.isMaxLevel(currentLevel);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Level $currentLevel',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isMaxLevel)
                  FilledButton(
                    onPressed: canAfford ? onBuy : null,
                    child: Text('Buy (\$${Formatters.money(cost)})'),
                  )
                else
                  const Chip(
                    label: Text('MAX'),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: theme.textTheme.bodyMedium,
            ),
            if (!isMaxLevel && !canAfford) ...[
              const SizedBox(height: 8),
              Text(
                'Insufficient funds',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
