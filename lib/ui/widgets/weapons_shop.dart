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
    
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.security, color: Colors.red, size: 20),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Black Market Arsenal',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '⚠️ HIGH RISK',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Weapons increase federal heat and investigation risk',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.red.shade700,
                        fontStyle: FontStyle.italic,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Weapons Grid
                    LayoutBuilder(
                      builder: (context, gridConstraints) {
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: gridConstraints.maxWidth > 400 ? 3 : 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: availableWeapons.length,
                          itemBuilder: (context, index) {
                            final weapon = availableWeapons[index];
                            final owned = gameState.weapons[weapon.id] ?? 0;
                            
                            return _buildWeaponCard(context, ref, weapon, owned, gameState.cash);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: categoryColor.withOpacity(0.3),
            width: 1,
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
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      weapon.icon,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const Spacer(),
                  if (owned > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'x$owned',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 4),
              
              // Name and Category
              Text(
                weapon.name,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  weapon.category,
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: categoryColor,
                  ),
                ),
              ),
              
              const SizedBox(height: 4),
              
              // Stats (simplified)
              _buildStatBar(context, 'DMG', weapon.damage, 100, Colors.red),
              const SizedBox(height: 2),
              _buildStatBar(context, 'REL', weapon.reliability, 100, Colors.blue),
              const SizedBox(height: 2),
              _buildStatBar(context, 'CON', weapon.concealability, 100, Colors.green),
              
              const Spacer(),
              
              // Price and Buy Button
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '\$${Formatters.money(weapon.price)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: canAfford ? Colors.green : Colors.red,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  SizedBox(
                    width: 40,
                    height: 24,
                    child: ElevatedButton(
                      onPressed: canAfford ? () => _buyWeapon(ref, weapon) : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: categoryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        'BUY',
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
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
          width: 18,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 2),
        Expanded(
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 2),
        SizedBox(
          width: 16,
          child: Text(
            value.toString(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 8,
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
