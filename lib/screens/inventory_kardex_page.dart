import 'package:flutter/material.dart';

import '../core/inventory/unit_converter.dart';
import '../models/ingredient_catalog.dart';
import '../models/inventory_movement.dart';
import '../services/inventory_kardex_service.dart';

class InventoryKardexPage extends StatelessWidget {
  final IngredientCatalog ingredient;

  const InventoryKardexPage({
    super.key,
    required this.ingredient,
  });

  @override
  Widget build(BuildContext context) {
    final kardexService = InventoryKardexService();

    final movements = kardexService.getHistory(ingredient.id);

    double purchasedPackages = 0;

    for (final movement in movements) {
      final type = movement.type.trim().toLowerCase();

      if (type == 'entrada' || type == 'compra') {
        purchasedPackages += movement.quantity;
      }
    }

    final consumed =
        kardexService.getTotalConsumedNormalized(ingredient);

    final available =
        kardexService.getAvailableStockNormalized(ingredient);

    final normalizedPerPackage = UnitConverter.normalize(
      quantity: 1,
      packageSize: ingredient.packageSize,
      packageUnit: ingredient.packageUnit,
      consumptionUnit: ingredient.unit,
    );

    final purchasePrice =
        kardexService.getLastPurchasePrice(ingredient);

    final costPerConsumptionUnit =
        normalizedPerPackage > 0
            ? purchasePrice / normalizedPerPackage
            : 0;

    final inventoryValue =
        available * costPerConsumptionUnit;

    final purchaseUnit = ingredient.purchaseUnit.isEmpty
        ? 'unidad'
        : ingredient.purchaseUnit;

    return Scaffold(
      appBar: AppBar(
        title: Text(ingredient.name),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(
                    Icons.inventory_2,
                    size: 60,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    ingredient.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${ingredient.category} • ${ingredient.unit}',
                  ),
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
                  title: const Text('Comprado'),
                  trailing: Text(
                    '${purchasedPackages.toStringAsFixed(2)} '
                    '$purchaseUnit',
                  ),
                ),

                const Divider(height: 1),

                ListTile(
                  leading: const Icon(Icons.remove_circle),
                  title: const Text('Consumido'),
                  trailing: Text(
                    '${consumed.toStringAsFixed(2)} '
                    '${ingredient.unit}',
                  ),
                ),

                const Divider(height: 1),

                ListTile(
                  leading: const Icon(Icons.inventory),
                  title: const Text('Disponible'),
                  trailing: Text(
                    '${available.toStringAsFixed(2)} '
                    '${ingredient.unit}',
                  ),
                ),

                const Divider(height: 1),

                ListTile(
                  leading: const Icon(Icons.attach_money),
                  title: const Text('Precio de compra'),
                  trailing: Text(
                    '\$${purchasePrice.toStringAsFixed(2)} '
                    '/ $purchaseUnit',
                  ),
                ),

                const Divider(height: 1),

                ListTile(
                  leading: const Icon(Icons.scale),
                  title: Text(
                    'Costo por ${ingredient.unit}',
                  ),
                  trailing: Text(
                    '\$${costPerConsumptionUnit.toStringAsFixed(2)}',
                  ),
                ),

                const Divider(height: 1),

                ListTile(
                  leading: const Icon(Icons.calculate),
                  title: const Text('Valor del inventario'),
                  trailing: Text(
                    '\$${inventoryValue.toStringAsFixed(2)}',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Historial de movimientos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          if (movements.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    'No existen movimientos.',
                  ),
                ),
              ),
            ),

          ...movements.map(
            (InventoryMovement movement) {
              final type = movement.type.trim().toLowerCase();

              final isEntry =
                  type == 'entrada' || type == 'compra';

              return Card(
                child: ListTile(
                  leading: Icon(
                    isEntry
                        ? Icons.add_circle
                        : Icons.remove_circle,
                  ),
                  title: Text(movement.type),
                  subtitle: Text(
                    '${movement.reference}\n'
                    '${movement.quantity.toStringAsFixed(2)} '
                    '${movement.unit}'
                    '${isEntry && movement.purchasePrice > 0 ? '\nPrecio: \$${movement.purchasePrice.toStringAsFixed(2)}' : ''}',
                  ),
                  isThreeLine: true,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
