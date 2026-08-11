import 'package:hive/hive.dart';

import '../models/cost_record.dart';

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
}
