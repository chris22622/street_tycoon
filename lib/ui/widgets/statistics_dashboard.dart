import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers.dart';
import '../../logic/achievement_service.dart';
import '../../logic/market_specialization_service.dart';
import 'mission_dashboard.dart';

class StatisticsDashboard extends ConsumerWidget {
  const StatisticsDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameControllerProvider);
    final stats = gameState.statistics;
    final unlockedIds = gameState.unlockedAchievements;
    final allAchievements = AchievementService.getDefaultAchievements();

    return SingleChildScrollView(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0), // Reduced from 16.0
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.analytics, color: Theme.of(context).primaryColor, size: 20),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Statistics & Achievements',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12), // Reduced from 16
              
              // Statistics Section
              _buildStatsSection(context, stats),
              
              const SizedBox(height: 16), // Reduced from 24
              
              // Market Specialization Info
              _buildMarketSpecializationSection(context, gameState.area),
              
              const SizedBox(height: 16), // Reduced from 24
              
              // Missions Section
              const MissionDashboard(),
              
              const SizedBox(height: 16), // Reduced from 24
            
              // Achievements Section
              _buildAchievementsSection(context, allAchievements, unlockedIds),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, Map<String, dynamic> stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Performance',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 12,
          children: [
            _buildStatCard(
              context,
              'Total Purchases',
              '${stats['totalPurchases'] ?? 0}',
              Icons.shopping_cart,
              Colors.blue,
            ),
            _buildStatCard(
              context,
              'Total Sales',
              '${stats['totalSales'] ?? 0}',
              Icons.sell,
              Colors.green,
            ),
            _buildStatCard(
              context,
              'Total Profit',
              '\$${(stats['totalProfit'] ?? 0).toStringAsFixed(0)}',
              Icons.trending_up,
              Colors.amber,
            ),
            _buildStatCard(
              context,
              'Largest Purchase',
              '\$${(stats['largestPurchase'] ?? 0).toStringAsFixed(0)}',
              Icons.monetization_on,
              Colors.purple,
            ),
            _buildStatCard(
              context,
              'Largest Sale',
              '\$${(stats['largestSale'] ?? 0).toStringAsFixed(0)}',
              Icons.attach_money,
              Colors.teal,
            ),
            _buildStatCard(
              context,
              'Max Heat',
              '${stats['maxHeat'] ?? 0}',
              Icons.local_fire_department,
              Colors.red,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMarketSpecializationSection(BuildContext context, String currentArea) {
    final specialization = MarketSpecializationService.getSpecializationForArea(currentArea);
    
    if (specialization == null) {
      return const SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Current Area: ${specialization.area}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor.withOpacity(0.1),
                Theme.of(context).primaryColor.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      specialization.icon,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          specialization.specialty,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          specialization.description,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Price modifiers
              if (specialization.priceModifiers.isNotEmpty) ...[
                Text(
                  'Price Bonuses:',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: specialization.priceModifiers.entries.map((entry) {
                    final multiplier = entry.value;
                    final isBonus = multiplier > 1.0;
                    final percentage = ((multiplier - 1) * 100).round().abs();
                    
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isBonus ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isBonus ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        '${entry.key}: ${isBonus ? '+' : '-'}$percentage%',
                        style: TextStyle(
                          fontSize: 12,
                          color: isBonus ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsSection(
    BuildContext context,
    List<Achievement> allAchievements,
    Set<String> unlockedIds,
  ) {
    final unlockedCount = unlockedIds.length;
    final totalCount = allAchievements.length;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Achievements',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$unlockedCount / $totalCount',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        
        // Progress bar
        LinearProgressIndicator(
          value: totalCount > 0 ? unlockedCount / totalCount : 0,
          backgroundColor: Colors.grey.withOpacity(0.3),
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).primaryColor,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Achievement grid - Make it more compact and prevent overflow
        LayoutBuilder(
          builder: (context, constraints) {
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: constraints.maxWidth > 600 ? 3 : 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 2.5, // Reduced from 3 to make cards shorter
              ),
              itemCount: allAchievements.length,
              itemBuilder: (context, index) {
                final achievement = allAchievements[index];
                final isUnlocked = unlockedIds.contains(achievement.id);
                
                return _buildAchievementCard(context, achievement, isUnlocked);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildAchievementCard(
    BuildContext context,
    Achievement achievement,
    bool isUnlocked,
  ) {
    return Container(
      padding: const EdgeInsets.all(8), // Reduced padding from 12 to 8
      decoration: BoxDecoration(
        color: isUnlocked 
          ? Theme.of(context).primaryColor.withOpacity(0.1)
          : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6), // Reduced border radius
        border: Border.all(
          color: isUnlocked 
            ? Theme.of(context).primaryColor.withOpacity(0.3)
            : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 24, // Reduced from 32 to 24
            height: 24, // Reduced from 32 to 24
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isUnlocked 
                ? Theme.of(context).primaryColor
                : Colors.grey,
            ),
            child: Center(
              child: Text(
                achievement.icon,
                style: const TextStyle(fontSize: 12), // Reduced from 16 to 12
              ),
            ),
          ),
          const SizedBox(width: 8), // Reduced from 12 to 8
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  achievement.title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith( // Changed from bodyMedium to bodySmall
                    fontWeight: FontWeight.bold,
                    color: isUnlocked ? null : Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1), // Reduced from 2 to 1
                Text(
                  achievement.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isUnlocked ? null : Colors.grey,
                    fontSize: 10, // Even smaller font for description
                  ),
                  maxLines: 1, // Reduced from 2 to 1
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (isUnlocked)
            Icon(
              Icons.check_circle,
              color: Theme.of(context).primaryColor,
              size: 16, // Reduced from 20 to 16
            ),
        ],
      ),
    );
  }
}
