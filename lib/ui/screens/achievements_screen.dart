import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../systems/meta_features_manager.dart';
import '../../data/customization_models.dart';
import '../../data/expanded_constants.dart';
import '../../theme/app_theme.dart';

class AchievementsScreen extends ConsumerStatefulWidget {
  const AchievementsScreen({super.key});

  @override
  ConsumerState<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends ConsumerState<AchievementsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: ACHIEVEMENT_CATEGORIES.length + 1, vsync: this);
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
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: Text('Achievements', style: AppTheme.heading.copyWith(fontSize: 20)),
        backgroundColor: AppTheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: AppTheme.gold),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppTheme.gold,
          indicatorWeight: 3,
          labelColor: AppTheme.gold,
          unselectedLabelColor: Colors.white54,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: [
            const Tab(text: 'All'),
            ...ACHIEVEMENT_CATEGORIES.map((cat) => Tab(text: cat)),
          ],
          onTap: (index) {
            setState(() {
              _selectedCategory =
                  index == 0 ? 'All' : ACHIEVEMENT_CATEGORIES[index - 1];
            });
          },
        ),
      ),
      body: Column(
        children: [
          _buildProgressOverview(metaState),
          if (_getRecentAchievements(metaState).isNotEmpty)
            _buildRecentSection(metaState),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: achievements.length,
              itemBuilder: (context, index) =>
                  _buildAchievementCard(achievements[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressOverview(MetaFeaturesState metaState) {
    final progress =
        ref.read(metaFeaturesProvider.notifier).getOverallProgress();
    final unlocked = _getUnlockedCount(metaState.achievements);
    final total = metaState.achievements.length;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.gold.withAlpha(80)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Overall Progress',
                    style: AppTheme.heading.copyWith(fontSize: 15)),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.white10,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(AppTheme.gold),
                  ),
                ),
                const SizedBox(height: 6),
                Text('$unlocked / $total Unlocked',
                    style: AppTheme.body.copyWith(
                        fontSize: 12, color: Colors.white60)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                  color: AppTheme.gold,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.star, color: AppTheme.bg, size: 22),
              ),
              const SizedBox(height: 6),
              Text('Level ${metaState.prestigeLevel}',
                  style: AppTheme.body
                      .copyWith(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSection(MetaFeaturesState metaState) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.gold.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.gold.withAlpha(60)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.new_releases, color: AppTheme.gold, size: 18),
              const SizedBox(width: 8),
              Text('Recent Achievements',
                  style: AppTheme.heading
                      .copyWith(fontSize: 13, color: AppTheme.gold)),
            ],
          ),
          const SizedBox(height: 8),
          ..._getRecentAchievements(metaState).take(3).map((a) => Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text('• ${a.name}',
                    style: AppTheme.body.copyWith(fontSize: 12)),
              )),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(Achievement achievement) {
    final unlocked = achievement.isUnlocked;
    final progress = achievement.progress;
    final rColor = _getRarityColor(achievement.rarity);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: unlocked ? AppTheme.surface : AppTheme.surface.withAlpha(120),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: unlocked ? rColor : Colors.white12,
          width: unlocked ? 1.5 : 1,
        ),
        boxShadow: unlocked
            ? [BoxShadow(color: rColor.withAlpha(50), blurRadius: 8, offset: const Offset(0, 3))]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: unlocked ? rColor : Colors.grey[700],
                shape: BoxShape.circle,
              ),
              child: Icon(_getAchievementIcon(achievement.category),
                  color: Colors.white, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(achievement.name,
                            style: AppTheme.heading.copyWith(
                                fontSize: 14,
                                color: unlocked ? Colors.white : Colors.grey)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: rColor.withAlpha(unlocked ? 200 : 80),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(achievement.rarity.toUpperCase(),
                            style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    achievement.isHidden && !unlocked
                        ? 'Hidden Achievement'
                        : achievement.description,
                    style: AppTheme.body.copyWith(
                        fontSize: 11,
                        color: unlocked ? Colors.white70 : Colors.grey),
                  ),
                  if (!unlocked && progress > 0) ...[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 5,
                        backgroundColor: Colors.white10,
                        valueColor: AlwaysStoppedAnimation<Color>(rColor),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text('${(progress * 100).toInt()}% Complete',
                        style: AppTheme.body.copyWith(fontSize: 10)),
                  ],
                  if (unlocked && achievement.unlockedDate != null) ...[
                    const SizedBox(height: 4),
                    Text(
                        'Unlocked: ${_formatDate(achievement.unlockedDate!)}',
                        style: AppTheme.body
                            .copyWith(fontSize: 10, color: AppTheme.accent)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Achievement> _getFilteredAchievements(
      Map<String, Achievement> achievements) {
    final list = achievements.values.toList();
    if (_selectedCategory == 'All') return list;
    return list.where((a) => a.category == _selectedCategory).toList();
  }

  List<Achievement> _getRecentAchievements(MetaFeaturesState metaState) {
    return ref.read(metaFeaturesProvider.notifier).getRecentAchievements();
  }

  int _getUnlockedCount(Map<String, Achievement> achievements) {
    return achievements.values.where((a) => a.isUnlocked).length;
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
        return AppTheme.gold;
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
