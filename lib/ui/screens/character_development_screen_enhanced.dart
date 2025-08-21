import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers.dart';
import '../../theme/app_theme.dart';
import '../../util/formatters.dart';

class CharacterDevelopmentScreen extends ConsumerStatefulWidget {
  const CharacterDevelopmentScreen({super.key});

  @override
  ConsumerState<CharacterDevelopmentScreen> createState() => _CharacterDevelopmentScreenState();
}

class _CharacterDevelopmentScreenState extends ConsumerState<CharacterDevelopmentScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedSkillCategory = 'Criminal';

  final Map<String, List<String>> skillCategories = {
    'Criminal': ['Stealth', 'Lock Picking', 'Intimidation', 'Street Smarts', 'Weapon Handling'],
    'Business': ['Negotiation', 'Finance', 'Leadership', 'Marketing', 'Analytics'],
    'Social': ['Charisma', 'Networking', 'Persuasion', 'Psychology', 'Public Speaking'],
    'Physical': ['Strength', 'Endurance', 'Agility', 'Combat', 'Parkour'],
    'Mental': ['Intelligence', 'Memory', 'Focus', 'Strategy', 'Problem Solving'],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
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
        title: const Text('Character Development'),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.accentColor,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.psychology), text: 'Skills'),
            Tab(icon: Icon(Icons.star), text: 'Reputation'),
            Tab(icon: Icon(Icons.favorite), text: 'Health'),
            Tab(icon: Icon(Icons.family_restroom), text: 'Relationships'),
            Tab(icon: Icon(Icons.trending_up), text: 'Training'),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.primaryColor, AppTheme.backgroundColor],
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildSkillsTab(gameState),
            _buildReputationTab(gameState),
            _buildHealthTab(gameState),
            _buildRelationshipsTab(gameState),
            _buildTrainingTab(gameState),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsTab(dynamic gameState) {
    return Column(
      children: [
        // Character Overview Card
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple.shade600, Colors.purple.shade800],
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatColumn('Level', '${_calculateLevel(gameState)}', '⭐'),
              _buildStatColumn('XP', '${gameState.statistics['totalExperience'] ?? 0}', '🎯'),
              _buildStatColumn('Skill Points', '${gameState.statistics['skillPoints'] ?? 25}', '💎'),
              _buildStatColumn('Health', '${gameState.statistics['health'] ?? 100}%', '❤️'),
            ],
          ),
        ),
        
        // Skill Category Selector
        Container(
          height: 60,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: skillCategories.keys.map((category) {
              final isSelected = _selectedSkillCategory == category;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedSkillCategory = category;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.accentColor : Colors.white24,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isSelected ? AppTheme.accentColor : Colors.white54,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        
        // Skills Grid
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.1,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: skillCategories[_selectedSkillCategory]!.length,
              itemBuilder: (context, index) {
                final skill = skillCategories[_selectedSkillCategory]![index];
                final skillKey = skill.toLowerCase().replaceAll(' ', '_');
                // Check both skills and statistics for the level
                final level = gameState.skills[skillKey] ?? 
                             gameState.statistics['skill_$skillKey'] ?? 1;
                final maxLevel = 100;
                final progress = level / maxLevel;
                
                return _buildSkillCard(skill, level, progress, gameState);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSkillCard(String skill, int level, double progress, dynamic gameState) {
    final skillPoints = gameState.statistics['skillPoints'] ?? 25;
    final upgradeCost = _calculateUpgradeCost(level);
    final canUpgrade = skillPoints >= upgradeCost && level < 100;
    
    return Card(
      elevation: 8,
      color: Colors.white10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: canUpgrade ? () => _upgradeSkill(skill, level, upgradeCost) : null,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                skill,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              // Progress Circle
              SizedBox(
                width: 50,
                height: 50,
                child: Stack(
                  children: [
                    CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 5,
                      backgroundColor: Colors.white24,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getSkillColor(progress),
                      ),
                    ),
                    Center(
                      child: Text(
                        '$level',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Upgrade Button
              Container(
                width: double.infinity,
                height: 28,
                child: ElevatedButton(
                  onPressed: canUpgrade ? () => _upgradeSkill(skill, level, upgradeCost) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canUpgrade ? AppTheme.accentColor : Colors.grey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                  child: Text(
                    canUpgrade ? 'Upgrade ($upgradeCost SP)' : level >= 100 ? 'MAX' : 'Need SP',
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper methods
  Widget _buildStatColumn(String label, String value, String icon) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 24, color: Colors.white)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
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

  int _calculateLevel(dynamic gameState) {
    final totalXP = gameState.statistics['totalExperience'] ?? 0;
    return (totalXP / 1000).floor() + 1;
  }

  int _calculateUpgradeCost(int currentLevel) {
    return ((currentLevel + 1) * 0.5).ceil();
  }

  void _upgradeSkill(String skill, int currentLevel, int cost) {
    final gameState = ref.read(gameControllerProvider);
    final controller = ref.read(gameControllerProvider.notifier);
    
    final currentSkillPoints = gameState.statistics['skillPoints'] ?? 0;
    
    print('🎮 Upgrading skill: $skill');
    print('📊 Current level: $currentLevel');
    print('💰 Cost: $cost SP');
    print('🎯 Available SP: $currentSkillPoints');
    
    if (currentSkillPoints >= cost) {
      // Calculate new values
      final skillKey = 'skill_${skill.toLowerCase().replaceAll(' ', '_')}';
      final newLevel = currentLevel + 1;
      final newSkillPoints = currentSkillPoints - cost;
      
      print('🔧 Skill key: $skillKey');
      print('⬆️ New level: $newLevel');
      print('📉 Remaining SP: $newSkillPoints');
      
      // Update skill points and skill level using the batch update method
      controller.updateStatistics({
        'skillPoints': newSkillPoints,
        skillKey: newLevel,
      });
      
      // Add experience for the upgrade
      controller.gainExperience('skill_upgrade', cost * 10);
      
      print('✅ Skill upgrade completed!');
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$skill upgraded to level $newLevel! (-$cost SP)'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
      
      // Force a rebuild by updating state
      setState(() {});
      
    } else {
      print('❌ Not enough skill points!');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Not enough skill points! Need $cost SP, have $currentSkillPoints SP.'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildReputationTab(dynamic gameState) {
    final reputationStats = {
      'Street Credibility': gameState.statistics['streetCred'] ?? 0,
      'Business Reputation': gameState.statistics['businessRep'] ?? 0,
      'Police Heat': gameState.heat ?? 0,
      'Respect Level': gameState.statistics['respect'] ?? 0,
      'Notoriety': gameState.statistics['notoriety'] ?? 0,
    };

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Reputation Overview Card
          Card(
            elevation: 8,
            color: Colors.white10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'Reputation Overview',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...reputationStats.entries.map((entry) {
                    return _buildReputationBar(entry.key, entry.value);
                  }).toList(),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Reputation Actions
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildReputationAction(
                  'Improve Street Cred',
                  Icons.local_fire_department,
                  Colors.orange,
                  () => _improveReputation('streetCred', 500),
                ),
                _buildReputationAction(
                  'Business Networking',
                  Icons.business_center,
                  Colors.blue,
                  () => _improveReputation('businessRep', 750),
                ),
                _buildReputationAction(
                  'Lay Low',
                  Icons.visibility_off,
                  Colors.green,
                  () => _reduceHeat(1000),
                ),
                _buildReputationAction(
                  'Community Service',
                  Icons.volunteer_activism,
                  Colors.purple,
                  () => _improveReputation('respect', 300),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReputationBar(String label, int value) {
    final maxValue = label == 'Police Heat' ? 100 : 200;
    final progress = (value / maxValue).clamp(0.0, 1.0);
    final color = label == 'Police Heat' 
        ? (progress > 0.7 ? Colors.red : progress > 0.4 ? Colors.orange : Colors.green)
        : AppTheme.accentColor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Text(
                '$value/$maxValue',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white24,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthTab(dynamic gameState) {
    final healthStats = {
      'Physical Health': gameState.statistics['physicalHealth'] ?? 85,
      'Mental Health': gameState.statistics['mentalHealth'] ?? 80,
      'Stress Level': gameState.statistics['stressLevel'] ?? 25,
      'Energy': gameState.statistics['energy'] ?? 90,
      'Fitness': gameState.statistics['fitness'] ?? 70,
    };

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Health Overview
          Card(
            elevation: 8,
            color: Colors.white10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'Health Status',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...healthStats.entries.map((entry) {
                    return _buildHealthBar(entry.key, entry.value);
                  }).toList(),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Health Activities
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildHealthActivity(
                  'Gym Workout',
                  Icons.fitness_center,
                  Colors.red,
                  () => _performHealthActivity('fitness', 200),
                ),
                _buildHealthActivity(
                  'Meditation',
                  Icons.self_improvement,
                  Colors.blue,
                  () => _performHealthActivity('mentalHealth', 150),
                ),
                _buildHealthActivity(
                  'Medical Checkup',
                  Icons.medical_services,
                  Colors.green,
                  () => _performHealthActivity('physicalHealth', 500),
                ),
                _buildHealthActivity(
                  'Vacation',
                  Icons.beach_access,
                  Colors.orange,
                  () => _performHealthActivity('stressLevel', 1000),
                ),
                _buildHealthActivity(
                  'Energy Drink',
                  Icons.local_drink,
                  Colors.purple,
                  () => _performHealthActivity('energy', 50),
                ),
                _buildHealthActivity(
                  'Spa Treatment',
                  Icons.spa,
                  Colors.pink,
                  () => _performHealthActivity('mentalHealth', 300),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelationshipsTab(dynamic gameState) {
    final relationships = {
      'Family Trust': gameState.statistics['familyTrust'] ?? 60,
      'Crew Loyalty': gameState.statistics['crewLoyalty'] ?? 75,
      'Police Relations': gameState.statistics['policeRelations'] ?? 20,
      'Business Contacts': gameState.statistics['businessContacts'] ?? 45,
      'Underground Network': gameState.statistics['undergroundNetwork'] ?? 80,
    };

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Relationships Overview
          Card(
            elevation: 8,
            color: Colors.white10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'Relationships',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...relationships.entries.map((entry) {
                    return _buildRelationshipBar(entry.key, entry.value);
                  }).toList(),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Relationship Actions
          Expanded(
            child: ListView(
              children: [
                _buildRelationshipAction(
                  'Call Family',
                  'Strengthen family bonds and trust',
                  Icons.phone,
                  Colors.green,
                  () => _improveRelationship('familyTrust', 100),
                ),
                _buildRelationshipAction(
                  'Crew Meeting',
                  'Discuss business and build loyalty',
                  Icons.group,
                  Colors.blue,
                  () => _improveRelationship('crewLoyalty', 150),
                ),
                _buildRelationshipAction(
                  'Business Lunch',
                  'Network with legitimate contacts',
                  Icons.restaurant,
                  Colors.orange,
                  () => _improveRelationship('businessContacts', 200),
                ),
                _buildRelationshipAction(
                  'Underground Favor',
                  'Help contacts for future benefits',
                  Icons.handshake,
                  Colors.purple,
                  () => _improveRelationship('undergroundNetwork', 80),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainingTab(dynamic gameState) {
    final trainingPrograms = [
      {
        'name': 'Combat Training',
        'description': 'Improve fighting skills and weapon handling',
        'cost': 1000,
        'duration': '2 hours',
        'benefits': ['Strength +5', 'Combat +8', 'Weapon Handling +6'],
        'color': Colors.red,
        'icon': Icons.sports_martial_arts,
      },
      {
        'name': 'Business School',
        'description': 'Learn advanced business strategies',
        'cost': 2500,
        'duration': '1 day',
        'benefits': ['Finance +10', 'Leadership +8', 'Negotiation +7'],
        'color': Colors.blue,
        'icon': Icons.school,
      },
      {
        'name': 'Street University',
        'description': 'Learn from experienced criminals',
        'cost': 500,
        'duration': '4 hours',
        'benefits': ['Street Smarts +10', 'Stealth +6', 'Intimidation +5'],
        'color': Colors.orange,
        'icon': Icons.local_fire_department,
      },
      {
        'name': 'Tech Bootcamp',
        'description': 'Master modern technology and hacking',
        'cost': 1500,
        'duration': '6 hours',
        'benefits': ['Intelligence +8', 'Analytics +10', 'Problem Solving +7'],
        'color': Colors.purple,
        'icon': Icons.computer,
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: trainingPrograms.length,
        itemBuilder: (context, index) {
          final program = trainingPrograms[index];
          return _buildTrainingCard(program);
        },
      ),
    );
  }

  Widget _buildTrainingCard(Map<String, dynamic> program) {
    return Card(
      elevation: 8,
      color: Colors.white10,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: program['color'],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    program['icon'],
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        program['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        program['description'],
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Program Details
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cost: ${Formatters.money(program['cost'])}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Duration: ${program['duration']}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _startTraining(program),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: program['color'],
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: const Text('Start Training'),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Benefits
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: (program['benefits'] as List<String>).map((benefit) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    benefit,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widgets and methods
  Widget _buildHealthBar(String label, int value) {
    final maxValue = label == 'Stress Level' ? 100 : 100;
    final progress = (value / maxValue).clamp(0.0, 1.0);
    final color = label == 'Stress Level'
        ? (progress > 0.7 ? Colors.red : progress > 0.4 ? Colors.orange : Colors.green)
        : (progress > 0.7 ? Colors.green : progress > 0.4 ? Colors.orange : Colors.red);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Text(
                '$value%',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white24,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthActivity(String name, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 8,
      color: Colors.white10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRelationshipBar(String label, int value) {
    final progress = (value / 100).clamp(0.0, 1.0);
    final color = progress > 0.7 ? Colors.green : progress > 0.4 ? Colors.orange : Colors.red;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Text(
                '$value/100',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white24,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }

  Widget _buildRelationshipAction(String title, String description, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 8,
      color: Colors.white10,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54),
        onTap: onTap,
      ),
    );
  }

  Widget _buildReputationAction(String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 8,
      color: Colors.white10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getSkillColor(double progress) {
    if (progress > 0.8) return Colors.purple;
    if (progress > 0.6) return Colors.blue;
    if (progress > 0.4) return Colors.green;
    if (progress > 0.2) return Colors.orange;
    return Colors.red;
  }

  // Action methods
  void _improveReputation(String type, int cost) {
    final gameController = ref.read(gameControllerProvider.notifier);
    
    if (ref.read(gameControllerProvider).cash >= cost) {
      gameController.spendCash(cost);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Improved $type reputation!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not enough cash!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _reduceHeat(int cost) {
    final gameController = ref.read(gameControllerProvider.notifier);
    
    if (ref.read(gameControllerProvider).cash >= cost) {
      gameController.spendCash(cost);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully laid low and reduced heat!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not enough cash!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _performHealthActivity(String type, int cost) {
    final gameController = ref.read(gameControllerProvider.notifier);
    
    if (ref.read(gameControllerProvider).cash >= cost) {
      gameController.spendCash(cost);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Improved $type!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not enough cash!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _improveRelationship(String type, int cost) {
    final gameController = ref.read(gameControllerProvider.notifier);
    
    if (ref.read(gameControllerProvider).cash >= cost) {
      gameController.spendCash(cost);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Improved $type!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not enough cash!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _startTraining(Map<String, dynamic> program) {
    final gameController = ref.read(gameControllerProvider.notifier);
    final cost = program['cost'] as int;
    
    if (ref.read(gameControllerProvider).cash >= cost) {
      gameController.spendCash(cost);
      
      // Add benefits
      for (String benefit in program['benefits']) {
        final parts = benefit.split(' +');
        if (parts.length == 2) {
          final skill = parts[0];
          final points = int.tryParse(parts[1]) ?? 0;
          gameController.gainExperience(skill, points);
        }
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Started ${program['name']} training!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not enough cash for training!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
