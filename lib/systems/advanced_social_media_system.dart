import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

// Advanced Social Media & Communication System
// Feature #19: Ultra-comprehensive social media platform, messaging systems,
// reputation management, viral campaigns, and digital influence mechanics

enum SocialPlatform {
  streetGram,
  crimeBook,
  dealerTok,
  undergroundForum,
  darkWeb,
  localNews,
  policeBand,
  businessNetwork
}

enum PostType {
  image,
  video,
  text,
  livestream,
  story,
  poll,
  advertisement,
  warning,
  recruitment,
  deal
}

enum MessageType {
  text,
  voice,
  video,
  image,
  location,
  contact,
  encrypted,
  anonymous
}

enum ViralityLevel {
  dead,
  local,
  regional,
  national,
  international,
  legendary
}

enum ReputationCategory {
  street,
  business,
  criminal,
  law_enforcement,
  political,
  celebrity,
  underground
}

class SocialPost {
  final String id;
  final String authorId;
  final SocialPlatform platform;
  final PostType type;
  final String content;
  final List<String> mediaUrls;
  final Map<String, dynamic> metadata;
  final DateTime timestamp;
  final int likes;
  final int shares;
  final int comments;
  final int views;
  final List<String> hashtags;
  final List<String> mentions;
  final ViralityLevel virality;
  final bool isPromoted;
  final Map<String, double> sentimentAnalysis;
  final List<String> reactions;

  SocialPost({
    required this.id,
    required this.authorId,
    required this.platform,
    required this.type,
    required this.content,
    this.mediaUrls = const [],
    this.metadata = const {},
    required this.timestamp,
    this.likes = 0,
    this.shares = 0,
    this.comments = 0,
    this.views = 0,
    this.hashtags = const [],
    this.mentions = const [],
    this.virality = ViralityLevel.dead,
    this.isPromoted = false,
    this.sentimentAnalysis = const {},
    this.reactions = const [],
  });

  SocialPost copyWith({
    String? id,
    String? authorId,
    SocialPlatform? platform,
    PostType? type,
    String? content,
    List<String>? mediaUrls,
    Map<String, dynamic>? metadata,
    DateTime? timestamp,
    int? likes,
    int? shares,
    int? comments,
    int? views,
    List<String>? hashtags,
    List<String>? mentions,
    ViralityLevel? virality,
    bool? isPromoted,
    Map<String, double>? sentimentAnalysis,
    List<String>? reactions,
  }) {
    return SocialPost(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      platform: platform ?? this.platform,
      type: type ?? this.type,
      content: content ?? this.content,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      metadata: metadata ?? this.metadata,
      timestamp: timestamp ?? this.timestamp,
      likes: likes ?? this.likes,
      shares: shares ?? this.shares,
      comments: comments ?? this.comments,
      views: views ?? this.views,
      hashtags: hashtags ?? this.hashtags,
      mentions: mentions ?? this.mentions,
      virality: virality ?? this.virality,
      isPromoted: isPromoted ?? this.isPromoted,
      sentimentAnalysis: sentimentAnalysis ?? this.sentimentAnalysis,
      reactions: reactions ?? this.reactions,
    );
  }

  double get engagementRate => views > 0 ? (likes + shares + comments) / views : 0.0;
  double get viralityScore => (likes * 1.0 + shares * 2.0 + comments * 1.5) / math.max(1, views);
  bool get isViral => viralityScore > 0.1 && views > 1000;
  bool get isTrending => engagementRate > 0.05 && DateTime.now().difference(timestamp).inHours < 24;
}

class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String? groupId;
  final MessageType type;
  final String content;
  final List<String> attachments;
  final DateTime timestamp;
  final bool isRead;
  final bool isEncrypted;
  final bool isAnonymous;
  final Map<String, dynamic> metadata;
  final String? replyToId;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    this.groupId,
    required this.type,
    required this.content,
    this.attachments = const [],
    required this.timestamp,
    this.isRead = false,
    this.isEncrypted = false,
    this.isAnonymous = false,
    this.metadata = const {},
    this.replyToId,
  });

  Message copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? groupId,
    MessageType? type,
    String? content,
    List<String>? attachments,
    DateTime? timestamp,
    bool? isRead,
    bool? isEncrypted,
    bool? isAnonymous,
    Map<String, dynamic>? metadata,
    String? replyToId,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      groupId: groupId ?? this.groupId,
      type: type ?? this.type,
      content: content ?? this.content,
      attachments: attachments ?? this.attachments,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      isEncrypted: isEncrypted ?? this.isEncrypted,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      metadata: metadata ?? this.metadata,
      replyToId: replyToId ?? this.replyToId,
    );
  }
}

class SocialAccount {
  final String id;
  final String userId;
  final SocialPlatform platform;
  final String username;
  final String displayName;
  final String? avatarUrl;
  final String bio;
  final int followers;
  final int following;
  final int posts;
  final bool isVerified;
  final bool isPrivate;
  final Map<String, double> reputationScores;
  final List<String> badges;
  final DateTime joinDate;
  final Map<String, dynamic> analytics;

