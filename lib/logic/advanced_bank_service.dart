import 'dart:math';

enum AccountType {
  basic,
  premium,
  vip,
}

enum LoanType {
  personal,
  business,
  property,
}

enum InvestmentType {
  stocks,
  bonds,
  crypto,
  realEstate,
}

class LoanOffer {
  final LoanType type;
  final int maxAmount;
  final double interestRate;
  final int termDays;
  final int creditRequirement;
  final String description;

  const LoanOffer({
    required this.type,
    required this.maxAmount,
    required this.interestRate,
    required this.termDays,
    required this.creditRequirement,
    required this.description,
  });
}

class Investment {
  final String id;
  final InvestmentType type;
  final String name;
  final int amount;
  final double currentValue;
  final double dailyReturn;
  final int daysHeld;
  final DateTime purchaseDate;

  const Investment({
    required this.id,
    required this.type,
    required this.name,
    required this.amount,
    required this.currentValue,
    required this.dailyReturn,
    required this.daysHeld,
    required this.purchaseDate,
  });

  Investment copyWith({
    String? id,
    InvestmentType? type,
    String? name,
    int? amount,
    double? currentValue,
    double? dailyReturn,
    int? daysHeld,
    DateTime? purchaseDate,
  }) {
    return Investment(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      currentValue: currentValue ?? this.currentValue,
      dailyReturn: dailyReturn ?? this.dailyReturn,
      daysHeld: daysHeld ?? this.daysHeld,
      purchaseDate: purchaseDate ?? this.purchaseDate,
    );
  }

  double get totalReturn => currentValue - amount;
  double get returnPercentage => (totalReturn / amount) * 100;
}

class Loan {
  final String id;
  final LoanType type;
  final int originalAmount;
  final int remainingAmount;
  final double interestRate;
  final int termDays;
  final int daysRemaining;
  final DateTime startDate;

  const Loan({
    required this.id,
    required this.type,
    required this.originalAmount,
    required this.remainingAmount,
    required this.interestRate,
    required this.termDays,
    required this.daysRemaining,
    required this.startDate,
  });

  Loan copyWith({
    String? id,
    LoanType? type,
    int? originalAmount,
    int? remainingAmount,
    double? interestRate,
    int? termDays,
    int? daysRemaining,
    DateTime? startDate,
  }) {
    return Loan(
      id: id ?? this.id,
      type: type ?? this.type,
      originalAmount: originalAmount ?? this.originalAmount,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      interestRate: interestRate ?? this.interestRate,
      termDays: termDays ?? this.termDays,
      daysRemaining: daysRemaining ?? this.daysRemaining,
      startDate: startDate ?? this.startDate,
    );
  }

  int get dailyPayment => (remainingAmount / daysRemaining).ceil();
  bool get isOverdue => daysRemaining <= 0 && remainingAmount > 0;
  double get totalInterest => originalAmount * (interestRate / 100) * (termDays / 30);
}

class AdvancedBankService {
  static const Map<AccountType, Map<String, dynamic>> accountBenefits = {
    AccountType.basic: {
      'interestRate': 0.001, // 0.1% daily
      'loanMultiplier': 1.0,
      'investmentSlots': 3,
      'withdrawalLimit': 50000,
      'monthlyFee': 0,
      'name': 'Basic Account',
    },
    AccountType.premium: {
      'interestRate': 0.0015, // 0.15% daily
      'loanMultiplier': 1.5,
      'investmentSlots': 5,
      'withdrawalLimit': 200000,
      'monthlyFee': 500,
      'name': 'Premium Account',
    },
    AccountType.vip: {
      'interestRate': 0.002, // 0.2% daily
      'loanMultiplier': 2.0,
      'investmentSlots': 10,
      'withdrawalLimit': 1000000,
      'monthlyFee': 2000,
      'name': 'VIP Account',
    },
  };

  static const List<LoanOffer> loanOffers = [
    LoanOffer(
      type: LoanType.personal,
      maxAmount: 50000,
      interestRate: 15.0, // 15% over term
      termDays: 30,
      creditRequirement: 500,
      description: 'Quick personal loan for immediate needs',
    ),
    LoanOffer(
      type: LoanType.business,
      maxAmount: 200000,
      interestRate: 12.0,
      termDays: 60,
      creditRequirement: 750,
      description: 'Business expansion loan with competitive rates',
    ),
    LoanOffer(
      type: LoanType.property,
      maxAmount: 1000000,
      interestRate: 8.0,
      termDays: 90,
      creditRequirement: 850,
      description: 'Property investment loan for real estate ventures',
    ),
  ];

