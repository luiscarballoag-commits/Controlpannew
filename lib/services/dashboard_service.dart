import '../models/ingredient_catalog.dart';
import '../models/production.dart';
import '../services/ingredient_service.dart';
import '../services/production_service.dart';

class DashboardService {
  final ProductionService productionService = ProductionService();

  final IngredientService ingredientService = IngredientService();

  List<Production> get productions => productionService.getAllProductions();

  List<IngredientCatalog> get inventory =>
      ingredientService.getAllIngredients();

  int get productionsToday {
    final now = DateTime.now();

    return productions.where((production) {
      return production.date.year == now.year &&
          production.date.month == now.month &&
          production.date.day == now.day;
    }).length;
  }

  double get totalMassToday {
    final now = DateTime.now();

    double total = 0;

    for (final production in productions) {
      if (production.date.year == now.year &&
          production.date.month == now.month &&
          production.date.day == now.day) {
        total += production.totalMassKg;
      }
    }

    return total;
  }

  int get totalPiecesToday {
    final now = DateTime.now();

    int total = 0;

    for (final production in productions) {
      if (production.date.year == now.year &&
          production.date.month == now.month &&
          production.date.day == now.day) {
        total += production.totalPieces;
      }
    }

    return total;
  }

  int get lowStockItems {
    int total = 0;

    for (final item in inventory) {
      if (item.stock <= item.minimumStock) {
        total++;
      }
    }

    return total;
  }

  double get totalMassProduced {
    double total = 0;

    for (final production in productions) {
      total += production.totalMassKg;
    }

    return total;
  }

  int get totalPiecesProduced {
    int total = 0;

    for (final production in productions) {
      total += production.totalPieces;
    }

    return total;
  }

  double get inventoryValue {
    double total = 0;

    for (final item in inventory) {
      total += item.stock * item.purchasePrice;
    }

    return total;
  }

  Production? get lastProduction {
    if (productions.isEmpty) {
      return null;
    }

    final list = [...productions];

    list.sort((a, b) => b.date.compareTo(a.date));

    return list.first;
  }
}
