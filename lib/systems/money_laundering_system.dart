import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';

enum MoneyType {
  dirty,
  clean,
  traced,
  digital,
  cash,
  foreign,
}

enum LaunderingMethod {
  casino,
  restaurant,
  carwash,
  realestate,
  cryptocurrency,
  offshore,
  artdealer,
  nightclub,
  construction,
  shell_company,
}

enum RiskLevel {
  minimal,
  low,
  moderate,
  high,
  extreme,
}

enum InvestigationStatus {
  none,
  routine_audit,
  suspicious_activity,
  active_investigation,
  federal_case,
}

class FrontBusiness {
  final String id;
  final String name;
  final LaunderingMethod method;
  final double capacity; // max amount per operation
  final double fee; // percentage taken as fee
  final double cleaningRate; // how fast it cleans money
  final RiskLevel riskLevel;
  final double legitimacy; // how legitimate it appears
  final double monthlyUpkeep;
  final bool isActive;
  final double currentLoad; // current amount being processed
  final DateTime lastOperation;
  final List<String> requiredLicenses;
  final Map<String, double> employeeCosts;

  const FrontBusiness({
    required this.id,
    required this.name,
    required this.method,
    required this.capacity,
    required this.fee,
    required this.cleaningRate,
    required this.riskLevel,
    required this.legitimacy,
    required this.monthlyUpkeep,
    required this.isActive,
    required this.currentLoad,
    required this.lastOperation,
    required this.requiredLicenses,
    required this.employeeCosts,
  });
}

class LaunderingTransaction {
  final String id;
  final double dirtyAmount;
  final double cleanAmount;
  final MoneyType sourceType;
  final MoneyType targetType;
  final LaunderingMethod method;
  final String businessId;
  final DateTime startTime;
  final DateTime? completionTime;
  final RiskLevel riskLevel;
  final bool isComplete;
  final double fee;
  final String traceId;

  const LaunderingTransaction({
    required this.id,
    required this.dirtyAmount,
    required this.cleanAmount,
    required this.sourceType,
    required this.targetType,
    required this.method,
    required this.businessId,
    required this.startTime,
    this.completionTime,
    required this.riskLevel,
    required this.isComplete,
    required this.fee,
    required this.traceId,
  });
}

class BankAccount {
  final String id;
  final String bankName;
  final String accountType;
  final double balance;
  final double dailyLimit;
  final bool isOffshore;
  final String jurisdiction;
  final double anonymityLevel;
  final List<String> transactionHistory;
  final bool isFrozen;
  final InvestigationStatus investigationStatus;

  const BankAccount({
    required this.id,
    required this.bankName,
    required this.accountType,
    required this.balance,
    required this.dailyLimit,
    required this.isOffshore,
    required this.jurisdiction,
    required this.anonymityLevel,
    required this.transactionHistory,
    required this.isFrozen,
    required this.investigationStatus,
  });
}

class Investigation {
  final String id;
  final String agency; // FBI, IRS, DEA, etc.
  final InvestigationStatus status;
  final double suspicionLevel;
  final List<String> targetAccounts;
  final List<String> targetBusinesses;
  final DateTime startDate;
  final double evidence;
  final List<String> investigationMethods;
  final double progress;

  const Investigation({
    required this.id,
    required this.agency,
    required this.status,
    required this.suspicionLevel,
    required this.targetAccounts,
    required this.targetBusinesses,
    required this.startDate,
    required this.evidence,
    required this.investigationMethods,
    required this.progress,
  });
}

class MoneyLaunderingSystem {
  static final MoneyLaunderingSystem _instance = MoneyLaunderingSystem._internal();
  factory MoneyLaunderingSystem() => _instance;
  MoneyLaunderingSystem._internal();

  final Map<String, FrontBusiness> _frontBusinesses = {};
  final Map<String, LaunderingTransaction> _activeTransactions = {};
  final Map<String, BankAccount> _bankAccounts = {};
  final Map<String, Investigation> _activeInvestigations = {};
  final List<LaunderingTransaction> _completedTransactions = [];
  
  double _dirtyMoney = 0.0;
  double _cleanMoney = 50000.0; // Starting clean money
  double _overallSuspicion = 0.0;
  Timer? _launderingTimer;

