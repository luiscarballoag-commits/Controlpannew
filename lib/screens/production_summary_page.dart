import 'package:flutter/material.dart';

import '../core/production_manager/production_manager.dart';
import '../core/production_engine/ingredient.dart';
import '../models/production.dart';
import '../models/cost_record.dart';
import '../models/recipe.dart';
import '../services/production_inventory_service.dart';
import '../services/production_service.dart';
import 'production_elaboration_page.dart';
import '../services/cost_service.dart';
import '../services/cost_record_service.dart';

class ProductionSummaryPage extends StatefulWidget {
  final Recipe recipe;
  final double lots;
  final double pieceWeight;

  const ProductionSummaryPage({
    super.key,
    required this.recipe,
    required this.lots,
    required this.pieceWeight,
  });

  @override
  State<ProductionSummaryPage> createState() => _ProductionSummaryPageState();
}

class _ProductionSummaryPageState extends State<ProductionSummaryPage> {
  final ProductionService productionService = ProductionService();

  final CostService costService = CostService();

  final CostRecordService costRecordService = CostRecordService();

  final ProductionInventoryService inventoryService =
      ProductionInventoryService();
  final ProductionManager productionManager = ProductionManager();

  double totalMassGrams = 0;

  @override
  void initState() {
    super.initState();
    calculateTotalMass();
  }

  void calculateTotalMass() {
    final ingredientes = <Ingredient>[];

    for (final item in widget.recipe.ingredients) {
      double cantidad = item.quantity * widget.lots;
      UnitType tipo = UnitType.grams;

      switch (item.unit) {
        case "kg":
          cantidad *= 1000;
          tipo = UnitType.grams;
          break;
        case "g":
          tipo = UnitType.grams;
          break;
        case "L":
          cantidad *= 1000;
          tipo = UnitType.milliliters;
          break;
        case "ml":
          tipo = UnitType.milliliters;
          break;
      }

      ingredientes.add(
        Ingredient(
          id: item.ingredient.id,
          name: item.ingredient.name,
          quantity: cantidad,
          unit: tipo,
        ),
      );
    }

    final resultado = productionManager.calculateProduction(
      ingredients: ingredientes,
      pieceWeight: widget.pieceWeight,
    );

    totalMassGrams = resultado.totalMass;
  }

  @override
  Widget build(BuildContext context) {
    final totalPieces = widget.pieceWeight > 0
        ? (totalMassGrams / widget.pieceWeight).floor()
        : 0;

    final hasInventory = inventoryService.hasEnoughInventory(
      recipe: widget.recipe,
      lots: widget.lots,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EB),
      appBar: AppBar(
        title: const Text("Resumen de Producción"),
        centerTitle: true,
        backgroundColor: const Color(0xFF8D6E63),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF8D6E63),
                  child: Icon(Icons.menu_book, color: Colors.white),
                ),
                title: Text(
                  widget.recipe.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("${widget.lots.toStringAsFixed(0)} lote(s)"),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: Card(
                    color: const Color(0xFF8D6E63),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.scale,
                            color: Colors.white,
                            size: 30,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            (totalMassGrams / 1000).toStringAsFixed(2),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            "Kg",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Card(
                    color: const Color(0xFF8D6E63),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.bakery_dining,
                            color: Colors.white,
                            size: 30,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            totalPieces.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            "Panes",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Card(
              elevation: 4,
              color: hasInventory ? Colors.green.shade50 : Colors.red.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: ListTile(
                leading: Icon(
                  hasInventory ? Icons.check_circle : Icons.warning,
                  color: hasInventory ? Colors.green : Colors.red,
                ),
                title: Text(
                  hasInventory
                      ? "Inventario disponible"
                      : "Inventario insuficiente",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Ingredientes necesarios",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: widget.recipe.ingredients.length,
                itemBuilder: (context, index) {
                  final ingredient = widget.recipe.ingredients[index];

                  final quantity = ingredient.quantity * widget.lots;

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFF8D6E63),
                        child: Icon(Icons.inventory, color: Colors.white),
                      ),
                      title: Text(
                        ingredient.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "${quantity.toStringAsFixed(2)} ${ingredient.unit}",
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8D6E63),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                icon: const Icon(Icons.play_arrow),
                label: const Text(
                  "INICIAR PRODUCCIÓN",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: hasInventory
                    ? () {
                        inventoryService.consumeIngredients(
                          recipe: widget.recipe,
                          lots: widget.lots,
                        );

                        final productionId =
                            "P-${(productionService.getAllProductions().length + 1).toString().padLeft(6, '0')}";

                        productionService.addProduction(
                          Production(
                            id: productionId,
                            date: DateTime.now(),
                            recipeId: widget.recipe.id,
                            recipeName: widget.recipe.name,
                            lots: widget.lots.toInt(),
                            totalMassKg: totalMassGrams / 1000,
                            pieceWeightGrams: widget.pieceWeight,
                            totalPieces: totalPieces,
                          ),
                        );

                        final costResult = costService.calculateRecipeCost(
                          recipe: widget.recipe,
                          lots: widget.lots,
                          totalWeightKg: totalMassGrams / 1000,
                          totalUnits: totalPieces,
                        );

                        costRecordService.saveRecord(
                          CostRecord(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            date: DateTime.now(),
                            productionId: productionId,
                            recipeName: widget.recipe.name,
                            rawMaterialCost: costResult.rawMaterialCost,
                            laborCost: costResult.laborCost,
                            operatingCost: costResult.operatingCost,
                            depreciationCost: costResult.depreciationCost,
                            totalCost: costResult.totalCost,
                            costPerKg: costResult.costPerKg,
                            costPerPiece: costResult.costPerUnit,
                            profitPercentage: costResult.profitMargin,
                            suggestedSalePrice: costResult.suggestedSalePrice,
                          ),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Producción registrada correctamente.",
                            ),
                          ),
                        );

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (dialogContext) {
                            return AlertDialog(
                              title: const Text("Producción finalizada"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 60,
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    "La producción fue registrada correctamente.",
                                  ),
                                  const SizedBox(height: 16),
                                  Text("Panes obtenidos: $totalPieces"),
                                ],
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () async {
                                    Navigator.pop(dialogContext);
                                    final navigator = Navigator.of(context);
                                    await navigator.push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            ProductionElaborationPage(
                                              productionId: productionId,
                                              availablePieces: totalPieces,
                                            ),
                                      ),
                                    );
                                    if (!mounted) return;
                                    navigator.popUntil(
                                      (route) => route.isFirst,
                                    );
                                  },
                                  child: const Text("Elaborar Productos"),
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.pop(dialogContext);
                                    Navigator.popUntil(
                                      context,
                                      (route) => route.isFirst,
                                    );
                                  },
                                  child: const Text("Finalizar"),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
