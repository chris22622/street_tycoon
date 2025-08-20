import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers.dart';

class ConfirmEndDay extends ConsumerWidget {
  const ConfirmEndDay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameControllerProvider);
    
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.bedtime),
          SizedBox(width: 8),
          Text('End Day'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Are you ready to end the day?'),
          const SizedBox(height: 16),
          const Text('This will:'),
          const Text('• Process random events'),
          const Text('• Check for law enforcement'),
          const Text('• Reduce heat level'),
          const Text('• Update market prices'),
          const Text('• Apply bank interest'),
          const SizedBox(height: 16),
          if (gameState.heat > 50) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning, color: Colors.orange),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'High heat level! Risk of law enforcement.',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
          if (gameState.heat > 75) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red),
              ),
              child: const Row(
                children: [
                  Icon(Icons.dangerous, color: Colors.red),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Critical heat level! Very high arrest risk!',
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            ref.read(gameControllerProvider.notifier).endDay();
          },
          child: const Text('End Day'),
        ),
      ],
    );
  }
}
