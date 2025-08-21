import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';

enum DrugType {
  marijuana,
  cocaine,
  heroin,
  methamphetamine,
  ecstasy,
  lsd,
  fentanyl,
  synthetic,
}

enum IngredientType {
  chemical,
  organic,
  processed,
  equipment,
  precursor,
}

enum ProductionMethod {
  basic,
  advanced,
  industrial,
  laboratory,
  chemical,
}

enum QualityLevel {
  garbage,
  poor,
  average,
  good,
  excellent,
  pure,
}

class Ingredient {
  final String id;
  final String name;
  final IngredientType type;
  final double cost;
  final double purity;
  final double danger;
  final double rarity;
  final String supplier;
  final List<String> effects;
  final Map<String, double> properties;

  const Ingredient({
    required this.id,
    required this.name,
    required this.type,
    required this.cost,
    required this.purity,
    required this.danger,
    required this.rarity,
    required this.supplier,
    required this.effects,
    required this.properties,
  });
}

class Recipe {
  final String id;
  final DrugType drugType;
  final String name;
  final ProductionMethod method;
  final Map<String, double> ingredients; // ingredient_id -> quantity
  final double baseYield;
  final double basePurity;
  final double difficulty;
  final Duration productionTime;
  final double riskFactor;
  final List<String> equipment;
  final double expertiseRequired;

  const Recipe({
    required this.id,
    required this.drugType,
    required this.name,
    required this.method,
    required this.ingredients,
    required this.baseYield,
    required this.basePurity,
    required this.difficulty,
    required this.productionTime,
    required this.riskFactor,
    required this.equipment,
    required this.expertiseRequired,
  });
}

class ProductionBatch {
  final String id;
  final Recipe recipe;
  final Map<String, double> usedIngredients;
  final DateTime startTime;
  final Duration estimatedTime;
  final QualityLevel targetQuality;
  final double yieldMultiplier;
  final bool isActive;
  final double progress;

  const ProductionBatch({
    required this.id,
    required this.recipe,
    required this.usedIngredients,
    required this.startTime,
    required this.estimatedTime,
    required this.targetQuality,
    required this.yieldMultiplier,
    required this.isActive,
    required this.progress,
  });
}

class Lab {
  final String id;
  final String name;
  final Offset location;
  final double quality;
  final double safety;
  final double capacity;
  final List<String> equipment;
  final Map<ProductionMethod, double> methodEfficiency;
  final double heatLevel;
  final bool isActive;
  final List<String> activeBatches;

  const Lab({
    required this.id,
    required this.name,
    required this.location,
    required this.quality,
    required this.safety,
    required this.capacity,
    required this.equipment,
    required this.methodEfficiency,
    required this.heatLevel,
    required this.isActive,
    required this.activeBatches,
  });
}

class DrugManufacturingSystem {
  static final DrugManufacturingSystem _instance = DrugManufacturingSystem._internal();
  factory DrugManufacturingSystem() => _instance;
  DrugManufacturingSystem._internal();

  final Map<String, Ingredient> _ingredients = {};
  final Map<String, Recipe> _recipes = {};
  final Map<String, Lab> _labs = {};
  final Map<String, ProductionBatch> _activeBatches = {};
  final Map<String, double> _inventory = {}; // ingredient_id -> quantity
  final Map<DrugType, double> _expertise = {}; // player expertise levels
  Timer? _productionTimer;

