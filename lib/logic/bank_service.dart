import '../data/constants.dart';

class BankService {
  static bool canDeposit(int amount, int currentCash) {
    return amount > 0 && amount <= currentCash;
  }

  static bool canWithdraw(int amount, int currentBank) {
    return amount > 0 && amount <= currentBank;
  }

  static int calculateDailyInterest(int bankBalance) {
    // Small daily interest
    return (bankBalance * BANK_DAILY_INTEREST).round();
  }

  static String formatInterestRate() {
    return '${(BANK_DAILY_INTEREST * 100).toStringAsFixed(1)}% daily';
  }

  static int getDepositLimit() {
    return 999999; // Arbitrary high limit
  }

  static int getWithdrawLimit() {
    return 999999; // Arbitrary high limit
  }
}
