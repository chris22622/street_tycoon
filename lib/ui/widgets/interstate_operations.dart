import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../logic/interstate_service.dart' as interstate;
import '../../providers.dart';

class InterstateOperationsWidget extends ConsumerStatefulWidget {
  const InterstateOperationsWidget({super.key});

  @override
  ConsumerState<InterstateOperationsWidget> createState() => _InterstateOperationsWidgetState();
}

class _InterstateOperationsWidgetState extends ConsumerState<InterstateOperationsWidget> {
  String? selectedState;
  List<interstate.State> availableStates = [];
  List<interstate.InterstateRoute> availableRoutes = [];

  @override
  void initState() {
    super.initState();
    availableStates = interstate.InterstateOperationsService.getAvailableStates();
    availableRoutes = interstate.InterstateOperationsService.getInterstateRoutes();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameControllerProvider);
    final currentState = gameState.area; // Using area as current state for now

    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🗺️ Interstate Criminal Operations',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Current Location: $currentState',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.map), text: 'Travel'),
              Tab(icon: Icon(Icons.business), text: 'Opportunities'),
              Tab(icon: Icon(Icons.info), text: 'Intel'),
            ],
          ),
          
          Expanded(
            child: TabBarView(
              children: [
                _buildTravelTab(),
                _buildOpportunitiesTab(),
                _buildIntelTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTravelTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🚗 Interstate Travel',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          // Available States
          Text(
            'Available States:',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          
          ...availableStates.map((state) => Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Text(
                state.icon,
                style: const TextStyle(fontSize: 24),
              ),
              title: Text(
                '${state.name} (${state.abbreviation})',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Travel Cost: \$${state.travelCost.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'),
                  Text('Difficulty: ${state.operationalDifficulty}/100'),
                  Text('Major Cities: ${state.majorCities.join(", ")}'),
                  if (state.features.isNotEmpty)
                    Text('Features: ${state.features.keys.join(", ")}'),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: () => _showTravelDialog(state),
                child: const Text('Travel'),
              ),
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildOpportunitiesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '💰 Criminal Opportunities',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          ...availableStates.map((state) {
            final opportunities = interstate.InterstateOperationsService.getStateOpportunities(state);
            if (opportunities.isEmpty) return const SizedBox.shrink();
            
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${state.icon} ${state.name}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    ...opportunities.map((opp) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            opp['title'] as String,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(opp['description'] as String),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Investment: \$${(opp['investment'] as int).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'),
                                  Text('Monthly Income: \$${(opp['monthly_income'] as int).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'),
                                  Text('Risk Level: ${opp['risk_level']}/100'),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () => _showInvestmentDialog(opp, state),
                                child: const Text('Invest'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )).toList(),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildIntelTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📊 State Intelligence',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          ...availableStates.map((state) => Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${state.icon} ${state.name}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Law Enforcement Strength
                  Text(
                    'Law Enforcement:',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  ...state.lawEnforcementStrength.entries.map((entry) => 
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(entry.key.toUpperCase()),
                          Text('${entry.value}/100'),
                        ],
                      ),
                    ),
                  ).toList(),
                  
                  const SizedBox(height: 12),
                  
                  // Drug Price Multipliers
                  Text(
                    'Drug Price Multipliers:',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  ...state.drugPrices.entries.map((entry) => 
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(entry.key.toUpperCase()),
                          Text('${(entry.value * 100).toInt()}%'),
                        ],
                      ),
                    ),
                  ).toList(),
                  
                  const SizedBox(height: 12),
                  
                  // State Features
                  if (state.features.isNotEmpty) ...[
                    Text(
                      'Special Features:',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 4),
                      child: Wrap(
                        spacing: 8,
                        children: state.features.keys.map((feature) => 
                          Chip(
                            label: Text(
                              feature.replaceAll('_', ' ').toUpperCase(),
                              style: const TextStyle(fontSize: 10),
                            ),
                            backgroundColor: Colors.blue.shade100,
                          ),
                        ).toList(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          )).toList(),
        ],
      ),
    );
  }

  void _showTravelDialog(interstate.State destinationState) {
    final gameState = ref.read(gameControllerProvider);
    final playerMoney = gameState.cash;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('🗺️ Travel to ${destinationState.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${destinationState.icon} ${destinationState.name} (${destinationState.abbreviation})'),
            const SizedBox(height: 12),
            Text('Travel Cost: \$${destinationState.travelCost.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'),
            Text('Operational Difficulty: ${destinationState.operationalDifficulty}/100'),
            Text('Your Money: \$${playerMoney.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'),
            const SizedBox(height: 12),
            if (playerMoney < destinationState.travelCost)
              const Text(
                '❌ Insufficient funds for travel!',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 8),
            Text('Major Cities: ${destinationState.majorCities.join(", ")}'),
            if (destinationState.features.isNotEmpty)
              Text('Special Features: ${destinationState.features.keys.join(", ")}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          if (playerMoney >= destinationState.travelCost)
            ElevatedButton(
              onPressed: () {
                // Execute travel using existing method (for now using standard travel cost)
                ref.read(gameControllerProvider.notifier).travel(destinationState.name);
                Navigator.of(context).pop();
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('✈️ Traveled to ${destinationState.name}! New opportunities await.'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Travel'),
            ),
        ],
      ),
    );
  }

  void _showInvestmentDialog(Map<String, dynamic> opportunity, interstate.State state) {
    final gameState = ref.read(gameControllerProvider);
    final playerMoney = gameState.cash;
    final investment = opportunity['investment'] as int;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('💰 ${opportunity['title']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${state.icon} ${state.name}'),
            const SizedBox(height: 12),
            Text(opportunity['description'] as String),
            const SizedBox(height: 12),
            Text('Investment Required: \$${investment.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'),
            Text('Monthly Income: \$${(opportunity['monthly_income'] as int).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'),
            Text('Risk Level: ${opportunity['risk_level']}/100'),
            Text('Your Money: \$${playerMoney.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'),
            const SizedBox(height: 12),
            if (playerMoney < investment)
              const Text(
                '❌ Insufficient funds for investment!',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          if (playerMoney >= investment)
            ElevatedButton(
              onPressed: () {
                // Execute investment - for now just show message (will be implemented with proper state management)
                Navigator.of(context).pop();
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('💼 Investment feature coming soon! ${opportunity['title']} looks promising.'),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
              child: const Text('Invest'),
            ),
        ],
      ),
    );
  }
}
