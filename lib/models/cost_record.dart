import 'package:hive/hive.dart';

part 'cost_record.g.dart';

@HiveType(typeId: 8)
class CostRecord extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final String productionId;

  @HiveField(3)
  final String recipeName;

  @HiveField(4)
  final double rawMaterialCost;

  @HiveField(5)
  final double laborCost;

  @HiveField(6)
  final double operatingCost;

  @HiveField(7)
  final double depreciationCost;
  @HiveField(8)
  final double totalCost;

  @HiveField(9)
  final double costPerKg;

  @HiveField(10)
  final double costPerPiece;

  @HiveField(11)
  final double profitPercentage;

  @HiveField(12)
  final double suggestedSalePrice;

  CostRecord({
    required this.id,
    required this.date,
    required this.productionId,
    required this.recipeName,
    required this.rawMaterialCost,
    required this.laborCost,
    required this.operatingCost,
    required this.depreciationCost,
    required this.totalCost,
    required this.costPerKg,
    required this.costPerPiece,
    required this.profitPercentage,
    required this.suggestedSalePrice,
  });
}
