import '../../models/ingredient_catalog.dart';
import '../../models/inventory_movement.dart';
import '../../services/ingredient_service.dart';
import '../../services/inventory_movement_service.dart';
import 'unit_converter.dart';

class InventoryManager {
  final IngredientService _ingredientService = IngredientService();
  final InventoryMovementService _movementService =
      InventoryMovementService();

  /// Registra una compra y actualiza el costo promedio ponderado.
  ///
  /// El costo promedio se calcula sobre la unidad de consumo:
  ///
  /// Valor anterior + valor de la compra
  /// -----------------------------------
  /// Cantidad anterior + cantidad comprada
  Future<void> purchaseIngredient({
    required int index,
    required IngredientCatalog ingredient,
    required double quantity,
    required double purchasePrice,
    required String reference,
    String notes = '',
  }) async {
    if (quantity <= 0) {
      throw Exception('La cantidad de compra debe ser mayor que cero.');
    }

    if (purchasePrice < 0) {
      throw Exception('El precio de compra no puede ser negativo.');
    }

    final normalizedPurchase = UnitConverter.normalize(
      quantity: quantity,
      packageSize: ingredient.packageSize,
      packageUnit: ingredient.packageUnit,
      consumptionUnit: ingredient.unit,
    );

    if (normalizedPurchase <= 0) {
      throw Exception('La cantidad normalizada de la compra no es válida.');
    }

    final previousQuantity = ingredient.normalizedStock;

    final previousValue = previousQuantity * ingredient.purchasePrice;

    final purchaseValue = normalizedPurchase * purchasePrice;

    final totalQuantity = previousQuantity + normalizedPurchase;

    final averageCost = totalQuantity > 0
        ? (previousValue + purchaseValue) / totalQuantity
        : purchasePrice;

    final updated = ingredient.copyWith(
      // purchasePrice pasa a representar el costo promedio
      // por unidad de consumo.
      purchasePrice: averageCost,

      // Cantidad expresada en la unidad de compra.
      stock: ingredient.stock + quantity,

      // Cantidad normalizada en la unidad de consumo.
      normalizedStock: totalQuantity,
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

  /// Registra un consumo o salida de inventario.
  Future<void> consumeIngredient({
    required int index,
    required IngredientCatalog ingredient,
    required double quantity,
    required String reason,
    String notes = '',
  }) async {
    if (quantity <= 0) {
      throw Exception('La cantidad de consumo debe ser mayor que cero.');
    }

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
        purchasePrice: ingredient.purchasePrice,
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
