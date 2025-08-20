import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../logic/federal_service.dart';
import '../../providers.dart';

class FederalInvestigationsWidget extends ConsumerWidget {
  const FederalInvestigationsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameControllerProvider);
    final agencies = FederalService.getAllAgencies();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.account_balance, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Federal Investigations',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                _buildOverallHeatLevel(context, gameState.statistics['totalSales'] ?? 0),
              ],
            ),
            const SizedBox(height: 16),
            
            // Agency Status Cards
            ...agencies.map((agency) => _buildAgencyCard(context, ref, agency, gameState)),
            
            const SizedBox(height: 16),
            
            // Active Investigations Summary
            _buildActiveInvestigations(context, gameState),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallHeatLevel(BuildContext context, int totalSales) {
    final heatLevel = FederalService.calculateOverallHeatLevel(totalSales, 0, {});
    final color = _getHeatColor(heatLevel);
    final levelText = _getHeatLevelText(heatLevel);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_fire_department, color: color, size: 16),
          const SizedBox(width: 4),
          Text(
            'Heat: $levelText',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgencyCard(BuildContext context, WidgetRef ref, FederalAgency agency, gameState) {
    final totalSales = gameState.statistics['totalSales'] ?? 0;
    final weapons = gameState.weapons;
    final investigationChance = FederalService.calculateInvestigationChance(
      agency, totalSales, 0, weapons
    );
    
    final riskLevel = _getRiskLevel(investigationChance);
    final riskColor = _getRiskColor(investigationChance);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: riskColor.withOpacity(0.3),
              width: 1,
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
                        color: riskColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        agency.icon,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            agency.name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            agency.fullName,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: riskColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        riskLevel,
                        style: TextStyle(
                          color: riskColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                Text(
                  agency.description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                
                const SizedBox(height: 12),
                
                // Investigation Progress Bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Investigation Risk',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${(investigationChance * 100).toStringAsFixed(1)}%',
                          style: TextStyle(
                            color: riskColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: investigationChance,
                      backgroundColor: Colors.grey.withOpacity(0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(riskColor),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Focus Areas
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: agency.focusAreas.map((area) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      area,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.blue[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveInvestigations(BuildContext context, gameState) {
    // This would show ongoing investigations
    // For now, we'll show a placeholder or potential future investigations
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.search, color: Colors.orange, size: 20),
              const SizedBox(width: 8),
              Text(
                'Intelligence Reports',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          _buildIntelligenceItem(
            context,
            '📱 Phone Taps',
            'DEA monitoring suspicious communications patterns',
            Colors.red,
          ),
          
          _buildIntelligenceItem(
            context,
            '💰 Financial Surveillance',
            'IRS-CI tracking unusual cash flow patterns',
            Colors.orange,
          ),
          
          _buildIntelligenceItem(
            context,
            '🔫 Weapons Tracking',
            'ATF investigating firearms acquisition patterns',
            Colors.red,
          ),
          
          _buildIntelligenceItem(
            context,
            '👥 Associate Monitoring',
            'FBI building network analysis of known associates',
            Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildIntelligenceItem(BuildContext context, String title, String description, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getHeatColor(int heatLevel) {
    switch (heatLevel) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.red;
      case 5:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _getHeatLevelText(int heatLevel) {
    switch (heatLevel) {
      case 1:
        return 'Cold';
      case 2:
        return 'Warm';
      case 3:
        return 'Hot';
      case 4:
        return 'Burning';
      case 5:
        return 'Inferno';
      default:
        return 'Unknown';
    }
  }

  String _getRiskLevel(double investigationChance) {
    if (investigationChance < 0.1) return 'LOW';
    if (investigationChance < 0.3) return 'MEDIUM';
    if (investigationChance < 0.6) return 'HIGH';
    return 'CRITICAL';
  }

  Color _getRiskColor(double investigationChance) {
    if (investigationChance < 0.1) return Colors.green;
    if (investigationChance < 0.3) return Colors.yellow;
    if (investigationChance < 0.6) return Colors.orange;
    return Colors.red;
  }
}
