import 'package:hive/hive.dart';

import '../../models/ingredient_catalog.dart';
import '../../models/elaboration/consumption_item.dart';
import '../../models/inventory_movement.dart';

class ElaborationConsumptionService {
  final Box<IngredientCatalog> ingredientBox =
      Hive.box<IngredientCatalog>('ingredients');

  final Box<InventoryMovement> movementBox =
      Hive.box<InventoryMovement>('inventory_movements');

  Future<void> consume(
      List<ConsumptionItem> consumption,
  ) async {
    for (final entry in consumption) {
        final ingredientId = entry.ingredientId;
        final quantity = entry.quantity;

      final int index = ingredientBox.values.toList().indexWhere(
              (i) => i.id == ingredientId,
          );

      if (index == -1) continue;

      final ingredient = ingredientBox.getAt(index)!;

      final updated = ingredient.copyWith(
        stock: ingredient.stock - quantity,
      );

      await ingredientBox.putAt(index, updated);

      await movementBox.add(
        InventoryMovement(
          id: DateTime.now()
              .microsecondsSinceEpoch
              .toString(),
          date: DateTime.now(),
          ingredientId: ingredient.id,
          ingredientName: ingredient.name,
          quantity: quantity,
          unit: ingredient.unit,
          type: "SALIDA",
          reference: "ELABORACION",
          notes: "Consumo automático",
        ),
      );
    }
  }
}
