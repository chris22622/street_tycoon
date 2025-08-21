import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers.dart';
import '../../data/constants.dart';
import '../../logic/price_engine.dart';
import '../../util/responsive_helper.dart';

class MarketTableAndroid extends ConsumerWidget {
  const MarketTableAndroid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prices = ref.watch(currentPricesProvider);
    
    if (prices.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Card(
      margin: ResponsiveHelper.getCardMargin(context),
      child: Column(
        children: [
          Container(
            padding: ResponsiveHelper.getContentPadding(context),
            child: Row(
              children: [
                Icon(Icons.storefront, 
                  size: ResponsiveHelper.getIconSize(context, base: 20),
                ),
                SizedBox(width: ResponsiveHelper.getSpacing(context, base: 6)),
                Text(
                  'Market',
                  style: ResponsiveHelper.scaleTextStyle(
                    context, 
                    Theme.of(context).textTheme.titleMedium!,
                  ),
                ),
              ],
            ),
          ),
          // Android-optimized header
          _buildAndroidHeader(context),
          // Android-optimized rows
          Expanded(
            child: ListView.builder(
              itemCount: GOODS.length,
              itemBuilder: (context, index) {
                final good = GOODS[index];
                final price = prices[good] ?? 0;
                return _buildAndroidRow(context, ref, good, price);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAndroidHeader(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getSpacing(context, base: 12),
        vertical: ResponsiveHelper.getSpacing(context, base: 8),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: isMobile ? 3 : 2,
            child: Text(
              'Item',
              style: ResponsiveHelper.scaleTextStyle(
                context,
                const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Price',
              style: ResponsiveHelper.scaleTextStyle(
                context,
                const TextStyle(fontWeight: FontWeight.bold),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (!isMobile) ...[
            const Expanded(
              child: Text(
                'Change',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const Expanded(
              child: Text(
                'Trend',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ],
          Expanded(
            flex: isMobile ? 2 : 1,
            child: Text(
              'Actions',
              style: ResponsiveHelper.scaleTextStyle(
                context,
                const TextStyle(fontWeight: FontWeight.bold),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAndroidRow(BuildContext context, WidgetRef ref, String good, int price) {
    final priceHistory = PriceEngine.getPriceHistory(good);
    final isMobile = ResponsiveHelper.isMobile(context);
    
    final percentChange = PriceEngine.getPercentageChange(good, price);
    
    return InkWell(
      onTap: () => _showGoodDetails(context, good, price.toDouble()),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.getSpacing(context, base: 12),
          vertical: ResponsiveHelper.getSpacing(context, base: 8),
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
            ),
          ),
        ),
        child: Row(
          children: [
            // Good name with icon
            Expanded(
              flex: isMobile ? 3 : 2,
              child: Row(
                children: [
                  Container(
                    width: ResponsiveHelper.getIconSize(context, base: 24),
                    height: ResponsiveHelper.getIconSize(context, base: 24),
                    decoration: BoxDecoration(
                      color: _getGoodColor(good).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      _getGoodIcon(good),
                      size: ResponsiveHelper.getIconSize(context, base: 16),
                      color: _getGoodColor(good),
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.getSpacing(context, base: 8)),
                  Expanded(
                    child: Text(
                      good,
                      style: ResponsiveHelper.scaleTextStyle(
                        context,
                        const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            
            // Price
            Expanded(
              flex: 2,
              child: Text(
                '\$${price}',
                style: ResponsiveHelper.scaleTextStyle(
                  context,
                  TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            // Change and trend (desktop only)
            if (!isMobile) ...[
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      percentChange >= 0 ? Icons.trending_up : Icons.trending_down,
                      color: percentChange >= 0 ? Colors.green : Colors.red,
                      size: ResponsiveHelper.getIconSize(context, base: 16),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${percentChange >= 0 ? '+' : ''}${percentChange.toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: percentChange >= 0 ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _buildMiniSparkline(priceHistory),
              ),
            ],
            
            // Actions
            Expanded(
              flex: isMobile ? 2 : 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildActionButton(
                    context: context,
                    icon: Icons.add_shopping_cart,
                    color: Colors.green,
                    onTap: () => _buyGood(ref, good),
                  ),
                  SizedBox(width: ResponsiveHelper.getSpacing(context, base: 4)),
                  _buildActionButton(
                    context: context,
                    icon: Icons.sell,
                    color: Colors.red,
                    onTap: () => _sellGood(ref, good),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: ResponsiveHelper.getIconSize(context, base: 32),
        height: ResponsiveHelper.getIconSize(context, base: 32),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Icon(
          icon,
          size: ResponsiveHelper.getIconSize(context, base: 18),
          color: color,
        ),
      ),
    );
  }

  Widget _buildMiniSparkline(List<double> priceHistory) {
    if (priceHistory.length < 2) {
      return const SizedBox();
    }

    return SizedBox(
      height: 30,
      width: 60,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: priceHistory.asMap().entries.map((entry) {
                return FlSpot(entry.key.toDouble(), entry.value);
              }).toList(),
              isCurved: true,
              color: Colors.blue,
              barWidth: 2,
              dotData: const FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  void _showGoodDetails(BuildContext context, String good, double price) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(good),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current Price: \$${price.toInt()}'),
            const SizedBox(height: 8),
            Text('Description: ${_getGoodDescription(good)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _buyGood(WidgetRef ref, String good) {
    final gameController = ref.read(gameControllerProvider.notifier);
    gameController.buy(good, 1);
  }

  void _sellGood(WidgetRef ref, String good) {
    final gameController = ref.read(gameControllerProvider.notifier);
    gameController.sell(good, 1);
  }

  Color _getGoodColor(String good) {
    switch (good.toLowerCase()) {
      case 'cannabis (marijuana)':
      case 'hashish':
        return Colors.green;
      case 'cocaine (powder)':
      case 'crack cocaine':
        return Colors.blue;
      case 'heroin':
      case 'fentanyl':
        return Colors.red;
      case 'mdma (ecstasy)':
        return Colors.purple;
      case 'lsd (acid)':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getGoodIcon(String good) {
    switch (good.toLowerCase()) {
      case 'cannabis (marijuana)':
      case 'hashish':
        return Icons.eco;
      case 'cocaine (powder)':
      case 'crack cocaine':
        return Icons.grain;
      case 'heroin':
      case 'fentanyl':
        return Icons.medical_services;
      case 'mdma (ecstasy)':
        return Icons.psychology;
      case 'lsd (acid)':
        return Icons.colorize;
      default:
        return Icons.medication;
    }
  }

  String _getGoodDescription(String good) {
    switch (good.toLowerCase()) {
      case 'cannabis (marijuana)':
        return 'Natural herb with steady demand';
      case 'cocaine (powder)':
        return 'High-value stimulant with volatile prices';
      case 'heroin':
        return 'Dangerous opioid with consistent market';
      case 'mdma (ecstasy)':
        return 'Party drug with weekend price spikes';
      case 'lsd (acid)':
        return 'Psychedelic with niche but loyal market';
      default:
        return 'Controlled substance';
    }
  }
}
