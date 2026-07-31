import 'package:hive/hive.dart';

import '../models/recipe.dart';

class RecipeService {
  final Box<Recipe> _box = Hive.box<Recipe>('recipes');

  List<Recipe> getAllRecipes() {
    return _box.values.toList();
  }

  void addRecipe(Recipe recipe) {
    _box.add(recipe);
  }

  void updateRecipe(int index, Recipe recipe) {
    _box.putAt(index, recipe);
  }

  void deleteRecipe(int index) {
    _box.deleteAt(index);
  }

  Recipe? getRecipe(int index) {
    if (index < 0 || index >= _box.length) {
      return null;
    }

    return _box.getAt(index);
  }

  int get count => _box.length;

  bool get isEmpty => _box.isEmpty;

  bool get isNotEmpty => _box.isNotEmpty;

  Recipe? getRecipeById(String id) {
    try {
      return _box.values.firstWhere(
        (recipe) => recipe.id == id,
      );
    } catch (_) {
      return null;
    }
  }

  void clear() {
    _box.clear();
  }
}
