import 'package:flutter/material.dart';

class ProductComponentsPage extends StatefulWidget {
  const ProductComponentsPage({super.key});

  @override
  State<ProductComponentsPage> createState() =>
      _ProductComponentsPageState();
}

class _ProductComponentsPageState
    extends State<ProductComponentsPage> {
  final List<Map<String, dynamic>> components = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EB),
      appBar: AppBar(
        title: const Text("Componentes"),
        centerTitle: true,
        backgroundColor: const Color(0xFF8D6E63),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8D6E63),
        child: const Icon(Icons.add),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Agregar componente próximamente",
              ),
            ),
          );
        },
      ),
      body: components.isEmpty
          ? const Center(
              child: Text(
                "Este producto no tiene componentes.",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: components.length,
              itemBuilder: (context, index) {
                final component = components[index];

                return Card(
                  margin:
                      const EdgeInsets.only(bottom: 12),
                  elevation: 4,
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.orange,
                      child: Icon(
                        Icons.inventory_2,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      component["name"],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "${component["grams"]} g por pieza",
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          SnackBar(
                            content: Text(
                              "$value próximamente",
                            ),
                          ),
                        );
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: "Editar",
                          child: Text("Editar"),
                        ),
                        PopupMenuItem(
                          value: "Eliminar",
                          child: Text("Eliminar"),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
