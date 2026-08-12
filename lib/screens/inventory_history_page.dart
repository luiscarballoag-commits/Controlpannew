import 'package:flutter/material.dart';

import '../models/inventory_movement.dart';
import '../services/inventory_movement_service.dart';

class InventoryHistoryPage extends StatefulWidget {
  const InventoryHistoryPage({super.key});

  @override
  State<InventoryHistoryPage> createState() => _InventoryHistoryPageState();
}

class _InventoryHistoryPageState extends State<InventoryHistoryPage> {
  final InventoryMovementService movementService = InventoryMovementService();

  @override
  Widget build(BuildContext context) {
    final movements = movementService.getAllMovements();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Historial de Movimientos"),
        centerTitle: true,
      ),
      body: movements.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  "Aún no existen movimientos de inventario.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: movements.length,
              itemBuilder: (context, index) {
                final InventoryMovement movement = movements[index];

                final bool isEntry = [
                  "Compra",
                  "Entrada",
                  "Ajuste +",
                ].contains(movement.type);
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isEntry ? Colors.green : Colors.red,
                      child: Icon(
                        isEntry ? Icons.arrow_downward : Icons.arrow_upward,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      movement.ingredientName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${movement.quantity} ${movement.unit}"),

                        Text(movement.reference),

                        if (movement.notes.isNotEmpty) Text(movement.notes),

                        const SizedBox(height: 4),

                        Text(
                          movement.type,
                          style: TextStyle(
                            color: isEntry ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          movement.date.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
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
