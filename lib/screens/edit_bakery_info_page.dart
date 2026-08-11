import 'package:flutter/material.dart';

import '../services/settings_service.dart';

class EditBakeryInfoPage extends StatefulWidget {
  const EditBakeryInfoPage({super.key});

  @override
  State<EditBakeryInfoPage> createState() => _EditBakeryInfoPageState();
}

class _EditBakeryInfoPageState extends State<EditBakeryInfoPage> {
  final SettingsService settings = SettingsService();

  late final TextEditingController nameController;
  late final TextEditingController addressController;
  late final TextEditingController phoneController;
  late final TextEditingController ownerController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: settings.bakeryName);

    addressController = TextEditingController(text: settings.bakeryAddress);

    phoneController = TextEditingController(text: settings.bakeryPhone);

    ownerController = TextEditingController(text: settings.bakeryOwner);
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    ownerController.dispose();
    super.dispose();
  }

  Future<void> save() async {
    await settings.saveBakeryName(nameController.text.trim());
    await settings.saveBakeryAddress(addressController.text.trim());
    await settings.saveBakeryPhone(phoneController.text.trim());
    await settings.saveBakeryOwner(ownerController.text.trim());

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Datos guardados correctamente')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Datos de la Panadería")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: "Nombre",
              prefixIcon: Icon(Icons.store),
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: addressController,
            decoration: const InputDecoration(
              labelText: "Dirección",
              prefixIcon: Icon(Icons.location_on),
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: phoneController,
            decoration: const InputDecoration(
              labelText: "Teléfono",
              prefixIcon: Icon(Icons.phone),
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: ownerController,
            decoration: const InputDecoration(
              labelText: "Propietario",
              prefixIcon: Icon(Icons.person),
            ),
          ),

          const SizedBox(height: 30),

          FilledButton.icon(
            onPressed: save,
            icon: const Icon(Icons.save),
            label: const Text("Guardar"),
          ),
        ],
      ),
    );
  }
}
