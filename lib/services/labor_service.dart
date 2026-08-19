import 'package:hive/hive.dart';

import '../models/labor_worker.dart';

class LaborService {
  static const String boxName = 'labor_workers';

  Box<LaborWorker> get _box =>
      Hive.box<LaborWorker>(boxName);

  List<LaborWorker> getAllWorkers() {
    return _box.values.toList();
  }

  void addWorker(LaborWorker worker) {
    _box.add(worker);
  }

  void updateWorker(int index, LaborWorker worker) {
    _box.putAt(index, worker);
  }

  void deleteWorker(int index) {
    _box.deleteAt(index);
  }

  LaborWorker? getWorker(int index) {
    if (index < 0 || index >= _box.length) {
      return null;
    }

    return _box.getAt(index);
  }

  double getTotalLaborCost() {
    double total = 0;

    for (final worker in _box.values) {
      if (worker.active) {
        total += worker.cost * worker.quantity;
      }
    }

    return total;
  }

  List<LaborWorker> getActiveWorkers() {
    return _box.values
        .where((worker) => worker.active)
        .toList();
  }
}
