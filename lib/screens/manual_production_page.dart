import 'package:flutter/material.dart';

import '../core/production_engine/ingredient.dart';
import '../core/production_manager/production_manager.dart';

class ManualProductionPage extends StatefulWidget {
  const ManualProductionPage({super.key});

  @override
  State<ManualProductionPage> createState() => _ManualProductionPageState();
}

class _ManualProductionPageState extends State<ManualProductionPage> {
  final ProductionManager productionManager = ProductionManager();

  final harinaController = TextEditingController();

  final aguaController = TextEditingController();

  final azucarController = TextEditingController();

  final salController = TextEditingController();

  final margarinaController = TextEditingController();

  final levaduraController = TextEditingController();

  final esenciaController = TextEditingController();

  final otrosController = TextEditingController();

  final pesoController = TextEditingController(text: "250");

  @override
  void dispose() {
    harinaController.dispose();
    aguaController.dispose();
    azucarController.dispose();
    salController.dispose();
    margarinaController.dispose();
    levaduraController.dispose();
    esenciaController.dispose();
    otrosController.dispose();
    pesoController.dispose();
    super.dispose();
  }

  Widget campo(String titulo, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: titulo,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Future<void> calcular() async {
    final ingredientes = <Ingredient>[
      Ingredient(
        id: 'harina',
        name: 'Harina',
        quantity: double.tryParse(harinaController.text) ?? 0,
        unit: UnitType.grams,
      ),
      Ingredient(
        id: 'agua',
        name: 'Agua',
        quantity: double.tryParse(aguaController.text) ?? 0,
        unit: UnitType.grams,
      ),
      Ingredient(
        id: 'azucar',
        name: 'Azúcar',
        quantity: double.tryParse(azucarController.text) ?? 0,
        unit: UnitType.grams,
      ),
      Ingredient(
        id: 'sal',
        name: 'Sal',
        quantity: double.tryParse(salController.text) ?? 0,
        unit: UnitType.grams,
      ),
      Ingredient(
        id: 'margarina',
        name: 'Margarina',
        quantity: double.tryParse(margarinaController.text) ?? 0,
        unit: UnitType.grams,
      ),
      Ingredient(
        id: 'levadura',
        name: 'Levadura',
        quantity: double.tryParse(levaduraController.text) ?? 0,
        unit: UnitType.grams,
      ),
      Ingredient(
        id: 'esencia',
        name: 'Esencia',
        quantity: double.tryParse(esenciaController.text) ?? 0,
        unit: UnitType.grams,
      ),
      Ingredient(
        id: 'otros',
        name: 'Otros',
        quantity: double.tryParse(otrosController.text) ?? 0,
        unit: UnitType.grams,
      ),
    ];

    final resultado = productionManager.calculateProduction(
      ingredients: ingredientes,
      pieceWeight: double.tryParse(pesoController.text) ?? 250,
    );
    await productionManager.saveManualProduction(
      totalMassKg: resultado.totalMassKg,
      pieceWeightGrams: double.tryParse(pesoController.text) ?? 250,
      totalPieces: resultado.totalPieces,
    );

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Resultado"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Masa total: ${resultado.totalMassKg.toStringAsFixed(2)} kg"),
            const SizedBox(height: 10),
            Text("Piezas: ${resultado.totalPieces}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cerrar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Producción Manual"), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          campo("Harina (g)", harinaController),
          campo("Agua (g)", aguaController),
          campo("Azúcar (g)", azucarController),
          campo("Sal (g)", salController),
          campo("Margarina (g)", margarinaController),
          campo("Levadura (g)", levaduraController),
          campo("Esencia (g)", esenciaController),
          campo("Otros ingredientes (g)", otrosController),
          campo("Peso por pieza (g)", pesoController),

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.calculate),
              label: const Text(
                "CALCULAR PRODUCCIÓN",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onPressed: calcular,
            ),
          ),
        ],
      ),
    );
  }
}
