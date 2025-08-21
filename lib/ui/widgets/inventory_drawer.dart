import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers.dart';
import '../../util/formatters.dart';

class InventoryDrawer extends ConsumerWidget {
  final ScrollController scrollController;

  const InventoryDrawer({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameControllerProvider);
    final prices = ref.watch(currentPricesProvider);
    
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.inventory),
                const SizedBox(width: 8),
                Text(
                  'Inventory',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                Text(
                  '${gameState.usedCapacity}/${gameState.capacity}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          
          // Capacity bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: LinearProgressIndicator(
              value: gameState.capacity > 0 ? gameState.usedCapacity / gameState.capacity : 0,
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Inventory list
          Expanded(
            child: gameState.stash.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2_outlined, size: 64),
                        SizedBox(height: 16),
                        Text(
                          'Inventory is empty',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          'Buy items from the market',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: scrollController,
                    itemCount: gameState.stash.length,
                    itemBuilder: (context, index) {
                      final entry = gameState.stash.entries.elementAt(index);
                      final item = entry.key;
                      final quantity = entry.value;
                      final price = prices[item] ?? 0;
                      final totalValue = price * quantity;
                      
                      return _InventoryTile(
                        item: item,
                        quantity: quantity,
                        price: price,
                        totalValue: totalValue,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _InventoryTile extends ConsumerWidget {
  final String item;
  final int quantity;
  final int price;
  final int totalValue;

  const _InventoryTile({
    required this.item,
    required this.quantity,
    required this.price,
    required this.totalValue,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Qty: $quantity',
                      style: theme.textTheme.bodyMedium,
                    ),
                    Text(
                      'Price: \$${Formatters.money(price)} each',
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(
                      'Value: \$${Formatters.money(totalValue)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              // Fixed overflow with Flexible wrapper
              Flexible(
                child: Column(
                  children: [
                    IconButton(
                      onPressed: () => _showSellDialog(context, ref, item, price, quantity),
                      icon: const Icon(Icons.sell),
                      tooltip: 'Sell',
                      constraints: BoxConstraints(minWidth: 24, minHeight: 24),
                      padding: EdgeInsets.all(4),
                    ),
                    IconButton(
                      onPressed: () => _quickSell(ref, item, 1),
                      icon: const Icon(Icons.remove),
                      tooltip: 'Sell 1',
                      constraints: BoxConstraints(minWidth: 24, minHeight: 24),
                      padding: EdgeInsets.all(4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _quickSell(WidgetRef ref, String item, int quantity) {
    if (ref.read(gameControllerProvider.notifier).canSell(item, quantity)) {
      ref.read(gameControllerProvider.notifier).sell(item, quantity);
    }
  }

  void _showSellDialog(BuildContext context, WidgetRef ref, String item, int price, int maxQuantity) {
    int quantity = maxQuantity;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Sell $item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Price: \$${Formatters.money(price)} each'),
                Text('Available: $maxQuantity'),
                const SizedBox(height: 16),
                Text('Quantity: $quantity'),
                Slider(
                  value: quantity.toDouble(),
                  min: 1,
                  max: maxQuantity.toDouble(),
                  divisions: maxQuantity - 1,
                  onChanged: (value) {
                    setState(() {
                      quantity = value.round();
                    });
                  },
                ),
                const SizedBox(height: 8),
                Text('Total: \$${Formatters.money(price * quantity)}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                ref.read(gameControllerProvider.notifier).sell(item, quantity);
                Navigator.of(context).pop();
              },
              child: const Text('Sell'),
            ),
          ],
        ),
      ),
    );
  }
}
