import 'package:flutter/material.dart';

import '../models/labor_worker.dart';
import '../services/labor_service.dart';

class LaborCostsPage extends StatefulWidget {
  const LaborCostsPage({super.key});

  @override
  State<LaborCostsPage> createState() => _LaborCostsPageState();
}

class _LaborCostsPageState extends State<LaborCostsPage> {
  final LaborService laborService = LaborService();

  void _showWorkerDialog({int? index}) {
    final existing =
        index != null ? laborService.getWorker(index) : null;

    final roleController =
        TextEditingController(text: existing?.role ?? '');
    final quantityController =
        TextEditingController(
          text: existing?.quantity.toString() ?? '1',
        );
    final costController =
        TextEditingController(
          text: existing?.cost.toString() ?? '',
        );

    String period = existing?.period ?? 'Mensual';
    bool active = existing?.active ?? true;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                existing == null
                    ? 'Agregar Mano de Obra'
                    : 'Editar Mano de Obra',
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: roleController,
                      decoration: const InputDecoration(
                        labelText: 'Cargo',
                        hintText:
                            'Ej. Panadero, Hornero, Ayudante',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: quantityController,
                      keyboardType:
                          const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Cantidad de trabajadores',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: costController,
                      keyboardType:
                          const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Costo',
                        prefixText: '\$ ',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: period,
                      decoration: const InputDecoration(
                        labelText: 'Periodo',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Diario',
                          child: Text('Diario'),
                        ),
                        DropdownMenuItem(
                          value: 'Semanal',
                          child: Text('Semanal'),
                        ),
                        DropdownMenuItem(
                          value: 'Mensual',
                          child: Text('Mensual'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            period = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Trabajador activo'),
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
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final role = roleController.text.trim();
                    final quantity =
                        double.tryParse(quantityController.text) ?? 0;
                    final cost =
                        double.tryParse(costController.text) ?? 0;

                    if (role.isEmpty ||
                        quantity <= 0 ||
                        cost < 0) {
                      return;
                    }

                    final worker = LaborWorker(
                      id: existing?.id ??
                          DateTime.now()
                              .microsecondsSinceEpoch
                              .toString(),
                      role: role,
                      quantity: quantity,
                      cost: cost,
                      period: period,
                      active: active,
                    );

                    if (index == null) {
                      laborService.addWorker(worker);
                    } else {
                      laborService.updateWorker(index, worker);
                    }

                    Navigator.pop(dialogContext);
                    setState(() {});
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteWorker(int index) {
    final worker = laborService.getWorker(index);

    if (worker == null) return;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar trabajador'),
          content: Text(
            '¿Desea eliminar "${worker.role}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                laborService.deleteWorker(index);
                Navigator.pop(dialogContext);
                setState(() {});
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final workers = laborService.getAllWorkers();
    final total = laborService.getTotalLaborCost();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mano de Obra'),
        centerTitle: true,
        backgroundColor: const Color(0xFF8D6E63),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(
                    Icons.groups,
                    size: 42,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Costo de Mano de Obra',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ...List.generate(workers.length, (index) {
            final worker = workers[index];
            final workerTotal =
                worker.cost * worker.quantity;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(
                    worker.active
                        ? Icons.person
                        : Icons.person_off,
                  ),
                ),
                title: Text(
                  worker.role,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '${worker.quantity.toStringAsFixed(0)} trabajador(es) · '
                  '${worker.period}',
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${workerTotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () =>
                              _showWorkerDialog(index: index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () =>
                              _deleteWorker(index),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 10),
          SizedBox(
            height: 55,
            child: ElevatedButton.icon(
              onPressed: () => _showWorkerDialog(),
              icon: const Icon(Icons.add),
              label: const Text(
                'AGREGAR TRABAJADOR',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
