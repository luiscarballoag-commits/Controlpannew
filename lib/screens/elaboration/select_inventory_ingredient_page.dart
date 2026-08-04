import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/ingredient_catalog.dart';

class SelectInventoryIngredientPage extends StatelessWidget {
  const SelectInventoryIngredientPage({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<IngredientCatalog>('ingredients');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Seleccionar ingrediente"),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<IngredientCatalog> box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text(
                "No hay ingredientes registrados.",
              ),
            );
          }

          final ingredients = box.values.toList();

          return ListView.builder(
            itemCount: ingredients.length,
            itemBuilder: (context, index) {
              final ingredient = ingredients[index];

              return ListTile(
                leading: const Icon(Icons.inventory_2),
                title: Text(ingredient.name),
                subtitle: Text(
                  "Disponible: ${ingredient.normalizedStock.toStringAsFixed(2)} ${ingredient.unit}",
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context, ingredient);
                },
              );
            },
          );
        },
      ),
    );
  }
}
