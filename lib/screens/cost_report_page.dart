import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/cost_record.dart';
import '../services/cost_record_service.dart';
import '../services/settings_service.dart';

class CostReportPage extends StatefulWidget {
  const CostReportPage({super.key});

  @override
  State<CostReportPage> createState() => _CostReportPageState();
}

class _CostReportPageState extends State<CostReportPage> {
  final SettingsService _settingsService = SettingsService();
  final CostRecordService _costRecordService = CostRecordService();

  String selectedPeriod = 'Hoy';

  List<CostRecord> _getPeriodRecords() {
    final now = DateTime.now();

    switch (selectedPeriod) {
      case 'Hoy':
        final start = DateTime(now.year, now.month, now.day);
        final end = start.add(const Duration(days: 1));
        return _costRecordService.getRecordsBetween(start, end);

      case 'Esta semana':
        final today = DateTime(now.year, now.month, now.day);
        final daysFromMonday = today.weekday - DateTime.monday;
        final start =
            today.subtract(Duration(days: daysFromMonday));
        final end = start.add(const Duration(days: 7));
        return _costRecordService.getRecordsBetween(start, end);

      case 'Este mes':
        final start = DateTime(now.year, now.month, 1);
        final end = DateTime(now.year, now.month + 1, 1);
        return _costRecordService.getRecordsBetween(start, end);

      case 'Todo':
        return _costRecordService.getAllRecords();

      default:
        return [];
    }
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }


