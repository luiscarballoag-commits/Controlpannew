import 'package:flutter/material.dart';

import 'new_production_page.dart';
import 'production_recipe_page.dart';
import 'productions_page.dart';

class ProductionDashboardPage extends StatelessWidget {
  const ProductionDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EB),
      appBar: AppBar(
        title: const Text(
          "Producción",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF8D6E63),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 10),

            const Text(
              "Producción Inteligente",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 25),            _menuCard(
              context: context,
              icon: Icons.play_circle_fill,
              iconColor: Colors.brown,
              title: "Nueva Producción",
              subtitle: "Seleccionar una receta para comenzar.",
              page: const NewProductionPage(),
            ),

            _menuCard(
              context: context,
              icon: Icons.menu_book,
              iconColor: Colors.indigo,
              title: "Recetas",
              subtitle: "Administrar recetas disponibles.",
              page: const ProductionRecipePage(),
            ),

            _menuCard(
              context: context,
              icon: Icons.history,
              iconColor: Colors.deepPurple,
              title: "Historial de Producción",
              subtitle: "Consultar todas las producciones realizadas.",
              page: const ProductionsPage(),
            ),

          ],
        ),
      ),
    );
  }

  Widget _menuCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget page,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: iconColor,
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => page,
            ),
          );
        },
      ),
    );
  }
}
