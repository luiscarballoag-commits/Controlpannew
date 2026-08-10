import 'package:flutter/material.dart';

import '../services/dashboard_service.dart';

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
    final dashboard = DashboardService();

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
            'Resumen de Hoy',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              _infoCard(
                icon: Icons.factory,
                title: 'Producciones',
                value: dashboard.productionsToday.toString(),
                color: Colors.brown,
              ),
              _infoCard(
                icon: Icons.scale,
                title: 'Kg',
                value: dashboard.totalMassToday.toStringAsFixed(1),
                color: Colors.orange,
              ),
              _infoCard(
                icon: Icons.bakery_dining,
                title: 'Panes',
                value: dashboard.totalPiecesToday.toString(),
                color: Colors.green,
              ),
            ],
          ),

          const SizedBox(height: 30),

          const Text(
            'Operaciones',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

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

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        height: 120,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              blurRadius: 8,
              color: Colors.black12,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
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
