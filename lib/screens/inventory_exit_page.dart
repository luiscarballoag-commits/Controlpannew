import 'package:flutter/material.dart';

import '../models/ingredient_catalog.dart';
import '../models/inventory_movement.dart';
import '../services/ingredient_service.dart';
import '../services/inventory_movement_service.dart';

class InventoryExitPage extends StatefulWidget {
  const InventoryExitPage({super.key});

  @override
  State<InventoryExitPage> createState() => _InventoryExitPageState();
}

class _InventoryExitPageState extends State<InventoryExitPage> {
  final IngredientService ingredientService = IngredientService();

  final InventoryMovementService movementService = InventoryMovementService();

  IngredientCatalog? selectedIngredient;

  int? selectedIndex;

  String? selectedReason;

  final _quantityController = TextEditingController();

  final _notesController = TextEditingController();

  final List<String> reasons = [
    "Producción",
    "Venta",
    "Daño",
    "Ajuste",
    "Otro",
  ];

  @override
  void dispose() {
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Widget buildField(
    String label,
    TextEditingController controller, {
    TextInputType keyboard = TextInputType.text,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon == null ? null : Icon(icon),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  void saveExit() {
    if (selectedIngredient == null || selectedIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Seleccione un ingrediente")),
      );

      return;
    }

    if (selectedReason == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Seleccione un motivo")));

      return;
    }

    final quantity = double.tryParse(_quantityController.text) ?? 0;

    if (quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ingrese una cantidad válida")),
      );

      return;
    }

    if (quantity > selectedIngredient!.stock) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Stock insuficiente")));

      return;
    }

    final updatedIngredient = IngredientCatalog(
      id: selectedIngredient!.id,
      name: selectedIngredient!.name,
      category: selectedIngredient!.category,
      unit: selectedIngredient!.unit,
      purchasePrice: selectedIngredient!.purchasePrice,
      stock: selectedIngredient!.stock - quantity,
      minimumStock: selectedIngredient!.minimumStock,
      notes: selectedIngredient!.notes,
    );

    ingredientService.updateIngredient(selectedIndex!, updatedIngredient);
    movementService.addMovement(
      InventoryMovement(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: DateTime.now(),
        ingredientId: updatedIngredient.id,
        ingredientName: updatedIngredient.name,
        quantity: quantity,
        unit: updatedIngredient.unit,
        type: "Salida",
        reference: selectedReason!,
        notes: _notesController.text,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Se descontaron ${quantity.toStringAsFixed(2)} ${updatedIngredient.unit} de ${updatedIngredient.name}",
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final ingredients = ingredientService.getAllIngredients();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Salida de Inventario"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<IngredientCatalog>(
              initialValue: selectedIngredient,
              decoration: const InputDecoration(
                labelText: "Ingrediente",
                prefixIcon: Icon(Icons.science),
                border: OutlineInputBorder(),
              ),
              items: List.generate(ingredients.length, (index) {
                final ingredient = ingredients[index];
                return DropdownMenuItem<IngredientCatalog>(
                  value: ingredient,
                  child: Text(ingredient.name),
                );
              }),
              onChanged: (value) {
                setState(() {
                  selectedIngredient = value;

                  if (value != null) {
                    selectedIndex = ingredients.indexOf(value);
                  }
                });
              },
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              initialValue: selectedReason,
              decoration: const InputDecoration(
                labelText: "Motivo de la salida",
                prefixIcon: Icon(Icons.assignment_outlined),
                border: OutlineInputBorder(),
              ),
              items: reasons.map((reason) {
                return DropdownMenuItem(value: reason, child: Text(reason));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedReason = value;
                });
              },
            ),

            const SizedBox(height: 16),

            buildField(
              "Cantidad",
              _quantityController,
              keyboard: const TextInputType.numberWithOptions(decimal: true),
              icon: Icons.scale,
            ),

            buildField("Observaciones", _notesController, icon: Icons.notes),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.remove_circle_outline),
                label: const Text(
                  "REGISTRAR SALIDA",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                onPressed: saveExit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
