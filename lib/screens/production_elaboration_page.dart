import 'package:flutter/material.dart';

class ProductionElaborationPage extends StatefulWidget {
  final int availablePieces;

  const ProductionElaborationPage({
    super.key,
    required this.availablePieces,
  });

  @override
  State<ProductionElaborationPage> createState() =>
      _ProductionElaborationPageState();
}

class _ProductionElaborationPageState
    extends State<ProductionElaborationPage> {

  final List<String> products = [
    "Pan de Jamón",
    "Golfeados",
    "Cachitos",
    "Pan de Queso",
    "Pan de Pizza",
    "Pan Aliñado",
    "Pan Integral",
    "Pan Dulce Especial",
    "Pan de Coco",
    "Pan Andino",
    "Pan Sandwich",
    "Pan Campesino",
  ];

  final Map<String, TextEditingController> controllers = {};

  @override
  void initState() {
    super.initState();

    for (final product in products) {
      controllers[product] = TextEditingController(text: "0");
    }
  }

  int get totalAssigned {
    int total = 0;

    for (final controller in controllers.values) {
      total += int.tryParse(controller.text) ?? 0;
    }

    return total;
  }

  int get remaining =>
      widget.availablePieces - totalAssigned;

  @override
  void dispose() {
    for (final controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Elaboración de Productos"),
        centerTitle: true,
      ),

      body: Column(
        children: [

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.brown.shade50,
            child: Column(
              children: [

                Text(
                  "Panes disponibles: ${widget.availablePieces}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "Restantes: $remaining",
                  style: TextStyle(
                    color: remaining < 0
                        ? Colors.red
                        : Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {

                final product = products[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.bakery_dining),
                    title: Text(product),
                    trailing: SizedBox(
                      width: 80,
                      child: TextField(
                        controller: controllers[product],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (_) {
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.arrow_forward),
                label: const Text(
                  "CONTINUAR",
                ),
                onPressed: remaining < 0
                    ? null
                    : () {

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Próximo paso: ingredientes de relleno.",
                            ),
                          ),
                        );

                    },
              ),
            ),
          ),

        ],
      ),
    );
  }
}
