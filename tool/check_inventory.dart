import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../lib/models/ingredient_catalog.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(IngredientCatalogAdapter());

  final box = await Hive.openBox<IngredientCatalog>('ingredients');

  for (final ingredient in box.values) {
    if (ingredient.name.toLowerCase().contains('azúcar') ||
        ingredient.name.toLowerCase().contains('azucar')) {
      print('--- AZÚCAR ---');
      print('id: ${ingredient.id}');
      print('name: ${ingredient.name}');
      print('stock: ${ingredient.stock}');
      print('unit: ${ingredient.unit}');
      print('purchaseUnit: ${ingredient.purchaseUnit}');
      print('packageSize: ${ingredient.packageSize}');
      print('packageUnit: ${ingredient.packageUnit}');
      print('normalizedStock: ${ingredient.normalizedStock}');
      print('minimumStock: ${ingredient.minimumStock}');
    }
  }

  await box.close();
}
