import 'package:flutter/material.dart';

import '../../models/elaboration/elaboration_production.dart';
import '../../services/elaboration/elaboration_production_service.dart';

class ElaborationProductionHistoryPage extends StatelessWidget {
  ElaborationProductionHistoryPage({super.key});

  final ElaborationProductionService service =
      ElaborationProductionService();

  @override
  Widget build(BuildContext context) {
    final List<ElaborationProduction> productions =
        service.getAll();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Historial de Elaboraciones"),
        centerTitle: true,
      ),
      body: productions.isEmpty
          ? const Center(
              child: Text(
                "No existen elaboraciones registradas.",
              ),
            )
          : ListView.builder(
              itemCount: productions.length,
              itemBuilder: (context, index) {
                final production = productions[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.bakery_dining,
                    ),
                    title: Text(production.recipeName),
                    subtitle: Text(
                      production.date.toString(),
                    ),
                    trailing: Text(
                      "${production.quantity}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
