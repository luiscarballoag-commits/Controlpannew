import 'package:flutter/material.dart';

import '../../services/settings_service.dart';
import '../../screens/edit_bakery_info_page.dart';

class BakeryInfoCard extends StatelessWidget {
  const BakeryInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = SettingsService();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                CircleAvatar(child: Icon(Icons.store)),
                SizedBox(width: 12),
                Text(
                  'Datos de la Panadería',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 20),

            ListTile(
              leading: const Icon(Icons.store),
              title: const Text('Nombre'),
              subtitle: Text(settings.bakeryName),
            ),

            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Dirección'),
              subtitle: Text(
                settings.bakeryAddress.isEmpty
                    ? 'Sin registrar'
                    : settings.bakeryAddress,
              ),
            ),

            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Teléfono'),
              subtitle: Text(
                settings.bakeryPhone.isEmpty
                    ? 'Sin registrar'
                    : settings.bakeryPhone,
              ),
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Propietario'),
              subtitle: Text(
                settings.bakeryOwner.isEmpty
                    ? 'Sin registrar'
                    : settings.bakeryOwner,
              ),
            ),

            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text('Editar'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EditBakeryInfoPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