  static AccountType getAccountType(int bankBalance) {
    if (bankBalance >= 500000) return AccountType.vip;
    if (bankBalance >= 100000) return AccountType.premium;
    return AccountType.basic;
  }

  static double getInterestRate(AccountType accountType) {
    return accountBenefits[accountType]!['interestRate'];
  }

  static int getInvestmentSlots(AccountType accountType) {
    return accountBenefits[accountType]!['investmentSlots'];
  }

  static int getWithdrawalLimit(AccountType accountType) {
    return accountBenefits[accountType]!['withdrawalLimit'];
  }

  static int getMonthlyFee(AccountType accountType) {
    return accountBenefits[accountType]!['monthlyFee'];
  }

  static String getAccountName(AccountType accountType) {
    return accountBenefits[accountType]!['name'];
  }

  static List<LoanOffer> getAvailableLoans(int creditScore) {
    return loanOffers.where((loan) => creditScore >= loan.creditRequirement).toList();
  }

  static bool canGetLoan(int creditScore, LoanOffer loan, List<Loan> existingLoans) {
    if (creditScore < loan.creditRequirement) return false;
    
    // Limit concurrent loans
    if (existingLoans.length >= 3) return false;
    
    // Check total debt load
    final totalDebt = existingLoans.fold(0, (sum, loan) => sum + loan.remainingAmount);
    return totalDebt <= 300000; // Max total debt
  }

  static List<Map<String, dynamic>> generateInvestmentOptions() {
    final random = Random();
    return [
      {
        'type': InvestmentType.stocks,
        'name': 'Tech Stocks',
        'minAmount': 1000,
        'expectedDaily': 0.02 + (random.nextDouble() * 0.03), // 2-5% daily
        'risk': 'High',
        'description': 'High-growth technology companies',
      },
      {
        'type': InvestmentType.bonds,
        'name': 'Government Bonds',
        'minAmount': 5000,
        'expectedDaily': 0.005 + (random.nextDouble() * 0.005), // 0.5-1% daily
        'risk': 'Low',
        'description': 'Stable government-backed securities',
      },
      {
        'type': InvestmentType.crypto,
        'name': 'Street Coin',
        'minAmount': 500,
        'expectedDaily': -0.05 + (random.nextDouble() * 0.15), // -5% to +10% daily
        'risk': 'Extreme',
        'description': 'Volatile digital currency',
      },
      {
        'type': InvestmentType.realEstate,
        'name': 'Property Fund',
        'minAmount': 25000,
        'expectedDaily': 0.01 + (random.nextDouble() * 0.02), // 1-3% daily
        'risk': 'Medium',
        'description': 'Diversified real estate portfolio',
      },
    ];
  }

  static Investment updateInvestmentValue(Investment investment) {
    final random = Random();
    double volatility = 0.1; // Base volatility
    
    switch (investment.type) {
      case InvestmentType.stocks:
        volatility = 0.2;
        break;
      case InvestmentType.bonds:
        volatility = 0.02;
        break;
      case InvestmentType.crypto:
        volatility = 0.5;
        break;
      case InvestmentType.realEstate:
        volatility = 0.05;
        break;
    }
    
    // Calculate new value with some randomness
    final change = investment.dailyReturn + ((random.nextDouble() - 0.5) * volatility);
    final newValue = investment.currentValue * (1 + change);
    
    return investment.copyWith(
      currentValue: newValue,
      daysHeld: investment.daysHeld + 1,
    );
  }

  static Loan processLoanPayment(Loan loan, int paymentAmount) {
    final newRemaining = (loan.remainingAmount - paymentAmount).clamp(0, loan.remainingAmount);
    return loan.copyWith(
      remainingAmount: newRemaining,
      daysRemaining: loan.daysRemaining - 1,
    );
  }

  static int calculateCreditScore(
    int bankBalance,
    List<Loan> loanHistory,
    int daysSinceLastLoan,
    int totalTransactions,
  ) {
    int score = 500; // Base score
    
    // Bank balance factor
    score += (bankBalance / 10000).clamp(0, 200).round();
    
    // Loan history factor
    final paidLoans = loanHistory.where((loan) => loan.remainingAmount == 0).length;
    final overdueLoans = loanHistory.where((loan) => loan.isOverdue).length;
    
    score += paidLoans * 50;
    score -= overdueLoans * 100;
    
    // Activity factor
    score += (totalTransactions / 100).clamp(0, 100).round();
    
    // Time factor
    if (daysSinceLastLoan > 30) score += 50;
    
    return score.clamp(300, 900);
  }
}
