import 'dart:math';
import '../data/models.dart';
import '../data/activity_log.dart';

class MinigameResult {
  final bool won;
  final int winnings;
  final int netGain; // winnings - bet
  final String message;
  final Map<String, dynamic> details;

  MinigameResult({
    required this.won,
    required this.winnings,
    required this.netGain,
    required this.message,
    required this.details,
  });
}

class MinigamesService {
  static final Random _random = Random();

  static MinigameResult playDiceRoll({
    required int betAmount,
    required String betType, // 'high', 'low', 'exact'
    int exactNumber = 6,
  }) {
    final result = _random.nextInt(6) + 1;
    
    int winnings = 0;
    bool won = false;
    String message = '';
    
    if (betType == 'high' && result >= 4) {
      winnings = betAmount * 2;
      won = true;
      message = 'High roll wins! 🎉';
    } else if (betType == 'low' && result <= 3) {
      winnings = betAmount * 2;
      won = true;
      message = 'Low roll wins! 🎉';
    } else if (betType == 'exact' && result == exactNumber) {
      winnings = betAmount * 6;
      won = true;
      message = 'Exact match! JACKPOT! 🏆';
    } else {
      message = 'Better luck next time! 😔';
    }
    
    return MinigameResult(
      won: won,
      winnings: winnings,
      netGain: winnings - betAmount,
      message: message,
      details: {
        'game': 'dice_roll',
        'bet_amount': betAmount,
        'bet_type': betType,
        'exact_number': exactNumber,
        'roll_result': result,
      },
    );
  }

  static MinigameResult playCardDraw({
    required int betAmount,
    required String betType, // 'red', 'black', 'face', 'ace'
  }) {
    final suits = ['♠', '♥', '♦', '♣'];
    final values = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'];
    
    final suit = suits[_random.nextInt(suits.length)];
    final value = values[_random.nextInt(values.length)];
    final card = '$value$suit';
    
    int winnings = 0;
    bool won = false;
    String message = '';
    
    final isRed = suit == '♥' || suit == '♦';
    final isBlack = suit == '♠' || suit == '♣';
    final isFace = value == 'J' || value == 'Q' || value == 'K';
    final isAce = value == 'A';
    
    if (betType == 'red' && isRed) {
      winnings = betAmount * 2;
      won = true;
      message = 'Red card wins! 🔴';
    } else if (betType == 'black' && isBlack) {
      winnings = betAmount * 2;
      won = true;
      message = 'Black card wins! ⚫';
    } else if (betType == 'face' && isFace) {
      winnings = betAmount * 3;
      won = true;
      message = 'Face card wins! 👑';
    } else if (betType == 'ace' && isAce) {
      winnings = betAmount * 5;
      won = true;
      message = 'Ace! JACKPOT! 🃏';
    } else {
      message = 'No match! Try again! 😔';
    }
    
    return MinigameResult(
      won: won,
      winnings: winnings,
      netGain: winnings - betAmount,
      message: message,
      details: {
        'game': 'card_draw',
        'bet_amount': betAmount,
        'bet_type': betType,
        'card_result': card,
      },
    );
  }

  static MinigameResult playNumberGuess({
    required int betAmount,
    required int guessedNumber, // 1-10
  }) {
    final result = _random.nextInt(10) + 1;
    
    int winnings = 0;
    bool won = false;
    String message = '';
    
    if (guessedNumber == result) {
      winnings = betAmount * 10;
      won = true;
      message = 'Perfect guess! MEGA JACKPOT! 🎯';
    } else if ((guessedNumber - result).abs() == 1) {
      winnings = betAmount * 3;
      won = true;
      message = 'So close! Consolation prize! 🎊';
    } else {
      message = 'Wrong number! Try again! 🤔';
    }
    
    return MinigameResult(
      won: won,
      winnings: winnings,
      netGain: winnings - betAmount,
      message: message,
      details: {
        'game': 'number_guess',
        'bet_amount': betAmount,
        'guessed_number': guessedNumber,
        'actual_number': result,
      },
    );
  }

  static MinigameResult playStreetRace({
    required int betAmount,
    required int skillLevel, // driving skill affects odds
  }) {
    // Higher driving skill improves odds
    final baseChance = 0.45;
    final skillBonus = skillLevel * 0.02; // +2% per skill level
    final winChance = (baseChance + skillBonus).clamp(0.0, 0.8); // Max 80% chance
    
    final won = _random.nextDouble() < winChance;
    
    int winnings = 0;
    String message = '';
    
    if (won) {
      winnings = betAmount * 3;
      message = 'You won the race! 🏁';
    } else {
      message = 'You lost the race! 🚗💨';
    }
    
    return MinigameResult(
      won: won,
      winnings: winnings,
      netGain: winnings - betAmount,
      message: message,
      details: {
        'game': 'street_race',
        'bet_amount': betAmount,
        'skill_level': skillLevel,
        'win_chance': winChance,
      },
    );
  }

  static Activity createMinigameActivity(MinigameResult result) {
    return Activity.randomEvent(
      eventTitle: result.won ? 'Minigame Win!' : 'Minigame Loss',
      eventDescription: result.message,
      eventEmoji: result.won ? '🎮✨' : '🎮💔',
      cashImpact: result.netGain,
      metadata: result.details,
    );
  }
}
