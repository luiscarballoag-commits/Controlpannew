import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'models/ingredient_catalog.dart';
import 'models/inventory_movement.dart';
import 'models/cost_record.dart';
import 'models/production.dart';
import 'models/recipe.dart';
import 'models/recipe_ingredient.dart';
import 'screens/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await initializeDateFormatting('es');

  Hive.registerAdapter(IngredientCatalogAdapter());
  Hive.registerAdapter(RecipeIngredientAdapter());
  Hive.registerAdapter(RecipeAdapter());
  Hive.registerAdapter(ProductionAdapter());
  Hive.registerAdapter(InventoryMovementAdapter());
  Hive.registerAdapter(CostRecordAdapter());

  await Hive.openBox<IngredientCatalog>('ingredients');
  await Hive.openBox<Recipe>('recipes');
  await Hive.openBox<Production>('productions');
  await Hive.openBox<InventoryMovement>(
    'inventory_movements',
  );

  await Hive.openBox('inventory');
  await Hive.openBox<CostRecord>('costs');
  await Hive.openBox('settings');

  runApp(const ControlPanApp());
}

class ControlPanApp extends StatelessWidget {
  const ControlPanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ControlPan',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF8D6E63),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
