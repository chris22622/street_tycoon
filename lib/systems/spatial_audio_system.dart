import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math' as math;
import 'dart:async';

enum SoundCategory {
  ambience,
  effects,
  music,
  voice,
  ui,
  environment,
}

enum SpatialPosition {
  left,
  right,
  center,
  front,
  back,
  farLeft,
  farRight,
}

class SpatialAudioManager {
  static final SpatialAudioManager _instance = SpatialAudioManager._internal();
  factory SpatialAudioManager() => _instance;
  SpatialAudioManager._internal();

  final Map<String, AudioPlayer> _players = {};
  final Map<SoundCategory, double> _categoryVolumes = {
    SoundCategory.ambience: 0.6,
    SoundCategory.effects: 0.8,
    SoundCategory.music: 0.7,
    SoundCategory.voice: 0.9,
    SoundCategory.ui: 0.5,
    SoundCategory.environment: 0.7,
  };
  
  double _masterVolume = 1.0;
  bool _isEnabled = true;
  Timer? _ambienceTimer;
  
  // Spatial audio properties
  Offset _listenerPosition = const Offset(0, 0);
  double _listenerOrientation = 0; // Radians
  
  // Weather-based audio effects
  String? _currentWeatherAmbience;
  
  void initialize() {
    _startAmbienceSystem();
  }

  void dispose() {
    _ambienceTimer?.cancel();
    for (final player in _players.values) {
      player.dispose();
    }
    _players.clear();
  }

  void setMasterVolume(double volume) {
    _masterVolume = volume.clamp(0.0, 1.0);
    _updateAllVolumes();
  }

  void setCategoryVolume(SoundCategory category, double volume) {
    _categoryVolumes[category] = volume.clamp(0.0, 1.0);
    _updateCategoryVolumes(category);
  }

  void setEnabled(bool enabled) {
    _isEnabled = enabled;
    if (!enabled) {
      _stopAllSounds();
    }
  }

  void updateListenerPosition(Offset position) {
    _listenerPosition = position;
  }

  void updateListenerOrientation(double orientation) {
    _listenerOrientation = orientation;
  }

  Future<void> playSound(
    String soundPath, {
    SoundCategory category = SoundCategory.effects,
    double volume = 1.0,
    bool loop = false,
    SpatialPosition? spatialPosition,
    Offset? worldPosition,
    double? pitch,
    String? playerId,
  }) async {
    if (!_isEnabled) return;

    final id = playerId ?? soundPath;
    
    // Get or create player
    AudioPlayer player;
    if (_players.containsKey(id)) {
      player = _players[id]!;
    } else {
      player = AudioPlayer();
      _players[id] = player;
    }

    // Calculate spatial audio properties
    double finalVolume = volume * _categoryVolumes[category]! * _masterVolume;
    double balance = 0.0; // -1.0 (left) to 1.0 (right)
    
    if (spatialPosition != null) {
      balance = _getSpatialBalance(spatialPosition);
    } else if (worldPosition != null) {
      balance = _calculateWorldPositionBalance(worldPosition);
      finalVolume *= _calculateDistanceAttenuation(worldPosition);
    }

    // Apply spatial effects
    await player.setVolume(finalVolume);
    await player.setBalance(balance);
    
    if (pitch != null) {
      await player.setPlaybackRate(pitch);
    }

    // Play sound
    if (loop) {
      await player.setReleaseMode(ReleaseMode.loop);
    } else {
      await player.setReleaseMode(ReleaseMode.release);
    }

    await player.play(AssetSource(soundPath));
  }

  Future<void> stopSound(String playerId) async {
    if (_players.containsKey(playerId)) {
      await _players[playerId]!.stop();
    }
  }

  Future<void> pauseSound(String playerId) async {
    if (_players.containsKey(playerId)) {
      await _players[playerId]!.pause();
    }
  }

  Future<void> resumeSound(String playerId) async {
    if (_players.containsKey(playerId)) {
      await _players[playerId]!.resume();
    }
  }

