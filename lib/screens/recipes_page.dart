import 'package:flutter/material.dart';

import '../models/recipe.dart';
import '../services/recipe_service.dart';
import 'recipe_details_page.dart';
import 'recipe_editor_page.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  final RecipeService recipeService = RecipeService();

  Future<void> _deleteRecipe(int index) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Eliminar receta"),
        content: const Text(
          "¿Deseas eliminar esta receta?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Eliminar"),
          ),
        ],
      ),
    );

    if (result == true) {
      recipeService.deleteRecipe(index);

      if (!mounted) return;

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Recipe> recipes =
        recipeService.getAllRecipes();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Recetas"),
        centerTitle: true,
      ),
      body: recipes.isEmpty
          ? const Center(
              child: Text(
                "Aún no tienes recetas.\n\nPulsa + para crear la primera.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.menu_book),
                    ),
                    title: Text(recipe.name),
                    subtitle: Text(
                      "${recipe.ingredients.length} ingredientes",
                    ),
                    trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == "edit") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RecipeEditorPage(
                                  recipe: recipe,
                                  recipeIndex: index,
                                ),
                              ),
                            ).then((_) => setState(() {}));
                          }
                          if (value == "delete") {
                            _deleteRecipe(index);
                          }
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(
                            value: "edit",
                            child: Row(
                              children: [
                                Icon(Icons.edit, color: Colors.blue),
                                SizedBox(width: 10),
                                Text("Editar"),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: "delete",
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red),
                                SizedBox(width: 10),
                                Text("Eliminar"),
                              ],
                            ),
                          ),
                        ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              RecipeDetailsPage(
                            recipe: recipe,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton:
          FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("Nueva receta"),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const RecipeEditorPage(),
            ),
          );

          if (!mounted) return;

          setState(() {});
        },
      ),
    );
  }
}
