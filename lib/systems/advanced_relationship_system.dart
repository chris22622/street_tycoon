import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

// Advanced Character Relationships System
// Feature #18: Ultra-comprehensive relationship mechanics with deep emotional bonds,
// loyalty systems, betrayal mechanics, romantic relationships, and complex social networks

enum RelationshipType {
  romantic,
  family,
  friend,
  business,
  criminal,
  mentor,
  rival,
  enemy,
  ally,
  contact,
  informant,
  asset
}

enum RelationshipStatus {
  stranger,
  acquaintance,
  friend,
  closeFriend,
  bestFriend,
  romantic,
  lover,
  partner,
  enemy,
  nemesis,
  ally,
  confidant
}

enum EmotionalState {
  happy,
  angry,
  sad,
  fearful,
  disgusted,
  surprised,
  neutral,
  excited,
  jealous,
  grateful,
  disappointed,
  proud
}

enum LoyaltyLevel {
  traitor,
  disloyal,
  unreliable,
  neutral,
  loyal,
  devoted,
  fanatical
}

enum TrustLevel {
  distrustful,
  suspicious,
  cautious,
  neutral,
  trusting,
  confident,
  absolute
}

enum RelationshipEvent {
  meeting,
  favor,
  betrayal,
  gift,
  conflict,
  cooperation,
  romance,
  breakup,
  reconciliation,
  business,
  crime,
  rescue
}

class Character {
  final String id;
  final String name;
  final String nickname;
  final int age;
  final String background;
  final String occupation;
  final Map<String, double> personality;
  final Map<String, double> skills;
  final List<String> interests;
  final List<String> fears;
  final Map<String, dynamic> secrets;
  final EmotionalState currentEmotion;
  final bool isAvailable;
  final String? currentLocation;
  final Map<String, dynamic> preferences;

  Character({
    required this.id,
    required this.name,
    required this.nickname,
    required this.age,
    required this.background,
    required this.occupation,
    this.personality = const {},
    this.skills = const {},
    this.interests = const [],
    this.fears = const [],
    this.secrets = const {},
    this.currentEmotion = EmotionalState.neutral,
    this.isAvailable = true,
    this.currentLocation,
    this.preferences = const {},
  });

  Character copyWith({
    String? id,
    String? name,
    String? nickname,
    int? age,
    String? background,
    String? occupation,
    Map<String, double>? personality,
    Map<String, double>? skills,
    List<String>? interests,
    List<String>? fears,
    Map<String, dynamic>? secrets,
    EmotionalState? currentEmotion,
    bool? isAvailable,
    String? currentLocation,
    Map<String, dynamic>? preferences,
  }) {
    return Character(
      id: id ?? this.id,
      name: name ?? this.name,
      nickname: nickname ?? this.nickname,
      age: age ?? this.age,
      background: background ?? this.background,
      occupation: occupation ?? this.occupation,
      personality: personality ?? this.personality,
      skills: skills ?? this.skills,
      interests: interests ?? this.interests,
      fears: fears ?? this.fears,
      secrets: secrets ?? this.secrets,
      currentEmotion: currentEmotion ?? this.currentEmotion,
      isAvailable: isAvailable ?? this.isAvailable,
      currentLocation: currentLocation ?? this.currentLocation,
      preferences: preferences ?? this.preferences,
    );
  }
}

class Relationship {
  final String id;
  final String characterId;
  final String playerId;
  final RelationshipType type;
  final RelationshipStatus status;
  final double affection;
  final double respect;
  final double trust;
  final double loyalty;
  final double attraction;
  final double intimacy;
  final double commitment;
  final LoyaltyLevel loyaltyLevel;
  final TrustLevel trustLevel;
  final DateTime startDate;
  final DateTime lastInteraction;
  final List<String> sharedExperiences;
  final Map<String, double> emotionalBonds;
  final Map<String, dynamic> relationshipData;
  final bool isActive;
  final String? notes;

  Relationship({
    required this.id,
    required this.characterId,
    required this.playerId,
    required this.type,
    this.status = RelationshipStatus.stranger,
    this.affection = 0.0,
    this.respect = 0.0,
    this.trust = 0.0,
    this.loyalty = 0.0,
    this.attraction = 0.0,
    this.intimacy = 0.0,
    this.commitment = 0.0,
    this.loyaltyLevel = LoyaltyLevel.neutral,
    this.trustLevel = TrustLevel.neutral,
    required this.startDate,
    required this.lastInteraction,
    this.sharedExperiences = const [],
    this.emotionalBonds = const {},
    this.relationshipData = const {},
    this.isActive = true,
    this.notes,
  });

  Relationship copyWith({
    String? id,
    String? characterId,
    String? playerId,
    RelationshipType? type,
    RelationshipStatus? status,
    double? affection,
    double? respect,
    double? trust,
    double? loyalty,
    double? attraction,
    double? intimacy,
    double? commitment,
    LoyaltyLevel? loyaltyLevel,
    TrustLevel? trustLevel,
    DateTime? startDate,
    DateTime? lastInteraction,
    List<String>? sharedExperiences,
    Map<String, double>? emotionalBonds,
    Map<String, dynamic>? relationshipData,
    bool? isActive,
    String? notes,
  }) {
    return Relationship(
      id: id ?? this.id,
      characterId: characterId ?? this.characterId,
      playerId: playerId ?? this.playerId,
      type: type ?? this.type,
      status: status ?? this.status,
      affection: affection ?? this.affection,
      respect: respect ?? this.respect,
      trust: trust ?? this.trust,
      loyalty: loyalty ?? this.loyalty,
      attraction: attraction ?? this.attraction,
      intimacy: intimacy ?? this.intimacy,
      commitment: commitment ?? this.commitment,
      loyaltyLevel: loyaltyLevel ?? this.loyaltyLevel,
      trustLevel: trustLevel ?? this.trustLevel,
      startDate: startDate ?? this.startDate,
      lastInteraction: lastInteraction ?? this.lastInteraction,
      sharedExperiences: sharedExperiences ?? this.sharedExperiences,
      emotionalBonds: emotionalBonds ?? this.emotionalBonds,
      relationshipData: relationshipData ?? this.relationshipData,
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
    );
  }

