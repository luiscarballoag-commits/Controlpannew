import 'package:flutter/material.dart';

import '../services/cost_record_service.dart';
import '../services/inventory_service.dart';
import '../services/production_service.dart';
import '../services/settings_service.dart';

class SummaryCards extends StatefulWidget {
  const SummaryCards({super.key});

  @override
  State<SummaryCards> createState() => _SummaryCardsState();
}

class _SummaryCardsState extends State<SummaryCards> {
  final SettingsService _settingsService = SettingsService();
  final InventoryService _inventoryService = InventoryService();
  final ProductionService _productionService = ProductionService();
  final CostRecordService _costRecordService = CostRecordService();

  int _totalIngredients = 0;
  int _todayProductions = 0;
  int _lowStockAlerts = 0;
  double? _averageSuggestedSalePrice;

  static const String _mainRecipeName = 'Pan Campesino';

  @override
  void initState() {
    super.initState();
    _loadSummary();
  }

  void _loadSummary() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final startOfTomorrow = startOfDay.add(const Duration(days: 1));

    final todayProductions = _productionService.getAllProductions().where(
      (production) =>
          !production.date.isBefore(startOfDay) &&
          production.date.isBefore(startOfTomorrow),
    );

    setState(() {
      _totalIngredients = _inventoryService.getTotalIngredients();
      _todayProductions = todayProductions.length;
      _lowStockAlerts = _inventoryService.getLowStockItems().length;
      _averageSuggestedSalePrice = _costRecordService
          .getAverageSuggestedSalePriceForRecipeToday(_mainRecipeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _summaryCard(
          Icons.inventory_2,
          'Ingredientes',
          _totalIngredients.toString(),
          Colors.orange,
        ),
        _summaryCard(
          Icons.bakery_dining,
          'Producciones',
          _todayProductions.toString(),
          Colors.brown,
        ),
        _summaryCard(
          Icons.attach_money,
          _mainRecipeName,
          _averageSuggestedSalePrice == null
              ? 'Sin producción hoy'
              : _settingsService.formatCurrency(_averageSuggestedSalePrice!),
          Colors.green,
        ),
        _summaryCard(
          Icons.warning_amber_rounded,
          'Alertas',
          _lowStockAlerts.toString(),
          Colors.red,
        ),
      ],
    );
  }

  Widget _summaryCard(IconData icon, String title, String value, Color color) {
    final isRecipeCard = title == _mainRecipeName;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: isRecipeCard ? 8 : 0,
        ),
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          maxLines: isRecipeCard ? 2 : 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: isRecipeCard
            ? Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              )
            : null,
        trailing: isRecipeCard
            ? null
            : Text(
                value,
                textAlign: TextAlign.end,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
      ),
    );
  }
}
