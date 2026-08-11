import 'package:hive/hive.dart';

import '../models/inventory_movement.dart';

class InventoryMovementService {
  final Box<InventoryMovement> _box = Hive.box<InventoryMovement>(
    'inventory_movements',
  );

  List<InventoryMovement> getAllMovements() {
    return _box.values.toList().reversed.toList();
  }

  void addMovement(InventoryMovement movement) {
    _box.add(movement);
  }

  void deleteMovement(String id) {
    final index = _box.values.toList().indexWhere((e) => e.id == id);

    if (index != -1) {
      _box.deleteAt(index);
    }
  }

  void clear() {
    _box.clear();
  }
}
