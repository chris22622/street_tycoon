enum LawyerTier {
  publicDefender,
  generalPractice,
  criminalSpecialist,
  topTier,
  celebrity,
}

extension LawyerTierExtension on LawyerTier {
  String get name {
    switch (this) {
      case LawyerTier.publicDefender:
        return 'Public Defender';
      case LawyerTier.generalPractice:
        return 'General Practice';
      case LawyerTier.criminalSpecialist:
        return 'Criminal Specialist';
      case LawyerTier.topTier:
        return 'Top-Tier Firm';
      case LawyerTier.celebrity:
        return 'Celebrity Lawyer';
    }
  }

  String get icon {
    switch (this) {
      case LawyerTier.publicDefender:
        return '⚖️';
      case LawyerTier.generalPractice:
        return '👔';
      case LawyerTier.criminalSpecialist:
        return '🎯';
      case LawyerTier.topTier:
        return '💼';
      case LawyerTier.celebrity:
        return '🌟';
    }
  }

  int get retainerCost {
    switch (this) {
      case LawyerTier.publicDefender:
        return 0;
      case LawyerTier.generalPractice:
        return 5000;
      case LawyerTier.criminalSpecialist:
        return 15000;
      case LawyerTier.topTier:
        return 50000;
      case LawyerTier.celebrity:
        return 150000;
    }
  }

  int get hourlyRate {
    switch (this) {
      case LawyerTier.publicDefender:
        return 0;
      case LawyerTier.generalPractice:
        return 300;
      case LawyerTier.criminalSpecialist:
        return 750;
      case LawyerTier.topTier:
        return 1500;
      case LawyerTier.celebrity:
        return 3000;
    }
  }

  double get successRate {
    switch (this) {
      case LawyerTier.publicDefender:
        return 0.15;
      case LawyerTier.generalPractice:
        return 0.35;
      case LawyerTier.criminalSpecialist:
        return 0.65;
      case LawyerTier.topTier:
        return 0.85;
      case LawyerTier.celebrity:
        return 0.95;
    }
  }

  String get description {
    switch (this) {
      case LawyerTier.publicDefender:
        return 'Free legal representation with minimal success rate';
      case LawyerTier.generalPractice:
        return 'Basic criminal defense with moderate success';
      case LawyerTier.criminalSpecialist:
        return 'Experienced in criminal law with good track record';
      case LawyerTier.topTier:
        return 'Elite firm with extensive resources and connections';
      case LawyerTier.celebrity:
        return 'High-profile lawyer with unmatched reputation';
    }
  }
}

class Lawyer {
  final String name;
  final LawyerTier tier;
  final String specialty;
  final int experience;
  final double reputation;
  final bool isAvailable;
  final DateTime? lastHired;

  const Lawyer({
    required this.name,
    required this.tier,
    required this.specialty,
    required this.experience,
    required this.reputation,
    this.isAvailable = true,
    this.lastHired,
  });

  Lawyer copyWith({
    String? name,
    LawyerTier? tier,
    String? specialty,
    int? experience,
    double? reputation,
    bool? isAvailable,
    DateTime? lastHired,
  }) {
    return Lawyer(
      name: name ?? this.name,
      tier: tier ?? this.tier,
      specialty: specialty ?? this.specialty,
      experience: experience ?? this.experience,
      reputation: reputation ?? this.reputation,
      isAvailable: isAvailable ?? this.isAvailable,
      lastHired: lastHired ?? this.lastHired,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'tier': tier.index,
      'specialty': specialty,
      'experience': experience,
      'reputation': reputation,
      'isAvailable': isAvailable,
      'lastHired': lastHired?.millisecondsSinceEpoch,
    };
  }

  factory Lawyer.fromJson(Map<String, dynamic> json) {
    return Lawyer(
      name: json['name'],
      tier: LawyerTier.values[json['tier']],
      specialty: json['specialty'],
      experience: json['experience'],
      reputation: json['reputation'],
      isAvailable: json['isAvailable'] ?? true,
      lastHired: json['lastHired'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['lastHired'])
          : null,
    );
  }
}

