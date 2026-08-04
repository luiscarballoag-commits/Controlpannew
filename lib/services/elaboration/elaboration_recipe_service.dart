import 'package:hive/hive.dart';

import '../../models/elaboration/elaboration_recipe.dart';

class ElaborationRecipeService {
  final Box<ElaborationRecipe> _box =
      Hive.box<ElaborationRecipe>(
    'elaboration_recipes',
  );

  List<ElaborationRecipe> getAllRecipes() {
    return _box.values.toList();
  }

  void saveRecipe(ElaborationRecipe recipe) {
    _box.put(recipe.id, recipe);
  }

  void updateRecipe(ElaborationRecipe recipe) {
    _box.put(recipe.id, recipe);
  }

  void deleteRecipe(String id) {
    _box.delete(id);
  }

  ElaborationRecipe? getRecipe(String id) {
    return _box.get(id);
  }
}
