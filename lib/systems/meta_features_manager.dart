// Achievement and Meta Features System
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/customization_models.dart';
import '../data/expanded_constants.dart';

class MetaFeaturesState {
  final Map<String, Achievement> achievements;
  final GameStatistics statistics;
  final UITheme currentTheme;
  final DifficultySettings difficulty;
  final ContentFilters contentFilters;
  final AccessibilityFeatures accessibility;
  final PhotoMode photoMode;
  final CommunityHub communityHub;
  final Map<String, bool> unlockedFeatures;
  final int prestigeLevel;
  final Map<String, dynamic> gameSettings;

  const MetaFeaturesState({
    required this.achievements,
    required this.statistics,
    required this.currentTheme,
    required this.difficulty,
    required this.contentFilters,
    required this.accessibility,
    required this.photoMode,
    required this.communityHub,
    required this.unlockedFeatures,
    this.prestigeLevel = 0,
    required this.gameSettings,
  });

  MetaFeaturesState copyWith({
    Map<String, Achievement>? achievements,
    GameStatistics? statistics,
    UITheme? currentTheme,
    DifficultySettings? difficulty,
    ContentFilters? contentFilters,
    AccessibilityFeatures? accessibility,
    PhotoMode? photoMode,
    CommunityHub? communityHub,
    Map<String, bool>? unlockedFeatures,
    int? prestigeLevel,
    Map<String, dynamic>? gameSettings,
  }) {
    return MetaFeaturesState(
      achievements: achievements ?? this.achievements,
      statistics: statistics ?? this.statistics,
      currentTheme: currentTheme ?? this.currentTheme,
      difficulty: difficulty ?? this.difficulty,
      contentFilters: contentFilters ?? this.contentFilters,
      accessibility: accessibility ?? this.accessibility,
      photoMode: photoMode ?? this.photoMode,
      communityHub: communityHub ?? this.communityHub,
      unlockedFeatures: unlockedFeatures ?? this.unlockedFeatures,
      prestigeLevel: prestigeLevel ?? this.prestigeLevel,
      gameSettings: gameSettings ?? this.gameSettings,
    );
  }
}

class MetaFeaturesManager extends StateNotifier<MetaFeaturesState> {
  MetaFeaturesManager() : super(_createInitialState());

  static MetaFeaturesState _createInitialState() {
    return MetaFeaturesState(
      achievements: _createInitialAchievements(),
      statistics: GameStatistics(
        lifetimeStats: {
          'total_money_earned': 0,
          'total_deals_made': 0,
          'total_arrests': 0,
          'total_escapes': 0,
          'cities_unlocked': 1,
          'businesses_established': 0,
        },
        averages: {
          'average_profit_per_deal': 0.0,
          'average_game_length': 0.0,
          'success_rate': 0.0,
        },
        firstAchievements: {},
        recordsSet: {
          'highest_net_worth': 0,
          'longest_survival': 0,
          'biggest_single_deal': 0,
        },
        totalPlaytime: 0,
        totalGamesSaved: 0,
        firstPlay: DateTime.now(),
        lastPlay: DateTime.now(),
        choicesMade: {},
      ),
      currentTheme: AVAILABLE_THEMES.first,
      difficulty: const DifficultySettings(
        preset: 'normal',
        modifiers: {
          'price_volatility': 1.0,
          'law_enforcement': 1.0,
          'market_demand': 1.0,
        },
        features: {
          'permadeath': false,
          'realistic_economy': true,
          'random_events': true,
        },
        aiAggression: 1.0,
        marketVolatility: 1.0,
        lawEnforcementPresence: 1.0,
        economicChallenge: 1.0,
      ),
      contentFilters: const ContentFilters(
        specificFilters: {
          'explicit_content': false,
          'violence_filter': false,
          'drug_references': false,
        },
      ),
      accessibility: const AccessibilityFeatures(
        keyBindings: {
          'move_up': 'W',
          'move_down': 'S',
          'move_left': 'A',
          'move_right': 'D',
          'confirm': 'Enter',
          'cancel': 'Escape',
        },
      ),
      photoMode: const PhotoMode(
        filters: {
          'vintage': 'sepia tone effect',
          'noir': 'black and white high contrast',
          'neon': 'enhanced neon lighting',
        },
        cameraSettings: {
          'zoom': 1.0,
          'angle': 0.0,
          'exposure': 0.0,
        },
        poses: ['standard', 'confident', 'intimidating', 'casual'],
        backgrounds: ['city', 'office', 'warehouse', 'street'],
        effects: {
          'motion_blur': false,
          'depth_of_field': false,
          'lighting_effects': true,
        },
      ),
      communityHub: const CommunityHub(
        sharedContent: {},
        friends: [],
        reputation: {
          'helpful_posts': 0,
          'strategy_shares': 0,
          'community_rating': 0,
        },
      ),
      unlockedFeatures: {
        'basic_trading': true,
        'character_creation': true,
        'save_system': true,
      },
      gameSettings: {
        'auto_save': true,
        'sound_enabled': true,
        'music_enabled': true,
        'notifications': true,
        'analytics': false,
      },
    );
  }

