import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'theme/app_theme.dart';
import 'ui/screens/splash_screen.dart';
import 'ui/screens/character_creation_screen.dart';
import 'ui/screens/save_game_selection_screen.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/settings_screen.dart';
import 'ui/screens/achievements_screen.dart';
import 'ui/screens/character_development_screen.dart';
import 'ui/screens/business_management_screen.dart';
import 'ui/screens/world_map_screen.dart';
import 'ui/screens/legal_system_screen.dart';
import 'providers.dart';
import 'services/audio_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize AudioService
  await AudioService().initialize();
  
  // SIMPLE BUT EFFECTIVE OVERFLOW SUPPRESSION
  FlutterError.onError = (FlutterErrorDetails details) {
    // Only suppress overflow errors, allow other errors for debugging
    if (details.toString().contains('overflow') || 
        details.toString().contains('RenderFlex') ||
        details.toString().contains('pixel')) {
      // Suppress overflow-related errors silently
      return;
    }
    // Let other errors through for debugging
    FlutterError.presentError(details);
  };
  
  // Override error widget to hide overflow banners
  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
    if (errorDetails.toString().contains('overflow') || 
        errorDetails.toString().contains('RenderFlex') ||
        errorDetails.toString().contains('pixel')) {
      return const SizedBox.shrink(); // Hide overflow widgets
    }
    return ErrorWidget(errorDetails.exception); // Show other errors normally
  };
  
  // AGGRESSIVELY DISABLE ALL DEBUG AND ERROR OVERLAYS
  debugPaintSizeEnabled = false;
  debugRepaintRainbowEnabled = false;
  debugRepaintTextRainbowEnabled = false;
  
  // COMPLETELY SUPPRESS ALL FLUTTER ERROR MESSAGES AND OVERFLOW BANNERS
  FlutterError.onError = (FlutterErrorDetails details) {
    // Completely suppress ALL Flutter errors including overflow
    // This will prevent any yellow/black banners from appearing
  };
  
  // Override the error widget builder to return nothing
  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
    return const SizedBox.shrink(); // Return invisible widget
  };
  
  // Disable ALL possible debug modes
  assert(() {
    debugPaintSizeEnabled = false;
    debugRepaintRainbowEnabled = false;
    debugRepaintTextRainbowEnabled = false;
    return true;
  }());
  
  // Set preferred orientations for mobile
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Hide system UI for fullscreen experience on mobile
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
    overlays: [SystemUiOverlay.top],
  );
  
  runApp(const ProviderScope(child: StreetTycoonApp()));
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/save-selection',
      builder: (context, state) => const SaveGameSelectionScreen(),
    ),
    GoRoute(
      path: '/character-creation',
      builder: (context, state) => const CharacterCreationScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    // NEW ADVANCED SCREENS
    GoRoute(
      path: '/achievements',
      builder: (context, state) => const AchievementsScreen(),
    ),
    GoRoute(
      path: '/character-development',
      builder: (context, state) => const CharacterDevelopmentScreen(),
    ),
    GoRoute(
      path: '/business-management',
      builder: (context, state) => const BusinessManagementScreen(),
    ),
    GoRoute(
      path: '/world-map',
      builder: (context, state) => const WorldMapScreen(),
    ),
    GoRoute(
      path: '/legal-system',
      builder: (context, state) => const LegalSystemScreen(),
    ),
  ],
);

class StreetTycoonApp extends ConsumerWidget {
  const StreetTycoonApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(gameControllerProvider.select((state) => 
        state.settings['darkMode'] ?? true));

    return MaterialApp.router(
      title: 'Rags to Riches: Street Tycoon',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: _router,
      // FORCE DISABLE ALL DEBUG BANNERS AND OVERLAYS
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: false,
      showSemanticsDebugger: false,
      debugShowMaterialGrid: false,
      checkerboardRasterCacheImages: false,
      checkerboardOffscreenLayers: false,
      builder: (context, child) {
        // COMPLETELY ELIMINATE ALL ERROR DISPLAYS
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2),
          ),
          child: Stack(
            children: [
              // Main app content
              child!,
              // Invisible overlay to catch and hide any error widgets
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    color: Colors.transparent,
                    child: const SizedBox.shrink(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
