import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/territory_models.dart';
import '../../providers.dart';
import '../../util/formatters.dart';
import '../../services/audio_service.dart';

class TerritoryControlWidget extends ConsumerWidget {
  const TerritoryControlWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameControllerProvider);
    final territory = gameState.territoryControl ?? TerritoryControl.initial();
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          // Territory overview card
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.map, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Territory Control',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getInfluenceColor(territory.influence),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${territory.territoryCount} Areas',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatChip(
                          'Income: ${Formatters.money(territory.totalDailyIncome)}/day',
                          Colors.green,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: _buildStatChip(
                          'Control: ${territory.averageControl.round()}%',
                          _getControlColor(territory.averageControl),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Current territories
          if (territory.territories.isNotEmpty)
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Controlled Territories:',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ...territory.territories.map((t) => _buildTerritoryCard(t, ref)),
                  ],
                ),
              ),
            ),

          // Expansion options
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Expansion:',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _buildExpansionOptions(gameState, ref),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTerritoryCard(Territory territory, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: _getControlColor(territory.controlLevel).withOpacity(0.3)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Text(territory.type.icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  territory.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  '${territory.type.name} • ${territory.controlLevel.round()}% control',
                  style: TextStyle(
                    fontSize: 10,
                    color: _getControlColor(territory.controlLevel),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${Formatters.money(territory.dailyIncome)}/day',
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (territory.underAttack)
                const Text(
                  'Under Attack!',
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpansionOptions(dynamic gameState, WidgetRef ref) {
    return Column(
      children: TerritoryTemplates.available.map((template) {
        final type = template['type'] as TerritoryType;
        final canAfford = gameState.cash >= type.cost;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              Text(type.icon, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${template['name']} - ${Formatters.money(type.cost)}',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '${Formatters.money(type.dailyIncome)}/day income',
                      style: const TextStyle(fontSize: 9, color: Colors.green),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 24,
                child: ElevatedButton(
                  onPressed: canAfford ? () => _expandTerritory(type, template['name'], ref) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getTypeColor(type),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  child: const Text(
                    'Expand',
                    style: TextStyle(fontSize: 9),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Color _getInfluenceColor(int influence) {
    if (influence >= 75) return Colors.purple;
    if (influence >= 50) return Colors.blue;
    if (influence >= 25) return Colors.orange;
    return Colors.grey;
  }

  Color _getControlColor(double control) {
    if (control >= 80) return Colors.green;
    if (control >= 60) return Colors.blue;
    if (control >= 40) return Colors.orange;
    return Colors.red;
  }

  Color _getTypeColor(TerritoryType type) {
    switch (type) {
      case TerritoryType.street:
        return Colors.grey;
      case TerritoryType.neighborhood:
        return Colors.blue;
      case TerritoryType.district:
        return Colors.purple;
      case TerritoryType.borough:
        return Colors.red;
    }
  }

  void _expandTerritory(TerritoryType type, String name, WidgetRef ref) {
    final gameController = ref.read(gameControllerProvider.notifier);
    
    // Play expansion sound
    AudioService().playSoundEffect(SoundEffect.buy);
    
    gameController.expandTerritoryNew(type, name);
  }
}