  double get overallBond => (affection + respect + trust + loyalty) / 4.0;
  double get romanticPotential => (affection + attraction + intimacy) / 3.0;
  double get businessValue => (respect + trust + loyalty) / 3.0;
  Duration get relationshipDuration => DateTime.now().difference(startDate);
  bool get isRomantic => type == RelationshipType.romantic && status.index >= RelationshipStatus.romantic.index;
  bool get isDeepBond => overallBond > 0.8;
  bool get isVolatile => emotionalBonds['volatility'] != null && emotionalBonds['volatility']! > 0.7;
}

class RelationshipInteraction {
  final String id;
  final String relationshipId;
  final RelationshipEvent eventType;
  final String description;
  final DateTime timestamp;
  final Map<String, double> emotionalImpact;
  final Map<String, dynamic> consequences;
  final bool playerInitiated;
  final double intensity;

  RelationshipInteraction({
    required this.id,
    required this.relationshipId,
    required this.eventType,
    required this.description,
    required this.timestamp,
    this.emotionalImpact = const {},
    this.consequences = const {},
    this.playerInitiated = false,
    required this.intensity,
  });
}

class RomanticRelationship {
  final String relationshipId;
  final String characterId;
  final String playerId;
  final DateTime startDate;
  final double passion;
  final double companionship;
  final double commitment;
  final double jealousy;
  final double communication;
  final Map<String, dynamic> relationshipGoals;
  final List<String> conflictAreas;
  final bool isExclusive;
  final bool isPublic;
  final Map<String, dynamic> intimacyLevel;

  RomanticRelationship({
    required this.relationshipId,
    required this.characterId,
    required this.playerId,
    required this.startDate,
    this.passion = 0.5,
    this.companionship = 0.5,
    this.commitment = 0.5,
    this.jealousy = 0.0,
    this.communication = 0.5,
    this.relationshipGoals = const {},
    this.conflictAreas = const [],
    this.isExclusive = false,
    this.isPublic = false,
    this.intimacyLevel = const {},
  });
}

class SocialNetwork {
  final String id;
  final String name;
  final List<String> members;
  final Map<String, double> memberInfluence;
  final String networkType;
  final double cohesion;
  final double secrecy;
  final Map<String, dynamic> networkData;

  SocialNetwork({
    required this.id,
    required this.name,
    this.members = const [],
    this.memberInfluence = const {},
    required this.networkType,
    this.cohesion = 0.5,
    this.secrecy = 0.5,
    this.networkData = const {},
  });
}

class AdvancedRelationshipSystem extends ChangeNotifier {
  static final AdvancedRelationshipSystem _instance = AdvancedRelationshipSystem._internal();
  factory AdvancedRelationshipSystem() => _instance;
  AdvancedRelationshipSystem._internal() {
    _initializeSystem();
  }

  final Map<String, Character> _characters = {};
  final Map<String, Relationship> _relationships = {};
  final Map<String, RelationshipInteraction> _interactions = {};
  final Map<String, RomanticRelationship> _romanticRelationships = {};
  final Map<String, SocialNetwork> _socialNetworks = {};
  
  String? _playerId;
  int _totalCharacters = 0;
  int _activeRelationships = 0;
  double _socialInfluence = 0.0;
  double _reputationScore = 0.5;
  String? _currentRomanticPartner;
  
  Timer? _systemTimer;
  final math.Random _random = math.Random();

  // Getters
  Map<String, Character> get characters => Map.unmodifiable(_characters);
  Map<String, Relationship> get relationships => Map.unmodifiable(_relationships);
  Map<String, RelationshipInteraction> get interactions => Map.unmodifiable(_interactions);
  Map<String, RomanticRelationship> get romanticRelationships => Map.unmodifiable(_romanticRelationships);
  Map<String, SocialNetwork> get socialNetworks => Map.unmodifiable(_socialNetworks);
  String? get playerId => _playerId;
  int get totalCharacters => _totalCharacters;
  int get activeRelationships => _activeRelationships;
  double get socialInfluence => _socialInfluence;
  double get reputationScore => _reputationScore;
  String? get currentRomanticPartner => _currentRomanticPartner;

  void _initializeSystem() {
    _playerId = 'player_${DateTime.now().millisecondsSinceEpoch}';
    _generateInitialCharacters();
    _generateSocialNetworks();
    _startSystemTimer();
  }

  void _generateInitialCharacters() {
    final characterDefinitions = _getCharacterDefinitions();
    
    for (final character in characterDefinitions) {
      _characters[character.id] = character;
      _totalCharacters++;
      
      // Create initial neutral relationship
      _createRelationship(character.id, RelationshipType.contact);
    }
  }

