import 'package:flutter/material.dart';

import 'costs_page.dart';
import 'ingredients_page.dart';
import 'inventory_page.dart';
import 'production_dashboard_page.dart';
import 'recipes_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EB),
      appBar: AppBar(
        title: const Text(
          "ControlPan",
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
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  "assets/images/dashboard_banner.png",
                  width: double.infinity,
                  height: 170,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 25),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [

                  DashboardCard(
                    icon: Icons.factory,
                    title: "Producción",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const ProductionDashboardPage(),
                        ),
                      );
                    },
                  ),

                  DashboardCard(
                    icon: Icons.menu_book_outlined,
                    title: "Mis Recetas",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const RecipesPage(),
                        ),
                      );
                    },
                  ),

                  DashboardCard(
                    icon: Icons.science_outlined,
                    title: "Ingredientes",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const IngredientsPage(),
                        ),
                      );
                    },
                  ),                  DashboardCard(
                    icon: Icons.inventory_2_outlined,
                    title: "Inventario",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              InventoryPage(),
                        ),
                      );
                    },
                  ),

                  DashboardCard(
                    icon: Icons.calculate_outlined,
                    title: "Calculadora",
                    onTap: () {},
                  ),

                  DashboardCard(
                    icon: Icons.attach_money_outlined,
                    title: "Costos",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              CostsPage(),
                        ),
                      );
                    },
                  ),

                  DashboardCard(
                    icon: Icons.bar_chart_outlined,
                    title: "Reportes",
                    onTap: () {},
                  ),

                  DashboardCard(
                    icon: Icons.settings_outlined,
                    title: "Configuración",
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const DashboardCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius:
            BorderRadius.circular(18),
        onTap: onTap,
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 42,
              color:
                  const Color(0xFF8D6E63),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight:
                    FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
