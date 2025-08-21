import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers.dart';
import '../../data/character_development_models.dart';
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
        // Skill Category Selector
        Container(
          height: 60,
          margin: const EdgeInsets.all(16),
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
                childAspectRatio: 1.2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: skillCategories[_selectedSkillCategory]!.length,
              itemBuilder: (context, index) {
                final skill = skillCategories[_selectedSkillCategory]![index];
                // Check both skills and statistics for the level
                final skillKey = skill.toLowerCase().replaceAll(' ', '_');
                final level = gameState.skills[skillKey] ?? 
                             gameState.statistics['skill_$skillKey'] ?? 0;
                final maxLevel = 100;
                final progress = level / maxLevel;
                
                return _buildSkillCard(skill, level, progress);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSkillCard(String skill, int level, double progress) {
    return Card(
      elevation: 8,
      color: Colors.white10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () => _showSkillDetails(skill, level),
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                skill,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              
              // Progress Circle
              SizedBox(
                width: 60,
                height: 60,
                child: Stack(
                  children: [
                    CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 6,
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
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              ElevatedButton(
                onPressed: () => _trainSkill(skill),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentColor,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  minimumSize: const Size(0, 30),
                ),
                child: const Text('Train', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ),
      ),
    );
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
                // Family section
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Family Activities',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildRelationshipAction(
                  'Call Family',
                  'Strengthen family bonds and trust',
                  Icons.phone,
                  Colors.green,
                  () => _improveRelationship('familyTrust', 100),
                ),
                _buildRelationshipAction(
                  'Family Dinner',
                  'Spend quality time with family',
                  Icons.restaurant,
                  Colors.blue,
                  () => _improveRelationship('familyTrust', 250),
                ),
                _buildRelationshipAction(
                  'Send Money Home',
                  'Support your family financially',
                  Icons.attach_money,
                  Colors.yellow,
                  () => _improveRelationship('familyTrust', 500),
                ),
                
                // Business section
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Business & Professional',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                  Icons.business_center,
                  Colors.orange,
                  () => _improveRelationship('businessContacts', 200),
                ),
                
                // Underground section
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Underground Network',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildRelationshipAction(
                  'Underground Favor',
                  'Help contacts for future benefits',
                  Icons.handshake,
                  Colors.purple,
                  () => _improveRelationship('undergroundNetwork', 80),
                ),
                _buildRelationshipAction(
                  'Information Trade',
                  'Share valuable intelligence',
                  Icons.info,
                  Colors.teal,
                  () => _improveRelationship('undergroundNetwork', 120),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyMemberCard(FamilyMember member) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: _getRelationshipIconColor(member.relationship),
            child: Icon(
              _getRelationshipIcon(member.relationship),
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${member.relationship.toUpperCase()}, ${member.age} years old',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Location: ${member.location}',
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (member.memories.containsKey('concerns'))
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Concerned',
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  IconData _getRelationshipIcon(String relationship) {
    switch (relationship) {
      case 'parent':
        return Icons.family_restroom;
      case 'sibling':
        return Icons.person;
      case 'spouse':
        return Icons.favorite;
      case 'child':
        return Icons.child_care;
      default:
        return Icons.person;
    }
  }

  Color _getRelationshipIconColor(String relationship) {
    switch (relationship) {
      case 'parent':
        return Colors.blue;
      case 'sibling':
        return Colors.green;
      case 'spouse':
        return Colors.pink;
      case 'child':
        return Colors.orange;
      default:
        return Colors.grey;
    }
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
  void _trainSkill(String skill) {
    final gameController = ref.read(gameControllerProvider.notifier);
    final cost = 100;
    
    if (ref.read(gameControllerProvider).cash >= cost) {
      gameController.spendCash(cost);
      gameController.gainExperience(skill, 10);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Trained $skill! Gained 10 experience points.'),
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

  void _showSkillDetails(String skill, int level) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          skill,
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Level: $level',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              'Next level requires: ${(level + 1) * 10} experience points',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              'Training cost: ${Formatters.money(100)}',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _trainSkill(skill);
            },
            child: const Text('Train'),
          ),
        ],
      ),
    );
  }

  void _improveReputation(String type, int cost) {
    final gameController = ref.read(gameControllerProvider.notifier);
    
    if (ref.read(gameControllerProvider).cash >= cost) {
      gameController.spendCash(cost);
      
      // Actually improve the reputation with meaningful amounts
      int improvementAmount = 10; // Base improvement
      switch (type) {
        case 'streetCred':
          improvementAmount = 15;
          break;
        case 'businessRep':
          improvementAmount = 12;
          break;
        case 'respect':
          improvementAmount = 8;
          break;
        case 'notoriety':
          improvementAmount = 10;
          break;
      }
      
      gameController.improveReputation(type, improvementAmount);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Improved ${type.replaceAll(RegExp(r'([A-Z])'), ' \$1').toLowerCase().trim()} by $improvementAmount points!'),
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
      gameController.reduceHeat(20); // Reduce heat by 20 points
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully laid low and reduced heat by 20 points!'),
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
      
      // Actually improve the health stat with meaningful amounts
      int improvementAmount = 10; // Base improvement
      String activityName = '';
      
      switch (type) {
        case 'fitness':
          improvementAmount = 12;
          activityName = 'Fitness';
          break;
        case 'mentalHealth':
          improvementAmount = 15;
          activityName = 'Mental Health';
          break;
        case 'physicalHealth':
          improvementAmount = 10;
          activityName = 'Physical Health';
          break;
        case 'energy':
          improvementAmount = 20;
          activityName = 'Energy';
          break;
        case 'stressLevel':
          improvementAmount = 15; // This will reduce stress
          activityName = 'Stress Level';
          break;
      }
      
      gameController.improveHealth(type, improvementAmount);
      
      String message = type == 'stressLevel' 
          ? 'Reduced stress by $improvementAmount points!'
          : 'Improved $activityName by $improvementAmount points!';
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
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
      
      // Actually improve the relationship with meaningful amounts
      int improvementAmount = 5; // Base improvement
      switch (type) {
        case 'familyTrust':
          improvementAmount = 8; // Family is more responsive
          break;
        case 'crewLoyalty':
          improvementAmount = 6; // Crew responds well to investment
          break;
        case 'businessContacts':
          improvementAmount = 4; // Business is transactional
          break;
        case 'undergroundNetwork':
          improvementAmount = 7; // Underground values loyalty
          break;
        case 'policeRelations':
          improvementAmount = 3; // Police are harder to influence
          break;
      }
      
      gameController.improveRelationship(type, improvementAmount);
      
      // Also update character development state for real-time UI updates
      ref.read(characterDevelopmentProvider.notifier).improveRelationship(type);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Improved ${type.replaceAll(RegExp(r'([A-Z])'), ' \$1').toLowerCase().trim()} by $improvementAmount points!'),
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
