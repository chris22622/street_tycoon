enum ContractRarity {
  common('Common', 1.0, 'C'),
  rare('Rare', 1.5, 'R'), 
  epic('Epic', 2.5, 'E');

  const ContractRarity(this.displayName, this.multiplier, this.shortCode);
  final String displayName;
  final double multiplier;
  final String shortCode;
}

class Contract {
  final String id;
  final String item;
  final int quantity;
  final int basePayout;
  final int penalty;
  final DateTime expiresAt;
  final ContractRarity rarity;
  final String description;
  final Map<String, dynamic> requirements; // {'heat_max': 30, 'zone': 'harbor'}
  
  Contract({
    required this.id,
    required this.item,
    required this.quantity,
    required this.basePayout,
    required this.penalty,
    required this.expiresAt,
    required this.rarity,
    required this.description,
    this.requirements = const {},
  });

  int get adjustedPayout => (basePayout * rarity.multiplier).round();
  
  bool get isExpired => DateTime.now().isAfter(expiresAt);
  
  Duration get timeRemaining => expiresAt.difference(DateTime.now());
  
  bool get isUrgent => timeRemaining.inHours < 6;

  // Factory for generating random contracts
  factory Contract.generate({ContractRarity? forceRarity}) {
    final items = ['Weed', 'Cocaine', 'Pills', 'LSD', 'Ecstasy'];
    final item = items[DateTime.now().millisecond % items.length];
    
    // Rarity distribution: 60% Common, 30% Rare, 10% Epic
    ContractRarity rarity = forceRarity ?? _generateRarity();
    
    final baseQty = _getBaseQuantity(rarity);
    final basePayout = _getBasePayout(item, baseQty, rarity);
    final duration = _getContractDuration(rarity);
    
    return Contract(
      id: 'contract_${DateTime.now().millisecondsSinceEpoch}',
      item: item,
      quantity: baseQty,
      basePayout: basePayout,
      penalty: (basePayout * 0.3).round(), // 30% penalty for failure
      expiresAt: DateTime.now().add(duration),
      rarity: rarity,
      description: _generateDescription(item, baseQty, rarity),
      requirements: _generateRequirements(rarity),
    );
  }

  static ContractRarity _generateRarity() {
    final rand = DateTime.now().millisecond % 100;
    if (rand < 60) return ContractRarity.common;
    if (rand < 90) return ContractRarity.rare;
    return ContractRarity.epic;
  }

  static int _getBaseQuantity(ContractRarity rarity) {
    switch (rarity) {
      case ContractRarity.common:
        return 5 + (DateTime.now().second % 15); // 5-20
      case ContractRarity.rare:
        return 15 + (DateTime.now().second % 25); // 15-40
      case ContractRarity.epic:
        return 30 + (DateTime.now().second % 50); // 30-80
    }
  }

  static int _getBasePayout(String item, int qty, ContractRarity rarity) {
    final basePrice = {
      'Weed': 50,
      'Cocaine': 120, 
      'Pills': 80,
      'LSD': 200,
      'Ecstasy': 150,
    }[item] ?? 100;
    
    return (basePrice * qty * 1.2).round(); // 20% premium over market
  }

  static Duration _getContractDuration(ContractRarity rarity) {
    switch (rarity) {
      case ContractRarity.common:
        return Duration(hours: 4 + (DateTime.now().minute % 8)); // 4-12 hours
      case ContractRarity.rare:
        return Duration(hours: 8 + (DateTime.now().minute % 16)); // 8-24 hours
      case ContractRarity.epic:
        return Duration(hours: 16 + (DateTime.now().minute % 32)); // 16-48 hours
    }
  }

  static String _generateDescription(String item, int qty, ContractRarity rarity) {
    final templates = {
      ContractRarity.common: [
        'Local dealer needs $qty units of $item by deadline',
        'Quick turnaround: $qty $item for regular client',
        'Standard order: $qty $item, payment on delivery',
      ],
      ContractRarity.rare: [
        'High-profile client wants $qty $item - premium rates',
        'Exclusive deal: $qty $item for VIP customer',
        'Rush order: $qty $item for wealthy buyer',
      ],
      ContractRarity.epic: [
        'MAJOR DEAL: $qty $item for international syndicate',
        'Cartel connection: $qty $item - massive payout',
        'Empire opportunity: $qty $item for crime family',
      ],
    };
    
    final options = templates[rarity]!;
    final template = options[DateTime.now().second % options.length];
    return template.replaceAll('\$qty', qty.toString()).replaceAll('\$item', item);
  }

  static Map<String, dynamic> _generateRequirements(ContractRarity rarity) {
    switch (rarity) {
      case ContractRarity.common:
        return {}; // No special requirements
      case ContractRarity.rare:
        return {'heat_max': 40}; // Can't be too hot
      case ContractRarity.epic:
        return {'heat_max': 25, 'reputation_min': 50}; // Low heat, high rep needed
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item': item,
      'quantity': quantity,
      'basePayout': basePayout,
      'penalty': penalty,
      'expiresAt': expiresAt.toIso8601String(),
      'rarity': rarity.shortCode,
      'description': description,
      'requirements': requirements,
    };
  }

  factory Contract.fromJson(Map<String, dynamic> json) {
    return Contract(
      id: json['id'],
      item: json['item'],
      quantity: json['quantity'],
      basePayout: json['basePayout'],
      penalty: json['penalty'],
      expiresAt: DateTime.parse(json['expiresAt']),
      rarity: ContractRarity.values.firstWhere((r) => r.shortCode == json['rarity']),
      description: json['description'],
      requirements: Map<String, dynamic>.from(json['requirements'] ?? {}),
    );
  }
}
