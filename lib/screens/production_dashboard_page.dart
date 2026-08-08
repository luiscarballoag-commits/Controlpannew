import 'package:flutter/material.dart';

import 'new_production_page.dart';
import 'production_recipe_page.dart';
import 'productions_page.dart';
import 'manual_production_page.dart';
import 'elaboration/elaboration_recipe_list_page.dart';

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

              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.07),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8D6E63),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.factory_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Producción Inteligente",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Gestiona recetas, producciones y elaboraciones.",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 30),

            _menuCard(
              context: context,
              icon: Icons.menu_book_rounded,
              iconColor: Colors.indigo,
              title: "Recetas de Masas",
              subtitle: "Administrar recetas y fórmulas de masas.",
              page: const ProductionRecipePage(),
            ),

            _menuCard(
              context: context,
              icon: Icons.bakery_dining,
              iconColor: Colors.orange,
              title: "Elaboraciones",
              subtitle: "Administrar rellenos y elaboraciones.",
              page: const ElaborationRecipeListPage(),
            ),

            _menuCard(
              context: context,
              icon: Icons.play_circle_fill_rounded,
              iconColor: const Color(0xFF6D4C41),
              title: "Nueva Producción",
              subtitle: "Iniciar producción",
              page: const NewProductionPage(),
            ),

            _menuCard(
              context: context,
              icon: Icons.history_rounded,
              iconColor: Colors.deepPurple,
              title: "Historial de Producción",
              subtitle: "Consultar todas las producciones realizadas.",
              page: const ProductionsPage(),
            ),

            _menuCard(
              context: context,
              icon: Icons.edit_note_rounded,
              iconColor: Colors.teal,
              title: "Producción Manual",
              subtitle: "Sin receta de masa",
              page: const ManualProductionPage(),
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
      margin: const EdgeInsets.only(bottom: 18),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 28,
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
            fontSize: 18,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right_rounded),
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