  static const Map<String, Ingredient> _baseIngredients = {
    'ephedrine': Ingredient(
      id: 'ephedrine',
      name: 'Ephedrine',
      type: IngredientType.precursor,
      cost: 50.0,
      purity: 0.8,
      danger: 0.3,
      rarity: 0.7,
      supplier: 'pharmacy_theft',
      effects: ['stimulant_precursor'],
      properties: {'volatility': 0.2, 'detectability': 0.8},
    ),
    
    'pseudoephedrine': Ingredient(
      id: 'pseudoephedrine',
      name: 'Pseudoephedrine',
      type: IngredientType.precursor,
      cost: 30.0,
      purity: 0.7,
      danger: 0.2,
      rarity: 0.4,
      supplier: 'cold_medicine',
      effects: ['meth_precursor'],
      properties: {'volatility': 0.1, 'detectability': 0.6},
    ),
    
    'coca_paste': Ingredient(
      id: 'coca_paste',
      name: 'Coca Paste',
      type: IngredientType.organic,
      cost: 200.0,
      purity: 0.6,
      danger: 0.4,
      rarity: 0.9,
      supplier: 'south_american_cartel',
      effects: ['cocaine_base'],
      properties: {'volatility': 0.3, 'detectability': 0.9},
    ),
    
    'hydrochloric_acid': Ingredient(
      id: 'hydrochloric_acid',
      name: 'Hydrochloric Acid',
      type: IngredientType.chemical,
      cost: 25.0,
      purity: 0.9,
      danger: 0.8,
      rarity: 0.3,
      supplier: 'industrial_supplier',
      effects: ['acid_processing'],
      properties: {'volatility': 0.7, 'detectability': 0.4},
    ),
    
    'mdma_precursor': Ingredient(
      id: 'mdma_precursor',
      name: 'Safrole',
      type: IngredientType.precursor,
      cost: 150.0,
      purity: 0.75,
      danger: 0.5,
      rarity: 0.8,
      supplier: 'chemical_lab',
      effects: ['ecstasy_base'],
      properties: {'volatility': 0.4, 'detectability': 0.7},
    ),
    
    'cannabis_plants': Ingredient(
      id: 'cannabis_plants',
      name: 'Cannabis Plants',
      type: IngredientType.organic,
      cost: 10.0,
      purity: 0.9,
      danger: 0.1,
      rarity: 0.2,
      supplier: 'grow_house',
      effects: ['thc_content'],
      properties: {'volatility': 0.0, 'detectability': 0.3},
    ),
    
    'fentanyl_base': Ingredient(
      id: 'fentanyl_base',
      name: 'Fentanyl Precursor',
      type: IngredientType.precursor,
      cost: 500.0,
      purity: 0.95,
      danger: 0.95,
      rarity: 0.95,
      supplier: 'chinese_labs',
      effects: ['ultra_potent'],
      properties: {'volatility': 0.8, 'detectability': 0.9},
    ),
  };

  static const Map<String, Recipe> _baseRecipes = {
    'basic_meth': Recipe(
      id: 'basic_meth',
      drugType: DrugType.methamphetamine,
      name: 'Basic Methamphetamine',
      method: ProductionMethod.basic,
      ingredients: {
        'pseudoephedrine': 10.0,
        'hydrochloric_acid': 5.0,
      },
      baseYield: 8.0,
      basePurity: 0.6,
      difficulty: 0.3,
      productionTime: Duration(hours: 4),
      riskFactor: 0.5,
      equipment: ['basic_glassware', 'heating_element'],
      expertiseRequired: 0.2,
    ),
    
    'premium_meth': Recipe(
      id: 'premium_meth',
      drugType: DrugType.methamphetamine,
      name: 'Premium Crystal Meth',
      method: ProductionMethod.laboratory,
      ingredients: {
        'ephedrine': 15.0,
        'hydrochloric_acid': 8.0,
      },
      baseYield: 12.0,
      basePurity: 0.95,
      difficulty: 0.8,
      productionTime: Duration(hours: 8),
      riskFactor: 0.7,
      equipment: ['professional_glassware', 'precision_heating', 'ventilation'],
      expertiseRequired: 0.7,
    ),
    
    'cocaine_hcl': Recipe(
      id: 'cocaine_hcl',
      drugType: DrugType.cocaine,
      name: 'Cocaine Hydrochloride',
      method: ProductionMethod.chemical,
      ingredients: {
        'coca_paste': 20.0,
        'hydrochloric_acid': 10.0,
      },
      baseYield: 15.0,
      basePurity: 0.8,
      difficulty: 0.6,
      productionTime: Duration(hours: 6),
      riskFactor: 0.6,
      equipment: ['chemical_setup', 'filtration_system'],
      expertiseRequired: 0.5,
    ),
    
    'ecstasy_pills': Recipe(
      id: 'ecstasy_pills',
      drugType: DrugType.ecstasy,
      name: 'MDMA Pills',
      method: ProductionMethod.advanced,
      ingredients: {
        'mdma_precursor': 12.0,
        'hydrochloric_acid': 6.0,
      },
      baseYield: 100.0, // Pills
      basePurity: 0.7,
      difficulty: 0.7,
      productionTime: Duration(hours: 10),
      riskFactor: 0.8,
      equipment: ['pill_press', 'chemical_setup', 'drying_equipment'],
      expertiseRequired: 0.6,
    ),
    
    'high_grade_cannabis': Recipe(
      id: 'high_grade_cannabis',
      drugType: DrugType.marijuana,
      name: 'High-Grade Cannabis',
      method: ProductionMethod.basic,
      ingredients: {
        'cannabis_plants': 5.0,
      },
      baseYield: 4.0,
      basePurity: 0.9,
      difficulty: 0.2,
      productionTime: Duration(hours: 2),
      riskFactor: 0.2,
      equipment: ['drying_racks', 'trimming_tools'],
      expertiseRequired: 0.1,
    ),
    
    'synthetic_fentanyl': Recipe(
      id: 'synthetic_fentanyl',
      drugType: DrugType.fentanyl,
      name: 'Synthetic Fentanyl',
      method: ProductionMethod.laboratory,
      ingredients: {
        'fentanyl_base': 5.0,
        'hydrochloric_acid': 3.0,
      },
      baseYield: 4.0,
      basePurity: 0.98,
      difficulty: 0.95,
      productionTime: Duration(hours: 12),
      riskFactor: 0.95,
      equipment: ['advanced_lab', 'safety_equipment', 'precision_scale'],
      expertiseRequired: 0.9,
    ),
  };

