import 'package:hive/hive.dart';

import '../models/ingredient_catalog.dart';

class IngredientService {
  static const String boxName = 'ingredients';

  Box<IngredientCatalog> get _box => Hive.box<IngredientCatalog>(boxName);

  List<IngredientCatalog> getAllIngredients() {
    return _box.values.toList();
  }

  void addIngredient(IngredientCatalog ingredient) {
    _box.add(ingredient);
  }

  void updateIngredient(int index, IngredientCatalog ingredient) {
    _box.putAt(index, ingredient);
  }

  void deleteIngredient(int index) {
    _box.deleteAt(index);
  }

  IngredientCatalog? getIngredient(int index) {
    if (index < 0 || index >= _box.length) {
      return null;
    }

    return _box.getAt(index);
  }

  int count() {
    return _box.length;
  }

  bool get isEmpty => _box.isEmpty;

  bool get isNotEmpty => _box.isNotEmpty;

  void clear() {
    _box.clear();
  }
}