class LawyerRetainer {
  final String lawyerId;
  final LawyerTier tier;
  final DateTime hiredDate;
  final int retainerPaid;
  final int hoursUsed;
  final List<String> casesHandled;
  final bool isActive;

  const LawyerRetainer({
    required this.lawyerId,
    required this.tier,
    required this.hiredDate,
    required this.retainerPaid,
    this.hoursUsed = 0,
    this.casesHandled = const [],
    this.isActive = true,
  });

  LawyerRetainer copyWith({
    String? lawyerId,
    LawyerTier? tier,
    DateTime? hiredDate,
    int? retainerPaid,
    int? hoursUsed,
    List<String>? casesHandled,
    bool? isActive,
  }) {
    return LawyerRetainer(
      lawyerId: lawyerId ?? this.lawyerId,
      tier: tier ?? this.tier,
      hiredDate: hiredDate ?? this.hiredDate,
      retainerPaid: retainerPaid ?? this.retainerPaid,
      hoursUsed: hoursUsed ?? this.hoursUsed,
      casesHandled: casesHandled ?? List.from(this.casesHandled),
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lawyerId': lawyerId,
      'tier': tier.index,
      'hiredDate': hiredDate.millisecondsSinceEpoch,
      'retainerPaid': retainerPaid,
      'hoursUsed': hoursUsed,
      'casesHandled': casesHandled,
      'isActive': isActive,
    };
  }

  factory LawyerRetainer.fromJson(Map<String, dynamic> json) {
    return LawyerRetainer(
      lawyerId: json['lawyerId'],
      tier: LawyerTier.values[json['tier']],
      hiredDate: DateTime.fromMillisecondsSinceEpoch(json['hiredDate']),
      retainerPaid: json['retainerPaid'],
      hoursUsed: json['hoursUsed'] ?? 0,
      casesHandled: List<String>.from(json['casesHandled'] ?? []),
      isActive: json['isActive'] ?? true,
    );
  }
}

class LegalSystem {
  final int courtBalance;
  final LawyerRetainer? currentRetainer;
  final List<LawyerRetainer> retainerHistory;
  final Map<String, int> finesPaid;
  final Map<String, int> bailsPaid;
  final int totalLegalFees;

  const LegalSystem({
    this.courtBalance = 0,
    this.currentRetainer,
    this.retainerHistory = const [],
    this.finesPaid = const {},
    this.bailsPaid = const {},
    this.totalLegalFees = 0,
  });

  LegalSystem copyWith({
    int? courtBalance,
    LawyerRetainer? currentRetainer,
    List<LawyerRetainer>? retainerHistory,
    Map<String, int>? finesPaid,
    Map<String, int>? bailsPaid,
    int? totalLegalFees,
  }) {
    return LegalSystem(
      courtBalance: courtBalance ?? this.courtBalance,
      currentRetainer: currentRetainer,
      retainerHistory: retainerHistory ?? List.from(this.retainerHistory),
      finesPaid: finesPaid ?? Map.from(this.finesPaid),
      bailsPaid: bailsPaid ?? Map.from(this.bailsPaid),
      totalLegalFees: totalLegalFees ?? this.totalLegalFees,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courtBalance': courtBalance,
      'currentRetainer': currentRetainer?.toJson(),
      'retainerHistory': retainerHistory.map((r) => r.toJson()).toList(),
      'finesPaid': finesPaid,
      'bailsPaid': bailsPaid,
      'totalLegalFees': totalLegalFees,
    };
  }

  factory LegalSystem.fromJson(Map<String, dynamic> json) {
    return LegalSystem(
      courtBalance: json['courtBalance'] ?? 0,
      currentRetainer: json['currentRetainer'] != null
          ? LawyerRetainer.fromJson(json['currentRetainer'])
          : null,
      retainerHistory: (json['retainerHistory'] as List<dynamic>?)
              ?.map((r) => LawyerRetainer.fromJson(r))
              .toList() ??
          [],
      finesPaid: Map<String, int>.from(json['finesPaid'] ?? {}),
      bailsPaid: Map<String, int>.from(json['bailsPaid'] ?? {}),
      totalLegalFees: json['totalLegalFees'] ?? 0,
    );
  }
}
