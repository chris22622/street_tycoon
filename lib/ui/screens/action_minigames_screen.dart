import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import 'dart:math';
import 'dart:async';

class ActionMinigamesScreen extends ConsumerStatefulWidget {
  const ActionMinigamesScreen({super.key});

  @override
  ConsumerState<ActionMinigamesScreen> createState() => _ActionMinigamesScreenState();
}

class _ActionMinigamesScreenState extends ConsumerState<ActionMinigamesScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Action Minigames'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.backgroundColor, AppTheme.cardColor],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Action Overview
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red, width: 2),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.flash_on, size: 48, color: Colors.red),
                    const SizedBox(height: 8),
                    Text('High-Stakes Operations', style: AppTheme.headingStyle),
                    const SizedBox(height: 8),
                    Text(
                      'Engage in dangerous activities that require skill and quick thinking.',
                      style: AppTheme.bodyStyle.copyWith(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Minigame Categories
              _buildMinigameSection('Combat Operations', Colors.red, [
                _buildMinigameCard(
                  'Shootout',
                  'Tactical gunfight scenarios',
                  Icons.my_location,
                  Colors.red,
                  () => _startShootoutMinigame(),
                ),
                _buildMinigameCard(
                  'Car Chase',
                  'High-speed pursuit sequences',
                  Icons.directions_car,
                  Colors.orange,
                  () => _startCarChaseMinigame(),
                ),
              ]),
              
              const SizedBox(height: 16),
              
              _buildMinigameSection('Stealth Operations', Colors.purple, [
                _buildMinigameCard(
                  'Infiltration',
                  'Sneak past security systems',
                  Icons.visibility_off,
                  Colors.purple,
                  () => _startStealthMinigame(),
                ),
                _buildMinigameCard(
                  'Surveillance',
                  'Monitor targets and gather intel',
                  Icons.camera_alt,
                  Colors.indigo,
                  () => _startSurveillanceMinigame(),
                ),
              ]),
              
              const SizedBox(height: 16),
              
              _buildMinigameSection('Technical Operations', Colors.blue, [
                _buildMinigameCard(
                  'Hacking',
                  'Break into computer systems',
                  Icons.computer,
                  Colors.blue,
                  () => _startHackingMinigame(),
                ),
                _buildMinigameCard(
                  'Demolition',
                  'Precise explosive placement',
                  Icons.whatshot,
                  Colors.deepOrange,
                  () => _startDemolitionMinigame(),
                ),
              ]),
              
              const SizedBox(height: 16),
              
              _buildMinigameSection('Social Operations', Colors.green, [
                _buildMinigameCard(
                  'Negotiation',
                  'Persuade and manipulate targets',
                  Icons.record_voice_over,
                  Colors.green,
                  () => _startNegotiationMinigame(),
                ),
                _buildMinigameCard(
                  'Intimidation',
                  'Use fear as a weapon',
                  Icons.warning,
                  Colors.amber,
                  () => _startIntimidationMinigame(),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMinigameSection(String title, Color color, List<Widget> cards) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: AppTheme.headingStyle.copyWith(color: color),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...cards,
      ],
    );
  }

  Widget _buildMinigameCard(String title, String description, IconData icon, Color color, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: color, width: 2),
                  ),
                  child: Icon(icon, color: color, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTheme.headingStyle.copyWith(fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: AppTheme.bodyStyle.copyWith(fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'Difficulty: ${_getRandomDifficulty()}',
                            style: AppTheme.bodyStyle.copyWith(fontSize: 10),
                          ),
                          const Spacer(),
                          Text(
                            'Tap to Play',
                            style: AppTheme.bodyStyle.copyWith(
                              fontSize: 10,
                              color: color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Icon(Icons.play_arrow, color: color, size: 24),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getRandomDifficulty() {
    final difficulties = ['Easy', 'Medium', 'Hard', 'Expert'];
    return difficulties[Random().nextInt(difficulties.length)];
  }

  // Minigame Implementations
  void _startShootoutMinigame() {
    showDialog(
      context: context,
      builder: (context) => _ShootoutMinigameDialog(),
    );
  }

  void _startCarChaseMinigame() {
    showDialog(
      context: context,
      builder: (context) => _CarChaseMinigameDialog(),
    );
  }

  void _startStealthMinigame() {
    showDialog(
      context: context,
      builder: (context) => _StealthMinigameDialog(),
    );
  }

  void _startSurveillanceMinigame() {
    showDialog(
      context: context,
      builder: (context) => _SurveillanceMinigameDialog(),
    );
  }

  void _startHackingMinigame() {
    showDialog(
      context: context,
      builder: (context) => _HackingMinigameDialog(),
    );
  }

  void _startDemolitionMinigame() {
    showDialog(
      context: context,
      builder: (context) => _DemolitionMinigameDialog(),
    );
  }

  void _startNegotiationMinigame() {
    showDialog(
      context: context,
      builder: (context) => _NegotiationMinigameDialog(),
    );
  }

  void _startIntimidationMinigame() {
    showDialog(
      context: context,
      builder: (context) => _IntimidationMinigameDialog(),
    );
  }
}

// Shootout Minigame Dialog
class _ShootoutMinigameDialog extends StatefulWidget {
  @override
  _ShootoutMinigameDialogState createState() => _ShootoutMinigameDialogState();
}

class _ShootoutMinigameDialogState extends State<_ShootoutMinigameDialog> with TickerProviderStateMixin {
  late AnimationController _targetController;
  int score = 0;
  int timeLeft = 30;
  bool gameActive = false;

  @override
  void initState() {
    super.initState();
    _targetController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _targetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black87,
      child: Container(
        width: 400,
        height: 500,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Shootout Minigame', style: AppTheme.headingStyle.copyWith(color: Colors.red)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Score: $score', style: AppTheme.bodyStyle.copyWith(color: Colors.white)),
                Text('Time: $timeLeft', style: AppTheme.bodyStyle.copyWith(color: Colors.white)),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: gameActive ? _buildShootingRange() : _buildGameInstructions(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: gameActive ? null : _startGame,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text(gameActive ? 'Game Active' : 'Start Game'),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: const Text('Close'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameInstructions() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.my_location, size: 64, color: Colors.red),
          SizedBox(height: 16),
          Text(
            'Tap targets as they appear!',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          SizedBox(height: 8),
          Text(
            'Hit as many targets as possible in 30 seconds',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildShootingRange() {
    return Stack(
      children: [
        // Background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue[900]!, Colors.green[900]!],
            ),
          ),
        ),
        // Moving targets would be positioned here
        const Center(
          child: Text(
            'Targets appearing...',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  void _startGame() {
    setState(() {
      gameActive = true;
      score = 0;
      timeLeft = 30;
    });
    
    // Start countdown timer
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft <= 0 || !mounted) {
        timer.cancel();
        if (mounted) {
          setState(() => gameActive = false);
          _showResults();
        }
      } else {
        setState(() => timeLeft--);
      }
    });
  }

  void _showResults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Game Over!'),
        content: Text('Final Score: $score'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// Car Chase Minigame Dialog
class _CarChaseMinigameDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black87,
      child: Container(
        width: 400,
        height: 300,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Car Chase Minigame', style: AppTheme.headingStyle.copyWith(color: Colors.orange)),
            const SizedBox(height: 20),
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.directions_car, size: 64, color: Colors.orange),
                    SizedBox(height: 16),
                    Text(
                      'High-Speed Chase',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Navigate through traffic while being pursued!',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text('Start Chase'),
            ),
          ],
        ),
      ),
    );
  }
}

// Stealth Minigame Dialog
class _StealthMinigameDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black87,
      child: Container(
        width: 400,
        height: 300,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Stealth Mission', style: AppTheme.headingStyle.copyWith(color: Colors.purple)),
            const SizedBox(height: 20),
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.visibility_off, size: 64, color: Colors.purple),
                    SizedBox(height: 16),
                    Text(
                      'Infiltration Mode',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Avoid guards and security cameras!',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
              child: const Text('Begin Mission'),
            ),
          ],
        ),
      ),
    );
  }
}

