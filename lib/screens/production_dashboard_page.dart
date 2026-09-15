import 'package:flutter/material.dart';

import 'production_recipe_page.dart';
import 'manual_production_page.dart';
import 'elaboration/elaboration_recipe_list_page.dart';
import 'production_costs_page.dart';

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
          const Text(
            'Operaciones',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          _menuCard(
            context: context,
            icon: Icons.account_balance_wallet_rounded,
            iconColor: Colors.brown,
            title: 'Costos de Producción',
            subtitle: 'Mano de obra, gastos operativos y depreciación.',
            page: const ProductionCostsPage(),
          ),

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
            page: const ProductionRecipePage(),
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
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: iconColor,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(subtitle),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        },
      ),
    );
  }
}
