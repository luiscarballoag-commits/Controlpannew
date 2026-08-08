// =======================================================
// CONTROLPAN
// Inventario Inteligente 2.0
// Catálogo de unidades permitidas.
// =======================================================

enum PurchaseUnit {
  sack,
  bag,
  box,
  package,
  bottle,
  drum,
  can,
  unit,
}

enum BaseUnit {
  grams,
  kilograms,
  milliliters,
  liters,
  units,
}

extension PurchaseUnitName on PurchaseUnit {
  String get label {
    switch (this) {
      case PurchaseUnit.sack:
        return 'Saco';
      case PurchaseUnit.bag:
        return 'Bolsa';
      case PurchaseUnit.box:
        return 'Caja';
      case PurchaseUnit.package:
        return 'Paquete';
      case PurchaseUnit.bottle:
        return 'Botella';
      case PurchaseUnit.drum:
        return 'Bidón';
      case PurchaseUnit.can:
        return 'Lata';
      case PurchaseUnit.unit:
        return 'Unidad';
    }
  }
}

extension BaseUnitName on BaseUnit {
  String get label {
    switch (this) {
      case BaseUnit.grams:
        return 'g';
      case BaseUnit.kilograms:
        return 'kg';
      case BaseUnit.milliliters:
        return 'ml';
      case BaseUnit.liters:
        return 'L';
      case BaseUnit.units:
        return 'Und';
    }
  }
}
