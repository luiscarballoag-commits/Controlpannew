import 'package:hive/hive.dart';

import '../models/labor_worker.dart';

class LaborService {
  static const String boxName = 'labor_workers';

  static const double daysPerWeek = 6;
  static const double daysPerMonth = 26;

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

  /// Calcula el costo por hora de un trabajador
  /// según su período de pago y jornada diaria.
  double getHourlyCost(LaborWorker worker) {
    if (worker.hoursPerDay <= 0 || worker.cost < 0) {
      return 0;
    }

    switch (worker.period.toLowerCase()) {
      case 'hora':
      case 'por hora':
      case 'hour':
      case 'hourly':
        return worker.cost;

      case 'diario':
      case 'daily':
        return worker.cost / worker.hoursPerDay;

      case 'semanal':
      case 'weekly':
        return worker.cost / daysPerWeek / worker.hoursPerDay;

      case 'mensual':
      case 'monthly':
        return worker.cost / daysPerMonth / worker.hoursPerDay;

      default:
        return 0;
    }
  }

  /// Calcula el costo de un trabajador según las horas
  /// que participó en una producción específica.
  double getProductionLaborCost({
    required LaborWorker worker,
    required double hours,
  }) {
    if (hours <= 0) {
      return 0;
    }

    return getHourlyCost(worker) * hours;
  }

  List<LaborWorker> getActiveWorkers() {
    return _box.values
        .where((worker) => worker.active)
        .toList();
  }
}