  void initialize() {
    _ingredients.addAll(_baseIngredients);
    _recipes.addAll(_baseRecipes);
    _setupInitialLabs();
    _initializeExpertise();
    _startProductionTimer();
  }

  void dispose() {
    _productionTimer?.cancel();
  }

  void _setupInitialLabs() {
    final labs = [
      Lab(
        id: 'basement_lab',
        name: 'Basement Laboratory',
        location: const Offset(100, 200),
        quality: 0.4,
        safety: 0.3,
        capacity: 2.0,
        equipment: ['basic_glassware', 'heating_element'],
        methodEfficiency: {
          ProductionMethod.basic: 1.0,
          ProductionMethod.advanced: 0.6,
          ProductionMethod.laboratory: 0.3,
        },
        heatLevel: 0.2,
        isActive: true,
        activeBatches: [],
      ),
      
      Lab(
        id: 'warehouse_facility',
        name: 'Warehouse Production Facility',
        location: const Offset(300, 150),
        quality: 0.7,
        safety: 0.6,
        capacity: 5.0,
        equipment: ['professional_glassware', 'ventilation', 'chemical_setup'],
        methodEfficiency: {
          ProductionMethod.basic: 1.2,
          ProductionMethod.advanced: 1.0,
          ProductionMethod.industrial: 0.8,
          ProductionMethod.laboratory: 0.7,
        },
        heatLevel: 0.4,
        isActive: false,
        activeBatches: [],
      ),
    ];

    for (final lab in labs) {
      _labs[lab.id] = lab;
    }
  }

  void _initializeExpertise() {
    for (final drugType in DrugType.values) {
      _expertise[drugType] = 0.0;
    }
  }

