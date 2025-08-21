import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers.dart';
import '../../logic/advanced_bank_service.dart';

class AdvancedBankingScreen extends ConsumerStatefulWidget {
  const AdvancedBankingScreen({super.key});

  @override
  ConsumerState<AdvancedBankingScreen> createState() => _AdvancedBankingScreenState();
}

class _AdvancedBankingScreenState extends ConsumerState<AdvancedBankingScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  
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
    final accountType = AdvancedBankService.getAccountType(gameState.bank);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('🏦 Advanced Banking'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.account_balance), text: 'Account'),
            Tab(icon: Icon(Icons.monetization_on), text: 'Loans'),
            Tab(icon: Icon(Icons.trending_up), text: 'Investments'),
            Tab(icon: Icon(Icons.credit_card), text: 'Credit'),
            Tab(icon: Icon(Icons.history), text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAccountTab(gameState, accountType),
          _buildLoansTab(gameState),
          _buildInvestmentsTab(gameState),
          _buildCreditTab(gameState),
          _buildHistoryTab(gameState),
        ],
      ),
    );
  }

  Widget _buildAccountTab(dynamic gameState, AccountType accountType) {
    final interestRate = AdvancedBankService.getInterestRate(accountType);
    final withdrawalLimit = AdvancedBankService.getWithdrawalLimit(accountType);
    final monthlyFee = AdvancedBankService.getMonthlyFee(accountType);
    final accountName = AdvancedBankService.getAccountName(accountType);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Account Overview Card
          Card(
            elevation: 8,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getAccountColor(accountType),
                    _getAccountColor(accountType).withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        accountName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _getAccountIcon(accountType),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Balance',
                    style: TextStyle(color: Colors.white.withOpacity(0.8)),
                  ),
                  Text(
                    '\$${_formatMoney(gameState.bank)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Cash: \$${_formatMoney(gameState.cash)}',
                    style: TextStyle(color: Colors.white.withOpacity(0.9)),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Quick Actions
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showBankModal(context),
                  icon: const Icon(Icons.arrow_upward),
                  label: const Text('Deposit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showBankModal(context),
                  icon: const Icon(Icons.arrow_downward),
                  label: const Text('Withdraw'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Account Benefits
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Account Benefits',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildBenefitRow(
                    'Daily Interest Rate',
                    '${(interestRate * 100).toStringAsFixed(2)}%',
                    Icons.trending_up,
                    Colors.green,
                  ),
                  _buildBenefitRow(
                    'Daily Withdrawal Limit',
                    '\$${_formatMoney(withdrawalLimit)}',
                    Icons.credit_card,
                    Colors.blue,
                  ),
                  _buildBenefitRow(
                    'Investment Slots',
                    '${AdvancedBankService.getInvestmentSlots(accountType)}',
                    Icons.business_center,
                    Colors.purple,
                  ),
                  if (monthlyFee > 0)
                    _buildBenefitRow(
                      'Monthly Fee',
                      '\$${_formatMoney(monthlyFee)}',
                      Icons.payment,
                      Colors.red,
                    ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Account Upgrade
          if (accountType != AccountType.vip)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Upgrade Your Account',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      accountType == AccountType.basic
                          ? 'Deposit \$100,000 to unlock Premium benefits'
                          : 'Deposit \$500,000 to unlock VIP benefits',
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: accountType == AccountType.basic
                          ? (gameState.bank / 100000).clamp(0.0, 1.0)
                          : (gameState.bank / 500000).clamp(0.0, 1.0),
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getAccountColor(accountType == AccountType.basic ? AccountType.premium : AccountType.vip),
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

  Widget _buildLoansTab(dynamic gameState) {
    // In a real implementation, this would get loans from game state
    final availableLoans = AdvancedBankService.getAvailableLoans(750); // Mock credit score
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Available Loans',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          ...availableLoans.map((loan) => Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _getLoanColor(loan.type),
                child: Icon(
                  _getLoanIcon(loan.type),
                  color: Colors.white,
                ),
              ),
              title: Text('${_getLoanTypeName(loan.type)} Loan'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(loan.description),
                  const SizedBox(height: 4),
                  Text('Max: \$${_formatMoney(loan.maxAmount)} • ${loan.interestRate}% interest'),
                  Text('Term: ${loan.termDays} days • Credit req: ${loan.creditRequirement}'),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: () => _applyForLoan(loan),
                child: const Text('Apply'),
              ),
              isThreeLine: true,
            ),
          )).toList(),
          
          const SizedBox(height: 20),
          
          const Text(
            'Active Loans',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // Placeholder for active loans
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(Icons.check_circle, size: 48, color: Colors.green),
                  const SizedBox(height: 8),
                  const Text('No Active Loans'),
                  const Text('You have a clean credit record!'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvestmentsTab(dynamic gameState) {
    final investmentOptions = AdvancedBankService.generateInvestmentOptions();
    final accountType = AdvancedBankService.getAccountType(gameState.bank);
    final availableSlots = AdvancedBankService.getInvestmentSlots(accountType);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.info, color: Colors.blue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'You have $availableSlots investment slots available',
                      style: TextStyle(color: Colors.blue.shade800),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          const Text(
            'Investment Options',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          ...investmentOptions.map((investment) => Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _getInvestmentColor(investment['type']),
                child: Icon(
                  _getInvestmentIcon(investment['type']),
                  color: Colors.white,
                ),
              ),
              title: Text(investment['name']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(investment['description']),
                  const SizedBox(height: 4),
                  Text('Min: \$${_formatMoney(investment['minAmount'])} • Risk: ${investment['risk']}'),
                  Text('Expected: ${(investment['expectedDaily'] * 100).toStringAsFixed(2)}% daily'),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: () => _makeInvestment(investment),
                child: const Text('Invest'),
              ),
              isThreeLine: true,
            ),
          )).toList(),
          
          const SizedBox(height: 20),
          
          const Text(
            'Your Portfolio',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // Placeholder for portfolio
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(Icons.business_center, size: 48, color: Colors.grey),
                  const SizedBox(height: 8),
                  const Text('No Investments Yet'),
                  const Text('Start building your portfolio today!'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditTab(dynamic gameState) {
    // Mock credit score calculation
    final creditScore = AdvancedBankService.calculateCreditScore(
      gameState.bank,
      [], // No loan history yet
      30, // Days since last loan
      100, // Total transactions
    );
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Credit Score Card
          Card(
            elevation: 8,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getCreditScoreColor(creditScore),
                    _getCreditScoreColor(creditScore).withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Credit Score',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    creditScore.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _getCreditRating(creditScore),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Credit Factors
          const Text(
            'Credit Factors',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildCreditFactor(
                    'Bank Balance',
                    '\$${_formatMoney(gameState.bank)}',
                    Icons.account_balance_wallet,
                    Colors.green,
                    (gameState.bank / 100000).clamp(0.0, 1.0),
                  ),
                  const SizedBox(height: 12),
                  _buildCreditFactor(
                    'Payment History',
                    'Excellent',
                    Icons.history,
                    Colors.blue,
                    1.0,
                  ),
                  const SizedBox(height: 12),
                  _buildCreditFactor(
                    'Account Age',
                    '${gameState.day} days',
                    Icons.calendar_today,
                    Colors.purple,
                    (gameState.day / 100).clamp(0.0, 1.0),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab(dynamic gameState) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Transaction History',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // Placeholder for transaction history
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(Icons.receipt_long, size: 48, color: Colors.grey),
                  const SizedBox(height: 8),
                  const Text('No Transaction History'),
                  const Text('Your banking activity will appear here'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitRow(String title, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(title)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditFactor(String title, String value, IconData icon, Color color, double progress) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title),
                  Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper methods
  Color _getAccountColor(AccountType type) {
    switch (type) {
      case AccountType.basic:
        return Colors.grey.shade600;
      case AccountType.premium:
        return Colors.blue.shade600;
      case AccountType.vip:
        return Colors.purple.shade600;
    }
  }

  Widget _getAccountIcon(AccountType type) {
    switch (type) {
      case AccountType.basic:
        return const Icon(Icons.account_circle, color: Colors.white, size: 32);
      case AccountType.premium:
        return const Icon(Icons.star, color: Colors.white, size: 32);
      case AccountType.vip:
        return const Icon(Icons.diamond, color: Colors.white, size: 32);
    }
  }

  Color _getLoanColor(LoanType type) {
    switch (type) {
      case LoanType.personal:
        return Colors.green;
      case LoanType.business:
        return Colors.blue;
      case LoanType.property:
        return Colors.orange;
    }
  }

  IconData _getLoanIcon(LoanType type) {
    switch (type) {
      case LoanType.personal:
        return Icons.person;
      case LoanType.business:
        return Icons.business;
      case LoanType.property:
        return Icons.home;
    }
  }

  String _getLoanTypeName(LoanType type) {
    switch (type) {
      case LoanType.personal:
        return 'Personal';
      case LoanType.business:
        return 'Business';
      case LoanType.property:
        return 'Property';
    }
  }

  Color _getInvestmentColor(InvestmentType type) {
    switch (type) {
      case InvestmentType.stocks:
        return Colors.green;
      case InvestmentType.bonds:
        return Colors.blue;
      case InvestmentType.crypto:
        return Colors.orange;
      case InvestmentType.realEstate:
        return Colors.brown;
    }
  }

  IconData _getInvestmentIcon(InvestmentType type) {
    switch (type) {
      case InvestmentType.stocks:
        return Icons.trending_up;
      case InvestmentType.bonds:
        return Icons.security;
      case InvestmentType.crypto:
        return Icons.currency_bitcoin;
      case InvestmentType.realEstate:
        return Icons.home_work;
    }
  }

  Color _getCreditScoreColor(int score) {
    if (score >= 800) return Colors.green;
    if (score >= 700) return Colors.blue;
    if (score >= 600) return Colors.orange;
    return Colors.red;
  }

  String _getCreditRating(int score) {
    if (score >= 800) return 'Excellent';
    if (score >= 700) return 'Good';
    if (score >= 600) return 'Fair';
    return 'Poor';
  }

  String _formatMoney(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  void _showBankModal(BuildContext context) {
    // TODO: Fix BankModal import issue
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Basic banking operations - use the bank modal from home screen for now'),
        backgroundColor: Colors.blue,
      ),
    );
    /*
    showDialog(
      context: context,
      builder: (context) => const BankModal(),
    );
    */
  }

  void _applyForLoan(LoanOffer loan) {
    // Implement loan application logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Loan application for ${_getLoanTypeName(loan.type)} submitted!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _makeInvestment(Map<String, dynamic> investment) {
    // Implement investment logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Investment in ${investment['name']} initiated!'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
