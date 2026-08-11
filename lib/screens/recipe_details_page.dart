import 'package:flutter/material.dart';

import '../models/recipe.dart';

class RecipeDetailsPage extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailsPage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe.name), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Descripción",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    recipe.description.isEmpty
                        ? "Sin descripción"
                        : recipe.description,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Ingredientes",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          ...recipe.ingredients.map(
            (ingredient) => Card(
              child: ListTile(
                leading: const Icon(Icons.inventory),
                title: Text(ingredient.name),
                trailing: Text("${ingredient.quantity} ${ingredient.unit}"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
