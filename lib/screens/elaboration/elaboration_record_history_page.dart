import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/elaboration/elaboration_record.dart';

class ElaborationRecordHistoryPage extends StatelessWidget {
  const ElaborationRecordHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final box =
        Hive.box<ElaborationRecord>('elaboration_records');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Historial de Elaboraciones"),
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<ElaborationRecord> box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text(
                "No existen elaboraciones registradas",
              ),
            );
          }

            final records = box.values.toList();

            final grouped = <String, List<ElaborationRecord>>{};

            for (final record in records) {
              grouped.putIfAbsent(record.productionId, () => []);
              grouped[record.productionId]!.add(record);
            }

            final productionIds = grouped.keys.toList().reversed.toList();

          return ListView.builder(
            itemCount: productionIds.length,
            itemBuilder: (_, index) {
                final productionId = productionIds[index];
                final items = grouped[productionId]!;

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Producción: $productionId",
                          style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                        ),
                        const Divider(),
                        ...items.map((e) => ListTile(
                              dense: true,
                              leading: const Icon(Icons.bakery_dining),
                              title: Text(e.productName),
                              trailing: Text("${e.quantity}"),
                            )),
                      ],
                    ),
                  ),
                );
            },
          );
        },
      ),
    );
  }
}