  SocialAccount({
    required this.id,
    required this.userId,
    required this.platform,
    required this.username,
    required this.displayName,
    this.avatarUrl,
    this.bio = '',
    this.followers = 0,
    this.following = 0,
    this.posts = 0,
    this.isVerified = false,
    this.isPrivate = false,
    this.reputationScores = const {},
    this.badges = const [],
    required this.joinDate,
    this.analytics = const {},
  });

  SocialAccount copyWith({
    String? id,
    String? userId,
    SocialPlatform? platform,
    String? username,
    String? displayName,
    String? avatarUrl,
    String? bio,
    int? followers,
    int? following,
    int? posts,
    bool? isVerified,
    bool? isPrivate,
    Map<String, double>? reputationScores,
    List<String>? badges,
    DateTime? joinDate,
    Map<String, dynamic>? analytics,
  }) {
    return SocialAccount(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      platform: platform ?? this.platform,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      posts: posts ?? this.posts,
      isVerified: isVerified ?? this.isVerified,
      isPrivate: isPrivate ?? this.isPrivate,
      reputationScores: reputationScores ?? this.reputationScores,
      badges: badges ?? this.badges,
      joinDate: joinDate ?? this.joinDate,
      analytics: analytics ?? this.analytics,
    );
  }

  double get engagementRate {
    final totalEngagement = analytics['total_likes'] ?? 0 + analytics['total_shares'] ?? 0;
    return followers > 0 ? totalEngagement / followers : 0.0;
  }

  double get influenceScore {
    final base = followers * 0.1 + posts * 0.05;
    final engagement = engagementRate * 1000;
    final verification = isVerified ? 500 : 0;
    final badges_score = badges.length * 100;
    return base + engagement + verification + badges_score;
  }
}

class ViralCampaign {
  final String id;
  final String name;
  final String description;
  final String targetAudience;
  final List<SocialPlatform> platforms;
  final Map<String, dynamic> content;
  final DateTime startDate;
  final DateTime endDate;
  final double budget;
  final Map<String, int> targets;
  final Map<String, int> results;
  final bool isActive;
  final double successRate;

  ViralCampaign({
    required this.id,
    required this.name,
    required this.description,
    required this.targetAudience,
    this.platforms = const [],
    this.content = const {},
    required this.startDate,
    required this.endDate,
    this.budget = 0.0,
    this.targets = const {},
    this.results = const {},
    this.isActive = false,
    this.successRate = 0.0,
  });
}

class ReputationProfile {
  final String id;
  final String userId;
  final Map<ReputationCategory, double> scores;
  final Map<String, int> mentions;
  final Map<String, double> sentiment;
  final List<String> keywords;
  final Map<String, dynamic> trends;
  final DateTime lastUpdated;

  ReputationProfile({
    required this.id,
    required this.userId,
    this.scores = const {},
    this.mentions = const {},
    this.sentiment = const {},
    this.keywords = const [],
    this.trends = const {},
    required this.lastUpdated,
  });

  double get overallReputation {
    if (scores.isEmpty) return 0.5;
    return scores.values.reduce((a, b) => a + b) / scores.length;
  }

  ReputationCategory get dominantCategory {
    if (scores.isEmpty) return ReputationCategory.street;
    return scores.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }
}

class AdvancedSocialMediaSystem extends ChangeNotifier {
  static final AdvancedSocialMediaSystem _instance = AdvancedSocialMediaSystem._internal();
  factory AdvancedSocialMediaSystem() => _instance;
  AdvancedSocialMediaSystem._internal() {
    _initializeSystem();
  }

  final Map<String, SocialPost> _posts = {};
  final Map<String, Message> _messages = {};
  final Map<String, SocialAccount> _accounts = {};
  final Map<String, ViralCampaign> _campaigns = {};
  final Map<String, ReputationProfile> _reputationProfiles = {};
  
  String? _playerId;
  int _totalPosts = 0;
  int _totalFollowers = 0;
  double _overallInfluence = 0.0;
  double _digitalReputation = 0.5;
  List<String> _trendingHashtags = [];
  
  Timer? _systemTimer;
  final math.Random _random = math.Random();

  // Getters
  Map<String, SocialPost> get posts => Map.unmodifiable(_posts);
  Map<String, Message> get messages => Map.unmodifiable(_messages);
  Map<String, SocialAccount> get accounts => Map.unmodifiable(_accounts);
  Map<String, ViralCampaign> get campaigns => Map.unmodifiable(_campaigns);
  Map<String, ReputationProfile> get reputationProfiles => Map.unmodifiable(_reputationProfiles);
  String? get playerId => _playerId;
  int get totalPosts => _totalPosts;
  int get totalFollowers => _totalFollowers;
  double get overallInfluence => _overallInfluence;
  double get digitalReputation => _digitalReputation;
  List<String> get trendingHashtags => List.unmodifiable(_trendingHashtags);

