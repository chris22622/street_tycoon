import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
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
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.storefront),
                const SizedBox(width: 8),
                Text(
                  'Market',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
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
                
                return _MarketRow(
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

class _MarketRow extends ConsumerWidget {
  final String good;
  final int price;
  final double percentChange;
  final List<double> history;

  const _MarketRow({
    required this.good,
    required this.price,
    required this.percentChange,
    required this.history,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    ref.watch(gameControllerProvider);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Item name
          Expanded(
            flex: 3,
            child: Text(
              good,
              style: theme.textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          // Price with trend indicator
          SizedBox(
            width: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '\$${Formatters.money(price)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: percentChange >= 0 ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  percentChange >= 0 ? Icons.trending_up : Icons.trending_down,
                  size: 14,
                  color: percentChange >= 0 ? Colors.green : Colors.red,
                ),
              ],
            ),
          ),
          
          // Percentage change
          SizedBox(
            width: 50,
            child: Text(
              '${percentChange >= 0 ? '+' : ''}${percentChange.toStringAsFixed(1)}%',
              style: theme.textTheme.bodySmall?.copyWith(
                color: percentChange >= 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          
          // Sparkline
          SizedBox(
            width: 60,
            height: 30,
            child: _buildSparkline(history, theme),
          ),
          
          // Quick buy button (1x)
          SizedBox(
            width: 35,
            child: IconButton(
              onPressed: ref.read(gameControllerProvider.notifier).canBuy(good, 1)
                  ? () {
                      ref.read(gameControllerProvider.notifier).buy(good, 1);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Bought 1 $good for \$${Formatters.money(price)}'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    }
                  : null,
              icon: const Icon(Icons.add_shopping_cart, size: 16),
              style: IconButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(28, 28),
                backgroundColor: Colors.green.withOpacity(0.1),
                foregroundColor: Colors.green,
              ),
              tooltip: 'Quick buy 1',
            ),
          ),
          
          // Buy button (custom amount)
          SizedBox(
            width: 35,
            child: IconButton(
              onPressed: ref.read(gameControllerProvider.notifier).canBuy(good, 1)
                  ? () => _showBuyDialog(context, ref, good, price)
                  : null,
              icon: const Icon(Icons.shopping_cart, size: 16),
              style: IconButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(28, 28),
              ),
              tooltip: 'Buy multiple',
            ),
          ),
          
          // Quick sell button (1x)
          SizedBox(
            width: 35,
            child: IconButton(
              onPressed: ref.read(gameControllerProvider.notifier).canSell(good, 1)
                  ? () {
                      ref.read(gameControllerProvider.notifier).sell(good, 1);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Sold 1 $good for \$${Formatters.money(price)}'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    }
                  : null,
              icon: const Icon(Icons.remove_shopping_cart, size: 16),
              style: IconButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(28, 28),
                backgroundColor: Colors.red.withOpacity(0.1),
                foregroundColor: Colors.red,
              ),
              tooltip: 'Quick sell 1',
            ),
          ),
          
          // Sell button (custom amount)
          SizedBox(
            width: 35,
            child: IconButton(
              onPressed: ref.read(gameControllerProvider.notifier).canSell(good, 1)
                  ? () => _showSellDialog(context, ref, good, price)
                  : null,
              icon: const Icon(Icons.sell, size: 16),
              style: IconButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(28, 28),
              ),
              tooltip: 'Sell multiple',
            ),
          ),
        ],
      ),
    );
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
          content: Column(
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
          content: Column(
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
}
