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
          // Header row with exact fixed widths
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              border: Border(
                bottom: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            child: Row(
              children: [
                Container(width: 80, alignment: Alignment.centerLeft, child: const Text('Item', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                Container(width: 60, alignment: Alignment.centerRight, child: const Text('Price', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                Container(width: 50, alignment: Alignment.centerRight, child: const Text('Change', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                Container(width: 30, alignment: Alignment.center, child: const Text('📊', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                const Expanded(child: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11), textAlign: TextAlign.center)),
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
                
                return _UltraCleanMarketRow(
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

class _UltraCleanMarketRow extends ConsumerWidget {
  final String good;
  final int price;
  final double percentChange;
  final List<double> history;

  const _UltraCleanMarketRow({
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
        ),
      ),
      child: Row(
        children: [
          // Item column (80px) - FIXED WIDTH
          Container(
            width: 80,
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_getDrugEmoji(good), style: const TextStyle(fontSize: 8)),
                    const SizedBox(width: 2),
                    Flexible(
                      child: Text(
                        good,
                        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (owned > 0)
                  Text(
                    'Own: $owned',
                    style: const TextStyle(color: Colors.green, fontSize: 7),
                  ),
              ],
            ),
          ),
          
          // Price column (60px) - FIXED WIDTH
          Container(
            width: 60,
            alignment: Alignment.centerRight,
            child: Text(
              '\$${Formatters.money(price)}',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: percentChange >= 0 ? Colors.green : Colors.red,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          // Change column (50px) - FIXED WIDTH
          Container(
            width: 50,
            alignment: Alignment.centerRight,
            child: Text(
              '${percentChange >= 0 ? '+' : ''}${percentChange.toStringAsFixed(1)}%',
              style: TextStyle(
                color: percentChange >= 0 ? Colors.green : Colors.red,
                fontSize: 8,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          // Chart column (30px) - FIXED WIDTH
          Container(
            width: 30,
            height: 16,
            alignment: Alignment.center,
            child: _buildMiniChart(history),
          ),
          
          // Actions column - REMAINING SPACE WITH CONSTRAINTS
          Expanded(
            child: Container(
              constraints: const BoxConstraints(minWidth: 100, maxWidth: 200),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Buy 1
                  _buildActionButton(
                    icon: Icons.add,
                    color: Colors.green,
                    size: 18,
                    enabled: ref.read(gameControllerProvider.notifier).canBuy(good, 1),
                    onTap: () => _quickBuy(context, ref, good, price),
                  ),
                  // Buy multiple
                  _buildActionButton(
                    icon: Icons.shopping_cart,
                    color: Colors.blue,
                    size: 18,
                    enabled: ref.read(gameControllerProvider.notifier).canBuy(good, 1),
                    onTap: () => _showBuyDialog(context, ref, good, price),
                  ),
                  // Sell 1
                  _buildActionButton(
                    icon: Icons.remove,
                    color: Colors.red,
                    size: 18,
                    enabled: ref.read(gameControllerProvider.notifier).canSell(good, 1),
                    onTap: () => _quickSell(context, ref, good, price),
                  ),
                  // Sell multiple
                  _buildActionButton(
                    icon: Icons.sell,
                    color: Colors.orange,
                    size: 18,
                    enabled: ref.read(gameControllerProvider.notifier).canSell(good, 1),
                    onTap: () => _showSellDialog(context, ref, good, price),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required double size,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: enabled ? color.withOpacity(0.15) : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(3),
          border: Border.all(
            color: enabled ? color.withOpacity(0.5) : Colors.grey.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          size: size * 0.6,
          color: enabled ? color : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildMiniChart(List<double> data) {
    if (data.length < 2) {
      return const Text('—', style: TextStyle(fontSize: 6, color: Colors.grey));
    }

    return CustomPaint(
      painter: _MiniChartPainter(
        data: data,
        color: percentChange >= 0 ? Colors.green : Colors.red,
      ),
    );
  }

  // Quick actions
  void _quickBuy(BuildContext context, WidgetRef ref, String good, int price) {
    ref.read(gameControllerProvider.notifier).buy(good, 1);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Bought 1x $good for \$${Formatters.money(price)}')),
    );
  }

  void _quickSell(BuildContext context, WidgetRef ref, String good, int price) {
    ref.read(gameControllerProvider.notifier).sell(good, 1);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sold 1x $good for \$${Formatters.money(price)}')),
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
            title: Text('Buy $good'),
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
            title: Text('Sell $good'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Price per unit: \$${Formatters.money(price)}'),
                Text('Available: $maxQuantity units'),
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
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: maxQuantity > 0 ? () => setState(() => quantity = maxQuantity) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text('Max'),
                ),
                const SizedBox(height: 8),
                Text('Total: \$${Formatters.money(totalValue)}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: maxQuantity > 0 ? () {
                  Navigator.of(context).pop();
                  ref.read(gameControllerProvider.notifier).sell(good, quantity);
                } : null,
                child: const Text('Sell'),
              ),
            ],
          );
        },
      ),
    );
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
