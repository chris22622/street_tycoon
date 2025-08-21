enum TerritoryType {
  street,
  neighborhood, 
  district,
  borough,
}

extension TerritoryTypeExtension on TerritoryType {
  String get name {
    switch (this) {
      case TerritoryType.street:
        return 'Street Corner';
      case TerritoryType.neighborhood:
        return 'Neighborhood';
      case TerritoryType.district:
        return 'District';
      case TerritoryType.borough:
        return 'Borough';
    }
  }

  String get icon {
    switch (this) {
      case TerritoryType.street:
        return '🏪';
      case TerritoryType.neighborhood:
        return '🏘️';
      case TerritoryType.district:
        return '🏙️';
      case TerritoryType.borough:
        return '🌆';
    }
  }

  int get cost {
    switch (this) {
      case TerritoryType.street:
        return 5000;
      case TerritoryType.neighborhood:
        return 20000;
      case TerritoryType.district:
        return 75000;
      case TerritoryType.borough:
        return 250000;
    }
  }

  int get dailyIncome {
    switch (this) {
      case TerritoryType.street:
        return 200;
      case TerritoryType.neighborhood:
        return 800;
      case TerritoryType.district:
        return 3000;
      case TerritoryType.borough:
        return 10000;
    }
  }

  double get defenseStrength {
    switch (this) {
      case TerritoryType.street:
        return 1.0;
      case TerritoryType.neighborhood:
        return 2.5;
      case TerritoryType.district:
        return 5.0;
      case TerritoryType.borough:
        return 10.0;
    }
  }
}

class Territory {
  final String id;
  final String name;
  final TerritoryType type;
  final DateTime acquiredDate;
  final double controlLevel; // 0-100%
  final bool underAttack;

  const Territory({
    required this.id,
    required this.name,
    required this.type,
    required this.acquiredDate,
    required this.controlLevel,
    required this.underAttack,
  });

  bool get isSecure => controlLevel >= 80;
  bool get isContested => controlLevel < 50;
  int get dailyIncome => (type.dailyIncome * (controlLevel / 100)).round();

  Territory copyWith({
    String? id,
    String? name,
    TerritoryType? type,
    DateTime? acquiredDate,
    double? controlLevel,
    bool? underAttack,
  }) {
    return Territory(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      acquiredDate: acquiredDate ?? this.acquiredDate,
      controlLevel: controlLevel ?? this.controlLevel,
      underAttack: underAttack ?? this.underAttack,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.index,
      'acquiredDate': acquiredDate.millisecondsSinceEpoch,
      'controlLevel': controlLevel,
      'underAttack': underAttack,
    };
  }

  factory Territory.fromJson(Map<String, dynamic> json) {
    return Territory(
      id: json['id'],
      name: json['name'],
      type: TerritoryType.values[json['type']],
      acquiredDate: DateTime.fromMillisecondsSinceEpoch(json['acquiredDate']),
      controlLevel: json['controlLevel'].toDouble(),
      underAttack: json['underAttack'] ?? false,
    );
  }
}

class TerritoryControl {
  final List<Territory> territories;
  final int influence; // 0-100 overall influence rating

  const TerritoryControl({
    required this.territories,
    required this.influence,
  });

  static TerritoryControl initial() {
    return const TerritoryControl(
      territories: [],
      influence: 0,
    );
  }

  int get totalDailyIncome => territories.fold(0, (sum, t) => sum + t.dailyIncome);
  int get territoryCount => territories.length;
  double get averageControl {
    if (territories.isEmpty) return 0.0;
    return territories.fold(0.0, (sum, t) => sum + t.controlLevel) / territories.length;
  }

  List<Territory> get contestedTerritories => territories.where((t) => t.isContested).toList();
  List<Territory> get secureTerritories => territories.where((t) => t.isSecure).toList();

  TerritoryControl copyWith({
    List<Territory>? territories,
    int? influence,
  }) {
    return TerritoryControl(
      territories: territories ?? this.territories,
      influence: influence ?? this.influence,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'territories': territories.map((t) => t.toJson()).toList(),
      'influence': influence,
    };
  }

  factory TerritoryControl.fromJson(Map<String, dynamic> json) {
    return TerritoryControl(
      territories: (json['territories'] as List)
          .map((t) => Territory.fromJson(t))
          .toList(),
      influence: json['influence'] ?? 0,
    );
  }
}

// Available territories to expand into
class TerritoryTemplates {
  static const List<Map<String, dynamic>> available = [
    {
      'name': 'East Side Corner',
      'type': TerritoryType.street,
    },
    {
      'name': 'Park Avenue Block',
      'type': TerritoryType.street,
    },
    {
      'name': 'Old Town Hood',
      'type': TerritoryType.neighborhood,
    },
    {
      'name': 'Financial Quarter',
      'type': TerritoryType.district,
    },
    {
      'name': 'Metro Borough',
      'type': TerritoryType.borough,
    },
  ];
}
