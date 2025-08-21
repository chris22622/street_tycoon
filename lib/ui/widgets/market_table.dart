import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers.dart';
import '../../data/constants.dart';
import '../../logic/price_engine.dart';
import '../../util/formatters.dart';
import '../../theme/app_theme.dart';

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
              color: AppTheme.withOpacity(Theme.of(context).primaryColor, 0.1),
              border: Border(
                bottom: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            child: const Row(
              children: [
                SizedBox(width: 100, child: Text('Item', style: TextStyle(fontWeight: FontWeight.bold))),
                SizedBox(width: 70, child: Text('Price', style: TextStyle(fontWeight: FontWeight.bold))),
                SizedBox(width: 50, child: Text('Change', style: TextStyle(fontWeight: FontWeight.bold))),
                SizedBox(width: 40, child: Text('Chart', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(child: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
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
                
                return _MarketRowClean(
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

class _MarketRowClean extends ConsumerWidget {
  final String good;
  final int price;
  final double percentChange;
  final List<double> history;

  const _MarketRowClean({
    super.key,
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    color: _getDrugColor(good).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      _getDrugEmoji(good),
                      style: const TextStyle(fontSize: 10),
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
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (owned > 0)
                        Text(
                          '$owned',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.green,
                            fontSize: 9,
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
                fontSize: 11,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          
          // Change column (50px)
          SizedBox(
            width: 50,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  percentChange >= 0 ? Icons.trending_up : Icons.trending_down,
                  size: 12,
                  color: percentChange >= 0 ? Colors.green : Colors.red,
                ),
                Text(
                  '${percentChange >= 0 ? '+' : ''}${percentChange.toStringAsFixed(1)}%',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: percentChange >= 0 ? Colors.green : Colors.red,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
          
          // Chart column (40px)
          SizedBox(
            width: 40,
            height: 20,
            child: _buildSparkline(history, theme),
          ),
          
          // Actions column (expanded)
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Buy buttons
                _buildActionButton(
                  icon: Icons.add,
                  color: Colors.green,
                  onTap: ref.read(gameControllerProvider.notifier).canBuy(good, 1)
                      ? () => _showQuickBuyConfirmation(context, ref, good, price)
                      : null,
                ),
                _buildActionButton(
                  text: 'B',
                  color: Colors.blue,
                  onTap: ref.read(gameControllerProvider.notifier).canBuy(good, 1)
                      ? () => _showBuyDialog(context, ref, good, price)
                      : null,
                ),
                // Sell buttons
                _buildActionButton(
                  icon: Icons.remove,
                  color: Colors.red,
                  onTap: ref.read(gameControllerProvider.notifier).canSell(good, 1)
                      ? () => _showQuickSellConfirmation(context, ref, good, price)
                      : null,
                ),
                _buildActionButton(
                  text: 'S',
                  color: Colors.orange,
                  onTap: ref.read(gameControllerProvider.notifier).canSell(good, 1)
                      ? () => _showSellDialog(context, ref, good, price)
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    IconData? icon,
    String? text,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: onTap != null ? color.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: onTap != null ? color.withOpacity(0.3) : Colors.grey.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Center(
          child: icon != null
              ? Icon(
                  icon,
                  size: 14,
                  color: onTap != null ? color : Colors.grey,
                )
              : Text(
                  text ?? '',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: onTap != null ? color : Colors.grey,
                  ),
                ),
        ),
      ),
    );
  }

  // Helper methods for better drug visualization
  String _getDrugEmoji(String drug) {
    switch (drug.toLowerCase()) {
      case 'weed':
      case 'marijuana':
        return '🌿';
      case 'cocaine':
      case 'coke':
        return '❄️';
      case 'heroin':
        return '💉';
      case 'lsd':
      case 'acid':
        return '🌈';
      case 'ecstasy':
      case 'mdma':
        return '💊';
      case 'meth':
      case 'crystal':
        return '🧊';
      case 'pills':
        return '💊';
      case 'speed':
        return '⚡';
      case 'shrooms':
      case 'mushrooms':
        return '🍄';
      default:
        return '💼';
    }
  }

  Color _getDrugColor(String drug) {
    switch (drug.toLowerCase()) {
      case 'weed':
      case 'marijuana':
        return Colors.green;
      case 'cocaine':
      case 'coke':
        return Colors.white;
      case 'heroin':
        return Colors.brown;
      case 'lsd':
      case 'acid':
        return Colors.purple;
      case 'ecstasy':
      case 'mdma':
        return Colors.pink;
      case 'meth':
      case 'crystal':
        return Colors.blue;
      case 'pills':
        return Colors.orange;
      case 'speed':
        return Colors.yellow;
      case 'shrooms':
      case 'mushrooms':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }

  Widget _buildSparkline(List<double> history, ThemeData theme) {
    if (history.length < 2) {
      return const SizedBox.shrink();
    }

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: history.length - 1.0,
        minY: history.reduce((a, b) => a < b ? a : b) * 0.9,
        maxY: history.reduce((a, b) => a > b ? a : b) * 1.1,
        lineBarsData: [
          LineChartBarData(
            spots: history.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value);
            }).toList(),
            isCurved: true,
            color: percentChange >= 0 ? Colors.green : Colors.red,
            barWidth: 1.5,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
      ),
    );
  }

  void _showBuyDialog(BuildContext context, WidgetRef ref, String good, int price) {
    final gameState = ref.read(gameControllerProvider);
    final maxAffordable = gameState.cash ~/ price;
    final maxCapacity = gameState.availableCapacity;
    final maxQuantity = maxAffordable < maxCapacity ? maxAffordable : maxCapacity;
    
    if (maxQuantity <= 0) return;
    
    int quantity = 1;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.shopping_cart, color: Colors.green),
              const SizedBox(width: 8),
              Text('Buy $good'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Price: \$${Formatters.money(price)} each'),
                Text('Max affordable: $maxAffordable | Available space: $maxCapacity'),
                const SizedBox(height: 16),
                
                // Quick preset buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildPresetButton('1', 1, quantity, maxQuantity, (newQuantity) => setState(() => quantity = newQuantity)),
                  _buildPresetButton('5', 5, quantity, maxQuantity, (newQuantity) => setState(() => quantity = newQuantity)),
                  _buildPresetButton('10', 10, quantity, maxQuantity, (newQuantity) => setState(() => quantity = newQuantity)),
                  _buildPresetButton('Max', maxQuantity, quantity, maxQuantity, (newQuantity) => setState(() => quantity = newQuantity)),
                ],
              ),
              
              const SizedBox(height: 16),
              Text('Quantity: $quantity', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Slider(
                value: quantity.toDouble(),
                min: 1,
                max: maxQuantity.toDouble(),
                divisions: maxQuantity > 1 ? maxQuantity - 1 : null,
                onChanged: (value) {
                  setState(() {
                    quantity = value.round();
                  });
                },
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Total: \$${Formatters.money(price * quantity)}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton.icon(
              onPressed: () {
                ref.read(gameControllerProvider.notifier).buy(good, quantity);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Bought $quantity $good for \$${Formatters.money(price * quantity)}'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              icon: const Icon(Icons.shopping_cart),
              label: const Text('Buy'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSellDialog(BuildContext context, WidgetRef ref, String good, int price) {
    final gameState = ref.read(gameControllerProvider);
    final maxQuantity = gameState.stash[good] ?? 0;
    
    if (maxQuantity <= 0) return;
    
    int quantity = 1;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.sell, color: Colors.red),
              const SizedBox(width: 8),
              Text('Sell $good'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Price: \$${Formatters.money(price)} each'),
                Text('You have: $maxQuantity'),
                const SizedBox(height: 16),
                
                // Quick preset buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildPresetButton('1', 1, quantity, maxQuantity, (newQuantity) => setState(() => quantity = newQuantity)),
                  _buildPresetButton('5', 5, quantity, maxQuantity, (newQuantity) => setState(() => quantity = newQuantity)),
                  _buildPresetButton('10', 10, quantity, maxQuantity, (newQuantity) => setState(() => quantity = newQuantity)),
                  _buildPresetButton('All', maxQuantity, quantity, maxQuantity, (newQuantity) => setState(() => quantity = newQuantity)),
                ],
              ),
              
              const SizedBox(height: 16),
              Text('Quantity: $quantity', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Slider(
                value: quantity.toDouble(),
                min: 1,
                max: maxQuantity.toDouble(),
                divisions: maxQuantity > 1 ? maxQuantity - 1 : null,
                onChanged: (value) {
                  setState(() {
                    quantity = value.round();
                  });
                },
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Total: \$${Formatters.money(price * quantity)}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton.icon(
              onPressed: () {
                ref.read(gameControllerProvider.notifier).sell(good, quantity);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Sold $quantity $good for \$${Formatters.money(price * quantity)}'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              icon: const Icon(Icons.sell),
              label: const Text('Sell'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetButton(String label, int value, int currentQuantity, int maxQuantity, Function(int) onPressed) {
    final isActive = currentQuantity == value;
    final isEnabled = value <= maxQuantity;
    
    return SizedBox(
      width: 50,
      child: ElevatedButton(
        onPressed: isEnabled ? () => onPressed(value) : null,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          backgroundColor: isActive ? Colors.green : null,
          foregroundColor: isActive ? Colors.white : null,
        ),
        child: Text(label, style: const TextStyle(fontSize: 12)),
      ),
    );
  }

  // Quick buy confirmation dialog
  void _showQuickBuyConfirmation(BuildContext context, WidgetRef ref, String good, int price) {
    final emoji = _getDrugEmoji(good);
    final color = _getDrugColor(good);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Text('Buy $good?', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(
            'Buy 1x $good for \$${Formatters.money(price)}?',
            style: const TextStyle(fontSize: 16),
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$emoji Bought 1x $good for \$${Formatters.money(price)}'),
                    duration: const Duration(seconds: 2),
                    backgroundColor: color.withOpacity(0.8),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
              ),
              child: const Text('Buy'),
            ),
          ],
        );
      },
    );
  }

  // Quick sell confirmation dialog
  void _showQuickSellConfirmation(BuildContext context, WidgetRef ref, String good, int price) {
    final emoji = _getDrugEmoji(good);
    final color = _getDrugColor(good);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Text('Sell $good?', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(
            'Sell 1x $good for \$${Formatters.money(price)}?',
            style: const TextStyle(fontSize: 16),
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$emoji Sold 1x $good for \$${Formatters.money(price)}'),
                    duration: const Duration(seconds: 2),
                    backgroundColor: Colors.red.withOpacity(0.8),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                foregroundColor: Colors.white,
              ),
              child: const Text('Sell'),
            ),
          ],
        );
      },
    );
  }
}
