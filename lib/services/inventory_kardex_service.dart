import '../models/inventory_movement.dart';
import 'inventory_movement_service.dart';

class InventoryKardexService {
  final InventoryMovementService _movementService = InventoryMovementService();

  /// Total comprado (Entradas)
  double getTotalPurchased(String ingredientId) {
    double total = 0;

    final movements = _movementService.getAllMovements();

    for (final movement in movements) {
      if (movement.ingredientId == ingredientId && (movement.type == 'Entrada' || movement.type == 'Compra')) {
        total += movement.quantity;
      }
    }

    return total;
  }

  /// Total consumido (Salidas)
  double getTotalConsumed(String ingredientId) {
    double total = 0;

    final movements = _movementService.getAllMovements();

    for (final movement in movements) {
      if (movement.ingredientId == ingredientId && movement.type == 'Salida') {
        total += movement.quantity;
      }
    }

    return total;
  }

  /// Stock disponible
  double getAvailableStock(String ingredientId) {
    return getTotalPurchased(ingredientId) - getTotalConsumed(ingredientId);
  }

  /// Historial del ingrediente
  List<InventoryMovement> getHistory(String ingredientId) {
    final movements = _movementService.getAllMovements();

    return movements
        .where((movement) => movement.ingredientId == ingredientId)
        .toList();
  }
}
