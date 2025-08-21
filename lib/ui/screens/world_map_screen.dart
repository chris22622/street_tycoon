import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../systems/world_manager.dart';
import '../../data/expanded_constants.dart';
import '../../theme/app_theme.dart';

class WorldMapScreen extends ConsumerWidget {
  const WorldMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final worldState = ref.watch(worldManagerProvider);
    final worldManager = ref.read(worldManagerProvider.notifier);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('World Map'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.backgroundColor, AppTheme.secondaryColor],
          ),
        ),
        child: Column(
          children: [
            // Time Period and Season Info
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.accentColor, width: 2),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Time Period',
                            style: AppTheme.headingStyle.copyWith(fontSize: 14),
                          ),
                          Text(
                            worldState.currentTimePeriod,
                            style: AppTheme.bodyStyle.copyWith(
                              color: AppTheme.accentColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Season',
                            style: AppTheme.headingStyle.copyWith(fontSize: 14),
                          ),
                          Text(
                            worldState.currentSeason.name,
                            style: AppTheme.bodyStyle.copyWith(
                              color: AppTheme.accentColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date',
                            style: AppTheme.headingStyle.copyWith(fontSize: 14),
                          ),
                          Text(
                            '${worldState.gameTime.month}/${worldState.gameTime.year}',
                            style: AppTheme.bodyStyle.copyWith(
                              color: AppTheme.accentColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    worldState.currentSeason.description,
                    style: AppTheme.bodyStyle.copyWith(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            // Cities Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemCount: CITIES.length,
                itemBuilder: (context, index) {
                  final city = CITIES[index];
                  final isUnlocked = worldState.unlockedCities.any((c) => c.id == city.id);
                  final isCurrent = city.id == worldState.currentCityId;
                  
                  return GestureDetector(
                    onTap: () => _onCityTapped(context, ref, city, isUnlocked, worldManager),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isCurrent ? AppTheme.accentColor.withOpacity(0.3) : AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isCurrent ? AppTheme.accentColor : 
                                 isUnlocked ? AppTheme.primaryColor : Colors.grey,
                          width: isCurrent ? 3 : 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (isCurrent ? AppTheme.accentColor : AppTheme.primaryColor).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isUnlocked ? Icons.location_city : Icons.lock,
                              size: 32,
                              color: isUnlocked ? AppTheme.accentColor : Colors.grey,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              city.name,
                              style: AppTheme.headingStyle.copyWith(
                                fontSize: 16,
                                color: isUnlocked ? AppTheme.textColor : Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              city.country,
                              style: AppTheme.bodyStyle.copyWith(
                                fontSize: 12,
                                color: isUnlocked ? AppTheme.textColor.withOpacity(0.7) : Colors.grey,
                              ),
                            ),
                            if (isCurrent) ...[
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'CURRENT',
                                  style: AppTheme.bodyStyle.copyWith(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.backgroundColor,
                                  ),
                                ),
                              ),
                            ],
                            if (!isUnlocked) ...[
                              const SizedBox(height: 4),
                              Text(
                                '\$${_formatMoney(city.unlockCost)}',
                                style: AppTheme.bodyStyle.copyWith(
                                  fontSize: 10,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Active Events
            if (worldState.activeEvents.isNotEmpty) ...[
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.warning, color: Colors.red, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Active Events',
                          style: AppTheme.headingStyle.copyWith(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...worldState.activeEvents.map((event) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '• ${event.name}: ${event.description}',
                        style: AppTheme.bodyStyle.copyWith(fontSize: 12),
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _onCityTapped(BuildContext context, WidgetRef ref, city, bool isUnlocked, worldManager) {
    if (!isUnlocked) {
      _showUnlockCityDialog(context, ref, city);
    } else if (city.id != ref.read(worldManagerProvider).currentCityId) {
      _showTravelDialog(context, ref, city, worldManager);
    } else {
      _showCityDetailsDialog(context, city);
    }
  }

  void _showUnlockCityDialog(BuildContext context, WidgetRef ref, city) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: Text('Unlock ${city.name}', style: AppTheme.headingStyle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(city.description, style: AppTheme.bodyStyle),
            const SizedBox(height: 16),
            Text(
              'Cost: \$${_formatMoney(city.unlockCost)}',
              style: AppTheme.bodyStyle.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.accentColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Profit Modifier: ${(city.economicModifiers['profit_margin'] ?? 1.0) * 100}%',
              style: AppTheme.bodyStyle,
            ),
            Text(
              'Risk Level: ${(city.riskModifiers['police_presence'] ?? 1.0) * 100}%',
              style: AppTheme.bodyStyle,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel', style: AppTheme.bodyStyle),
          ),
          ElevatedButton(
            onPressed: () {
              // Check if player has enough money
              ref.read(worldManagerProvider.notifier).unlockCity(city.id);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor),
            child: Text('Unlock', style: AppTheme.bodyStyle.copyWith(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showTravelDialog(BuildContext context, WidgetRef ref, city, worldManager) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: Text('Travel to ${city.name}', style: AppTheme.headingStyle),
        content: Text(
          'Are you sure you want to travel to ${city.name}? This will change your current location and market conditions.',
          style: AppTheme.bodyStyle,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel', style: AppTheme.bodyStyle),
          ),
          ElevatedButton(
            onPressed: () {
              worldManager.travelToCity(city.id);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor),
            child: Text('Travel', style: AppTheme.bodyStyle.copyWith(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showCityDetailsDialog(BuildContext context, city) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: Text('${city.name} Details', style: AppTheme.headingStyle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current Location', style: AppTheme.headingStyle.copyWith(fontSize: 16)),
            const SizedBox(height: 8),
            Text(city.description, style: AppTheme.bodyStyle),
            const SizedBox(height: 16),
            Text('Districts:', style: AppTheme.headingStyle.copyWith(fontSize: 14)),
            ...city.districts.map((district) => Text('• $district', style: AppTheme.bodyStyle)),
            const SizedBox(height: 16),
            Text('Available Goods:', style: AppTheme.headingStyle.copyWith(fontSize: 14)),
            ...city.availableGoods.map((good) => Text('• $good', style: AppTheme.bodyStyle)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close', style: AppTheme.bodyStyle),
          ),
        ],
      ),
    );
  }

  String _formatMoney(int amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toString();
  }
}
