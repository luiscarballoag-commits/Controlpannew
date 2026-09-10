import 'package:flutter/material.dart';

import 'production_report_page.dart';
import 'inventory_report_page.dart';
import 'cost_report_page.dart';
import '../models/cost_record.dart';
import '../services/cost_record_service.dart';

class CostsPage extends StatefulWidget {
  const CostsPage({super.key});

  @override
  State<CostsPage> createState() => _CostsPageState();
}

class _CostsPageState extends State<CostsPage> {
  final CostRecordService costRecordService = CostRecordService();

  String selectedPeriod = 'Hoy';

  List<CostRecord> _getPeriodRecords() {
    final now = DateTime.now();

    switch (selectedPeriod) {
      case 'Hoy':
        final start = DateTime(now.year, now.month, now.day);
        final end = start.add(const Duration(days: 1));
        return costRecordService.getRecordsBetween(start, end);

      case 'Esta semana':
        final today = DateTime(now.year, now.month, now.day);
        final daysFromMonday = today.weekday - DateTime.monday;
        final start = today.subtract(Duration(days: daysFromMonday));
        final end = start.add(const Duration(days: 7));
        return costRecordService.getRecordsBetween(start, end);

      case 'Este mes':
        final start = DateTime(now.year, now.month, 1);
        final end = DateTime(now.year, now.month + 1, 1);
        return costRecordService.getRecordsBetween(start, end);

      case 'Todo':
        return costRecordService.getAllRecords();

      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final records = _getPeriodRecords();

    double rawMaterial = 0;
    double elaboration = 0;
    double labor = 0;
    double operating = 0;
    double depreciation = 0;
    double total = 0;
    double totalWeight = 0;
    double totalUnits = 0;

    for (final record in records) {
      rawMaterial += record.rawMaterialCost;
      elaboration += record.elaborationCost;
      labor += record.laborCost;
      operating += record.operatingCost;
      depreciation += record.depreciationCost;
      total += record.totalCost;

      if (record.costPerKg > 0) {
        totalWeight += record.totalCost / record.costPerKg;
      }

      if (record.costPerPiece > 0) {
        totalUnits += record.totalCost / record.costPerPiece;
      }
    }

    final double costKg = totalWeight > 0 ? total / totalWeight : 0.0;
    final double costPiece = totalUnits > 0 ? total / totalUnits : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EB),
      appBar: AppBar(
        title: const Text('Costos Inteligentes'),
        centerTitle: true,
        backgroundColor: const Color(0xFF8D6E63),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Resumen General',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: DropdownButtonFormField<String>(
                initialValue: selectedPeriod,
                decoration: const InputDecoration(
                  labelText: 'Período',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.date_range),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Hoy',
                    child: Text('Hoy'),
                  ),
                  DropdownMenuItem(
                    value: 'Esta semana',
                    child: Text('Esta semana'),
                  ),
                  DropdownMenuItem(
                    value: 'Este mes',
                    child: Text('Este mes'),
                  ),
                  DropdownMenuItem(
                    value: 'Todo',
                    child: Text('Todo'),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    selectedPeriod = value;
                  });
                },
              ),
            ),
          ),

          const SizedBox(height: 15),

          _buildCard(
            Icons.shopping_basket,
            'Materia Prima',
            rawMaterial,
            Colors.orange,
          ),

          _buildCard(
            Icons.extension,
            'Complementos',
            elaboration,
            Colors.deepOrange,
          ),

          _buildCard(
            Icons.groups,
            'Mano de Obra',
            labor,
            Colors.blue,
          ),

          _buildCard(
            Icons.business,
            'Gastos Operativos',
            operating,
            Colors.green,
          ),

          _buildCard(
            Icons.precision_manufacturing,
            'Depreciación',
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
                    'Resumen Financiero',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  _buildSummaryRow(
                    'Producciones',
                    records.length.toDouble(),
                    isCurrency: false,
                  ),

                  _buildSummaryRow(
                    'Costo Total',
                    total,
                  ),

                  _buildSummaryRow(
                    'Costo promedio por Kg',
                    costKg,
                  ),

                  _buildSummaryRow(
                    'Costo promedio por Pieza',
                    costPiece,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            'Centro de Reportes',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          _buildActionCard(
            context,
            Icons.factory,
            'Reporte de Producción',
            'Consultar historial de producciones',
            Colors.brown,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductionReportPage(),
                ),
              );
            },
          ),

          _buildActionCard(
            context,
            Icons.inventory_2,
            'Reporte de Inventario',
            'Entradas, salidas y existencias',
            Colors.teal,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => InventoryReportPage(),
                ),
              );
            },
          ),

          _buildActionCard(
            context,
            Icons.attach_money,
            'Reporte de Costos',
            'Análisis detallado de costos',
            Colors.orange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CostReportPage(),
                ),
              );
            },
          ),

          _buildActionCard(
            context,
            Icons.bar_chart,
            'Estadísticas',
            'Indicadores y gráficos',
            Colors.indigo,
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    IconData icon,
    String title,
    double value,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Text(
          '\$${value.toStringAsFixed(2)}',
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
    bool isCurrency = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            isCurrency
                ? '\$${value.toStringAsFixed(2)}'
                : value.toStringAsFixed(0),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
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
    Color color, {
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 18,
        ),
        onTap: onTap ??
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$title próximamente.'),
                ),
              );
            },
      ),
    );
  }
}
