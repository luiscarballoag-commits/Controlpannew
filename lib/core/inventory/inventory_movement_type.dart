enum InventoryMovementType {
  purchase,
  entry,
  production,
  exit,
  adjustmentPositive,
  adjustmentNegative,
}

extension InventoryMovementTypeExtension on InventoryMovementType {
  String get label {
    switch (this) {
      case InventoryMovementType.purchase:
        return 'Compra';
      case InventoryMovementType.entry:
        return 'Entrada';
      case InventoryMovementType.production:
        return 'Producción';
      case InventoryMovementType.exit:
        return 'Salida';
      case InventoryMovementType.adjustmentPositive:
        return 'Ajuste +';
      case InventoryMovementType.adjustmentNegative:
        return 'Ajuste -';
    }
  }

  bool get increasesStock {
    switch (this) {
      case InventoryMovementType.purchase:
      case InventoryMovementType.entry:
      case InventoryMovementType.adjustmentPositive:
        return true;

      case InventoryMovementType.production:
      case InventoryMovementType.exit:
      case InventoryMovementType.adjustmentNegative:
        return false;
    }
  }
}
