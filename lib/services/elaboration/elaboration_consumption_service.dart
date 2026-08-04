import 'package:hive/hive.dart';

import '../../models/ingredient_catalog.dart';
import '../../models/inventory_movement.dart';

class ElaborationConsumptionService {
  final Box<IngredientCatalog> ingredientBox =
      Hive.box<IngredientCatalog>('ingredients');

  final Box<InventoryMovement> movementBox =
      Hive.box<InventoryMovement>('inventory_movements');

  Future<void> consume(
    Map<String, double> consumption,
  ) async {
    for (final entry in consumption.entries) {
      final ingredientName = entry.key;
      final quantity = entry.value;

      final int index = ingredientBox.values.toList().indexWhere(
            (i) => i.name == ingredientName,
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
