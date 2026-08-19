import 'package:flutter/material.dart';

import '../models/cost_record.dart';
import '../services/cost_record_service.dart';
import 'labor_costs_page.dart';

class CostsPage extends StatelessWidget {
  CostsPage({super.key});

  final CostRecordService costRecordService = CostRecordService();

  @override
  Widget build(BuildContext context) {
    final CostRecord? record = costRecordService.getLastRecord();

    final history = costRecordService.getAllRecords();

    final rawMaterial = record?.rawMaterialCost ?? 0;

    final labor = record?.laborCost ?? 0;

    final operating = record?.operatingCost ?? 0;

    final depreciation = record?.depreciationCost ?? 0;

    final total = record?.totalCost ?? 0;

    final costKg = record?.costPerKg ?? 0;

    final costPiece = record?.costPerPiece ?? 0;

    final suggestedPrice = record?.suggestedSalePrice ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EB),

      appBar: AppBar(
        title: const Text("Costos Inteligentes"),
        centerTitle: true,
        backgroundColor: const Color(0xFF8D6E63),
        foregroundColor: Colors.white,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          const Text(
            "Resumen General",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 15),

          _buildCard(
            Icons.shopping_basket,
            "Materia Prima",
            rawMaterial,
            Colors.orange,
          ),

          _buildCard(
            Icons.local_fire_department,
            "Producción",
            total,
            Colors.red,
          ),

          _buildCard(Icons.groups, "Mano de Obra", labor, Colors.blue, onTap: () { Navigator.push(context, MaterialPageRoute(builder: (_) => const LaborCostsPage())); }),

          _buildCard(
            Icons.business,
            "Gastos Operativos",
            operating,
            Colors.green,
          ),

          _buildCard(
            Icons.precision_manufacturing,
            "Depreciación",
            depreciation,
            Colors.deepPurple,
          ),

          const SizedBox(height: 20),

          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    "Resumen Financiero",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  _buildSummaryRow("Costo Total", total),

                  _buildSummaryRow("Costo por Kg", costKg),

                  _buildSummaryRow("Costo por Pieza", costPiece),

                  const Divider(height: 30),

                  _buildSummaryRow(
                    "Precio Sugerido",
                    suggestedPrice,
                    valueColor: Colors.blue,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            "Centro de Reportes",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 15),

          _buildActionCard(
            context,
            Icons.factory,
            "Reporte de Producción",
            "Consultar historial de producciones",
            Colors.brown,
          ),

          _buildActionCard(
            context,
            Icons.inventory_2,
            "Reporte de Inventario",
            "Entradas, salidas y existencias",
            Colors.teal,
          ),

          _buildActionCard(
            context,
            Icons.attach_money,
            "Reporte de Costos",
            "Análisis detallado de costos",
            Colors.orange,
          ),

          _buildActionCard(
            context,
            Icons.bar_chart,
            "Estadísticas",
            "Indicadores y gráficos",
            Colors.indigo,
          ),

          const SizedBox(height: 25),

          const Text(
            "Exportar",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Exportación PDF próximamente"),
                      ),
                    );
                  },
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text("PDF"),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Exportación Excel próximamente"),
                      ),
                    );
                  },
                  icon: const Icon(Icons.table_chart),
                  label: const Text("Excel"),
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          const Text(
            "Últimos Costos",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 15),

          ...history
              .take(5)
              .map(
                (record) => Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Icon(Icons.receipt_long, color: Colors.white),
                    ),
                    title: Text(record.recipeName),
                    subtitle: Text(
                      "Costo: \$${record.totalCost.toStringAsFixed(2)}",
                    ),
                    trailing: Text(
                      "\$${record.suggestedSalePrice.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildCard(IconData icon, String title, double value, Color color, {VoidCallback? onTap}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(
          "\$${value.toStringAsFixed(2)}",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    String title,
    double value, {
    Color valueColor = Colors.green,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Text(
            "\$${value.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("$title próximamente.")));
        },
      ),
    );
  }
}