  void _initializeSystem() {
    _playerId = 'player_${DateTime.now().millisecondsSinceEpoch}';
    _createPlayerAccounts();
    _generateInitialContent();
    _initializeReputationProfile();
    _startSystemTimer();
  }

  void _createPlayerAccounts() {
    final platforms = SocialPlatform.values;
    
    for (final platform in platforms) {
      final accountId = 'account_${platform.name}_${_playerId}';
      _accounts[accountId] = SocialAccount(
        id: accountId,
        userId: _playerId!,
        platform: platform,
        username: _generateUsername(platform),
        displayName: 'Street Entrepreneur',
        bio: _generateBio(platform),
        joinDate: DateTime.now().subtract(Duration(days: _random.nextInt(365))),
      );
    }
  }

  String _generateUsername(SocialPlatform platform) {
    final prefixes = ['street', 'urban', 'city', 'downtown', 'hustle', 'grind'];
    final suffixes = ['king', 'boss', 'pro', 'master', 'elite', 'legend'];
    
    final prefix = prefixes[_random.nextInt(prefixes.length)];
    final suffix = suffixes[_random.nextInt(suffixes.length)];
    final number = _random.nextInt(999);
    
    return '${prefix}_${suffix}$number';
  }

  String _generateBio(SocialPlatform platform) {
    switch (platform) {
      case SocialPlatform.streetGram:
        return '📱 Digital entrepreneur | 💰 Making moves | 🏙️ City life';
      case SocialPlatform.crimeBook:
        return 'Connected across the city. Always looking for opportunities.';
      case SocialPlatform.dealerTok:
        return '🎥 Street content creator | 💯 Authentic hustle';
      case SocialPlatform.undergroundForum:
        return 'Veteran member. Reliable connections. PM for business.';
      case SocialPlatform.darkWeb:
        return 'Secure communications. Verified seller. Clean record.';
      case SocialPlatform.localNews:
        return 'Local business owner and community advocate.';
      case SocialPlatform.policeBand:
        return 'Concerned citizen providing community information.';
      case SocialPlatform.businessNetwork:
        return 'Entrepreneur | Investment opportunities | Networking';
    }
  }

  void _generateInitialContent() {
    // Generate some initial posts for atmosphere
    final contentTemplates = _getContentTemplates();
    
    for (int i = 0; i < 20; i++) {
      final template = contentTemplates[_random.nextInt(contentTemplates.length)];
      _createSystemPost(template);
    }
  }

  List<Map<String, dynamic>> _getContentTemplates() {
    return [
      {
        'platform': SocialPlatform.streetGram,
        'type': PostType.image,
        'content': 'Another day, another hustle 💪 #streetlife #grind',
        'hashtags': ['streetlife', 'grind', 'hustle', 'money'],
      },
      {
        'platform': SocialPlatform.crimeBook,
        'type': PostType.text,
        'content': 'Anyone know what\'s happening on 5th street? Heard there was some action.',
        'hashtags': ['news', 'street', 'info'],
      },
      {
        'platform': SocialPlatform.dealerTok,
        'type': PostType.video,
        'content': 'Street knowledge 101: Always watch your back 👀',
        'hashtags': ['knowledge', 'street', 'tips', 'safe'],
      },
      {
        'platform': SocialPlatform.localNews,
        'type': PostType.text,
        'content': 'Local business community meeting this Thursday. All welcome.',
        'hashtags': ['community', 'business', 'meeting'],
      },
      {
        'platform': SocialPlatform.businessNetwork,
        'type': PostType.text,
        'content': 'Looking for investment partners for new venture. High ROI potential.',
        'hashtags': ['investment', 'business', 'opportunity'],
      },
    ];
  }

  void _createSystemPost(Map<String, dynamic> template) {
    final postId = 'post_${DateTime.now().millisecondsSinceEpoch}_${_random.nextInt(1000)}';
    
    _posts[postId] = SocialPost(
      id: postId,
      authorId: 'system_user_${_random.nextInt(100)}',
      platform: template['platform'],
      type: template['type'],
      content: template['content'],
      timestamp: DateTime.now().subtract(Duration(hours: _random.nextInt(72))),
      hashtags: template['hashtags'] ?? [],
      likes: _random.nextInt(100),
      shares: _random.nextInt(20),
      comments: _random.nextInt(50),
      views: _random.nextInt(1000) + 100,
    );
    
    _totalPosts++;
  }

  void _initializeReputationProfile() {
    final profileId = 'rep_${_playerId}';
    
    _reputationProfiles[profileId] = ReputationProfile(
      id: profileId,
      userId: _playerId!,
      scores: {
        ReputationCategory.street: 0.5,
        ReputationCategory.business: 0.4,
        ReputationCategory.criminal: 0.3,
        ReputationCategory.law_enforcement: 0.6,
        ReputationCategory.political: 0.4,
        ReputationCategory.celebrity: 0.2,
        ReputationCategory.underground: 0.3,
      },
      lastUpdated: DateTime.now(),
    );
  }