  void _stopAllSounds() {
    for (final player in _players.values) {
      player.stop();
    }
  }

  void _updateAllVolumes() {
    for (final category in SoundCategory.values) {
      _updateCategoryVolumes(category);
    }
  }

  void _updateCategoryVolumes(SoundCategory category) {
    // This would require tracking which players belong to which category
    // For now, we'll update all players
    final volume = _categoryVolumes[category]! * _masterVolume;
    for (final player in _players.values) {
      player.setVolume(volume);
    }
  }

  double _getSpatialBalance(SpatialPosition position) {
    switch (position) {
      case SpatialPosition.left:
        return -0.7;
      case SpatialPosition.right:
        return 0.7;
      case SpatialPosition.center:
        return 0.0;
      case SpatialPosition.front:
        return 0.0;
      case SpatialPosition.back:
        return 0.0;
      case SpatialPosition.farLeft:
        return -1.0;
      case SpatialPosition.farRight:
        return 1.0;
    }
  }

  double _calculateWorldPositionBalance(Offset worldPosition) {
    final dx = worldPosition.dx - _listenerPosition.dx;
    return (dx / 500).clamp(-1.0, 1.0); // Normalize to screen width
  }

  double _calculateDistanceAttenuation(Offset worldPosition) {
    final distance = (worldPosition - _listenerPosition).distance;
    const maxDistance = 1000.0;
    return (1.0 - (distance / maxDistance)).clamp(0.1, 1.0);
  }

  void _startAmbienceSystem() {
    _ambienceTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _updateAmbience();
    });
    _updateAmbience(); // Start immediately
  }

  void _updateAmbience() {
    // Play different ambience based on time and weather
    final hour = DateTime.now().hour;
    String ambienceTrack;
    
    if (hour >= 6 && hour < 18) {
      // Daytime
      ambienceTrack = 'audio/ambience/city_day.mp3';
    } else if (hour >= 18 && hour < 22) {
      // Evening
      ambienceTrack = 'audio/ambience/city_evening.mp3';
    } else {
      // Night
      ambienceTrack = 'audio/ambience/city_night.mp3';
    }

    if (_currentWeatherAmbience != ambienceTrack) {
      _currentWeatherAmbience = ambienceTrack;
      playSound(
        ambienceTrack,
        category: SoundCategory.ambience,
        volume: 0.4,
        loop: true,
        playerId: 'main_ambience',
      );
    }
  }

  void updateWeatherAmbience(String weatherType) {
    String? weatherAmbience;
    
    switch (weatherType.toLowerCase()) {
      case 'rainy':
      case 'stormy':
        weatherAmbience = 'audio/ambience/rain.mp3';
        break;
      case 'snowy':
      case 'blizzard':
        weatherAmbience = 'audio/ambience/wind_snow.mp3';
        break;
      case 'windy':
        weatherAmbience = 'audio/ambience/wind.mp3';
        break;
      case 'foggy':
        weatherAmbience = 'audio/ambience/fog_ambient.mp3';
        break;
    }

    if (weatherAmbience != null) {
      playSound(
        weatherAmbience,
        category: SoundCategory.environment,
        volume: 0.3,
        loop: true,
        playerId: 'weather_ambience',
      );
    } else {
      stopSound('weather_ambience');
    }
  }

  // Game-specific audio methods
  void playDealSound(bool success) {
    if (success) {
      playSound(
        'audio/effects/deal_success.mp3',
        category: SoundCategory.effects,
        volume: 0.8,
      );
    } else {
      playSound(
        'audio/effects/deal_failed.mp3',
        category: SoundCategory.effects,
        volume: 0.6,
      );
    }
  }

  void playMoneySound(double amount) {
    String soundFile;
    double volume;
    
    if (amount > 10000) {
      soundFile = 'audio/effects/money_big.mp3';
      volume = 1.0;
    } else if (amount > 1000) {
      soundFile = 'audio/effects/money_medium.mp3';
      volume = 0.8;
    } else {
      soundFile = 'audio/effects/money_small.mp3';
      volume = 0.6;
    }
    
    playSound(
      soundFile,
      category: SoundCategory.effects,
      volume: volume,
    );
  }

  void playPoliceSound(Offset? policePosition) {
    playSound(
      'audio/effects/police_siren.mp3',
      category: SoundCategory.effects,
      volume: 0.9,
      worldPosition: policePosition,
      playerId: 'police_chase',
    );
  }

  void playFootstepsSound(Offset playerPosition, String surface) {
    String soundFile;
    switch (surface) {
      case 'concrete':
        soundFile = 'audio/effects/footsteps_concrete.mp3';
        break;
      case 'grass':
        soundFile = 'audio/effects/footsteps_grass.mp3';
        break;
      case 'gravel':
        soundFile = 'audio/effects/footsteps_gravel.mp3';
        break;
      default:
        soundFile = 'audio/effects/footsteps_default.mp3';
    }
    
    playSound(
      soundFile,
      category: SoundCategory.effects,
      volume: 0.4,
      worldPosition: playerPosition,
      playerId: 'footsteps',
    );
  }

  void playUISound(String uiAction) {
    String soundFile;
    switch (uiAction) {
      case 'click':
        soundFile = 'audio/ui/click.mp3';
        break;
      case 'hover':
        soundFile = 'audio/ui/hover.mp3';
        break;
      case 'error':
        soundFile = 'audio/ui/error.mp3';
        break;
      case 'success':
        soundFile = 'audio/ui/success.mp3';
        break;
      case 'notification':
        soundFile = 'audio/ui/notification.mp3';
        break;
      default:
        soundFile = 'audio/ui/generic.mp3';
    }
    
    playSound(
      soundFile,
      category: SoundCategory.ui,
      volume: 0.5,
    );
  }

  void playVoiceLine(String characterId, String emotion, {Offset? position}) {
    final soundFile = 'audio/voice/${characterId}_$emotion.mp3';
    playSound(
      soundFile,
      category: SoundCategory.voice,
      volume: 0.9,
      worldPosition: position,
      playerId: 'voice_$characterId',
    );
  }

  void playMusicTrack(String trackName, {bool loop = true, double volume = 0.7}) {
    playSound(
      'audio/music/$trackName.mp3',
      category: SoundCategory.music,
      volume: volume,
      loop: loop,
      playerId: 'music_track',
    );
  }

  void crossfadeMusic(String newTrack, {Duration fadeDuration = const Duration(seconds: 3)}) {
    // Implement music crossfading
    playMusicTrack(newTrack);
  }
}

