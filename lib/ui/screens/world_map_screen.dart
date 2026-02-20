import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../systems/world_manager.dart';
import '../../data/expanded_constants.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';

class WorldMapScreen extends ConsumerWidget {
  const WorldMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final worldState = ref.watch(worldManagerProvider);
    final worldManager = ref.read(worldManagerProvider.notifier);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('World Map', style: AppTheme.heading.copyWith(fontSize: 20)),
        backgroundColor: AppTheme.surface,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: AppTheme.gold),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.bg, AppTheme.accent],
          ),
        ),
        child: Column(
          children: [
            // Time Period and Season Info
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.accent, width: 2),
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
                            style: AppTheme.heading.copyWith(fontSize: 14),
                          ),
                          Text(
                            worldState.currentTimePeriod,
                            style: AppTheme.body.copyWith(
                              color: AppTheme.accent,
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
                            style: AppTheme.heading.copyWith(fontSize: 14),
                          ),
                          Text(
                            worldState.currentSeason.name,
                            style: AppTheme.body.copyWith(
                              color: AppTheme.accent,
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
                            style: AppTheme.heading.copyWith(fontSize: 14),
                          ),
                          Text(
                            '${worldState.gameTime.month}/${worldState.gameTime.year}',
                            style: AppTheme.body.copyWith(
                              color: AppTheme.accent,
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
                    style: AppTheme.body.copyWith(fontSize: 12),
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
                        color: isCurrent ? AppTheme.accent.withOpacity(0.3) : AppTheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isCurrent ? AppTheme.accent : 
                                 isUnlocked ? AppTheme.gold : Colors.grey,
                          width: isCurrent ? 3 : 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (isCurrent ? AppTheme.accent : AppTheme.gold).withOpacity(0.3),
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
                              color: isUnlocked ? AppTheme.accent : Colors.grey,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              city.name,
                              style: AppTheme.heading.copyWith(
                                fontSize: 16,
                                color: isUnlocked ? Colors.white : Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              city.country,
                              style: AppTheme.body.copyWith(
                                fontSize: 12,
                                color: isUnlocked ? Colors.white.withOpacity(0.7) : Colors.grey,
                              ),
                            ),
                            if (isCurrent) ...[
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppTheme.accent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'CURRENT',
                                  style: AppTheme.body.copyWith(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.bg,
                                  ),
                                ),
                              ),
                            ],
                            if (!isUnlocked) ...[
                              const SizedBox(height: 4),
                              Text(
                                '\$${_formatMoney(city.unlockCost)}',
                                style: AppTheme.body.copyWith(
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
                  color: AppTheme.surface,
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
                          style: AppTheme.heading.copyWith(
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
                        style: AppTheme.body.copyWith(fontSize: 12),
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
        backgroundColor: AppTheme.surface,
        title: Text('Unlock ${city.name}', style: AppTheme.heading),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(city.description, style: AppTheme.body),
            const SizedBox(height: 16),
            Text(
              'Cost: \$${_formatMoney(city.unlockCost)}',
              style: AppTheme.body.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.accent,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Profit Modifier: ${(city.economicModifiers['profit_margin'] ?? 1.0) * 100}%',
              style: AppTheme.body,
            ),
            Text(
              'Risk Level: ${(city.riskModifiers['police_presence'] ?? 1.0) * 100}%',
              style: AppTheme.body,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel', style: AppTheme.body),
          ),
          ElevatedButton(
            onPressed: () {
              // Check if player has enough money
              ref.read(worldManagerProvider.notifier).unlockCity(city.id);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.gold),
            child: Text('Unlock', style: AppTheme.body.copyWith(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showTravelDialog(BuildContext context, WidgetRef ref, city, worldManager) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text('Travel to ${city.name}', style: AppTheme.heading),
        content: Text(
          'Are you sure you want to travel to ${city.name}? This will change your current location and market conditions.',
          style: AppTheme.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel', style: AppTheme.body),
          ),
          ElevatedButton(
            onPressed: () {
              worldManager.travelToCity(city.id);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.gold),
            child: Text('Travel', style: AppTheme.body.copyWith(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showCityDetailsDialog(BuildContext context, city) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text('${city.name} Details', style: AppTheme.heading),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current Location', style: AppTheme.heading.copyWith(fontSize: 16)),
            const SizedBox(height: 8),
            Text(city.description, style: AppTheme.body),
            const SizedBox(height: 16),
            Text('Districts:', style: AppTheme.heading.copyWith(fontSize: 14)),
            ...city.districts.map((district) => Text('• $district', style: AppTheme.body)),
            const SizedBox(height: 16),
            Text('Available Goods:', style: AppTheme.heading.copyWith(fontSize: 14)),
            ...city.availableGoods.map((good) => Text('• $good', style: AppTheme.body)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close', style: AppTheme.body),
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