  void _startSystemTimer() {
    _systemTimer?.cancel();
    _systemTimer = Timer.periodic(const Duration(seconds: 8), (_) {
      _updateViralityScores();
      _processMessages();
      _updateReputationScores();
      _generateTrendingContent();
      _updateInfluenceMetrics();
      notifyListeners();
    });
  }

  // Social Media Operations
  String createPost(SocialPlatform platform, PostType type, String content, {
    List<String>? hashtags,
    List<String>? mentions,
    bool isPromoted = false,
  }) {
    final postId = 'post_${DateTime.now().millisecondsSinceEpoch}';
    
    final post = SocialPost(
      id: postId,
      authorId: _playerId!,
      platform: platform,
      type: type,
      content: content,
      timestamp: DateTime.now(),
      hashtags: hashtags ?? [],
      mentions: mentions ?? [],
      isPromoted: isPromoted,
    );

    _posts[postId] = post;
    _totalPosts++;

    // Update account posts count
    _updateAccountPosts(platform);
    
    // Process engagement simulation
    _simulateEngagement(postId);
    
    return postId;
  }

  void _updateAccountPosts(SocialPlatform platform) {
    final account = _accounts.values
        .where((acc) => acc.userId == _playerId && acc.platform == platform)
        .firstOrNull;
    
    if (account != null) {
      _accounts[account.id] = account.copyWith(posts: account.posts + 1);
    }
  }

  void _simulateEngagement(String postId) {
    final post = _posts[postId];
    if (post == null) return;

    // Simulate initial engagement based on platform and content
    final baseEngagement = _calculateBaseEngagement(post);
    
    Timer.periodic(const Duration(seconds: 10), (timer) {
      if (timer.tick > 20) {
        timer.cancel();
        return;
      }

      final newLikes = post.likes + _random.nextInt((baseEngagement * 0.1).round() + 1);
      final newShares = post.shares + (_random.nextDouble() < 0.3 ? 1 : 0);
      final newComments = post.comments + (_random.nextDouble() < 0.2 ? 1 : 0);
      final newViews = post.views + _random.nextInt(10) + 1;

      _posts[postId] = post.copyWith(
        likes: newLikes,
        shares: newShares,
        comments: newComments,
        views: newViews,
        virality: _calculateVirality(newLikes, newShares, newComments, newViews),
      );

      if (timer.tick % 5 == 0) {
        notifyListeners();
      }
    });
  }

  int _calculateBaseEngagement(SocialPost post) {
    int base = 10;
    
    // Platform modifier
    switch (post.platform) {
      case SocialPlatform.streetGram:
        base *= 3;
        break;
      case SocialPlatform.dealerTok:
        base *= 5;
        break;
      case SocialPlatform.crimeBook:
        base *= 2;
        break;
      default:
        break;
    }

    // Content type modifier
    switch (post.type) {
      case PostType.video:
        base = (base * 1.5).round();
        break;
      case PostType.image:
        base = (base * 1.2).round();
        break;
      case PostType.livestream:
        base *= 2;
        break;
      default:
        break;
    }

    // Hashtag bonus
    base += post.hashtags.length * 2;
    
    // Promotion bonus
    if (post.isPromoted) {
      base *= 3;
    }

    return base;
  }

  ViralityLevel _calculateVirality(int likes, int shares, int comments, int views) {
    final score = (likes + shares * 2 + comments * 1.5) / math.max(1, views);
    
    if (score > 0.5) return ViralityLevel.legendary;
    if (score > 0.3) return ViralityLevel.international;
    if (score > 0.2) return ViralityLevel.national;
    if (score > 0.1) return ViralityLevel.regional;
    if (score > 0.05) return ViralityLevel.local;
    return ViralityLevel.dead;
  }

  // Messaging System
  String sendMessage(String receiverId, MessageType type, String content, {
    String? groupId,
    bool isEncrypted = false,
    bool isAnonymous = false,
    List<String>? attachments,
  }) {
    final messageId = 'msg_${DateTime.now().millisecondsSinceEpoch}';
    
    final message = Message(
      id: messageId,
      senderId: _playerId!,
      receiverId: receiverId,
      groupId: groupId,
      type: type,
      content: content,
      timestamp: DateTime.now(),
      isEncrypted: isEncrypted,
      isAnonymous: isAnonymous,
      attachments: attachments ?? [],
    );

    _messages[messageId] = message;
    
    // Simulate response for NPCs
    if (receiverId.startsWith('npc_')) {
      _scheduleNPCResponse(messageId, receiverId);
    }
    
    return messageId;
  }

  void _scheduleNPCResponse(String originalMessageId, String npcId) {
    Timer(Duration(seconds: _random.nextInt(30) + 10), () {
      final responseId = 'msg_${DateTime.now().millisecondsSinceEpoch}';
      
      _messages[responseId] = Message(
        id: responseId,
        senderId: npcId,
        receiverId: _playerId!,
        type: MessageType.text,
        content: _generateNPCResponse(npcId),
        timestamp: DateTime.now(),
        replyToId: originalMessageId,
      );
      
      notifyListeners();
    });
  }