// Audio settings widget
class AudioSettingsWidget extends StatefulWidget {
  const AudioSettingsWidget({super.key});

  @override
  State<AudioSettingsWidget> createState() => _AudioSettingsWidgetState();
}

class _AudioSettingsWidgetState extends State<AudioSettingsWidget> {
  final SpatialAudioManager _audioManager = SpatialAudioManager();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Audio Settings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Master Volume
          _buildVolumeSlider(
            'Master Volume',
            _audioManager._masterVolume,
            (value) => _audioManager.setMasterVolume(value),
          ),
          
          // Category volumes
          ...SoundCategory.values.map((category) => _buildVolumeSlider(
            _getCategoryName(category),
            _audioManager._categoryVolumes[category]!,
            (value) => _audioManager.setCategoryVolume(category, value),
          )),
          
          // Audio enable/disable
          Row(
            children: [
              const Text(
                'Audio Enabled',
                style: TextStyle(color: Colors.white70),
              ),
              const Spacer(),
              Switch(
                value: _audioManager._isEnabled,
                onChanged: (value) {
                  setState(() {
                    _audioManager.setEnabled(value);
                  });
                },
                activeColor: Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVolumeSlider(String label, double value, Function(double) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70),
          ),
          Slider(
            value: value,
            onChanged: (newValue) {
              setState(() {
                onChanged(newValue);
              });
            },
            activeColor: Colors.blue,
            inactiveColor: Colors.grey,
          ),
        ],
      ),
    );
  }

  String _getCategoryName(SoundCategory category) {
    switch (category) {
      case SoundCategory.ambience:
        return 'Ambience';
      case SoundCategory.effects:
        return 'Sound Effects';
      case SoundCategory.music:
        return 'Music';
      case SoundCategory.voice:
        return 'Voice';
      case SoundCategory.ui:
        return 'UI Sounds';
      case SoundCategory.environment:
        return 'Environment';
    }
  }
}