  static const Map<LaunderingMethod, Map<String, dynamic>> _businessTemplates = {
    LaunderingMethod.casino: {
      'name': 'Lucky Stars Casino',
      'capacity': 100000.0,
      'fee': 0.15,
      'cleaningRate': 0.8,
      'riskLevel': RiskLevel.high,
      'legitimacy': 0.6,
      'monthlyUpkeep': 25000.0,
      'licenses': ['gambling_license', 'business_license'],
    },
    
    LaunderingMethod.restaurant: {
      'name': 'Bella Vista Restaurant',
      'capacity': 25000.0,
      'fee': 0.08,
      'cleaningRate': 0.9,
      'riskLevel': RiskLevel.low,
      'legitimacy': 0.9,
      'monthlyUpkeep': 8000.0,
      'licenses': ['food_license', 'liquor_license'],
    },
    
    LaunderingMethod.carwash: {
      'name': 'Sparkle Auto Wash',
      'capacity': 15000.0,
      'fee': 0.05,
      'cleaningRate': 0.95,
      'riskLevel': RiskLevel.minimal,
      'legitimacy': 0.95,
      'monthlyUpkeep': 3000.0,
      'licenses': ['business_license'],
    },
    
    LaunderingMethod.realestate: {
      'name': 'Premium Properties LLC',
      'capacity': 500000.0,
      'fee': 0.12,
      'cleaningRate': 0.7,
      'riskLevel': RiskLevel.moderate,
      'legitimacy': 0.8,
      'monthlyUpkeep': 15000.0,
      'licenses': ['real_estate_license', 'business_license'],
    },
    
    LaunderingMethod.cryptocurrency: {
      'name': 'CryptoExchange Pro',
      'capacity': 200000.0,
      'fee': 0.18,
      'cleaningRate': 0.6,
      'riskLevel': RiskLevel.high,
      'legitimacy': 0.4,
      'monthlyUpkeep': 12000.0,
      'licenses': ['fintech_license'],
    },
    
    LaunderingMethod.offshore: {
      'name': 'Caribbean Holdings Ltd',
      'capacity': 1000000.0,
      'fee': 0.20,
      'cleaningRate': 0.5,
      'riskLevel': RiskLevel.extreme,
      'legitimacy': 0.3,
      'monthlyUpkeep': 50000.0,
      'licenses': ['offshore_license'],
    },
    
    LaunderingMethod.artdealer: {
      'name': 'Modern Art Gallery',
      'capacity': 300000.0,
      'fee': 0.25,
      'cleaningRate': 0.4,
      'riskLevel': RiskLevel.moderate,
      'legitimacy': 0.7,
      'monthlyUpkeep': 20000.0,
      'licenses': ['art_dealer_license', 'business_license'],
    },
    
    LaunderingMethod.nightclub: {
      'name': 'Neon Nights Club',
      'capacity': 80000.0,
      'fee': 0.12,
      'cleaningRate': 0.85,
      'riskLevel': RiskLevel.high,
      'legitimacy': 0.5,
      'monthlyUpkeep': 18000.0,
      'licenses': ['liquor_license', 'entertainment_license'],
    },
    
    LaunderingMethod.construction: {
      'name': 'Apex Construction Co',
      'capacity': 400000.0,
      'fee': 0.10,
      'cleaningRate': 0.75,
      'riskLevel': RiskLevel.moderate,
      'legitimacy': 0.85,
      'monthlyUpkeep': 22000.0,
      'licenses': ['contractor_license', 'business_license'],
    },
    
    LaunderingMethod.shell_company: {
      'name': 'Global Consulting Group',
      'capacity': 150000.0,
      'fee': 0.30,
      'cleaningRate': 0.3,
      'riskLevel': RiskLevel.extreme,
      'legitimacy': 0.2,
      'monthlyUpkeep': 5000.0,
      'licenses': ['business_license'],
    },
  };

  void initialize() {
    _setupInitialAccounts();
    _setupInitialBusinesses();
    _startLaunderingTimer();
  }

  void dispose() {
    _launderingTimer?.cancel();
  }

