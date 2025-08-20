import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers.dart';

class BriberyCorruptionWidget extends ConsumerWidget {
  const BriberyCorruptionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameControllerProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '💰 Bribery & Corruption',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Current Heat: ${gameState.heat}% | Cash: \$${gameState.cash}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: gameState.heat > 50 ? Colors.red : Colors.green,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          
          // Law Enforcement Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🚔 Law Enforcement',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  _buildLawEnforcementActions(ref, gameState),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Government Officials Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🏛️ Government Officials',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  _buildGovernmentActions(ref, gameState),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Special Operations Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🕴️ Special Operations',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  _buildSpecialOperations(ref, gameState),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLawEnforcementActions(WidgetRef ref, gameState) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        ElevatedButton.icon(
          onPressed: gameState.cash >= 5000 ? () {
            final controller = ref.read(gameControllerProvider.notifier);
            controller.bribeOfficial('Police Officer Martinez', 5000);
          } : null,
          icon: const Icon(Icons.local_police),
          label: const Text('Bribe Police (\$5K)'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        ),
        ElevatedButton.icon(
          onPressed: gameState.cash >= 15000 ? () {
            final controller = ref.read(gameControllerProvider.notifier);
            controller.bribeOfficial('Detective Sarah Chen', 15000);
          } : null,
          icon: const Icon(Icons.person_search),
          label: const Text('Bribe Detective (\$15K)'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
        ),
        ElevatedButton.icon(
          onPressed: gameState.cash >= 25000 ? () {
            final controller = ref.read(gameControllerProvider.notifier);
            controller.bribeOfficial('Captain Robert Hayes', 25000);
          } : null,
          icon: const Icon(Icons.security),
          label: const Text('Bribe Captain (\$25K)'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
        ),
      ],
    );
  }
  
  Widget _buildGovernmentActions(WidgetRef ref, gameState) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        ElevatedButton.icon(
          onPressed: gameState.cash >= 20000 ? () {
            final controller = ref.read(gameControllerProvider.notifier);
            controller.bribeOfficial('City Councilman Johnson', 20000);
          } : null,
          icon: const Icon(Icons.account_balance),
          label: const Text('Bribe Councilman (\$20K)'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        ),
        ElevatedButton.icon(
          onPressed: gameState.cash >= 50000 ? () {
            final controller = ref.read(gameControllerProvider.notifier);
            controller.bribeOfficial('District Attorney Williams', 50000);
          } : null,
          icon: const Icon(Icons.gavel),
          label: const Text('Bribe DA (\$50K)'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
        ),
        ElevatedButton.icon(
          onPressed: gameState.cash >= 100000 ? () {
            final controller = ref.read(gameControllerProvider.notifier);
            controller.bribeOfficial('Judge Patricia Moore', 100000);
          } : null,
          icon: const Icon(Icons.balance),
          label: const Text('Bribe Judge (\$100K)'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        ),
      ],
    );
  }
  
  Widget _buildSpecialOperations(WidgetRef ref, gameState) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        ElevatedButton.icon(
          onPressed: gameState.cash >= 75000 ? () {
            final controller = ref.read(gameControllerProvider.notifier);
            controller.bribeOfficial('FBI Agent Thompson', 75000);
          } : null,
          icon: const Icon(Icons.shield),
          label: const Text('Bribe FBI Agent (\$75K)'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
        ),
        ElevatedButton.icon(
          onPressed: gameState.cash >= 30000 ? () {
            final controller = ref.read(gameControllerProvider.notifier);
            controller.bribeOfficial('Port Authority Chief', 30000);
          } : null,
          icon: const Icon(Icons.directions_boat),
          label: const Text('Bribe Port Authority (\$30K)'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
        ),
        ElevatedButton.icon(
          onPressed: gameState.cash >= 40000 ? () {
            final controller = ref.read(gameControllerProvider.notifier);
            controller.bribeOfficial('Customs Officer Rodriguez', 40000);
          } : null,
          icon: const Icon(Icons.flight_takeoff),
          label: const Text('Bribe Customs (\$40K)'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
        ),
      ],
    );
  }
}
