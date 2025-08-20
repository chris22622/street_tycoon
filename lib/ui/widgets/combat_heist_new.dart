import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers.dart';

class CombatHeistWidget extends ConsumerWidget {
  const CombatHeistWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameControllerProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '⚔️ Combat & Heist Operations',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Heat Level: ${gameState.heat}% | Cash: \$${gameState.cash}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: gameState.heat > 75 ? Colors.red : Colors.green,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          
          // Heist Operations Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '💰 Heist Operations',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'High-risk, high-reward operations. Success rate varies.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  _buildHeistActions(ref, gameState),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Weapons Arsenal Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🔫 Weapons Arsenal',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Expand your arsenal for better operation success rates.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  _buildWeaponActions(ref, gameState),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Combat Training Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🥋 Combat Training',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Improve your crew\'s effectiveness in combat situations.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  _buildTrainingActions(context, ref, gameState),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHeistActions(WidgetRef ref, gameState) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        ElevatedButton.icon(
          onPressed: gameState.cash >= 10000 ? () {
            final controller = ref.read(gameControllerProvider.notifier);
            controller.startHeist('Bank Robbery', 10000);
          } : null,
          icon: const Icon(Icons.account_balance),
          label: const Text('Bank Heist (\$10K)'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        ),
        ElevatedButton.icon(
          onPressed: gameState.cash >= 25000 ? () {
            final controller = ref.read(gameControllerProvider.notifier);
            controller.startHeist('Armored Car', 25000);
          } : null,
          icon: const Icon(Icons.local_shipping),
          label: const Text('Armored Car (\$25K)'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
        ),
        ElevatedButton.icon(
          onPressed: gameState.cash >= 50000 ? () {
            final controller = ref.read(gameControllerProvider.notifier);
            controller.startHeist('Casino Vault', 50000);
          } : null,
          icon: const Icon(Icons.casino),
          label: const Text('Casino Vault (\$50K)'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
        ),
        ElevatedButton.icon(
          onPressed: gameState.cash >= 100000 ? () {
            final controller = ref.read(gameControllerProvider.notifier);
            controller.startHeist('Federal Reserve', 100000);
          } : null,
          icon: const Icon(Icons.account_balance_wallet),
          label: const Text('Federal Reserve (\$100K)'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
        ),
      ],
    );
  }
  
  Widget _buildWeaponActions(WidgetRef ref, gameState) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        ElevatedButton.icon(
          onPressed: gameState.cash >= 5000 ? () {
            final controller = ref.read(gameControllerProvider.notifier);
            controller.buyWeapon('Body Armor', 5000);
          } : null,
          icon: const Icon(Icons.shield),
          label: const Text('Body Armor (\$5K)'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
        ),
        ElevatedButton.icon(
          onPressed: gameState.cash >= 15000 ? () {
            final controller = ref.read(gameControllerProvider.notifier);
            controller.buyWeapon('Assault Rifle', 15000);
          } : null,
          icon: const Icon(Icons.sports_motorsports),
          label: const Text('Assault Rifle (\$15K)'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
        ),
        ElevatedButton.icon(
          onPressed: gameState.cash >= 30000 ? () {
            final controller = ref.read(gameControllerProvider.notifier);
            controller.buyWeapon('Explosives Kit', 30000);
          } : null,
          icon: const Icon(Icons.warning),
          label: const Text('Explosives (\$30K)'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
        ),
        ElevatedButton.icon(
          onPressed: gameState.cash >= 75000 ? () {
            final controller = ref.read(gameControllerProvider.notifier);
            controller.buyWeapon('Military Grade Equipment', 75000);
          } : null,
          icon: const Icon(Icons.military_tech),
          label: const Text('Military Grade (\$75K)'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        ),
      ],
    );
  }
  
  Widget _buildTrainingActions(BuildContext context, WidgetRef ref, gameState) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        ElevatedButton.icon(
          onPressed: gameState.cash >= 8000 ? () {
            final controller = ref.read(gameControllerProvider.notifier);
            controller.spendCash(8000);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('🥋 Combat training completed! Crew effectiveness improved!'),
                backgroundColor: Colors.blue,
              ),
            );
          } : null,
          icon: const Icon(Icons.fitness_center),
          label: const Text('Combat Training (\$8K)'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        ),
        ElevatedButton.icon(
          onPressed: gameState.cash >= 12000 ? () {
            final controller = ref.read(gameControllerProvider.notifier);
            controller.spendCash(12000);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('🎯 Tactical training completed! Mission success rate improved!'),
                backgroundColor: Colors.indigo,
              ),
            );
          } : null,
          icon: const Icon(Icons.my_location),
          label: const Text('Tactical Training (\$12K)'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
        ),
        ElevatedButton.icon(
          onPressed: gameState.cash >= 20000 ? () {
            final controller = ref.read(gameControllerProvider.notifier);
            controller.spendCash(20000);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('🧠 Advanced tactics learned! Elite operations unlocked!'),
                backgroundColor: Colors.teal,
              ),
            );
          } : null,
          icon: const Icon(Icons.school),
          label: const Text('Elite Training (\$20K)'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
        ),
      ],
    );
  }
}
