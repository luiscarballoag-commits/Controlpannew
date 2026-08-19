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
import 'models/labor_worker.dart';

import 'models/elaboration/elaboration_ingredient.dart';
import 'models/elaboration/elaboration_recipe.dart';
import 'models/elaboration/elaboration_production.dart';
import 'models/elaboration/elaboration_record.dart';

import 'screens/splash_page.dart';

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
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(ProductComponentAdapter());
  Hive.registerAdapter(LaborWorkerAdapter());

  Hive.registerAdapter(ElaborationIngredientAdapter());
  Hive.registerAdapter(ElaborationRecipeAdapter());
  Hive.registerAdapter(ElaborationProductionAdapter());
  Hive.registerAdapter(ElaborationRecordAdapter());

  await Hive.openBox<IngredientCatalog>('ingredients');

  await Hive.openBox<Recipe>('recipes');

  await Hive.openBox<Production>('productions');
  await Hive.openBox<ElaborationRecord>('elaboration_records');

  await Hive.openBox<InventoryMovement>('inventory_movements');

  await Hive.openBox('inventory');

  await Hive.openBox<CostRecord>('costs');

  await Hive.openBox<Product>('products');

  await Hive.openBox<ProductComponent>('product_components');
  await Hive.openBox<LaborWorker>('labor_workers');

  await Hive.openBox<ElaborationRecipe>('elaboration_recipes');

  await Hive.openBox<ElaborationProduction>('elaboration_productions');

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
      home: const SplashPage(),
    );
  }
}
