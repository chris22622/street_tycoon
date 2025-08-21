import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

// Advanced Cryptocurrency Empire System
// Feature #24: Ultra-comprehensive digital currency operations with
// cryptocurrency mining, trading, blockchain development, and digital empire expansion

enum CryptoCurrency {
  bitcoin,
  ethereum,
  litecoin,
  monero,
  darkCoin,
  streetCoin,
  empireToken,
  launderCoin
}

enum MiningType {
  cpu,
  gpu,
  asic,
  cloudMining,
  stealthMining,
  boilerRoom
}

enum TradingStrategy {
  buyAndHold,
  dayTrading,
  arbitrage,
  pumpAndDump,
  washTrading,
  marketManipulation
}

enum ExchangeType {
  centralized,
  decentralized,
  darkWeb,
  privateExchange
}

class CryptoAsset {
  final String id;
  final CryptoCurrency currency;
  final double amount;
  final double averageBuyPrice;
  final double currentPrice;
  final DateTime lastUpdated;
  final bool isStolen;
  final String sourceWallet;

  CryptoAsset({
    required this.id,
    required this.currency,
    required this.amount,
    required this.averageBuyPrice,
    required this.currentPrice,
    required this.lastUpdated,
    this.isStolen = false,
    this.sourceWallet = '',
  });

  CryptoAsset copyWith({
    String? id,
    CryptoCurrency? currency,
    double? amount,
    double? averageBuyPrice,
    double? currentPrice,
    DateTime? lastUpdated,
    bool? isStolen,
    String? sourceWallet,
  }) {
    return CryptoAsset(
      id: id ?? this.id,
      currency: currency ?? this.currency,
      amount: amount ?? this.amount,
      averageBuyPrice: averageBuyPrice ?? this.averageBuyPrice,
      currentPrice: currentPrice ?? this.currentPrice,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isStolen: isStolen ?? this.isStolen,
      sourceWallet: sourceWallet ?? this.sourceWallet,
    );
  }

  double get totalValue => amount * currentPrice;
  double get totalInvestment => amount * averageBuyPrice;
  double get profitLoss => totalValue - totalInvestment;
  double get roi => totalInvestment > 0 ? profitLoss / totalInvestment : 0.0;
}

class MiningRig {
  final String id;
  final String name;
  final MiningType type;
  final double hashRate;
  final double powerConsumption;
  final double purchasePrice;
  final DateTime purchaseDate;
  final CryptoCurrency targetCurrency;
  final bool isActive;
  final double efficiency;

  MiningRig({
    required this.id,
    required this.name,
    required this.type,
    required this.hashRate,
    required this.powerConsumption,
    required this.purchasePrice,
    required this.purchaseDate,
    required this.targetCurrency,
    this.isActive = true,
    this.efficiency = 1.0,
  });

  MiningRig copyWith({
    String? id,
    String? name,
    MiningType? type,
    double? hashRate,
    double? powerConsumption,
    double? purchasePrice,
    DateTime? purchaseDate,
    CryptoCurrency? targetCurrency,
    bool? isActive,
    double? efficiency,
  }) {
    return MiningRig(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      hashRate: hashRate ?? this.hashRate,
      powerConsumption: powerConsumption ?? this.powerConsumption,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      targetCurrency: targetCurrency ?? this.targetCurrency,
      isActive: isActive ?? this.isActive,
      efficiency: efficiency ?? this.efficiency,
    );
  }

  double get dailyRevenue {
    if (!isActive) return 0.0;
    
    // Simplified mining calculation
    final baseRate = hashRate * efficiency;
    switch (targetCurrency) {
      case CryptoCurrency.bitcoin:
        return baseRate * 0.00001 * 50000; // Approximate BTC mining
      case CryptoCurrency.ethereum:
        return baseRate * 0.0001 * 3000;
      case CryptoCurrency.monero:
        return baseRate * 0.001 * 150;
      case CryptoCurrency.darkCoin:
        return baseRate * 0.01 * 50; // Higher yield for dark operations
      default:
        return baseRate * 0.0005 * 1000;
    }
  }

  double get dailyCost => powerConsumption * 24 * 0.12; // $0.12 per kWh
  double get dailyProfit => dailyRevenue - dailyCost;
}

class CryptoExchange {
  final String id;
  final String name;
  final ExchangeType type;
  final double tradingFee;
  final List<CryptoCurrency> supportedCurrencies;
  final double reputation;
  final bool requiresKYC;
  final double dailyVolume;

  CryptoExchange({
    required this.id,
    required this.name,
    required this.type,
    this.tradingFee = 0.001,
    required this.supportedCurrencies,
    this.reputation = 0.5,
    this.requiresKYC = true,
    this.dailyVolume = 1000000,
  });
}

