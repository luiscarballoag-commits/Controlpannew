import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/product_service.dart';
import 'product_editor_page.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final ProductService productService = ProductService();

  @override
  Widget build(BuildContext context) {
    final List<Product> products = productService.getAllProducts();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EB),
      appBar: AppBar(
        title: const Text("Productos"),
        centerTitle: true,
        backgroundColor: const Color(0xFF8D6E63),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8D6E63),
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ProductEditorPage(),
            ),
          );

          setState(() {});
        },
      ),
      body: products.isEmpty
          ? const Center(
              child: Text(
                "No hay productos registrados.",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 4,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: product.isFilled
                          ? Colors.orange
                          : Colors.brown,
                      child: const Icon(
                        Icons.bakery_dining,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "Peso: ${product.pieceWeightGrams.toStringAsFixed(0)} g",
                    ),
                  ),
                );
              },
            ),
    );
  }
}