  void _setupInitialAccounts() {
    final accounts = [
      BankAccount(
        id: 'local_checking',
        bankName: 'First National Bank',
        accountType: 'Checking',
        balance: 15000.0,
        dailyLimit: 10000.0,
        isOffshore: false,
        jurisdiction: 'US',
        anonymityLevel: 0.1,
        transactionHistory: [],
        isFrozen: false,
        investigationStatus: InvestigationStatus.none,
      ),
      
      BankAccount(
        id: 'business_account',
        bankName: 'Business Bank Corp',
        accountType: 'Business',
        balance: 35000.0,
        dailyLimit: 50000.0,
        isOffshore: false,
        jurisdiction: 'US',
        anonymityLevel: 0.2,
        transactionHistory: [],
        isFrozen: false,
        investigationStatus: InvestigationStatus.none,
      ),
    ];

    for (final account in accounts) {
      _bankAccounts[account.id] = account;
    }
  }

  void _setupInitialBusinesses() {
    // Start with a basic car wash
    final carwashTemplate = _businessTemplates[LaunderingMethod.carwash]!;
    final carwash = FrontBusiness(
      id: 'initial_carwash',
      name: carwashTemplate['name'],
      method: LaunderingMethod.carwash,
      capacity: carwashTemplate['capacity'],
      fee: carwashTemplate['fee'],
      cleaningRate: carwashTemplate['cleaningRate'],
      riskLevel: carwashTemplate['riskLevel'],
      legitimacy: carwashTemplate['legitimacy'],
      monthlyUpkeep: carwashTemplate['monthlyUpkeep'],
      isActive: true,
      currentLoad: 0.0,
      lastOperation: DateTime.now().subtract(const Duration(days: 1)),
      requiredLicenses: List<String>.from(carwashTemplate['licenses']),
      employeeCosts: {'manager': 3000.0, 'workers': 2000.0},
    );

    _frontBusinesses[carwash.id] = carwash;
  }

