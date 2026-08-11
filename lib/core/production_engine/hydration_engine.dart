import 'ingredient.dart';

class HydrationEngine {
  double calculate(List<Ingredient> ingredients) {
    final flour = ingredients.firstWhere(
      (i) => i.name.toLowerCase() == 'harina',
    );

    final water = ingredients.firstWhere((i) => i.name.toLowerCase() == 'agua');

    return (water.quantityInGrams / flour.quantityInGrams) * 100;
  }
}
