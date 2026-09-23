import 'package:flutter/material.dart';
import '../models/cost_record.dart';
import '../services/cost_record_service.dart';
import '../services/cost_service.dart';

import '../services/depreciation_service.dart';
import '../services/labor_service.dart';
import '../services/operating_expense_service.dart';
import '../services/production_service.dart';
import '../services/settings_service.dart';

class AddProductionCostsPage extends StatefulWidget {
  final String productionId;

  const AddProductionCostsPage({super.key, required this.productionId});

  @override
  State<AddProductionCostsPage> createState() => _AddProductionCostsPageState();
}

class _AddProductionCostsPageState extends State<AddProductionCostsPage> {
  final SettingsService _settingsService = SettingsService();
  final ProductionService productionService = ProductionService();
  final LaborService laborService = LaborService();
  final OperatingExpenseService operatingExpenseService =
      OperatingExpenseService();
  final DepreciationService depreciationService = DepreciationService();

  final Map<String, double> _workerHours = {};
  final List<String> _selectedWorkerIds = [];

  final Map<String, double> _assetHours = {};
  final List<String> _selectedAssetIds = [];

  double _productionHours = 0;

  double _calculateLaborCost() {
    double total = 0;
    final workers = laborService.getActiveWorkers();

    for (final workerId in _selectedWorkerIds) {
      final worker = workers.where((item) => item.id == workerId).firstOrNull;

      if (worker == null) continue;

      final hours = _workerHours[workerId] ?? 0;

      total +=
          laborService.getProductionLaborCost(worker: worker, hours: hours) *
          worker.quantity;
    }

    return total;
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

  Future<void> _showAddWorkerDialog() async {
    final workers = laborService
        .getActiveWorkers()
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

    final selectedId = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Agregar mano de obra'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: workers.length,
              itemBuilder: (_, index) {
                final worker = workers[index];

                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(worker.role),
                  subtitle: Text('${worker.quantity} trabajador(es)'),
                  onTap: () {
                    Navigator.pop(dialogContext, worker.id);
                  },
                );
              },
            ),
          ),
        );
      },
    );

    if (selectedId != null) {
      _addWorker(selectedId);
    }
  }

  Future<void> _showAddAssetDialog() async {
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

    final selectedId = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Agregar equipo'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: assets.length,
              itemBuilder: (_, index) {
                final asset = assets[index];

                return ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.precision_manufacturing),
                  ),
                  title: Text(asset.name),
                  onTap: () {
                    Navigator.pop(dialogContext, asset.id);
                  },
                );
              },
            ),
          ),
        );
      },
    );

    if (selectedId != null) {
      _addAsset(selectedId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final production = productionService.getProductionById(widget.productionId);

    if (production == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Agregar gastos de producción')),
        body: const Center(child: Text('No se encontró la producción.')),
      );
    }

    final operatingCost = operatingExpenseService.getTotalCostForHours(
      hours: _productionHours,
    );

    final laborCost = _calculateLaborCost();
    final depreciationCost = _calculateDepreciationCost();

    final additionalCost = laborCost + operatingCost + depreciationCost;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EB),
      appBar: AppBar(
        title: const Text(
          'Agregar gastos de producción',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF8D6E63),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF8D6E63),
                child: Icon(Icons.bakery_dining, color: Colors.white),
              ),
              title: Text(
                production.recipeName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${production.totalPieces} piezas · '
                '${production.totalMassKg.toStringAsFixed(2)} kg',
              ),
            ),
          ),
          const SizedBox(height: 16),

          _buildLaborCard(laborCost),
          _buildOperatingCard(operatingCost),
          _buildDepreciationCard(depreciationCost),

          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Gastos adicionales',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _settingsService.formatCurrency(additionalCost),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          SizedBox(
            height: 56,
            child: ElevatedButton.icon(
              onPressed: _finalizeProduction,
              icon: const Icon(Icons.check),
              label: const Text(
                'FINALIZAR',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8D6E63),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _finalizeProduction() async {
    final production = productionService.getProductionById(widget.productionId);

    if (production == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se encontró la producción.')),
      );
      return;
    }

    final laborCost = _calculateLaborCost();

    final operatingCost = operatingExpenseService.getTotalCostForHours(
      hours: _productionHours,
    );

    final depreciationCost = _calculateDepreciationCost();

    final costService = CostService();

    final recipe = costService.recipeService.getRecipeById(production.recipeId);

    if (recipe == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se encontró la receta de la producción.'),
        ),
      );
      return;
    }

    final costResult = costService.calculateRecipeCost(
      recipe: recipe,
      lots: production.lots.toDouble(),
      totalWeightKg: production.totalMassKg,
      totalUnits: production.totalPieces,
      productionId: production.id,
      laborCost: laborCost,
      operatingCost: operatingCost,
      depreciationCost: depreciationCost,
    );

    final costRecordService = CostRecordService();

    costRecordService.saveRecord(
      CostRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: DateTime.now(),
        productionId: production.id,
        recipeName: production.recipeName,
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

    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Producción finalizada'),
          content: Text(
            'Costo total: ${_settingsService.formatCurrency(costResult.totalCost)}\n'
            'Costo por pieza: ${_settingsService.formatCurrency(costResult.costPerUnit)}',
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('CONTINUAR'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    Navigator.popUntil(context, (route) => route.isFirst);
  }

  Widget _buildLaborCard(double total) {
    final workers = laborService.getActiveWorkers();

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.groups_rounded, color: Color(0xFF8D6E63)),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Mano de Obra',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton.icon(
                  onPressed: _showAddWorkerDialog,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Agregar'),
                ),
              ],
            ),
            const Divider(),

            if (_selectedWorkerIds.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'No hay trabajadores agregados.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),

            ..._selectedWorkerIds.map((workerId) {
              final worker = workers
                  .where((item) => item.id == workerId)
                  .firstOrNull;

              if (worker == null) {
                return const SizedBox.shrink();
              }

              final hours = _workerHours[workerId] ?? 0;
              final cost =
                  laborService.getProductionLaborCost(
                    worker: worker,
                    hours: hours,
                  ) *
                  worker.quantity;

              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(worker.role),
                subtitle: Text(_settingsService.formatCurrency(cost)),
                leading: const Icon(Icons.person_outline),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 70,
                      child: TextFormField(
                        initialValue: hours.toString(),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          labelText: 'Horas',
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _workerHours[workerId] =
                                double.tryParse(
                                  value.trim().replaceAll(',', '.'),
                                ) ??
                                0;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () => _removeWorker(workerId),
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                ),
              );
            }),

            const Divider(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total mano de obra',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  _settingsService.formatCurrency(total),
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

  Widget _buildOperatingCard(double total) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
        child: Row(
          children: [
            const Icon(Icons.receipt_long_rounded, color: Color(0xFF8D6E63)),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Gastos Operativos',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: 78,
              child: TextFormField(
                initialValue: _productionHours.toString(),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  labelText: 'Horas',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _productionHours =
                        double.tryParse(value.trim().replaceAll(',', '.')) ?? 0;
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            Text(
              _settingsService.formatCurrency(total),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDepreciationCard(double total) {
    final assets = depreciationService.getActiveAssets();

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.precision_manufacturing_rounded,
                  color: Color(0xFF8D6E63),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Depreciación',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton.icon(
                  onPressed: _showAddAssetDialog,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Agregar'),
                ),
              ],
            ),
            const Divider(),

            if (_selectedAssetIds.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'No hay equipos agregados.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),

            ..._selectedAssetIds.map((assetId) {
              final asset = assets
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

              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(asset.name),
                subtitle: Text(_settingsService.formatCurrency(cost)),
                leading: const Icon(Icons.precision_manufacturing_outlined),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 70,
                      child: TextFormField(
                        initialValue: hours.toString(),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          labelText: 'Horas',
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _assetHours[assetId] =
                                double.tryParse(
                                  value.trim().replaceAll(',', '.'),
                                ) ??
                                0;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () => _removeAsset(assetId),
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                ),
              );
            }),

            const Divider(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total depreciación',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  _settingsService.formatCurrency(total),
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
}
