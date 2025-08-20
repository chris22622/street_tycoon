import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../logic/prison_service.dart';
import '../../providers.dart';
import '../../util/formatters.dart';

class PrisonOperationsWidget extends ConsumerWidget {
  const PrisonOperationsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameControllerProvider);
    
    if (!gameState.inPrison) {
      return const SizedBox.shrink();
    }

    final facility = PrisonService.getCurrentFacility(gameState.prisonData);
    final operations = PrisonService.getAvailableOperations(facility);
    final activeOps = PrisonService.getActiveOperations(gameState.prisonData);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPrisonHeader(context, facility),
            const SizedBox(height: 16),
            _buildFacilityInfo(context, facility),
            const SizedBox(height: 16),
            _buildActiveOperations(context, activeOps),
            const SizedBox(height: 16),
            _buildAvailableOperations(context, ref, operations, gameState.cash),
          ],
        ),
      ),
    );
  }

  Widget _buildPrisonHeader(BuildContext context, PrisonFacility facility) {
    return Row(
      children: [
        Text(
          facility.icon,
          style: const TextStyle(fontSize: 32),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                facility.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Security Level: ${facility.securityLevel}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: _getSecurityColor(facility.securityLevel),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.orange.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.gavel, color: Colors.orange, size: 16),
              const SizedBox(width: 4),
              Text(
                'INCARCERATED',
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFacilityInfo(BuildContext context, PrisonFacility facility) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Facility Information',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            facility.description,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildInfoChip(context, 'Risk Factor', '${facility.riskFactor}%', Colors.red),
              const SizedBox(width: 8),
              _buildInfoChip(context, 'Profit Multiplier', '${facility.profitMultiplier}x', Colors.green),
              const SizedBox(width: 8),
              _buildInfoChip(context, 'Max Operations', '${facility.maxOperations}', Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveOperations(BuildContext context, List<PrisonOperation> activeOps) {
    if (activeOps.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue),
            const SizedBox(width: 8),
            Text(
              'No active operations. Start building your prison empire!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.blue[700],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Active Operations',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...activeOps.map((op) => _buildActiveOperationCard(context, op)),
      ],
    );
  }

  Widget _buildActiveOperationCard(BuildContext context, PrisonOperation operation) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Text(
            operation.icon,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  operation.name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Earning: \$${Formatters.money(operation.dailyIncome)}/day',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.green[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'ACTIVE',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableOperations(
    BuildContext context, 
    WidgetRef ref, 
    List<PrisonOperation> operations, 
    int playerCash
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Operations',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemCount: operations.length,
          itemBuilder: (context, index) {
            final operation = operations[index];
            final canAfford = playerCash >= operation.startupCost;
            
            return _buildOperationCard(context, ref, operation, canAfford);
          },
        ),
      ],
    );
  }

  Widget _buildOperationCard(
    BuildContext context, 
    WidgetRef ref, 
    PrisonOperation operation, 
    bool canAfford
  ) {
    final riskColor = _getRiskColor(operation.riskLevel);
    
    return Card(
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: riskColor.withOpacity(0.3),
            width: 2,
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              riskColor.withOpacity(0.1),
              riskColor.withOpacity(0.05),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: riskColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      operation.icon,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: riskColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _getRiskText(operation.riskLevel),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: riskColor,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              Text(
                operation.name,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 4),
              
              Text(
                operation.description,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const Spacer(),
              
              // Income and Cost
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Income: \$${Formatters.money(operation.dailyIncome)}/day',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Startup: \$${Formatters.money(operation.startupCost)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: canAfford ? Colors.blue[700] : Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              SizedBox(
                width: double.infinity,
                height: 32,
                child: ElevatedButton(
                  onPressed: canAfford ? () => _startOperation(ref, operation) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: riskColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text(
                    'START',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getSecurityColor(String securityLevel) {
    switch (securityLevel) {
      case 'Minimum':
        return Colors.green;
      case 'Medium':
        return Colors.orange;
      case 'Maximum':
        return Colors.red;
      case 'Super Maximum':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Color _getRiskColor(int riskLevel) {
    if (riskLevel <= 2) return Colors.green;
    if (riskLevel <= 4) return Colors.orange;
    return Colors.red;
  }

  String _getRiskText(int riskLevel) {
    if (riskLevel <= 2) return 'LOW';
    if (riskLevel <= 4) return 'MED';
    return 'HIGH';
  }

  void _startOperation(WidgetRef ref, PrisonOperation operation) {
    showDialog(
      context: ref.context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text(operation.icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            Expanded(child: Text('Start ${operation.name}?')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Startup Cost: \$${Formatters.money(operation.startupCost)}'),
            Text('Daily Income: \$${Formatters.money(operation.dailyIncome)}'),
            Text('Risk Level: ${operation.riskLevel}/5'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning, color: Colors.orange, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'RISKS',
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Prison operations may result in:',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '• Solitary confinement',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '• Additional charges',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '• Extended sentence',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '• Transfer to higher security facility',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _confirmOperationStart(ref, operation);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Start Operation'),
          ),
        ],
      ),
    );
  }

  void _confirmOperationStart(WidgetRef ref, PrisonOperation operation) {
    final controller = ref.read(gameControllerProvider.notifier);
    controller.startPrisonOperation(operation.id, operation.startupCost);
    
    ScaffoldMessenger.of(ref.context).showSnackBar(
      SnackBar(
        content: Text('${operation.name} started! Watch for guards...'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
