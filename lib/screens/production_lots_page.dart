import 'package:flutter/material.dart';

import '../models/recipe.dart';
import 'production_summary_page.dart';

class ProductionLotsPage extends StatefulWidget {
  final Recipe recipe;

  const ProductionLotsPage({super.key, required this.recipe});

  @override
  State<ProductionLotsPage> createState() => _ProductionLotsPageState();
}

class _ProductionLotsPageState extends State<ProductionLotsPage> {
  final TextEditingController lotsController = TextEditingController(text: "1");

  final TextEditingController pieceWeightController = TextEditingController(
    text: "250",
  );

  @override
  void dispose() {
    lotsController.dispose();
    pieceWeightController.dispose();
    super.dispose();
  }

  Widget buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Producción Inteligente"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.menu_book),
                title: Text(widget.recipe.name),
                subtitle: Text(
                  "${widget.recipe.ingredients.length} ingredientes",
                ),
              ),
            ),

            const SizedBox(height: 24),

            buildField("Cantidad de lotes", lotsController),

            buildField("Peso por pieza (g)", pieceWeightController),

            const SizedBox(height: 30),

            SizedBox(
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.arrow_forward),
                label: const Text(
                  "CONTINUAR",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductionSummaryPage(
                        recipe: widget.recipe,
                        lots: double.tryParse(lotsController.text) ?? 1,
                        pieceWeight:
                            double.tryParse(pieceWeightController.text) ?? 250,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
