import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers.dart';
import '../../data/constants.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameControllerProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Dark Mode'),
                  subtitle: const Text('Use dark theme'),
                  value: gameState.settings['darkMode'] ?? true,
                  onChanged: (value) {
                    ref.read(gameControllerProvider.notifier).updateSettings({
                      'darkMode': value,
                    });
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Sound Effects'),
                  subtitle: const Text('Play sound effects'),
                  value: gameState.settings['sound'] ?? true,
                  onChanged: (value) {
                    ref.read(gameControllerProvider.notifier).updateSettings({
                      'sound': value,
                    });
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          Card(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Show Disclaimer'),
                  subtitle: const Text('Show content disclaimer on startup'),
                  trailing: TextButton(
                    onPressed: () => _showDisclaimer(context),
                    child: const Text('Show Now'),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('New Game'),
                  subtitle: const Text('Start a new game (loses current progress)'),
                  trailing: TextButton(
                    onPressed: () => _showNewGameConfirmation(context, ref),
                    child: const Text('New Game'),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Game Stats',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text('Day: ${gameState.day}/${gameState.daysLimit}'),
                  Text('Area: ${gameState.area}'),
                  Text('Heat Level: ${gameState.heat}/100'),
                  Text('Rap Sheet Entries: ${gameState.rapSheet.length}'),
                  Text('Big Moves: ${gameState.habits['bigMoves'] ?? 0}'),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Rags to Riches: Street Tycoon'),
                  Text('Version 1.0.0'),
                  SizedBox(height: 8),
                  Text(
                    'This is a fictional simulation game for entertainment purposes only.',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDisclaimer(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ Content Disclaimer'),
        content: const SingleChildScrollView(
          child: Text(CONTENT_DISCLAIMER),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showNewGameConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Game'),
        content: const Text('Are you sure you want to start a new game? This will delete your current progress.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(gameControllerProvider.notifier).newGame();
              Navigator.of(context).pop();
              context.pop();
            },
            child: const Text('New Game'),
          ),
        ],
      ),
    );
  }
}
