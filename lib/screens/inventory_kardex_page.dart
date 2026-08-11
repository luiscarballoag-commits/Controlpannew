import 'package:flutter/material.dart';

import '../models/ingredient_catalog.dart';
import '../models/inventory_movement.dart';
import '../services/inventory_movement_service.dart';

class InventoryKardexPage extends StatelessWidget {
  final IngredientCatalog ingredient;

  const InventoryKardexPage({super.key, required this.ingredient});

  @override
  Widget build(BuildContext context) {
    final movementService = InventoryMovementService();

    final movements = movementService
        .getAllMovements()
        .where((m) => m.ingredientId == ingredient.id)
        .toList();

    double purchased = 0;
    double consumed = 0;

    for (final movement in movements) {
      if (movement.type == 'Entrada') {
        purchased += movement.quantity;
      } else if (movement.type == 'Salida') {
        consumed += movement.quantity;
      }
    }

    final inventoryValue = ingredient.stock * ingredient.purchasePrice;

    return Scaffold(
      appBar: AppBar(title: Text(ingredient.name), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.inventory_2, size: 60),

                  const SizedBox(height: 12),

                  Text(
                    ingredient.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text("${ingredient.category} • ${ingredient.unit}"),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.add_circle),
                  title: const Text("Comprado"),
                  trailing: Text(purchased.toStringAsFixed(2)),
                ),

                const Divider(height: 1),

                ListTile(
                  leading: const Icon(Icons.remove_circle),
                  title: const Text("Consumido"),
                  trailing: Text(consumed.toStringAsFixed(2)),
                ),

                const Divider(height: 1),

                ListTile(
                  leading: const Icon(Icons.inventory),
                  title: const Text("Disponible"),
                  trailing: Text(ingredient.stock.toStringAsFixed(2)),
                ),

                const Divider(height: 1),

                ListTile(
                  leading: const Icon(Icons.attach_money),
                  title: const Text("Precio"),
                  trailing: Text(
                    "\$${ingredient.purchasePrice.toStringAsFixed(2)}",
                  ),
                ),

                const Divider(height: 1),

                ListTile(
                  leading: const Icon(Icons.calculate),
                  title: const Text("Valor del inventario"),
                  trailing: Text("\$${inventoryValue.toStringAsFixed(2)}"),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Historial de movimientos",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          if (movements.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Center(child: Text("No existen movimientos.")),
              ),
            ),

          ...movements.map((InventoryMovement movement) {
            return Card(
              child: ListTile(
                leading: Icon(
                  movement.type == 'Entrada'
                      ? Icons.add_circle
                      : Icons.remove_circle,
                ),
                title: Text(movement.type),
                subtitle: Text(movement.reference),
                trailing: Text(movement.quantity.toStringAsFixed(2)),
              ),
            );
          }),
        ],
      ),
    );
  }
}
