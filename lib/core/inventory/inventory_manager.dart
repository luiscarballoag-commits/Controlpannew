import '../../models/ingredient_catalog.dart';
import '../../models/inventory_movement.dart';
import '../../services/ingredient_service.dart';
import '../../services/inventory_movement_service.dart';
import 'unit_converter.dart';

class InventoryManager {
  final IngredientService _ingredientService = IngredientService();
  final InventoryMovementService _movementService = InventoryMovementService();

  /// Compra o entrada de inventario.
  Future<void> purchaseIngredient({
    required int index,
    required IngredientCatalog ingredient,
    required double quantity,
    required double purchasePrice,
    required String reference,
    String notes = '',
  }) async {
    final normalized = UnitConverter.normalize(
      quantity: quantity,
      packageSize: ingredient.packageSize,
      packageUnit: ingredient.packageUnit,
      consumptionUnit: ingredient.unit,
    );

    final updated = ingredient.copyWith(
      purchasePrice: purchasePrice,
      stock: ingredient.stock + quantity,
      normalizedStock: ingredient.normalizedStock + normalized,
    );

    _ingredientService.updateIngredient(index, updated);

    _movementService.addMovement(
      InventoryMovement(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: DateTime.now(),
        ingredientId: updated.id,
        ingredientName: updated.name,
        quantity: quantity,
        unit: updated.purchaseUnit,
        type: 'Entrada',
        reference: reference,
        purchasePrice: purchasePrice,
        notes: notes,
      ),
    );
  }

  /// Consumo o salida de inventario.
  Future<void> consumeIngredient({
    required int index,
    required IngredientCatalog ingredient,
    required double quantity,
    required String reason,
    String notes = '',
  }) async {
    if (quantity > ingredient.normalizedStock) {
      throw Exception('Stock insuficiente.');
    }

    final updated = ingredient.copyWith(
      normalizedStock: ingredient.normalizedStock - quantity,
    );

    _ingredientService.updateIngredient(index, updated);

    _movementService.addMovement(
      InventoryMovement(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: DateTime.now(),
        ingredientId: updated.id,
        ingredientName: updated.name,
        quantity: quantity,
        unit: ingredient.unit,
        type: 'Salida',
        reference: reason,
        notes: notes,
      ),
    );
  }

  double getCurrentStock(IngredientCatalog ingredient) {
    return ingredient.normalizedStock;
  }

  double getInventoryValue(List<IngredientCatalog> ingredients) {
    double total = 0;

    for (final ingredient in ingredients) {
      total += ingredient.normalizedStock * ingredient.purchasePrice;
    }

    return total;
  }
}
