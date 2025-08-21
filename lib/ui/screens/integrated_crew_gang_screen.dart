import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers.dart';
import '../../data/crew_models.dart';

class IntegratedCrewGangScreen extends ConsumerStatefulWidget {
  const IntegratedCrewGangScreen({super.key});

  @override
  ConsumerState<IntegratedCrewGangScreen> createState() => _IntegratedCrewGangScreenState();
}

class _IntegratedCrewGangScreenState extends ConsumerState<IntegratedCrewGangScreen>
    with TickerProviderStateMixin {
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
    final gameState = ref.watch(gameControllerProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('👥 Crew & Gang Operations'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.group), text: 'My Crew'),
            Tab(icon: Icon(Icons.groups), text: 'Gang Wars'),
            Tab(icon: Icon(Icons.map), text: 'Territory'),
            Tab(icon: Icon(Icons.local_police), text: 'Operations'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCrewTab(gameState),
          _buildGangWarsTab(gameState),
          _buildTerritoryTab(gameState),
          _buildOperationsTab(gameState),
        ],
      ),
    );
  }

  Widget _buildCrewTab(dynamic gameState) {
    // Mock crew data - in real implementation, this would come from game state
    final List<Map<String, dynamic>> crewMembers = [
      {
        'name': 'Tony "The Hammer" Martinez',
        'rank': CrewMemberRank.underboss,
        'loyalty': 95,
        'skills': {'Combat': 90, 'Leadership': 85, 'Intimidation': 88},
        'dailyCost': 1500,
        'isRecruited': true,
        'specialties': ['Gang Wars', 'Territory Control'],
      },
      {
        'name': 'Maria "Silent" Rodriguez',
        'rank': CrewMemberRank.lieutenant,
        'loyalty': 87,
        'skills': {'Stealth': 95, 'Hacking': 82, 'Intelligence': 90},
        'dailyCost': 800,
        'isRecruited': true,
        'specialties': ['Heists', 'Information'],
      },
      {
        'name': 'Jake "Wheels" Thompson',
        'rank': CrewMemberRank.soldier,
        'loyalty': 76,
        'skills': {'Driving': 88, 'Mechanics': 85, 'Evasion': 80},
        'dailyCost': 400,
        'isRecruited': true,
        'specialties': ['Getaway', 'Vehicle Operations'],
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Crew Overview Card
          Card(
            elevation: 8,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.shade600, Colors.purple.shade800],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Crew Overview',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatColumn('Members', '${crewMembers.length}', '👥'),
                      _buildStatColumn('Total Loyalty', '86%', '💖'),
                      _buildStatColumn('Daily Cost', '\$2.7K', '💰'),
                      _buildStatColumn('Combat Power', '8.5K', '⚔️'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Crew Members List
          const Text(
            'Crew Members',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          
          ...crewMembers.map((member) => Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: _getRankColor(member['rank']),
                child: Text(
                  member['rank'].icon,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              title: Text(
                member['name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${member['rank'].name} • Loyalty: ${member['loyalty']}%'),
                  Text('Daily Cost: \$${member['dailyCost']} • Specialties: ${member['specialties'].join(', ')}'),
                ],
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Skills:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ...member['skills'].entries.map((skill) => 
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              Expanded(child: Text(skill.key)),
                              SizedBox(
                                width: 150,
                                child: LinearProgressIndicator(
                                  value: skill.value / 100,
                                  backgroundColor: Colors.grey[300],
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    _getSkillColor(skill.value),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text('${skill.value}'),
                            ],
                          ),
                        ),
                      ).toList(),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _assignToGangWar(member),
                              icon: const Icon(Icons.groups),
                              label: const Text('Assign to Gang War'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _sendOnMission(member),
                              icon: const Icon(Icons.directions_run),
                              label: const Text('Send on Mission'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )).toList(),
          
          const SizedBox(height: 20),
          
          // Recruitment Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recruit New Members',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showRecruitmentDialog(),
                      icon: const Icon(Icons.person_add),
                      label: const Text('Browse Available Recruits'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
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

  Widget _buildGangWarsTab(dynamic gameState) {
    // Mock gang war data
    final List<Map<String, dynamic>> activeWars = [
      {
        'gang': 'Los Serpientes',
        'territory': 'East Side',
        'status': 'Ongoing',
        'daysRemaining': 3,
        'ourChance': 75,
        'potentialReward': 25000,
        'assignedCrew': ['Tony "The Hammer" Martinez'],
      },
    ];

    final List<Map<String, dynamic>> rivalGangs = [
      {
        'name': 'Iron Wolves',
        'leader': 'Viktor "Steel" Petrov',
        'territory': 'Industrial District',
        'strength': 8500,
        'relationship': 'Hostile',
        'threatLevel': 'High',
      },
      {
        'name': 'Shadow Syndicate',
        'leader': 'Phantom',
        'territory': 'Downtown',
        'strength': 12000,
        'relationship': 'Neutral',
        'threatLevel': 'Extreme',
      },
      {
        'name': 'Blood Roses',
        'leader': 'Rosa "Thorn" Martinez',
        'territory': 'West Hills',
        'strength': 6200,
        'relationship': 'Rival',
        'threatLevel': 'Medium',
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Active Gang Wars
          const Text(
            'Active Gang Wars',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          
          if (activeWars.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(Icons.check_circle, size: 48, color: Colors.green),
                    const SizedBox(height: 8),
                    const Text('No Active Wars'),
                    const Text('Your territory is secure for now'),
                  ],
                ),
              ),
            )
          else
            ...activeWars.map((war) => Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'War vs ${war['gang']}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            war['status'],
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text('Territory: ${war['territory']}'),
                    Text('Days Remaining: ${war['daysRemaining']}'),
                    Text('Victory Chance: ${war['ourChance']}%'),
                    Text('Potential Reward: \$${war['potentialReward']}'),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: war['ourChance'] / 100,
                      backgroundColor: Colors.red[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        war['ourChance'] > 70 ? Colors.green : 
                        war['ourChance'] > 40 ? Colors.orange : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text('Assigned Crew: ${war['assignedCrew'].join(', ')}'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _reinforceWar(war),
                            child: const Text('Send Reinforcements'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _retreatFromWar(war),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            child: const Text('Retreat'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )).toList(),
          
          const SizedBox(height: 20),
          
          // Rival Gangs
          const Text(
            'Rival Gangs',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          
          ...rivalGangs.map((gang) => Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _getThreatColor(gang['threatLevel']),
                child: Text(
                  _getThreatIcon(gang['threatLevel']),
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              title: Text(gang['name']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Leader: ${gang['leader']}'),
                  Text('Territory: ${gang['territory']}'),
                  Text('Strength: ${gang['strength']} • ${gang['relationship']}'),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: () => _declareWar(gang),
                style: ElevatedButton.styleFrom(
                  backgroundColor: gang['relationship'] == 'Hostile' ? Colors.red : Colors.orange,
                  foregroundColor: Colors.white,
                ),
                child: Text(gang['relationship'] == 'Hostile' ? 'Attack' : 'Declare War'),
              ),
              isThreeLine: true,
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildTerritoryTab(dynamic gameState) {
    // Mock territory data
    final List<Map<String, dynamic>> territories = [
      {
        'name': 'Downtown Core',
        'control': 'Ours',
        'income': 15000,
        'defense': 85,
        'specialFeatures': ['Banking District', 'High Security'],
      },
      {
        'name': 'East Side Docks',
        'control': 'Contested',
        'income': 8000,
        'defense': 45,
        'specialFeatures': ['Smuggling Routes', 'Low Police Presence'],
      },
      {
        'name': 'Industrial Zone',
        'control': 'Iron Wolves',
        'income': 12000,
        'defense': 70,
        'specialFeatures': ['Manufacturing', 'Weapon Storage'],
      },
      {
        'name': 'West Hills',
        'control': 'Neutral',
        'income': 20000,
        'defense': 30,
        'specialFeatures': ['Wealthy Clients', 'Low Heat'],
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Territory Overview
          Card(
            elevation: 8,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade600, Colors.orange.shade800],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Territory Control',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatColumn('Controlled', '1', '🏗️'),
                      _buildStatColumn('Contested', '1', '⚔️'),
                      _buildStatColumn('Total Income', '\$15K', '💰'),
                      _buildStatColumn('Defense', '85%', '🛡️'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Territory List
          const Text(
            'Territory Map',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          
          ...territories.map((territory) => Card(
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: _getControlColor(territory['control']),
                child: Text(
                  _getControlIcon(territory['control']),
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              title: Text(territory['name']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Control: ${territory['control']}'),
                  Text('Income: \$${territory['income']}/day • Defense: ${territory['defense']}%'),
                ],
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Special Features:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: territory['specialFeatures'].map<Widget>((feature) =>
                          Chip(
                            label: Text(feature),
                            backgroundColor: Colors.blue.shade100,
                          ),
                        ).toList(),
                      ),
                      const SizedBox(height: 12),
                      if (territory['control'] != 'Ours')
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _attackTerritory(territory),
                            icon: const Icon(Icons.local_fire_department),
                            label: Text(territory['control'] == 'Neutral' ? 'Claim Territory' : 'Attack Territory'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: territory['control'] == 'Neutral' ? Colors.green : Colors.red,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        )
                      else
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _upgradeDefenses(territory),
                            icon: const Icon(Icons.security),
                            label: const Text('Upgrade Defenses'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildOperationsTab(dynamic gameState) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Operation Planning
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Plan New Operation',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text('Coordinate your crew and gang resources for maximum impact'),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _planOperation(),
                      icon: const Icon(Icons.account_tree),
                      label: const Text('Open Operation Planner'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Recent Operations
          const Text(
            'Recent Operations',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(Icons.history, size: 48, color: Colors.grey),
                  const SizedBox(height: 8),
                  const Text('No Recent Operations'),
                  const Text('Start planning your first coordinated operation!'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, String icon) {
    return Column(
      children: [
        Text(
          icon,
          style: const TextStyle(fontSize: 24, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // Helper methods for colors and icons
  Color _getRankColor(CrewMemberRank rank) {
    switch (rank) {
      case CrewMemberRank.recruit:
        return Colors.grey;
      case CrewMemberRank.soldier:
        return Colors.green;
      case CrewMemberRank.lieutenant:
        return Colors.blue;
      case CrewMemberRank.underboss:
        return Colors.purple;
    }
  }

  Color _getSkillColor(int skill) {
    if (skill >= 90) return Colors.purple;
    if (skill >= 80) return Colors.blue;
    if (skill >= 70) return Colors.green;
    if (skill >= 60) return Colors.orange;
    return Colors.red;
  }

  Color _getThreatColor(String threatLevel) {
    switch (threatLevel) {
      case 'Low':
        return Colors.green;
      case 'Medium':
        return Colors.orange;
      case 'High':
        return Colors.red;
      case 'Extreme':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _getThreatIcon(String threatLevel) {
    switch (threatLevel) {
      case 'Low':
        return '🟢';
      case 'Medium':
        return '🟡';
      case 'High':
        return '🔴';
      case 'Extreme':
        return '💀';
      default:
        return '❓';
    }
  }

  Color _getControlColor(String control) {
    switch (control) {
      case 'Ours':
        return Colors.green;
      case 'Contested':
        return Colors.orange;
      case 'Neutral':
        return Colors.grey;
      default:
        return Colors.red;
    }
  }

  String _getControlIcon(String control) {
    switch (control) {
      case 'Ours':
        return '👑';
      case 'Contested':
        return '⚔️';
      case 'Neutral':
        return '🏳️';
      default:
        return '💀';
    }
  }

  // Action methods
  void _assignToGangWar(Map<String, dynamic> member) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${member['name']} assigned to gang war operations!'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _sendOnMission(Map<String, dynamic> member) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${member['name']} sent on solo mission!'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showRecruitmentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎯 Recruitment Center'),
        content: const Text('Available recruits will be shown here with their skills and costs.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _reinforceWar(Map<String, dynamic> war) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reinforcements sent to war vs ${war['gang']}!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _retreatFromWar(Map<String, dynamic> war) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Retreated from war vs ${war['gang']}'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _declareWar(Map<String, dynamic> gang) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('War declared against ${gang['name']}!'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _attackTerritory(Map<String, dynamic> territory) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Attacking ${territory['name']}!'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _upgradeDefenses(Map<String, dynamic> territory) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Upgrading defenses in ${territory['name']}'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _planOperation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎯 Operation Planner'),
        content: const Text('Coordinate crew members and gang resources for complex operations.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
