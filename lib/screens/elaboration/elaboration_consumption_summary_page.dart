import 'package:flutter/material.dart';

import '../../services/elaboration/elaboration_consumption_service.dart';
import "../../models/elaboration/consumption_item.dart";
import 'elaboration_production_success_page.dart';

class ElaborationConsumptionSummaryPage extends StatelessWidget {
  final List<ConsumptionItem> ingredients;
  final String productName;

  final int quantity;


  ElaborationConsumptionSummaryPage({
    super.key,
      required this.productName,
      required this.quantity,
    required this.ingredients,
  });

  final ElaborationConsumptionService consumptionService =
      ElaborationConsumptionService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Resumen de Consumo"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ingredients.isEmpty
                ? const Center(
                    child: Text(
                      "No hay ingredientes para mostrar.",
                    ),
                  )
                : ListView.builder(
                    itemCount: ingredients.length,
                    itemBuilder: (context, index) {
                        final item = ingredients[index];
                        

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: const Icon(
                            Icons.inventory_2,
                          ),
                          title: Text(item.ingredientName),
                          trailing: Text(
                            item.quantity.toStringAsFixed(2),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("CANCELAR"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await consumptionService.consume(
                        ingredients,
                      );

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Inventario actualizado correctamente.",
                          ),
                        ),
                      );

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ElaborationProductionSuccessPage(
                              productName: "Producción realizada",
                              quantity: 0,
                              ingredients: ingredients,
                            ),
                          ),
                        );
                    },
                    child: const Text("CONFIRMAR"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
