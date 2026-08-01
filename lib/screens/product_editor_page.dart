import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/product_service.dart';

class ProductEditorPage extends StatefulWidget {
  const ProductEditorPage({super.key});

  @override
  State<ProductEditorPage> createState() =>
      _ProductEditorPageState();
}

class _ProductEditorPageState
    extends State<ProductEditorPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _weightController = TextEditingController();

  final ProductService productService =
      ProductService();

  bool _isFilled = false;
  bool _isActive = true;

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _saveProduct() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final product = Product(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(),
      name: _nameController.text.trim(),

      massRecipeId: "BASE",
      pieceWeightGrams:
          double.parse(_weightController.text),
      isFilled: _isFilled,
      isActive: _isActive,

      notes: "",
    );

    productService.addProduct(product);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F1EB),
      appBar: AppBar(
        title: const Text("Nuevo Producto"),
        centerTitle: true,
        backgroundColor:
            const Color(0xFF8D6E63),
        foregroundColor:
            Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding:
              const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText:
                    "Nombre del producto",
                border:
                    OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return "Ingrese un nombre";
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            TextFormField(
              controller: _weightController,
              keyboardType:
                  const TextInputType
                      .numberWithOptions(
                decimal: true,
              ),
              decoration:
                  const InputDecoration(
                labelText:
                    "Peso por pieza (g)",
                border:
                    OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null ||
                    value.isEmpty) {
                  return "Ingrese el peso";
                }

                if (double.tryParse(value) ==
                    null) {
                  return "Peso inválido";
                }

                return null;
              },
            ),

            const SizedBox(height: 20),

            SwitchListTile(
              title: const Text(
                  "¿Tiene relleno?"),
              value: _isFilled,
              onChanged: (value) {
                setState(() {
                  _isFilled = value;
                });
              },
            ),

            SwitchListTile(
              title: const Text(
                  "Producto activo"),
              value: _isActive,
              onChanged: (value) {
                setState(() {
                  _isActive = value;
                });
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text(
                    "GUARDAR PRODUCTO"),
                onPressed: _saveProduct,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
