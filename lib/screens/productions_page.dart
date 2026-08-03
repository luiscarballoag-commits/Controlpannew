import 'package:flutter/material.dart';

import '../services/production_service.dart';
import 'production_detail_page.dart';

class ProductionsPage extends StatefulWidget {
  const ProductionsPage({super.key});

  @override
  State<ProductionsPage> createState() =>
      _ProductionsPageState();
}

class _ProductionsPageState
    extends State<ProductionsPage> {
  final ProductionService productionService =
      ProductionService();

  @override
  Widget build(BuildContext context) {
    final productions =
        productionService.getAllProductions();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Historial de Producción",
        ),
        centerTitle: true,
      ),
      body: productions.isEmpty
          ? const Center(
              child: Text(
                "Todavía no existen producciones registradas.",
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: productions.length,
              itemBuilder: (context, index) {
                final production =
                    productions[index];

                return Card(
                  margin:
                      const EdgeInsets.only(
                    bottom: 12,
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(
                        Icons.bakery_dining,
                      ),
                    ),
                      title: Text(
                        "${production.id} • ${production.recipeName}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    subtitle: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Lotes: ${production.lots}",
                        ),
                        Text(
                          "Masa: ${production.totalMassKg.toStringAsFixed(2)} kg",
                        ),
                        Text(
                          "Panes: ${production.totalPieces}",
                        ),
                        Text(
                          production.date
                              .toString()
                              .substring(0, 16),
                        ),
                      ],
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ProductionDetailPage(
                            production:
                                production,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
