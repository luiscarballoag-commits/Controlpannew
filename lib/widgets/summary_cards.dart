import 'package:flutter/material.dart';

class SummaryCards extends StatelessWidget {
  const SummaryCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _summaryCard(Icons.inventory_2, "Ingredientes", "0", Colors.orange),

        _summaryCard(Icons.bakery_dining, "Producciones", "0", Colors.brown),

        _summaryCard(
          Icons.attach_money,
          "Costo promedio",
          "\$0.00",
          Colors.green,
        ),

        _summaryCard(Icons.warning_amber_rounded, "Alertas", "0", Colors.red),
      ],
    );
  }

  Widget _summaryCard(IconData icon, String title, String value, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}
