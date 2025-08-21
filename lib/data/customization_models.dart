// Customization & Meta Features Models
import 'package:flutter/foundation.dart';

@immutable
class UITheme {
  final String id;
  final String name;
  final String style; // '80s_neon', 'modern_dark', 'classic', 'cyberpunk'
  final Map<String, String> colors;
  final Map<String, String> fonts;
  final Map<String, double> animations;
  final List<String> soundEffects;
  final bool isUnlocked;
  final int unlockCost;

  const UITheme({
    required this.id,
    required this.name,
    required this.style,
    required this.colors,
    required this.fonts,
    required this.animations,
    required this.soundEffects,
    this.isUnlocked = false,
    this.unlockCost = 0,
  });

  UITheme copyWith({
    String? id,
    String? name,
    String? style,
    Map<String, String>? colors,
    Map<String, String>? fonts,
    Map<String, double>? animations,
    List<String>? soundEffects,
    bool? isUnlocked,
    int? unlockCost,
  }) {
    return UITheme(
      id: id ?? this.id,
      name: name ?? this.name,
      style: style ?? this.style,
      colors: colors ?? this.colors,
      fonts: fonts ?? this.fonts,
      animations: animations ?? this.animations,
      soundEffects: soundEffects ?? this.soundEffects,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockCost: unlockCost ?? this.unlockCost,
    );
  }
}

@immutable
class DifficultySettings {
  final String preset; // 'casual', 'normal', 'hard', 'expert', 'custom'
  final Map<String, double> modifiers;
  final Map<String, bool> features;
  final double aiAggression;
  final double marketVolatility;
  final double lawEnforcementPresence;
  final double economicChallenge;
  final bool permadeath;

  const DifficultySettings({
    required this.preset,
    required this.modifiers,
    required this.features,
    required this.aiAggression,
    required this.marketVolatility,
    required this.lawEnforcementPresence,
    required this.economicChallenge,
    this.permadeath = false,
  });

  DifficultySettings copyWith({
    String? preset,
    Map<String, double>? modifiers,
    Map<String, bool>? features,
    double? aiAggression,
    double? marketVolatility,
    double? lawEnforcementPresence,
    double? economicChallenge,
    bool? permadeath,
  }) {
    return DifficultySettings(
      preset: preset ?? this.preset,
      modifiers: modifiers ?? this.modifiers,
      features: features ?? this.features,
      aiAggression: aiAggression ?? this.aiAggression,
      marketVolatility: marketVolatility ?? this.marketVolatility,
      lawEnforcementPresence: lawEnforcementPresence ?? this.lawEnforcementPresence,
      economicChallenge: economicChallenge ?? this.economicChallenge,
      permadeath: permadeath ?? this.permadeath,
    );
  }
}

@immutable
class ContentFilters {
  final bool familyFriendlyMode;
  final bool reduceViolence;
  final bool removeDrugsReferences;
  final bool simplifyEconomics;
  final bool educationalMode;
  final Map<String, bool> specificFilters;
  final String alternativeNarrative; // if family-friendly

  const ContentFilters({
    this.familyFriendlyMode = false,
    this.reduceViolence = false,
    this.removeDrugsReferences = false,
    this.simplifyEconomics = false,
    this.educationalMode = false,
    required this.specificFilters,
    this.alternativeNarrative = '',
  });

  ContentFilters copyWith({
    bool? familyFriendlyMode,
    bool? reduceViolence,
    bool? removeDrugsReferences,
    bool? simplifyEconomics,
    bool? educationalMode,
    Map<String, bool>? specificFilters,
    String? alternativeNarrative,
  }) {
    return ContentFilters(
      familyFriendlyMode: familyFriendlyMode ?? this.familyFriendlyMode,
      reduceViolence: reduceViolence ?? this.reduceViolence,
      removeDrugsReferences: removeDrugsReferences ?? this.removeDrugsReferences,
      simplifyEconomics: simplifyEconomics ?? this.simplifyEconomics,
      educationalMode: educationalMode ?? this.educationalMode,
      specificFilters: specificFilters ?? this.specificFilters,
      alternativeNarrative: alternativeNarrative ?? this.alternativeNarrative,
    );
  }
}

@immutable
class AccessibilityFeatures {
  final bool colorBlindSupport;
  final bool highContrast;
  final bool largeText;
  final bool screenReader;
  final bool subtitles;
  final bool soundVisualizations;
  final bool motorAssistance;
  final Map<String, String> keyBindings;
  final double textSize;
  final String colorPalette;

  const AccessibilityFeatures({
    this.colorBlindSupport = false,
    this.highContrast = false,
    this.largeText = false,
    this.screenReader = false,
    this.subtitles = false,
    this.soundVisualizations = false,
    this.motorAssistance = false,
    required this.keyBindings,
    this.textSize = 1.0,
    this.colorPalette = 'default',
  });

  AccessibilityFeatures copyWith({
    bool? colorBlindSupport,
    bool? highContrast,
    bool? largeText,
    bool? screenReader,
    bool? subtitles,
    bool? soundVisualizations,
    bool? motorAssistance,
    Map<String, String>? keyBindings,
    double? textSize,
    String? colorPalette,
  }) {
    return AccessibilityFeatures(
      colorBlindSupport: colorBlindSupport ?? this.colorBlindSupport,
      highContrast: highContrast ?? this.highContrast,
      largeText: largeText ?? this.largeText,
      screenReader: screenReader ?? this.screenReader,
      subtitles: subtitles ?? this.subtitles,
      soundVisualizations: soundVisualizations ?? this.soundVisualizations,
      motorAssistance: motorAssistance ?? this.motorAssistance,
      keyBindings: keyBindings ?? this.keyBindings,
      textSize: textSize ?? this.textSize,
      colorPalette: colorPalette ?? this.colorPalette,
    );
  }
}

