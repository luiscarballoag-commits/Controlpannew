import 'package:flutter/material.dart';

import '../models/ingredient_catalog.dart';
import '../services/ingredient_service.dart';
import '../services/inventory_kardex_service.dart';

class InventoryReportPage extends StatelessWidget {
  InventoryReportPage({super.key});

  final IngredientService _ingredientService = IngredientService();
  final InventoryKardexService _kardexService = InventoryKardexService();

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }

    return value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final ingredients = _ingredientService.getAllIngredients();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporte de Inventario'),
      ),
      body: ingredients.isEmpty
          ? const Center(
              child: Text(
                'No hay ingredientes registrados.',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Existencias actuales',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Resumen del inventario disponible por ingrediente.',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ...ingredients.map(_buildIngredientCard),
              ],
            ),
    );
  }

  Widget _buildIngredientCard(IngredientCatalog ingredient) {
    final purchased =
        _kardexService.getTotalPurchasedNormalized(ingredient);

    final consumed =
        _kardexService.getTotalConsumedNormalized(ingredient);

    final available =
        _kardexService.getAvailableStockNormalized(ingredient);

    final lastPrice =
        _kardexService.getLastPurchasePrice(ingredient);

    final inventoryValue =
        available > 0 ? available * (lastPrice > 0 ? lastPrice : 0) : 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ingredient.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildRow(
              'Comprado',
              '${_formatNumber(purchased)} ${ingredient.unit}',
            ),
            _buildRow(
              'Consumido',
              '${_formatNumber(consumed)} ${ingredient.unit}',
            ),
            _buildRow(
              'Existencia',
              '${_formatNumber(available)} ${ingredient.unit}',
            ),
            _buildRow(
              'Último precio',
              '\$${lastPrice.toStringAsFixed(2)}',
            ),
            const Divider(),
            _buildRow(
              'Valor del inventario',
              '\$${inventoryValue.toStringAsFixed(2)}',
              bold: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(
    String label,
    String value, {
    bool bold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
