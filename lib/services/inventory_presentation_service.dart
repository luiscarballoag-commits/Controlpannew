import '../models/ingredient_catalog.dart';
import '../core/inventory/unit_converter.dart';

class InventoryPresentationService {
  static String formatStock(IngredientCatalog ingredient) {
    final stock = ingredient.normalizedStock;

    // Si no existe una configuración válida de compra,
    // mostramos directamente la unidad normalizada.
    if (ingredient.purchaseUnit.isEmpty ||
        ingredient.packageSize <= 0 ||
        ingredient.packageUnit.isEmpty ||
        ingredient.unit.isEmpty) {
      return "${stock.toStringAsFixed(2)} ${ingredient.unit}";
    }

    // Convertimos el stock normalizado (unidad de consumo)
    // a la unidad en la que se compra el ingrediente.
    final stockInPurchaseUnit = UnitConverter.normalize(
      quantity: stock,
      packageSize: 1,
      packageUnit: ingredient.unit,
      consumptionUnit: ingredient.packageUnit,
    );

    final fullPackages = stockInPurchaseUnit ~/ ingredient.packageSize;

    final remainder =
        stockInPurchaseUnit - (fullPackages * ingredient.packageSize);

    // Evitamos mostrar residuos diminutos causados por
    // operaciones de punto flotante.
    final cleanRemainder = remainder.abs() < 0.000001 ? 0 : remainder;

    if (cleanRemainder == 0) {
      return "$fullPackages ${ingredient.purchaseUnit}";
    }

    final remainderText = ingredient.packageUnit == "Unidad"
        ? cleanRemainder.toStringAsFixed(0)
        : cleanRemainder.toStringAsFixed(2);

    return "$fullPackages ${ingredient.purchaseUnit} + "
        "$remainderText ${ingredient.packageUnit}";
  }
}
