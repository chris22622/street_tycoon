import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers.dart';
import '../../data/constants.dart';
import '../../theme/app_theme.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameControllerProvider);

    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: Text('Settings', style: AppTheme.heading.copyWith(fontSize: 20)),
        backgroundColor: AppTheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: AppTheme.gold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Game Progress'),
          const SizedBox(height: 8),
          _buildCard(
            child: Column(
              children: [
                _buildStatRow(
                    'Day', '${gameState.day}/${gameState.daysLimit}',
                    progress: gameState.day / gameState.daysLimit),
                const Divider(color: Colors.white12, height: 24),
                _buildStatRow('Area', gameState.area),
                const Divider(color: Colors.white12, height: 24),
                _buildStatRow('Heat Level', '${gameState.heat}/100',
                    progress: gameState.heat / 100,
                    barColor: gameState.heat > 70
                        ? AppTheme.danger
                        : gameState.heat > 40
                            ? AppTheme.warning
                            : AppTheme.success),
                const Divider(color: Colors.white12, height: 24),
                _buildStatRow(
                    'Rap Sheet', '${gameState.rapSheet.length} entries'),
                const Divider(color: Colors.white12, height: 24),
                _buildStatRow(
                    'Big Moves', '${gameState.habits['bigMoves'] ?? 0}'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Gameplay'),
          const SizedBox(height: 8),
          _buildCard(
            child: Column(
              children: [
                SwitchListTile(
                  title: Text('Dark Mode',
                      style: AppTheme.body
                          .copyWith(fontWeight: FontWeight.w600)),
                  subtitle: Text('Use dark theme',
                      style: AppTheme.body
                          .copyWith(fontSize: 12, color: Colors.white54)),
                  value: gameState.settings['darkMode'] ?? true,
                  activeColor: AppTheme.gold,
                  onChanged: (value) {
                    ref
                        .read(gameControllerProvider.notifier)
                        .updateSettings({'darkMode': value});
                  },
                ),
                const Divider(color: Colors.white12, height: 1),
                ListTile(
                  title: Text('New Game',
                      style: AppTheme.body
                          .copyWith(fontWeight: FontWeight.w600)),
                  subtitle: Text('Start fresh (loses current progress)',
                      style: AppTheme.body
                          .copyWith(fontSize: 12, color: Colors.white54)),
                  trailing: OutlinedButton(
                    onPressed: () =>
                        _showNewGameConfirmation(context, ref),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppTheme.danger),
                      foregroundColor: AppTheme.danger,
                    ),
                    child: const Text('Reset'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Audio'),
          const SizedBox(height: 8),
          _buildCard(
            child: SwitchListTile(
              title: Text('Sound Effects',
                  style: AppTheme.body
                      .copyWith(fontWeight: FontWeight.w600)),
              subtitle: Text('Play sound effects',
                  style: AppTheme.body
                      .copyWith(fontSize: 12, color: Colors.white54)),
              value: gameState.settings['sound'] ?? true,
              activeColor: AppTheme.gold,
              onChanged: (value) {
                ref
                    .read(gameControllerProvider.notifier)
                    .updateSettings({'sound': value});
              },
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('About'),
          const SizedBox(height: 8),
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Rags to Riches: Street Tycoon',
                          style: AppTheme.heading.copyWith(fontSize: 16)),
                      const SizedBox(height: 4),
                      Text('Version 1.0.0',
                          style: AppTheme.body
                              .copyWith(color: Colors.white54, fontSize: 12)),
                      const SizedBox(height: 12),
                      Text(
                        'This is a fictional simulation game for entertainment purposes only.',
                        style: AppTheme.body.copyWith(
                            fontStyle: FontStyle.italic,
                            color: Colors.white54,
                            fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white12, height: 1),
                ListTile(
                  title: Text('Content Disclaimer',
                      style: AppTheme.body
                          .copyWith(fontWeight: FontWeight.w600)),
                  trailing:
                      const Icon(Icons.chevron_right, color: Colors.white54),
                  onTap: () => _showDisclaimer(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title.toUpperCase(),
        style: AppTheme.label.copyWith(
          color: AppTheme.gold,
          fontSize: 12,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: child,
    );
  }

  Widget _buildStatRow(String label, String value,
      {double? progress, Color barColor = AppTheme.gold}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: AppTheme.body.copyWith(color: Colors.white70)),
              Text(value,
                  style: AppTheme.body
                      .copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          if (progress != null) ...[
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                backgroundColor: Colors.white12,
                valueColor: AlwaysStoppedAnimation<Color>(barColor),
                minHeight: 4,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showDisclaimer(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text('Content Disclaimer',
            style: AppTheme.heading.copyWith(fontSize: 18)),
        content: SingleChildScrollView(
          child: Text(CONTENT_DISCLAIMER,
              style: AppTheme.body.copyWith(fontSize: 13)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child:
                const Text('Close', style: TextStyle(color: AppTheme.gold)),
          ),
        ],
      ),
    );
  }

  void _showNewGameConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text('New Game',
            style: AppTheme.heading.copyWith(fontSize: 18)),
        content: Text(
          'Are you sure you want to start a new game? This will delete your current progress.',
          style: AppTheme.body.copyWith(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(gameControllerProvider.notifier).newGame();
              Navigator.of(context).pop();
              context.pop();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.danger),
            child: const Text('New Game'),
          ),
        ],
      ),
    );
  }
}