class TradingBot {
  final String id;
  final String name;
  final TradingStrategy strategy;
  final CryptoCurrency targetCurrency;
  final double buyThreshold;
  final double sellThreshold;
  final double maxTradeAmount;
  final bool isActive;
  final double successRate;

  TradingBot({
    required this.id,
    required this.name,
    required this.strategy,
    required this.targetCurrency,
    this.buyThreshold = 0.95,
    this.sellThreshold = 1.05,
    this.maxTradeAmount = 10000,
    this.isActive = true,
    this.successRate = 0.6,
  });

  TradingBot copyWith({
    String? id,
    String? name,
    TradingStrategy? strategy,
    CryptoCurrency? targetCurrency,
    double? buyThreshold,
    double? sellThreshold,
    double? maxTradeAmount,
    bool? isActive,
    double? successRate,
  }) {
    return TradingBot(
      id: id ?? this.id,
      name: name ?? this.name,
      strategy: strategy ?? this.strategy,
      targetCurrency: targetCurrency ?? this.targetCurrency,
      buyThreshold: buyThreshold ?? this.buyThreshold,
      sellThreshold: sellThreshold ?? this.sellThreshold,
      maxTradeAmount: maxTradeAmount ?? this.maxTradeAmount,
      isActive: isActive ?? this.isActive,
      successRate: successRate ?? this.successRate,
    );
  }
}

class CryptoTransaction {
  final String id;
  final CryptoCurrency currency;
  final String type; // buy, sell, mine, steal, launder
  final double amount;
  final double price;
  final DateTime timestamp;
  final String? exchangeId;
  final bool isIllegal;

  CryptoTransaction({
    required this.id,
    required this.currency,
    required this.type,
    required this.amount,
    required this.price,
    required this.timestamp,
    this.exchangeId,
    this.isIllegal = false,
  });

  double get totalValue => amount * price;
}

class AdvancedCryptocurrencySystem extends ChangeNotifier {
  static final AdvancedCryptocurrencySystem _instance = AdvancedCryptocurrencySystem._internal();
  factory AdvancedCryptocurrencySystem() => _instance;
  AdvancedCryptocurrencySystem._internal() {
    _initializeSystem();
  }

  final Map<String, CryptoAsset> _portfolio = {};
  final Map<String, MiningRig> _miningRigs = {};
  final Map<String, CryptoExchange> _exchanges = {};
  final Map<String, TradingBot> _tradingBots = {};
  final Map<String, CryptoTransaction> _transactions = {};
  final Map<CryptoCurrency, double> _cryptoPrices = {};
  
  String? _playerId;
  double _totalPortfolioValue = 0.0;
  double _dailyMiningRevenue = 0.0;
  double _totalTradingProfit = 0.0;
  int _totalTransactions = 0;
  double _blockchainReputation = 0.5;
  
  Timer? _systemTimer;
  Timer? _priceTimer;
  final math.Random _random = math.Random();

  // Getters
  Map<String, CryptoAsset> get portfolio => Map.unmodifiable(_portfolio);
  Map<String, MiningRig> get miningRigs => Map.unmodifiable(_miningRigs);
  Map<String, CryptoExchange> get exchanges => Map.unmodifiable(_exchanges);
  Map<String, TradingBot> get tradingBots => Map.unmodifiable(_tradingBots);
  Map<String, CryptoTransaction> get transactions => Map.unmodifiable(_transactions);
  Map<CryptoCurrency, double> get cryptoPrices => Map.unmodifiable(_cryptoPrices);
  String? get playerId => _playerId;
  double get totalPortfolioValue => _totalPortfolioValue;
  double get dailyMiningRevenue => _dailyMiningRevenue;
  double get totalTradingProfit => _totalTradingProfit;
  int get totalTransactions => _totalTransactions;
  double get blockchainReputation => _blockchainReputation;

  void _initializeSystem() {
    _playerId = 'crypto_${DateTime.now().millisecondsSinceEpoch}';
    _initializeCryptoPrices();
    _initializeExchanges();
    _startSystemTimers();
  }

  void _initializeCryptoPrices() {
    _cryptoPrices[CryptoCurrency.bitcoin] = 45000.0;
    _cryptoPrices[CryptoCurrency.ethereum] = 3000.0;
    _cryptoPrices[CryptoCurrency.litecoin] = 180.0;
    _cryptoPrices[CryptoCurrency.monero] = 150.0;
    _cryptoPrices[CryptoCurrency.darkCoin] = 75.0;
    _cryptoPrices[CryptoCurrency.streetCoin] = 12.0;
    _cryptoPrices[CryptoCurrency.empireToken] = 5.0;
    _cryptoPrices[CryptoCurrency.launderCoin] = 25.0;
  }