  String _generateNPCResponse(String npcId) {
    final responses = [
      'Got it, I\'ll look into that.',
      'Interesting proposition. Let me think about it.',
      'That could work. When do you want to meet?',
      'I\'m not sure about that. Seems risky.',
      'Yeah, I know what you mean.',
      'Let\'s discuss this in person.',
      'I might have something for you.',
      'That\'s not really my thing.',
      'I\'ll get back to you on that.',
      'Sounds like a plan.',
    ];
    
    return responses[_random.nextInt(responses.length)];
  }

  // Viral Campaign System
  String launchViralCampaign(String name, String description, 
                            List<SocialPlatform> platforms, double budget) {
    final campaignId = 'campaign_${DateTime.now().millisecondsSinceEpoch}';
    
    final campaign = ViralCampaign(
      id: campaignId,
      name: name,
      description: description,
      targetAudience: 'Urban demographics 18-35',
      platforms: platforms,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 7)),
      budget: budget,
      targets: {
        'views': (budget * 10).round(),
        'likes': (budget * 2).round(),
        'shares': (budget * 0.5).round(),
      },
      isActive: true,
    );

    _campaigns[campaignId] = campaign;
    
    // Schedule campaign posts
    _scheduleCampaignPosts(campaignId);
    
    return campaignId;
  }

  void _scheduleCampaignPosts(String campaignId) {
    final campaign = _campaigns[campaignId];
    if (campaign == null || !campaign.isActive) return;

    for (final platform in campaign.platforms) {
      Timer.periodic(const Duration(hours: 6), (timer) {
        if (!campaign.isActive || DateTime.now().isAfter(campaign.endDate)) {
          timer.cancel();
          return;
        }

        createPost(
          platform,
          PostType.advertisement,
          campaign.description,
          hashtags: ['campaign', campaign.name.toLowerCase()],
          isPromoted: true,
        );
      });
    }
  }

  // System Updates
  void _updateViralityScores() {
    for (final postId in _posts.keys.toList()) {
      final post = _posts[postId]!;
      
      // Simulate continued engagement
      if (DateTime.now().difference(post.timestamp).inHours < 48) {
        final viralityBonus = post.virality.index * 0.1;
        final newViews = post.views + _random.nextInt((viralityBonus * 10).round() + 1);
        final newLikes = post.likes + (_random.nextDouble() < viralityBonus ? 1 : 0);
        
        _posts[postId] = post.copyWith(
          views: newViews,
          likes: newLikes,
          virality: _calculateVirality(newLikes, post.shares, post.comments, newViews),
        );
      }
    }
  }

  void _processMessages() {
    // Mark some messages as read
    for (final messageId in _messages.keys.toList()) {
      final message = _messages[messageId]!;
      
      if (!message.isRead && 
          message.receiverId == _playerId &&
          DateTime.now().difference(message.timestamp).inMinutes > 5 &&
          _random.nextDouble() < 0.3) {
        _messages[messageId] = message.copyWith(isRead: true);
      }
    }
  }

  void _updateReputationScores() {
    final profile = _reputationProfiles['rep_${_playerId}'];
    if (profile == null) return;

    // Analyze recent posts for reputation impact
    final recentPosts = _posts.values
        .where((post) => post.authorId == _playerId && 
                DateTime.now().difference(post.timestamp).inDays < 7)
        .toList();

    Map<ReputationCategory, double> adjustments = {};

    for (final post in recentPosts) {
      final impact = _analyzePostReputationImpact(post);
      impact.forEach((category, value) {
        adjustments[category] = (adjustments[category] ?? 0.0) + value;
      });
    }

    // Apply adjustments
    final newScores = Map<ReputationCategory, double>.from(profile.scores);
    adjustments.forEach((category, adjustment) {
      newScores[category] = (newScores[category]! + adjustment * 0.01).clamp(0.0, 1.0);
    });

    _reputationProfiles['rep_${_playerId}'] = ReputationProfile(
      id: profile.id,
      userId: profile.userId,
      scores: newScores,
      mentions: profile.mentions,
      sentiment: profile.sentiment,
      keywords: profile.keywords,
      trends: profile.trends,
      lastUpdated: DateTime.now(),
    );

    _digitalReputation = newScores.values.reduce((a, b) => a + b) / newScores.length;
  }

  Map<ReputationCategory, double> _analyzePostReputationImpact(SocialPost post) {
    final impact = <ReputationCategory, double>{};
    
    // Platform-based reputation impact
    switch (post.platform) {
      case SocialPlatform.businessNetwork:
        impact[ReputationCategory.business] = post.engagementRate;
        break;
      case SocialPlatform.localNews:
        impact[ReputationCategory.political] = post.engagementRate * 0.5;
        break;
      case SocialPlatform.undergroundForum:
        impact[ReputationCategory.underground] = post.engagementRate;
        impact[ReputationCategory.criminal] = post.engagementRate * 0.3;
        break;
      case SocialPlatform.streetGram:
        impact[ReputationCategory.street] = post.engagementRate;
        impact[ReputationCategory.celebrity] = post.engagementRate * 0.2;
        break;
      default:
        impact[ReputationCategory.street] = post.engagementRate * 0.5;
        break;
    }

    return impact;
  }

  void _generateTrendingContent() {
    if (_random.nextDouble() < 0.1) {
      _updateTrendingHashtags();
    }
    
    if (_random.nextDouble() < 0.05) {
      _generateViralEvent();
    }
  }

  void _updateTrendingHashtags() {
    final potentialHashtags = [
      'streetlife', 'hustle', 'grind', 'money', 'business', 'entrepreneur',
      'citylife', 'opportunity', 'network', 'success', 'growth', 'invest',
      'community', 'local', 'urban', 'downtown', 'deals', 'connections'
    ];

    _trendingHashtags = potentialHashtags
        .where((_) => _random.nextDouble() < 0.3)
        .take(5)
        .toList();
  }

  void _generateViralEvent() {
    final events = [
      'Major business deal announced in the city',
      'New development project breaks ground',
      'Local entrepreneur makes headlines',
      'Community event draws massive crowd',
      'Police crackdown on illegal activities',
      'Celebrity spotted in local establishments',
    ];

    final event = events[_random.nextInt(events.length)];
    
    createPost(
      SocialPlatform.localNews,
      PostType.text,
      'BREAKING: $event',
      hashtags: ['breaking', 'news', 'local'],
    );
  }

  void _updateInfluenceMetrics() {
    _totalFollowers = 0;
    _overallInfluence = 0.0;

    for (final account in _accounts.values) {
      if (account.userId == _playerId) {
        _totalFollowers += account.followers;
        _overallInfluence += account.influenceScore;
      }
    }

    _overallInfluence = _overallInfluence / _accounts.values.where((acc) => acc.userId == _playerId).length;
  }

  // Public Interface Methods
  List<SocialPost> getFeedForPlatform(SocialPlatform platform, {int limit = 20}) {
    return _posts.values
        .where((post) => post.platform == platform)
        .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp))
        ..take(limit).toList();
  }

  List<SocialPost> getTrendingPosts({int limit = 10}) {
    return _posts.values
        .where((post) => post.isTrending)
        .toList()
        ..sort((a, b) => b.viralityScore.compareTo(a.viralityScore))
        ..take(limit).toList();
  }

  List<Message> getConversationWith(String userId, {int limit = 50}) {
    return _messages.values
        .where((msg) => (msg.senderId == userId && msg.receiverId == _playerId) ||
                       (msg.senderId == _playerId && msg.receiverId == userId))
        .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp))
        ..take(limit).toList();
  }

  List<Message> getUnreadMessages() {
    return _messages.values
        .where((msg) => msg.receiverId == _playerId && !msg.isRead)
        .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  SocialAccount? getAccountForPlatform(SocialPlatform platform) {
    return _accounts.values
        .where((acc) => acc.userId == _playerId && acc.platform == platform)
        .firstOrNull;
  }

  List<ViralCampaign> getActiveCampaigns() {
    return _campaigns.values
        .where((campaign) => campaign.isActive)
        .toList()
        ..sort((a, b) => b.startDate.compareTo(a.startDate));
  }

  ReputationProfile? getPlayerReputationProfile() {
    return _reputationProfiles['rep_${_playerId}'];
  }

  void markMessageAsRead(String messageId) {
    final message = _messages[messageId];
    if (message != null) {
      _messages[messageId] = message.copyWith(isRead: true);
      notifyListeners();
    }
  }

  void likePost(String postId) {
    final post = _posts[postId];
    if (post != null) {
      _posts[postId] = post.copyWith(likes: post.likes + 1);
      notifyListeners();
    }
  }

  void sharePost(String postId) {
    final post = _posts[postId];
    if (post != null) {
      _posts[postId] = post.copyWith(shares: post.shares + 1);
      notifyListeners();
    }
  }

  void dispose() {
    _systemTimer?.cancel();
    super.dispose();
  }
}

