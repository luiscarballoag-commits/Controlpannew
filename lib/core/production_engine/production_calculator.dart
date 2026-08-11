import 'production_result.dart';

class ProductionCalculator {
  static ProductionResult calculate({
    required double flourKg,
    required double waterLiters,
    required double sugarGrams,
    required double saltGrams,
    required double yeastGrams,
    required double fatGrams,
    required double butterGrams,
    required double pieceWeightGrams,
  }) {
    // Conversión a gramos
    final flour = flourKg * 1000;
    final water = waterLiters * 1000;

    // Masa total
    final totalMass =
        flour +
        water +
        sugarGrams +
        saltGrams +
        yeastGrams +
        fatGrams +
        butterGrams;

    // Cantidad de piezas
    final totalPieces = pieceWeightGrams > 0
        ? (totalMass / pieceWeightGrams).floor()
        : 0;

    return ProductionResult(
      totalMass: totalMass,
      pieceWeight: pieceWeightGrams,
      totalPieces: totalPieces,
    );
  }
}
