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
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.storefront, size: 20, color: Color(0xFFD4AF37)),
                const SizedBox(width: 6),
                Text('Market', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          ),
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFD4AF37).withOpacity(0.1),
              border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor)),
            ),
            child: const Row(
              children: [
                Expanded(flex: 3, child: Text('Item', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                Expanded(flex: 2, child: Text('Price', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.right)),
                Expanded(flex: 4, child: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.center)),
              ],
            ),
          ),
          // Rows - use ListView with shrinkWrap instead of Expanded
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: GOODS.length,
            itemBuilder: (context, index) {
              final good = GOODS[index];
              final price = prices[good] ?? 0;
              final percentChange = PriceEngine.getPercentageChange(good, price);
              return _MarketRow(good: good, price: price, percentChange: percentChange);
            },
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

  const _MarketRow({required this.good, required this.price, required this.percentChange});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameControllerProvider);
    final owned = gameState.stash[good] ?? 0;
    final canBuy = gameState.cash >= price && gameState.availableCapacity > 0;
    final canSell = owned > 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.2))),
      ),
      child: Row(
        children: [
          // Item + price info
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_getDrugEmoji(good), style: const TextStyle(fontSize: 12)),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(good, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                if (owned > 0)
                  Text('Own: $owned', style: const TextStyle(color: Colors.green, fontSize: 11)),
              ],
            ),
          ),
          // Price + change
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('\$${Formatters.money(price)}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: percentChange >= 0 ? Colors.green : Colors.red)),
                Text('${percentChange >= 0 ? "+" : ""}${percentChange.toStringAsFixed(1)}%', style: TextStyle(color: percentChange >= 0 ? Colors.green : Colors.red, fontSize: 10)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Action buttons - flex layout
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _ActionBtn(label: 'Buy', color: Colors.green, enabled: canBuy, onTap: () => _quickBuy(context, ref)),
                const SizedBox(width: 4),
                _ActionBtn(label: 'Buy+', color: Colors.blue, enabled: canBuy, onTap: () => _showBuyDialog(context, ref)),
                const SizedBox(width: 4),
                _ActionBtn(label: 'Sell', color: Colors.red, enabled: canSell, onTap: () => _quickSell(context, ref)),
                const SizedBox(width: 4),
                _ActionBtn(label: 'Sell+', color: Colors.orange, enabled: canSell, onTap: () => _showSellDialog(context, ref)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _quickBuy(BuildContext context, WidgetRef ref) {
    ref.read(gameControllerProvider.notifier).buy(good, 1);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Bought 1x $good for \$${Formatters.money(price)}'), duration: const Duration(seconds: 1)),
    );
  }

  void _quickSell(BuildContext context, WidgetRef ref) {
    ref.read(gameControllerProvider.notifier).sell(good, 1);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sold 1x $good for \$${Formatters.money(price)}'), duration: const Duration(seconds: 1)),
    );
  }

  void _showBuyDialog(BuildContext context, WidgetRef ref) {
    int quantity = 1;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          final gs = ref.read(gameControllerProvider);
          final maxQty = (gs.cash / price).floor().clamp(1, gs.availableCapacity);
          return AlertDialog(
            title: Text('Buy $good'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Price: \$${Formatters.money(price)} each'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(onPressed: quantity > 1 ? () => setState(() => quantity--) : null, icon: const Icon(Icons.remove_circle_outline)),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text('$quantity', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
                    IconButton(onPressed: quantity < maxQty ? () => setState(() => quantity++) : null, icon: const Icon(Icons.add_circle_outline)),
                  ],
                ),
                const SizedBox(height: 8),
                FilledButton.tonal(onPressed: () => setState(() => quantity = maxQty), child: const Text('Max')),
                const SizedBox(height: 8),
                Text('Total: \$${Formatters.money(price * quantity)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
              FilledButton(onPressed: () { Navigator.of(context).pop(); ref.read(gameControllerProvider.notifier).buy(good, quantity); }, child: const Text('Buy')),
            ],
          );
        },
      ),
    );
  }

  void _showSellDialog(BuildContext context, WidgetRef ref) {
    int quantity = 1;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          final gs = ref.read(gameControllerProvider);
          final maxQty = gs.stash[good] ?? 0;
          return AlertDialog(
            title: Text('Sell $good'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Price: \$${Formatters.money(price)} each'),
                Text('Available: $maxQty units'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(onPressed: quantity > 1 ? () => setState(() => quantity--) : null, icon: const Icon(Icons.remove_circle_outline)),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text('$quantity', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
                    IconButton(onPressed: quantity < maxQty ? () => setState(() => quantity++) : null, icon: const Icon(Icons.add_circle_outline)),
                  ],
                ),
                const SizedBox(height: 8),
                FilledButton.tonal(onPressed: maxQty > 0 ? () => setState(() => quantity = maxQty) : null, child: const Text('Max')),
                const SizedBox(height: 8),
                Text('Total: \$${Formatters.money(price * quantity)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
              FilledButton(onPressed: maxQty > 0 ? () { Navigator.of(context).pop(); ref.read(gameControllerProvider.notifier).sell(good, quantity); } : null, child: const Text('Sell')),
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

class _ActionBtn extends StatelessWidget {
  final String label;
  final Color color;
  final bool enabled;
  final VoidCallback onTap;

  const _ActionBtn({required this.label, required this.color, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: enabled ? color.withOpacity(0.15) : Colors.grey.withOpacity(0.08),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: enabled ? color.withOpacity(0.4) : Colors.grey.withOpacity(0.2)),
        ),
        child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: enabled ? color : Colors.grey)),
      ),
    );
  }
}
