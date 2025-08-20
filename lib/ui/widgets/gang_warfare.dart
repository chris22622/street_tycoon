import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers.dart';

class GangWarfareWidget extends ConsumerWidget {
  GangWarfareWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameControllerProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🏴‍☠️ Gang Warfare Operations',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Current Location: ${gameState.area} | Cash: \$${gameState.cash}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.green,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          
          // Quick Actions Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '⚡ Quick Gang Actions',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ElevatedButton.icon(
                        onPressed: gameState.cash >= 5000
                            ? () {
                                final gangController = ref.read(gameControllerProvider.notifier);
                                final newRecruits = [
                                  'Tony "The Tiger" Marconi',
                                  'Vincent "Vinny" Rodriguez', 
                                  'Marcus "Steel" Johnson',
                                  'Isabella "Ice" Petrov',
                                  'Carlos "The Knife" Santos',
                                  'Rachel "Red" Murphy',
                                  'Angelo "Angel" Dimaggio'
                                ];
                                final recruitName = newRecruits[DateTime.now().millisecond % newRecruits.length];
                                gangController.recruitGangMember(recruitName, 5000);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('👥 Recruited $recruitName! Gang strength increased! 🔥'),
                                    backgroundColor: Colors.indigo,
                                  ),
                                );
                              }
                            : null,
                        icon: const Icon(Icons.people),
                        label: const Text('Recruit (\$5K)'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                      ),
                      ElevatedButton.icon(
                        onPressed: gameState.cash >= 10000
                            ? () {
                                final gangController = ref.read(gameControllerProvider.notifier);
                                final targets = [
                                  'Salvatore "Sal" Romano (Iron Wolves)',
                                  'Dmitri "The Bear" Volkov (Blood Serpents)',
                                  'Maria "Black Widow" Gonzalez (Shadow Runners)',
                                  'Viktor "The Viper" Petrov (Steel Ravens)',
                                  'Chen "Dragon" Li (Night Stalkers)'
                                ];
                                final target = targets[DateTime.now().millisecond % targets.length];
                                gangController.executeHit(target, 10000);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('🎯 Hit on $target executed! Message sent! 💀'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            : null,
                        icon: const Icon(Icons.local_fire_department),
                        label: const Text('Execute Hit (\$10K)'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      ),
                      ElevatedButton.icon(
                        onPressed: gameState.cash >= 15000
                            ? () {
                                final gangController = ref.read(gameControllerProvider.notifier);
                                final territories = [
                                  'Downtown Financial District',
                                  'Riverside Docks',
                                  'Industrial Warehouse Zone',
                                  'Uptown Shopping District',
                                  'Old Town Historic Quarter'
                                ];
                                final territory = territories[DateTime.now().millisecond % territories.length];
                                gangController.expandTerritory(territory, 15000);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('🗺️ Expanded into $territory! Territory secured! 💪'),
                                    backgroundColor: Colors.purple,
                                  ),
                                );
                              }
                            : null,
                        icon: const Icon(Icons.location_city),
                        label: const Text('Expand Territory (\$15K)'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Gang Status Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '👑 Gang Empire Status',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('💰 Cash: \$${gameState.cash}'),
                            const Text('👥 Gang Members: 0'),
                            const Text('🗺️ Territories: 0'),
                            Text('🔥 Heat Level: ${gameState.heat}/100'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('⚔️ Rivals Eliminated: 0'),
                            const Text('🎯 Successful Hits: 0'),
                            const Text('💎 Reputation: Rising'),
                            const Text('🛡️ Protection: None'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Instructions Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📋 Gang Operations Guide',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  const Text('• 👥 Recruit Members - Build your crew for operations'),
                  const Text('• 🎯 Execute Hits - Eliminate rival gang members'),
                  const Text('• 🗺️ Expand Territory - Control more neighborhoods'),
                  const Text('• 💰 Generate Income - Use assets for passive money'),
                  const Text('• 🛡️ Bribe Officials - Reduce heat and investigations'),
                  const Text('• ⚔️ Gang Wars - Battle other criminal organizations'),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: const Text(
                      '⚠️ Higher level operations increase police heat! Use corruption to stay under the radar.',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
