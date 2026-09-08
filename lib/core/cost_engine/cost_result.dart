class CostResult {
  final double rawMaterialCost;
  final double elaborationCost;
  final double productionCost;
  final double laborCost;
  final double operatingCost;
  final double depreciationCost;

  final double totalCost;

  final double totalWeight;

  final int totalUnits;

  final double costPerKg;

  final double costPerUnit;

  final double suggestedSalePrice;

  final double profitMargin;

  const CostResult({
    required this.rawMaterialCost,
    required this.elaborationCost,
    required this.productionCost,
    required this.laborCost,
    required this.operatingCost,
    required this.depreciationCost,
    required this.totalCost,
    required this.totalWeight,
    required this.totalUnits,
    required this.costPerKg,
    required this.costPerUnit,
    required this.suggestedSalePrice,
    required this.profitMargin,
  });
}
