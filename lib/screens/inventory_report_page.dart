import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/ingredient_catalog.dart';
import '../services/ingredient_service.dart';
import '../services/inventory_kardex_service.dart';
import '../core/inventory/unit_converter.dart';
import '../services/settings_service.dart';

class InventoryReportPage extends StatelessWidget {
  InventoryReportPage({super.key});

  final IngredientService _ingredientService = IngredientService();
  final InventoryKardexService _kardexService = InventoryKardexService();
  final SettingsService _settingsService = SettingsService();

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }

    return value.toStringAsFixed(2);
  }

  double _getNormalizedUnitPrice(IngredientCatalog ingredient) {
    final quantityPerPackage = UnitConverter.normalize(
      quantity: 1,
      packageSize: ingredient.packageSize,
      packageUnit: ingredient.packageUnit,
      consumptionUnit: ingredient.unit,
    );

    if (quantityPerPackage <= 0) {
      return 0;
    }

    return ingredient.purchasePrice / quantityPerPackage;
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return '$day/$month/$year';
  }

  pw.Widget _buildPdfBakeryHeader() {
    final name = _settingsService.bakeryName.trim();
    final address = _settingsService.bakeryAddress.trim();
    final phone = _settingsService.bakeryPhone.trim();
    final owner = _settingsService.bakeryOwner.trim();

    final information = <pw.Widget>[];

    if (owner.isNotEmpty) {
      information.add(
        pw.Text(
          'Propietario: $owner',
          style: const pw.TextStyle(fontSize: 9),
        ),
      );
    }

    if (address.isNotEmpty) {
      information.add(
        pw.Text(
          'Dirección: $address',
          style: const pw.TextStyle(fontSize: 9),
        ),
      );
    }

    if (phone.isNotEmpty) {
      information.add(
        pw.Text(
          'Teléfono: $phone',
          style: const pw.TextStyle(fontSize: 9),
        ),
      );
    }

    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.only(bottom: 10),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: pdf.PdfColors.grey400,
          ),
        ),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            name.isEmpty ? 'CONTROLPAN' : name,
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          if (information.isNotEmpty) ...[
            pw.SizedBox(height: 5),
            ...information,
          ],
        ],
      ),
    );
  }

  Future<void> _exportPdf() async {
    final ingredients = _ingredientService.getAllIngredients();

    double totalInventoryValue = 0;

    for (final ingredient in ingredients) {
      final available =
          _kardexService.getAvailableStockNormalized(ingredient);

      final normalizedUnitPrice =
          _getNormalizedUnitPrice(ingredient);

      if (available > 0) {
        totalInventoryValue += available * normalizedUnitPrice;
      }
    }

    final document = pw.Document();

    document.addPage(
      pw.MultiPage(
        pageFormat: pdf.PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return [
            _buildPdfBakeryHeader(),
            pw.SizedBox(height: 18),

            pw.Text(
              'REPORTE DE INVENTARIO',
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
              'Resumen del inventario',
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
                  'Ingredientes registrados',
                  ingredients.length.toString(),
                ),
                _pdfSummaryRow(
                  'Valor total del inventario',
                  '\$${totalInventoryValue.toStringAsFixed(2)}',
                ),
              ],
            ),

            pw.SizedBox(height: 20),

            pw.Text(
              'Existencias actuales',
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 8),

            if (ingredients.isEmpty)
              pw.Text('No hay ingredientes registrados.')
            else
              pw.Table(
                border: pw.TableBorder.all(
                  color: pdf.PdfColors.grey400,
                ),
                columnWidths: {
                  0: const pw.FlexColumnWidth(2.0),
                  1: const pw.FlexColumnWidth(1.3),
                  2: const pw.FlexColumnWidth(1.3),
                  3: const pw.FlexColumnWidth(1.3),
                  4: const pw.FlexColumnWidth(1.2),
                  5: const pw.FlexColumnWidth(1.3),
                  6: const pw.FlexColumnWidth(1.4),
                },
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                      color: pdf.PdfColors.grey200,
                    ),
                    children: [
                      _pdfCell('Ingrediente', bold: true),
                      _pdfCell('Comprado', bold: true),
                      _pdfCell('Consumido', bold: true),
                      _pdfCell('Existencia', bold: true),
                      _pdfCell('Último precio', bold: true),
                      _pdfCell('Costo/unidad', bold: true),
                      _pdfCell('Valor', bold: true),
                    ],
                  ),
                  ...ingredients.map(
                    (ingredient) {
                      final purchased =
                          _kardexService
                              .getTotalPurchasedNormalized(ingredient);

                      final consumed =
                          _kardexService
                              .getTotalConsumedNormalized(ingredient);

                      final available =
                          _kardexService
                              .getAvailableStockNormalized(ingredient);

                      final lastPrice =
                          _kardexService
                              .getLastPurchasePrice(ingredient);

                      final normalizedUnitPrice =
                          _getNormalizedUnitPrice(ingredient);

                      final inventoryValue = available > 0
                          ? available * normalizedUnitPrice
                          : 0;

                      return pw.TableRow(
                        children: [
                          _pdfCell(ingredient.name),
                          _pdfCell(
                            '${_formatNumber(purchased)} ${ingredient.unit}',
                          ),
                          _pdfCell(
                            '${_formatNumber(consumed)} ${ingredient.unit}',
                          ),
                          _pdfCell(
                            '${_formatNumber(available)} ${ingredient.unit}',
                          ),
                          _pdfCell(
                            '\$${lastPrice.toStringAsFixed(2)}',
                          ),
                          _pdfCell(
                            '\$${normalizedUnitPrice.toStringAsFixed(4)}',
                          ),
                          _pdfCell(
                            '\$${inventoryValue.toStringAsFixed(2)}',
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),

            pw.SizedBox(height: 16),

            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                'Valor total del inventario: '
                '\$${totalInventoryValue.toStringAsFixed(2)}',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ];
        },
      ),
    );

    final bakeryName = _settingsService.bakeryName.trim();
    final safeBakeryName = (bakeryName.isEmpty ? 'ControlPan' : bakeryName)
        .replaceAll(RegExp(r'[^a-zA-Z0-9áéíóúÁÉÍÓÚñÑ ]'), '')
        .replaceAll(RegExp(r'\\s+'), '_');

    await Printing.layoutPdf(
      onLayout: (format) async => document.save(),
      name: '${safeBakeryName}_Reporte_Inventario.pdf',
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
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 8,
          fontWeight: bold
              ? pw.FontWeight.bold
              : pw.FontWeight.normal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ingredients = _ingredientService.getAllIngredients();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporte de Inventario'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Exportar a PDF',
            onPressed: ingredients.isEmpty ? null : _exportPdf,
          ),
        ],
      ),
      body: ingredients.isEmpty
          ? const Center(
              child: Text(
                'No hay ingredientes registrados.',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Existencias actuales',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Resumen del inventario disponible por ingrediente.',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ...ingredients.map(_buildIngredientCard),
              ],
            ),
    );
  }

  Widget _buildIngredientCard(IngredientCatalog ingredient) {
    final purchased =
        _kardexService.getTotalPurchasedNormalized(ingredient);

    final consumed =
        _kardexService.getTotalConsumedNormalized(ingredient);

    final available =
        _kardexService.getAvailableStockNormalized(ingredient);

    final lastPrice =
        _kardexService.getLastPurchasePrice(ingredient);

    final normalizedUnitPrice =
        _getNormalizedUnitPrice(ingredient);

    final inventoryValue =
        available > 0 ? available * normalizedUnitPrice : 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ingredient.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildRow(
              'Comprado',
              '${_formatNumber(purchased)} ${ingredient.unit}',
            ),
            _buildRow(
              'Consumido',
              '${_formatNumber(consumed)} ${ingredient.unit}',
            ),
            _buildRow(
              'Existencia',
              '${_formatNumber(available)} ${ingredient.unit}',
            ),
            _buildRow(
              'Último precio',
              '\$${lastPrice.toStringAsFixed(2)}',
            ),
            _buildRow(
              'Costo por ${ingredient.unit}',
              '\$${normalizedUnitPrice.toStringAsFixed(4)}',
            ),
            const Divider(),
            _buildRow(
              'Valor del inventario',
              '\$${inventoryValue.toStringAsFixed(2)}',
              bold: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(
    String label,
    String value, {
    bool bold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
