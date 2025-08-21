import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers.dart';
import '../../data/constants.dart';
import '../../logic/price_engine.dart';
import '../../util/formatters.dart';

class MarketTable extends ConsumerWidget {
  const MarketTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prices = ref.watch(currentPricesProvider);
    
    if (prices.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.storefront, size: 20),
                const SizedBox(width: 6),
                Text(
                  'Market',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          // Header row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              border: Border(
                bottom: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            child: const Row(
              children: [
                SizedBox(width: 100, child: Text('Item', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                SizedBox(width: 70, child: Text('Price', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                SizedBox(width: 60, child: Text('Change', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                SizedBox(width: 40, child: Text('Chart', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                Expanded(child: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.center)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: GOODS.length,
              itemBuilder: (context, index) {
                final good = GOODS[index];
                final price = prices[good] ?? 0;
                final percentChange = PriceEngine.getPercentageChange(good, price);
                final history = PriceEngine.getPriceHistory(good);
                
                return _CleanMarketRow(
                  good: good,
                  price: price,
                  percentChange: percentChange,
                  history: history,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CleanMarketRow extends ConsumerWidget {
  final String good;
  final int price;
  final double percentChange;
  final List<double> history;

  const _CleanMarketRow({
    required this.good,
    required this.price,
    required this.percentChange,
    required this.history,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final gameState = ref.watch(gameControllerProvider);
    final owned = gameState.stash[good] ?? 0;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.dividerColor.withOpacity(0.3)),
        ),
      ),
      child: Row(
        children: [
          // Item column (100px)
          SizedBox(
            width: 100,
            child: Row(
              children: [
                // Drug emoji
                Container(
                  width: 18,
                  height: 18,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    color: _getDrugColor(good).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Center(
                    child: Text(
                      _getDrugEmoji(good),
                      style: const TextStyle(fontSize: 9),
                    ),
                  ),
                ),
                // Drug name
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        good,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (owned > 0)
                        Text(
                          'Own: $owned',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.green,
                            fontSize: 8,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Price column (70px)
          SizedBox(
            width: 70,
            child: Text(
              '\$${Formatters.money(price)}',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: percentChange >= 0 ? Colors.green : Colors.red,
                fontSize: 10,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          
          // Change column (60px)
          SizedBox(
            width: 60,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  percentChange >= 0 ? Icons.trending_up : Icons.trending_down,
                  size: 10,
                  color: percentChange >= 0 ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 2),
                Text(
                  '${percentChange >= 0 ? '+' : ''}${percentChange.toStringAsFixed(1)}%',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: percentChange >= 0 ? Colors.green : Colors.red,
                    fontSize: 8,
                  ),
                ),
              ],
            ),
          ),
          
          // Chart column (40px)
          SizedBox(
            width: 40,
            height: 18,
            child: _buildMiniChart(history),
          ),
          
          // Actions column (expanded)
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Buy 1
                _buildCleanButton(
                  icon: Icons.add_circle_outline,
                  color: Colors.green,
                  enabled: ref.read(gameControllerProvider.notifier).canBuy(good, 1),
                  onTap: () => _showQuickBuyConfirmation(context, ref, good, price),
                ),
                // Buy multiple
                _buildCleanButton(
                  icon: Icons.shopping_cart_outlined,
                  color: Colors.blue,
                  enabled: ref.read(gameControllerProvider.notifier).canBuy(good, 1),
                  onTap: () => _showBuyDialog(context, ref, good, price),
                ),
                // Sell 1
                _buildCleanButton(
                  icon: Icons.remove_circle_outline,
                  color: Colors.red,
                  enabled: ref.read(gameControllerProvider.notifier).canSell(good, 1),
                  onTap: () => _showQuickSellConfirmation(context, ref, good, price),
                ),
                // Sell multiple
                _buildCleanButton(
                  icon: Icons.sell_outlined,
                  color: Colors.orange,
                  enabled: ref.read(gameControllerProvider.notifier).canSell(good, 1),
                  onTap: () => _showSellDialog(context, ref, good, price),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCleanButton({
    required IconData icon,
    required Color color,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: enabled ? color.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: enabled ? color.withOpacity(0.4) : Colors.grey.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          size: 12,
          color: enabled ? color : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildMiniChart(List<double> data) {
    if (data.length < 2) {
      return const Center(child: Text('—', style: TextStyle(fontSize: 8, color: Colors.grey)));
    }

    return CustomPaint(
      painter: _MiniChartPainter(
        data: data,
        color: percentChange >= 0 ? Colors.green : Colors.red,
      ),
    );
  }

  Color _getDrugColor(String drug) {
    switch (drug.toLowerCase()) {
      case 'weed': return Colors.green;
      case 'cocaine': return Colors.white;
      case 'heroin': return Colors.brown;
      case 'lsd': return Colors.purple;
      case 'speed': return Colors.yellow;
      case 'ecstasy': return Colors.pink;
      case 'pcp': return Colors.red;
      case 'mushrooms': return Colors.orange;
      default: return Colors.grey;
    }
  }

  String _getDrugEmoji(String drug) {
    switch (drug.toLowerCase()) {
      case 'weed': return '🌿';
      case 'cocaine': return '❄️';
      case 'heroin': return '💉';
      case 'lsd': return '🎨';
      case 'speed': return '⚡';
      case 'ecstasy': return '💊';
      case 'pcp': return '🧪';
      case 'mushrooms': return '🍄';
      default: return '📦';
    }
  }

  // Quick buy confirmation dialog
  void _showQuickBuyConfirmation(BuildContext context, WidgetRef ref, String good, int price) {
    final color = _getDrugColor(good);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text(_getDrugEmoji(good)),
            const SizedBox(width: 8),
            Text('Buy $good?', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          'Buy 1x $good for \$${Formatters.money(price)}?',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(gameControllerProvider.notifier).buy(good, 1);
            },
            style: ElevatedButton.styleFrom(backgroundColor: color),
            child: const Text('Buy'),
          ),
        ],
      ),
    );
  }

  // Buy dialog for multiple quantities
  void _showBuyDialog(BuildContext context, WidgetRef ref, String good, int price) {
    int quantity = 1;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          final gameState = ref.read(gameControllerProvider);
          final maxQuantity = (gameState.cash / price).floor().clamp(1, gameState.availableCapacity);
          final totalCost = price * quantity;
          
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.shopping_cart, color: Colors.blue),
                const SizedBox(width: 8),
                Text('Buy $good'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Price per unit: \$${Formatters.money(price)}'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Quantity:'),
                    Row(
                      children: [
                        IconButton(
                          onPressed: quantity > 1 ? () => setState(() => quantity--) : null,
                          icon: const Icon(Icons.remove),
                        ),
                        Text('$quantity', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        IconButton(
                          onPressed: quantity < maxQuantity ? () => setState(() => quantity++) : null,
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                ),
                Text('Total: \$${Formatters.money(totalCost)}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ref.read(gameControllerProvider.notifier).buy(good, quantity);
                },
                child: const Text('Buy'),
              ),
            ],
          );
        },
      ),
    );
  }

  // Quick sell confirmation dialog
  void _showQuickSellConfirmation(BuildContext context, WidgetRef ref, String good, int price) {
    final color = _getDrugColor(good);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text(_getDrugEmoji(good)),
            const SizedBox(width: 8),
            Text('Sell $good?', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          'Sell 1x $good for \$${Formatters.money(price)}?',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(gameControllerProvider.notifier).sell(good, 1);
            },
            style: ElevatedButton.styleFrom(backgroundColor: color),
            child: const Text('Sell'),
          ),
        ],
      ),
    );
  }

  // Sell dialog for multiple quantities
  void _showSellDialog(BuildContext context, WidgetRef ref, String good, int price) {
    int quantity = 1;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          final gameState = ref.read(gameControllerProvider);
          final maxQuantity = gameState.stash[good] ?? 0;
          final totalValue = price * quantity;
          
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.sell, color: Colors.red),
                const SizedBox(width: 8),
                Text('Sell $good'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Price per unit: \$${Formatters.money(price)}'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Quantity:'),
                    Row(
                      children: [
                        IconButton(
                          onPressed: quantity > 1 ? () => setState(() => quantity--) : null,
                          icon: const Icon(Icons.remove),
                        ),
                        Text('$quantity', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        IconButton(
                          onPressed: quantity < maxQuantity ? () => setState(() => quantity++) : null,
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                ),
                Text('Total: \$${Formatters.money(totalValue)}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ref.read(gameControllerProvider.notifier).sell(good, quantity);
                },
                child: const Text('Sell'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MiniChartPainter extends CustomPainter {
  final List<double> data;
  final Color color;

  _MiniChartPainter({required this.data, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    final minVal = data.reduce((a, b) => a < b ? a : b);
    final maxVal = data.reduce((a, b) => a > b ? a : b);
    final range = maxVal - minVal;

    if (range == 0) return;

    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final y = size.height - ((data[i] - minVal) / range) * size.height;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