  List<Character> _getCharacterDefinitions() {
    return [
      Character(
        id: 'char_elena_vasquez',
        name: 'Elena Vasquez',
        nickname: 'La Rosa',
        age: 28,
        background: 'Former cartel princess turned independent operator',
        occupation: 'Information Broker',
        personality: {
          'charismatic': 0.9,
          'intelligent': 0.8,
          'manipulative': 0.7,
          'ambitious': 0.8,
          'trustworthy': 0.4,
        },
        skills: {
          'negotiation': 0.9,
          'deception': 0.8,
          'networking': 0.9,
          'combat': 0.6,
        },
        interests: ['art', 'luxury', 'power', 'information'],
        fears: ['betrayal', 'poverty', 'irrelevance'],
        secrets: {
          'family_cartel': 'Her family still controls territory in Colombia',
          'federal_informant': 'May be providing information to federal agents',
        },
        preferences: {
          'gift_type': 'luxury_items',
          'interaction_style': 'sophisticated',
          'loyalty_trigger': 'respect',
        },
      ),
      Character(
        id: 'char_marcus_king',
        name: 'Marcus King',
        nickname: 'The Wolf',
        age: 35,
        background: 'Ex-military turned mercenary',
        occupation: 'Security Specialist',
        personality: {
          'loyal': 0.9,
          'disciplined': 0.8,
          'aggressive': 0.7,
          'protective': 0.9,
          'emotional': 0.3,
        },
        skills: {
          'combat': 0.95,
          'tactics': 0.9,
          'weapons': 0.95,
          'leadership': 0.7,
        },
        interests: ['military_history', 'weapons', 'fitness', 'honor'],
        fears: ['failure', 'losing_comrades', 'civilians_hurt'],
        secrets: {
          'ptsd': 'Suffers from PTSD from military service',
          'daughter': 'Has a daughter he\'s never met',
        },
        preferences: {
          'gift_type': 'practical_items',
          'interaction_style': 'direct',
          'loyalty_trigger': 'trust',
        },
      ),
      Character(
        id: 'char_sophia_chen',
        name: 'Sophia Chen',
        nickname: 'The Architect',
        age: 32,
        background: 'MIT graduate turned hacker',
        occupation: 'Cyber Security Consultant',
        personality: {
          'intelligent': 0.95,
          'introverted': 0.8,
          'perfectionist': 0.9,
          'curious': 0.9,
          'social': 0.3,
        },
        skills: {
          'hacking': 0.95,
          'programming': 0.9,
          'analysis': 0.9,
          'electronics': 0.8,
        },
        interests: ['technology', 'puzzles', 'privacy', 'efficiency'],
        fears: ['social_situations', 'failure', 'surveillance'],
        secrets: {
          'government_contract': 'Has contracts with government agencies',
          'family_pressure': 'Family expects her to return to legitimate work',
        },
        preferences: {
          'gift_type': 'tech_gadgets',
          'interaction_style': 'intellectual',
          'loyalty_trigger': 'trust',
        },
      ),
      Character(
        id: 'char_james_rodriguez',
        name: 'James Rodriguez',
        nickname: 'Smooth',
        age: 29,
        background: 'Street-smart hustler with charm',
        occupation: 'Club Owner',
        personality: {
          'charismatic': 0.8,
          'opportunistic': 0.9,
          'fun_loving': 0.8,
          'unreliable': 0.6,
          'loyal': 0.5,
        },
        skills: {
          'persuasion': 0.8,
          'streetwise': 0.9,
          'business': 0.7,
          'socializing': 0.9,
        },
        interests: ['parties', 'money', 'women', 'cars'],
        fears: ['commitment', 'poverty', 'boredom'],
        secrets: {
          'gambling_debt': 'Owes money to dangerous people',
          'informant': 'Sometimes provides information to police',
        },
        preferences: {
          'gift_type': 'money',
          'interaction_style': 'casual',
          'loyalty_trigger': 'benefits',
        },
      ),
      Character(
        id: 'char_victoria_black',
        name: 'Victoria Black',
        nickname: 'The Duchess',
        age: 42,
        background: 'Wealthy socialite with dark connections',
        occupation: 'Philanthropist',
        personality: {
          'sophisticated': 0.9,
          'manipulative': 0.8,
          'patient': 0.8,
          'ruthless': 0.7,
          'charming': 0.9,
        },
        skills: {
          'influence': 0.9,
          'manipulation': 0.8,
          'networking': 0.9,
          'business': 0.8,
        },
        interests: ['art', 'politics', 'power', 'culture'],
        fears: ['scandal', 'losing_status', 'aging'],
        secrets: {
          'money_laundering': 'Launders money through charity organizations',
          'political_corruption': 'Has dirt on major political figures',
        },
        preferences: {
          'gift_type': 'art_culture',
          'interaction_style': 'formal',
          'loyalty_trigger': 'mutual_benefit',
        },
      ),
      Character(
        id: 'char_alex_murphy',
        name: 'Alex Murphy',
        nickname: 'Murphy',
        age: 26,
        background: 'Young ambitious lawyer',
        occupation: 'Defense Attorney',
        personality: {
          'ambitious': 0.8,
          'idealistic': 0.7,
          'intelligent': 0.8,
          'naive': 0.6,
          'honest': 0.7,
        },
        skills: {
          'law': 0.8,
          'negotiation': 0.7,
          'research': 0.8,
          'persuasion': 0.7,
        },
        interests: ['justice', 'books', 'debate', 'success'],
        fears: ['corruption', 'failure', 'moral_compromise'],
        secrets: {
          'family_debt': 'Family owes money for law school',
          'idealism_vs_reality': 'Struggling with moral compromises',
        },
        preferences: {
          'gift_type': 'books_knowledge',
          'interaction_style': 'professional',
          'loyalty_trigger': 'respect',
        },
      ),
    ];
  }

