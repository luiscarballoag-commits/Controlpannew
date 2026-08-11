import 'package:flutter/material.dart';

import '../services/ingredient_service.dart';
import '../services/inventory_presentation_service.dart';
import 'ingredient_editor_page.dart';
import 'inventory_kardex_page.dart';
import 'inventory_entry_page.dart';
import 'inventory_exit_page.dart';
import '../core/inventory/inventory_category_style.dart';

class IngredientsPage extends StatefulWidget {
  const IngredientsPage({super.key});

  @override
  State<IngredientsPage> createState() => _IngredientsPageState();
}

class _IngredientsPageState extends State<IngredientsPage> {
  final IngredientService ingredientService = IngredientService();

  Future<void> deleteIngredient(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Eliminar ingrediente"),
        content: const Text("¿Está seguro de eliminar este ingrediente?"),
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

    if (confirm != true) return;

    ingredientService.deleteIngredient(index);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final ingredients = ingredientService.getAllIngredients();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Catálogo de Ingredientes"),
        centerTitle: true,
      ),
      body: ingredients.isEmpty
          ? const Center(
              child: Text(
                "Aún no tienes ingredientes.\n\nPulsa + para crear el primero.",
                textAlign: TextAlign.center,
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
                    leading: CircleAvatar(
                      backgroundColor: InventoryCategoryStyle.color(
                        ingredient.category,
                      ),
                      child: Icon(
                        InventoryCategoryStyle.icon(ingredient.category),
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      ingredient.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("📂 ${ingredient.category}"),
                        Text(
                          "📦 Compra: ${ingredient.purchaseUnit} (${ingredient.packageSize} ${ingredient.packageUnit})",
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Stock: ${InventoryPresentationService.formatStock(ingredient)}",
                        ),
                        Text(
                          "⚠️ Mínimo: ${ingredient.minimumStock.toStringAsFixed(2)} ${ingredient.unit}",
                        ),
                        Text(
                          "💲 Precio: \$${ingredient.purchasePrice.toStringAsFixed(2)}",
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) async {
                        switch (value) {
                          case 'edit':
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => IngredientEditorPage(
                                  ingredient: ingredient,
                                  index: index,
                                ),
                              ),
                            );
                            setState(() {});
                            break;

                          case 'entry':
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const InventoryEntryPage(),
                              ),
                            );
                            setState(() {});
                            break;

                          case 'exit':
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const InventoryExitPage(),
                              ),
                            );
                            setState(() {});
                            break;

                          case 'kardex':
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    InventoryKardexPage(ingredient: ingredient),
                              ),
                            );
                            break;

                          case 'delete':
                            deleteIngredient(index);
                            break;
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: 'edit', child: Text('✏️ Editar')),
                        PopupMenuItem(value: 'entry', child: Text('➕ Entrada')),
                        PopupMenuItem(value: 'exit', child: Text('➖ Salida')),
                        PopupMenuItem(
                          value: 'kardex',
                          child: Text('📋 Ver Kardex'),
                        ),
                        PopupMenuDivider(),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('🗑️ Eliminar'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const IngredientEditorPage()),
          );

          setState(() {});
        },
        icon: const Icon(Icons.add),
        label: const Text("Ingrediente"),
      ),
    );
  }
}
