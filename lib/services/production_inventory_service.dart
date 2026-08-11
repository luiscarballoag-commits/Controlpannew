import 'package:hive/hive.dart';

import '../models/ingredient_catalog.dart';
import '../models/inventory_movement.dart';
import '../models/recipe.dart';
import 'inventory_movement_service.dart';

class ProductionInventoryService {
  final Box<IngredientCatalog> _ingredientsBox = Hive.box<IngredientCatalog>(
    'ingredients',
  );

  final InventoryMovementService movementService = InventoryMovementService();

  bool hasEnoughInventory({required Recipe recipe, required double lots}) {
    for (final item in recipe.ingredients) {
      final ingredient = _ingredientsBox.values.firstWhere(
        (e) => e.id == item.ingredient.id,
        orElse: () => item.ingredient,
      );

      final requiredQuantity = item.quantity * lots;

      if (ingredient.normalizedStock < requiredQuantity) {
        return false;
      }
    }

    return true;
  }

  void consumeIngredients({required Recipe recipe, required double lots}) {
    for (final item in recipe.ingredients) {
      final index = _ingredientsBox.values.toList().indexWhere(
        (ingredient) => ingredient.id == item.ingredient.id,
      );

      if (index == -1) {
        continue;
      }

      final ingredient = _ingredientsBox.getAt(index);

      if (ingredient == null) {
        continue;
      }

      final consumed = item.quantity * lots;

      final updatedIngredient = ingredient.copyWith(
        normalizedStock: ingredient.normalizedStock - consumed,
      );

      _ingredientsBox.putAt(index, updatedIngredient);

      movementService.addMovement(
        InventoryMovement(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          date: DateTime.now(),
          ingredientId: ingredient.id,
          ingredientName: ingredient.name,
          quantity: consumed,
          unit: ingredient.unit,
          type: 'Consumo',
          reference: recipe.name,
          notes: 'Producción Inteligente',
        ),
      );
    }
  }

  void consumeSingleIngredient({
    required String ingredientId,
    required double quantity,
    required String reference,
  }) {
    final index = _ingredientsBox.values.toList().indexWhere(
      (ingredient) => ingredient.id == ingredientId,
    );

    if (index == -1) {
      return;
    }

    final ingredient = _ingredientsBox.getAt(index);

    if (ingredient == null) {
      return;
    }

    final updatedIngredient = ingredient.copyWith(
      normalizedStock: ingredient.normalizedStock - quantity,
    );

    _ingredientsBox.putAt(index, updatedIngredient);

    movementService.addMovement(
      InventoryMovement(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        date: DateTime.now(),
        ingredientId: ingredient.id,
        ingredientName: ingredient.name,
        quantity: quantity,
        unit: ingredient.unit,
        type: 'Consumo',
        reference: reference,
        notes: 'Elaboración de productos',
      ),
    );
  }
}
