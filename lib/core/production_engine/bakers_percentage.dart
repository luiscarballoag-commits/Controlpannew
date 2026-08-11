import 'ingredient.dart';

class BakersPercentageEngine {
  Map<String, double> calculate(List<Ingredient> ingredients) {
    final flour = ingredients.firstWhere(
      (i) => i.name.toLowerCase() == 'harina',
      orElse: () =>
          throw Exception('Debe existir un ingrediente llamado Harina'),
    );

    final flourWeight = flour.quantityInGrams;

    final Map<String, double> percentages = {};

    for (final ingredient in ingredients) {
      percentages[ingredient.name] =
          (ingredient.quantityInGrams / flourWeight) * 100;
    }

    return percentages;
  }
}
