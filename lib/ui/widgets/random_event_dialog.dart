import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';
import '../../providers.dart';

class RandomEvent {
  final String title;
  final String description;
  final List<EventChoice> choices;

  RandomEvent({
    required this.title,
    required this.description,
    required this.choices,
  });
}

class EventChoice {
  final String text;
  final VoidCallback onTap;

  EventChoice({
    required this.text,
    required this.onTap,
  });
}

class RandomEventDialog extends ConsumerStatefulWidget {
  const RandomEventDialog({super.key});

  @override
  ConsumerState<RandomEventDialog> createState() => _RandomEventDialogState();
}

class _RandomEventDialogState extends ConsumerState<RandomEventDialog> {
  late RandomEvent event;

  @override
  void initState() {
    super.initState();
    event = generateRandomEvent();
  }

  RandomEvent generateRandomEvent() {
    final random = Random();
    final eventTypes = ['recruitment', 'business', 'police', 'rival'];
    final eventType = eventTypes[random.nextInt(eventTypes.length)];
    
    final gangMembers = [
      'Tony "The Tiger" Marconi',
      'Vincent "Vinny" Rodriguez', 
      'Marcus "Steel" Johnson',
      'Isabella "Ice" Petrov',
      'Carlos "The Knife" Santos'
    ];
    
    final officials = [
      'Detective Sarah Mitchell',
      'Commissioner Robert Hayes',
      'Judge Patricia Williams',
      'Captain Mike Torres'
    ];
    
    final rivals = [
      'Salvatore "Sal" Romano',
      'Dmitri "The Bear" Volkov',
      'Maria "Black Widow" Gonzalez'
    ];

    switch (eventType) {
      case 'recruitment':
        final member = gangMembers[random.nextInt(gangMembers.length)];
        return RandomEvent(
          title: '👥 New Recruit Available',
          description: '$member wants to join your organization. They\'re offering their services for a reasonable fee.',
          choices: [
            EventChoice(
              text: 'Hire them (\$3,000)',
              onTap: () {
                final controller = ref.read(gameControllerProvider.notifier);
                final gameState = ref.read(gameControllerProvider);
                if (gameState.cash >= 3000) {
                  controller.recruitGangMember(member, 3000);
                  _showResult('✅ $member joined your crew!');
                } else {
                  _showResult('❌ Not enough cash!');
                }
              },
            ),
            EventChoice(
              text: 'Decline',
              onTap: () => _showResult('You declined the offer.'),
            ),
          ],
        );
        
      case 'business':
        return RandomEvent(
          title: '💼 Business Opportunity',
          description: 'A local businessman wants protection services. This could be a regular income source.',
          choices: [
            EventChoice(
              text: 'Accept Deal (\$2,000 investment)',
              onTap: () {
                final controller = ref.read(gameControllerProvider.notifier);
                final gameState = ref.read(gameControllerProvider);
                if (gameState.cash >= 2000) {
                  controller.spendCash(2000);
                  // Simulate earning from the business deal
                  controller.spendCash(-5000); // This adds money
                  _showResult('✅ Deal successful! Earned \$5,000!');
                } else {
                  _showResult('❌ Not enough cash for investment!');
                }
              },
            ),
            EventChoice(
              text: 'Ignore',
              onTap: () => _showResult('You ignored the opportunity.'),
            ),
          ],
        );
        
      case 'police':
        final officer = officials[random.nextInt(officials.length)];
        return RandomEvent(
          title: '🚔 Police Encounter',
          description: '$officer is investigating your operations. They\'re asking questions around the neighborhood.',
          choices: [
            EventChoice(
              text: 'Pay Bribe (\$4,000)',
              onTap: () {
                final controller = ref.read(gameControllerProvider.notifier);
                final gameState = ref.read(gameControllerProvider);
                if (gameState.cash >= 4000) {
                  controller.spendCash(4000);
                  _showResult('✅ $officer looked the other way.');
                } else {
                  _showResult('❌ Not enough cash for bribe!');
                }
              },
            ),
            EventChoice(
              text: 'Lay Low',
              onTap: () => _showResult('You decided to lay low for now.'),
            ),
          ],
        );
        
      case 'rival':
      default:
        final rival = rivals[random.nextInt(rivals.length)];
        return RandomEvent(
          title: '⚔️ Rival Gang Challenge',
          description: '$rival\'s crew is moving into your territory. They\'re demanding tribute or threatening war.',
          choices: [
            EventChoice(
              text: 'Fight Back (\$1,000)',
              onTap: () {
                final controller = ref.read(gameControllerProvider.notifier);
                final gameState = ref.read(gameControllerProvider);
                if (gameState.cash >= 1000) {
                  controller.spendCash(1000);
                  final success = random.nextBool();
                  if (success) {
                    // Simulate earning by spending negative amount
                    controller.spendCash(-3000);
                    _showResult('✅ Victory! Earned \$3,000 and respect!');
                  } else {
                    _showResult('❌ Fight failed, but you held your ground.');
                  }
                } else {
                  _showResult('❌ Not enough cash to fight!');
                }
              },
            ),
            EventChoice(
              text: 'Pay Tribute (\$2,000)',
              onTap: () {
                final controller = ref.read(gameControllerProvider.notifier);
                final gameState = ref.read(gameControllerProvider);
                if (gameState.cash >= 2000) {
                  controller.spendCash(2000);
                  _showResult('You paid tribute to avoid conflict.');
                } else {
                  _showResult('❌ Not enough cash for tribute!');
                }
              },
            ),
          ],
        );
    }
  }

  void _showResult(String message) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: message.contains('✅') ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 400,
        height: 300,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              event.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Text(
                event.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            ...event.choices.map(
              (choice) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: choice.onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4a4e69),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(choice.text),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
