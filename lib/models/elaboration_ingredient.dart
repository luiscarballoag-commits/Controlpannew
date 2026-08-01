import 'package:hive/hive.dart';

part 'elaboration_ingredient.g.dart';

@HiveType(typeId: 10)
class ElaborationIngredient extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String elaborationId;

  @HiveField(2)
  String inventoryItemId;

  @HiveField(3)
  String ingredientName;

  @HiveField(4)
  double gramsPerPiece;

  ElaborationIngredient({
    required this.id,
    required this.elaborationId,
    required this.inventoryItemId,
    required this.ingredientName,
    required this.gramsPerPiece,
  });
}
