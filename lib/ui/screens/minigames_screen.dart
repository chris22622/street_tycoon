import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers.dart';

class MinigamesScreen extends ConsumerStatefulWidget {
  const MinigamesScreen({super.key});

  @override
  ConsumerState<MinigamesScreen> createState() => _MinigamesScreenState();
}

class _MinigamesScreenState extends ConsumerState<MinigamesScreen> {
  int selectedGameIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Street Minigames'),
        backgroundColor: Colors.purple.shade800,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Game selection tabs
          Container(
            color: Colors.purple.shade50,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildGameTab('Dice Roll', Icons.casino, 0),
                  _buildGameTab('Card Draw', Icons.style, 1),
                  _buildGameTab('Number Guess', Icons.quiz, 2),
                  _buildGameTab('Street Racing', Icons.directions_car, 3),
                  _buildGameTab('Poker', Icons.casino_outlined, 4),
                ],
              ),
            ),
          ),
          
          // Game content
          Expanded(
            child: _buildSelectedGame(),
          ),
        ],
      ),
    );
  }

  Widget _buildGameTab(String title, IconData icon, int index) {
    final isSelected = selectedGameIndex == index;
    return GestureDetector(
      onTap: () => setState(() => selectedGameIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple.shade800 : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.purple.shade800),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.purple.shade800, size: 18),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.purple.shade800,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedGame() {
    switch (selectedGameIndex) {
      case 0:
        return const DiceRollGame();
      case 1:
        return const CardDrawGame();
      case 2:
        return const NumberGuessGame();
      case 3:
        return const StreetRacingGame();
      case 4:
        return const PokerGame();
      default:
        return const DiceRollGame();
    }
  }
}

// Dice Roll Game
class DiceRollGame extends ConsumerStatefulWidget {
  const DiceRollGame({super.key});

  @override
  ConsumerState<DiceRollGame> createState() => _DiceRollGameState();
}

