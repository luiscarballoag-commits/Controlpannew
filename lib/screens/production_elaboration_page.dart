import 'package:flutter/material.dart';

import 'add_elaboration_dialog.dart';

class ProductionElaborationPage extends StatefulWidget {
  final String productionId;
  final int availablePieces;

  const ProductionElaborationPage({
    super.key,
    required this.productionId,
    required this.availablePieces,
  });

  @override
  State<ProductionElaborationPage> createState() =>
      _ProductionElaborationPageState();
}

class _ProductionElaborationPageState
    extends State<ProductionElaborationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EB),
      appBar: AppBar(
        title: const Text("Elaboración"),
        centerTitle: true,
        backgroundColor: const Color(0xFF8D6E63),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8D6E63),
        child: const Icon(Icons.add),
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (_) => const AddElaborationDialog(),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Producción: ${widget.productionId}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Panes disponibles: ${widget.availablePieces}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 25),
            const Expanded(
              child: Center(
                child: Text(
                  "No hay elaboraciones registradas.",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