  void _generateSocialNetworks() {
    final networks = [
      SocialNetwork(
        id: 'network_high_society',
        name: 'High Society Circle',
        members: ['char_victoria_black', 'char_elena_vasquez'],
        networkType: 'social_elite',
        cohesion: 0.7,
        secrecy: 0.8,
        memberInfluence: {
          'char_victoria_black': 0.9,
          'char_elena_vasquez': 0.6,
        },
      ),
      SocialNetwork(
        id: 'network_tech_underground',
        name: 'Tech Underground',
        members: ['char_sophia_chen'],
        networkType: 'professional',
        cohesion: 0.6,
        secrecy: 0.9,
        memberInfluence: {
          'char_sophia_chen': 0.8,
        },
      ),
      SocialNetwork(
        id: 'network_street_contacts',
        name: 'Street Network',
        members: ['char_james_rodriguez', 'char_marcus_king'],
        networkType: 'criminal',
        cohesion: 0.5,
        secrecy: 0.6,
        memberInfluence: {
          'char_james_rodriguez': 0.7,
          'char_marcus_king': 0.6,
        },
      ),
    ];

    for (final network in networks) {
      _socialNetworks[network.id] = network;
    }
  }

  void _startSystemTimer() {
    _systemTimer?.cancel();
    _systemTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _updateRelationships();
      _processEmotionalChanges();
      _generateRandomEvents();
      _updateSocialInfluence();
      notifyListeners();
    });
  }

  // Relationship Management
  String _createRelationship(String characterId, RelationshipType type) {
    final relationshipId = 'rel_${DateTime.now().millisecondsSinceEpoch}_$characterId';
    
    final relationship = Relationship(
      id: relationshipId,
      characterId: characterId,
      playerId: _playerId!,
      type: type,
      startDate: DateTime.now(),
      lastInteraction: DateTime.now(),
    );

    _relationships[relationshipId] = relationship;
    _activeRelationships++;
    
    return relationshipId;
  }

  void interactWithCharacter(String characterId, RelationshipEvent eventType, {
    String? customMessage,
    Map<String, dynamic>? parameters,
  }) {
    final character = _characters[characterId];
    final relationship = getRelationshipWithCharacter(characterId);
    
    if (character == null || relationship == null) return;

    final intensity = _calculateInteractionIntensity(eventType, character, relationship);
    final emotionalImpact = _calculateEmotionalImpact(eventType, character, relationship, intensity);
    
    // Create interaction record
    final interactionId = 'interaction_${DateTime.now().millisecondsSinceEpoch}';
    final interaction = RelationshipInteraction(
      id: interactionId,
      relationshipId: relationship.id,
      eventType: eventType,
      description: customMessage ?? _generateInteractionDescription(eventType, character),
      timestamp: DateTime.now(),
      emotionalImpact: emotionalImpact,
      playerInitiated: true,
      intensity: intensity,
    );

    _interactions[interactionId] = interaction;

    // Update relationship based on interaction
    _updateRelationshipFromInteraction(relationship, interaction, character);

    // Update character emotional state
    _updateCharacterEmotion(character, eventType, intensity);

    notifyListeners();
  }

  double _calculateInteractionIntensity(RelationshipEvent eventType, Character character, Relationship relationship) {
    double baseIntensity = 0.5;

    // Event type intensity
    switch (eventType) {
      case RelationshipEvent.betrayal:
        baseIntensity = 0.9;
        break;
      case RelationshipEvent.romance:
        baseIntensity = 0.8;
        break;
      case RelationshipEvent.rescue:
        baseIntensity = 0.8;
        break;
      case RelationshipEvent.favor:
        baseIntensity = 0.4;
        break;
      case RelationshipEvent.gift:
        baseIntensity = 0.3;
        break;
      case RelationshipEvent.meeting:
        baseIntensity = 0.2;
        break;
      default:
        break;
    }

    // Character personality modifiers
    final emotionalness = character.personality['emotional'] ?? 0.5;
    baseIntensity *= (0.5 + emotionalness);

    // Relationship status modifier
    if (relationship.overallBond > 0.7) {
      baseIntensity *= 1.2; // Deeper relationships feel things more intensely
    }

    return baseIntensity.clamp(0.1, 1.0);
  }

  Map<String, double> _calculateEmotionalImpact(RelationshipEvent eventType, Character character, 
                                                Relationship relationship, double intensity) {
    final impact = <String, double>{};

    switch (eventType) {
      case RelationshipEvent.favor:
        impact['affection'] = intensity * 0.3;
        impact['trust'] = intensity * 0.2;
        impact['respect'] = intensity * 0.1;
        break;
      case RelationshipEvent.betrayal:
        impact['affection'] = -intensity * 0.5;
        impact['trust'] = -intensity * 0.8;
        impact['loyalty'] = -intensity * 0.6;
        break;
      case RelationshipEvent.gift:
        impact['affection'] = intensity * 0.4;
        impact['attraction'] = intensity * 0.2;
        break;
      case RelationshipEvent.romance:
        impact['affection'] = intensity * 0.6;
        impact['attraction'] = intensity * 0.8;
        impact['intimacy'] = intensity * 0.5;
        break;
      case RelationshipEvent.conflict:
        impact['affection'] = -intensity * 0.3;
        impact['respect'] = -intensity * 0.2;
        break;
      case RelationshipEvent.cooperation:
        impact['trust'] = intensity * 0.3;
        impact['respect'] = intensity * 0.4;
        impact['loyalty'] = intensity * 0.2;
        break;
      case RelationshipEvent.rescue:
        impact['affection'] = intensity * 0.7;
        impact['trust'] = intensity * 0.8;
        impact['loyalty'] = intensity * 0.9;
        break;
      default:
        impact['affection'] = intensity * 0.1;
        break;
    }

    // Apply character personality modifiers
    final trustworthiness = character.personality['trustworthy'] ?? 0.5;
    if (impact['trust'] != null) {
      impact['trust'] = impact['trust']! * (0.5 + trustworthiness);
    }

    final loyalty_trait = character.personality['loyal'] ?? 0.5;
    if (impact['loyalty'] != null) {
      impact['loyalty'] = impact['loyalty']! * (0.5 + loyalty_trait);
    }

    return impact;
  }

  void _updateRelationshipFromInteraction(Relationship relationship, RelationshipInteraction interaction, Character character) {
    double newAffection = relationship.affection;
    double newRespect = relationship.respect;
    double newTrust = relationship.trust;
    double newLoyalty = relationship.loyalty;
    double newAttraction = relationship.attraction;
    double newIntimacy = relationship.intimacy;
    double newCommitment = relationship.commitment;

    // Apply emotional impact
    for (final entry in interaction.emotionalImpact.entries) {
      switch (entry.key) {
        case 'affection':
          newAffection = (newAffection + entry.value).clamp(-1.0, 1.0);
          break;
        case 'respect':
          newRespect = (newRespect + entry.value).clamp(-1.0, 1.0);
          break;
        case 'trust':
          newTrust = (newTrust + entry.value).clamp(-1.0, 1.0);
          break;
        case 'loyalty':
          newLoyalty = (newLoyalty + entry.value).clamp(-1.0, 1.0);
          break;
        case 'attraction':
          newAttraction = (newAttraction + entry.value).clamp(-1.0, 1.0);
          break;
        case 'intimacy':
          newIntimacy = (newIntimacy + entry.value).clamp(-1.0, 1.0);
          break;
        case 'commitment':
          newCommitment = (newCommitment + entry.value).clamp(-1.0, 1.0);
          break;
      }
    }

    // Determine new status based on relationship values
    RelationshipStatus newStatus = _calculateRelationshipStatus(
      newAffection, newRespect, newTrust, newLoyalty, newAttraction, newIntimacy, relationship.type
    );

    // Determine loyalty and trust levels
    LoyaltyLevel newLoyaltyLevel = _calculateLoyaltyLevel(newLoyalty);
    TrustLevel newTrustLevel = _calculateTrustLevel(newTrust);

    // Update relationship
    _relationships[relationship.id] = relationship.copyWith(
      affection: newAffection,
      respect: newRespect,
      trust: newTrust,
      loyalty: newLoyalty,
      attraction: newAttraction,
      intimacy: newIntimacy,
      commitment: newCommitment,
      status: newStatus,
      loyaltyLevel: newLoyaltyLevel,
      trustLevel: newTrustLevel,
      lastInteraction: DateTime.now(),
      sharedExperiences: [
        ...relationship.sharedExperiences,
        interaction.eventType.name,
      ],
    );

    // Handle romantic relationship progression
    if (newStatus.index >= RelationshipStatus.romantic.index && 
        !_romanticRelationships.containsKey(relationship.id)) {
      _createRomanticRelationship(relationship.id, character.id);
    }
  }

  RelationshipStatus _calculateRelationshipStatus(double affection, double respect, double trust, 
                                                 double loyalty, double attraction, double intimacy,
                                                 RelationshipType type) {
    final overallBond = (affection + respect + trust + loyalty) / 4.0;
    final romanticBond = (affection + attraction + intimacy) / 3.0;

    if (overallBond < -0.5) return RelationshipStatus.enemy;
    if (overallBond < -0.2) return RelationshipStatus.stranger;
    
    if (type == RelationshipType.romantic && romanticBond > 0.6) {
      if (intimacy > 0.8 && affection > 0.8) return RelationshipStatus.partner;
      if (romanticBond > 0.7) return RelationshipStatus.lover;
      return RelationshipStatus.romantic;
    }

    if (overallBond > 0.8 && loyalty > 0.7) return RelationshipStatus.confidant;
    if (overallBond > 0.7) return RelationshipStatus.bestFriend;
    if (overallBond > 0.5) return RelationshipStatus.closeFriend;
    if (overallBond > 0.3) return RelationshipStatus.friend;
    if (overallBond > 0.1) return RelationshipStatus.acquaintance;
    
    return RelationshipStatus.stranger;
  }

  LoyaltyLevel _calculateLoyaltyLevel(double loyalty) {
    if (loyalty < -0.7) return LoyaltyLevel.traitor;
    if (loyalty < -0.3) return LoyaltyLevel.disloyal;
    if (loyalty < -0.1) return LoyaltyLevel.unreliable;
    if (loyalty < 0.3) return LoyaltyLevel.neutral;
    if (loyalty < 0.7) return LoyaltyLevel.loyal;
    if (loyalty < 0.9) return LoyaltyLevel.devoted;
    return LoyaltyLevel.fanatical;
  }

  TrustLevel _calculateTrustLevel(double trust) {
    if (trust < -0.5) return TrustLevel.distrustful;
    if (trust < -0.2) return TrustLevel.suspicious;
    if (trust < 0.0) return TrustLevel.cautious;
    if (trust < 0.3) return TrustLevel.neutral;
    if (trust < 0.6) return TrustLevel.trusting;
    if (trust < 0.8) return TrustLevel.confident;
    return TrustLevel.absolute;
  }

  void _createRomanticRelationship(String relationshipId, String characterId) {
    final romanticRel = RomanticRelationship(
      relationshipId: relationshipId,
      characterId: characterId,
      playerId: _playerId!,
      startDate: DateTime.now(),
    );

    _romanticRelationships[relationshipId] = romanticRel;
    _currentRomanticPartner = characterId;
  }

  void _updateCharacterEmotion(Character character, RelationshipEvent eventType, double intensity) {
    EmotionalState newEmotion = character.currentEmotion;

    switch (eventType) {
      case RelationshipEvent.favor:
      case RelationshipEvent.gift:
        newEmotion = intensity > 0.5 ? EmotionalState.grateful : EmotionalState.happy;
        break;
      case RelationshipEvent.betrayal:
        newEmotion = intensity > 0.7 ? EmotionalState.angry : EmotionalState.disappointed;
        break;
      case RelationshipEvent.romance:
        newEmotion = EmotionalState.excited;
        break;
      case RelationshipEvent.conflict:
        newEmotion = EmotionalState.angry;
        break;
      case RelationshipEvent.rescue:
        newEmotion = EmotionalState.grateful;
        break;
      default:
        break;
    }

    _characters[character.id] = character.copyWith(currentEmotion: newEmotion);
  }

  String _generateInteractionDescription(RelationshipEvent eventType, Character character) {
    switch (eventType) {
      case RelationshipEvent.meeting:
        return 'Met with ${character.name} for a conversation';
      case RelationshipEvent.favor:
        return 'Did a favor for ${character.name}';
      case RelationshipEvent.gift:
        return 'Gave a gift to ${character.name}';
      case RelationshipEvent.romance:
        return 'Had a romantic moment with ${character.name}';
      case RelationshipEvent.conflict:
        return 'Had a disagreement with ${character.name}';
      case RelationshipEvent.cooperation:
        return 'Worked together with ${character.name}';
      case RelationshipEvent.betrayal:
        return 'Betrayed ${character.name}\'s trust';
      case RelationshipEvent.rescue:
        return 'Came to ${character.name}\'s aid';
      default:
        return 'Interacted with ${character.name}';
    }
  }

  // System Updates
  void _updateRelationships() {
    for (final relationshipId in _relationships.keys.toList()) {
      final relationship = _relationships[relationshipId]!;
      _naturalRelationshipDecay(relationship);
    }
  }

  void _naturalRelationshipDecay(Relationship relationship) {
    // Relationships naturally decay over time without interaction
    final daysSinceLastInteraction = DateTime.now().difference(relationship.lastInteraction).inDays;
    
    if (daysSinceLastInteraction > 7) {
      final decayRate = 0.001 * daysSinceLastInteraction;
      
      _relationships[relationship.id] = relationship.copyWith(
        affection: (relationship.affection - decayRate).clamp(-1.0, 1.0),
        trust: (relationship.trust - decayRate).clamp(-1.0, 1.0),
        loyalty: (relationship.loyalty - decayRate * 0.5).clamp(-1.0, 1.0),
      );
    }
  }

  void _processEmotionalChanges() {
    for (final characterId in _characters.keys.toList()) {
      final character = _characters[characterId]!;
      
      // Characters gradually return to neutral emotional state
      if (character.currentEmotion != EmotionalState.neutral && _random.nextDouble() < 0.1) {
        _characters[characterId] = character.copyWith(currentEmotion: EmotionalState.neutral);
      }
    }
  }

  void _generateRandomEvents() {
    if (_random.nextDouble() < 0.02) {
      _generateRelationshipEvent();
    }
  }

  void _generateRelationshipEvent() {
    final activeRelationships = _relationships.values.where((r) => r.isActive).toList();
    if (activeRelationships.isEmpty) return;

    final relationship = activeRelationships[_random.nextInt(activeRelationships.length)];
    final character = _characters[relationship.characterId];
    if (character == null) return;

    final events = [
      'character_reaches_out',
      'character_needs_help',
      'character_betrays_someone',
      'character_promotion',
      'character_crisis',
    ];

    final eventType = events[_random.nextInt(events.length)];
    _handleRandomRelationshipEvent(relationship, character, eventType);
  }

  void _handleRandomRelationshipEvent(Relationship relationship, Character character, String eventType) {
    switch (eventType) {
      case 'character_reaches_out':
        if (relationship.overallBond > 0.3) {
          interactWithCharacter(character.id, RelationshipEvent.meeting, 
              customMessage: '${character.name} reached out to reconnect');
        }
        break;
      case 'character_needs_help':
        if (relationship.trust > 0.5) {
          _createInteractionEvent(relationship.id, RelationshipEvent.favor,
              '${character.name} asked for help with a personal matter', 0.4, false);
        }
        break;
      case 'character_betrays_someone':
        if (character.personality['trustworthy'] != null && 
            character.personality['trustworthy']! < 0.3 && 
            _random.nextDouble() < 0.3) {
          _createInteractionEvent(relationship.id, RelationshipEvent.betrayal,
              '${character.name} betrayed someone in their network', 0.6, false);
        }
        break;
      case 'character_promotion':
        _characters[character.id] = character.copyWith(currentEmotion: EmotionalState.proud);
        break;
      case 'character_crisis':
        _characters[character.id] = character.copyWith(currentEmotion: EmotionalState.sad);
        break;
    }
  }

  void _createInteractionEvent(String relationshipId, RelationshipEvent eventType, 
                              String description, double intensity, bool playerInitiated) {
    final interactionId = 'interaction_${DateTime.now().millisecondsSinceEpoch}';
    
    final interaction = RelationshipInteraction(
      id: interactionId,
      relationshipId: relationshipId,
      eventType: eventType,
      description: description,
      timestamp: DateTime.now(),
      playerInitiated: playerInitiated,
      intensity: intensity,
    );

    _interactions[interactionId] = interaction;
  }

  void _updateSocialInfluence() {
    _socialInfluence = 0.0;
    double reputationSum = 0.0;
    int relationshipCount = 0;

    for (final relationship in _relationships.values) {
      if (relationship.isActive) {
        _socialInfluence += relationship.overallBond * 0.1;
        reputationSum += relationship.respect;
        relationshipCount++;
      }
    }

    if (relationshipCount > 0) {
      _reputationScore = reputationSum / relationshipCount;
    }

    _socialInfluence = _socialInfluence.clamp(0.0, 1.0);
    _reputationScore = _reputationScore.clamp(0.0, 1.0);
  }

  // Public Interface Methods
  Relationship? getRelationshipWithCharacter(String characterId) {
    return _relationships.values
        .where((rel) => rel.characterId == characterId && rel.isActive)
        .firstOrNull;
  }

  List<Relationship> getRelationshipsByType(RelationshipType type) {
    return _relationships.values
        .where((rel) => rel.type == type && rel.isActive)
        .toList()
        ..sort((a, b) => b.overallBond.compareTo(a.overallBond));
  }

  List<Relationship> getRelationshipsByStatus(RelationshipStatus status) {
    return _relationships.values
        .where((rel) => rel.status == status && rel.isActive)
        .toList()
        ..sort((a, b) => b.overallBond.compareTo(a.overallBond));
  }

  List<Character> getAvailableCharacters() {
    return _characters.values
        .where((char) => char.isAvailable)
        .toList()
        ..sort((a, b) => a.name.compareTo(b.name));
  }

  List<RelationshipInteraction> getRecentInteractions({int limit = 10}) {
    final interactions = _interactions.values.toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    
    return interactions.take(limit).toList();
  }

  List<Character> getCloseContacts() {
    final closeRelationships = _relationships.values
        .where((rel) => rel.isActive && rel.overallBond > 0.6)
        .toList()
        ..sort((a, b) => b.overallBond.compareTo(a.overallBond));

    return closeRelationships
        .map((rel) => _characters[rel.characterId])
        .where((char) => char != null)
        .cast<Character>()
        .toList();
  }

  bool canStartRomance(String characterId) {
    final relationship = getRelationshipWithCharacter(characterId);
    if (relationship == null) return false;

    return relationship.affection > 0.5 && 
           relationship.attraction > 0.4 && 
           !relationship.isRomantic &&
           _currentRomanticPartner == null;
  }

  double getCharacterLoyalty(String characterId) {
    final relationship = getRelationshipWithCharacter(characterId);
    return relationship?.loyalty ?? 0.0;
  }

  void dispose() {
    _systemTimer?.cancel();
    super.dispose();
  }
}

