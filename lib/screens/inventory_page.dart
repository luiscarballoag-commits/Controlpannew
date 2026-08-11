import 'package:flutter/material.dart';

import '../services/inventory_service.dart';
import '../services/inventory_movement_service.dart';

import 'ingredients_page.dart';
import 'inventory_entry_page.dart';
import 'inventory_exit_page.dart';
import 'inventory_history_page.dart';

class InventoryPage extends StatelessWidget {
  InventoryPage({super.key});

  final InventoryService inventoryService = InventoryService();

  final InventoryMovementService movementService = InventoryMovementService();

  @override
  Widget build(BuildContext context) {
    final items = inventoryService.getAllItems();

    final lowStock = inventoryService.getLowStockItems();

    final inventoryValue = inventoryService.getInventoryValue();

    final movements = movementService.getAllMovements();

    final totalEntries = movements.where((m) => m.type == "Entrada").length;

    final totalExits = movements.where((m) => m.type == "Salida").length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EB),
      appBar: AppBar(
        title: const Text("Inventario Inteligente"),
        centerTitle: true,
        backgroundColor: const Color(0xFF8D6E63),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCard(
            context,
            icon: Icons.science_outlined,
            color: Colors.orange,
            title: "Catálogo de Ingredientes",
            subtitle: "Administrar ingredientes",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const IngredientsPage()),
              );
            },
          ),

          _buildCard(
            context,
            icon: Icons.add_box_outlined,
            color: Colors.green,
            title: "Registrar Entrada",
            subtitle: "Comprar materia prima",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const InventoryEntryPage()),
              );
            },
          ),

          _buildCard(
            context,
            icon: Icons.remove_circle_outline,
            color: Colors.deepOrange,
            title: "Registrar Salida",
            subtitle: "Consumo y ajustes",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const InventoryExitPage()),
              );
            },
          ),

          _buildCard(
            context,
            icon: Icons.history,
            color: Colors.indigo,
            title: "Historial de Movimientos",
            subtitle: "Entradas y salidas",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const InventoryHistoryPage()),
              );
            },
          ),

          _buildCard(
            context,
            icon: Icons.inventory_2_outlined,
            color: Colors.blue,
            title: "Stock Actual",
            subtitle: "${items.length} ingredientes",
            onTap: () {},
          ),

          _buildCard(
            context,
            icon: Icons.warning_amber_outlined,
            color: Colors.red,
            title: "Stock Bajo",
            subtitle: "${lowStock.length} alertas",
            onTap: () {},
          ),

          _buildCard(
            context,
            icon: Icons.attach_money,
            color: Colors.teal,
            title: "Valor del Inventario",
            subtitle: "\$${inventoryValue.toStringAsFixed(2)}",
            onTap: () {},
          ),

          const SizedBox(height: 25),

          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    "Resumen General",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  ListTile(
                    leading: const Icon(Icons.inventory, color: Colors.blue),
                    title: const Text("Ingredientes"),
                    trailing: Text(
                      items.length.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  ListTile(
                    leading: const Icon(Icons.input, color: Colors.green),
                    title: const Text("Entradas registradas"),
                    trailing: Text(
                      totalEntries.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  ListTile(
                    leading: const Icon(Icons.output, color: Colors.deepOrange),
                    title: const Text("Salidas registradas"),
                    trailing: Text(
                      totalExits.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.warning, color: Colors.red),
                    title: const Text("Alertas"),
                    trailing: Text(
                      lowStock.length.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  const Divider(height: 30),

                  ListTile(
                    leading: const Icon(
                      Icons.attach_money,
                      color: Colors.green,
                    ),
                    title: const Text(
                      "Valor del Inventario",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      "\$${inventoryValue.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(subtitle),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: onTap,
      ),
    );
  }
}
