import 'package:hive/hive.dart';

part 'elaboration_ingredient.g.dart';

@HiveType(typeId: 20)
class ElaborationIngredient extends HiveObject {
  @HiveField(0)
  final String ingredientId;

  @HiveField(1)
  final String ingredientName;

  @HiveField(2)
  final double quantity;

  @HiveField(3)
  final String unit;

  ElaborationIngredient({
    required this.ingredientId,
    required this.ingredientName,
    required this.quantity,
    required this.unit,
  });
}