@immutable
class Achievement {
  final String id;
  final String name;
  final String description;
  final String category; // 'progress', 'challenge', 'secret', 'social'
  final String rarity; // 'common', 'uncommon', 'rare', 'epic', 'legendary'
  final Map<String, dynamic> criteria;
  final Map<String, dynamic> rewards;
  final DateTime? unlockedDate;
  final bool isUnlocked;
  final double progress; // 0.0 to 1.0
  final bool isHidden;

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.rarity,
    required this.criteria,
    required this.rewards,
    this.unlockedDate,
    this.isUnlocked = false,
    this.progress = 0.0,
    this.isHidden = false,
  });

  Achievement copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? rarity,
    Map<String, dynamic>? criteria,
    Map<String, dynamic>? rewards,
    DateTime? unlockedDate,
    bool? isUnlocked,
    double? progress,
    bool? isHidden,
  }) {
    return Achievement(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      rarity: rarity ?? this.rarity,
      criteria: criteria ?? this.criteria,
      rewards: rewards ?? this.rewards,
      unlockedDate: unlockedDate ?? this.unlockedDate,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      progress: progress ?? this.progress,
      isHidden: isHidden ?? this.isHidden,
    );
  }
}

@immutable
class GameStatistics {
  final Map<String, int> lifetimeStats;
  final Map<String, double> averages;
  final Map<String, DateTime> firstAchievements;
  final Map<String, int> recordsSet;
  final int totalPlaytime; // minutes
  final int totalGamesSaved;
  final DateTime firstPlay;
  final DateTime lastPlay;
  final Map<String, int> choicesMade;

  const GameStatistics({
    required this.lifetimeStats,
    required this.averages,
    required this.firstAchievements,
    required this.recordsSet,
    required this.totalPlaytime,
    required this.totalGamesSaved,
    required this.firstPlay,
    required this.lastPlay,
    required this.choicesMade,
  });

  GameStatistics copyWith({
    Map<String, int>? lifetimeStats,
    Map<String, double>? averages,
    Map<String, DateTime>? firstAchievements,
    Map<String, int>? recordsSet,
    int? totalPlaytime,
    int? totalGamesSaved,
    DateTime? firstPlay,
    DateTime? lastPlay,
    Map<String, int>? choicesMade,
  }) {
    return GameStatistics(
      lifetimeStats: lifetimeStats ?? this.lifetimeStats,
      averages: averages ?? this.averages,
      firstAchievements: firstAchievements ?? this.firstAchievements,
      recordsSet: recordsSet ?? this.recordsSet,
      totalPlaytime: totalPlaytime ?? this.totalPlaytime,
      totalGamesSaved: totalGamesSaved ?? this.totalGamesSaved,
      firstPlay: firstPlay ?? this.firstPlay,
      lastPlay: lastPlay ?? this.lastPlay,
      choicesMade: choicesMade ?? this.choicesMade,
    );
  }
}

@immutable
class PhotoMode {
  final bool enabled;
  final Map<String, String> filters;
  final Map<String, double> cameraSettings;
  final List<String> poses;
  final List<String> backgrounds;
  final Map<String, bool> effects;
  final String watermark;

  const PhotoMode({
    this.enabled = false,
    required this.filters,
    required this.cameraSettings,
    required this.poses,
    required this.backgrounds,
    required this.effects,
    this.watermark = '',
  });

  PhotoMode copyWith({
    bool? enabled,
    Map<String, String>? filters,
    Map<String, double>? cameraSettings,
    List<String>? poses,
    List<String>? backgrounds,
    Map<String, bool>? effects,
    String? watermark,
  }) {
    return PhotoMode(
      enabled: enabled ?? this.enabled,
      filters: filters ?? this.filters,
      cameraSettings: cameraSettings ?? this.cameraSettings,
      poses: poses ?? this.poses,
      backgrounds: backgrounds ?? this.backgrounds,
      effects: effects ?? this.effects,
      watermark: watermark ?? this.watermark,
    );
  }
}

@immutable
class CommunityHub {
  final bool shareStrategies;
  final bool shareStories;
  final bool leaderboards;
  final bool seasonalEvents;
  final Map<String, dynamic> sharedContent;
  final List<String> friends;
  final Map<String, int> reputation;

  const CommunityHub({
    this.shareStrategies = false,
    this.shareStories = false,
    this.leaderboards = false,
    this.seasonalEvents = false,
    required this.sharedContent,
    required this.friends,
    required this.reputation,
  });

  CommunityHub copyWith({
    bool? shareStrategies,
    bool? shareStories,
    bool? leaderboards,
    bool? seasonalEvents,
    Map<String, dynamic>? sharedContent,
    List<String>? friends,
    Map<String, int>? reputation,
  }) {
    return CommunityHub(
      shareStrategies: shareStrategies ?? this.shareStrategies,
      shareStories: shareStories ?? this.shareStories,
      leaderboards: leaderboards ?? this.leaderboards,
      seasonalEvents: seasonalEvents ?? this.seasonalEvents,
      sharedContent: sharedContent ?? this.sharedContent,
      friends: friends ?? this.friends,
      reputation: reputation ?? this.reputation,
    );
  }
}