  void _startLaunderingTimer() {
    _launderingTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _updateLaundering();
    });
  }

  void _updateLaundering() {
    _processActiveTransactions();
    _updateInvestigations();
    _calculateSuspicionLevels();
    _processBusinessUpkeep();
  }

  void _processActiveTransactions() {
    final completedTransactionIds = <String>[];
    
    for (final transactionId in _activeTransactions.keys) {
      final transaction = _activeTransactions[transactionId]!;
      final business = _frontBusinesses[transaction.businessId];
      
      if (business == null) continue;
      
      final elapsed = DateTime.now().difference(transaction.startTime);
      final requiredTime = Duration(
        hours: (transaction.dirtyAmount / business.cleaningRate / 1000).round(),
      );
      
      if (elapsed >= requiredTime) {
        // Transaction complete
        final cleanAmount = transaction.dirtyAmount * 
                           (1.0 - business.fee) * 
                           business.cleaningRate;
        
        final completedTransaction = LaunderingTransaction(
          id: transaction.id,
          dirtyAmount: transaction.dirtyAmount,
          cleanAmount: cleanAmount,
          sourceType: transaction.sourceType,
          targetType: MoneyType.clean,
          method: transaction.method,
          businessId: transaction.businessId,
          startTime: transaction.startTime,
          completionTime: DateTime.now(),
          riskLevel: transaction.riskLevel,
          isComplete: true,
          fee: transaction.fee,
          traceId: transaction.traceId,
        );
        
        _completedTransactions.add(completedTransaction);
        completedTransactionIds.add(transactionId);
        
        // Add clean money
        _cleanMoney += cleanAmount;
        
        // Update business load
        _updateBusinessLoad(business.id, -transaction.dirtyAmount);
        
        // Increase suspicion based on risk
        _increaseSuspicion(transaction.riskLevel);
        
        debugPrint('Laundering complete: \$${cleanAmount.toStringAsFixed(2)} cleaned through ${business.name}');
      }
    }
    
    // Remove completed transactions
    for (final id in completedTransactionIds) {
      _activeTransactions.remove(id);
    }
  }

  void _updateBusinessLoad(String businessId, double amountChange) {
    final business = _frontBusinesses[businessId];
    if (business == null) return;
    
    final newLoad = (business.currentLoad + amountChange).clamp(0.0, business.capacity);
    
    _frontBusinesses[businessId] = FrontBusiness(
      id: business.id,
      name: business.name,
      method: business.method,
      capacity: business.capacity,
      fee: business.fee,
      cleaningRate: business.cleaningRate,
      riskLevel: business.riskLevel,
      legitimacy: business.legitimacy,
      monthlyUpkeep: business.monthlyUpkeep,
      isActive: business.isActive,
      currentLoad: newLoad,
      lastOperation: DateTime.now(),
      requiredLicenses: business.requiredLicenses,
      employeeCosts: business.employeeCosts,
    );
  }

  void _increaseSuspicion(RiskLevel riskLevel) {
    double suspicionIncrease = 0.0;
    
    switch (riskLevel) {
      case RiskLevel.minimal:
        suspicionIncrease = 0.001;
        break;
      case RiskLevel.low:
        suspicionIncrease = 0.003;
        break;
      case RiskLevel.moderate:
        suspicionIncrease = 0.007;
        break;
      case RiskLevel.high:
        suspicionIncrease = 0.015;
        break;
      case RiskLevel.extreme:
        suspicionIncrease = 0.030;
        break;
    }
    
    _overallSuspicion = (_overallSuspicion + suspicionIncrease).clamp(0.0, 1.0);
  }

  void _updateInvestigations() {
    final random = math.Random();
    
    // Check if new investigation should start
    if (_overallSuspicion > 0.3 && random.nextDouble() < 0.05) {
      _startInvestigation();
    }
    
    // Update existing investigations
    for (final investigationId in _activeInvestigations.keys) {
      final investigation = _activeInvestigations[investigationId]!;
      
      if (investigation.progress < 1.0) {
        final progressIncrease = 0.02 + (investigation.suspicionLevel * 0.01);
        final newProgress = (investigation.progress + progressIncrease).clamp(0.0, 1.0);
        
        _activeInvestigations[investigationId] = Investigation(
          id: investigation.id,
          agency: investigation.agency,
          status: investigation.status,
          suspicionLevel: investigation.suspicionLevel,
          targetAccounts: investigation.targetAccounts,
          targetBusinesses: investigation.targetBusinesses,
          startDate: investigation.startDate,
          evidence: investigation.evidence,
          investigationMethods: investigation.investigationMethods,
          progress: newProgress,
        );
        
        if (newProgress >= 1.0) {
          _completeInvestigation(investigation);
        }
      }
    }
  }

  void _startInvestigation() {
    final agencies = ['FBI', 'IRS', 'DEA', 'FinCEN'];
    final random = math.Random();
    
    final investigationId = 'inv_${DateTime.now().millisecondsSinceEpoch}';
    final agency = agencies[random.nextInt(agencies.length)];
    
    // Target highest risk businesses and accounts
    final targetBusinesses = _frontBusinesses.values
        .where((b) => b.riskLevel.index >= RiskLevel.moderate.index)
        .map((b) => b.id)
        .take(2)
        .toList();
    
    final targetAccounts = _bankAccounts.values
        .where((a) => a.investigationStatus == InvestigationStatus.none)
        .map((a) => a.id)
        .take(1)
        .toList();
    
    final investigation = Investigation(
      id: investigationId,
      agency: agency,
      status: InvestigationStatus.routine_audit,
      suspicionLevel: _overallSuspicion,
      targetAccounts: targetAccounts,
      targetBusinesses: targetBusinesses,
      startDate: DateTime.now(),
      evidence: 0.0,
      investigationMethods: ['financial_audit', 'surveillance'],
      progress: 0.0,
    );
    
    _activeInvestigations[investigationId] = investigation;
    
    debugPrint('$agency started investigation: $investigationId');
  }

  void _completeInvestigation(Investigation investigation) {
    if (investigation.evidence > 0.7) {
      // Investigation successful - freeze accounts/businesses
      for (final accountId in investigation.targetAccounts) {
        _freezeAccount(accountId);
      }
      
      for (final businessId in investigation.targetBusinesses) {
        _shutdownBusiness(businessId);
      }
      
      debugPrint('Investigation ${investigation.id} completed - Assets seized!');
    } else {
      debugPrint('Investigation ${investigation.id} completed - Insufficient evidence');
    }
    
    _activeInvestigations.remove(investigation.id);
  }

  void _freezeAccount(String accountId) {
    final account = _bankAccounts[accountId];
    if (account == null) return;
    
    _bankAccounts[accountId] = BankAccount(
      id: account.id,
      bankName: account.bankName,
      accountType: account.accountType,
      balance: 0.0, // Funds seized
      dailyLimit: account.dailyLimit,
      isOffshore: account.isOffshore,
      jurisdiction: account.jurisdiction,
      anonymityLevel: account.anonymityLevel,
      transactionHistory: account.transactionHistory,
      isFrozen: true,
      investigationStatus: InvestigationStatus.federal_case,
    );
  }

  void _shutdownBusiness(String businessId) {
    final business = _frontBusinesses[businessId];
    if (business == null) return;
    
    _frontBusinesses[businessId] = FrontBusiness(
      id: business.id,
      name: '${business.name} (CLOSED)',
      method: business.method,
      capacity: business.capacity,
      fee: business.fee,
      cleaningRate: business.cleaningRate,
      riskLevel: business.riskLevel,
      legitimacy: business.legitimacy,
      monthlyUpkeep: business.monthlyUpkeep,
      isActive: false,
      currentLoad: business.currentLoad,
      lastOperation: business.lastOperation,
      requiredLicenses: business.requiredLicenses,
      employeeCosts: business.employeeCosts,
    );
  }

  void _calculateSuspicionLevels() {
    // Gradually reduce suspicion over time if no activity
    if (_activeTransactions.isEmpty) {
      _overallSuspicion = (_overallSuspicion - 0.001).clamp(0.0, 1.0);
    }
  }

  void _processBusinessUpkeep() {
    final now = DateTime.now();
    
    for (final businessId in _frontBusinesses.keys) {
      final business = _frontBusinesses[businessId]!;
      
      if (!business.isActive) continue;
      
      // Check if monthly upkeep is due
      final daysSinceLastOperation = now.difference(business.lastOperation).inDays;
      if (daysSinceLastOperation >= 30) {
        final upkeepCost = business.monthlyUpkeep;
        
        if (_cleanMoney >= upkeepCost) {
          _cleanMoney -= upkeepCost;
          
          // Update last operation date
          _frontBusinesses[businessId] = FrontBusiness(
            id: business.id,
            name: business.name,
            method: business.method,
            capacity: business.capacity,
            fee: business.fee,
            cleaningRate: business.cleaningRate,
            riskLevel: business.riskLevel,
            legitimacy: business.legitimacy,
            monthlyUpkeep: business.monthlyUpkeep,
            isActive: business.isActive,
            currentLoad: business.currentLoad,
            lastOperation: now,
            requiredLicenses: business.requiredLicenses,
            employeeCosts: business.employeeCosts,
          );
        } else {
          // Can't afford upkeep - shutdown business
          _shutdownBusiness(businessId);
          debugPrint('${business.name} shutdown due to unpaid upkeep');
        }
      }
    }
  }

  // Player actions
  bool launderMoney(String businessId, double amount) {
    final business = _frontBusinesses[businessId];
    
    if (business == null || !business.isActive) {
      debugPrint('Business not available for laundering');
      return false;
    }
    
    if (amount > _dirtyMoney) {
      debugPrint('Insufficient dirty money');
      return false;
    }
    
    if (business.currentLoad + amount > business.capacity) {
      debugPrint('Business capacity exceeded');
      return false;
    }
    
    // Create transaction
    final transactionId = 'txn_${DateTime.now().millisecondsSinceEpoch}';
    final transaction = LaunderingTransaction(
      id: transactionId,
      dirtyAmount: amount,
      cleanAmount: 0.0, // Will be calculated when complete
      sourceType: MoneyType.dirty,
      targetType: MoneyType.clean,
      method: business.method,
      businessId: businessId,
      startTime: DateTime.now(),
      riskLevel: business.riskLevel,
      isComplete: false,
      fee: business.fee,
      traceId: 'trace_${transactionId}',
    );
    
    _activeTransactions[transactionId] = transaction;
    
    // Deduct dirty money
    _dirtyMoney -= amount;
    
    // Update business load
    _updateBusinessLoad(businessId, amount);
    
    debugPrint('Started laundering \$${amount.toStringAsFixed(2)} through ${business.name}');
    return true;
  }

  bool purchaseBusiness(LaunderingMethod method) {
    final template = _businessTemplates[method];
    if (template == null) return false;
    
    final cost = _getBusinessCost(method);
    
    if (_cleanMoney < cost) {
      debugPrint('Insufficient clean money to purchase business');
      return false;
    }
    
    final businessId = 'business_${DateTime.now().millisecondsSinceEpoch}';
    final business = FrontBusiness(
      id: businessId,
      name: template['name'],
      method: method,
      capacity: template['capacity'],
      fee: template['fee'],
      cleaningRate: template['cleaningRate'],
      riskLevel: template['riskLevel'],
      legitimacy: template['legitimacy'],
      monthlyUpkeep: template['monthlyUpkeep'],
      isActive: true,
      currentLoad: 0.0,
      lastOperation: DateTime.now(),
      requiredLicenses: List<String>.from(template['licenses']),
      employeeCosts: {'manager': 5000.0, 'staff': 3000.0},
    );
    
    _frontBusinesses[businessId] = business;
    _cleanMoney -= cost;
    
    debugPrint('Purchased ${business.name} for \$${cost.toStringAsFixed(2)}');
    return true;
  }

  double _getBusinessCost(LaunderingMethod method) {
    switch (method) {
      case LaunderingMethod.carwash:
        return 50000.0;
      case LaunderingMethod.restaurant:
        return 150000.0;
      case LaunderingMethod.casino:
        return 1000000.0;
      case LaunderingMethod.realestate:
        return 500000.0;
      case LaunderingMethod.cryptocurrency:
        return 200000.0;
      case LaunderingMethod.offshore:
        return 2000000.0;
      case LaunderingMethod.artdealer:
        return 300000.0;
      case LaunderingMethod.nightclub:
        return 400000.0;
      case LaunderingMethod.construction:
        return 600000.0;
      case LaunderingMethod.shell_company:
        return 100000.0;
    }
  }

  bool openBankAccount(String bankName, String jurisdiction, bool isOffshore) {
    final cost = isOffshore ? 50000.0 : 1000.0;
    
    if (_cleanMoney < cost) {
      debugPrint('Insufficient funds to open account');
      return false;
    }
    
    final accountId = 'account_${DateTime.now().millisecondsSinceEpoch}';
    final account = BankAccount(
      id: accountId,
      bankName: bankName,
      accountType: isOffshore ? 'Offshore' : 'Standard',
      balance: 0.0,
      dailyLimit: isOffshore ? 1000000.0 : 25000.0,
      isOffshore: isOffshore,
      jurisdiction: jurisdiction,
      anonymityLevel: isOffshore ? 0.8 : 0.2,
      transactionHistory: [],
      isFrozen: false,
      investigationStatus: InvestigationStatus.none,
    );
    
    _bankAccounts[accountId] = account;
    _cleanMoney -= cost;
    
    debugPrint('Opened $bankName account in $jurisdiction');
    return true;
  }

  void addDirtyMoney(double amount) {
    _dirtyMoney += amount;
  }

  void addCleanMoney(double amount) {
    _cleanMoney += amount;
  }

  // Public interface
  double get dirtyMoney => _dirtyMoney;
  double get cleanMoney => _cleanMoney;
  double get overallSuspicion => _overallSuspicion;
  
  List<FrontBusiness> getFrontBusinesses() => _frontBusinesses.values.toList();
  List<LaunderingTransaction> getActiveTransactions() => _activeTransactions.values.toList();
  List<LaunderingTransaction> getCompletedTransactions() => List.unmodifiable(_completedTransactions);
  List<BankAccount> getBankAccounts() => _bankAccounts.values.toList();
  List<Investigation> getActiveInvestigations() => _activeInvestigations.values.toList();
  
  List<FrontBusiness> getAvailableBusinesses() => _frontBusinesses.values.where((b) => b.isActive).toList();
  
  double getTotalCapacity() => _frontBusinesses.values
      .where((b) => b.isActive)
      .fold(0.0, (sum, b) => sum + (b.capacity - b.currentLoad));
  
  double getTotalMonthlyUpkeep() => _frontBusinesses.values
      .where((b) => b.isActive)
      .fold(0.0, (sum, b) => sum + b.monthlyUpkeep);
  
  bool canAffordBusiness(LaunderingMethod method) => _cleanMoney >= _getBusinessCost(method);
  
  double getBusinessCost(LaunderingMethod method) => _getBusinessCost(method);
  
  InvestigationStatus getHighestInvestigationStatus() {
    if (_activeInvestigations.isEmpty) return InvestigationStatus.none;
    
    return _activeInvestigations.values
        .map((inv) => inv.status)
        .reduce((a, b) => a.index > b.index ? a : b);
  }
}

