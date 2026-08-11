import 'package:hive/hive.dart';

import '../models/production_elaboration.dart';

class ElaborationService {
  static const String boxName = 'elaborations';

  Box<ProductionElaboration> get _box =>
      Hive.box<ProductionElaboration>(boxName);

  List<ProductionElaboration> getAll() {
    return _box.values.toList();
  }

  List<ProductionElaboration> getByProduction(String productionId) {
    return _box.values
        .where((item) => item.productionId == productionId)
        .toList();
  }

  void add(ProductionElaboration elaboration) {
    _box.add(elaboration);
  }

  void update(int index, ProductionElaboration elaboration) {
    _box.putAt(index, elaboration);
  }

  void delete(int index) {
    _box.deleteAt(index);
  }

  void clear() {
    _box.clear();
  }
}