// Surveillance Minigame Dialog  
class _SurveillanceMinigameDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black87,
      child: Container(
        width: 400,
        height: 300,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Surveillance Operation', style: AppTheme.headingStyle.copyWith(color: Colors.indigo)),
            const SizedBox(height: 20),
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt, size: 64, color: Colors.indigo),
                    SizedBox(height: 16),
                    Text(
                      'Intel Gathering',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Monitor targets and collect evidence!',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
              child: const Text('Start Surveillance'),
            ),
          ],
        ),
      ),
    );
  }
}

// Hacking Minigame Dialog
class _HackingMinigameDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black87,
      child: Container(
        width: 400,
        height: 300,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Hacking Terminal', style: AppTheme.headingStyle.copyWith(color: Colors.blue)),
            const SizedBox(height: 20),
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.computer, size: 64, color: Colors.blue),
                    SizedBox(height: 16),
                    Text(
                      'System Breach',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Break into secure computer systems!',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Begin Hack'),
            ),
          ],
        ),
      ),
    );
  }
}

// Demolition Minigame Dialog
class _DemolitionMinigameDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black87,
      child: Container(
        width: 400,
        height: 300,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Demolition Expert', style: AppTheme.headingStyle.copyWith(color: Colors.deepOrange)),
            const SizedBox(height: 20),
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.whatshot, size: 64, color: Colors.deepOrange),
                    SizedBox(height: 16),
                    Text(
                      'Explosive Placement',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Place charges precisely for maximum effect!',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
              child: const Text('Arm Explosives'),
            ),
          ],
        ),
      ),
    );
  }
}

// Negotiation Minigame Dialog
class _NegotiationMinigameDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black87,
      child: Container(
        width: 400,
        height: 300,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Negotiation Table', style: AppTheme.headingStyle.copyWith(color: Colors.green)),
            const SizedBox(height: 20),
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.record_voice_over, size: 64, color: Colors.green),
                    SizedBox(height: 16),
                    Text(
                      'Diplomatic Solution',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Use persuasion and manipulation!',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Start Negotiation'),
            ),
          ],
        ),
      ),
    );
  }
}

// Intimidation Minigame Dialog
class _IntimidationMinigameDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black87,
      child: Container(
        width: 400,
        height: 300,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Intimidation Tactics', style: AppTheme.headingStyle.copyWith(color: Colors.amber)),
            const SizedBox(height: 20),
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning, size: 64, color: Colors.amber),
                    SizedBox(height: 16),
                    Text(
                      'Fear Factor',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Use psychological pressure to get results!',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              child: const Text('Apply Pressure'),
            ),
          ],
        ),
      ),
    );
  }
}
