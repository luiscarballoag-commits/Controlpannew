import 'package:hive_flutter/hive_flutter.dart';

import '../models/production_variety_cost.dart';

class ProductionVarietyCostService {
  static const String boxName = 'production_variety_costs';

  Box<ProductionVarietyCost> get box =>
      Hive.box<ProductionVarietyCost>(boxName);

  Future<void> save(ProductionVarietyCost cost) async {
    await box.put(cost.id, cost);
  }

  ProductionVarietyCost? getById(String id) {
    return box.get(id);
  }

  List<ProductionVarietyCost> getAll() {
    return box.values.toList();
  }

  List<ProductionVarietyCost> getByProduction(String productionId) {
    return box.values
        .where((item) => item.productionId == productionId)
        .toList();
  }

  ProductionVarietyCost? getByProductionAndRecipe(
    String productionId,
    String recipeId,
  ) {
    for (final item in box.values) {
      if (item.productionId == productionId && item.recipeId == recipeId) {
        return item;
      }
    }

    return null;
  }

  Future<void> deleteByProduction(String productionId) async {
    final keys = box.keys.where((key) {
      final item = box.get(key);
      return item?.productionId == productionId;
    }).toList();

    await box.deleteAll(keys);
  }
}
