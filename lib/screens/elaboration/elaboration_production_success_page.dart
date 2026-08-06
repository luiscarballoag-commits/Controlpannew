import 'package:flutter/material.dart';

import '../../models/elaboration/consumption_item.dart';

class ElaborationProductionSuccessPage extends StatelessWidget {
  final String productName;
  final int quantity;
  final List<ConsumptionItem> ingredients;

  const ElaborationProductionSuccessPage({
    super.key,
    required this.productName,
    required this.quantity,
    required this.ingredients,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Producción finalizada"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 90,
            ),
            const SizedBox(height: 12),
            Text(
              productName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "$quantity unidades elaboradas",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Ingredientes consumidos",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: ingredients.length,
                itemBuilder: (_, index) {
                  final item = ingredients[index];

                  return ListTile(
                    leading: const Icon(Icons.inventory_2),
                    title: Text(item.ingredientName),
                    trailing: Text(
                      "${item.quantity.toStringAsFixed(2)} ${item.unit}",
                    ),
                  );
                },
              ),
            ),

            Text(
              "Fecha: ${now.day}/${now.month}/${now.year}",
            ),

            Text(
              "Hora: ${now.hour}:${now.minute.toString().padLeft(2, '0')}",
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text("FINALIZAR"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
