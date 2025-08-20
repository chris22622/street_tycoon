class MarketSpecialization {
  final String area;
  final String specialty;
  final String description;
  final String icon;
  final Map<String, double> priceModifiers;
  final Map<String, double> demandModifiers;
  final List<String> exclusiveItems;
  final Map<String, dynamic> areaBonus;

  const MarketSpecialization({
    required this.area,
    required this.specialty,
    required this.description,
    required this.icon,
    required this.priceModifiers,
    required this.demandModifiers,
    this.exclusiveItems = const [],
    this.areaBonus = const {},
  });
}

class MarketSpecializationService {
  static List<MarketSpecialization> getSpecializations() {
    return [
      const MarketSpecialization(
        area: 'Downtown',
        specialty: 'Business District',
        description: 'High-end clientele with deep pockets',
        icon: '🏢',
        priceModifiers: {
          'Weed': 1.2,
          'Cocaine': 1.3,
          'Heroin': 1.1,
        },
        demandModifiers: {
          'Weed': 0.8,
          'Cocaine': 1.4,
          'Heroin': 0.7,
        },
        areaBonus: {
          'heatResistance': 10,
          'cashMultiplier': 1.1,
        },
      ),
      
      const MarketSpecialization(
        area: 'Suburbs',
        specialty: 'Family Neighborhood',
        description: 'Steady demand but lower heat tolerance',
        icon: '🏡',
        priceModifiers: {
          'Weed': 1.1,
          'Speed': 1.2,
          'Cocaine': 0.9,
        },
        demandModifiers: {
          'Weed': 1.3,
          'Speed': 1.1,
          'Cocaine': 0.8,
        },
        areaBonus: {
          'heatPenalty': 15,
          'safetyBonus': true,
        },
      ),
      
      const MarketSpecialization(
        area: 'University',
        specialty: 'Student Hub',
        description: 'High volume, party-focused market',
        icon: '🎓',
        priceModifiers: {
          'Weed': 0.9,
          'Speed': 1.1,
          'Ecstasy': 1.3,
        },
        demandModifiers: {
          'Weed': 1.5,
          'Speed': 1.2,
          'Ecstasy': 1.6,
        },
        exclusiveItems: ['Party Mix'],
        areaBonus: {
          'bulkDiscount': 0.05,
          'weekendBonus': 1.4,
        },
      ),
      
      const MarketSpecialization(
        area: 'Industrial',
        specialty: 'Blue Collar',
        description: 'Working class area with specific preferences',
        icon: '🏭',
        priceModifiers: {
          'Speed': 1.2,
          'Cocaine': 0.8,
          'Heroin': 1.3,
        },
        demandModifiers: {
          'Speed': 1.4,
          'Cocaine': 0.7,
          'Heroin': 1.1,
        },
        areaBonus: {
          'morningPenalty': 0.7,
          'eveningBonus': 1.3,
        },
      ),
      
      const MarketSpecialization(
        area: 'Ghetto',
        specialty: 'Street Market',
        description: 'High risk, high reward territory',
        icon: '🌃',
        priceModifiers: {
          'Heroin': 1.4,
          'Crack': 1.5,
          'Weed': 0.8,
        },
        demandModifiers: {
          'Heroin': 1.3,
          'Crack': 1.4,
          'Weed': 1.1,
        },
        exclusiveItems: ['Street Special'],
        areaBonus: {
          'dangerBonus': 1.2,
          'heatMultiplier': 1.5,
        },
      ),
      
      const MarketSpecialization(
        area: 'Uptown',
        specialty: 'Elite District',
        description: 'Luxury market with premium prices',
        icon: '💎',
        priceModifiers: {
          'Cocaine': 1.6,
          'Heroin': 1.2,
          'Weed': 1.3,
        },
        demandModifiers: {
          'Cocaine': 1.2,
          'Heroin': 0.8,
          'Weed': 0.9,
        },
        exclusiveItems: ['Premium Blend'],
        areaBonus: {
          'luxuryTax': 50,
          'premiumClientele': true,
        },
      ),
    ];
  }
  
  static MarketSpecialization? getSpecializationForArea(String area) {
    final specializations = getSpecializations();
    try {
      return specializations.firstWhere((spec) => spec.area == area);
    } catch (e) {
      return null;
    }
  }
  
  static double getAreaPriceModifier(String area, String item) {
    final spec = getSpecializationForArea(area);
    if (spec == null) return 1.0;
    
    return spec.priceModifiers[item] ?? 1.0;
  }
  
  static double getAreaDemandModifier(String area, String item) {
    final spec = getSpecializationForArea(area);
    if (spec == null) return 1.0;
    
    return spec.demandModifiers[item] ?? 1.0;
  }
  
  static List<String> getExclusiveItems(String area) {
    final spec = getSpecializationForArea(area);
    if (spec == null) return [];
    
    return spec.exclusiveItems;
  }
  
  static Map<String, dynamic> getAreaBonus(String area) {
    final spec = getSpecializationForArea(area);
    if (spec == null) return {};
    
    return spec.areaBonus;
  }
}
