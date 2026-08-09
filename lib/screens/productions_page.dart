import 'package:flutter/material.dart';

import '../models/elaboration/elaboration_production.dart';
import '../services/elaboration/elaboration_production_service.dart';
import '../services/production_service.dart';
import 'production_detail_page.dart';

class ProductionsPage extends StatefulWidget {
  const ProductionsPage({super.key});

  @override
  State<ProductionsPage> createState() => _ProductionsPageState();
}

class _ProductionsPageState extends State<ProductionsPage> {
  final ProductionService productionService = ProductionService();
  final ElaborationProductionService elaborationService =
      ElaborationProductionService();

  @override
  Widget build(BuildContext context) {
    final productions = productionService.getAllProductions();
    final elaborations = elaborationService.getAll();

    final linkedElaborations = <String, List<ElaborationProduction>>{};

    final unlinkedElaborations = <ElaborationProduction>[];

    for (final elaboration in elaborations) {
      final productionId = elaboration.productionId;

      if (productionId == null || productionId.isEmpty) {
        unlinkedElaborations.add(elaboration);
        continue;
      }

      linkedElaborations.putIfAbsent(productionId, () => []);
      linkedElaborations[productionId]!.add(elaboration);
    }

    final hasHistory =
        productions.isNotEmpty || unlinkedElaborations.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Historial de Producción"),
        centerTitle: true,
      ),
      body: !hasHistory
          ? const Center(
              child: Text(
                "Todavía no existen producciones registradas.",
                textAlign: TextAlign.center,
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ...productions.map((production) {
                  final elaborationsForProduction =
                      linkedElaborations[production.id] ?? [];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ProductionDetailPage(production: production),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  child: Icon(Icons.bakery_dining),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    "${production.id} • ${production.recipeName}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const Icon(Icons.chevron_right),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Tipo: Producción de masa",
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                            Text("Lotes: ${production.lots}"),
                            Text(
                              "Masa: ${production.totalMassKg.toStringAsFixed(2)} kg",
                            ),
                            Text("Panes: ${production.totalPieces}"),
                            Text(production.date.toString().substring(0, 16)),

                            if (elaborationsForProduction.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              const Divider(),
                              const SizedBox(height: 6),
                              const Text(
                                "Elaboraciones",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),

                              ...elaborationsForProduction.map(
                                (elaboration) => Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.brown.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.bakery_dining, size: 22),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          elaboration.recipeName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "${elaboration.quantity}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                }),

                if (unlinkedElaborations.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Text(
                    "Elaboraciones sin producción asociada",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  const SizedBox(height: 8),

                  ...unlinkedElaborations.map(
                    (elaboration) => Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.bakery_dining),
                        ),
                        title: Text(
                          elaboration.recipeName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          elaboration.date.toString().substring(0, 16),
                        ),
                        trailing: Text(
                          "${elaboration.quantity}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}