  void _startProductionTimer() {
    _productionTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _updateProduction();
    });
  }

  void _updateProduction() {
    final now = DateTime.now();
    final completedBatches = <String>[];

    for (final batchId in _activeBatches.keys) {
      final batch = _activeBatches[batchId]!;
      final elapsed = now.difference(batch.startTime);
      final progress = elapsed.inMilliseconds / batch.estimatedTime.inMilliseconds;

      if (progress >= 1.0) {
        completedBatches.add(batchId);
        _completeBatch(batch);
      } else {
        // Update progress
        _activeBatches[batchId] = ProductionBatch(
          id: batch.id,
          recipe: batch.recipe,
          usedIngredients: batch.usedIngredients,
          startTime: batch.startTime,
          estimatedTime: batch.estimatedTime,
          targetQuality: batch.targetQuality,
          yieldMultiplier: batch.yieldMultiplier,
          isActive: batch.isActive,
          progress: progress.clamp(0.0, 1.0),
        );
      }
    }

    // Remove completed batches
    for (final batchId in completedBatches) {
      _activeBatches.remove(batchId);
    }
  }

  void _completeBatch(ProductionBatch batch) {
    final recipe = batch.recipe;
    
    // Calculate final yield and quality
    final random = math.Random();
    final skillBonus = _expertise[recipe.drugType]!;
    final qualityBonus = _getQualityBonus(batch.targetQuality);
    
    final finalYield = recipe.baseYield * batch.yieldMultiplier * (0.8 + skillBonus * 0.4);
    final finalPurity = (recipe.basePurity * qualityBonus * (0.9 + skillBonus * 0.1)).clamp(0.0, 1.0);
    
    // Add random factor
    final randomFactor = 0.8 + (random.nextDouble() * 0.4);
    final actualYield = finalYield * randomFactor;
    final actualPurity = finalPurity * (0.9 + random.nextDouble() * 0.2);

    // Increase expertise
    _expertise[recipe.drugType] = (_expertise[recipe.drugType]! + 0.05).clamp(0.0, 1.0);

    // Update inventory with produced drugs
    final drugKey = '${recipe.drugType.toString()}_${actualPurity.toStringAsFixed(2)}';
    _inventory[drugKey] = (_inventory[drugKey] ?? 0.0) + actualYield;

    debugPrint('Production completed: ${actualYield.toStringAsFixed(1)}g of ${recipe.name} (${(actualPurity * 100).toStringAsFixed(1)}% purity)');
  }

  double _getQualityBonus(QualityLevel quality) {
    switch (quality) {
      case QualityLevel.garbage:
        return 0.5;
      case QualityLevel.poor:
        return 0.7;
      case QualityLevel.average:
        return 1.0;
      case QualityLevel.good:
        return 1.3;
      case QualityLevel.excellent:
        return 1.6;
      case QualityLevel.pure:
        return 2.0;
    }
  }

  bool canStartProduction(String recipeId, String labId) {
    final recipe = _recipes[recipeId];
    final lab = _labs[labId];
    
    if (recipe == null || lab == null || !lab.isActive) return false;
    
    // Check lab capacity
    if (lab.activeBatches.length >= lab.capacity) return false;
    
    // Check ingredient availability
    for (final ingredientId in recipe.ingredients.keys) {
      final required = recipe.ingredients[ingredientId]!;
      final available = _inventory[ingredientId] ?? 0.0;
      if (available < required) return false;
    }
    
    // Check expertise requirement
    final expertise = _expertise[recipe.drugType] ?? 0.0;
    if (expertise < recipe.expertiseRequired) return false;
    
    // Check lab equipment
    for (final equipment in recipe.equipment) {
      if (!lab.equipment.contains(equipment)) return false;
    }
    
    return true;
  }

  String? startProduction(String recipeId, String labId, QualityLevel targetQuality) {
    if (!canStartProduction(recipeId, labId)) return null;
    
    final recipe = _recipes[recipeId]!;
    final lab = _labs[labId]!;
    
    // Consume ingredients
    for (final ingredientId in recipe.ingredients.keys) {
      final required = recipe.ingredients[ingredientId]!;
      _inventory[ingredientId] = (_inventory[ingredientId]! - required).clamp(0.0, double.infinity);
    }
    
    // Calculate production modifiers
    final labEfficiency = lab.methodEfficiency[recipe.method] ?? 0.5;
    final qualityTimeMultiplier = _getQualityTimeMultiplier(targetQuality);
    final skillTimeReduction = _expertise[recipe.drugType]! * 0.3;
    
    final finalTime = Duration(
      milliseconds: (recipe.productionTime.inMilliseconds * 
                    qualityTimeMultiplier * 
                    (1.0 - skillTimeReduction) / 
                    labEfficiency).round(),
    );
    
    final batchId = 'batch_${DateTime.now().millisecondsSinceEpoch}';
    final batch = ProductionBatch(
      id: batchId,
      recipe: recipe,
      usedIngredients: Map.from(recipe.ingredients),
      startTime: DateTime.now(),
      estimatedTime: finalTime,
      targetQuality: targetQuality,
      yieldMultiplier: labEfficiency,
      isActive: true,
      progress: 0.0,
    );
    
    _activeBatches[batchId] = batch;
    
    // Update lab
    final updatedBatches = List<String>.from(lab.activeBatches)..add(batchId);
    _labs[labId] = Lab(
      id: lab.id,
      name: lab.name,
      location: lab.location,
      quality: lab.quality,
      safety: lab.safety,
      capacity: lab.capacity,
      equipment: lab.equipment,
      methodEfficiency: lab.methodEfficiency,
      heatLevel: lab.heatLevel + recipe.riskFactor * 0.1,
      isActive: lab.isActive,
      activeBatches: updatedBatches,
    );
    
    return batchId;
  }

  double _getQualityTimeMultiplier(QualityLevel quality) {
    switch (quality) {
      case QualityLevel.garbage:
        return 0.5;
      case QualityLevel.poor:
        return 0.7;
      case QualityLevel.average:
        return 1.0;
      case QualityLevel.good:
        return 1.5;
      case QualityLevel.excellent:
        return 2.5;
      case QualityLevel.pure:
        return 4.0;
    }
  }

  void purchaseIngredients(String ingredientId, double quantity) {
    final ingredient = _ingredients[ingredientId];
    if (ingredient == null) return;
    
    final cost = ingredient.cost * quantity;
    // Assume player has money - in real game, check and deduct money
    
    _inventory[ingredientId] = (_inventory[ingredientId] ?? 0.0) + quantity;
    
    debugPrint('Purchased ${quantity}x ${ingredient.name} for \$${cost.toStringAsFixed(2)}');
  }

  void upgradeLab(String labId, String equipment) {
    final lab = _labs[labId];
    if (lab == null) return;
    
    final updatedEquipment = List<String>.from(lab.equipment);
    if (!updatedEquipment.contains(equipment)) {
      updatedEquipment.add(equipment);
      
      _labs[labId] = Lab(
        id: lab.id,
        name: lab.name,
        location: lab.location,
        quality: (lab.quality + 0.1).clamp(0.0, 1.0),
        safety: lab.safety,
        capacity: lab.capacity,
        equipment: updatedEquipment,
        methodEfficiency: lab.methodEfficiency,
        heatLevel: lab.heatLevel,
        isActive: lab.isActive,
        activeBatches: lab.activeBatches,
      );
    }
  }

  // Public interface
  List<Recipe> getAvailableRecipes() => _recipes.values.toList();
  List<Lab> getAvailableLabs() => _labs.values.where((lab) => lab.isActive).toList();
  List<ProductionBatch> getActiveBatches() => _activeBatches.values.toList();
  Map<String, double> getInventory() => Map.unmodifiable(_inventory);
  Map<DrugType, double> getExpertise() => Map.unmodifiable(_expertise);
  
  List<Ingredient> getAvailableIngredients() => _ingredients.values.toList();
  
  double getIngredientQuantity(String ingredientId) => _inventory[ingredientId] ?? 0.0;
  
  double getExpertiseLevel(DrugType drugType) => _expertise[drugType] ?? 0.0;
  
  List<String> getMissingIngredients(String recipeId) {
    final recipe = _recipes[recipeId];
    if (recipe == null) return [];
    
    final missing = <String>[];
    for (final ingredientId in recipe.ingredients.keys) {
      final required = recipe.ingredients[ingredientId]!;
      final available = _inventory[ingredientId] ?? 0.0;
      if (available < required) {
        missing.add(ingredientId);
      }
    }
    return missing;
  }
  
  double getLabHeatLevel(String labId) {
    final lab = _labs[labId];
    return lab?.heatLevel ?? 0.0;
  }
}

