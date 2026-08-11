import 'package:flutter/material.dart';

import '../models/ingredient_catalog.dart';
import '../services/ingredient_service.dart';

class SelectIngredientPage extends StatelessWidget {
  const SelectIngredientPage({super.key});

  @override
  Widget build(BuildContext context) {
    final IngredientService ingredientService = IngredientService();

    final List<IngredientCatalog> ingredients = ingredientService
        .getAllIngredients();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Seleccionar ingrediente"),
        centerTitle: true,
      ),
      body: ingredients.isEmpty
          ? const Center(
              child: Text(
                "No hay ingredientes registrados.",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: ingredients.length,
              itemBuilder: (context, index) {
                final ingredient = ingredients[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.inventory),
                    title: Text(ingredient.name),
                    subtitle: Text(
                      "${ingredient.category} • ${ingredient.unit}",
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.pop(context, ingredient);
                    },
                  ),
                );
              },
            ),
    );
  }
}