// Dynamic music system
class DynamicMusicSystem {
  static final DynamicMusicSystem _instance = DynamicMusicSystem._internal();
  factory DynamicMusicSystem() => _instance;
  DynamicMusicSystem._internal();

  final SpatialAudioManager _audioManager = SpatialAudioManager();
  String _currentMood = 'calm';
  double _intensity = 0.5;
  Timer? _musicUpdateTimer;

  void initialize() {
    _musicUpdateTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _updateMusic();
    });
  }

  void dispose() {
    _musicUpdateTimer?.cancel();
  }

  void updateGameState({
    required double dangerLevel,
    required double excitement,
    required bool inChase,
    required bool inDeal,
    required String location,
  }) {
    // Calculate music intensity based on game state
    _intensity = (dangerLevel + excitement).clamp(0.0, 1.0);
    
    // Determine mood
    String newMood;
    if (inChase) {
      newMood = 'chase';
    } else if (inDeal) {
      newMood = 'tense';
    } else if (dangerLevel > 0.7) {
      newMood = 'danger';
    } else if (excitement > 0.6) {
      newMood = 'energetic';
    } else {
      newMood = 'calm';
    }

    if (newMood != _currentMood) {
      _currentMood = newMood;
      _updateMusic();
    }
  }

  void _updateMusic() {
    String trackName;
    double volume;

    switch (_currentMood) {
      case 'chase':
        trackName = 'chase_${(_intensity * 3).round() + 1}';
        volume = 0.9;
        break;
      case 'tense':
        trackName = 'tense_${(_intensity * 2).round() + 1}';
        volume = 0.7;
        break;
      case 'danger':
        trackName = 'danger_${(_intensity * 2).round() + 1}';
        volume = 0.8;
        break;
      case 'energetic':
        trackName = 'energetic_${(_intensity * 2).round() + 1}';
        volume = 0.8;
        break;
      default:
        trackName = 'calm_${(_intensity * 2).round() + 1}';
        volume = 0.6;
    }

    _audioManager.crossfadeMusic(trackName, volume: volume);
  }
}

// Sound effect preloader
class AudioPreloader {
  static final AudioPreloader _instance = AudioPreloader._internal();
  factory AudioPreloader() => _instance;
  AudioPreloader._internal();

  final Set<String> _preloadedSounds = {};
  final SpatialAudioManager _audioManager = SpatialAudioManager();

  Future<void> preloadEssentialSounds() async {
    final essentialSounds = [
      'audio/effects/deal_success.mp3',
      'audio/effects/deal_failed.mp3',
      'audio/effects/money_small.mp3',
      'audio/effects/money_medium.mp3',
      'audio/effects/money_big.mp3',
      'audio/effects/police_siren.mp3',
      'audio/ui/click.mp3',
      'audio/ui/hover.mp3',
      'audio/ui/error.mp3',
      'audio/ui/success.mp3',
      'audio/ui/notification.mp3',
      'audio/ambience/city_day.mp3',
      'audio/ambience/city_night.mp3',
      'audio/ambience/rain.mp3',
    ];

    for (final sound in essentialSounds) {
      await _preloadSound(sound);
    }
  }

  Future<void> _preloadSound(String soundPath) async {
    if (_preloadedSounds.contains(soundPath)) return;
    
    try {
      final player = AudioPlayer();
      await player.setSource(AssetSource(soundPath));
      _preloadedSounds.add(soundPath);
      player.dispose();
    } catch (e) {
      debugPrint('Failed to preload sound: $soundPath');
    }
  }

  bool isSoundPreloaded(String soundPath) {
    return _preloadedSounds.contains(soundPath);
  }
}
