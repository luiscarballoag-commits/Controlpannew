import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'models/ingredient_catalog.dart';
import 'models/inventory_movement.dart';
import 'models/cost_record.dart';
import 'models/product.dart';
import 'models/product_component.dart';
import 'models/production.dart';
import 'models/recipe.dart';
import 'models/recipe_ingredient.dart';

import 'models/elaboration/elaboration_ingredient.dart';
import 'models/elaboration/elaboration_recipe.dart';
import 'models/elaboration/elaboration_production.dart';
import 'models/elaboration/elaboration_record.dart';

import 'screens/splash_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  debugPrint('CONTROLPAN: 01 - iniciando');

  await Hive.initFlutter();
  debugPrint('CONTROLPAN: 02 - Hive inicializado');

  await initializeDateFormatting('es');
  debugPrint('CONTROLPAN: 03 - fechas inicializadas');

  Hive.registerAdapter(IngredientCatalogAdapter());
  Hive.registerAdapter(RecipeIngredientAdapter());
  Hive.registerAdapter(RecipeAdapter());
  Hive.registerAdapter(ProductionAdapter());
  Hive.registerAdapter(InventoryMovementAdapter());
  Hive.registerAdapter(CostRecordAdapter());
  // LaborWorker desactivado temporalmente para diagnóstico.
  // Hive.registerAdapter(LaborWorkerAdapter());
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(ProductComponentAdapter());

  Hive.registerAdapter(ElaborationIngredientAdapter());
  Hive.registerAdapter(ElaborationRecipeAdapter());
  Hive.registerAdapter(ElaborationProductionAdapter());
  Hive.registerAdapter(ElaborationRecordAdapter());

  debugPrint('CONTROLPAN: 04 - adaptadores registrados');

  debugPrint('CONTROLPAN: 05 - abriendo ingredients');
  await Hive.openBox<IngredientCatalog>('ingredients');
  debugPrint('CONTROLPAN: 06 - ingredients OK');

  debugPrint('CONTROLPAN: 07 - abriendo recipes');
  await Hive.openBox<Recipe>('recipes');
  debugPrint('CONTROLPAN: 08 - recipes OK');

  debugPrint('CONTROLPAN: 09 - abriendo productions');
  await Hive.openBox<Production>('productions');
  debugPrint('CONTROLPAN: 10 - productions OK');

  debugPrint('CONTROLPAN: 11 - abriendo elaboration_records');
  await Hive.openBox<ElaborationRecord>('elaboration_records');
  debugPrint('CONTROLPAN: 12 - elaboration_records OK');

  debugPrint('CONTROLPAN: 13 - abriendo inventory_movements');
  await Hive.openBox<InventoryMovement>('inventory_movements');
  debugPrint('CONTROLPAN: 14 - inventory_movements OK');

  debugPrint('CONTROLPAN: 15 - abriendo inventory');
  await Hive.openBox('inventory');
  debugPrint('CONTROLPAN: 16 - inventory OK');

  debugPrint('CONTROLPAN: 17 - abriendo costs');
  await Hive.openBox<CostRecord>('costs');
  debugPrint('CONTROLPAN: 18 - costs OK');

  // LaborWorker desactivado temporalmente para diagnóstico.
  // await Hive.openBox<LaborWorker>('labor_workers');

  debugPrint('CONTROLPAN: 19 - abriendo products');
  await Hive.openBox<Product>('products');
  debugPrint('CONTROLPAN: 20 - products OK');

  debugPrint('CONTROLPAN: 21 - abriendo product_components');
  await Hive.openBox<ProductComponent>('product_components');
  debugPrint('CONTROLPAN: 22 - product_components OK');

  debugPrint('CONTROLPAN: 23 - abriendo elaboration_recipes');
  await Hive.openBox<ElaborationRecipe>('elaboration_recipes');
  debugPrint('CONTROLPAN: 24 - elaboration_recipes OK');

  debugPrint('CONTROLPAN: 25 - abriendo elaboration_productions');
  await Hive.openBox<ElaborationProduction>('elaboration_productions');
  debugPrint('CONTROLPAN: 26 - elaboration_productions OK');

  debugPrint('CONTROLPAN: 27 - abriendo settings');
  await Hive.openBox('settings');
  debugPrint('CONTROLPAN: 28 - settings OK');

  debugPrint('CONTROLPAN: 29 - ejecutando runApp');

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
      home: const SplashPage(),
    );
  }
}
