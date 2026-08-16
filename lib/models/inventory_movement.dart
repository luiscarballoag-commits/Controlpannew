import 'package:hive/hive.dart';

part 'inventory_movement.g.dart';

@HiveType(typeId: 7)
class InventoryMovement extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final String ingredientId;

  @HiveField(3)
  final String ingredientName;

  @HiveField(4)
  final double quantity;

  @HiveField(5)
  final String unit;

  @HiveField(6)
  final String type;

  @HiveField(7)
  final String reference;

  @HiveField(8)
  final String notes;

  @HiveField(9)
  final double purchasePrice;

  InventoryMovement({
    required this.id,
    required this.date,
    required this.ingredientId,
    required this.ingredientName,
    required this.quantity,
    required this.unit,
    required this.type,
    required this.reference,
    this.notes = '',
    this.purchasePrice = 0,
  });
}
