import '../models/ingredient_catalog.dart';
import '../models/inventory_movement.dart';
import '../core/inventory/unit_converter.dart';
import 'inventory_movement_service.dart';

class InventoryKardexService {
  final InventoryMovementService _movementService =
      InventoryMovementService();

  /// Total comprado convertido a la unidad de consumo.
  ///
  /// Ejemplo:
  /// 20 sacos × 45 kg = 900 kg.
  double getTotalPurchasedNormalized(IngredientCatalog ingredient) {
    double total = 0;

    final movements = _movementService.getAllMovements();

    for (final movement in movements) {
      if (movement.ingredientId != ingredient.id) {
        continue;
      }

      if (movement.type == 'Entrada' || movement.type == 'Compra') {
        total += UnitConverter.normalize(
          quantity: movement.quantity,
          packageSize: ingredient.packageSize,
          packageUnit: ingredient.packageUnit,
          consumptionUnit: ingredient.unit,
        );
      }
    }

    return total;
  }

  /// Total consumido en la unidad de consumo.
  ///
  /// Se reconocen las salidas provenientes de:
  /// - Inventario manual
  /// - Producción
  /// - Elaboración
  double getTotalConsumedNormalized(IngredientCatalog ingredient) {
    double total = 0;

    final movements = _movementService.getAllMovements();

    for (final movement in movements) {
      if (movement.ingredientId != ingredient.id) {
        continue;
      }

      final type = movement.type.trim().toLowerCase();

      if (type == 'salida' || type == 'consumo') {
        total += movement.quantity;
      }
    }

    return total;
  }

  /// Stock disponible calculado mediante movimientos.
  double getAvailableStockNormalized(IngredientCatalog ingredient) {
    return getTotalPurchasedNormalized(ingredient) -
        getTotalConsumedNormalized(ingredient);
  }

  /// Último precio de compra registrado para el ingrediente.
  ///
  /// Se busca primero en los movimientos históricos.
  /// Si no existe un precio válido, se utiliza el precio
  /// actualmente registrado en el ingrediente.
  double getLastPurchasePrice(IngredientCatalog ingredient) {
    final movements = _movementService.getAllMovements();

    for (final movement in movements) {
      if (movement.ingredientId != ingredient.id) {
        continue;
      }

      final type = movement.type.trim().toLowerCase();

      if ((type == 'entrada' || type == 'compra') &&
          movement.purchasePrice > 0) {
        return movement.purchasePrice;
      }
    }

    return ingredient.purchasePrice;
  }

  /// Historial del ingrediente.
  List<InventoryMovement> getHistory(String ingredientId) {
    final movements = _movementService.getAllMovements();

    return movements
        .where((movement) => movement.ingredientId == ingredientId)
        .toList();
  }
}
