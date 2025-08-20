import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'theme/app_theme.dart';
import 'ui/screens/splash_screen.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/settings_screen.dart';
import 'providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // FORCE DISABLE ALL DEBUG MODES COMPLETELY
  debugPaintSizeEnabled = false;
  debugRepaintRainbowEnabled = false;
  debugRepaintTextRainbowEnabled = false;
  
  // DISABLE OVERFLOW ERROR MESSAGES
  FlutterError.onError = (FlutterErrorDetails details) {
    // Suppress overflow errors in release builds
    if (!details.toString().contains('RenderFlex overflowed')) {
      FlutterError.presentError(details);
    }
  };
  
  // Override in release and debug mode
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
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
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
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2),
          ),
          child: child!,
        );
      },
    );
  }
}