  static Map<String, Achievement> _createInitialAchievements() {
    final achievements = <String, Achievement>{};
    
    // First Steps Achievements
    achievements['first_deal'] = const Achievement(
      id: 'first_deal',
      name: 'First Deal',
      description: 'Complete your first drug transaction',
      category: 'First Steps',
      rarity: 'common',
      criteria: {'deals_completed': 1},
      rewards: {'experience': 100, 'reputation': 10},
    );

    achievements['first_arrest'] = const Achievement(
      id: 'first_arrest',
      name: 'First Bust',
      description: 'Get arrested for the first time',
      category: 'First Steps',
      rarity: 'common',
      criteria: {'arrests': 1},
      rewards: {'experience': 50, 'street_cred': 25},
    );

    // Business Milestones
    achievements['millionaire'] = const Achievement(
      id: 'millionaire',
      name: 'Millionaire',
      description: 'Accumulate a net worth of \$1,000,000',
      category: 'Business Milestones',
      rarity: 'uncommon',
      criteria: {'net_worth': 1000000},
      rewards: {'prestige_points': 100, 'unlock_feature': 'advanced_investments'},
    );

    achievements['empire_builder'] = const Achievement(
      id: 'empire_builder',
      name: 'Empire Builder',
      description: 'Own 10 legitimate businesses',
      category: 'Business Milestones',
      rarity: 'rare',
      criteria: {'legitimate_businesses': 10},
      rewards: {'prestige_points': 250, 'unlock_feature': 'political_influence'},
    );

    // Criminal Achievements
    achievements['untouchable'] = const Achievement(
      id: 'untouchable',
      name: 'Untouchable',
      description: 'Survive 365 days without getting arrested',
      category: 'Criminal Achievements',
      rarity: 'epic',
      criteria: {'days_without_arrest': 365},
      rewards: {'prestige_points': 500, 'unlock_feature': 'witness_protection'},
    );

    achievements['cartel_connections'] = const Achievement(
      id: 'cartel_connections',
      name: 'Cartel Connections',
      description: 'Establish international smuggling routes',
      category: 'Criminal Achievements',
      rarity: 'rare',
      criteria: {'international_routes': 3},
      rewards: {'prestige_points': 200, 'unlock_city': 'colombia'},
    );

    // Social Impact
    achievements['community_helper'] = const Achievement(
      id: 'community_helper',
      name: 'Community Helper',
      description: 'Donate \$500,000 to charity',
      category: 'Social Impact',
      rarity: 'uncommon',
      criteria: {'charity_donations': 500000},
      rewards: {'reputation_boost': 50, 'community_standing': 25},
    );

    achievements['rehabilitation_supporter'] = const Achievement(
      id: 'rehabilitation_supporter',
      name: 'Rehabilitation Supporter',
      description: 'Fund 5 rehabilitation programs',
      category: 'Social Impact',
      rarity: 'rare',
      criteria: {'rehab_programs_funded': 5},
      rewards: {'prestige_points': 150, 'karma_bonus': 100},
    );

    // Technical Mastery
    achievements['cyber_criminal'] = const Achievement(
      id: 'cyber_criminal',
      name: 'Cyber Criminal',
      description: 'Successfully complete 50 hacking minigames',
      category: 'Technical Mastery',
      rarity: 'rare',
      criteria: {'hacking_successes': 50},
      rewards: {'prestige_points': 200, 'unlock_feature': 'advanced_hacking'},
    );

    achievements['logistics_master'] = const Achievement(
      id: 'logistics_master',
      name: 'Logistics Master',
      description: 'Optimize 10 supply chains to 95% efficiency',
      category: 'Technical Mastery',
      rarity: 'epic',
      criteria: {'optimized_supply_chains': 10},
      rewards: {'prestige_points': 300, 'efficiency_bonus': 0.2},
    );

    // Hidden Secrets
    achievements['time_traveler'] = const Achievement(
      id: 'time_traveler',
      name: 'Time Traveler',
      description: 'Experience all three time periods',
      category: 'Hidden Secrets',
      rarity: 'legendary',
      criteria: {'time_periods_experienced': 3},
      rewards: {'prestige_points': 1000, 'unlock_feature': 'time_manipulation'},
      isHidden: true,
    );

    achievements['kingpin'] = const Achievement(
      id: 'kingpin',
      name: 'Kingpin',
      description: 'Control drug markets in all major cities',
      category: 'Hidden Secrets',
      rarity: 'legendary',
      criteria: {'cities_dominated': 7},
      rewards: {'prestige_points': 2000, 'unlock_ending': 'criminal_mastermind'},
      isHidden: true,
    );

    return achievements;
  }

