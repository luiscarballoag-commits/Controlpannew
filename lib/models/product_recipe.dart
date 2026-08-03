import 'package:hive/hive.dart';

import 'recipe_ingredient.dart';

part 'product_recipe.g.dart';

@HiveType(typeId: 11)
class ProductRecipe extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final List<RecipeIngredient> ingredients;

  ProductRecipe({
    required this.id,
    required this.name,
    required this.ingredients,
  });

  ProductRecipe copyWith({
    String? id,
    String? name,
    List<RecipeIngredient>? ingredients,
  }) {
    return ProductRecipe(
      id: id ?? this.id,
      name: name ?? this.name,
      ingredients: ingredients ?? this.ingredients,
    );
  }
}
