import 'package:hive/hive.dart';

import 'elaboration_ingredient.dart';

part 'elaboration_recipe.g.dart';

@HiveType(typeId: 20)
class ElaborationRecipe extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  List<ElaborationIngredient> ingredients;

  ElaborationRecipe({
    required this.id,
    required this.name,
    required this.ingredients,
  });
}
