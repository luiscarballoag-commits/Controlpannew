import 'package:flutter/material.dart';

class ProductionProductPage extends StatelessWidget {
  final String productName;

  const ProductionProductPage({
    super.key,
    required this.productName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productName),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.inventory_2),
                title: Text(productName),
                subtitle: const Text(
                  "Aquí se realizará la elaboración del producto.",
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Esta pantalla será utilizada para:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            const ListTile(
              leading: Icon(Icons.check_circle_outline),
              title: Text("Registrar cantidad elaborada"),
            ),
            const ListTile(
              leading: Icon(Icons.check_circle_outline),
              title: Text("Descontar rellenos automáticamente"),
            ),
            const ListTile(
              leading: Icon(Icons.check_circle_outline),
              title: Text("Descontar envoltorios"),
            ),
            const ListTile(
              leading: Icon(Icons.check_circle_outline),
              title: Text("Guardar lote elaborado"),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Módulo en construcción.",
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.build),
              label: const Text("Continuar"),
            ),
          ],
        ),
      ),
    );
  }
}