// Advanced Social Media Dashboard Widget
class AdvancedSocialMediaDashboardWidget extends StatefulWidget {
  const AdvancedSocialMediaDashboardWidget({super.key});

  @override
  State<AdvancedSocialMediaDashboardWidget> createState() => _AdvancedSocialMediaDashboardWidgetState();
}

class _AdvancedSocialMediaDashboardWidgetState extends State<AdvancedSocialMediaDashboardWidget>
    with TickerProviderStateMixin {
  final AdvancedSocialMediaSystem _socialSystem = AdvancedSocialMediaSystem();
  late TabController _tabController;
  SocialPlatform _selectedPlatform = SocialPlatform.streetGram;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _socialSystem,
      builder: (context, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                _buildStatsRow(),
                const SizedBox(height: 16),
                _buildTabBar(),
                const SizedBox(height: 16),
                Expanded(child: _buildTabBarView()),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Text(
          'Social Media Hub',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        const Icon(Icons.trending_up, color: Colors.green),
        const SizedBox(width: 8),
        Text('Influence: ${_socialSystem.overallInfluence.toInt()}'),
      ],
    );
  }

  Widget _buildStatsRow() {
    final unreadCount = _socialSystem.getUnreadMessages().length;
    
    return Row(
      children: [
        _buildStatCard('Posts', '${_socialSystem.totalPosts}'),
        _buildStatCard('Followers', '${_socialSystem.totalFollowers}'),
        _buildStatCard('Reputation', '${(_socialSystem.digitalReputation * 100).toInt()}%'),
        _buildStatCard('Unread', '$unreadCount', unreadCount > 0 ? Colors.red[50] : null),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, [Color? backgroundColor]) {
    return Expanded(
      child: Card(
        color: backgroundColor ?? Colors.blue[50],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(label, style: const TextStyle(fontSize: 12)),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      tabs: const [
        Tab(text: 'Feed', icon: Icon(Icons.dynamic_feed)),
        Tab(text: 'Messages', icon: Icon(Icons.message)),
        Tab(text: 'Campaigns', icon: Icon(Icons.campaign)),
        Tab(text: 'Analytics', icon: Icon(Icons.analytics)),
      ],
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildFeedTab(),
        _buildMessagesTab(),
        _buildCampaignsTab(),
        _buildAnalyticsTab(),
      ],
    );
  }

  Widget _buildFeedTab() {
    return Column(
      children: [
        _buildPlatformSelector(),
        const SizedBox(height: 8),
        _buildCreatePostButton(),
        const SizedBox(height: 8),
        Expanded(child: _buildPostsFeed()),
      ],
    );
  }

  Widget _buildPlatformSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: SocialPlatform.values.map((platform) {
          final isSelected = platform == _selectedPlatform;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(platform.name),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedPlatform = platform;
                });
              },
              backgroundColor: isSelected ? Colors.blue[100] : null,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCreatePostButton() {
    return ElevatedButton.icon(
      onPressed: () => _showCreatePostDialog(),
      icon: const Icon(Icons.add),
      label: Text('Create Post on ${_selectedPlatform.name}'),
    );
  }

  Widget _buildPostsFeed() {
    final posts = _socialSystem.getFeedForPlatform(_selectedPlatform);
    
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return _buildPostCard(post);
      },
    );
  }

  Widget _buildPostCard(SocialPost post) {
    final isPlayerPost = post.authorId == _socialSystem.playerId;
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: isPlayerPost ? Colors.blue[50] : null,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: isPlayerPost ? Colors.blue : Colors.grey,
                  radius: 16,
                  child: Text(isPlayerPost ? 'You' : 'U', style: const TextStyle(fontSize: 12)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isPlayerPost ? 'You' : 'User ${post.authorId.split('_').last}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _formatDateTime(post.timestamp),
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                if (post.virality.index > 1)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      post.virality.name.toUpperCase(),
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(post.content),
            if (post.hashtags.isNotEmpty) ...[
              const SizedBox(height: 4),
              Wrap(
                children: post.hashtags.map((tag) => 
                  Text('#$tag ', style: TextStyle(color: Colors.blue[600]))).toList(),
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                _buildEngagementButton(Icons.thumb_up, '${post.likes}', () => _socialSystem.likePost(post.id)),
                _buildEngagementButton(Icons.share, '${post.shares}', () => _socialSystem.sharePost(post.id)),
                _buildEngagementButton(Icons.comment, '${post.comments}', () {}),
                const Spacer(),
                Text('${post.views} views', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEngagementButton(IconData icon, String count, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(count, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildMessagesTab() {
    final unreadMessages = _socialSystem.getUnreadMessages();
    
    return Column(
      children: [
        if (unreadMessages.isNotEmpty) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8.0),
            color: Colors.red[50],
            child: Text(
              '${unreadMessages.length} unread messages',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
        ],
        Expanded(
          child: ListView.builder(
            itemCount: unreadMessages.length,
            itemBuilder: (context, index) {
              final message = unreadMessages[index];
              return _buildMessageCard(message);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMessageCard(Message message) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: message.isEncrypted ? Colors.green : Colors.grey,
          child: Icon(
            message.isEncrypted ? Icons.lock : Icons.person,
            size: 16,
          ),
        ),
        title: Text(message.isAnonymous ? 'Anonymous' : 'User ${message.senderId.split('_').last}'),
        subtitle: Text(
          message.content,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_formatDateTime(message.timestamp), style: const TextStyle(fontSize: 12)),
            if (!message.isRead)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        onTap: () => _socialSystem.markMessageAsRead(message.id),
      ),
    );
  }

  Widget _buildCampaignsTab() {
    final campaigns = _socialSystem.getActiveCampaigns();
    
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () => _showCreateCampaignDialog(),
          icon: const Icon(Icons.add),
          label: const Text('Launch Campaign'),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: campaigns.length,
            itemBuilder: (context, index) {
              final campaign = campaigns[index];
              return _buildCampaignCard(campaign);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCampaignCard(ViralCampaign campaign) {
    final daysRemaining = campaign.endDate.difference(DateTime.now()).inDays;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    campaign.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: campaign.isActive ? Colors.green[100] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    campaign.isActive ? 'ACTIVE' : 'ENDED',
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(campaign.description),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('Budget: \$${campaign.budget.toInt()}'),
                const Spacer(),
                Text('$daysRemaining days left'),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              children: campaign.platforms.map((platform) => 
                Chip(
                  label: Text(platform.name),
                  backgroundColor: Colors.blue[100],
                )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    final reputation = _socialSystem.getPlayerReputationProfile();
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Reputation Scores', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (reputation != null) ...[
            ...reputation.scores.entries.map((entry) => 
              _buildReputationBar(entry.key.name, entry.value)),
          ],
          const SizedBox(height: 16),
          const Text('Trending Hashtags', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            children: _socialSystem.trendingHashtags.map((tag) => 
              Chip(
                label: Text('#$tag'),
                backgroundColor: Colors.orange[100],
              )).toList(),
          ),
          const SizedBox(height: 16),
          const Text('Platform Performance', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...SocialPlatform.values.map((platform) => _buildPlatformStats(platform)),
        ],
      ),
    );
  }

  Widget _buildReputationBar(String category, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(category, style: const TextStyle(fontSize: 12)),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(_getReputationColor(value)),
            ),
          ),
          const SizedBox(width: 8),
          Text('${(value * 100).toInt()}%', style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildPlatformStats(SocialPlatform platform) {
    final account = _socialSystem.getAccountForPlatform(platform);
    
    return ListTile(
      leading: Icon(_getPlatformIcon(platform)),
      title: Text(platform.name),
      subtitle: account != null 
          ? Text('${account.followers} followers • ${account.posts} posts')
          : const Text('Not active'),
      trailing: account != null 
          ? Text('${account.influenceScore.toInt()}')
          : null,
    );
  }

  void _showCreatePostDialog() {
    final contentController = TextEditingController();
    final hashtagsController = TextEditingController();
    PostType selectedType = PostType.text;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create Post - ${_selectedPlatform.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<PostType>(
              value: selectedType,
              decoration: const InputDecoration(labelText: 'Post Type'),
              items: PostType.values.map((type) => 
                DropdownMenuItem(value: type, child: Text(type.name))).toList(),
              onChanged: (type) => selectedType = type!,
            ),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: 'Content'),
              maxLines: 3,
            ),
            TextField(
              controller: hashtagsController,
              decoration: const InputDecoration(labelText: 'Hashtags (comma separated)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final hashtags = hashtagsController.text
                  .split(',')
                  .map((tag) => tag.trim())
                  .where((tag) => tag.isNotEmpty)
                  .toList();

              _socialSystem.createPost(
                _selectedPlatform,
                selectedType,
                contentController.text,
                hashtags: hashtags,
              );

              Navigator.of(context).pop();
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }

  void _showCreateCampaignDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final budgetController = TextEditingController();
    List<SocialPlatform> selectedPlatforms = [];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Launch Viral Campaign'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Campaign Name'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
                TextField(
                  controller: budgetController,
                  decoration: const InputDecoration(labelText: 'Budget (\$)'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                const Text('Select Platforms:'),
                ...SocialPlatform.values.map((platform) => 
                  CheckboxListTile(
                    title: Text(platform.name),
                    value: selectedPlatforms.contains(platform),
                    onChanged: (selected) {
                      setState(() {
                        if (selected == true) {
                          selectedPlatforms.add(platform);
                        } else {
                          selectedPlatforms.remove(platform);
                        }
                      });
                    },
                  )),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final budget = double.tryParse(budgetController.text) ?? 0;
                
                _socialSystem.launchViralCampaign(
                  nameController.text,
                  descriptionController.text,
                  selectedPlatforms,
                  budget,
                );

                Navigator.of(context).pop();
              },
              child: const Text('Launch'),
            ),
          ],
        ),
      ),
    );
  }

  Color _getReputationColor(double value) {
    if (value < 0.3) return Colors.red;
    if (value < 0.6) return Colors.orange;
    return Colors.green;
  }

  IconData _getPlatformIcon(SocialPlatform platform) {
    switch (platform) {
      case SocialPlatform.streetGram:
        return Icons.photo_camera;
      case SocialPlatform.crimeBook:
        return Icons.book;
      case SocialPlatform.dealerTok:
        return Icons.video_library;
      case SocialPlatform.undergroundForum:
        return Icons.forum;
      case SocialPlatform.darkWeb:
        return Icons.security;
      case SocialPlatform.localNews:
        return Icons.newspaper;
      case SocialPlatform.policeBand:
        return Icons.radio;
      case SocialPlatform.businessNetwork:
        return Icons.business;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
