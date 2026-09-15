import 'package:flutter/material.dart';

import 'labor_costs_page.dart';
import 'operating_expenses_page.dart';
import 'depreciation_assets_page.dart';

class ProductionCostsPage extends StatelessWidget {
  const ProductionCostsPage({super.key});

  static const Color _background = Color(0xFFF5F1EB);
  static const Color _brown = Color(0xFF8D6E63);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        title: const Text(
          'Costos de Producción',
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
          _buildCostCard(
            context,
            icon: Icons.groups_rounded,
            iconColor: Colors.blue,
            title: 'Mano de Obra',
            subtitle: 'Registrar y administrar trabajadores de producción.',
            page: const LaborCostsPage(),
          ),
          _buildCostCard(
            context,
            icon: Icons.receipt_long_rounded,
            iconColor: Colors.teal,
            title: 'Gastos Operativos',
            subtitle: 'Administrar luz, agua, aseo, gas y otros gastos.',
            page: const OperatingExpensesPage(),
          ),
          _buildCostCard(
            context,
            icon: Icons.precision_manufacturing_rounded,
            iconColor: Colors.orange,
            title: 'Depreciación',
            subtitle: 'Administrar equipos y costos de depreciación.',
            page: const DepreciationAssetsPage(),
          ),
        ],
      ),
    );
  }

  Widget _buildCostCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget page,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 12,
        ),
        leading: CircleAvatar(
          radius: 25,
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
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(subtitle),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 18,
        ),
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
