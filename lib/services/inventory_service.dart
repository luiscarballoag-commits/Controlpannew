import 'package:hive/hive.dart';

import '../models/ingredient_catalog.dart';
import '../core/inventory/unit_converter.dart';

class InventoryService {
  final Box<IngredientCatalog> _box =
      Hive.box<IngredientCatalog>('ingredients');

  List<IngredientCatalog> getAllItems() {
    return _box.values.toList();
  }

  double getInventoryValue() {
    double total = 0;

    for (final item in _box.values) {
      total += item.normalizedStock * item.purchasePrice;
    }

    return total;
  }

  int getTotalIngredients() {
    return _box.length;
  }

  List<IngredientCatalog> getLowStockItems() {
    return _box.values
        .where((item) => item.normalizedStock <= item.minimumStock)
        .toList();
  }

  /// Convierte una compra a la unidad base.
  ///
  /// Ejemplo:
  /// 10 sacos × 45 kg = 450 kg
  double calculateNormalizedStock({
    required double quantity,
    required double packageSize,
  }) {
    return UnitConverter.normalize(
      quantity: quantity,
      packageSize: packageSize,
      packageUnit: "kg",
      consumptionUnit: "kg",
    );
  }
}
