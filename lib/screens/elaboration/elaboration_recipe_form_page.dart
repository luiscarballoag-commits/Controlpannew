import 'package:flutter/material.dart';

import '../../models/ingredient_catalog.dart';
import '../../models/elaboration/elaboration_ingredient.dart';
import '../../models/elaboration/elaboration_recipe.dart';
import '../../services/elaboration/elaboration_recipe_service.dart';

import 'select_inventory_ingredient_page.dart';

class ElaborationRecipeFormPage extends StatefulWidget {
  const ElaborationRecipeFormPage({super.key});

  @override
  State<ElaborationRecipeFormPage> createState() =>
      _ElaborationRecipeFormPageState();
}

class _ElaborationRecipeFormPageState
    extends State<ElaborationRecipeFormPage> {
  final TextEditingController _nameController =
      TextEditingController();

  final ElaborationRecipeService recipeService =
      ElaborationRecipeService();

  final List<Map<String, dynamic>> ingredients = [];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> addIngredient() async {
    final IngredientCatalog? ingredient =
        await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const SelectInventoryIngredientPage(),
      ),
    );

    if (!mounted || ingredient == null) return;

    final quantityController =
        TextEditingController();

    final quantity =
        await showDialog<double>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(ingredient.name),
          content: TextField(
            controller: quantityController,
            keyboardType:
                const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: InputDecoration(
              labelText:
                  "Cantidad por producto (${ingredient.unit})",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  double.tryParse(
                        quantityController.text,
                      ) ??
                      0,
                );
              },
              child: const Text("Aceptar"),
            ),
          ],
        );
      },
    );

    if (quantity == null || quantity <= 0) {
      return;
    }

    setState(() {
      ingredients.add({
        "id": ingredient.id,
        "name": ingredient.name,
        "quantity": quantity,
        "unit": ingredient.unit,
      });
    });
  }

  void saveRecipe() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Debe indicar el nombre del producto.",
          ),
        ),
      );
      return;
    }

    if (ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Debe agregar al menos un ingrediente.",
          ),
        ),
      );
      return;
    }

    final recipeId = DateTime.now()
        .millisecondsSinceEpoch
        .toString();

    final recipe = ElaborationRecipe(
      id: recipeId,
      name: _nameController.text.trim(),
      ingredients: ingredients.map((item) {
        return ElaborationIngredient(
          ingredientId: item["id"],
          ingredientName: item["name"],
          quantity: item["quantity"],
          unit: item["unit"],
        );
      }).toList(),
    );

    recipeService.saveRecipe(recipe);

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Nueva Receta de Elaboración",
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              decoration:
                  const InputDecoration(
                labelText:
                    "Nombre del producto",
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Ingredientes",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 10),

            if (ingredients.isEmpty)
              const Card(
                child: Padding(
                  padding:
                      EdgeInsets.all(16),
                  child: Text(
                    "No hay ingredientes agregados.",
                  ),
                ),
              ),

            ...ingredients.map(
              (ingredient) => Card(
                child: ListTile(
                  leading:
                      const Icon(Icons.inventory),
                  title: Text(
                    ingredient["name"],
                  ),
                  subtitle: Text(
                    "${ingredient["quantity"]} ${ingredient["unit"]}",
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      setState(() {
                        ingredients.remove(
                          ingredient,
                        );
                      });
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 55,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text(
                  "AGREGAR INGREDIENTE",
                ),
                onPressed: addIngredient,
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              height: 55,
              child: ElevatedButton(
                onPressed: saveRecipe,
                child:
                    const Text("GUARDAR"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