  // Achievement checking and unlocking
  void checkAchievements(Map<String, dynamic> gameState) {
    final updatedAchievements = <String, Achievement>{};
    bool hasNewAchievements = false;

    for (final achievement in state.achievements.values) {
      if (achievement.isUnlocked) {
        updatedAchievements[achievement.id] = achievement;
        continue;
      }

      bool criteriasMet = true;
      double progress = 0.0;
      int totalCriteria = achievement.criteria.length;
      int metCriteria = 0;

      for (final entry in achievement.criteria.entries) {
        final criterion = entry.key;
        final requiredValue = entry.value;
        final currentValue = gameState[criterion] ?? 0;

        if (currentValue is num && requiredValue is num) {
          if (currentValue >= requiredValue) {
            metCriteria++;
          }
          progress += (currentValue / requiredValue).clamp(0.0, 1.0);
        }
      }

      final finalProgress = progress / totalCriteria;
      criteriasMet = metCriteria == totalCriteria;

      if (criteriasMet && !achievement.isUnlocked) {
        // Achievement unlocked!
        final unlockedAchievement = achievement.copyWith(
          isUnlocked: true,
          unlockedDate: DateTime.now(),
          progress: 1.0,
        );
        updatedAchievements[achievement.id] = unlockedAchievement;
        hasNewAchievements = true;
        
        _applyAchievementRewards(achievement);
        _recordFirstAchievement(achievement);
      } else {
        final updatedAchievement = achievement.copyWith(
          progress: finalProgress,
        );
        updatedAchievements[achievement.id] = updatedAchievement;
      }
    }

    if (hasNewAchievements) {
      state = state.copyWith(achievements: updatedAchievements);
    }
  }

  void _applyAchievementRewards(Achievement achievement) {
    // Apply rewards from achievement
    final rewards = achievement.rewards;
    
    if (rewards.containsKey('unlock_feature')) {
      final feature = rewards['unlock_feature'] as String;
      state = state.copyWith(
        unlockedFeatures: {...state.unlockedFeatures, feature: true},
      );
    }
    
    if (rewards.containsKey('prestige_points')) {
      // final points = rewards['prestige_points'] as int;
      // This would be handled by another system that manages prestige points
    }
  }

  void _recordFirstAchievement(Achievement achievement) {
    final updatedFirstAchievements = Map<String, DateTime>.from(state.statistics.firstAchievements);
    
    if (!updatedFirstAchievements.containsKey(achievement.category)) {
      updatedFirstAchievements[achievement.category] = DateTime.now();
      
      final updatedStats = state.statistics.copyWith(
        firstAchievements: updatedFirstAchievements,
      );
      
      state = state.copyWith(statistics: updatedStats);
    }
  }

