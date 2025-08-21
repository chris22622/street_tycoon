import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/federal_models.dart';
import '../../logic/federal_meter_service.dart';
import '../../providers.dart';
import '../../util/formatters.dart';
import '../../services/audio_service.dart';

class FederalMeterWidget extends ConsumerStatefulWidget {
  const FederalMeterWidget({super.key});

  @override
  ConsumerState<FederalMeterWidget> createState() => _FederalMeterWidgetState();
}

class _FederalMeterWidgetState extends ConsumerState<FederalMeterWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameControllerProvider);
    final federalMeter = gameState.federalMeter ?? FederalMeter.initial();
    final theme = Theme.of(context);

    // Start pulsing animation for critical levels
    if (federalMeter.isCritical && !_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    } else if (!federalMeter.isCritical && _pulseController.isAnimating) {
      _pulseController.stop();
      _pulseController.reset();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header card
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  // Header
                  Row(
                    children: [
                      const Icon(Icons.account_balance, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Federal Heat Monitor',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      _buildStatusBadge(federalMeter),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Heat meter
                  _buildHeatMeter(federalMeter, theme),
                ],
              ),
            ),
          ),
          
          // Status description card
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getStatusColor(federalMeter.currentLevel).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _getStatusColor(federalMeter.currentLevel).withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    federalMeter.currentLevel.icon,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      federalMeter.currentLevel.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Effects summary card
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: _buildEffectsSummary(federalMeter, theme),
            ),
          ),
          
          // Recent warnings card
          if (federalMeter.activeWarnings.isNotEmpty)
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: _buildWarnings(federalMeter, theme),
              ),
            ),
          
          // Action buttons card
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: _buildActionButtons(federalMeter, gameState),
            ),
          ),
          
          // Federal operations card
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: _buildFederalOperations(federalMeter, gameState),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(FederalMeter meter) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: meter.isCritical ? _pulseAnimation.value : 1.0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getStatusColor(meter.currentLevel),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  meter.currentLevel.icon,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 4),
                Text(
                  meter.currentLevel.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeatMeter(FederalMeter meter, ThemeData theme) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Heat Level: ${meter.level}/100',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Daily Decay: -${meter.dailyDecay}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: meter.level / 100,
            minHeight: 20,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              _getStatusColor(meter.currentLevel),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEffectsSummary(FederalMeter meter, ThemeData theme) {
    final level = meter.currentLevel;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Current Effects:',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: _buildEffectChip(
                'Prices: ${(level.priceImpact * 100).round()}%',
                level.priceImpact < 0 ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _buildEffectChip(
                'Travel: +${((level.travelCostMultiplier - 1) * 100).round()}%',
                level.travelCostMultiplier > 1 ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _buildEffectChip(
                'Risk: +${((level.eventRiskMultiplier - 1) * 100).round()}%',
                level.eventRiskMultiplier > 1 ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEffectChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildWarnings(FederalMeter meter, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.warning, color: Colors.orange, size: 14),
            const SizedBox(width: 4),
            Text(
              'Recent Alerts',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.orange[800],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ...meter.activeWarnings.reversed.take(2).map(
          (warning) => Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              '• $warning',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.orange[700],
                fontSize: 11,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(FederalMeter meter, dynamic gameState) {
    return Row(
      children: [
        // Bribe officials
        Expanded(
          child: ElevatedButton.icon(
            onPressed: meter.level > 10 && gameState.cash >= FederalMeterService.calculateBribeCost(meter)
                ? () => _bribeOfficials(meter)
                : null,
            icon: const Icon(Icons.monetization_on, size: 16),
            label: Text(
              'Bribe (${Formatters.money(FederalMeterService.calculateBribeCost(meter))})',
              style: const TextStyle(fontSize: 12),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        
        const SizedBox(width: 8),
        
        // Lay low
        Expanded(
          child: ElevatedButton.icon(
            onPressed: meter.level > 5 ? () => _layLow() : null,
            icon: const Icon(Icons.visibility_off, size: 16),
            label: const Text(
              'Lay Low (-15 Heat)',
              style: TextStyle(fontSize: 12),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFederalOperations(FederalMeter meter, dynamic gameState) {
    final availableOps = FederalOperations.getAvailableOperations(meter.currentLevel);
    
    if (availableOps.isEmpty || !meter.canOperate) {
      return Row(
        children: [
          const Icon(Icons.block, color: Colors.red, size: 14),
          const SizedBox(width: 6),
          const Expanded(
            child: Text(
              'Operations suspended - heat too high',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Federal Operations:',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        if (availableOps.isNotEmpty) _buildCompactOperationCard(availableOps.first, gameState),
      ],
    );
  }

  Widget _buildCompactOperationCard(FederalOperation operation, dynamic gameState) {
    final canAfford = gameState.cash >= operation.cost;
    
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: _getStatusColor(operation.requiredLevel).withOpacity(0.3)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  operation.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: _getStatusColor(operation.requiredLevel),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  operation.requiredLevel.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            operation.description,
            style: const TextStyle(fontSize: 10),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                '${Formatters.money(operation.cost)} → ${Formatters.money(operation.payout)}',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 24,
                child: ElevatedButton(
                  onPressed: canAfford ? () => _executeOperation(operation) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getStatusColor(operation.requiredLevel),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  child: const Text(
                    'Execute',
                    style: TextStyle(fontSize: 9),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(FederalLevel level) {
    switch (level) {
      case FederalLevel.clear:
        return Colors.green;
      case FederalLevel.watch:
        return Colors.yellow[700]!;
      case FederalLevel.target:
        return Colors.orange;
      case FederalLevel.manhunt:
        return Colors.red;
    }
  }

  void _bribeOfficials(FederalMeter meter) {
    final cost = FederalMeterService.calculateBribeCost(meter);
    final gameController = ref.read(gameControllerProvider.notifier);
    
    // Play bribery sound
    AudioService().playSoundEffect(SoundEffect.money);
    
    gameController.bribeOfficials(cost);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Officials bribed for ${Formatters.money(cost)} - Federal heat reduced'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _layLow() {
    final gameController = ref.read(gameControllerProvider.notifier);
    
    gameController.layLowFederal();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Laying low - Federal heat reduced significantly'),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _executeOperation(FederalOperation operation) {
    final gameController = ref.read(gameControllerProvider.notifier);
    
    // Play federal operation sound
    AudioService().playSoundEffect(SoundEffect.weapons);
    
    gameController.executeFederalOperation(operation);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${operation.name} executed! Earned ${Formatters.money(operation.payout)}'),
        backgroundColor: _getStatusColor(operation.requiredLevel),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
