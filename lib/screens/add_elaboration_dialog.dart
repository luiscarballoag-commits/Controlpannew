import 'package:flutter/material.dart';

class AddElaborationDialog extends StatefulWidget {
  const AddElaborationDialog({super.key});

  @override
  State<AddElaborationDialog> createState() => _AddElaborationDialogState();
}

class _AddElaborationDialogState extends State<AddElaborationDialog> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Nueva Elaboración"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: "Producto"),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Cantidad de panes"),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, {
              "name": _nameController.text.trim(),
              "quantity": int.tryParse(_quantityController.text) ?? 0,
            });
          },
          child: const Text("Continuar"),
        ),
      ],
    );
  }
}