  // Statistics tracking
  void updateStatistic(String statName, dynamic value) {
    final updatedLifetimeStats = Map<String, int>.from(state.statistics.lifetimeStats);
    final updatedRecords = Map<String, int>.from(state.statistics.recordsSet);
    
    if (value is int) {
      updatedLifetimeStats[statName] = (updatedLifetimeStats[statName] ?? 0) + value;
      
      // Check for new records
      if (statName.startsWith('highest_') || statName.startsWith('biggest_') || statName.startsWith('longest_')) {
        final currentRecord = updatedRecords[statName] ?? 0;
        if (value > currentRecord) {
          updatedRecords[statName] = value;
        }
      }
    }
    
    final updatedStats = state.statistics.copyWith(
      lifetimeStats: updatedLifetimeStats,
      recordsSet: updatedRecords,
      lastPlay: DateTime.now(),
    );
    
    state = state.copyWith(statistics: updatedStats);
  }

  // Theme management
  void changeTheme(String themeId) {
    final theme = AVAILABLE_THEMES.where((t) => t.id == themeId).firstOrNull;
    if (theme != null && theme.isUnlocked) {
      state = state.copyWith(currentTheme: theme);
    }
  }

  void unlockTheme(String themeId) {
    // This would be called when conditions are met
    final updatedFeatures = Map<String, bool>.from(state.unlockedFeatures);
    updatedFeatures['theme_$themeId'] = true;
    
    state = state.copyWith(unlockedFeatures: updatedFeatures);
  }

  // Difficulty settings
  void updateDifficulty(DifficultySettings newDifficulty) {
    state = state.copyWith(difficulty: newDifficulty);
  }

  // Content filters
  void updateContentFilters(ContentFilters newFilters) {
    state = state.copyWith(contentFilters: newFilters);
  }

  // Accessibility
  void updateAccessibility(AccessibilityFeatures newAccessibility) {
    state = state.copyWith(accessibility: newAccessibility);
  }

  // Game settings
  void updateGameSetting(String settingName, dynamic value) {
    final updatedSettings = Map<String, dynamic>.from(state.gameSettings);
    updatedSettings[settingName] = value;
    
    state = state.copyWith(gameSettings: updatedSettings);
  }

  // Photo mode
  void enablePhotoMode() {
    state = state.copyWith(
      photoMode: state.photoMode.copyWith(enabled: true),
    );
  }

  void updatePhotoSettings(Map<String, dynamic> settings) {
    PhotoMode updatedPhotoMode = state.photoMode;
    
    if (settings.containsKey('filter')) {
      // Would update filter settings
    }
    
    if (settings.containsKey('camera')) {
      final cameraSettings = Map<String, double>.from(state.photoMode.cameraSettings);
      final newCameraSettings = settings['camera'] as Map<String, double>;
      cameraSettings.addAll(newCameraSettings);
      
      updatedPhotoMode = updatedPhotoMode.copyWith(cameraSettings: cameraSettings);
    }
    
    state = state.copyWith(photoMode: updatedPhotoMode);
  }

  // Community features
  void shareContent(String contentType, Map<String, dynamic> content) {
    final updatedCommunityHub = state.communityHub.copyWith(
      sharedContent: {
        ...state.communityHub.sharedContent,
        '${contentType}_${DateTime.now().millisecondsSinceEpoch}': content,
      },
    );
    
    state = state.copyWith(communityHub: updatedCommunityHub);
  }

  // Prestige system
  void prestige() {
    // Reset some progress but keep certain unlocks
    state = state.copyWith(
      prestigeLevel: state.prestigeLevel + 1,
    );
  }

  Map<String, Achievement> getAchievementsByCategory(String category) {
    return Map.fromEntries(
      state.achievements.entries.where((entry) => entry.value.category == category),
    );
  }

  List<Achievement> getRecentAchievements({int limit = 5}) {
    final unlockedAchievements = state.achievements.values
        .where((achievement) => achievement.isUnlocked)
        .toList();
    
    unlockedAchievements.sort((a, b) {
      if (a.unlockedDate == null || b.unlockedDate == null) return 0;
      return b.unlockedDate!.compareTo(a.unlockedDate!);
    });
    
    return unlockedAchievements.take(limit).toList();
  }

  double getOverallProgress() {
    final totalAchievements = state.achievements.length;
    final unlockedAchievements = state.achievements.values
        .where((achievement) => achievement.isUnlocked)
        .length;
    
    return totalAchievements > 0 ? unlockedAchievements / totalAchievements : 0.0;
  }
}

final metaFeaturesProvider = StateNotifierProvider<MetaFeaturesManager, MetaFeaturesState>((ref) {
  return MetaFeaturesManager();
});
