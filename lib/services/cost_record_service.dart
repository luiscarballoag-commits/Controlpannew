import 'package:hive/hive.dart';

import '../models/cost_record.dart';
import 'production_service.dart';

class CostRecordService {
  static const String boxName = 'costs';

  Box<CostRecord> get _box => Hive.box<CostRecord>(boxName);

  List<CostRecord> getAllRecords() {
    return _box.values.toList().reversed.toList();
  }

  void addRecord(CostRecord record) {
    _box.add(record);
  }

  void updateRecord(int index, CostRecord record) {
    _box.putAt(index, record);
  }

  void deleteRecord(int index) {
    _box.deleteAt(index);
  }

  CostRecord? getRecord(int index) {
    if (index < 0 || index >= _box.length) {
      return null;
    }

    return _box.getAt(index);
  }

  List<CostRecord> getRecordsBetween(DateTime start, DateTime end) {
    return _box.values.where((record) {
      return !record.date.isBefore(start) && record.date.isBefore(end);
    }).toList();
  }

  CostRecord? getLastRecord() {
    if (_box.isEmpty) {
      return null;
    }

    return _box.getAt(_box.length - 1);
  }

  int get count => _box.length;

  bool get isEmpty => _box.isEmpty;

  bool get isNotEmpty => _box.isNotEmpty;

  void clear() {
    _box.clear();
  }

  void saveRecord(CostRecord record) {
    _box.add(record);
  }

  double? getAverageCostPerPieceForRecipeToday(String recipeName) {
    final productionService = ProductionService();

    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final startOfTomorrow = startOfDay.add(const Duration(days: 1));

    double weightedCost = 0.0;
    int totalPieces = 0;

    for (final record in _box.values) {
      if (record.recipeName.trim().toLowerCase() !=
          recipeName.trim().toLowerCase()) {
        continue;
      }

      if (record.date.isBefore(startOfDay) ||
          !record.date.isBefore(startOfTomorrow)) {
        continue;
      }

      final production =
          productionService.getProductionById(record.productionId);

      if (production == null || production.totalPieces <= 0) {
        continue;
      }

      weightedCost += record.costPerPiece * production.totalPieces;
      totalPieces += production.totalPieces;
    }

    if (totalPieces == 0) {
      return null;
    }

    return weightedCost / totalPieces;
  }
}
