import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/production.dart';
import '../services/production_service.dart';
import '../services/elaboration/elaboration_record_service.dart';

class ProductionReportPage extends StatelessWidget {
  ProductionReportPage({super.key});

  final ProductionService productionService = ProductionService();
  final ElaborationRecordService elaborationRecordService =
      ElaborationRecordService();

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return '$day/$month/$year';
  }

  Future<void> _exportPdf() async {
    final productions = productionService.getAllProductions();

    int totalLots = 0;
    double totalMassKg = 0;
    int totalPieces = 0;

    for (final production in productions) {
      totalLots += production.lots;
      totalMassKg += production.totalMassKg;
      totalPieces += production.totalPieces;
    }

    final records = elaborationRecordService.getAll();

    final Map<String, int> piecesByVariety = {};

    for (final record in records) {
      piecesByVariety[record.productName] =
          (piecesByVariety[record.productName] ?? 0) + record.quantity;
    }

    final document = pw.Document();

    document.addPage(
      pw.MultiPage(
        pageFormat: pdf.PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return [
            pw.Text(
              'CONTROLPAN',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              'Reporte de Producción',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              'Generado: ${_formatDate(DateTime.now())}',
              style: const pw.TextStyle(fontSize: 10),
            ),
            pw.SizedBox(height: 20),

            pw.Text(
              'Resumen de producción',
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 8),

            pw.Table(
              border: pw.TableBorder.all(
                color: pdf.PdfColors.grey400,
              ),
              children: [
                _pdfSummaryRow(
                  'Producciones',
                  productions.length.toString(),
                ),
                _pdfSummaryRow(
                  'Lotes',
                  totalLots.toString(),
                ),
                _pdfSummaryRow(
                  'Kg producidos',
                  totalMassKg.toStringAsFixed(2),
                ),
                _pdfSummaryRow(
                  'Piezas producidas',
                  totalPieces.toString(),
                ),
              ],
            ),

            pw.SizedBox(height: 20),

            pw.Text(
              'Piezas por variedad',
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 8),

            if (piecesByVariety.isEmpty)
              pw.Text('No hay variedades registradas.')
            else
              pw.Table(
                border: pw.TableBorder.all(
                  color: pdf.PdfColors.grey400,
                ),
                columnWidths: {
                  0: const pw.FlexColumnWidth(3),
                  1: const pw.FlexColumnWidth(1),
                },
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                      color: pdf.PdfColors.grey200,
                    ),
                    children: [
                      _pdfCell('Variedad', bold: true),
                      _pdfCell('Piezas', bold: true),
                    ],
                  ),
                  ...piecesByVariety.entries.map(
                    (entry) => pw.TableRow(
                      children: [
                        _pdfCell(entry.key),
                        _pdfCell(entry.value.toString()),
                      ],
                    ),
                  ),
                ],
              ),

            pw.SizedBox(height: 24),

            pw.Text(
              'Detalle de producciones',
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 10),

            ...productions.map(
              (production) => _buildPdfProduction(
                production,
                records,
              ),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => document.save(),
    );
  }

  pw.Widget _buildPdfProduction(
    Production production,
    List<dynamic> records,
  ) {
    final productionRecords = records
        .where(
          (record) => record.productionId == production.id,
        )
        .toList();

    final Map<String, int> varieties = {};

    for (final record in productionRecords) {
      varieties[record.productName] =
          (varieties[record.productName] ?? 0) + record.quantity as int;
    }

    final List<pw.Widget> varietyRows = [];

    if (varieties.isNotEmpty) {
      varietyRows.add(
        pw.Padding(
          padding: const pw.EdgeInsets.only(top: 8, bottom: 4),
          child: pw.Text(
            'Variedades producidas',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
      );

      for (final entry in varieties.entries) {
        varietyRows.add(
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 2),
            child: pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Text(entry.key),
                ),
                pw.Text('${entry.value} piezas'),
              ],
            ),
          ),
        );
      }
    }

    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 16),
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(
          color: pdf.PdfColors.grey400,
        ),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            '${production.id} • ${production.recipeName}',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Text('Fecha: ${_formatDate(production.date)}'),
          pw.Text('Lotes: ${production.lots}'),
          pw.Text(
            'Masa: ${production.totalMassKg.toStringAsFixed(2)} kg',
          ),
          pw.Text('Piezas: ${production.totalPieces}'),
          pw.Text(
            'Peso por pieza: '
            '${production.pieceWeightGrams.toStringAsFixed(0)} g',
          ),
          ...varietyRows,
          if (production.notes.isNotEmpty) ...[
            pw.SizedBox(height: 6),
            pw.Text('Observaciones: ${production.notes}'),
          ],
        ],
      ),
    );
  }

  pw.TableRow _pdfSummaryRow(
    String label,
    String value,
  ) {
    return pw.TableRow(
      children: [
        _pdfCell(label),
        _pdfCell(value, bold: true),
      ],
    );
  }

  pw.Widget _pdfCell(
    String text, {
    bool bold = false,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productions = productionService.getAllProductions();

    int totalLots = 0;
    double totalMassKg = 0;
    int totalPieces = 0;

    for (final production in productions) {
      totalLots += production.lots;
      totalMassKg += production.totalMassKg;
      totalPieces += production.totalPieces;
    }

    final Map<String, int> piecesByVariety = {};

    for (final record in elaborationRecordService.getAll()) {
      piecesByVariety[record.productName] =
          (piecesByVariety[record.productName] ?? 0) + record.quantity;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporte de Producción'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Exportar a PDF',
            onPressed: productions.isEmpty ? null : _exportPdf,
          ),
        ],
      ),
      body: productions.isEmpty
          ? const Center(
              child: Text(
                'Todavía no existen producciones registradas.',
                textAlign: TextAlign.center,
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        icon: Icons.factory,
                        title: 'Producciones',
                        value: productions.length.toString(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildSummaryCard(
                        icon: Icons.layers,
                        title: 'Lotes',
                        value: totalLots.toString(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _buildSummaryCard(
                  icon: Icons.scale,
                  title: 'Kg producidos',
                  value: totalMassKg.toStringAsFixed(2),
                ),
                const SizedBox(height: 10),
                _buildVarietiesSummaryCard(piecesByVariety, totalPieces),
                const SizedBox(height: 24),
                const Text(
                  'Historial de Producción',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...productions.map(
                  (production) => _buildProductionCard(production),
                ),
              ],
            ),
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Icon(icon, size: 30),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVarietiesSummaryCard(
    Map<String, int> piecesByVariety,
    int totalPieces,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.bakery_dining, size: 30),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Piezas por variedad',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  totalPieces.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (piecesByVariety.isEmpty) ...[
              const SizedBox(height: 12),
              const Text('No hay variedades registradas.'),
            ] else ...[
              const SizedBox(height: 12),
              ...piecesByVariety.entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.bakery_dining,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          entry.key,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Text(
                        '${entry.value} piezas',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProductionCard(Production production) {
    final date = production.date.toString().substring(0, 16);

    final records = elaborationRecordService
        .getAll()
        .where((record) => record.productionId == production.id)
        .toList();

    final Map<String, int> varieties = {};

    for (final record in records) {
      varieties[record.productName] =
          (varieties[record.productName] ?? 0) + record.quantity;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  child: Icon(Icons.bakery_dining),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${production.id} • ${production.recipeName}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Fecha: $date'),
            Text('Lotes: ${production.lots}'),
            Text(
              'Masa: ${production.totalMassKg.toStringAsFixed(2)} kg',
            ),
            Text('Piezas: ${production.totalPieces}'),
            Text(
              'Peso por pieza: '
              '${production.pieceWeightGrams.toStringAsFixed(0)} g',
            ),
            if (varieties.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                'Variedades producidas',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...varieties.entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.bakery_dining,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          entry.key,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Text(
                        '${entry.value} piezas',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if (production.notes.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Observaciones: ${production.notes}'),
            ],
          ],
        ),
      ),
    );
  }
}
