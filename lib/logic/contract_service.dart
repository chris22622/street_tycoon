import 'dart:math';
import '../data/contract_models.dart';
import '../services/audio_service.dart';

class ContractService {
  static final ContractService _instance = ContractService._internal();
  factory ContractService() => _instance;
  ContractService._internal();

  final List<Contract> _activeContracts = [];
  final List<Contract> _completedContracts = [];
  final Random _random = Random();

  List<Contract> get activeContracts => List.unmodifiable(_activeContracts);
  List<Contract> get completedContracts => List.unmodifiable(_completedContracts);

  // Initialize with some starting contracts
  void initialize() {
    if (_activeContracts.isEmpty) {
      _generateInitialContracts();
    }
  }

  void _generateInitialContracts() {
    // Start with 2-3 contracts
    for (int i = 0; i < 2 + _random.nextInt(2); i++) {
      _activeContracts.add(Contract.generate());
    }
  }

  // Add a new contract to the board
  void addContract({ContractRarity? rarity}) {
    if (_activeContracts.length < 5) { // Max 5 active contracts
      final contract = Contract.generate(forceRarity: rarity);
      _activeContracts.add(contract);
      AudioService().playSoundEffect(SoundEffect.achievement);
      print('📋 New ${contract.rarity.displayName} contract added: ${contract.description}');
    }
  }

  // Accept a contract (player commits to it)
  bool acceptContract(String contractId, Map<String, dynamic> playerState) {
    final contractIndex = _activeContracts.indexWhere((c) => c.id == contractId);
    if (contractIndex == -1) return false;

    final contract = _activeContracts[contractIndex];
    
    // Check if player meets requirements
    if (!_meetsRequirements(contract, playerState)) {
      print('❌ Cannot accept contract: requirements not met');
      return false;
    }

    // Check if player has enough inventory
    final playerInventory = playerState['stash'] as Map<String, int>? ?? {};
    final currentStock = playerInventory[contract.item] ?? 0;
    
    if (currentStock < contract.quantity) {
      print('❌ Cannot accept contract: insufficient ${contract.item} (need ${contract.quantity}, have $currentStock)');
      return false;
    }

    // Accept the contract (remove from active, add to completed)
    _activeContracts.removeAt(contractIndex);
    _completedContracts.add(contract);
    
    AudioService().playSoundEffect(SoundEffect.money);
    print('✅ Contract accepted: ${contract.description}');
    print('💰 Earned: \$${contract.adjustedPayout}');
    
    return true;
  }

  // Get payout and remove items from inventory
  Map<String, dynamic> fulfillContract(String contractId, Map<String, dynamic> playerState) {
    final contract = _completedContracts.firstWhere((c) => c.id == contractId);
    
    // Remove items from inventory
    final stash = Map<String, int>.from(playerState['stash'] as Map<String, int>? ?? {});
    stash[contract.item] = (stash[contract.item] ?? 0) - contract.quantity;
    if (stash[contract.item]! <= 0) stash.remove(contract.item);
    
    // Add cash
    final currentCash = playerState['cash'] as int? ?? 0;
    final newCash = currentCash + contract.adjustedPayout;
    
    return {
      'cash': newCash,
      'stash': stash,
      'contract_completed': contract.id,
    };
  }

  // Check for expired contracts and apply penalties
  Map<String, dynamic> processExpiredContracts(Map<String, dynamic> playerState) {
    final expired = _activeContracts.where((c) => c.isExpired).toList();
    final penalties = <Contract>[];
    
    for (final contract in expired) {
      _activeContracts.remove(contract);
      penalties.add(contract);
      print('⏰ Contract expired: ${contract.description}');
      print('💸 Penalty: \$${contract.penalty}');
    }
    
    if (penalties.isEmpty) return playerState;
    
    // Apply cash penalties
    final totalPenalty = penalties.fold<int>(0, (sum, c) => sum + c.penalty);
    final currentCash = playerState['cash'] as int? ?? 0;
    final newCash = (currentCash - totalPenalty).clamp(0, double.infinity).toInt();
    
    // Add some heat for failed contracts
    final currentHeat = playerState['heat'] as int? ?? 0;
    final heatIncrease = penalties.length * 5; // 5 heat per failed contract
    final newHeat = currentHeat + heatIncrease;
    
    AudioService().playSoundEffect(SoundEffect.alert);
    
    return {
      ...playerState,
      'cash': newCash,
      'heat': newHeat,
      'expired_contracts': penalties.map((c) => c.id).toList(),
    };
  }

  // Check if player meets contract requirements
  bool _meetsRequirements(Contract contract, Map<String, dynamic> playerState) {
    for (final entry in contract.requirements.entries) {
      switch (entry.key) {
        case 'heat_max':
          final playerHeat = playerState['heat'] as int? ?? 0;
          if (playerHeat > entry.value) return false;
          break;
        case 'reputation_min':
          final playerRep = playerState['reputation'] as int? ?? 0;
          if (playerRep < entry.value) return false;
          break;
        case 'zone':
          final playerZone = playerState['current_zone'] as String? ?? '';
          if (playerZone != entry.value) return false;
          break;
      }
    }
    return true;
  }

  // Refresh contracts (called periodically)
  void refreshContracts() {
    // Remove a random contract 25% of the time to keep board fresh
    if (_activeContracts.isNotEmpty && _random.nextDouble() < 0.25) {
      final removed = _activeContracts.removeAt(_random.nextInt(_activeContracts.length));
      print('📋 Contract removed from board: ${removed.description}');
    }
    
    // Add new contract if we have space
    if (_activeContracts.length < 4) { // Keep 3-4 contracts active
      addContract();
    }
  }

  // Get contract statistics
  Map<String, dynamic> getStats() {
    final totalCompleted = _completedContracts.length;
    final totalPayout = _completedContracts.fold<int>(0, (sum, c) => sum + c.adjustedPayout);
    final averagePayout = totalCompleted > 0 ? totalPayout / totalCompleted : 0;
    
    return {
      'total_completed': totalCompleted,
      'total_payout': totalPayout,
      'average_payout': averagePayout.round(),
      'active_count': _activeContracts.length,
    };
  }

  // Save/load state
  Map<String, dynamic> toJson() {
    return {
      'active_contracts': _activeContracts.map((c) => c.toJson()).toList(),
      'completed_contracts': _completedContracts.map((c) => c.toJson()).toList(),
    };
  }

  void fromJson(Map<String, dynamic> json) {
    _activeContracts.clear();
    _completedContracts.clear();
    
    if (json['active_contracts'] != null) {
      for (final contractJson in json['active_contracts']) {
        _activeContracts.add(Contract.fromJson(contractJson));
      }
    }
    
    if (json['completed_contracts'] != null) {
      for (final contractJson in json['completed_contracts']) {
        _completedContracts.add(Contract.fromJson(contractJson));
      }
    }
  }
}
