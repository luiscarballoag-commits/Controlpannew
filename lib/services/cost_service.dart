import '../core/cost_engine/cost_engine.dart';
import '../core/cost_engine/cost_item.dart';
import '../core/cost_engine/cost_result.dart';
import '../core/inventory/unit_converter.dart';

import '../models/ingredient_catalog.dart';
import '../models/recipe.dart';
import '../models/elaboration/elaboration_recipe.dart';

import 'ingredient_service.dart';
import 'production_service.dart';
import 'recipe_service.dart';
import 'elaboration/elaboration_production_service.dart';
import 'elaboration/elaboration_recipe_service.dart';

class CostService {
  final IngredientService ingredientService = IngredientService();
  final ProductionService productionService = ProductionService();
  final RecipeService recipeService = RecipeService();
  final ElaborationProductionService elaborationProductionService =
      ElaborationProductionService();
  final ElaborationRecipeService elaborationRecipeService =
      ElaborationRecipeService();

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
      productionId: production.id,
    );
  }

  /// Calcula el costo completo de una receta.
  ///
  /// Si se proporciona [productionId], también incorpora la materia prima
  /// utilizada por las elaboraciones asociadas a esa producción.
  CostResult calculateRecipeCost({
    required Recipe recipe,
    required double lots,
    required double totalWeightKg,
    required int totalUnits,
    String? productionId,
    double laborCost = 0,
    double operatingCost = 0,
    double depreciationCost = 0,
    double profitMargin = 30,
  }) {
    final inventory = ingredientService.getAllIngredients();

    final List<CostItem> items = [];

    // ============================================================
    // MATERIA PRIMA DE LA RECETA PRINCIPAL
    // ============================================================

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

      final unitPrice = ingredient.purchasePrice / quantityPerPackage;

      items.add(
        CostItem(
          name: ingredient.name,
          category: 'Materia Prima',
          amount: quantityUsed,
          unitPrice: unitPrice,
        ),
      );
    }

    // ============================================================
    // MATERIA PRIMA DE LAS ELABORACIONES
    // ============================================================

    if (productionId != null && productionId.isNotEmpty) {
      final elaborations = elaborationProductionService
          .getAll()
          .where((production) => production.productionId == productionId)
          .toList();

      for (final elaboration in elaborations) {
        final ElaborationRecipe? elaborationRecipe =
            elaborationRecipeService.getRecipe(elaboration.recipeId);

        if (elaborationRecipe == null) {
          continue;
        }

        for (final elaborationIngredient
            in elaborationRecipe.ingredients) {
          final ingredient = inventory.cast<IngredientCatalog?>().firstWhere(
            (item) => item?.id == elaborationIngredient.ingredientId,
            orElse: () => null,
          );

          if (ingredient == null) {
            continue;
          }

          final quantityUsed =
              elaborationIngredient.quantity * elaboration.quantity;

          final quantityPerPackage = UnitConverter.normalize(
            quantity: 1,
            packageSize: ingredient.packageSize,
            packageUnit: ingredient.packageUnit,
            consumptionUnit: elaborationIngredient.unit,
          );

          if (quantityPerPackage <= 0) {
            continue;
          }

          final unitPrice = ingredient.purchasePrice / quantityPerPackage;

          items.add(
            CostItem(
              name: '${ingredient.name} (Elaboración)',
              category: 'Elaboraciones',
              amount: quantityUsed,
              unitPrice: unitPrice,
            ),
          );
        }
      }
    }

    // ============================================================
    // MANO DE OBRA
    // ============================================================

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

    // ============================================================
    // GASTOS OPERATIVOS
    // ============================================================

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

    // ============================================================
    // DEPRECIACIÓN
    // ============================================================

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
