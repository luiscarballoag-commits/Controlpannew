import 'package:flutter/material.dart';

import '../models/depreciation_asset.dart';
import '../services/depreciation_service.dart';

class DepreciationAssetsPage extends StatefulWidget {
  const DepreciationAssetsPage({super.key});

  @override
  State<DepreciationAssetsPage> createState() =>
      _DepreciationAssetsPageState();
}

class _DepreciationAssetsPageState
    extends State<DepreciationAssetsPage> {
  final DepreciationService _service = DepreciationService();

  List<DepreciationAsset> _assets = [];

  @override
  void initState() {
    super.initState();
    _loadAssets();
  }

  void _loadAssets() {
    setState(() {
      _assets = _service.getAllAssets();
    });
  }

  void _showAssetForm({int? index}) {
    final asset = index == null ? null : _assets[index];

    final nameController =
        TextEditingController(text: asset?.name ?? '');
    final valueController = TextEditingController(
      text: asset?.purchaseValue.toString() ?? '',
    );
    final lifeController = TextEditingController(
      text: asset?.usefulLifeYears.toString() ?? '',
    );
    final hoursController = TextEditingController(
      text: asset?.productiveHoursPerMonth.toString() ?? '260',
    );

    bool active = asset?.active ?? true;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                asset == null
                    ? 'Agregar equipo'
                    : 'Editar equipo',
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del equipo',
                        prefixIcon: Icon(Icons.precision_manufacturing),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: valueController,
                      keyboardType:
                          const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Valor de compra',
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: lifeController,
                      keyboardType:
                          const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Vida útil (años)',
                        prefixIcon: Icon(Icons.calendar_month),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: hoursController,
                      keyboardType:
                          const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Horas productivas por mes',
                        prefixIcon: Icon(Icons.schedule),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Depreciación activa'),
                      subtitle: Text(
                        active ? 'Participa en los costos' : 'Inactiva',
                      ),
                      value: active,
                      onChanged: (value) {
                        setDialogState(() {
                          active = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('CANCELAR'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final purchaseValue =
                        double.tryParse(valueController.text) ?? 0;
                    final usefulLife =
                        double.tryParse(lifeController.text) ?? 0;
                    final productiveHours =
                        double.tryParse(hoursController.text) ?? 0;

                    if (name.isEmpty ||
                        purchaseValue <= 0 ||
                        usefulLife <= 0 ||
                        productiveHours <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Completa los datos correctamente.',
                          ),
                        ),
                      );
                      return;
                    }

                    final updatedAsset = DepreciationAsset(
                      id: asset?.id ??
                          DateTime.now()
                              .millisecondsSinceEpoch
                              .toString(),
                      name: name,
                      purchaseValue: purchaseValue,
                      usefulLifeYears: usefulLife,
                      productiveHoursPerMonth: productiveHours,
                      active: active,
                    );

                    if (index == null) {
                      _service.addAsset(updatedAsset);
                    } else {
                      _service.updateAsset(index, updatedAsset);
                    }

                    Navigator.pop(dialogContext);
                    _loadAssets();
                  },
                  child: const Text('GUARDAR'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteAsset(int index) {
    final asset = _assets[index];

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar equipo'),
          content: Text(
            '¿Deseas eliminar "${asset.name}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('CANCELAR'),
            ),
            ElevatedButton(
              onPressed: () {
                _service.deleteAsset(index);
                Navigator.pop(dialogContext);
                _loadAssets();
              },
              child: const Text('ELIMINAR'),
            ),
          ],
        );
      },
    );
  }

  void _toggleAsset(int index, bool active) {
    final asset = _assets[index];

    _service.updateAsset(
      index,
      asset.copyWith(active: active),
    );

    _loadAssets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Depreciación'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAssetForm(),
        icon: const Icon(Icons.add),
        label: const Text('Agregar equipo'),
      ),
      body: _assets.isEmpty
          ? const Center(
              child: Text(
                'No hay equipos registrados.\n\n'
                'Agrega un equipo para comenzar.',
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 90),
              itemCount: _assets.length,
              itemBuilder: (context, index) {
                final asset = _assets[index];
                final monthly =
                    _service.getMonthlyDepreciation(asset);
                final hourly =
                    _service.getHourlyDepreciation(asset);

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.precision_manufacturing,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                asset.name,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Switch(
                              value: asset.active,
                              onChanged: (value) =>
                                  _toggleAsset(index, value),
                            ),
                          ],
                        ),
                        const Divider(),
                        Text(
                          'Valor de compra: \$${asset.purchaseValue.toStringAsFixed(2)}',
                        ),
                        Text(
                          'Vida útil: ${asset.usefulLifeYears.toStringAsFixed(1)} años',
                        ),
                        Text(
                          'Horas productivas/mes: '
                          '${asset.productiveHoursPerMonth.toStringAsFixed(1)}',
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Depreciación mensual: '
                          '\$${monthly.toStringAsFixed(2)}',
                        ),
                        Text(
                          'Depreciación por hora: '
                          '\$${hourly.toStringAsFixed(4)}',
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.end,
                          children: [
                            IconButton(
                              tooltip: 'Editar',
                              onPressed: () =>
                                  _showAssetForm(index: index),
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              tooltip: 'Eliminar',
                              onPressed: () =>
                                  _deleteAsset(index),
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
