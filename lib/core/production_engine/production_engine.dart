// =======================================================
// CONTROLPAN
// Archivo: production_engine.dart
// Descripción:
// Motor principal de cálculo de producción.
// =======================================================

import 'ingredient.dart';
import 'production_result.dart';

class ProductionEngine {
  /// Calcula el peso total de la masa y la cantidad
  /// estimada de piezas según el peso indicado.
  ProductionResult calculate({
    required List<Ingredient> ingredients,
    required double pieceWeight,
  }) {
    // Suma el peso total de todos los ingredientes.
    double totalMass = 0;

    for (final ingredient in ingredients) {
      totalMass += ingredient.quantityInGrams;
    }

    // Calcula la cantidad de panes.
    final int totalPieces = (totalMass / pieceWeight).floor();

    return ProductionResult(
      totalMass: totalMass,
      pieceWeight: pieceWeight,
      totalPieces: totalPieces,
    );
  }
}
