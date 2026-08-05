import 'package:hive/hive.dart';

import '../../models/elaboration/elaboration_production.dart';

class ElaborationProductionService {
  final Box<ElaborationProduction> box =
      Hive.box<ElaborationProduction>(
    'elaboration_productions',
  );

  Future<void> saveProduction({
    required String recipeId,
    required String recipeName,
    required int quantity,
  }) async {
    final production = ElaborationProduction(
      id: DateTime.now()
          .microsecondsSinceEpoch
          .toString(),
      date: DateTime.now(),
      recipeId: recipeId,
      recipeName: recipeName,
      quantity: quantity,
    );

    await box.add(production);
  }

  List<ElaborationProduction> getAll() {
    return box.values.toList()
      ..sort(
        (a, b) => b.date.compareTo(a.date),
      );
  }
}
