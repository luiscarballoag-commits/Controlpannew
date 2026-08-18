import '../core/cost_engine/cost_engine.dart';
import '../core/cost_engine/cost_item.dart';
import '../core/cost_engine/cost_result.dart';
import '../core/inventory/unit_converter.dart';

import '../models/ingredient_catalog.dart';
import '../models/recipe.dart';

import 'ingredient_service.dart';
import 'production_service.dart';
import 'recipe_service.dart';

class CostService {
  final IngredientService ingredientService = IngredientService();
  final ProductionService productionService = ProductionService();
  final RecipeService recipeService = RecipeService();

  /// Calcula el costo de la última producción registrada.
  CostResult? calculateLastProductionCost() {
    final production = productionService.getLastProduction();

    if (production == null) {
      return null;
    }

    final recipe = recipeService.getRecipeById(production.recipeId);

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

  /// Calcula el costo completo de una receta.
  ///
  /// El precio de cada ingrediente se obtiene a partir de:
  ///
  /// precio del envase / cantidad que contiene el envase
  ///
  /// Ejemplo:
  /// Harina:
  /// 1 saco = 45 kg
  /// precio = $50
  ///
  /// Costo por kg:
  /// 50 / 45 = $1.1111
  ///
  /// Si la receta utiliza 20 kg:
  /// 20 × 1.1111 = $22.22
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
    final inventory = ingredientService.getAllIngredients();

    final List<CostItem> items = [];

    for (final recipeIngredient in recipe.ingredients) {
      final ingredient = inventory.cast<IngredientCatalog?>().firstWhere(
        (item) => item?.id == recipeIngredient.ingredient.id,
        orElse: () => null,
      );

      if (ingredient == null) {
        continue;
      }

      final quantityUsed = recipeIngredient.quantity * lots;

      final quantityPerPackage = UnitConverter.normalize(
        quantity: 1,
        packageSize: ingredient.packageSize,
        packageUnit: ingredient.packageUnit,
        consumptionUnit: ingredient.unit,
      );

      if (quantityPerPackage <= 0) {
        continue;
      }

      final unitPrice = ingredient.purchasePrice;

      items.add(
        CostItem(
          name: ingredient.name,
          category: 'Materia Prima',
          amount: quantityUsed,
          unitPrice: unitPrice,
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