class _DiceRollGameState extends ConsumerState<DiceRollGame> {
  int? lastRoll;
  int betAmount = 50;
  String betType = 'high'; // 'high' (4-6), 'low' (1-3), 'exact'
  int exactNumber = 6;
  bool isRolling = false;

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameControllerProvider);
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Game info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    '🎲 Dice Roll',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Bet on dice outcome:\n• High (4-6): 2x payout\n• Low (1-3): 2x payout\n• Exact number: 6x payout',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Dice display
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: Center(
              child: isRolling
                  ? const CircularProgressIndicator()
                  : Text(
                      lastRoll?.toString() ?? '?',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Bet controls
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Bet amount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Bet Amount:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => setState(() => betAmount = (betAmount - 10).clamp(10, gameState.cash)),
                            icon: const Icon(Icons.remove),
                          ),
                          Text('\$${betAmount}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          IconButton(
                            onPressed: () => setState(() => betAmount = (betAmount + 10).clamp(10, gameState.cash)),
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  // Bet type
                  const SizedBox(height: 16),
                  const Text('Bet Type:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('High (4-6)'),
                        selected: betType == 'high',
                        onSelected: (selected) => setState(() => betType = 'high'),
                      ),
                      ChoiceChip(
                        label: const Text('Low (1-3)'),
                        selected: betType == 'low',
                        onSelected: (selected) => setState(() => betType = 'low'),
                      ),
                      ChoiceChip(
                        label: const Text('Exact'),
                        selected: betType == 'exact',
                        onSelected: (selected) => setState(() => betType = 'exact'),
                      ),
                    ],
                  ),
                  
                  if (betType == 'exact') ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Number: '),
                        ...List.generate(6, (index) {
                          final number = index + 1;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ChoiceChip(
                              label: Text(number.toString()),
                              selected: exactNumber == number,
                              onSelected: (selected) => setState(() => exactNumber = number),
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Roll button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: betAmount <= gameState.cash && !isRolling ? _rollDice : null,
              icon: const Icon(Icons.casino),
              label: Text(isRolling ? 'Rolling...' : 'Roll Dice (\$${betAmount})'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade800,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _rollDice() async {
    if (isRolling) return;
    
    setState(() => isRolling = true);
    
    final controller = ref.read(gameControllerProvider.notifier);
    
    try {
      // Simulate rolling animation
      await Future.delayed(const Duration(milliseconds: 1500));
      
      final result = await controller.playMinigame(
        gameType: 'dice_roll',
        betAmount: betAmount,
        gameParams: {
          'betType': betType,
          'exactNumber': exactNumber,
        },
      );
      
      setState(() {
        lastRoll = result.details['roll_result'];
        isRolling = false;
      });
      
      // Show result dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(result.won ? 'You Won!' : 'You Lost!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('🎲 Rolled: ${result.details['roll_result']}'),
                const SizedBox(height: 8),
                Text(result.message),
                if (result.won) Text('Winnings: \$${result.winnings}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Continue'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      setState(() => isRolling = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}

// Card Draw Game
class CardDrawGame extends ConsumerStatefulWidget {
  const CardDrawGame({super.key});

  @override
  ConsumerState<CardDrawGame> createState() => _CardDrawGameState();
}

class _CardDrawGameState extends ConsumerState<CardDrawGame> {
  String? lastCard;
  int betAmount = 75;
  String betType = 'red'; // 'red', 'black', 'face', 'ace'
  bool isDrawing = false;

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameControllerProvider);
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Game info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    '🃏 Card Draw',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Bet on card color/type:\n• Red/Black: 2x payout\n• Face card (J,Q,K): 3x payout\n• Ace: 5x payout',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Card display
          Container(
            width: 140,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: Center(
              child: isDrawing
                  ? const CircularProgressIndicator()
                  : Text(
                      lastCard ?? '🃏',
                      style: const TextStyle(fontSize: 48),
                    ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Bet controls
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Bet amount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Bet Amount:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => setState(() => betAmount = (betAmount - 25).clamp(25, gameState.cash)),
                            icon: const Icon(Icons.remove),
                          ),
                          Text('\$${betAmount}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          IconButton(
                            onPressed: () => setState(() => betAmount = (betAmount + 25).clamp(25, gameState.cash)),
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  // Bet type
                  const SizedBox(height: 16),
                  const Text('Bet On:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('Red ♥♦'),
                        selected: betType == 'red',
                        onSelected: (selected) => setState(() => betType = 'red'),
                      ),
                      ChoiceChip(
                        label: const Text('Black ♠♣'),
                        selected: betType == 'black',
                        onSelected: (selected) => setState(() => betType = 'black'),
                      ),
                      ChoiceChip(
                        label: const Text('Face (J,Q,K)'),
                        selected: betType == 'face',
                        onSelected: (selected) => setState(() => betType = 'face'),
                      ),
                      ChoiceChip(
                        label: const Text('Ace'),
                        selected: betType == 'ace',
                        onSelected: (selected) => setState(() => betType = 'ace'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Draw button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: betAmount <= gameState.cash && !isDrawing ? _drawCard : null,
              icon: const Icon(Icons.style),
              label: Text(isDrawing ? 'Drawing...' : 'Draw Card (\$${betAmount})'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade800,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _drawCard() async {
    if (isDrawing) return;
    
    setState(() => isDrawing = true);
    
    final controller = ref.read(gameControllerProvider.notifier);
    
    try {
      // Simulate card drawing animation
      await Future.delayed(const Duration(milliseconds: 1000));
      
      final result = await controller.playMinigame(
        gameType: 'card_draw',
        betAmount: betAmount,
        gameParams: {'betType': betType},
      );
      
      setState(() {
        lastCard = result.details['card_drawn'];
        isDrawing = false;
      });
      
      // Show result dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(result.won ? 'You Won!' : 'You Lost!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('🃏 Drew: ${result.details['card_drawn']}'),
                const SizedBox(height: 8),
                Text(result.message),
                if (result.won) Text('Winnings: \$${result.winnings}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Continue'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      setState(() => isDrawing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}

// Number Guess Game Implementation
class NumberGuessGame extends ConsumerStatefulWidget {
  const NumberGuessGame({super.key});

  @override
  ConsumerState<NumberGuessGame> createState() => _NumberGuessGameState();
}

class _NumberGuessGameState extends ConsumerState<NumberGuessGame> {
  final TextEditingController _guessController = TextEditingController();
  int betAmount = 100;
  int targetRange = 10; // 1-10, 1-50, 1-100
  bool isGuessing = false;
  int? lastGuess;
  int? lastTarget;

  @override
  void dispose() {
    _guessController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameControllerProvider);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text('🎯 Number Guessing', 
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          
          // Game Info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text('Guess the secret number!', 
                    style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Range: 1-$targetRange'),
                  if (lastGuess != null && lastTarget != null)
                    Text('Last: Guessed $lastGuess, Answer was $lastTarget'),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Range Selection
          const Text('Select Range:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 10, label: Text('1-10\n(×5)')),
              ButtonSegment(value: 50, label: Text('1-50\n(×25)')),
              ButtonSegment(value: 100, label: Text('1-100\n(×50)')),
            ],
            selected: {targetRange},
            onSelectionChanged: (Set<int> newSelection) {
              setState(() => targetRange = newSelection.first);
            },
          ),
          
          const SizedBox(height: 20),
          
          // Guess Input
          TextField(
            controller: _guessController,
            decoration: InputDecoration(
              labelText: 'Your Guess (1-$targetRange)',
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            enabled: !isGuessing,
          ),
          
          const SizedBox(height: 20),
          
          // Bet Amount
          const Text('Bet Amount:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 50, label: Text('\$50')),
              ButtonSegment(value: 100, label: Text('\$100')),
              ButtonSegment(value: 250, label: Text('\$250')),
              ButtonSegment(value: 500, label: Text('\$500')),
            ],
            selected: {betAmount},
            onSelectionChanged: (Set<int> newSelection) {
              setState(() => betAmount = newSelection.first);
            },
          ),
          
          const SizedBox(height: 20),
          
          // Action Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: (!isGuessing && gameState.cash >= betAmount && 
                         _guessController.text.isNotEmpty) ? _makeGuess : null,
              child: isGuessing 
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 10),
                      Text('Checking...'),
                    ],
                  )
                : Text('Make Guess (\$${betAmount})'),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Balance Display
          Card(
            color: Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('💰 Current Balance:'),
                  Text('\$${gameState.cash}', 
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _makeGuess() async {
    if (isGuessing) return;
    
    final guessText = _guessController.text.trim();
    final guess = int.tryParse(guessText);
    
    if (guess == null || guess < 1 || guess > targetRange) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid number between 1 and $targetRange')),
      );
      return;
    }
    
    setState(() => isGuessing = true);
    
    final controller = ref.read(gameControllerProvider.notifier);
    
    try {
      // Simulate thinking time
      await Future.delayed(const Duration(milliseconds: 1000));
      
      final result = await controller.playMinigame(
        gameType: 'number_guess',
        betAmount: betAmount,
        gameParams: {
          'guess': guess,
          'targetRange': targetRange,
        },
      );
      
      setState(() {
        lastGuess = guess;
        lastTarget = result.details['target_number'];
        isGuessing = false;
      });
      
      _guessController.clear();
      
      // Show result dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(result.won ? 'Correct! 🎉' : 'Wrong! 😔'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('🎯 Your guess: $guess'),
                Text('🔢 Secret number: ${result.details['target_number']}'),
                const SizedBox(height: 8),
                Text(result.message),
                if (result.won) Text('Winnings: \$${result.winnings}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Continue'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      setState(() => isGuessing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}

// Street Racing Game Implementation
class StreetRacingGame extends ConsumerStatefulWidget {
  const StreetRacingGame({super.key});

  @override
  ConsumerState<StreetRacingGame> createState() => _StreetRacingGameState();
}

class _StreetRacingGameState extends ConsumerState<StreetRacingGame> {
  int betAmount = 200;
  String selectedCar = 'sports_car';
  bool isRacing = false;
  String? lastRaceResult;
  
  final Map<String, Map<String, dynamic>> cars = {
    'muscle_car': {
      'name': 'Muscle Car',
      'emoji': '🏎️',
      'speed': 85,
      'description': 'High power, good speed',
    },
    'sports_car': {
      'name': 'Sports Car', 
      'emoji': '🚗',
      'speed': 90,
      'description': 'Balanced performance',
    },
    'super_car': {
      'name': 'Super Car',
      'emoji': '🚕',
      'speed': 95,
      'description': 'Ultimate speed machine',
    },
  };

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameControllerProvider);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text('🏁 Street Racing', 
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          
          // Game Info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text('Race against street opponents!', 
                    style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  const Text('Choose your car and bet on yourself'),
                  if (lastRaceResult != null)
                    Text('Last race: $lastRaceResult'),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Car Selection
          const Text('Choose Your Car:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          
          ...cars.entries.map((entry) {
            final carKey = entry.key;
            final carData = entry.value;
            final isSelected = selectedCar == carKey;
            
            return Card(
              color: isSelected ? Colors.blue.shade50 : null,
              child: ListTile(
                leading: Text(carData['emoji'], style: const TextStyle(fontSize: 24)),
                title: Text(carData['name']),
                subtitle: Text('${carData['description']} • Speed: ${carData['speed']}'),
                trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.blue) : null,
                onTap: () => setState(() => selectedCar = carKey),
              ),
            );
          }).toList(),
          
          const SizedBox(height: 20),
          
          // Bet Amount
          const Text('Bet Amount:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 100, label: Text('\$100')),
              ButtonSegment(value: 200, label: Text('\$200')),
              ButtonSegment(value: 500, label: Text('\$500')),
              ButtonSegment(value: 1000, label: Text('\$1000')),
            ],
            selected: {betAmount},
            onSelectionChanged: (Set<int> newSelection) {
              setState(() => betAmount = newSelection.first);
            },
          ),
          
          const SizedBox(height: 20),
          
          // Action Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: (!isRacing && gameState.cash >= betAmount) ? _startRace : null,
              child: isRacing 
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 10),
                      Text('Racing...'),
                    ],
                  )
                : Text('Start Race (\$${betAmount})'),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Balance Display
          Card(
            color: Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('💰 Current Balance:'),
                  Text('\$${gameState.cash}', 
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _startRace() async {
    if (isRacing) return;
    
    setState(() => isRacing = true);
    
    final controller = ref.read(gameControllerProvider.notifier);
    
    try {
      // Simulate race time
      await Future.delayed(const Duration(milliseconds: 2500));
      
      final result = await controller.playMinigame(
        gameType: 'street_race',
        betAmount: betAmount,
        gameParams: {
          'selectedCar': selectedCar,
          'carSpeed': cars[selectedCar]!['speed'],
        },
      );
      
      setState(() {
        lastRaceResult = result.won ? 'WON!' : 'Lost';
        isRacing = false;
      });
      
      // Show result dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(result.won ? 'Victory! 🏆' : 'Defeat! 😔'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('🏁 Your time: ${result.details['player_time']}s'),
                Text('🚗 Opponent time: ${result.details['opponent_time']}s'),
                const SizedBox(height: 8),
                Text(result.message),
                if (result.won) Text('Winnings: \$${result.winnings}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Continue'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      setState(() => isRacing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}

class PokerGame extends StatelessWidget {
  const PokerGame({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Poker Game\n(Coming Soon!)', 
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18)),
    );
  }
}
