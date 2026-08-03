import 'package:flutter/material.dart';

import '../services/dashboard_service.dart';
import 'production_recipe_page.dart';
import 'productions_page.dart';
import 'recipes_page.dart';

class NewProductionPage extends StatelessWidget {
  const NewProductionPage({super.key});

  Widget infoCard({
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
          borderRadius: BorderRadius.circular(18),
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
            Icon(
              icon,
              color: Colors.white,
              size: 34,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget menuCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget page,
  }) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(18),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: const Color(0xFF8D6E63),
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

  @override
  Widget build(BuildContext context) {    final dashboard = DashboardService();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EB),
      appBar: AppBar(
        title: const Text(
          "Producción Inteligente",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Resumen de Hoy",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              infoCard(
                icon: Icons.factory,
                title: "Producciones",
                value: dashboard.productionsToday.toString(),
                color: Colors.brown,
              ),

              infoCard(
                icon: Icons.scale,
                title: "Kg",
                value: dashboard.totalMassToday
                    .toStringAsFixed(1),
                color: Colors.orange,
              ),

              infoCard(
                icon: Icons.bakery_dining,
                title: "Panes",
                value: dashboard.totalPiecesToday.toString(),
                color: Colors.green,
              ),
            ],
          ),

          const SizedBox(height: 30),

          const Text(
            "Operaciones",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          menuCard(
            context: context,
            icon: Icons.play_circle_fill,
            title: "Nueva Producción",
            subtitle:
                "Seleccionar una receta para comenzar.",
            page: const ProductionRecipePage(),
          ),

          menuCard(
            context: context,
            icon: Icons.menu_book,
            title: "Recetas",
            subtitle:
                "Administrar recetas disponibles.",
            page: const RecipesPage(),
          ),

          menuCard(
            context: context,
            icon: Icons.history,
            title: "Historial de Producción",
            subtitle:
                "Consultar todas las producciones realizadas.",
            page: const ProductionsPage(),
          ),

          menuCard(
            context: context,
            icon: Icons.calculate,
            title: "Producción Manual",
            subtitle:
                "Próximamente disponible.",
            page: const ProductionRecipePage(),
          ),

          const SizedBox(height: 28),

          if (dashboard.lastProduction != null) ...[
            const Text(
              "Última Producción",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  radius: 26,
                  backgroundColor: Color(0xFF8D6E63),
                  child: Icon(
                    Icons.local_fire_department,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  dashboard.lastProduction!.recipeName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "${dashboard.lastProduction!.totalPieces} panes • ${dashboard.lastProduction!.totalMassKg.toStringAsFixed(2)} kg",
                ),
                trailing: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
