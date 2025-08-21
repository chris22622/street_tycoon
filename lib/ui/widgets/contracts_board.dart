import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/contract_models.dart';
import '../../logic/contract_service.dart';
import '../../providers.dart';
import '../../util/formatters.dart';

class ContractsBoard extends ConsumerStatefulWidget {
  const ContractsBoard({super.key});

  @override
  ConsumerState<ContractsBoard> createState() => _ContractsBoardState();
}

class _ContractsBoardState extends ConsumerState<ContractsBoard> {
  @override
  void initState() {
    super.initState();
    ContractService().initialize();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameControllerProvider);
    final contracts = ContractService().activeContracts;

    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.assignment, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Contracts Board',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${contracts.length}/5 Active',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Contracts list
          Expanded(
            child: contracts.isEmpty 
              ? const Center(
                  child: Text(
                    'No contracts available.\nCheck back later!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: contracts.length,
                  itemBuilder: (context, index) {
                    return _ContractCard(
                      contract: contracts[index],
                      gameState: gameState,
                      onAccept: () => _acceptContract(contracts[index]),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }

  void _acceptContract(Contract contract) {
    final gameState = ref.read(gameControllerProvider);
    final playerState = {
      'stash': gameState.stash,
      'cash': gameState.cash,
      'heat': gameState.heat,
      'reputation': 50, // TODO: Add reputation system
    };

    if (ContractService().acceptContract(contract.id, playerState)) {
      final updates = ContractService().fulfillContract(contract.id, playerState);
      
      // Update game state via the new completeContract method
      ref.read(gameControllerProvider.notifier).completeContract(
        contract.adjustedPayout,
        Map<String, int>.from(updates['stash']),
      );
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Contract completed! Earned \$${Formatters.money(contract.adjustedPayout)}'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
      
      setState(() {}); // Refresh UI
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot accept contract - check requirements'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}

class _ContractCard extends StatelessWidget {
  final Contract contract;
  final dynamic gameState;
  final VoidCallback onAccept;

  const _ContractCard({
    required this.contract,
    required this.gameState,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canAccept = _canAcceptContract();
    final timeRemaining = contract.timeRemaining;
    final isUrgent = contract.isUrgent;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _getRarityColor(contract.rarity).withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  // Rarity badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getRarityColor(contract.rarity),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      contract.rarity.shortCode,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 8),
                  
                  // Item and quantity
                  Expanded(
                    child: Text(
                      '${contract.quantity}x ${contract.item}',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  // Timer
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isUrgent ? Colors.red.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.timer,
                          size: 12,
                          color: isUrgent ? Colors.red : Colors.grey[600],
                        ),
                        const SizedBox(width: 2),
                        Text(
                          _formatTimeRemaining(timeRemaining),
                          style: TextStyle(
                            fontSize: 10,
                            color: isUrgent ? Colors.red : Colors.grey[600],
                            fontWeight: isUrgent ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Description
              Text(
                contract.description,
                style: theme.textTheme.bodySmall,
              ),
              
              const SizedBox(height: 8),
              
              // Payout and requirements row
              Row(
                children: [
                  // Payout
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.attach_money, size: 12, color: Colors.green),
                        Text(
                          Formatters.money(contract.adjustedPayout),
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 8),
                  
                  // Penalty
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.warning, size: 12, color: Colors.red),
                        Text(
                          'Penalty: \$${Formatters.money(contract.penalty)}',
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Accept button
                  SizedBox(
                    height: 28,
                    child: ElevatedButton(
                      onPressed: canAccept ? onAccept : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _getRarityColor(contract.rarity),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: Text(
                        canAccept ? 'Accept' : 'Need ${contract.quantity}x',
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _canAcceptContract() {
    final playerInventory = gameState.stash as Map<String, int>? ?? {};
    final currentStock = playerInventory[contract.item] ?? 0;
    return currentStock >= contract.quantity;
  }

  Color _getRarityColor(ContractRarity rarity) {
    switch (rarity) {
      case ContractRarity.common:
        return Colors.grey;
      case ContractRarity.rare:
        return Colors.blue;
      case ContractRarity.epic:
        return Colors.purple;
    }
  }

  String _formatTimeRemaining(Duration duration) {
    if (duration.isNegative) return 'EXPIRED';
    
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else {
      return '${duration.inMinutes}m';
    }
  }
}
