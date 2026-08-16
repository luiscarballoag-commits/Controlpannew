import 'cost_item.dart';
import 'cost_result.dart';

class CostEngine {
  static CostResult calculate({
    required List<CostItem> items,
    required double totalWeight,
    required int totalUnits,
    double profitMargin = 30.0,
  }) {
    double rawMaterial = 0.0;
    double production = 0.0;
    double labor = 0.0;
    double operating = 0.0;
    double depreciation = 0.0;

    for (final item in items) {
      switch (item.category) {
        case 'Materia Prima':
          rawMaterial += item.total;
          break;

        case 'Producción':
          production += item.total;
          break;

        case 'Mano de Obra':
          labor += item.total;
          break;

        case 'Gastos':
          operating += item.total;
          break;

        case 'Depreciación':
          depreciation += item.total;
          break;
      }
    }

    final double totalCost =
        rawMaterial + production + labor + operating + depreciation;

    final double costPerKg = totalWeight > 0 ? totalCost / totalWeight : 0.0;

    final double costPerUnit = totalUnits > 0 ? totalCost / totalUnits : 0.0;

    final double suggestedSalePrice =
        costPerUnit * (1.0 + profitMargin / 100.0);

    return CostResult(
      rawMaterialCost: rawMaterial,
      productionCost: production,
      laborCost: labor,
      operatingCost: operating,
      depreciationCost: depreciation,
      totalCost: totalCost,
      totalWeight: totalWeight,
      totalUnits: totalUnits,
      costPerKg: costPerKg,
      costPerUnit: costPerUnit,
      suggestedSalePrice: suggestedSalePrice,
      profitMargin: profitMargin,
    );
  }
}
