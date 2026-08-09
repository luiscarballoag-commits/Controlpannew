import 'package:flutter/material.dart';

import 'new_production_page.dart';
import 'production_recipe_page.dart';
import 'productions_page.dart';
import 'manual_production_page.dart';
import 'elaboration/elaboration_recipe_list_page.dart';

class ProductionDashboardPage extends StatelessWidget {
  const ProductionDashboardPage({super.key});

  static const Color _background = Color(0xFFF5F1EB);
  static const Color _brown = Color(0xFF8D6E63);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        title: const Text(
          'Producción Inteligente',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: _brown,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        children: [
          _menuCard(
            context: context,
            icon: Icons.menu_book_rounded,
            iconColor: Colors.indigo,
            title: 'Recetas de Masas',
            subtitle: 'Administrar recetas y fórmulas de masas.',
            page: const ProductionRecipePage(),
          ),

          _menuCard(
            context: context,
            icon: Icons.bakery_dining_rounded,
            iconColor: Colors.orange,
            title: 'Recetas de Elaboración',
            subtitle: 'Guayaba, Jamón, Coco, Arequipe, Pizza y más.',
            page: const ElaborationRecipeListPage(),
          ),

          _menuCard(
            context: context,
            icon: Icons.play_circle_fill_rounded,
            iconColor: _brown,
            title: 'Nueva Producción',
            subtitle: 'Iniciar una nueva producción.',
            page: const NewProductionPage(),
          ),

          _menuCard(
            context: context,
            icon: Icons.history_rounded,
            iconColor: Colors.deepPurple,
            title: 'Historial de Producción',
            subtitle: 'Ver masas producidas, panes y elaboraciones.',
            page: const ProductionsPage(),
          ),

          _menuCard(
            context: context,
            icon: Icons.edit_note_rounded,
            iconColor: Colors.teal,
            title: 'Producción Manual',
            subtitle: 'Producir sin receta de masa.',
            page: const ManualProductionPage(),
          ),
        ],
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
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => page,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 17,
          ),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 31,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.black45,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
