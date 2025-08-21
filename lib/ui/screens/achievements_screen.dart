import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../systems/meta_features_manager.dart';
import '../../data/customization_models.dart';
import '../../data/expanded_constants.dart';
import '../../theme/app_theme.dart';

class AchievementsScreen extends ConsumerStatefulWidget {
  const AchievementsScreen({super.key});

  @override
  ConsumerState<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends ConsumerState<AchievementsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: ACHIEVEMENT_CATEGORIES.length + 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final metaState = ref.watch(metaFeaturesProvider);
    final achievements = _getFilteredAchievements(metaState.achievements);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
        backgroundColor: AppTheme.primaryColor,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppTheme.accentColor,
          tabs: [
            const Tab(text: 'All'),
            ...ACHIEVEMENT_CATEGORIES.map((category) => Tab(text: category)),
          ],
          onTap: (index) {
            setState(() {
              _selectedCategory = index == 0 ? 'All' : ACHIEVEMENT_CATEGORIES[index - 1];
            });
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.backgroundColor, AppTheme.cardColor],
          ),
        ),
        child: Column(
          children: [
            // Progress Overview
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.accentColor, width: 2),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Overall Progress',
                          style: AppTheme.headingStyle.copyWith(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: ref.read(metaFeaturesProvider.notifier).getOverallProgress(),
                          backgroundColor: Colors.grey[700],
                          valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_getUnlockedCount(metaState.achievements)}/${metaState.achievements.length} Unlocked',
                          style: AppTheme.bodyStyle.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.accentColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.star,
                          color: AppTheme.backgroundColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Level ${metaState.prestigeLevel}',
                        style: AppTheme.bodyStyle.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Recent Achievements
            if (_getRecentAchievements(metaState).isNotEmpty) ...[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.primaryColor, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.new_releases, color: AppTheme.primaryColor, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Recent Achievements',
                          style: AppTheme.headingStyle.copyWith(
                            fontSize: 14,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ..._getRecentAchievements(metaState).take(3).map((achievement) => 
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          '• ${achievement.name}',
                          style: AppTheme.bodyStyle.copyWith(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            // Achievements List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: achievements.length,
                itemBuilder: (context, index) {
                  final achievement = achievements[index];
                  return _buildAchievementCard(achievement);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementCard(Achievement achievement) {
    final isUnlocked = achievement.isUnlocked;
    final progress = achievement.progress;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isUnlocked ? AppTheme.cardColor : AppTheme.cardColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnlocked ? _getRarityColor(achievement.rarity) : Colors.grey,
          width: isUnlocked ? 2 : 1,
        ),
        boxShadow: isUnlocked ? [
          BoxShadow(
            color: _getRarityColor(achievement.rarity).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ] : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Achievement Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isUnlocked ? _getRarityColor(achievement.rarity) : Colors.grey,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getAchievementIcon(achievement.category),
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            
            // Achievement Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          achievement.name,
                          style: AppTheme.headingStyle.copyWith(
                            fontSize: 16,
                            color: isUnlocked ? AppTheme.textColor : Colors.grey,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getRarityColor(achievement.rarity),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          achievement.rarity.toUpperCase(),
                          style: AppTheme.bodyStyle.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    achievement.isHidden && !isUnlocked ? 'Hidden Achievement' : achievement.description,
                    style: AppTheme.bodyStyle.copyWith(
                      fontSize: 12,
                      color: isUnlocked ? AppTheme.textColor.withOpacity(0.8) : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Progress Bar (if not unlocked)
                  if (!isUnlocked && progress > 0) ...[
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[700],
                      valueColor: AlwaysStoppedAnimation<Color>(_getRarityColor(achievement.rarity)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(progress * 100).toInt()}% Complete',
                      style: AppTheme.bodyStyle.copyWith(fontSize: 10),
                    ),
                  ],
                  
                  // Unlock Date (if unlocked)
                  if (isUnlocked && achievement.unlockedDate != null) ...[
                    Text(
                      'Unlocked: ${_formatDate(achievement.unlockedDate!)}',
                      style: AppTheme.bodyStyle.copyWith(
                        fontSize: 10,
                        color: AppTheme.accentColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Achievement> _getFilteredAchievements(Map<String, Achievement> achievements) {
    final achievementList = achievements.values.toList();
    
    if (_selectedCategory == 'All') {
      return achievementList;
    }
    
    return achievementList.where((achievement) => achievement.category == _selectedCategory).toList();
  }

  List<Achievement> _getRecentAchievements(MetaFeaturesState metaState) {
    return ref.read(metaFeaturesProvider.notifier).getRecentAchievements();
  }

  int _getUnlockedCount(Map<String, Achievement> achievements) {
    return achievements.values.where((achievement) => achievement.isUnlocked).length;
  }

  Color _getRarityColor(String rarity) {
    switch (rarity) {
      case 'common':
        return Colors.grey;
      case 'uncommon':
        return Colors.green;
      case 'rare':
        return Colors.blue;
      case 'epic':
        return Colors.purple;
      case 'legendary':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getAchievementIcon(String category) {
    switch (category) {
      case 'First Steps':
        return Icons.flag;
      case 'Business Milestones':
        return Icons.business;
      case 'Criminal Achievements':
        return Icons.security;
      case 'Social Impact':
        return Icons.favorite;
      case 'Technical Mastery':
        return Icons.computer;
      case 'Survival Challenges':
        return Icons.shield;
      case 'Hidden Secrets':
        return Icons.visibility_off;
      case 'Community Challenges':
        return Icons.group;
      default:
        return Icons.star;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
