class ConsumptionItem {
  final String ingredientId;
  final String ingredientName;
  final double quantity;
  final String unit;

  const ConsumptionItem({
    required this.ingredientId,
    required this.ingredientName,
    required this.quantity,
    required this.unit,
  });

  ConsumptionItem copyWith({
    double? quantity,
  }) {
    return ConsumptionItem(
      ingredientId: ingredientId,
      ingredientName: ingredientName,
      quantity: quantity ?? this.quantity,
      unit: unit,
    );
  }
}
