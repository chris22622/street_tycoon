import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';

class LegalSystemScreen extends ConsumerStatefulWidget {
  const LegalSystemScreen({super.key});

  @override
  ConsumerState<LegalSystemScreen> createState() => _LegalSystemScreenState();
}

class _LegalSystemScreenState extends ConsumerState<LegalSystemScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Legal System'),
        backgroundColor: AppTheme.primaryColor,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.accentColor,
          tabs: const [
            Tab(text: 'Lawyers'),
            Tab(text: 'Court Cases'),
            Tab(text: 'Prison'),
            Tab(text: 'Legal Business'),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.backgroundColor, AppTheme.cardColor],
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildLawyersTab(),
            _buildCourtCasesTab(),
            _buildPrisonTab(),
            _buildLegalBusinessTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildLawyersTab() {
    final lawyers = _getMockLawyers();
    
    return Column(
      children: [
        // Lawyer Overview
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue, width: 2),
          ),
          child: Column(
            children: [
              Text('Legal Representation', style: AppTheme.headingStyle),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text('Active Lawyers', style: AppTheme.bodyStyle.copyWith(fontSize: 12)),
                        Text(
                          '${lawyers.length}',
                          style: AppTheme.headingStyle.copyWith(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text('Monthly Retainer', style: AppTheme.bodyStyle.copyWith(fontSize: 12)),
                        Text(
                          '\$${_calculateRetainerFees(lawyers)}',
                          style: AppTheme.headingStyle.copyWith(
                            fontSize: 20,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _showHireLawyerDialog(),
                icon: const Icon(Icons.add),
                label: const Text('Hire Lawyer'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              ),
            ],
          ),
        ),
        
        // Lawyers List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: lawyers.length,
            itemBuilder: (context, index) {
              final lawyer = lawyers[index];
              return _buildLawyerCard(lawyer);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLawyerCard(Map<String, dynamic> lawyer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.gavel, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lawyer['name'],
                        style: AppTheme.headingStyle.copyWith(fontSize: 16),
                      ),
                      Text(
                        lawyer['specialization'].toUpperCase(),
                        style: AppTheme.bodyStyle.copyWith(fontSize: 12),
                      ),
                      Text(
                        'Experience: ${lawyer['experience']} years',
                        style: AppTheme.bodyStyle.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${lawyer['retainerFee']}/mo',
                      style: AppTheme.headingStyle.copyWith(
                        fontSize: 16,
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      'Win Rate: ${(lawyer['winRate'] * 100).toInt()}%',
                      style: AppTheme.bodyStyle.copyWith(fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Success Rate Indicator
            Row(
              children: [
                Text('Success Rate: ', style: AppTheme.bodyStyle.copyWith(fontSize: 12)),
                Expanded(
                  child: LinearProgressIndicator(
                    value: lawyer['winRate'],
                    backgroundColor: Colors.grey[700],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      lawyer['winRate'] > 0.8 ? Colors.green : 
                      lawyer['winRate'] > 0.6 ? Colors.orange : Colors.red,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text('${(lawyer['winRate'] * 100).toInt()}%', style: AppTheme.bodyStyle.copyWith(fontSize: 12)),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Specializations
            Wrap(
              spacing: 4,
              children: (lawyer['specializations'] as List<String>).map((spec) => 
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    spec.toUpperCase(),
                    style: AppTheme.bodyStyle.copyWith(fontSize: 10),
                  ),
                ),
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourtCasesTab() {
    final courtCases = _getMockCourtCases();
    
    return Column(
      children: [
        // Court Overview
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red, width: 2),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text('Active Cases', style: AppTheme.bodyStyle.copyWith(fontSize: 12)),
                    Text(
                      '${courtCases.where((c) => c['status'] == 'active').length}',
                      style: AppTheme.headingStyle.copyWith(fontSize: 20, color: Colors.red),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text('Won Cases', style: AppTheme.bodyStyle.copyWith(fontSize: 12)),
                    Text(
                      '${courtCases.where((c) => c['status'] == 'won').length}',
                      style: AppTheme.headingStyle.copyWith(fontSize: 20, color: Colors.green),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text('Lost Cases', style: AppTheme.bodyStyle.copyWith(fontSize: 12)),
                    Text(
                      '${courtCases.where((c) => c['status'] == 'lost').length}',
                      style: AppTheme.headingStyle.copyWith(fontSize: 20, color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // Court Cases List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: courtCases.length,
            itemBuilder: (context, index) {
              final courtCase = courtCases[index];
              return _buildCourtCaseCard(courtCase);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCourtCaseCard(Map<String, dynamic> courtCase) {
    final statusColor = _getStatusColor(courtCase['status']);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.balance, color: statusColor, size: 32),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        courtCase['caseNumber'],
                        style: AppTheme.headingStyle.copyWith(fontSize: 16),
                      ),
                      Text(
                        courtCase['chargeType'].toUpperCase(),
                        style: AppTheme.bodyStyle.copyWith(fontSize: 12),
                      ),
                      Text(
                        'Court: ${courtCase['court']}',
                        style: AppTheme.bodyStyle.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    courtCase['status'].toUpperCase(),
                    style: AppTheme.bodyStyle.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            Text(
              'Charges: ${courtCase['charges'].join(', ')}',
              style: AppTheme.bodyStyle.copyWith(fontSize: 12),
            ),
            const SizedBox(height: 8),
            
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Evidence Strength', style: AppTheme.bodyStyle.copyWith(fontSize: 10)),
                      LinearProgressIndicator(
                        value: courtCase['evidenceStrength'],
                        backgroundColor: Colors.grey[700],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          courtCase['evidenceStrength'] > 0.7 ? Colors.red : 
                          courtCase['evidenceStrength'] > 0.4 ? Colors.orange : Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Next Hearing', style: AppTheme.bodyStyle.copyWith(fontSize: 10)),
                    Text(
                      courtCase['nextHearing'],
                      style: AppTheme.bodyStyle.copyWith(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            
            if (courtCase['status'] == 'active') ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _playCourtMinigame(courtCase),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      child: const Text('Attend Hearing'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _negotiatePlea(courtCase),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                      child: const Text('Plea Deal'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPrisonTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Prison Status
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange, width: 2),
            ),
            child: Column(
              children: [
                Text('Prison System', style: AppTheme.headingStyle),
                const SizedBox(height: 16),
                const Icon(Icons.lock, size: 64, color: Colors.orange),
                const SizedBox(height: 16),
                Text(
                  'Currently Free',
                  style: AppTheme.headingStyle.copyWith(color: Colors.green),
                ),
                const SizedBox(height: 8),
                Text(
                  'Keep a low profile and avoid getting caught!',
                  style: AppTheme.bodyStyle.copyWith(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Prison Intel
          Text('Prison Intelligence', style: AppTheme.headingStyle),
          const SizedBox(height: 8),
          
          ..._getPrisonIntel().map((intel) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange),
            ),
            child: Row(
              children: [
                Icon(intel['icon'], color: Colors.orange, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        intel['title'],
                        style: AppTheme.bodyStyle.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        intel['description'],
                        style: AppTheme.bodyStyle.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildLegalBusinessTab() {
    final legalBusinesses = _getMockLegalBusinesses();
    
    return Column(
      children: [
        // Legal Business Overview
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green, width: 2),
          ),
          child: Column(
            children: [
              Text('Legal Business Empire', style: AppTheme.headingStyle),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text('Legal Entities', style: AppTheme.bodyStyle.copyWith(fontSize: 12)),
                        Text(
                          '${legalBusinesses.length}',
                          style: AppTheme.headingStyle.copyWith(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text('Legal Protection', style: AppTheme.bodyStyle.copyWith(fontSize: 12)),
                        Text(
                          '${_calculateLegalProtection(legalBusinesses)}%',
                          style: AppTheme.headingStyle.copyWith(
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _showCreateLegalBusinessDialog(),
                icon: const Icon(Icons.add_business),
                label: const Text('Create Legal Entity'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ],
          ),
        ),
        
        // Legal Businesses List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: legalBusinesses.length,
            itemBuilder: (context, index) {
              final business = legalBusinesses[index];
              return _buildLegalBusinessCard(business);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLegalBusinessCard(Map<String, dynamic> business) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.account_balance, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        business['name'],
                        style: AppTheme.headingStyle.copyWith(fontSize: 16),
                      ),
                      Text(
                        business['type'].toUpperCase(),
                        style: AppTheme.bodyStyle.copyWith(fontSize: 12),
                      ),
                      Text(
                        'Jurisdiction: ${business['jurisdiction']}',
                        style: AppTheme.bodyStyle.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Protection: ${business['protectionLevel']}%',
                      style: AppTheme.headingStyle.copyWith(
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      'Annual Fee: \$${business['annualFee']}',
                      style: AppTheme.bodyStyle.copyWith(fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Protection Level
            Row(
              children: [
                Text('Legal Protection: ', style: AppTheme.bodyStyle.copyWith(fontSize: 12)),
                Expanded(
                  child: LinearProgressIndicator(
                    value: business['protectionLevel'] / 100,
                    backgroundColor: Colors.grey[700],
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ),
                const SizedBox(width: 8),
                Text('${business['protectionLevel']}%', style: AppTheme.bodyStyle.copyWith(fontSize: 12)),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Services
            if (business['services'].isNotEmpty) ...[
              Text('Services:', style: AppTheme.bodyStyle.copyWith(fontSize: 12, fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 4,
                children: (business['services'] as List<String>).map((service) => 
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      service.toUpperCase(),
                      style: AppTheme.bodyStyle.copyWith(fontSize: 10),
                    ),
                  ),
                ).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Helper Methods
  List<Map<String, dynamic>> _getMockLawyers() {
    return [
      {
        'name': 'Victoria Sterling',
        'specialization': 'Criminal Defense',
        'experience': 15,
        'retainerFee': 25000,
        'winRate': 0.85,
        'specializations': ['Drug Cases', 'Money Laundering', 'RICO', 'White Collar'],
      },
      {
        'name': 'Marcus Chen',
        'specialization': 'Corporate Law',
        'experience': 12,
        'retainerFee': 18000,
        'winRate': 0.78,
        'specializations': ['Business Formation', 'Tax Law', 'Securities', 'Mergers'],
      },
      {
        'name': 'Isabella Rodriguez',
        'specialization': 'International Law',
        'experience': 20,
        'retainerFee': 35000,
        'winRate': 0.92,
        'specializations': ['Extradition', 'International Commerce', 'Treaties', 'Offshore'],
      },
    ];
  }

  List<Map<String, dynamic>> _getMockCourtCases() {
    return [
      {
        'caseNumber': 'CR-2024-001234',
        'chargeType': 'Money Laundering',
        'charges': ['Financial Crimes Act Violation', 'Conspiracy'],
        'court': 'Federal District Court',
        'status': 'active',
        'evidenceStrength': 0.6,
        'nextHearing': '2024-03-15',
      },
      {
        'caseNumber': 'CR-2024-001189',
        'chargeType': 'Drug Possession',
        'charges': ['Controlled Substance Possession'],
        'court': 'State Superior Court',
        'status': 'won',
        'evidenceStrength': 0.3,
        'nextHearing': 'Closed',
      },
      {
        'caseNumber': 'CR-2023-009876',
        'chargeType': 'Tax Evasion',
        'charges': ['Federal Tax Evasion', 'Filing False Returns'],
        'court': 'Federal Tax Court',
        'status': 'lost',
        'evidenceStrength': 0.9,
        'nextHearing': 'Sentencing: 2024-04-01',
      },
    ];
  }

  List<Map<String, dynamic>> _getPrisonIntel() {
    return [
      {
        'icon': Icons.group,
        'title': 'Gang Territories',
        'description': 'Learn about prison gang hierarchies and territories for survival.',
      },
      {
        'icon': Icons.security,
        'title': 'Guard Corruption',
        'description': 'Identify corrupt guards who can be bribed for special privileges.',
      },
      {
        'icon': Icons.local_shipping,
        'title': 'Contraband Routes',
        'description': 'Smuggling routes for drugs, weapons, and communication devices.',
      },
      {
        'icon': Icons.psychology,
        'title': 'Rehabilitation Programs',
        'description': 'Educational and therapy programs that can reduce sentence time.',
      },
    ];
  }

  List<Map<String, dynamic>> _getMockLegalBusinesses() {
    return [
      {
        'name': 'Sterling Holdings LLC',
        'type': 'Limited Liability Company',
        'jurisdiction': 'Delaware',
        'protectionLevel': 85,
        'annualFee': 5000,
        'services': ['Asset Protection', 'Tax Optimization', 'Privacy Shield'],
      },
      {
        'name': 'Offshore Investments Ltd',
        'type': 'International Corporation',
        'jurisdiction': 'Cayman Islands',
        'protectionLevel': 95,
        'annualFee': 12000,
        'services': ['Offshore Banking', 'International Trade', 'Currency Exchange'],
      },
    ];
  }

  String _calculateRetainerFees(List<Map<String, dynamic>> lawyers) {
    final total = lawyers.fold(0, (sum, lawyer) => sum + (lawyer['retainerFee'] as int));
    return total.toString();
  }

  int _calculateLegalProtection(List<Map<String, dynamic>> businesses) {
    if (businesses.isEmpty) return 0;
    final average = businesses.fold(0, (sum, business) => sum + (business['protectionLevel'] as int)) / businesses.length;
    return average.round();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.orange;
      case 'won':
        return Colors.green;
      case 'lost':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Action Methods
  void _showHireLawyerDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Lawyer hiring dialog would open here')),
    );
  }

  void _showCreateLegalBusinessDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Legal business creation dialog would open here')),
    );
  }

  void _playCourtMinigame(Map<String, dynamic> courtCase) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Court minigame for ${courtCase['caseNumber']} would start here')),
    );
  }

  void _negotiatePlea(Map<String, dynamic> courtCase) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Plea negotiation for ${courtCase['caseNumber']} would open here')),
    );
  }
}
