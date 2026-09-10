import 'package:flutter/material.dart';

import '../core/production_manager/production_manager.dart';
import '../core/production_engine/ingredient.dart';
import '../models/production.dart';
import '../models/cost_record.dart';
import '../models/recipe.dart';
import '../services/production_inventory_service.dart';
import '../services/production_service.dart';
import '../services/labor_service.dart';
import '../services/operating_expense_service.dart';
import '../services/depreciation_service.dart';
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
  final LaborService laborService = LaborService();
  final OperatingExpenseService operatingExpenseService = OperatingExpenseService();
  final DepreciationService depreciationService = DepreciationService();
  final Map<String, double> _workerHours = {};
  final List<String> _selectedWorkerIds = [];

  final Map<String, double> _assetHours = {};
  final List<String> _selectedAssetIds = [];

  double _productionHours = 0;
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

  void _addWorker(String workerId) {
    if (_selectedWorkerIds.contains(workerId)) return;

    setState(() {
      _selectedWorkerIds.add(workerId);
      _workerHours[workerId] = 0;
    });
  }

  void _removeWorker(String workerId) {
    setState(() {
      _selectedWorkerIds.remove(workerId);
      _workerHours.remove(workerId);
    });
  }

  void _addAsset(String assetId) {
    if (_selectedAssetIds.contains(assetId)) return;

    setState(() {
      _selectedAssetIds.add(assetId);
      _assetHours[assetId] = 0;
    });
  }

  void _removeAsset(String assetId) {
    setState(() {
      _selectedAssetIds.remove(assetId);
      _assetHours.remove(assetId);
    });
  }

  double _calculateDepreciationCost() {
    double total = 0;

    final assets = depreciationService.getActiveAssets();

    for (final assetId in _selectedAssetIds) {
      final asset = assets.where((item) => item.id == assetId).firstOrNull;
      if (asset == null) continue;

      final hours = _assetHours[assetId] ?? 0;

      total += depreciationService.getProductionDepreciation(
        asset: asset,
        hours: hours,
      );
    }

    return total;
  }

  double _calculateLaborCost() {
    double total = 0;

    final workers = laborService.getActiveWorkers();

    for (final workerId in _selectedWorkerIds) {
      final worker = workers.where((worker) => worker.id == workerId).firstOrNull;

      if (worker == null) continue;

      final hours = _workerHours[workerId] ?? 0;

      total += laborService.getProductionLaborCost(
            worker: worker,
            hours: hours,
          ) *
          worker.quantity;
    }

    return total;
  }

  void _showAddWorkerDialog() {
    final workers = laborService.getActiveWorkers()
        .where((worker) => !_selectedWorkerIds.contains(worker.id))
        .toList();

    if (workers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay trabajadores disponibles para agregar.'),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar trabajador'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: workers.length,
              itemBuilder: (context, index) {
                final worker = workers[index];

                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(worker.role),
                  subtitle: Text(
                    '${worker.quantity.toStringAsFixed(0)} trabajador(es)',
                  ),
                  onTap: () {
                    _addWorker(worker.id);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showAddAssetDialog() {
    final assets = depreciationService
        .getActiveAssets()
        .where((asset) => !_selectedAssetIds.contains(asset.id))
        .toList();

    if (assets.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay equipos disponibles para agregar.'),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar equipo'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: assets.length,
              itemBuilder: (context, index) {
                final asset = assets[index];

                return ListTile(
                  leading: const Icon(Icons.precision_manufacturing),
                  title: Text(asset.name),
                  subtitle: Text(
                    '\$${depreciationService.getHourlyDepreciation(asset).toStringAsFixed(4)} por hora',
                  ),
                  onTap: () {
                    _addAsset(asset.id);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildLaborCostCard() {
    final workers = laborService.getActiveWorkers();

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.groups_rounded,
                  color: Color(0xFF8D6E63),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Costos adicionales',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: _showAddWorkerDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar trabajador'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Mano de Obra',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (_selectedWorkerIds.isEmpty)
              const Text(
                'No hay trabajadores agregados a esta producción.',
                style: TextStyle(color: Colors.grey),
              ),
            ..._selectedWorkerIds.map((workerId) {
              final worker = workers.where(
                (item) => item.id == workerId,
              ).firstOrNull;

              if (worker == null) {
                return const SizedBox.shrink();
              }

              final hours = _workerHours[workerId] ?? 0;
              final cost = laborService.getProductionLaborCost(
                    worker: worker,
                    hours: hours,
                  ) *
                  worker.quantity;

              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          worker.role,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 75,
                        child: TextFormField(
                          initialValue: hours == 0
                              ? ''
                              : hours.toString(),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Horas',
                            isDense: true,
                          ),
                          onChanged: (value) {
                            final parsed = double.tryParse(value) ?? 0;

                            setState(() {
                              _workerHours[workerId] = parsed;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 75,
                        child: Text(
                          '\$${cost.toStringAsFixed(2)}',
                          textAlign: TextAlign.right,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _removeWorker(workerId),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total mano de obra',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${_calculateLaborCost().toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Gastos Operativos',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: 90,
                  child: TextFormField(
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Horas',
                      isDense: true,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _productionHours = double.tryParse(value) ?? 0;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '\$${operatingExpenseService.getTotalCostForHours(hours: _productionHours).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Depreciación',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: _showAddAssetDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar equipo'),
                ),
              ],
            ),
            if (_selectedAssetIds.isEmpty)
              const Text(
                'No hay equipos agregados a esta producción.',
                style: TextStyle(color: Colors.grey),
              ),
            ..._selectedAssetIds.map((assetId) {
              final asset = depreciationService
                  .getActiveAssets()
                  .where((item) => item.id == assetId)
                  .firstOrNull;

              if (asset == null) {
                return const SizedBox.shrink();
              }

              final hours = _assetHours[assetId] ?? 0;
              final cost = depreciationService.getProductionDepreciation(
                asset: asset,
                hours: hours,
              );

              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          asset.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 75,
                        child: TextFormField(
                          initialValue: hours == 0
                              ? ''
                              : hours.toString(),
                          keyboardType:
                              const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Horas',
                            isDense: true,
                          ),
                          onChanged: (value) {
                            final parsed = double.tryParse(value) ?? 0;

                            setState(() {
                              _assetHours[assetId] = parsed;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 75,
                        child: Text(
                          '\$${cost.toStringAsFixed(2)}',
                          textAlign: TextAlign.right,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _removeAsset(assetId),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total depreciación',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${_calculateDepreciationCost().toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProductionCost(String productionId) async {
    final totalUnits = widget.pieceWeight > 0
        ? (totalMassGrams / widget.pieceWeight).floor()
        : 0;

    final costResult = costService.calculateRecipeCost(
      recipe: widget.recipe,
      lots: widget.lots,
      totalWeightKg: totalMassGrams / 1000,
      totalUnits: totalUnits,
      productionId: productionId,
      laborCost: _calculateLaborCost(),
      operatingCost: operatingExpenseService.getTotalCostForHours(
        hours: _productionHours,
      ),
      depreciationCost: _calculateDepreciationCost(),
    );

    costRecordService.saveRecord(
      CostRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: DateTime.now(),
        productionId: productionId,
        recipeName: widget.recipe.name,
        rawMaterialCost: costResult.rawMaterialCost,
        elaborationCost: costResult.elaborationCost,
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
      body: SingleChildScrollView(
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

            SizedBox(
              height: 260,
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

            const SizedBox(height: 12),

            _buildLaborCostCard(),

            const SizedBox(height: 8),

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

                                    await _saveProductionCost(productionId);

                                    navigator.popUntil(
                                      (route) => route.isFirst,
                                    );
                                  },
                                  child: const Text("Elaborar Productos"),
                                ),
                                OutlinedButton(
                                  onPressed: () async {
                                    final navigator = Navigator.of(context);

                                    Navigator.pop(dialogContext);
                                    await _saveProductionCost(productionId);
                                    if (!mounted) return;

                                    navigator.popUntil(
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
