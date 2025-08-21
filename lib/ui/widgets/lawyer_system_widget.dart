import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/lawyer_models.dart';
import '../../providers.dart';
import '../../util/formatters.dart';

class LawyerSystemWidget extends ConsumerStatefulWidget {
  const LawyerSystemWidget({super.key});

  @override
  ConsumerState<LawyerSystemWidget> createState() => _LawyerSystemWidgetState();
}

class _LawyerSystemWidgetState extends ConsumerState<LawyerSystemWidget> {
  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameControllerProvider);
    final controller = ref.read(gameControllerProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '⚖️ Legal System',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // Court Balance & Current Retainer
          _buildLegalStatus(gameState),
          const SizedBox(height: 20),
          
          // Available Lawyers
          _buildAvailableLawyers(gameState, controller),
          const SizedBox(height: 20),
          
          // Legal History
          _buildLegalHistory(gameState),
        ],
      ),
    );
  }

  Widget _buildLegalStatus(gameState) {
    final legalSystem = gameState.legalSystem ?? const LegalSystem();
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Legal Status',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Court Balance: \$${Formatters.money(legalSystem.courtBalance)}'),
                    Text('Total Legal Fees: \$${Formatters.money(legalSystem.totalLegalFees)}'),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (legalSystem.currentRetainer != null)
                      Text(
                        'Current Lawyer: ${legalSystem.currentRetainer!.tier.name}',
                        style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      )
                    else
                      const Text(
                        'No Current Retainer',
                        style: TextStyle(color: Colors.red),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableLawyers(gameState, controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Available Lawyers',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          
          ...LawyerTier.values.map((tier) => _buildLawyerOption(tier, gameState, controller)).toList(),
        ],
      ),
    );
  }

  Widget _buildLawyerOption(LawyerTier tier, gameState, controller) {
    final currentRetainer = gameState.legalSystem?.currentRetainer;
    final isCurrentLawyer = currentRetainer?.tier == tier;
    final canAfford = gameState.cash >= tier.retainerCost;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCurrentLawyer 
            ? Colors.green.withOpacity(0.2)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCurrentLawyer ? Colors.green : Colors.grey,
          width: isCurrentLawyer ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(tier.icon, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  tier.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isCurrentLawyer ? Colors.green : null,
                  ),
                ),
              ),
              if (isCurrentLawyer)
                const Icon(Icons.check_circle, color: Colors.green)
              else
                Text(
                  '\$${Formatters.money(tier.retainerCost)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: canAfford ? Colors.blue : Colors.red,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            tier.description,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text('Success Rate: ${(tier.successRate * 100).toInt()}%'),
              ),
              Expanded(
                child: Text('Hourly: \$${tier.hourlyRate}'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          if (!isCurrentLawyer && tier != LawyerTier.publicDefender)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: canAfford ? () => _hireLawyer(tier, controller) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: canAfford ? Colors.blue : Colors.grey,
                ),
                child: Text(
                  canAfford ? 'Hire Lawyer' : 'Insufficient Funds',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          
          if (isCurrentLawyer)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _fireLawyer(controller),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Fire Lawyer', style: TextStyle(color: Colors.white)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLegalHistory(gameState) {
    final legalSystem = gameState.legalSystem ?? const LegalSystem();
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Legal History',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          
          if (legalSystem.retainerHistory.isEmpty)
            const Text('No previous legal representation')
          else
            ...legalSystem.retainerHistory.take(5).map((retainer) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Text(retainer.tier.icon),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${retainer.tier.name} - ${retainer.casesHandled.length} cases',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  Text(
                    '\$${Formatters.money(retainer.retainerPaid)}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )).toList(),
        ],
      ),
    );
  }

  void _hireLawyer(LawyerTier tier, controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hire ${tier.name}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Retainer Fee: \$${Formatters.money(tier.retainerCost)}'),
              Text('Hourly Rate: \$${tier.hourlyRate}'),
              Text('Success Rate: ${(tier.successRate * 100).toInt()}%'),
              const SizedBox(height: 12),
              Text(
                tier.description,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 12),
              const Text(
                'This lawyer will represent you in all legal matters and improve your chances in court.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.hireLawyer(tier);
              Navigator.pop(context);
            },
            child: const Text('Hire'),
          ),
        ],
      ),
    );
  }

  void _fireLawyer(controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Fire Current Lawyer'),
        content: const Text('Are you sure you want to fire your current lawyer? You will lose any remaining retainer balance.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.fireLawyer();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Fire'),
          ),
        ],
      ),
    );
  }
}
