// =======================================================
// CONTROLPAN
// Archivo: production_result.dart
// Descripción:
// Modelo que almacena el resultado de una producción.
// =======================================================

class ProductionResult {
  /// Masa total en gramos.
  final double totalMass;

  /// Peso de cada pieza en gramos.
  final double pieceWeight;

  /// Cantidad estimada de panes.
  final int totalPieces;

  const ProductionResult({
    required this.totalMass,
    required this.pieceWeight,
    required this.totalPieces,
  });

  /// Masa total expresada en kilogramos.
  double get totalMassKg => totalMass / 1000;
}
