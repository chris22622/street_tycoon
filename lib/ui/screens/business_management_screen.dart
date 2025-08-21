import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers.dart';
import '../../theme/app_theme.dart';
import '../../util/formatters.dart';
import 'dart:math';

class BusinessManagementScreen extends ConsumerStatefulWidget {
  const BusinessManagementScreen({super.key});

  @override
  ConsumerState<BusinessManagementScreen> createState() => _BusinessManagementScreenState();
}

class _BusinessManagementScreenState extends ConsumerState<BusinessManagementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Random _random = Random();

  // Mock data for business features
  final List<Map<String, dynamic>> stocks = [
    {'name': 'TechCorp', 'symbol': 'TECH', 'price': 150.25, 'change': 2.5, 'owned': 0},
    {'name': 'GreenEnergy', 'symbol': 'GREN', 'price': 89.50, 'change': -1.2, 'owned': 0},
    {'name': 'HealthPlus', 'symbol': 'HLTH', 'price': 203.75, 'change': 4.8, 'owned': 0},
    {'name': 'AutoDrive', 'symbol': 'AUTO', 'price': 98.30, 'change': -0.8, 'owned': 0},
    {'name': 'CloudNet', 'symbol': 'CLND', 'price': 175.60, 'change': 3.2, 'owned': 0},
  ];

  final List<Map<String, dynamic>> cryptos = [
    {'name': 'Bitcoin', 'symbol': 'BTC', 'price': 45000.0, 'change': 5.2, 'owned': 0.0},
    {'name': 'Ethereum', 'symbol': 'ETH', 'price': 3200.0, 'change': -2.1, 'owned': 0.0},
    {'name': 'DarkCoin', 'symbol': 'DARK', 'price': 125.50, 'change': 15.8, 'owned': 0.0},
    {'name': 'StreetCoin', 'symbol': 'STR', 'price': 2.45, 'change': -8.3, 'owned': 0.0},
    {'name': 'AnonymCoin', 'symbol': 'ANON', 'price': 89.30, 'change': 22.1, 'owned': 0.0},
  ];

  final List<Map<String, dynamic>> businesses = [
    {'name': 'Car Wash', 'type': 'Service', 'investment': 50000, 'monthlyProfit': 8000, 'owned': false},
    {'name': 'Laundromat', 'type': 'Service', 'investment': 75000, 'monthlyProfit': 12000, 'owned': false},
    {'name': 'Restaurant', 'type': 'Food', 'investment': 150000, 'monthlyProfit': 25000, 'owned': false},
    {'name': 'Gym', 'type': 'Fitness', 'investment': 100000, 'monthlyProfit': 18000, 'owned': false},
    {'name': 'Tech Startup', 'type': 'Technology', 'investment': 200000, 'monthlyProfit': 35000, 'owned': false},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
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
        title: const Text('Business Empire'),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.accentColor,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.trending_up), text: 'Overview'),
            Tab(icon: Icon(Icons.show_chart), text: 'Stocks'),
            Tab(icon: Icon(Icons.currency_bitcoin), text: 'Crypto'),
            Tab(icon: Icon(Icons.business), text: 'Businesses'),
            Tab(icon: Icon(Icons.account_balance), text: 'Banking'),
            Tab(icon: Icon(Icons.analytics), text: 'Reports'),
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
            _buildOverviewTab(gameState),
            _buildStocksTab(gameState),
            _buildCryptoTab(gameState),
            _buildBusinessesTab(gameState),
            _buildBankingTab(gameState),
            _buildReportsTab(gameState),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab(dynamic gameState) {
    final totalPortfolio = _calculatePortfolioValue();
    final dailyProfit = _calculateDailyProfit();
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Portfolio Overview Card
          Card(
            elevation: 8,
            color: Colors.white10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'Business Portfolio',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard('Total Value', Formatters.money(totalPortfolio), Colors.green),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard('Daily Profit', Formatters.money(dailyProfit), Colors.blue),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard('Owned Businesses', '${_getOwnedBusinesses()}', Colors.orange),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard('Stock Holdings', '${_getStockHoldings()}', Colors.purple),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Quick Actions
          const Text(
            'Quick Actions',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildQuickAction(
                  'Market Analysis',
                  Icons.analytics,
                  Colors.blue,
                  () => _showMarketAnalysis(),
                ),
                _buildQuickAction(
                  'Invest Cash',
                  Icons.attach_money,
                  Colors.green,
                  () => _showInvestmentOptions(),
                ),
                _buildQuickAction(
                  'Collect Profits',
                  Icons.account_balance_wallet,
                  Colors.orange,
                  () => _collectAllProfits(),
                ),
                _buildQuickAction(
                  'Risk Assessment',
                  Icons.security,
                  Colors.red,
                  () => _showRiskAssessment(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStocksTab(dynamic gameState) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Market Status
          Card(
            elevation: 8,
            color: Colors.white10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.show_chart, color: Colors.green, size: 24),
                  const SizedBox(width: 12),
                  const Text(
                    'Stock Market',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'OPEN',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Stocks List
          Expanded(
            child: ListView.builder(
              itemCount: stocks.length,
              itemBuilder: (context, index) {
                final stock = stocks[index];
                return _buildStockCard(stock, gameState);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockCard(Map<String, dynamic> stock, dynamic gameState) {
    final isPositive = stock['change'] >= 0;
    
    return Card(
      elevation: 8,
      color: Colors.white10,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isPositive ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      stock['symbol'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stock['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Owned: ${stock['owned']} shares',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${stock['price'].toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${isPositive ? '+' : ''}${stock['change'].toStringAsFixed(2)}%',
                      style: TextStyle(
                        color: isPositive ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _buyStock(stock, gameState),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Buy'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: stock['owned'] > 0 ? () => _sellStock(stock, gameState) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Sell'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCryptoTab(dynamic gameState) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Crypto Market Header
          Card(
            elevation: 8,
            color: Colors.white10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.currency_bitcoin, color: Colors.orange, size: 24),
                  const SizedBox(width: 12),
                  const Text(
                    'Cryptocurrency Market',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      '24/7',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Crypto List
          Expanded(
            child: ListView.builder(
              itemCount: cryptos.length,
              itemBuilder: (context, index) {
                final crypto = cryptos[index];
                return _buildCryptoCard(crypto, gameState);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCryptoCard(Map<String, dynamic> crypto, dynamic gameState) {
    final isPositive = crypto['change'] >= 0;
    
    return Card(
      elevation: 8,
      color: Colors.white10,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isPositive ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Text(
                      crypto['symbol'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        crypto['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Owned: ${crypto['owned'].toStringAsFixed(4)} ${crypto['symbol']}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${crypto['price'].toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${isPositive ? '+' : ''}${crypto['change'].toStringAsFixed(2)}%',
                      style: TextStyle(
                        color: isPositive ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _buyCrypto(crypto, gameState),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Buy'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: crypto['owned'] > 0 ? () => _sellCrypto(crypto, gameState) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Sell'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessesTab(dynamic gameState) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Business Header
          Card(
            elevation: 8,
            color: Colors.white10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.business, color: Colors.blue, size: 24),
                  const SizedBox(width: 12),
                  const Text(
                    'Legitimate Businesses',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Business List
          Expanded(
            child: ListView.builder(
              itemCount: businesses.length,
              itemBuilder: (context, index) {
                final business = businesses[index];
                return _buildBusinessCard(business, gameState);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessCard(Map<String, dynamic> business, dynamic gameState) {
    final monthlyROI = (business['monthlyProfit'] / business['investment'] * 100);
    
    return Card(
      elevation: 8,
      color: Colors.white10,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: business['owned'] ? Colors.green : Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.business, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        business['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        business['type'],
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                if (business['owned'])
                  const Icon(Icons.check_circle, color: Colors.green, size: 24),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Investment: ${Formatters.money(business['investment'])}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      Text(
                        'Monthly Profit: ${Formatters.money(business['monthlyProfit'])}',
                        style: const TextStyle(color: Colors.green),
                      ),
                      Text(
                        'ROI: ${monthlyROI.toStringAsFixed(1)}%/month',
                        style: const TextStyle(color: Colors.orange),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: !business['owned'] ? () => _buyBusiness(business, gameState) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: business['owned'] ? Colors.grey : Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: Text(business['owned'] ? 'Owned' : 'Buy'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankingTab(dynamic gameState) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Bank Account Overview
          Card(
            elevation: 8,
            color: Colors.white10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'Banking Services',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildBankStat('Bank Balance', Formatters.money(gameState.bank), Colors.blue),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildBankStat('Cash on Hand', Formatters.money(gameState.cash), Colors.green),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Banking Actions
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildBankAction(
                  'Deposit Cash',
                  Icons.file_upload,
                  Colors.green,
                  () => _showDepositDialog(gameState),
                ),
                _buildBankAction(
                  'Withdraw Cash',
                  Icons.file_download,
                  Colors.orange,
                  () => _showWithdrawDialog(gameState),
                ),
                _buildBankAction(
                  'Take Loan',
                  Icons.request_quote,
                  Colors.red,
                  () => _showLoanDialog(gameState),
                ),
                _buildBankAction(
                  'Pay Bills',
                  Icons.receipt_long,
                  Colors.purple,
                  () => _payBills(gameState),
                ),
                _buildBankAction(
                  'Money Laundering',
                  Icons.local_laundry_service,
                  Colors.grey,
                  () => _showLaunderingDialog(gameState),
                ),
                _buildBankAction(
                  'Offshore Account',
                  Icons.account_balance,
                  Colors.blue,
                  () => _showOffshoreDialog(gameState),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsTab(dynamic gameState) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          // Financial Summary
          Card(
            elevation: 8,
            color: Colors.white10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Financial Reports',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildReportItem('Total Assets', Formatters.money(_calculateTotalAssets(gameState))),
                  _buildReportItem('Daily Income', Formatters.money(_calculateDailyProfit())),
                  _buildReportItem('Monthly Projection', Formatters.money(_calculateDailyProfit() * 30)),
                  _buildReportItem('Investment Portfolio', Formatters.money(_calculatePortfolioValue())),
                  _buildReportItem('Business Revenue', Formatters.money(_calculateBusinessRevenue())),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Performance Metrics
          Card(
            elevation: 8,
            color: Colors.white10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Performance Metrics',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildMetricBar('Portfolio Growth', 0.75, Colors.green),
                  _buildMetricBar('Risk Level', 0.45, Colors.orange),
                  _buildMetricBar('Diversification', 0.60, Colors.blue),
                  _buildMetricBar('Liquidity Ratio', 0.85, Colors.purple),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widgets
  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(String title, IconData icon, Color color, VoidCallback onTap) {
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

  Widget _buildBankStat(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBankAction(String title, IconData icon, Color color, VoidCallback onTap) {
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

  Widget _buildReportItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricBar(String label, double value, Color color) {
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
                '${(value * 100).toStringAsFixed(0)}%',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: value,
            backgroundColor: Colors.white24,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }

  // Action Methods
  void _buyStock(Map<String, dynamic> stock, dynamic gameState) {
    _showBuyDialog('stock', stock, gameState);
  }

  void _sellStock(Map<String, dynamic> stock, dynamic gameState) {
    _showSellDialog('stock', stock, gameState);
  }

  void _buyCrypto(Map<String, dynamic> crypto, dynamic gameState) {
    _showBuyDialog('crypto', crypto, gameState);
  }

  void _sellCrypto(Map<String, dynamic> crypto, dynamic gameState) {
    _showSellDialog('crypto', crypto, gameState);
  }

  void _buyBusiness(Map<String, dynamic> business, dynamic gameState) {
    final gameController = ref.read(gameControllerProvider.notifier);
    final cost = business['investment'] as int;
    
    if (gameState.cash >= cost) {
      gameController.spendCash(cost);
      setState(() {
        business['owned'] = true;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully purchased ${business['name']}!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not enough cash to purchase this business!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showBuyDialog(String type, Map<String, dynamic> item, dynamic gameState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Buy ${item['name']}',
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Current Price: \$${item['price'].toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: type == 'stock' ? 'Number of shares' : 'Amount to buy',
                labelStyle: const TextStyle(color: Colors.white70),
                border: const OutlineInputBorder(),
              ),
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Implement buy logic
              _executeBuy(type, item, 1, gameState);
            },
            child: const Text('Buy'),
          ),
        ],
      ),
    );
  }

  void _showSellDialog(String type, Map<String, dynamic> item, dynamic gameState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Sell ${item['name']}',
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Current Price: \$${item['price'].toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.white70),
            ),
            Text(
              'Owned: ${item['owned']}',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: type == 'stock' ? 'Number of shares' : 'Amount to sell',
                labelStyle: const TextStyle(color: Colors.white70),
                border: const OutlineInputBorder(),
              ),
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Implement sell logic
              _executeSell(type, item, 1, gameState);
            },
            child: const Text('Sell'),
          ),
        ],
      ),
    );
  }

  void _executeBuy(String type, Map<String, dynamic> item, int quantity, dynamic gameState) {
    final gameController = ref.read(gameControllerProvider.notifier);
    final cost = (item['price'] * quantity).round();
    
    if (gameState.cash >= cost) {
      gameController.spendCash(cost);
      setState(() {
        if (type == 'stock') {
          item['owned'] += quantity;
        } else {
          item['owned'] += quantity / item['price'];
        }
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully bought ${item['name']}!'),
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

  void _executeSell(String type, Map<String, dynamic> item, int quantity, dynamic gameState) {
    final gameController = ref.read(gameControllerProvider.notifier);
    final revenue = (item['price'] * quantity).round();
    
    if ((type == 'stock' && item['owned'] >= quantity) || 
        (type == 'crypto' && item['owned'] >= quantity / item['price'])) {
      gameController.addLegitimateIncome(revenue, 'Investment sale');
      setState(() {
        if (type == 'stock') {
          item['owned'] -= quantity;
        } else {
          item['owned'] -= quantity / item['price'];
        }
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully sold ${item['name']}!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not enough holdings to sell!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Calculation methods
  int _calculatePortfolioValue() {
    int total = 0;
    for (var stock in stocks) {
      total += ((stock['price'] as double) * (stock['owned'] as int)).round().toInt();
    }
    for (var crypto in cryptos) {
      total += ((crypto['price'] as double) * (crypto['owned'] as double)).round().toInt();
    }
    return total;
  }

  int _calculateDailyProfit() {
    int profit = 0;
    for (var business in businesses) {
      if (business['owned']) {
        profit += ((business['monthlyProfit'] as int) / 30).round().toInt();
      }
    }
    return profit;
  }

  int _getOwnedBusinesses() {
    return businesses.where((b) => b['owned']).length;
  }

  int _getStockHoldings() {
    return stocks.where((s) => s['owned'] > 0).length;
  }

  int _calculateTotalAssets(dynamic gameState) {
    return gameState.cash + gameState.bank + _calculatePortfolioValue();
  }

  int _calculateBusinessRevenue() {
    int revenue = 0;
    for (var business in businesses) {
      if (business['owned']) {
        revenue += business['monthlyProfit'] as int;
      }
    }
    return revenue;
  }

  // Dialog methods
  void _showDepositDialog(dynamic gameState) {
    // Implementation for deposit dialog
  }

  void _showWithdrawDialog(dynamic gameState) {
    // Implementation for withdraw dialog
  }

  void _showLoanDialog(dynamic gameState) {
    // Implementation for loan dialog
  }

  void _payBills(dynamic gameState) {
    // Implementation for paying bills
  }

  void _showLaunderingDialog(dynamic gameState) {
    // Implementation for money laundering dialog
  }

  void _showOffshoreDialog(dynamic gameState) {
    // Implementation for offshore account dialog
  }

  void _showMarketAnalysis() {
    // Implementation for market analysis
  }

  void _showInvestmentOptions() {
    // Implementation for investment options
  }

  void _collectAllProfits() {
    final gameController = ref.read(gameControllerProvider.notifier);
    final totalProfit = _calculateDailyProfit();
    
    if (totalProfit > 0) {
      gameController.addLegitimateIncome(totalProfit, 'Business profits');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Collected ${Formatters.money(totalProfit)} in profits!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No profits to collect yet!'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _showRiskAssessment() {
    // Implementation for risk assessment
  }
}
