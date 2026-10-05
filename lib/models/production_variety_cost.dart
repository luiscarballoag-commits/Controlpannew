import 'package:hive/hive.dart';

part 'production_variety_cost.g.dart';

@HiveType(typeId: 25)
class ProductionVarietyCost extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String productionId;

  @HiveField(2)
  final String recipeId;

  @HiveField(3)
  final String productName;

  @HiveField(4)
  final int quantity;

  @HiveField(5)
  final double baseCostPerPiece;

  @HiveField(6)
  final double elaborationCostPerPiece;

  @HiveField(7)
  final double totalCostPerPiece;

  ProductionVarietyCost({
    required this.id,
    required this.productionId,
    required this.recipeId,
    required this.productName,
    required this.quantity,
    required this.baseCostPerPiece,
    required this.elaborationCostPerPiece,
    required this.totalCostPerPiece,
  });
}
