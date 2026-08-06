import 'package:flutter/material.dart';

import '../models/elaboration/elaboration_recipe.dart';
import '../services/elaboration/elaboration_recipe_service.dart';
import '../services/elaboration/elaboration_production_service.dart';
import '../models/elaboration/consumption_item.dart';

import 'elaboration/elaboration_recipe_list_page.dart';
import 'elaboration/elaboration_consumption_summary_page.dart';
import 'elaboration/elaboration_production_history_page.dart';

class ProductionElaborationPage extends StatefulWidget {
  final int availablePieces;

  const ProductionElaborationPage({
    super.key,
    required this.availablePieces,
  });

  @override
  State<ProductionElaborationPage> createState() =>
      _ProductionElaborationPageState();
}

class _ProductionElaborationPageState
    extends State<ProductionElaborationPage> {
  final ElaborationRecipeService recipeService =
      ElaborationRecipeService();

  final ElaborationProductionService productionService =
      ElaborationProductionService();


  final Map<String, TextEditingController> controllers = {};

  @override
  void initState() {
    super.initState();

    final recipes = recipeService.getAllRecipes();

    for (final recipe in recipes) {
      controllers[recipe.name] =
          TextEditingController(text: "0");
    }
  }

  int get totalAssigned {
    int total = 0;

    for (final controller in controllers.values) {
      total += int.tryParse(controller.text) ?? 0;
    }

    return total;
  }

  int get remaining =>
      widget.availablePieces - totalAssigned;

  @override
  void dispose() {
    for (final controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<ElaborationRecipe> recipes =
        recipeService.getAllRecipes();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Elaboración de Productos"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.brown.shade50,
            child: Column(
              children: [
                Text(
                  "Panes disponibles: ${widget.availablePieces}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Restantes: $remaining",
                  style: TextStyle(
                    color: remaining < 0
                        ? Colors.red
                        : Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding:
                const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.menu_book),
                label: const Text(
                  "RECETAS DE ELABORACIÓN",
                ),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const ElaborationRecipeListPage(),
                    ),
                  );

                  if (!mounted) return;

                  setState(() {});
                },
              ),
            ),
          ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.history),
                  label: const Text("HISTORIAL DE ELABORACIONES"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ElaborationProductionHistoryPage(),
                      ),
                    );
                  },
                ),
              ),
            ),

          Expanded(
            child: recipes.isEmpty
                ? const Center(
                    child: Text(
                      "No existen recetas de elaboración.",
                    ),
                  )
                : ListView.builder(
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];

                      return Card(
                        margin:
                            const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: const Icon(
                            Icons.bakery_dining,
                          ),
                          title: Text(recipe.name),
                          subtitle: Text(
                            "${recipe.ingredients.length} ingredientes",
                          ),
                          trailing: SizedBox(
                            width: 80,
                            child: TextField(
                              controller:
                                  controllers[recipe.name],
                              keyboardType:
                                  TextInputType.number,
                              textAlign:
                                  TextAlign.center,
                              decoration:
                                  const InputDecoration(
                                border:
                                    OutlineInputBorder(),
                              ),
                              onChanged: (_) {
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.arrow_forward),
                label: const Text("CONTINUAR"),
                onPressed: remaining < 0
                    ? null
                    : () async {
                          final List<ConsumptionItem> consumption = [];

                          String lastRecipeName = "";
                          int lastPieces = 0;
                        for (final recipe in recipes) {
                          final pieces =
                              int.tryParse(
                                    controllers[
                                                recipe
                                                    .name]
                                            ?.text ??
                                        "0",
                                  ) ??
                                  0;

                          if (pieces <= 0) continue;

                            await productionService.saveProduction(
                              recipeId: recipe.id,
                              recipeName: recipe.name,
                              quantity: pieces,
                            );
                              lastRecipeName = recipe.name;
                              lastPieces = pieces;



                          for (final ingredient
                              in recipe.ingredients) {
                              consumption.add(
                                ConsumptionItem(
                                  ingredientId: ingredient.ingredientId,
                                  ingredientName: ingredient.ingredientName,
                                  quantity: ingredient.quantity * pieces,
                                    unit: ingredient.unit,
                                ),
                              );
                          }
                        }


                          if (!mounted) return;
                          setState(() {});


                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ElaborationConsumptionSummaryPage(
                                productName: lastRecipeName,
                                quantity: lastPieces,
                                ingredients: consumption,
                              ),
                            ),
                          );

                      },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
