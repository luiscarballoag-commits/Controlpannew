import 'package:hive/hive.dart';

import '../models/product_elaboration.dart';

class ProductElaborationService {
  static const boxName = "product_elaborations";

  Box<ProductElaboration> get box =>
      Hive.box<ProductElaboration>(boxName);

  List<ProductElaboration> getByProduction(String productionId) {
    return box.values
        .where((e) => e.productionId == productionId)
        .toList();
  }

  void add(ProductElaboration item) {
    box.add(item);
  }

  int totalUsed(String productionId) {
    return getByProduction(productionId)
        .fold(
          0,
          (sum, e) => sum + e.quantity,
        );
  }
}
