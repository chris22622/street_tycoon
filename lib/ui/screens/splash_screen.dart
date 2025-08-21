import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _fadeController;
  late Animation<double> _logoScale;
  late Animation<double> _textOpacity;
  late Animation<double> _fadeOut;

  @override
  void initState() {
    super.initState();
    
    // Initialize animations
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _logoScale = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));
    
    _textOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    ));
    
    _fadeOut = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));
    
    _startSplashSequence();
  }
  
  void _startSplashSequence() async {
    // Use SystemSound instead of AudioPlayer
    try {
      SystemSound.play(SystemSoundType.click);
      print('🎵 Startup sound played via SystemSound');
    } catch (e) {
      print('🎵 Startup sound failed: $e');
    }
    
    // Haptic feedback
    HapticFeedback.heavyImpact();
    
    // Start logo animation
    await _logoController.forward();
    
    // Wait a bit then start text
    await Future.delayed(const Duration(milliseconds: 300));
    await _textController.forward();
    
    // Hold for a moment
    await Future.delayed(const Duration(milliseconds: 1500));
    
    // Fade out and navigate
    await _fadeController.forward();
    
    if (mounted) {
      // Always go to save game selection screen
      // It will handle character creation if no saves exist
      context.go('/save-selection');
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _fadeController.dispose();
    // No need to dispose AudioPlayer since we're using SystemSound
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: _fadeOut,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeOut.value,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1a1a1a),
                    Color(0xFF000000),
                    Color(0xFF1a1a1a),
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo Animation
                    AnimatedBuilder(
                      animation: _logoScale,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _logoScale.value,
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const RadialGradient(
                                colors: [
                                  Color(0xFFFFD700), // Gold
                                  Color(0xFFFF8C00), // Dark Orange
                                  Color(0xFFDC143C), // Crimson
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.amber.withOpacity(0.8),
                                  blurRadius: 30,
                                  spreadRadius: 8,
                                ),
                                BoxShadow(
                                  color: Colors.orange.withOpacity(0.4),
                                  blurRadius: 15,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Crown at top
                                Positioned(
                                  top: 15,
                                  child: Icon(
                                    Icons.star,
                                    size: 30,
                                    color: Colors.black.withOpacity(0.8),
                                  ),
                                ),
                                // Main dollar sign
                                const Icon(
                                  Icons.attach_money,
                                  size: 80,
                                  color: Colors.black,
                                ),
                                // Small money symbols around
                                Positioned(
                                  top: 25,
                                  right: 25,
                                  child: Icon(
                                    Icons.monetization_on,
                                    size: 20,
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                ),
                                Positioned(
                                  bottom: 25,
                                  left: 25,
                                  child: Icon(
                                    Icons.monetization_on,
                                    size: 20,
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Title Animation
                    AnimatedBuilder(
                      animation: _textOpacity,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _textOpacity.value,
                          child: Column(
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) => const LinearGradient(
                                  colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
                                ).createShader(bounds),
                                child: const Text(
                                  'STREET TYCOON™',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 2.0,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'RAGS TO RICHES',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 30),
                              // Loading indicator
                              SizedBox(
                                width: 200,
                                child: LinearProgressIndicator(
                                  backgroundColor: Colors.grey[800],
                                  valueColor: const AlwaysStoppedAnimation<Color>(
                                    Color(0xFFFFD700),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              const Text(
                                'Loading Empire...',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
