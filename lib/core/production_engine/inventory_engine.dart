import 'ingredient.dart';

class InventoryEngine {
  List<Ingredient> consume({
    required List<Ingredient> stock,
    required List<Ingredient> used,
  }) {
    final List<Ingredient> result = [];

    for (final item in stock) {
      final usedItem = used.where((u) => u.id == item.id);

      if (usedItem.isEmpty) {
        result.add(item);
        continue;
      }

      final consume = usedItem.first;

      result.add(item.copyWith(quantity: item.quantity - consume.quantity));
    }

    return result;
  }
}
