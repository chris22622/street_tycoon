import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  // Settings
  bool _musicEnabled = true;
  bool _sfxEnabled = true;
  double _musicVolume = 0.7;
  double _sfxVolume = 0.8;

  // Getters
  bool get musicEnabled => _musicEnabled;
  bool get sfxEnabled => _sfxEnabled;
  double get musicVolume => _musicVolume;
  double get sfxVolume => _sfxVolume;

  // Initialize audio service
  Future<void> initialize() async {
    try {
      if (kDebugMode) {
        print('AudioService initialized with multi-feedback system');
        print('🎵 Platform: ${defaultTargetPlatform.toString()}');
        
        // Test platform-specific audio on initialization
        if (defaultTargetPlatform == TargetPlatform.android) {
          print('🎵 Android detected - testing audio...');
          try {
            await SystemSound.play(SystemSoundType.click);
            print('🎵 Android initial audio test: SUCCESS');
          } catch (e) {
            print('🎵 Android initial audio test: FAILED - $e');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('AudioService initialized with limited functionality: $e');
      }
    }
  }

  // Music control (placeholder for future implementation)
  Future<void> playBackgroundMusic() async {
    if (!_musicEnabled) return;
    if (kDebugMode) {
      print('Background music would start here');
    }
  }

  Future<void> stopBackgroundMusic() async {
    if (kDebugMode) {
      print('Background music stopped');
    }
  }

  Future<void> pauseBackgroundMusic() async {
    if (kDebugMode) {
      print('Background music paused');
    }
  }

  Future<void> resumeBackgroundMusic() async {
    if (!_musicEnabled) return;
    if (kDebugMode) {
      print('Background music resumed');
    }
  }

  // Enhanced sound effects with multiple feedback types
  Future<void> playSoundEffect(SoundEffect effect) async {
    if (!_sfxEnabled) return;

    try {
      // Multiple feedback approaches for maximum compatibility
      switch (effect) {
        case SoundEffect.buy:
          await _playFeedback(
            systemSound: SystemSoundType.click,
            haptic: HapticFeedback.lightImpact,
            debugMessage: 'Buy sound played',
          );
          break;
        case SoundEffect.sell:
          await _playFeedback(
            systemSound: SystemSoundType.click,
            haptic: HapticFeedback.mediumImpact,
            debugMessage: 'Sell sound played',
          );
          break;
        case SoundEffect.money:
          await _playFeedback(
            systemSound: SystemSoundType.click,
            haptic: HapticFeedback.heavyImpact,
            debugMessage: 'Money sound played',
            extraFeedback: true,
          );
          break;
        case SoundEffect.notification:
          await _playFeedback(
            systemSound: SystemSoundType.alert,
            haptic: HapticFeedback.lightImpact,
            debugMessage: 'Notification sound played',
          );
          break;
        case SoundEffect.achievement:
          await _playFeedback(
            systemSound: SystemSoundType.alert,
            haptic: HapticFeedback.heavyImpact,
            debugMessage: 'Achievement sound played',
            extraFeedback: true,
          );
          break;
        case SoundEffect.alert:
          await _playFeedback(
            systemSound: SystemSoundType.alert,
            haptic: HapticFeedback.heavyImpact,
            debugMessage: 'Alert sound played',
            extraFeedback: true,
          );
          break;
        case SoundEffect.button:
          await _playFeedback(
            systemSound: SystemSoundType.click,
            haptic: HapticFeedback.selectionClick,
            debugMessage: 'Button sound played',
          );
          break;
        case SoundEffect.travel:
          await _playFeedback(
            systemSound: SystemSoundType.click,
            haptic: HapticFeedback.mediumImpact,
            debugMessage: 'Travel sound played',
          );
          break;
        case SoundEffect.upgrade:
          await _playFeedback(
            systemSound: SystemSoundType.click,
            haptic: HapticFeedback.heavyImpact,
            debugMessage: 'Upgrade sound played',
            extraFeedback: true,
          );
          break;
        case SoundEffect.endDay:
          await _playFeedback(
            systemSound: SystemSoundType.click,
            haptic: HapticFeedback.mediumImpact,
            debugMessage: 'End day sound played',
          );
          break;
        case SoundEffect.weapons:
          await _playFeedback(
            systemSound: SystemSoundType.alert,
            haptic: HapticFeedback.heavyImpact,
            debugMessage: 'Weapons sound played',
            extraFeedback: true,
          );
          break;
        case SoundEffect.federal:
          await _playFeedback(
            systemSound: SystemSoundType.alert,
            haptic: HapticFeedback.heavyImpact,
            debugMessage: 'Federal alert sound played',
            extraFeedback: true,
          );
          break;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error playing sound effect ${effect.toString()}: $e');
      }
    }
  }

  // Enhanced feedback system
  Future<void> _playFeedback({
    required SystemSoundType systemSound,
    required Future<void> Function() haptic,
    required String debugMessage,
    bool extraFeedback = false,
  }) async {
    try {
      // Always print debug message so user knows audio system is working
      print('🎵 $debugMessage');
      print('🎵 Platform: ${defaultTargetPlatform.toString()}');

      // Android-specific handling with multiple fallbacks
      if (defaultTargetPlatform == TargetPlatform.android) {
        print('🎵 Android audio system activated');
        
        // Try multiple Android audio approaches
        try {
          // Primary: Try the requested sound type
          await SystemSound.play(systemSound);
          print('🎵 Android SystemSound ${systemSound.toString()} SUCCESS');
        } catch (e) {
          print('🎵 Android SystemSound ${systemSound.toString()} FAILED: $e');
          
          // Fallback 1: Try click sound
          try {
            await SystemSound.play(SystemSoundType.click);
            print('🎵 Android SystemSound.click SUCCESS');
          } catch (e2) {
            print('🎵 Android SystemSound.click FAILED: $e2');
            
            // Fallback 2: Try alert sound
            try {
              await SystemSound.play(SystemSoundType.alert);
              print('🎵 Android SystemSound.alert SUCCESS');
            } catch (e3) {
              print('🎵 Android all SystemSounds FAILED: $e3');
            }
          }
        }
        
        // Always do haptic feedback for Android (this usually works)
        try {
          await HapticFeedback.lightImpact();
          await Future.delayed(const Duration(milliseconds: 20));
          await HapticFeedback.selectionClick();
          print('🎵 Android haptic feedback SUCCESS');
          
          if (extraFeedback) {
            await Future.delayed(const Duration(milliseconds: 50));
            await HapticFeedback.mediumImpact();
            await Future.delayed(const Duration(milliseconds: 20));
            await HapticFeedback.heavyImpact();
            print('🎵 Android extra haptic SUCCESS');
          }
        } catch (e) {
          print('🎵 Android haptic FAILED: $e');
        }
        
      } else {
        // Windows/Desktop handling (working)
        print('🎵 Desktop audio system activated');
        try {
          await SystemSound.play(systemSound);
          print('🎵 Desktop SystemSound SUCCESS');
        } catch (e) {
          print('🎵 Desktop SystemSound FAILED: $e');
        }
        
        try {
          await haptic();
          print('🎵 Desktop haptic SUCCESS');
        } catch (e) {
          print('🎵 Desktop haptic FAILED: $e');
        }
        
        if (extraFeedback) {
          await Future.delayed(const Duration(milliseconds: 100));
          try {
            await haptic();
            await SystemSound.play(systemSound);
            print('🎵 Desktop extra feedback SUCCESS');
          } catch (e) {
            print('🎵 Desktop extra feedback FAILED: $e');
          }
        }
      }
      
    } catch (e) {
      print('🎵 CRITICAL AUDIO ERROR: $e');
      // Final fallback - triple haptic
      try {
        await HapticFeedback.heavyImpact();
        await Future.delayed(const Duration(milliseconds: 100));
        await HapticFeedback.heavyImpact();
        await Future.delayed(const Duration(milliseconds: 100));
        await HapticFeedback.heavyImpact();
        print('🎵 Emergency triple haptic played');
      } catch (finalError) {
        print('🎵 Even emergency haptic failed: $finalError');
      }
    }
  }

  // Settings
  void setMusicEnabled(bool enabled) {
    _musicEnabled = enabled;
    if (kDebugMode) {
      print('Music enabled: $enabled');
    }
  }

  void setSfxEnabled(bool enabled) {
    _sfxEnabled = enabled;
    if (kDebugMode) {
      print('SFX enabled: $enabled');
    }
  }

  void setMusicVolume(double volume) {
    _musicVolume = volume.clamp(0.0, 1.0);
    if (kDebugMode) {
      print('Music volume: $_musicVolume');
    }
  }

  void setSfxVolume(double volume) {
    _sfxVolume = volume.clamp(0.0, 1.0);
    if (kDebugMode) {
      print('SFX volume: $_sfxVolume');
    }
  }

  // Clean up
  void dispose() {
    if (kDebugMode) {
      print('AudioService disposed');
    }
  }
}

// Sound effect enumeration
enum SoundEffect {
  buy,
  sell,
  money,
  notification,
  achievement,
  alert,
  button,
  travel,
  upgrade,
  endDay,
  weapons,
  federal,
}
