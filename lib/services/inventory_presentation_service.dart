import '../models/ingredient_catalog.dart';

class InventoryPresentationService {
  static String formatStock(IngredientCatalog ingredient) {
    final stock = ingredient.normalizedStock;

    if (ingredient.purchaseUnit.isEmpty ||
        ingredient.packageSize <= 0 ||
        ingredient.packageUnit.isEmpty) {
      return "${stock.toStringAsFixed(2)} ${ingredient.unit}";
    }

    final fullPackages = stock ~/ ingredient.packageSize;
    final remainder = stock - (fullPackages * ingredient.packageSize);

    if (remainder == 0) {
      return "$fullPackages ${ingredient.purchaseUnit}";
    }

    String remainderText;

    if (ingredient.packageUnit == "Unidad") {
      remainderText = remainder.toStringAsFixed(0);
    } else {
      remainderText = remainder.toStringAsFixed(2);
    }

    return "$fullPackages ${ingredient.purchaseUnit} + $remainderText ${ingredient.packageUnit}";
  }
}
