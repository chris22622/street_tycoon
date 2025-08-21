enum CrewMemberRank {
  recruit,
  soldier,
  lieutenant,
  underboss,
}

extension CrewMemberRankExtension on CrewMemberRank {
  String get name {
    switch (this) {
      case CrewMemberRank.recruit:
        return 'Recruit';
      case CrewMemberRank.soldier:
        return 'Soldier';
      case CrewMemberRank.lieutenant:
        return 'Lieutenant';
      case CrewMemberRank.underboss:
        return 'Underboss';
    }
  }

  String get icon {
    switch (this) {
      case CrewMemberRank.recruit:
        return '👤';
      case CrewMemberRank.soldier:
        return '👥';
      case CrewMemberRank.lieutenant:
        return '⭐';
      case CrewMemberRank.underboss:
        return '👑';
    }
  }

  int get hireCost {
    switch (this) {
      case CrewMemberRank.recruit:
        return 2000;
      case CrewMemberRank.soldier:
        return 8000;
      case CrewMemberRank.lieutenant:
        return 25000;
      case CrewMemberRank.underboss:
        return 75000;
    }
  }

  int get dailyCost {
    switch (this) {
      case CrewMemberRank.recruit:
        return 100;
      case CrewMemberRank.soldier:
        return 400;
      case CrewMemberRank.lieutenant:
        return 1200;
      case CrewMemberRank.underboss:
        return 3500;
    }
  }

  double get loyaltyDecayRate {
    switch (this) {
      case CrewMemberRank.recruit:
        return 0.05; // 5% per day
      case CrewMemberRank.soldier:
        return 0.03; // 3% per day
      case CrewMemberRank.lieutenant:
        return 0.02; // 2% per day
      case CrewMemberRank.underboss:
        return 0.01; // 1% per day
    }
  }

  double get efficiencyBonus {
    switch (this) {
      case CrewMemberRank.recruit:
        return 0.05; // 5% bonus
      case CrewMemberRank.soldier:
        return 0.15; // 15% bonus
      case CrewMemberRank.lieutenant:
        return 0.30; // 30% bonus
      case CrewMemberRank.underboss:
        return 0.50; // 50% bonus
    }
  }
}

class CrewMember {
  final String id;
  final String name;
  final CrewMemberRank rank;
  final double loyalty; // 0-100
  final DateTime hiredDate;
  final Map<String, double> skills; // Different specializations
  final String specialty;

  const CrewMember({
    required this.id,
    required this.name,
    required this.rank,
    required this.loyalty,
    required this.hiredDate,
    required this.skills,
    required this.specialty,
  });

  bool get isLoyal => loyalty >= 60;
  bool get isRisky => loyalty < 30;
  
  int get dailyUpkeep => rank.dailyCost;
  double get efficiencyMultiplier => 1.0 + rank.efficiencyBonus;

  CrewMember copyWith({
    String? id,
    String? name,
    CrewMemberRank? rank,
    double? loyalty,
    DateTime? hiredDate,
    Map<String, double>? skills,
    String? specialty,
  }) {
    return CrewMember(
      id: id ?? this.id,
      name: name ?? this.name,
      rank: rank ?? this.rank,
      loyalty: loyalty ?? this.loyalty,
      hiredDate: hiredDate ?? this.hiredDate,
      skills: skills ?? this.skills,
      specialty: specialty ?? this.specialty,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rank': rank.index,
      'loyalty': loyalty,
      'hiredDate': hiredDate.millisecondsSinceEpoch,
      'skills': skills,
      'specialty': specialty,
    };
  }

  factory CrewMember.fromJson(Map<String, dynamic> json) {
    return CrewMember(
      id: json['id'],
      name: json['name'],
      rank: CrewMemberRank.values[json['rank']],
      loyalty: json['loyalty'].toDouble(),
      hiredDate: DateTime.fromMillisecondsSinceEpoch(json['hiredDate']),
      skills: Map<String, double>.from(json['skills']),
      specialty: json['specialty'],
    );
  }
}

class Crew {
  final List<CrewMember> members;
  final int maxSize;
  final double overallLoyalty;

  const Crew({
    required this.members,
    required this.maxSize,
    required this.overallLoyalty,
  });

  static Crew initial() {
    return const Crew(
      members: [],
      maxSize: 8, // Start with capacity for 8 crew members
      overallLoyalty: 100.0,
    );
  }