  void _initializeExchanges() {
    _exchanges['binance'] = CryptoExchange(
      id: 'binance',
      name: 'Binance',
      type: ExchangeType.centralized,
      tradingFee: 0.001,
      supportedCurrencies: [
        CryptoCurrency.bitcoin,
        CryptoCurrency.ethereum,
        CryptoCurrency.litecoin,
      ],
      reputation: 0.9,
      requiresKYC: true,
      dailyVolume: 15000000000,
    );

    _exchanges['uniswap'] = CryptoExchange(
      id: 'uniswap',
      name: 'Uniswap',
      type: ExchangeType.decentralized,
      tradingFee: 0.003,
      supportedCurrencies: [
        CryptoCurrency.ethereum,
        CryptoCurrency.empireToken,
      ],
      reputation: 0.8,
      requiresKYC: false,
      dailyVolume: 2000000000,
    );

    _exchanges['darkmarket'] = CryptoExchange(
      id: 'darkmarket',
      name: 'Shadow Exchange',
      type: ExchangeType.darkWeb,
      tradingFee: 0.005,
      supportedCurrencies: [
        CryptoCurrency.monero,
        CryptoCurrency.darkCoin,
        CryptoCurrency.launderCoin,
      ],
      reputation: 0.4,
      requiresKYC: false,
      dailyVolume: 50000000,
    );
  }

