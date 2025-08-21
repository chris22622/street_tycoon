import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

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
  
  void initialize() {
    _startAmbienceSystem();
  }

  void dispose() {
    _ambienceTimer?.cancel();
  }

  void setMasterVolume(double volume) {
    _masterVolume = volume.clamp(0.0, 1.0);
  }

  void setCategoryVolume(SoundCategory category, double volume) {
    _categoryVolumes[category] = volume.clamp(0.0, 1.0);
  }

  void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  void updateListenerPosition(Offset position) {
    // Position updated for future spatial audio implementation
  }

  Future<void> playSound(
    String soundPath, {
    SoundCategory category = SoundCategory.effects,
    double volume = 1.0,
    bool loop = false,
    SpatialPosition? spatialPosition,
    Offset? worldPosition,
    String? playerId,
  }) async {
    if (!_isEnabled) return;

    // Use system sound for UI feedback
    if (category == SoundCategory.ui) {
      HapticFeedback.lightImpact();
    }
    
    // For other sounds, we would integrate with a proper audio library
    debugPrint('Playing sound: $soundPath (Volume: $volume)');
  }

  void _startAmbienceSystem() {
    _ambienceTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _updateAmbience();
    });
  }

  void _updateAmbience() {
    final hour = DateTime.now().hour;
    String ambienceTrack;
    
    if (hour >= 6 && hour < 18) {
      ambienceTrack = 'city_day';
    } else if (hour >= 18 && hour < 22) {
      ambienceTrack = 'city_evening';
    } else {
      ambienceTrack = 'city_night';
    }
    
    debugPrint('Current ambience: $ambienceTrack');
  }

  // Game-specific audio methods
  void playDealSound(bool success) {
    if (success) {
      HapticFeedback.lightImpact();
    }
  }

  void playMoneySound(double amount) {
    HapticFeedback.lightImpact();
  }

  void playUISound(String uiAction) {
    HapticFeedback.lightImpact();
  }
}

// Audio settings widget
class AudioSettingsWidget extends StatefulWidget {
  const AudioSettingsWidget({super.key});

  @override
  State<AudioSettingsWidget> createState() => _AudioSettingsWidgetState();
}

class _AudioSettingsWidgetState extends State<AudioSettingsWidget> {
  final AudioManager _audioManager = AudioManager();

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
