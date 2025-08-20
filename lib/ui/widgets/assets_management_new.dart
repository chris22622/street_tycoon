import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers.dart';

class AssetsManagementWidget extends ConsumerWidget {
  const AssetsManagementWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameControllerProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🏢 Assets Management',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Current Location: ${gameState.area} | Cash: \$${gameState.cash}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.green,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          
          // Vehicles Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🚗 Vehicle Fleet',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  _buildVehicleActions(ref, gameState),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Properties Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🏠 Real Estate Portfolio',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  _buildPropertyActions(ref, gameState),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Luxury Items Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '💎 Luxury Assets',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  _buildLuxuryActions(ref, gameState),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildVehicleActions(WidgetRef ref, gameState) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        ElevatedButton.icon(
          onPressed: gameState.cash >= 25000 ? () {
            final controller = ref.read(gameControllerProvider.notifier);
            controller.purchaseVehicle('Armored Sedan', 25000);
          } : null,
          icon: const Icon(Icons.directions_car),
          label: const Text('Buy Armored Sedan (\$25K)'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        ),
        ElevatedButton.icon(
          onPressed: gameState.cash >= 50000 ? () {
            final controller = ref.read(gameControllerProvider.notifier);
            controller.purchaseVehicle('Speed Boat', 50000);
          } : null,
          icon: const Icon(Icons.directions_boat),
          label: const Text('Buy Speed Boat (\$50K)'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
        ),
        ElevatedButton.icon(
          onPressed: gameState.cash >= 100000 ? () {
            final controller = ref.read(gameControllerProvider.notifier);
            controller.purchaseVehicle('Private Jet', 100000);
          } : null,
          icon: const Icon(Icons.flight),
          label: const Text('Buy Private Jet (\$100K)'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
        ),
        ElevatedButton.icon(
          onPressed: gameState.cash >= 5000 ? () {
            final controller = ref.read(gameControllerProvider.notifier);
            final vehicles = ['BMW M5', 'Audi RS6', 'Mercedes AMG', 'Porsche 911'];
            final vehicle = vehicles[DateTime.now().millisecond % vehicles.length];
            controller.stealVehicle(vehicle, 5000);
          } : null,
          icon: const Icon(Icons.local_fire_department),
          label: const Text('Steal Vehicle (\$5K)'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        ),
      ],
    );
  }
  
  Widget _buildPropertyActions(WidgetRef ref, gameState) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        ElevatedButton.icon(
          onPressed: gameState.cash >= 75000 ? () {
            final controller = ref.read(gameControllerProvider.notifier);
            controller.purchaseProperty('Safe House', 75000);
          } : null,
          icon: const Icon(Icons.home),
          label: const Text('Buy Safe House (\$75K)'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
        ),
        ElevatedButton.icon(
          onPressed: gameState.cash >= 150000 ? () {
            final controller = ref.read(gameControllerProvider.notifier);
            controller.purchaseProperty('Warehouse', 150000);
          } : null,
          icon: const Icon(Icons.warehouse),
          label: const Text('Buy Warehouse (\$150K)'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
        ),
        ElevatedButton.icon(
          onPressed: gameState.cash >= 300000 ? () {
            final controller = ref.read(gameControllerProvider.notifier);
            controller.purchaseProperty('Nightclub', 300000);
          } : null,
          icon: const Icon(Icons.nightlife),
          label: const Text('Buy Nightclub (\$300K)'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
        ),
        ElevatedButton.icon(
          onPressed: gameState.cash >= 500000 ? () {
            final controller = ref.read(gameControllerProvider.notifier);
            controller.purchaseProperty('Casino', 500000);
          } : null,
          icon: const Icon(Icons.casino),
          label: const Text('Buy Casino (\$500K)'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
        ),
      ],
    );
  }
  
  Widget _buildLuxuryActions(WidgetRef ref, gameState) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        ElevatedButton.icon(
          onPressed: gameState.cash >= 10000 ? () {
            final controller = ref.read(gameControllerProvider.notifier);
            controller.purchaseLuxury('Gold Watch', 10000);
          } : null,
          icon: const Icon(Icons.watch),
          label: const Text('Buy Gold Watch (\$10K)'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
        ),
        ElevatedButton.icon(
          onPressed: gameState.cash >= 25000 ? () {
            final controller = ref.read(gameControllerProvider.notifier);
            controller.purchaseLuxury('Diamond Ring', 25000);
          } : null,
          icon: const Icon(Icons.ring_volume),
          label: const Text('Buy Diamond Ring (\$25K)'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
        ),
        ElevatedButton.icon(
          onPressed: gameState.cash >= 50000 ? () {
            final controller = ref.read(gameControllerProvider.notifier);
            controller.purchaseLuxury('Art Collection', 50000);
          } : null,
          icon: const Icon(Icons.palette),
          label: const Text('Buy Art Collection (\$50K)'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
        ),
      ],
    );
  }
}
