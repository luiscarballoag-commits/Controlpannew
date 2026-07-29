class UnitConverter {
  /// Convierte una cantidad a la unidad base.
  ///
  /// Ejemplos:
  /// 10 sacos × 45 kg = 450 kg
  /// 2 cajas × 5 kg = 10 kg
  /// 2 paquetes × 500 g = 1000 g
  static double normalize({
    required double quantity,
    required double packageSize,
  }) {
    return quantity * packageSize;
  }

  /// Convierte gramos a kilogramos.
  static double gramsToKg(double grams) {
    return grams / 1000;
  }

  /// Convierte kilogramos a gramos.
  static double kgToGrams(double kg) {
    return kg * 1000;
  }

  /// Convierte mililitros a litros.
  static double mlToLiters(double ml) {
    return ml / 1000;
  }

  /// Convierte litros a mililitros.
  static double litersToMl(double liters) {
    return liters * 1000;
  }
}
