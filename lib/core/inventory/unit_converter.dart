class UnitConverter {
  /// Convierte una cantidad comprada a la unidad de consumo.
  ///
  /// Ejemplos:
  /// 1 saco × 30 kg = 30000 g
  /// 2 cajas × 5 kg = 10000 g
  /// 2 paquetes × 500 g = 1000 g
  /// 1 bidón × 18 L = 18 L
  static double normalize({
    required double quantity,
    required double packageSize,
    required String packageUnit,
    required String consumptionUnit,
  }) {
    double value = quantity * packageSize;

    // Kilogramos <-> gramos
    if (packageUnit == 'kg' && consumptionUnit == 'g') {
      value *= 1000;
    } else if (packageUnit == 'g' && consumptionUnit == 'kg') {
      value /= 1000;
    }
    // Litros <-> mililitros
    else if (packageUnit == 'L' && consumptionUnit == 'mL') {
      value *= 1000;
    } else if (packageUnit == 'mL' && consumptionUnit == 'L') {
      value /= 1000;
    }

    // Si las unidades son iguales (kg→kg, g→g, L→L, unidad→unidad)
    // simplemente devuelve el valor calculado.
    return value;
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
