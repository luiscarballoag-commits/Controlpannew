import 'package:flutter/material.dart';

import '../models/production.dart';

class ProductionDetailPage extends StatelessWidget {
  final Production production;

  const ProductionDetailPage({
    super.key,
    required this.production,
  });

  Widget infoTile(
    String title,
    String value,
    IconData icon,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(icon),
        ),
        title: Text(title),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EB),
      appBar: AppBar(
        title: const Text(
          "Detalle de Producción",
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(
                    Icons.bakery_dining,
                    size: 70,
                    color: Color(0xFF8D6E63),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    production.id,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    production.recipeName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),          infoTile(
            "Fecha",
            production.date.toString().substring(0, 16),
            Icons.calendar_today,
          ),

          infoTile(
            "Lotes",
            production.lots.toString(),
            Icons.layers,
          ),

          infoTile(
            "Masa Total",
            "${production.totalMassKg.toStringAsFixed(2)} kg",
            Icons.scale,
          ),

          infoTile(
            "Peso por Pieza",
            "${production.pieceWeightGrams.toStringAsFixed(0)} g",
            Icons.straighten,
          ),

          infoTile(
            "Total de Panes",
            production.totalPieces.toString(),
            Icons.bakery_dining,
          ),

          if (production.notes.isNotEmpty)
            infoTile(
              "Observaciones",
              production.notes,
              Icons.notes,
            ),
        ],
      ),
    );
  }
}
