import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/crimes.dart';
import '../../providers.dart';

class CrimeSheet extends ConsumerWidget {
  const CrimeSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameControllerProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(Icons.warning, color: Colors.red, size: 24),
              const SizedBox(width: 8),
              const Text(
                'Criminal Activities',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Fictional criminal activities for entertainment only',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),
          
          // Energy status
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.bolt,
                  color: _getEnergyColor(gameState.energy),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Energy: ${gameState.energy}/100',
                  style: TextStyle(
                    color: _getEnergyColor(gameState.energy),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Crime list
          Expanded(
            child: ListView.builder(
              itemCount: kCrimes.length,
              itemBuilder: (context, index) {
                final crime = kCrimes[index];
                final canAfford = gameState.energy >= crime.energyCost;
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  color: canAfford ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getCrimeColor(crime.baseSuccess),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getCrimeIcon(crime.key),
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      crime.name,
                      style: TextStyle(
                        color: canAfford ? Colors.white : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          crime.desc,
                          style: TextStyle(
                            color: canAfford ? Colors.white70 : Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _buildInfoChip('⚡${crime.energyCost}', Colors.blue),
                            const SizedBox(width: 4),
                            _buildInfoChip('\$${_formatRange(crime.minPayout, crime.maxPayout)}', Colors.green),
                            const SizedBox(width: 4),
                            _buildInfoChip(_getRiskLevel(crime.baseSuccess), _getRiskColor(crime.baseSuccess)),
                          ],
                        ),
                      ],
                    ),
                    trailing: canAfford 
                      ? const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16)
                      : const Icon(Icons.block, color: Colors.red, size: 16),
                    onTap: canAfford ? () => _commitCrime(context, ref, crime.key) : () => _showEnergyWarning(context),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getEnergyColor(int energy) {
    if (energy > 60) return Colors.green;
    if (energy > 30) return Colors.amber;
    return Colors.red;
  }

  Color _getCrimeColor(double baseSuccess) {
    if (baseSuccess > 0.5) return Colors.green;
    if (baseSuccess > 0.3) return Colors.orange;
    return Colors.red;
  }

  Color _getRiskColor(double baseSuccess) {
    if (baseSuccess > 0.5) return Colors.green;
    if (baseSuccess > 0.3) return Colors.orange;
    return Colors.red;
  }

  String _getRiskLevel(double baseSuccess) {
    if (baseSuccess > 0.5) return '● Low Risk';
    if (baseSuccess > 0.3) return '●● Med Risk';
    return '●●● High Risk';
  }

  IconData _getCrimeIcon(String crimeKey) {
    switch (crimeKey) {
      case 'pickpocket':
        return Icons.person;
      case 'shoplift':
        return Icons.shopping_bag;
      case 'car_breakin':
        return Icons.directions_car;
      case 'burglary':
        return Icons.home;
      case 'mugging':
        return Icons.group;
      case 'online_scam':
        return Icons.computer;
      case 'bank_fraud':
        return Icons.account_balance;
      case 'armored_ambush':
        return Icons.local_shipping;
      default:
        return Icons.warning;
    }
  }

  String _formatRange(int min, int max) {
    return '${_formatMoney(min)}-${_formatMoney(max)}';
  }

  String _formatMoney(int amount) {
    if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}k';
    }
    return amount.toString();
  }

  void _commitCrime(BuildContext context, WidgetRef ref, String crimeKey) {
    Navigator.of(context).pop();
    ref.read(gameControllerProvider.notifier).commitCrime(crimeKey);
  }

  void _showEnergyWarning(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Too tired—end day first to restore energy.'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
