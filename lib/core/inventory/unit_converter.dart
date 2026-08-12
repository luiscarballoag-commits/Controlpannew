class UnitConverter {
  /// Convierte una cantidad de envases a la unidad de consumo.
  ///
  /// Ejemplos:
  /// 1 saco × 30 kg = 30 kg
  /// 1 saco × 30 kg = 30000 g
  /// 2 paquetes × 500 g = 1000 g
  /// 1 bidón × 18 L = 18 L
  /// 1 botella × 500 ml = 0.5 L
  static double normalize({
    required double quantity,
    required double packageSize,
    required String packageUnit,
    required String consumptionUnit,
  }) {
    final normalizedPackageUnit = packageUnit.trim().toLowerCase();
    final normalizedConsumptionUnit = consumptionUnit.trim().toLowerCase();

    double value = quantity * packageSize;

    // Peso: kg ↔ g
    if (normalizedPackageUnit == 'kg' &&
        normalizedConsumptionUnit == 'g') {
      value *= 1000;
    } else if (normalizedPackageUnit == 'g' &&
        normalizedConsumptionUnit == 'kg') {
      value /= 1000;
    }

    // Volumen: L ↔ ml
    else if (normalizedPackageUnit == 'l' &&
        normalizedConsumptionUnit == 'ml') {
      value *= 1000;
    } else if (normalizedPackageUnit == 'ml' &&
        normalizedConsumptionUnit == 'l') {
      value /= 1000;
    }

    return value;
  }

  static double gramsToKg(double grams) {
    return grams / 1000;
  }

  static double kgToGrams(double kg) {
    return kg * 1000;
  }

  static double mlToLiters(double ml) {
    return ml / 1000;
  }

  static double litersToMl(double liters) {
    return liters * 1000;
  }
}
