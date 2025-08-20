import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers.dart';
import '../../logic/enforcement.dart';
import '../../util/formatters.dart';

class CourtModals {
  static void showArrestModal(BuildContext context, WidgetRef ref) {
    final case_ = ref.read(enforcementCaseProvider);
    if (case_ == null) return;
    
    final gameState = ref.read(gameControllerProvider);
    final lawyerLevel = gameState.upgrades['lawyer'] ?? 0;
    final bailAmount = EnforcementService.calculateBailAmount(case_, lawyerLevel);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.local_police, color: Colors.red),
            SizedBox(width: 8),
            Text('ARRESTED!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('You have been arrested and are awaiting a court hearing.'),
            const SizedBox(height: 16),
            Text('Items found: ${case_.stashAtArrest}'),
            Text('Heat level: ${case_.heatAtArrest}'),
            const SizedBox(height: 16),
            Text('Bail amount: \$${Formatters.money(bailAmount)}'),
            if (lawyerLevel > 0) ...[
              const SizedBox(height: 8),
              Text(
                'Your lawyer reduced bail by ${lawyerLevel * 15}%',
                style: const TextStyle(
                  color: Colors.green,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (gameState.cash >= bailAmount)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(gameControllerProvider.notifier).postBail(bailAmount);
              },
              child: Text('Post Bail (\$${Formatters.money(bailAmount)})'),
            ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showCourtModal(context, ref);
            },
            child: const Text('Go to Court'),
          ),
        ],
      ),
    );
  }

  static void _showCourtModal(BuildContext context, WidgetRef ref) {
    final case_ = ref.read(enforcementCaseProvider);
    if (case_ == null) return;
    
    final gameState = ref.read(gameControllerProvider);
    final lawyerLevel = gameState.upgrades['lawyer'] ?? 0;
    final convictionProb = EnforcementService.calculateConvictionProbability(
      case_, 
      gameState.rapSheet, 
      lawyerLevel
    );
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.gavel),
            SizedBox(width: 8),
            Text('Court Hearing'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your case is being heard by the judge.'),
            const SizedBox(height: 16),
            Text('Charge: ${EnforcementService.getChargeType(case_)}'),
            Text('Evidence: ${case_.stashAtArrest} items, heat level ${case_.heatAtArrest}'),
            Text('Prior convictions: ${gameState.rapSheet.length}'),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Conviction chance: '),
                Text(
                  '${(convictionProb * 100).toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: convictionProb > 0.5 ? Colors.red : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (lawyerLevel > 0) ...[
              const SizedBox(height: 8),
              Text(
                'Your lawyer reduced conviction chance by ${lawyerLevel * 15}%',
                style: const TextStyle(
                  color: Colors.green,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(gameControllerProvider.notifier).goToCourt();
            },
            child: const Text('Await Verdict'),
          ),
        ],
      ),
    );
  }

  static void showSentenceModal(BuildContext context, String facilityType, int days) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.lock, color: Colors.red),
            const SizedBox(width: 8),
            Text('Sentenced to $facilityType'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('You have been sentenced to $days days in $facilityType.'),
            const SizedBox(height: 16),
            const Text('Time will pass automatically and some of your stash may be confiscated.'),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: 0,
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(height: 8),
            Text('Day 1 of $days'),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Serve Time'),
          ),
        ],
      ),
    );
  }
}
