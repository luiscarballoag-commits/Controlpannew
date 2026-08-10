import 'package:flutter/material.dart';

import '../models/recipe.dart';
import '../services/recipe_service.dart';
import 'recipe_editor_page.dart';

class ProductionRecipePage extends StatefulWidget {
  const ProductionRecipePage({super.key});

  @override
  State<ProductionRecipePage> createState() => _ProductionRecipePageState();
}

class _ProductionRecipePageState extends State<ProductionRecipePage> {
  final RecipeService recipeService = RecipeService();

  final TextEditingController searchController = TextEditingController();

  List<Recipe> recipes = [];

  List<Recipe> filteredRecipes = [];

  @override
  void initState() {
    super.initState();

    recipes = recipeService.getAllRecipes();

    filteredRecipes = List.from(recipes);

    searchController.addListener(() {
      final query = searchController.text.toLowerCase();

      setState(() {
        filteredRecipes = recipes
            .where((recipe) => recipe.name.toLowerCase().contains(query))
            .toList();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EB),
      appBar: AppBar(
        title: const Text("Producción Inteligente"),
        centerTitle: true,
        backgroundColor: const Color(0xFF8D6E63),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("Nueva receta"),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RecipeEditorPage()),
          );

          if (!mounted) return;

          setState(() {
            recipes = recipeService.getAllRecipes();
            filteredRecipes = List.from(recipes);
          });
        },
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: "Buscar receta...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),

          Expanded(
            child: filteredRecipes.isEmpty
                ? const Center(
                    child: Text(
                      "No hay recetas disponibles.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = filteredRecipes[index];

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
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () async {
                            final recipeIndex = recipes.indexWhere(
                              (item) => item.id == recipe.id,
                            );

                            if (recipeIndex < 0) return;

                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RecipeEditorPage(
                                  recipe: recipe,
                                  recipeIndex: recipeIndex,
                                ),
                              ),
                            );

                            if (!mounted) return;

                            setState(() {
                              recipes = recipeService.getAllRecipes();

                              final query = searchController.text.toLowerCase();

                              filteredRecipes = recipes
                                  .where(
                                    (item) =>
                                        item.name.toLowerCase().contains(query),
                                  )
                                  .toList();
                            });
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