// Money laundering status widget
class MoneyLaunderingStatusWidget extends StatefulWidget {
  const MoneyLaunderingStatusWidget({super.key});

  @override
  State<MoneyLaunderingStatusWidget> createState() => _MoneyLaunderingStatusWidgetState();
}

class _MoneyLaunderingStatusWidgetState extends State<MoneyLaunderingStatusWidget> {
  final MoneyLaunderingSystem _laundering = MoneyLaunderingSystem();
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    _laundering.initialize();
    _laundering.addDirtyMoney(25000.0); // Start with some dirty money
    _updateTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dirtyMoney = _laundering.dirtyMoney;
    final cleanMoney = _laundering.cleanMoney;
    final suspicion = _laundering.overallSuspicion;
    final activeTransactions = _laundering.getActiveTransactions();
    final businesses = _laundering.getAvailableBusinesses();
    final investigations = _laundering.getActiveInvestigations();
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.attach_money,
                color: Colors.green,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Money Laundering',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                      'Dirty: \$${dirtyMoney.toStringAsFixed(0)}',
                      style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Clean: \$${cleanMoney.toStringAsFixed(0)}',
                      style: const TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Businesses: ${businesses.length}',
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                  Text(
                    'Active Ops: ${activeTransactions.length}',
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Row(
            children: [
              const Text('Suspicion: ', style: TextStyle(color: Colors.white70, fontSize: 12)),
              Expanded(
                child: LinearProgressIndicator(
                  value: suspicion,
                  backgroundColor: Colors.grey[800],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    suspicion < 0.3 ? Colors.green : 
                    suspicion < 0.6 ? Colors.orange : Colors.red,
                  ),
                ),
              ),
              Text(
                ' ${(suspicion * 100).toStringAsFixed(0)}%',
                style: const TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ],
          ),
          
          if (investigations.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.red, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'UNDER INVESTIGATION (${investigations.length})',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          if (activeTransactions.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Text(
              'Laundering Progress:',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            ...activeTransactions.take(2).map((transaction) {
              final business = businesses.firstWhere(
                (b) => b.id == transaction.businessId,
                orElse: () => businesses.first,
              );
              final elapsed = DateTime.now().difference(transaction.startTime);
              final requiredTime = Duration(
                hours: (transaction.dirtyAmount / business.cleaningRate / 1000).round(),
              );
              final progress = (elapsed.inMilliseconds / requiredTime.inMilliseconds).clamp(0.0, 1.0);
              
              return Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$${transaction.dirtyAmount.toStringAsFixed(0)} - ${business.name}',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[800],
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.yellow),
                    ),
                  ],
                ),
              );
            }),
          ],
          
          const SizedBox(width: 8),
          
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: dirtyMoney >= 5000 && businesses.isNotEmpty
                      ? () {
                          final business = businesses.first;
                          final amount = math.min(5000.0, dirtyMoney);
                          _laundering.launderMoney(business.id, amount);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    padding: const EdgeInsets.symmetric(vertical: 4),
                  ),
                  child: const Text('Launder \$5K', style: TextStyle(fontSize: 10)),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: ElevatedButton(
                  onPressed: _laundering.canAffordBusiness(LaunderingMethod.restaurant)
                      ? () => _laundering.purchaseBusiness(LaunderingMethod.restaurant)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    padding: const EdgeInsets.symmetric(vertical: 4),
                  ),
                  child: const Text('Buy Business', style: TextStyle(fontSize: 10)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
