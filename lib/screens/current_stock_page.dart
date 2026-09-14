import 'package:flutter/material.dart';

import '../models/ingredient_catalog.dart';
import '../services/inventory_service.dart';

class CurrentStockPage extends StatelessWidget {
  CurrentStockPage({super.key});

  final InventoryService inventoryService = InventoryService();

  @override
  Widget build(BuildContext context) {
    final items = inventoryService.getAllItems();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EB),
      appBar: AppBar(
        title: const Text('Stock Actual'),
        centerTitle: true,
        backgroundColor: const Color(0xFF8D6E63),
        foregroundColor: Colors.white,
      ),
      body: items.isEmpty
          ? const Center(
              child: Text(
                'No hay ingredientes registrados.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return _buildIngredientCard(items[index]);
              },
            ),
    );
  }

  Widget _buildIngredientCard(IngredientCatalog ingredient) {
    final isLowStock =
        ingredient.normalizedStock <= ingredient.minimumStock;

    final stock = ingredient.normalizedStock;
    final unit = ingredient.unit.isNotEmpty ? ingredient.unit : 'unidad';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor:
                  isLowStock ? Colors.red : Colors.blue,
              child: Icon(
                isLowStock
                    ? Icons.warning_amber_rounded
                    : Icons.inventory_2_outlined,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ingredient.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Stock disponible',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${_formatQuantity(stock)} $unit',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isLowStock
                          ? Colors.red
                          : Colors.green.shade700,
                    ),
                  ),
                  if (ingredient.minimumStock > 0) ...[
                    const SizedBox(height: 3),
                    Text(
                      'Mínimo: ${_formatQuantity(ingredient.minimumStock)} $unit',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatQuantity(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(2);
  }
}