// Advanced Relationship Dashboard Widget
class AdvancedRelationshipDashboardWidget extends StatefulWidget {
  const AdvancedRelationshipDashboardWidget({super.key});

  @override
  State<AdvancedRelationshipDashboardWidget> createState() => _AdvancedRelationshipDashboardWidgetState();
}

class _AdvancedRelationshipDashboardWidgetState extends State<AdvancedRelationshipDashboardWidget>
    with TickerProviderStateMixin {
  final AdvancedRelationshipSystem _relationshipSystem = AdvancedRelationshipSystem();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _relationshipSystem,
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
    final currentPartner = _relationshipSystem.currentRomanticPartner;
    final partner = currentPartner != null ? _relationshipSystem.characters[currentPartner] : null;
    
    return Row(
      children: [
        const Text(
          'Relationships',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        if (partner != null) ...[
          const Icon(Icons.favorite, color: Colors.red),
          const SizedBox(width: 8),
          Text('Partner: ${partner.name}'),
        ],
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatCard('Contacts', '${_relationshipSystem.totalCharacters}'),
        _buildStatCard('Active', '${_relationshipSystem.activeRelationships}'),
        _buildStatCard('Influence', '${(_relationshipSystem.socialInfluence * 100).toInt()}%'),
        _buildStatCard('Reputation', '${(_relationshipSystem.reputationScore * 100).toInt()}%'),
      ],
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Expanded(
      child: Card(
        color: Colors.blue[50],
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
        Tab(text: 'Characters', icon: Icon(Icons.people)),
        Tab(text: 'Relationships', icon: Icon(Icons.favorite)),
        Tab(text: 'Interactions', icon: Icon(Icons.chat)),
        Tab(text: 'Networks', icon: Icon(Icons.hub)),
      ],
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildCharactersTab(),
        _buildRelationshipsTab(),
        _buildInteractionsTab(),
        _buildNetworksTab(),
      ],
    );
  }

  Widget _buildCharactersTab() {
    final characters = _relationshipSystem.getAvailableCharacters();
    
    return ListView.builder(
      itemCount: characters.length,
      itemBuilder: (context, index) {
        final character = characters[index];
        return _buildCharacterTile(character);
      },
    );
  }

  Widget _buildCharacterTile(Character character) {
    final relationship = _relationshipSystem.getRelationshipWithCharacter(character.id);
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: _getEmotionColor(character.currentEmotion),
          child: Text(character.name[0]),
        ),
        title: Text('${character.name} "${character.nickname}"'),
        subtitle: Text('${character.occupation} - ${relationship?.status.name ?? 'Unknown'}'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Background: ${character.background}'),
                const SizedBox(height: 8),
                if (relationship != null) _buildRelationshipBars(relationship),
                const SizedBox(height: 8),
                _buildInteractionButtons(character),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelationshipBars(Relationship relationship) {
    return Column(
      children: [
        _buildRelationshipBar('Affection', relationship.affection),
        _buildRelationshipBar('Respect', relationship.respect),
        _buildRelationshipBar('Trust', relationship.trust),
        _buildRelationshipBar('Loyalty', relationship.loyalty),
        if (relationship.attraction > 0.1)
          _buildRelationshipBar('Attraction', relationship.attraction),
      ],
    );
  }

  Widget _buildRelationshipBar(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: const TextStyle(fontSize: 12)),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: (value + 1.0) / 2.0, // Convert from -1,1 to 0,1
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(_getRelationshipColor(value)),
            ),
          ),
          const SizedBox(width: 8),
          Text('${(value * 100).toInt()}%', style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildInteractionButtons(Character character) {
    return Wrap(
      spacing: 8,
      children: [
        ElevatedButton(
          onPressed: () => _interact(character, RelationshipEvent.meeting),
          child: const Text('Talk'),
        ),
        ElevatedButton(
          onPressed: () => _interact(character, RelationshipEvent.favor),
          child: const Text('Favor'),
        ),
        ElevatedButton(
          onPressed: () => _interact(character, RelationshipEvent.gift),
          child: const Text('Gift'),
        ),
        if (_relationshipSystem.canStartRomance(character.id))
          ElevatedButton(
            onPressed: () => _interact(character, RelationshipEvent.romance),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
            child: const Text('Romance'),
          ),
      ],
    );
  }

  Widget _buildRelationshipsTab() {
    final relationships = _relationshipSystem.relationships.values
        .where((rel) => rel.isActive)
        .toList()
      ..sort((a, b) => b.overallBond.compareTo(a.overallBond));

    return ListView.builder(
      itemCount: relationships.length,
      itemBuilder: (context, index) {
        final relationship = relationships[index];
        final character = _relationshipSystem.characters[relationship.characterId];
        if (character == null) return const SizedBox.shrink();
        
        return _buildRelationshipTile(relationship, character);
      },
    );
  }

  Widget _buildRelationshipTile(Relationship relationship, Character character) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _getRelationshipStatusColor(relationship.status),
        child: Text(character.name[0]),
      ),
      title: Text(character.name),
      subtitle: Text('${relationship.status.name} - Bond: ${(relationship.overallBond * 100).toInt()}%'),
      trailing: Text('${relationship.relationshipDuration.inDays}d'),
    );
  }

  Widget _buildInteractionsTab() {
    final interactions = _relationshipSystem.getRecentInteractions();
    
    return ListView.builder(
      itemCount: interactions.length,
      itemBuilder: (context, index) {
        final interaction = interactions[index];
        final relationship = _relationshipSystem.relationships[interaction.relationshipId];
        final character = relationship != null ? _relationshipSystem.characters[relationship.characterId] : null;
        
        return ListTile(
          leading: Icon(
            _getEventIcon(interaction.eventType),
            color: interaction.playerInitiated ? Colors.blue : Colors.orange,
          ),
          title: Text(interaction.description),
          subtitle: Text(character?.name ?? 'Unknown'),
          trailing: Text(_formatDateTime(interaction.timestamp)),
        );
      },
    );
  }

  Widget _buildNetworksTab() {
    final networks = _relationshipSystem.socialNetworks.values.toList();
    
    return ListView.builder(
      itemCount: networks.length,
      itemBuilder: (context, index) {
        final network = networks[index];
        return ListTile(
          leading: const Icon(Icons.hub),
          title: Text(network.name),
          subtitle: Text('${network.networkType} - ${network.members.length} members'),
          trailing: Text('Cohesion: ${(network.cohesion * 100).toInt()}%'),
        );
      },
    );
  }

  void _interact(Character character, RelationshipEvent eventType) {
    _relationshipSystem.interactWithCharacter(character.id, eventType);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${eventType.name} with ${character.name}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Color _getEmotionColor(EmotionalState emotion) {
    switch (emotion) {
      case EmotionalState.happy:
      case EmotionalState.excited:
      case EmotionalState.grateful:
        return Colors.green;
      case EmotionalState.angry:
      case EmotionalState.disgusted:
        return Colors.red;
      case EmotionalState.sad:
      case EmotionalState.disappointed:
        return Colors.blue;
      case EmotionalState.fearful:
        return Colors.purple;
      case EmotionalState.surprised:
        return Colors.orange;
      case EmotionalState.jealous:
        return Colors.yellow[700]!;
      case EmotionalState.proud:
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  Color _getRelationshipColor(double value) {
    if (value < -0.3) return Colors.red;
    if (value < 0.0) return Colors.orange;
    if (value < 0.3) return Colors.yellow[700]!;
    if (value < 0.6) return Colors.lightGreen;
    return Colors.green;
  }

  Color _getRelationshipStatusColor(RelationshipStatus status) {
    switch (status) {
      case RelationshipStatus.enemy:
        return Colors.red;
      case RelationshipStatus.nemesis:
        return Colors.red[900]!;
      case RelationshipStatus.stranger:
        return Colors.grey;
      case RelationshipStatus.acquaintance:
        return Colors.blue[200]!;
      case RelationshipStatus.friend:
        return Colors.blue;
      case RelationshipStatus.closeFriend:
        return Colors.green;
      case RelationshipStatus.bestFriend:
        return Colors.green[700]!;
      case RelationshipStatus.romantic:
      case RelationshipStatus.lover:
      case RelationshipStatus.partner:
        return Colors.pink;
      case RelationshipStatus.ally:
        return Colors.purple;
      case RelationshipStatus.confidant:
        return Colors.indigo;
    }
  }

  IconData _getEventIcon(RelationshipEvent eventType) {
    switch (eventType) {
      case RelationshipEvent.meeting:
        return Icons.chat;
      case RelationshipEvent.favor:
        return Icons.help;
      case RelationshipEvent.gift:
        return Icons.card_giftcard;
      case RelationshipEvent.romance:
        return Icons.favorite;
      case RelationshipEvent.betrayal:
        return Icons.heart_broken;
      case RelationshipEvent.conflict:
        return Icons.warning;
      case RelationshipEvent.cooperation:
        return Icons.handshake;
      case RelationshipEvent.rescue:
        return Icons.security;
      default:
        return Icons.circle;
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