  void _startSystemTimers() {
    _systemTimer?.cancel();
    _priceTimer?.cancel();
    
    _systemTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _processMining();
      _processTradingBots();
      _updatePortfolioValue();
      notifyListeners();
    });
    
    _priceTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _updateCryptoPrices();
      notifyListeners();
    });
  }

  // Mining Operations
  String purchaseMiningRig(String name, MiningType type, CryptoCurrency targetCurrency) {
    final rigId = 'rig_${DateTime.now().millisecondsSinceEpoch}';
    
    double hashRate = 0;
    double powerConsumption = 0;
    double price = 0;
    
    switch (type) {
      case MiningType.cpu:
        hashRate = 1000;
        powerConsumption = 0.1;
        price = 500;
        break;
      case MiningType.gpu:
        hashRate = 50000;
        powerConsumption = 0.3;
        price = 2000;
        break;
      case MiningType.asic:
        hashRate = 1000000;
        powerConsumption = 1.5;
        price = 15000;
        break;
      case MiningType.cloudMining:
        hashRate = 500000;
        powerConsumption = 0;
        price = 8000;
        break;
      case MiningType.stealthMining:
        hashRate = 200000;
        powerConsumption = 0.2;
        price = 5000;
        break;
      case MiningType.boilerRoom:
        hashRate = 2000000;
        powerConsumption = 3.0;
        price = 50000;
        break;
    }
    
    _miningRigs[rigId] = MiningRig(
      id: rigId,
      name: name,
      type: type,
      hashRate: hashRate,
      powerConsumption: powerConsumption,
      purchasePrice: price,
      purchaseDate: DateTime.now(),
      targetCurrency: targetCurrency,
    );
    
    return rigId;
  }

  void _processMining() {
    _dailyMiningRevenue = 0;
    
    for (final rig in _miningRigs.values) {
      if (!rig.isActive) continue;
      
      final dailyProfit = rig.dailyProfit;
      _dailyMiningRevenue += dailyProfit;
      
      // Add mined coins to portfolio
      final minedAmount = rig.dailyRevenue / (_cryptoPrices[rig.targetCurrency] ?? 1);
      _addToPortfolio(rig.targetCurrency, minedAmount / 24, _cryptoPrices[rig.targetCurrency]!);
      
      // Record mining transaction
      final transactionId = 'mine_${DateTime.now().millisecondsSinceEpoch}';
      _transactions[transactionId] = CryptoTransaction(
        id: transactionId,
        currency: rig.targetCurrency,
        type: 'mine',
        amount: minedAmount / 24,
        price: _cryptoPrices[rig.targetCurrency]!,
        timestamp: DateTime.now(),
      );
    }
  }

  // Trading Operations
  String createTradingBot(String name, TradingStrategy strategy, CryptoCurrency targetCurrency) {
    final botId = 'bot_${DateTime.now().millisecondsSinceEpoch}';
    
    double successRate = 0.6;
    double buyThreshold = 0.95;
    double sellThreshold = 1.05;
    
    switch (strategy) {
      case TradingStrategy.buyAndHold:
        successRate = 0.8;
        buyThreshold = 0.9;
        sellThreshold = 1.2;
        break;
      case TradingStrategy.dayTrading:
        successRate = 0.55;
        buyThreshold = 0.98;
        sellThreshold = 1.02;
        break;
      case TradingStrategy.arbitrage:
        successRate = 0.85;
        buyThreshold = 0.995;
        sellThreshold = 1.005;
        break;
      case TradingStrategy.pumpAndDump:
        successRate = 0.7;
        buyThreshold = 0.95;
        sellThreshold = 1.15;
        break;
      case TradingStrategy.washTrading:
        successRate = 0.9;
        buyThreshold = 0.99;
        sellThreshold = 1.01;
        break;
      case TradingStrategy.marketManipulation:
        successRate = 0.95;
        buyThreshold = 0.9;
        sellThreshold = 1.3;
        break;
    }
    
    _tradingBots[botId] = TradingBot(
      id: botId,
      name: name,
      strategy: strategy,
      targetCurrency: targetCurrency,
      buyThreshold: buyThreshold,
      sellThreshold: sellThreshold,
      successRate: successRate,
    );
    
    return botId;
  }

  void _processTradingBots() {
    for (final bot in _tradingBots.values) {
      if (!bot.isActive) continue;
      
      final currentPrice = _cryptoPrices[bot.targetCurrency] ?? 0;
      final asset = _portfolio.values
          .where((a) => a.currency == bot.targetCurrency)
          .firstOrNull;
      
      if (asset != null && currentPrice > 0) {
        final priceRatio = currentPrice / asset.averageBuyPrice;
        
        // Trading logic
        if (_random.nextDouble() < 0.1) { // 10% chance per cycle
          if (priceRatio >= bot.sellThreshold && asset.amount > 0) {
            // Sell signal
            final sellAmount = math.min(asset.amount * 0.1, bot.maxTradeAmount / currentPrice);
            if (_random.nextDouble() < bot.successRate) {
              _sellCrypto(bot.targetCurrency, sellAmount, currentPrice);
            }
          } else if (priceRatio <= bot.buyThreshold) {
            // Buy signal
            final buyAmount = math.min(bot.maxTradeAmount / currentPrice, 1.0);
            if (_random.nextDouble() < bot.successRate) {
              _buyCrypto(bot.targetCurrency, buyAmount, currentPrice);
            }
          }
        }
      }
    }
  }

  // Portfolio Management
  void _addToPortfolio(CryptoCurrency currency, double amount, double price) {
    final existingAsset = _portfolio.values
        .where((a) => a.currency == currency)
        .firstOrNull;
    
    if (existingAsset != null) {
      final totalAmount = existingAsset.amount + amount;
      final totalCost = (existingAsset.amount * existingAsset.averageBuyPrice) + (amount * price);
      final newAveragePrice = totalCost / totalAmount;
      
      _portfolio[existingAsset.id] = existingAsset.copyWith(
        amount: totalAmount,
        averageBuyPrice: newAveragePrice,
        currentPrice: price,
        lastUpdated: DateTime.now(),
      );
    } else {
      final assetId = 'asset_${DateTime.now().millisecondsSinceEpoch}';
      _portfolio[assetId] = CryptoAsset(
        id: assetId,
        currency: currency,
        amount: amount,
        averageBuyPrice: price,
        currentPrice: price,
        lastUpdated: DateTime.now(),
      );
    }
  }

  void _buyCrypto(CryptoCurrency currency, double amount, double price) {
    _addToPortfolio(currency, amount, price);
    
    final transactionId = 'buy_${DateTime.now().millisecondsSinceEpoch}';
    _transactions[transactionId] = CryptoTransaction(
      id: transactionId,
      currency: currency,
      type: 'buy',
      amount: amount,
      price: price,
      timestamp: DateTime.now(),
    );
    
    _totalTransactions++;
  }

  void _sellCrypto(CryptoCurrency currency, double amount, double price) {
    final asset = _portfolio.values
        .where((a) => a.currency == currency)
        .firstOrNull;
    
    if (asset != null && asset.amount >= amount) {
      final profit = (price - asset.averageBuyPrice) * amount;
      _totalTradingProfit += profit;
      
      _portfolio[asset.id] = asset.copyWith(
        amount: asset.amount - amount,
        currentPrice: price,
        lastUpdated: DateTime.now(),
      );
      
      final transactionId = 'sell_${DateTime.now().millisecondsSinceEpoch}';
      _transactions[transactionId] = CryptoTransaction(
        id: transactionId,
        currency: currency,
        type: 'sell',
        amount: amount,
        price: price,
        timestamp: DateTime.now(),
      );
      
      _totalTransactions++;
    }
  }

  // Dark Operations
  void stealCrypto(CryptoCurrency currency, double amount) {
    final currentPrice = _cryptoPrices[currency] ?? 0;
    
    final assetId = 'stolen_${DateTime.now().millisecondsSinceEpoch}';
    _portfolio[assetId] = CryptoAsset(
      id: assetId,
      currency: currency,
      amount: amount,
      averageBuyPrice: 0, // Stolen - no cost
      currentPrice: currentPrice,
      lastUpdated: DateTime.now(),
      isStolen: true,
      sourceWallet: 'victim_wallet_${_random.nextInt(1000)}',
    );
    
    final transactionId = 'steal_${DateTime.now().millisecondsSinceEpoch}';
    _transactions[transactionId] = CryptoTransaction(
      id: transactionId,
      currency: currency,
      type: 'steal',
      amount: amount,
      price: currentPrice,
      timestamp: DateTime.now(),
      isIllegal: true,
    );
    
    // Stealing reduces blockchain reputation
    _blockchainReputation = (_blockchainReputation - 0.05).clamp(0.0, 1.0);
  }

  void launderCrypto(String assetId, CryptoCurrency targetCurrency) {
    final asset = _portfolio[assetId];
    if (asset == null || !asset.isStolen) return;
    
    // Convert stolen crypto to launderCoin
    final launderAmount = asset.amount * 0.8; // 20% laundering fee
    final currentPrice = _cryptoPrices[targetCurrency] ?? 0;
    
    _portfolio.remove(assetId);
    
    final launderedAssetId = 'clean_${DateTime.now().millisecondsSinceEpoch}';
    _portfolio[launderedAssetId] = CryptoAsset(
      id: launderedAssetId,
      currency: targetCurrency,
      amount: launderAmount,
      averageBuyPrice: currentPrice,
      currentPrice: currentPrice,
      lastUpdated: DateTime.now(),
      isStolen: false,
    );
    
    final transactionId = 'launder_${DateTime.now().millisecondsSinceEpoch}';
    _transactions[transactionId] = CryptoTransaction(
      id: transactionId,
      currency: targetCurrency,
      type: 'launder',
      amount: launderAmount,
      price: currentPrice,
      timestamp: DateTime.now(),
      isIllegal: true,
    );
  }

  // Market Manipulation
  void manipulateMarket(CryptoCurrency currency, bool pumpPrice) {
    final currentPrice = _cryptoPrices[currency] ?? 0;
    final manipulationFactor = pumpPrice ? 1.1 + _random.nextDouble() * 0.2 : 0.8 - _random.nextDouble() * 0.2;
    
    _cryptoPrices[currency] = currentPrice * manipulationFactor;
    
    // Market manipulation is risky and reduces reputation
    _blockchainReputation = (_blockchainReputation - 0.03).clamp(0.0, 1.0);
  }

  // System Updates
  void _updateCryptoPrices() {
    for (final currency in _cryptoPrices.keys) {
      final currentPrice = _cryptoPrices[currency]!;
      final volatility = _getCurrencyVolatility(currency);
      final change = 1.0 + ((_random.nextDouble() - 0.5) * volatility);
      
      _cryptoPrices[currency] = (currentPrice * change).clamp(currentPrice * 0.5, currentPrice * 2.0);
    }
    
    // Update portfolio prices
    for (final assetId in _portfolio.keys) {
      final asset = _portfolio[assetId]!;
      _portfolio[assetId] = asset.copyWith(
        currentPrice: _cryptoPrices[asset.currency]!,
        lastUpdated: DateTime.now(),
      );
    }
  }

  double _getCurrencyVolatility(CryptoCurrency currency) {
    switch (currency) {
      case CryptoCurrency.bitcoin:
        return 0.02;
      case CryptoCurrency.ethereum:
        return 0.03;
      case CryptoCurrency.litecoin:
        return 0.04;
      case CryptoCurrency.monero:
        return 0.05;
      case CryptoCurrency.darkCoin:
        return 0.08;
      case CryptoCurrency.streetCoin:
        return 0.12;
      case CryptoCurrency.empireToken:
        return 0.15;
      case CryptoCurrency.launderCoin:
        return 0.10;
    }
  }

  void _updatePortfolioValue() {
    _totalPortfolioValue = _portfolio.values.fold(0.0, (sum, asset) => sum + asset.totalValue);
  }

  // Public Interface Methods
  List<CryptoAsset> getPortfolioAssets() {
    return _portfolio.values.toList()
      ..sort((a, b) => b.totalValue.compareTo(a.totalValue));
  }

  List<MiningRig> getActiveMiningRigs() {
    return _miningRigs.values.where((rig) => rig.isActive).toList()
      ..sort((a, b) => b.dailyProfit.compareTo(a.dailyProfit));
  }

  List<TradingBot> getActiveTradingBots() {
    return _tradingBots.values.where((bot) => bot.isActive).toList()
      ..sort((a, b) => b.successRate.compareTo(a.successRate));
  }

  List<CryptoTransaction> getRecentTransactions({int limit = 20}) {
    return _transactions.values.toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp))
      ..take(limit);
  }

  List<CryptoAsset> getStolenAssets() {
    return _portfolio.values.where((asset) => asset.isStolen).toList();
  }

  double getTotalMiningPower() {
    return _miningRigs.values
        .where((rig) => rig.isActive)
        .fold(0.0, (sum, rig) => sum + rig.hashRate);
  }

  double getPortfolioROI() {
    double totalInvestment = 0;
    double totalValue = 0;
    
    for (final asset in _portfolio.values) {
      if (!asset.isStolen) {
        totalInvestment += asset.totalInvestment;
        totalValue += asset.totalValue;
      }
    }
    
    return totalInvestment > 0 ? (totalValue - totalInvestment) / totalInvestment : 0.0;
  }

  void dispose() {
    _systemTimer?.cancel();
    _priceTimer?.cancel();
    super.dispose();
  }
}

