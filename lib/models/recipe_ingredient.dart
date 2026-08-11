import 'package:hive/hive.dart';

import 'ingredient_catalog.dart';

part 'recipe_ingredient.g.dart';

@HiveType(typeId: 5)
class RecipeIngredient extends HiveObject {
  @HiveField(0)
  final IngredientCatalog ingredient;

  @HiveField(1)
  final double quantity;

  RecipeIngredient({required this.ingredient, required this.quantity});

  String get unit => ingredient.unit;

  String get name => ingredient.name;
}
