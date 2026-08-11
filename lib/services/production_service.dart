import 'package:hive/hive.dart';

import '../models/production.dart';

class ProductionService {
  static const String boxName = 'productions';

  Box<Production> get _box => Hive.box<Production>(boxName);

  List<Production> getAllProductions() {
    return _box.values.toList().reversed.toList();
  }

  void addProduction(Production production) {
    _box.add(production);
  }

  Production? getProduction(int index) {
    if (index < 0 || index >= _box.length) {
      return null;
    }

    return _box.getAt(index);
  }

  int count() {
    return _box.length;
  }

  bool get isEmpty => _box.isEmpty;

  bool get isNotEmpty => _box.isNotEmpty;

  int get totalProductions => _box.length;

  Production? getLastProduction() {
    if (_box.isEmpty) {
      return null;
    }

    return _box.getAt(_box.length - 1);
  }

  List<Production> getLatestProductions({int limit = 10}) {
    final list = getAllProductions();

    if (list.length <= limit) {
      return list;
    }

    return list.take(limit).toList();
  }

  void deleteProduction(int index) {
    if (index >= 0 && index < _box.length) {
      _box.deleteAt(index);
    }
  }

  void clear() {
    _box.clear();
  }
}