// Production status widget
class ProductionStatusWidget extends StatefulWidget {
  const ProductionStatusWidget({super.key});

  @override
  State<ProductionStatusWidget> createState() => _ProductionStatusWidgetState();
}

class _ProductionStatusWidgetState extends State<ProductionStatusWidget> {
  final DrugManufacturingSystem _manufacturing = DrugManufacturingSystem();
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    _manufacturing.initialize();
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
    final activeBatches = _manufacturing.getActiveBatches();
    final labs = _manufacturing.getAvailableLabs();
    
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
                Icons.science,
                color: Colors.green,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Production Status',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          Text(
            'Active Labs: ${labs.length}',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          Text(
            'Active Batches: ${activeBatches.length}',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          
          if (activeBatches.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Text(
              'Current Production:',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            ...activeBatches.map((batch) => Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    batch.recipe.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  LinearProgressIndicator(
                    value: batch.progress,
                    backgroundColor: Colors.grey[800],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getQualityColor(batch.targetQuality),
                    ),
                  ),
                  Text(
                    '${(batch.progress * 100).toStringAsFixed(1)}% complete',
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }

  Color _getQualityColor(QualityLevel quality) {
    switch (quality) {
      case QualityLevel.garbage:
        return Colors.brown;
      case QualityLevel.poor:
        return Colors.red;
      case QualityLevel.average:
        return Colors.orange;
      case QualityLevel.good:
        return Colors.yellow;
      case QualityLevel.excellent:
        return Colors.lightGreen;
      case QualityLevel.pure:
        return Colors.cyan;
    }
  }
}
