import 'package:flutter/material.dart';

import '../../models/elaboration/elaboration_recipe.dart';
import '../../services/elaboration/elaboration_recipe_service.dart';
import 'elaboration_recipe_form_page.dart';

class ElaborationRecipeListPage extends StatefulWidget {
  const ElaborationRecipeListPage({super.key});

  @override
  State<ElaborationRecipeListPage> createState() =>
      _ElaborationRecipeListPageState();
}

class _ElaborationRecipeListPageState extends State<ElaborationRecipeListPage> {
  final ElaborationRecipeService recipeService = ElaborationRecipeService();

  @override
  Widget build(BuildContext context) {
    final List<ElaborationRecipe> recipes = recipeService.getAllRecipes();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Recetas de Elaboración"),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ElaborationRecipeFormPage(),
            ),
          );

          if (!mounted) return;

          if (result == true) {
            setState(() {});
          }
        },
        icon: const Icon(Icons.add),
        label: const Text("Nueva"),
      ),

      body: recipes.isEmpty
          ? const Center(child: Text("No existen recetas de elaboración."))
          : ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (_, index) {
                final recipe = recipes[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ExpansionTile(
                    leading: const Icon(Icons.bakery_dining),
                    title: Text(recipe.name),
                    subtitle: Text("${recipe.ingredients.length} ingredientes"),
                    children: [
                      ...recipe.ingredients.map(
                        (ingredient) => ListTile(
                          dense: true,
                          leading: const Icon(Icons.inventory_2),
                          title: Text(ingredient.ingredientName),
                          trailing: Text(
                            "${ingredient.quantity} ${ingredient.unit}",
                          ),
                        ),
                      ),

                      const Divider(),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              // editar (próximo paso)
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text("Editar"),
                          ),

                          TextButton.icon(
                            onPressed: () {
                              recipeService.deleteRecipe(recipe.id);

                              setState(() {});
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
                            label: const Text(
                              "Eliminar",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
