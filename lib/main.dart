import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'theme/app_theme.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/character_creation_screen.dart';
import 'ui/screens/settings_screen.dart';
import 'ui/screens/achievements_screen.dart';
import 'ui/screens/character_development_screen.dart';
import 'ui/screens/business_management_screen.dart';
import 'ui/screens/world_map_screen.dart';
import 'ui/screens/legal_system_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: StreetTycoonApp()));
}

final _router = GoRouter(
  initialLocation: '/character-creation',
  routes: [
    GoRoute(path: '/character-creation', builder: (context, state) => const CharacterCreationScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
    GoRoute(path: '/achievements', builder: (context, state) => const AchievementsScreen()),
    GoRoute(path: '/character-development', builder: (context, state) => const CharacterDevelopmentScreen()),
    GoRoute(path: '/business-management', builder: (context, state) => const BusinessManagementScreen()),
    GoRoute(path: '/world-map', builder: (context, state) => const WorldMapScreen()),
    GoRoute(path: '/legal-system', builder: (context, state) => const LegalSystemScreen()),
  ],
);

class StreetTycoonApp extends StatelessWidget {
  const StreetTycoonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Street Tycoon',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: _router,
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'theme/app_theme.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/character_creation_screen.dart';
import 'ui/screens/save_selection_screen.dart';
import 'ui/screens/settings_screen.dart';
import 'ui/screens/achievements_screen.dart';
import 'ui/screens/character_development_screen.dart';
import 'ui/screens/business_management_screen.dart';
import 'ui/screens/world_map_screen.dart';
import 'ui/screens/legal_system_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: StreetTycoonApp()));
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SaveSelectionScreen()),
    GoRoute(path: '/save-selection', builder: (context, state) => const SaveSelectionScreen()),
    GoRoute(path: '/character-creation', builder: (context, state) => const CharacterCreationScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
    GoRoute(path: '/achievements', builder: (context, state) => const AchievementsScreen()),
    GoRoute(path: '/character-development', builder: (context, state) => const CharacterDevelopmentScreen()),
    GoRoute(path: '/business-management', builder: (context, state) => const BusinessManagementScreen()),
    GoRoute(path: '/world-map', builder: (context, state) => const WorldMapScreen()),
    GoRoute(path: '/legal-system', builder: (context, state) => const LegalSystemScreen()),
  ],
);

class StreetTycoonApp extends StatelessWidget {
  const StreetTycoonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Street Tycoon',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: _router,
    );
  }
}
