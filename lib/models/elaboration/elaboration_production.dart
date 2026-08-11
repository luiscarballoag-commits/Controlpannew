import 'package:hive/hive.dart';

part 'elaboration_production.g.dart';

@HiveType(typeId: 22)
class ElaborationProduction extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final String recipeId;

  @HiveField(3)
  final String recipeName;

  @HiveField(4)
  final int quantity;

  @HiveField(5)
  final String? productionId;

  ElaborationProduction({
    required this.id,
    required this.date,
    required this.recipeId,
    required this.recipeName,
    required this.quantity,
    this.productionId,
  });
}
