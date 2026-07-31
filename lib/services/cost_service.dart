import '../core/cost_engine/cost_engine.dart';
import '../core/cost_engine/cost_item.dart';
import '../core/cost_engine/cost_result.dart';

import '../models/ingredient_catalog.dart';
import '../models/recipe.dart';

import 'ingredient_service.dart';
import 'production_service.dart';
import 'recipe_service.dart';

class CostService {
  final IngredientService ingredientService =
      IngredientService();

  final ProductionService productionService =
      ProductionService();

  final RecipeService recipeService =
      RecipeService();

  CostResult? calculateLastProductionCost() {
    final production =
        productionService.getLastProduction();

    if (production == null) {
      return null;
    }

    final recipe =
        recipeService.getRecipeById(
      production.recipeId,
    );

    if (recipe == null) {
      return null;
    }

    return calculateRecipeCost(
      recipe: recipe,
      lots: production.lots.toDouble(),
      totalWeightKg: production.totalMassKg,
      totalUnits: production.totalPieces,
    );
  }

  CostResult calculateRecipeCost({
    required Recipe recipe,
    required double lots,
    required double totalWeightKg,
    required int totalUnits,
    double laborCost = 0,
    double operatingCost = 0,
    double depreciationCost = 0,
    double profitMargin = 30,
  }) {
    final inventory =
        ingredientService.getAllIngredients();

    final List<CostItem> items = [];

    for (final recipeIngredient
        in recipe.ingredients) {
      final IngredientCatalog? ingredient =
          inventory
              .cast<IngredientCatalog?>()
              .firstWhere(
        (item) =>
            item?.id ==
            recipeIngredient.ingredient.id,
        orElse: () => null,
      );

      if (ingredient == null) {
        continue;
      }

      final cantidad =
          recipeIngredient.quantity * lots;

      final precioUnitario =
          ingredient.normalizedStock > 0
              ? ingredient.purchasePrice /
                  ingredient.normalizedStock
              : 0.0;

      items.add(
        CostItem(
          name: ingredient.name,
          category: 'Materia Prima',
          amount: cantidad,
          unitPrice: precioUnitario,
        ),
      );
    }

    if (laborCost > 0) {
      items.add(
        CostItem(
          name: 'Mano de Obra',
          category: 'Mano de Obra',
          amount: 1,
          unitPrice: laborCost,
        ),
      );
    }

    if (operatingCost > 0) {
      items.add(
        CostItem(
          name: 'Gastos Operativos',
          category: 'Gastos',
          amount: 1,
          unitPrice: operatingCost,
        ),
      );
    }

    if (depreciationCost > 0) {
      items.add(
        CostItem(
          name: 'Depreciación',
          category: 'Depreciación',
          amount: 1,
          unitPrice: depreciationCost,
        ),
      );
    }

    return CostEngine.calculate(
      items: items,
      totalWeight: totalWeightKg,
      totalUnits: totalUnits,
      profitMargin: profitMargin,
    );
  }
}
