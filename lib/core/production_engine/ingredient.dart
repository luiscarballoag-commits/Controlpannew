// =======================================================
// CONTROLPAN
// Archivo: ingredient.dart
// Descripción:
// Modelo que representa un ingrediente utilizado en una
// producción de pan.
// =======================================================

/// Unidades soportadas por ControlPan.
enum UnitType { grams, kilograms, milliliters, liters, units }

/// Modelo de un ingrediente.
class Ingredient {
  final String id;
  final String name;
  final double quantity;
  final UnitType unit;

  const Ingredient({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
  });

  /// Convierte la cantidad a gramos cuando es posible.
  double get quantityInGrams {
    switch (unit) {
      case UnitType.grams:
        return quantity;

      case UnitType.kilograms:
        return quantity * 1000;

      case UnitType.milliliters:
        return quantity;

      case UnitType.liters:
        return quantity * 1000;

      case UnitType.units:
        return quantity;
    }
  }

  /// Permite crear una copia del ingrediente modificando
  /// únicamente los campos necesarios.
  Ingredient copyWith({
    String? id,
    String? name,
    double? quantity,
    UnitType? unit,
  }) {
    return Ingredient(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
    );
  }
}