  Future<void> _exportPdf() async {
    final records = _getPeriodRecords();

    double rawMaterial = 0;
    double elaboration = 0;
    double labor = 0;
    double operating = 0;
    double depreciation = 0;
    double total = 0;
    double totalWeight = 0;
    double totalPieces = 0;

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
        totalPieces += record.totalCost / record.costPerPiece;
      }
    }

    final costPerKg =
        totalWeight > 0 ? total / totalWeight : 0.0;

    final costPerPiece =
        totalPieces > 0 ? total / totalPieces : 0.0;

    final document = pw.Document();

    document.addPage(
      pw.MultiPage(
        pageFormat: pdf.PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Text(
            _settingsService.bakeryName.trim().isEmpty
                ? 'ControlPan'
                : _settingsService.bakeryName.trim(),
            style: pw.TextStyle(
              fontSize: 22,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'Reporte de Costos',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Text('Período: $selectedPeriod'),
          pw.Text(
            'Generado: ${_formatDate(DateTime.now())}',
          ),
          pw.SizedBox(height: 20),

          pw.Text(
            'Resumen financiero',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 8),

          _pdfRow(
            'Costo Total',
            '\$${total.toStringAsFixed(2)}',
            bold: true,
          ),
          _pdfRow(
            'Producciones',
            records.length.toString(),
          ),
          _pdfRow(
            'Kg producidos',
            totalWeight.toStringAsFixed(2),
          ),
          _pdfRow(
            'Piezas producidas',
            totalPieces.toStringAsFixed(0),
          ),
          _pdfRow(
            'Costo promedio por Kg',
            '\$${costPerKg.toStringAsFixed(2)}',
          ),
          _pdfRow(
            'Costo promedio por pieza',
            '\$${costPerPiece.toStringAsFixed(2)}',
          ),

          pw.SizedBox(height: 20),

          pw.Text(
            'Composición del costo',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 8),

          _pdfRow(
            'Materia Prima',
            '\$${rawMaterial.toStringAsFixed(2)}',
          ),
          _pdfRow(
            'Complementos',
            '\$${elaboration.toStringAsFixed(2)}',
          ),
          _pdfRow(
            'Mano de Obra',
            '\$${labor.toStringAsFixed(2)}',
          ),
          _pdfRow(
            'Gastos Operativos',
            '\$${operating.toStringAsFixed(2)}',
          ),
          _pdfRow(
            'Depreciación',
            '\$${depreciation.toStringAsFixed(2)}',
          ),

          pw.SizedBox(height: 20),

          pw.Text(
            'Detalle de producciones',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 8),

          if (records.isEmpty)
            pw.Text(
              'No hay registros de costos para este período.',
            )
          else
            ...records.map(
              (record) => pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 12),
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(
                    color: pdf.PdfColors.grey400,
                  ),
                ),
                child: pw.Column(
                  crossAxisAlignment:
                      pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      record.recipeName,
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Fecha: ${_formatDate(record.date)}',
                    ),
                    pw.SizedBox(height: 6),
                    _pdfRow(
                      'Materia Prima',
                      '\$${record.rawMaterialCost.toStringAsFixed(2)}',
                    ),
                    _pdfRow(
                      'Complementos',
                      '\$${record.elaborationCost.toStringAsFixed(2)}',
                    ),
                    _pdfRow(
                      'Mano de Obra',
                      '\$${record.laborCost.toStringAsFixed(2)}',
                    ),
                    _pdfRow(
                      'Gastos Operativos',
                      '\$${record.operatingCost.toStringAsFixed(2)}',
                    ),
                    _pdfRow(
                      'Depreciación',
                      '\$${record.depreciationCost.toStringAsFixed(2)}',
                    ),
                    pw.Divider(),
                    _pdfRow(
                      'Costo Total',
                      '\$${record.totalCost.toStringAsFixed(2)}',
                      bold: true,
                    ),
                    _pdfRow(
                      'Costo por Kg',
                      '\$${record.costPerKg.toStringAsFixed(2)}',
                    ),
                    _pdfRow(
                      'Costo por Pieza',
                      '\$${record.costPerPiece.toStringAsFixed(2)}',
                    ),
                    _pdfRow(
                      'Margen',
                      '${record.profitPercentage.toStringAsFixed(1)}%',
                    ),
                    _pdfRow(
                      'Precio Sugerido',
                      '\$${record.suggestedSalePrice.toStringAsFixed(2)}',
                      bold: true,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );

    final bakeryName = _settingsService.bakeryName.trim();
    final safeBakeryName = (bakeryName.isEmpty ? 'ControlPan' : bakeryName)
        .replaceAll(RegExp(r'[^a-zA-Z0-9áéíóúÁÉÍÓÚñÑ ]'), '')
        .replaceAll(RegExp(r'\\s+'), '_');

    await Printing.layoutPdf(
      onLayout: (format) async => document.save(),
      name:
          '${safeBakeryName}_Reporte_Costos_${selectedPeriod.toLowerCase().replaceAll(' ', '_')}.pdf',
    );
  }

  pw.Widget _pdfRow(
    String title,
    String value, {
    bool bold = false,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              fontWeight: bold
                  ? pw.FontWeight.bold
                  : pw.FontWeight.normal,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontWeight: bold
                  ? pw.FontWeight.bold
                  : pw.FontWeight.normal,
            ),
          ),
        ],
      ),
    );
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
    double totalPieces = 0;

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
        totalPieces += record.totalCost / record.costPerPiece;
      }
    }

    final costPerKg =
        totalWeight > 0 ? total / totalWeight : 0.0;

    final costPerPiece =
        totalPieces > 0 ? total / totalPieces : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EB),
      appBar: AppBar(
        title: const Text('Reporte de Costos'),
        centerTitle: true,
        backgroundColor: const Color(0xFF8D6E63),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Exportar PDF',
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _exportPdf,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Análisis detallado de costos',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Resumen financiero de las producciones realizadas.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 16),

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

          const SizedBox(height: 18),

          _buildTotalCard(total, records.length),

          const SizedBox(height: 18),

          const Text(
            'Composición del costo',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          _buildCostRow(
            Icons.shopping_basket,
            'Materia Prima',
            rawMaterial,
            Colors.orange,
          ),

          _buildCostRow(
            Icons.extension,
            'Complementos',
            elaboration,
            Colors.deepOrange,
          ),

          _buildCostRow(
            Icons.groups,
            'Mano de Obra',
            labor,
            Colors.blue,
          ),

          _buildCostRow(
            Icons.business,
            'Gastos Operativos',
            operating,
            Colors.green,
          ),

          _buildCostRow(
            Icons.precision_manufacturing,
            'Depreciación',
            depreciation,
            Colors.deepPurple,
          ),

          const SizedBox(height: 18),

          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Indicadores',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),

                  _buildIndicatorRow(
                    'Producciones',
                    records.length.toString(),
                  ),

                  _buildIndicatorRow(
                    'Kg producidos',
                    totalWeight.toStringAsFixed(2),
                  ),

                  _buildIndicatorRow(
                    'Piezas producidas',
                    totalPieces.toStringAsFixed(0),
                  ),

                  _buildIndicatorRow(
                    'Costo promedio por Kg',
                    '\$${costPerKg.toStringAsFixed(2)}',
                  ),

                  _buildIndicatorRow(
                    'Costo promedio por pieza',
                    '\$${costPerPiece.toStringAsFixed(2)}',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 22),

          const Text(
            'Detalle de producciones',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          if (records.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      Icons.receipt_long,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'No hay registros de costos para este período.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...records.map(_buildProductionCard),
        ],
      ),
    );
  }

  Widget _buildTotalCard(double total, int productions) {
    return Card(
      elevation: 7,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Costo Total del Período',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${total.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '$productions producción(es)',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostRow(
    IconData icon,
    String title,
    double value,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
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
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildIndicatorRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductionCard(CostRecord record) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ExpansionTile(
        leading: const CircleAvatar(
          child: Icon(Icons.factory),
        ),
        title: Text(
          record.recipeName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          _formatDate(record.date),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(
          16,
          0,
          16,
          16,
        ),
        children: [
          _buildDetailRow(
            'Materia Prima',
            record.rawMaterialCost,
          ),
          _buildDetailRow(
            'Complementos',
            record.elaborationCost,
          ),
          _buildDetailRow(
            'Mano de Obra',
            record.laborCost,
          ),
          _buildDetailRow(
            'Gastos Operativos',
            record.operatingCost,
          ),
          _buildDetailRow(
            'Depreciación',
            record.depreciationCost,
          ),
          const Divider(),

          _buildDetailRow(
            'Costo Total',
            record.totalCost,
            bold: true,
          ),

          _buildDetailRow(
            'Costo por Kg',
            record.costPerKg,
          ),

          _buildDetailRow(
            'Costo por Pieza',
            record.costPerPiece,
          ),

          _buildDetailRow(
            'Margen',
            record.profitPercentage,
            suffix: '%',
          ),

          _buildDetailRow(
            'Precio Sugerido',
            record.suggestedSalePrice,
            bold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String title,
    double value, {
    bool bold = false,
    String suffix = '',
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight:
                  bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            suffix == '%'
                ? '${value.toStringAsFixed(1)}%'
                : '\$${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight:
                  bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
