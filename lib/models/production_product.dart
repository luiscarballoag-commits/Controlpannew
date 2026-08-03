import 'package:hive/hive.dart';

part 'production_product.g.dart';

@HiveType(typeId: 12)
class ProductionProduct extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String productionId;

  @HiveField(2)
  final String productName;

  @HiveField(3)
  final int quantity;

  @HiveField(4)
  final double extraCost;

  @HiveField(5)
  final DateTime date;

  ProductionProduct({
    required this.id,
    required this.productionId,
    required this.productName,
    required this.quantity,
    this.extraCost = 0,
    required this.date,
  });
}
