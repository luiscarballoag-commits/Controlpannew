// =======================================================
// CONTROLPAN
// Archivo: production_manager.dart
// Descripción:
// Coordina todos los motores de producción.
// =======================================================

import '../../models/production.dart';
import '../../models/recipe.dart';
import '../../services/production_inventory_service.dart';
import '../../services/production_service.dart';

import '../production_engine/bakers_percentage.dart';
import '../production_engine/ingredient.dart';
import '../production_engine/production_engine.dart';
import '../production_engine/production_result.dart';
import '../production_engine/yield_engine.dart';

class ProductionManager {
  final ProductionEngine _productionEngine =
      ProductionEngine();

  final BakersPercentageEngine _bakersEngine =
      BakersPercentageEngine();


  final YieldEngine _yieldEngine =
      YieldEngine();

  final ProductionInventoryService _inventoryService =
      ProductionInventoryService();

  final ProductionService _productionService =
      ProductionService();

  ProductionResult calculateProduction({
    required List<Ingredient> ingredients,
    required double pieceWeight,
  }) {
    return _productionEngine.calculate(
      ingredients: ingredients,
      pieceWeight: pieceWeight,
    );
  }

  Map<String, double> calculatePercentages(
    List<Ingredient> ingredients,
  ) {
    return _bakersEngine.calculate(ingredients);
  }

  double calculateYield({
    required double totalMass,
    double bakingLoss = 10,
  }) {
    return _yieldEngine.calculate(
      totalMass: totalMass,
      bakingLoss: bakingLoss,
    );
  }

  Future<void> startProduction({
    required Recipe recipe,
    required int lots,
    required double totalMassKg,
    required double pieceWeightGrams,
    required int totalPieces,
    String notes = '',
  }) async {
    if (!_inventoryService.hasEnoughInventory(
      recipe: recipe,
      lots: lots.toDouble(),
    )) {
      throw Exception(
        'No hay suficiente inventario para producir.',
      );
    }

    _inventoryService.consumeIngredients(
      recipe: recipe,
      lots: lots.toDouble(),
    );

    final production = Production(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(),
      date: DateTime.now(),
      recipeId: recipe.id,
      recipeName: recipe.name,
      lots: lots,
      totalMassKg: totalMassKg,
      pieceWeightGrams: pieceWeightGrams,
      totalPieces: totalPieces,
      notes: notes,
    );

    _productionService.addProduction(
      production,
    );
  }

  Future<void> saveManualProduction({
    required double totalMassKg,
    required double pieceWeightGrams,
    required int totalPieces,
    String notes = '',
  }) async {
    final production = Production(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      recipeId: 'manual',
      recipeName: 'Producción Manual',
      lots: 1,
      totalMassKg: totalMassKg,
      pieceWeightGrams: pieceWeightGrams,
      totalPieces: totalPieces,
      notes: notes,
    );

    _productionService.addProduction(production);
  }
}