  int get size => members.length;
  bool get isFull => size >= maxSize;
  int get dailyUpkeep => members.fold(0, (sum, member) => sum + member.dailyUpkeep);
  
  double get averageLoyalty {
    if (members.isEmpty) return 100.0;
    return members.fold(0.0, (sum, member) => sum + member.loyalty) / members.length;
  }

  List<CrewMember> get riskyMembers => members.where((m) => m.isRisky).toList();
  List<CrewMember> get loyalMembers => members.where((m) => m.isLoyal).toList();

  // Calculate crew efficiency bonus for different activities
  double getEfficiencyBonus(String activity) {
    if (members.isEmpty) return 1.0;
    
    final relevantMembers = members.where((member) => 
      member.skills.containsKey(activity) && member.loyalty > 50).toList();
    
    if (relevantMembers.isEmpty) return 1.0;
    
    final totalBonus = relevantMembers.fold(0.0, (sum, member) => 
      sum + (member.skills[activity] ?? 0.0) * member.efficiencyMultiplier);
    
    return 1.0 + (totalBonus / 100); // Convert percentage to multiplier
  }

  Crew copyWith({
    List<CrewMember>? members,
    int? maxSize,
    double? overallLoyalty,
  }) {
    return Crew(
      members: members ?? this.members,
      maxSize: maxSize ?? this.maxSize,
      overallLoyalty: overallLoyalty ?? this.overallLoyalty,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'members': members.map((m) => m.toJson()).toList(),
      'maxSize': maxSize,
      'overallLoyalty': overallLoyalty,
    };
  }

  factory Crew.fromJson(Map<String, dynamic> json) {
    return Crew(
      members: (json['members'] as List)
          .map((m) => CrewMember.fromJson(m))
          .toList(),
      maxSize: json['maxSize'] ?? 8,
      overallLoyalty: json['overallLoyalty']?.toDouble() ?? 100.0,
    );
  }
}

// Predefined crew member templates for hiring
class CrewTemplates {
  static const List<Map<String, dynamic>> templates = [
    {
      'names': ['Tommy "The Knife"', 'Big Mike', 'Joey Numbers', 'Sal "The Fish"'],
      'rank': CrewMemberRank.recruit,
      'specialty': 'Muscle',
      'skills': {'trading': 10.0, 'protection': 25.0, 'intimidation': 20.0},
    },
    {
      'names': ['Maria "Blackjack"', 'Lucky Lou', 'Fast Eddie', 'Smooth Tony'],
      'rank': CrewMemberRank.recruit,
      'specialty': 'Dealer',
      'skills': {'trading': 25.0, 'negotiation': 20.0, 'networking': 15.0},
    },
    {
      'names': ['Doc "Patch"', 'Clean Pete', 'Jimmy "Wash"', 'Cool Cat'],
      'rank': CrewMemberRank.recruit,
      'specialty': 'Cleaner',
      'skills': {'heat_reduction': 30.0, 'stealth': 25.0, 'cleanup': 20.0},
    },
    {
      'names': ['Wheels McGee', 'Turbo Tim', 'Gear Head', 'Highway Harry'],
      'rank': CrewMemberRank.soldier,
      'specialty': 'Driver',
      'skills': {'travel': 30.0, 'escape': 35.0, 'speed': 25.0},
    },
    {
      'names': ['Hawk Eye', 'Silent Sam', 'Ghost Walker', 'Shadow Pete'],
      'rank': CrewMemberRank.soldier,
      'specialty': 'Scout',
      'skills': {'intel': 40.0, 'surveillance': 35.0, 'warning': 30.0},
    },
    {
      'names': ['Money Mike', 'Calculator Cal', 'Banker Bob', 'Vault Vicky'],
      'rank': CrewMemberRank.lieutenant,
      'specialty': 'Accountant',
      'skills': {'money_laundering': 50.0, 'tax_evasion': 45.0, 'banking': 40.0},
    },
    {
      'names': ['The Fixer', 'Mr. Clean', 'Problem Solver', 'The Solution'],
      'rank': CrewMemberRank.underboss,
      'specialty': 'Fixer',
      'skills': {'corruption': 60.0, 'political': 55.0, 'legal': 50.0},
    },
  ];
}