// Advanced Cryptocurrency Dashboard Widget
class AdvancedCryptocurrencyDashboardWidget extends StatefulWidget {
  const AdvancedCryptocurrencyDashboardWidget({super.key});

  @override
  State<AdvancedCryptocurrencyDashboardWidget> createState() => _AdvancedCryptocurrencyDashboardWidgetState();
}

class _AdvancedCryptocurrencyDashboardWidgetState extends State<AdvancedCryptocurrencyDashboardWidget>
    with TickerProviderStateMixin {
  final AdvancedCryptocurrencySystem _cryptoSystem = AdvancedCryptocurrencySystem();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _cryptoSystem,
      builder: (context, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                _buildPortfolioMetrics(),
                const SizedBox(height: 16),
                _buildTabBar(),
                const SizedBox(height: 16),
                Expanded(child: _buildTabBarView()),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Icon(Icons.currency_bitcoin, color: Colors.orange),
        const SizedBox(width: 8),
        const Text(
          'Crypto Empire',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Text('Portfolio: \$${(_cryptoSystem.totalPortfolioValue / 1000).toStringAsFixed(1)}K'),
      ],
    );
  }

  Widget _buildPortfolioMetrics() {
    return Card(
      color: Colors.orange[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                _buildMetricCard('Total Value', '\$${_cryptoSystem.totalPortfolioValue.toInt()}'),
                _buildMetricCard('Daily Mining', '\$${_cryptoSystem.dailyMiningRevenue.toInt()}'),
                _buildMetricCard('Trading Profit', '\$${_cryptoSystem.totalTradingProfit.toInt()}'),
                _buildMetricCard('ROI', '${(_cryptoSystem.getPortfolioROI() * 100).toStringAsFixed(1)}%'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Blockchain Reputation', style: TextStyle(fontWeight: FontWeight.bold)),
                      LinearProgressIndicator(
                        value: _cryptoSystem.blockchainReputation,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _cryptoSystem.blockchainReputation > 0.6 ? Colors.green : Colors.red,
                        ),
                      ),
                      Text('${(_cryptoSystem.blockchainReputation * 100).toInt()}%'),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Mining Power', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${(_cryptoSystem.getTotalMiningPower() / 1000000).toStringAsFixed(1)}M H/s'),
                      Text('${_cryptoSystem.getActiveMiningRigs().length} Rigs Active'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String label, String value) {
    return Expanded(
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(label, style: const TextStyle(fontSize: 12)),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      tabs: const [
        Tab(text: 'Portfolio', icon: Icon(Icons.account_balance_wallet)),
        Tab(text: 'Mining', icon: Icon(Icons.memory)),
        Tab(text: 'Trading', icon: Icon(Icons.trending_up)),
        Tab(text: 'Dark Ops', icon: Icon(Icons.security)),
        Tab(text: 'Prices', icon: Icon(Icons.show_chart)),
      ],
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildPortfolioTab(),
        _buildMiningTab(),
        _buildTradingTab(),
        _buildDarkOpsTab(),
        _buildPricesTab(),
      ],
    );
  }

  Widget _buildPortfolioTab() {
    final assets = _cryptoSystem.getPortfolioAssets();
    
    return ListView.builder(
      itemCount: assets.length,
      itemBuilder: (context, index) {
        final asset = assets[index];
        return _buildAssetCard(asset);
      },
    );
  }

  Widget _buildAssetCard(CryptoAsset asset) {
    return Card(
      color: asset.isStolen ? Colors.red[50] : null,
      child: ListTile(
        leading: Icon(
          _getCurrencyIcon(asset.currency),
          color: _getCurrencyColor(asset.currency),
        ),
        title: Text('${asset.currency.name} ${asset.isStolen ? '(STOLEN)' : ''}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Amount: ${asset.amount.toStringAsFixed(6)}'),
            Text('Value: \$${asset.totalValue.toStringAsFixed(2)}'),
            Text('P&L: \$${asset.profitLoss.toStringAsFixed(2)} (${(asset.roi * 100).toStringAsFixed(1)}%)'),
          ],
        ),
        trailing: asset.isStolen 
          ? ElevatedButton(
              onPressed: () => _showLaunderDialog(asset),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Launder'),
            )
          : null,
        isThreeLine: true,
      ),
    );
  }

  Widget _buildMiningTab() {
    final rigs = _cryptoSystem.getActiveMiningRigs();
    
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _showPurchaseRigDialog,
                    child: const Text('Purchase Mining Rig'),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: rigs.length,
            itemBuilder: (context, index) {
              final rig = rigs[index];
              return _buildMiningRigCard(rig);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMiningRigCard(MiningRig rig) {
    return Card(
      child: ListTile(
        leading: Icon(
          _getMiningTypeIcon(rig.type),
          color: _getMiningTypeColor(rig.type),
        ),
        title: Text(rig.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${rig.type.name} - Target: ${rig.targetCurrency.name}'),
            Text('Hash Rate: ${(rig.hashRate / 1000).toStringAsFixed(1)}K H/s'),
            Text('Daily Profit: \$${rig.dailyProfit.toStringAsFixed(2)}'),
            Text('Power: ${rig.powerConsumption.toStringAsFixed(1)} kW'),
          ],
        ),
        trailing: Switch(
          value: rig.isActive,
          onChanged: (value) => _toggleMiningRig(rig.id, value),
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildTradingTab() {
    final bots = _cryptoSystem.getActiveTradingBots();
    
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _showCreateBotDialog,
                    child: const Text('Create Trading Bot'),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: bots.length,
            itemBuilder: (context, index) {
              final bot = bots[index];
              return _buildTradingBotCard(bot);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTradingBotCard(TradingBot bot) {
    return Card(
      child: ListTile(
        leading: Icon(
          _getTradingStrategyIcon(bot.strategy),
          color: _getTradingStrategyColor(bot.strategy),
        ),
        title: Text(bot.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Strategy: ${bot.strategy.name}'),
            Text('Target: ${bot.targetCurrency.name}'),
            Text('Success Rate: ${(bot.successRate * 100).toInt()}%'),
            Text('Max Trade: \$${bot.maxTradeAmount.toInt()}'),
          ],
        ),
        trailing: Switch(
          value: bot.isActive,
          onChanged: (value) => _toggleTradingBot(bot.id, value),
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildDarkOpsTab() {
    final stolenAssets = _cryptoSystem.getStolenAssets();
    
    return Column(
      children: [
        Card(
          color: Colors.red[50],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text('Dark Operations', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _showStealCryptoDialog,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text('Steal Crypto'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _showMarketManipulationDialog,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                        child: const Text('Manipulate Market'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: stolenAssets.length,
            itemBuilder: (context, index) {
              final asset = stolenAssets[index];
              return _buildStolenAssetCard(asset);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStolenAssetCard(CryptoAsset asset) {
    return Card(
      color: Colors.red[100],
      child: ListTile(
        leading: const Icon(Icons.warning, color: Colors.red),
        title: Text('STOLEN ${asset.currency.name}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Amount: ${asset.amount.toStringAsFixed(6)}'),
            Text('Value: \$${asset.totalValue.toStringAsFixed(2)}'),
            Text('Source: ${asset.sourceWallet}'),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () => _showLaunderDialog(asset),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
          child: const Text('Launder'),
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildPricesTab() {
    final prices = _cryptoSystem.cryptoPrices;
    
    return ListView.builder(
      itemCount: prices.length,
      itemBuilder: (context, index) {
        final currency = prices.keys.elementAt(index);
        final price = prices[currency]!;
        
        return Card(
          child: ListTile(
            leading: Icon(
              _getCurrencyIcon(currency),
              color: _getCurrencyColor(currency),
            ),
            title: Text(currency.name),
            subtitle: Text('\$${price.toStringAsFixed(2)}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.trending_up, color: Colors.green),
                  onPressed: () => _cryptoSystem.manipulateMarket(currency, true),
                ),
                IconButton(
                  icon: const Icon(Icons.trending_down, color: Colors.red),
                  onPressed: () => _cryptoSystem.manipulateMarket(currency, false),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPurchaseRigDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Purchase Mining Rig'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: MiningType.values.map((type) {
            return ListTile(
              title: Text(type.name),
              onTap: () {
                _cryptoSystem.purchaseMiningRig(
                  '${type.name} Rig ${DateTime.now().millisecondsSinceEpoch}',
                  type,
                  CryptoCurrency.bitcoin,
                );
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showCreateBotDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Trading Bot'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: TradingStrategy.values.map((strategy) {
            return ListTile(
              title: Text(strategy.name),
              onTap: () {
                _cryptoSystem.createTradingBot(
                  '${strategy.name} Bot ${DateTime.now().millisecondsSinceEpoch}',
                  strategy,
                  CryptoCurrency.bitcoin,
                );
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showStealCryptoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ Steal Cryptocurrency'),
        content: const Text('This is highly illegal and will damage your reputation!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _cryptoSystem.stealCrypto(CryptoCurrency.bitcoin, 0.1);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Steal'),
          ),
        ],
      ),
    );
  }

  void _showMarketManipulationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Market Manipulation'),
        content: const Text('Pump or dump cryptocurrency prices'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _cryptoSystem.manipulateMarket(CryptoCurrency.bitcoin, true);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Pump'),
          ),
          ElevatedButton(
            onPressed: () {
              _cryptoSystem.manipulateMarket(CryptoCurrency.bitcoin, false);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Dump'),
          ),
        ],
      ),
    );
  }

  void _showLaunderDialog(CryptoAsset asset) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Launder Cryptocurrency'),
        content: Text('Convert stolen ${asset.currency.name} to clean LaunderCoin?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _cryptoSystem.launderCrypto(asset.id, CryptoCurrency.launderCoin);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Launder'),
          ),
        ],
      ),
    );
  }

  void _toggleMiningRig(String rigId, bool isActive) {
    // Implementation would toggle rig active state
  }

  void _toggleTradingBot(String botId, bool isActive) {
    // Implementation would toggle bot active state
  }

  Color _getCurrencyColor(CryptoCurrency currency) {
    switch (currency) {
      case CryptoCurrency.bitcoin:
        return Colors.orange;
      case CryptoCurrency.ethereum:
        return Colors.blue;
      case CryptoCurrency.litecoin:
        return Colors.grey;
      case CryptoCurrency.monero:
        return Colors.orange[800]!;
      case CryptoCurrency.darkCoin:
        return Colors.black;
      case CryptoCurrency.streetCoin:
        return Colors.green;
      case CryptoCurrency.empireToken:
        return Colors.purple;
      case CryptoCurrency.launderCoin:
        return Colors.brown;
    }
  }

  IconData _getCurrencyIcon(CryptoCurrency currency) {
    switch (currency) {
      case CryptoCurrency.bitcoin:
        return Icons.currency_bitcoin;
      case CryptoCurrency.ethereum:
        return Icons.diamond;
      case CryptoCurrency.litecoin:
        return Icons.monetization_on;
      case CryptoCurrency.monero:
        return Icons.security;
      case CryptoCurrency.darkCoin:
        return Icons.visibility_off;
      case CryptoCurrency.streetCoin:
        return Icons.local_atm;
      case CryptoCurrency.empireToken:
        return Icons.business;
      case CryptoCurrency.launderCoin:
        return Icons.local_laundry_service;
    }
  }

  Color _getMiningTypeColor(MiningType type) {
    switch (type) {
      case MiningType.cpu:
        return Colors.blue;
      case MiningType.gpu:
        return Colors.green;
      case MiningType.asic:
        return Colors.orange;
      case MiningType.cloudMining:
        return Colors.cyan;
      case MiningType.stealthMining:
        return Colors.black;
      case MiningType.boilerRoom:
        return Colors.red;
    }
  }

  IconData _getMiningTypeIcon(MiningType type) {
    switch (type) {
      case MiningType.cpu:
        return Icons.memory;
      case MiningType.gpu:
        return Icons.videogame_asset;
      case MiningType.asic:
        return Icons.hardware;
      case MiningType.cloudMining:
        return Icons.cloud;
      case MiningType.stealthMining:
        return Icons.visibility_off;
      case MiningType.boilerRoom:
        return Icons.factory;
    }
  }

  Color _getTradingStrategyColor(TradingStrategy strategy) {
    switch (strategy) {
      case TradingStrategy.buyAndHold:
        return Colors.blue;
      case TradingStrategy.dayTrading:
        return Colors.green;
      case TradingStrategy.arbitrage:
        return Colors.orange;
      case TradingStrategy.pumpAndDump:
        return Colors.red;
      case TradingStrategy.washTrading:
        return Colors.purple;
      case TradingStrategy.marketManipulation:
        return Colors.black;
    }
  }

  IconData _getTradingStrategyIcon(TradingStrategy strategy) {
    switch (strategy) {
      case TradingStrategy.buyAndHold:
        return Icons.trending_up;
      case TradingStrategy.dayTrading:
        return Icons.show_chart;
      case TradingStrategy.arbitrage:
        return Icons.swap_horiz;
      case TradingStrategy.pumpAndDump:
        return Icons.dangerous;
      case TradingStrategy.washTrading:
        return Icons.repeat;
      case TradingStrategy.marketManipulation:
        return Icons.psychology;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
