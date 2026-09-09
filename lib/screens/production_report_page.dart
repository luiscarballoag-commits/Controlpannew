import 'package:flutter/material.dart';

import '../models/production.dart';
import '../services/production_service.dart';
import '../services/elaboration/elaboration_record_service.dart';

class ProductionReportPage extends StatelessWidget {
  ProductionReportPage({super.key});

  final ProductionService productionService = ProductionService();
  final ElaborationRecordService elaborationRecordService =
      ElaborationRecordService();

  @override
  Widget build(BuildContext context) {
    final productions = productionService.getAllProductions();

    int totalLots = 0;
    double totalMassKg = 0;
    int totalPieces = 0;

    for (final production in productions) {
      totalLots += production.lots;
      totalMassKg += production.totalMassKg;
      totalPieces += production.totalPieces;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporte de Producción'),
        centerTitle: true,
      ),
      body: productions.isEmpty
          ? const Center(
              child: Text(
                'Todavía no existen producciones registradas.',
                textAlign: TextAlign.center,
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        icon: Icons.factory,
                        title: 'Producciones',
                        value: productions.length.toString(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildSummaryCard(
                        icon: Icons.layers,
                        title: 'Lotes',
                        value: totalLots.toString(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        icon: Icons.scale,
                        title: 'Kg producidos',
                        value: totalMassKg.toStringAsFixed(2),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildSummaryCard(
                        icon: Icons.bakery_dining,
                        title: 'Piezas',
                        value: totalPieces.toString(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Historial de Producción',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...productions.map(
                  (production) => _buildProductionCard(production),
                ),
              ],
            ),
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Icon(icon, size: 30),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductionCard(Production production) {
    final date = production.date.toString().substring(0, 16);

    final records = elaborationRecordService
        .getAll()
        .where((record) => record.productionId == production.id)
        .toList();

    final Map<String, int> varieties = {};

    for (final record in records) {
      varieties[record.productName] =
          (varieties[record.productName] ?? 0) + record.quantity;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
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
                    '${production.id} • ${production.recipeName}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Fecha: $date'),
            Text('Lotes: ${production.lots}'),
            Text(
              'Masa: ${production.totalMassKg.toStringAsFixed(2)} kg',
            ),
            Text('Piezas: ${production.totalPieces}'),
            Text(
              'Peso por pieza: '
              '${production.pieceWeightGrams.toStringAsFixed(0)} g',
            ),

            if (varieties.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                'Variedades producidas',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...varieties.entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.bakery_dining,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          entry.key,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Text(
                        '${entry.value} piezas',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            if (production.notes.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Observaciones: ${production.notes}'),
            ],
          ],
        ),
      ),
    );
  }
}
