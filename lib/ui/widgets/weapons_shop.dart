import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../logic/federal_service.dart';
import '../../providers.dart';
import '../../util/formatters.dart';

class WeaponsShop extends ConsumerWidget {
  const WeaponsShop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameControllerProvider);
    final availableWeapons = FederalService.getAvailableWeapons();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.security, color: Colors.red),
                const SizedBox(width: 8),
                Text(
                  'Black Market Arsenal',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '⚠️ HIGH RISK',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Weapons significantly increase federal heat and investigation risk',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.red.shade700,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),
            
            // Weapons Grid
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemCount: availableWeapons.length,
                itemBuilder: (context, index) {
                  final weapon = availableWeapons[index];
                  final owned = gameState.weapons[weapon.id] ?? 0;
                  
                  return _buildWeaponCard(context, ref, weapon, owned, gameState.cash);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeaponCard(
    BuildContext context,
    WidgetRef ref,
    Weapon weapon,
    int owned,
    int playerCash,
  ) {
    final canAfford = playerCash >= weapon.price;
    final categoryColor = _getCategoryColor(weapon.category);
    
    return Card(
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: categoryColor.withOpacity(0.3),
            width: 2,
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              categoryColor.withOpacity(0.1),
              categoryColor.withOpacity(0.05),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      weapon.icon,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  const Spacer(),
                  if (owned > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'x$owned',
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
              
              // Name and Category
              Text(
                weapon.name,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  weapon.category,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: categoryColor,
                  ),
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Description
              Text(
                weapon.description,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 8),
              
              // Stats
              _buildStatBar(context, 'DMG', weapon.damage, 100, Colors.red),
              const SizedBox(height: 4),
              _buildStatBar(context, 'REL', weapon.reliability, 100, Colors.blue),
              const SizedBox(height: 4),
              _buildStatBar(context, 'CON', weapon.concealability, 100, Colors.green),
              
              const Spacer(),
              
              // Price and Buy Button
              Row(
                children: [
                  Text(
                    '\$${Formatters.money(weapon.price)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: canAfford ? Colors.green : Colors.red,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 60,
                    height: 32,
                    child: ElevatedButton(
                      onPressed: canAfford ? () => _buyWeapon(ref, weapon) : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: categoryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        'BUY',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatBar(BuildContext context, String label, int value, int max, Color color) {
    final percentage = value / max;
    
    return Row(
      children: [
        SizedBox(
          width: 24,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Container(
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        SizedBox(
          width: 24,
          child: Text(
            value.toString(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Pistol':
        return Colors.blue;
      case 'SMG':
        return Colors.purple;
      case 'Rifle':
        return Colors.orange;
      case 'Shotgun':
        return Colors.brown;
      case 'Heavy':
        return Colors.red;
      case 'Protection':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _buyWeapon(WidgetRef ref, Weapon weapon) {
    // Show confirmation dialog for weapon purchase
    showDialog(
      context: ref.context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text(weapon.icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            Expanded(child: Text('Purchase ${weapon.name}?')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price: \$${Formatters.money(weapon.price)}'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'WARNING',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Purchasing weapons will:',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '• Increase federal investigation risk',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '• Attract ATF attention',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '• Add weapons trafficking charges if caught',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
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
              _confirmWeaponPurchase(ref, weapon);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Buy Anyway'),
          ),
        ],
      ),
    );
  }

  void _confirmWeaponPurchase(WidgetRef ref, Weapon weapon) {
    final controller = ref.read(gameControllerProvider.notifier);
    controller.purchaseWeapon(weapon.id, weapon.price);
    
    ScaffoldMessenger.of(ref.context).showSnackBar(
      SnackBar(
        content: Text('${weapon.name} purchased! Federal heat increased.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
