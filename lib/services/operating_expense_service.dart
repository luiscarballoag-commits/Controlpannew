import 'package:hive/hive.dart';

import '../models/operating_expense.dart';

class OperatingExpenseService {
  static const String boxName = 'operating_expenses';

  static const double daysPerWeek = 6;
  static const double daysPerMonth = 26;
  static const double monthsPerYear = 12;

  Box<OperatingExpense> get _box =>
      Hive.box<OperatingExpense>(boxName);

  List<OperatingExpense> getAllExpenses() {
    return _box.values.toList();
  }

  List<OperatingExpense> getActiveExpenses() {
    return _box.values
        .where((expense) => expense.active)
        .toList();
  }

  void addExpense(OperatingExpense expense) {
    _box.add(expense);
  }

  void updateExpense(int index, OperatingExpense expense) {
    _box.putAt(index, expense);
  }

  void deleteExpense(int index) {
    _box.deleteAt(index);
  }

  OperatingExpense? getExpense(int index) {
    if (index < 0 || index >= _box.length) {
      return null;
    }

    return _box.getAt(index);
  }

  /// Convierte el gasto al costo diario equivalente.
  double getDailyCost(OperatingExpense expense) {
    if (expense.cost < 0) {
      return 0;
    }

    switch (expense.period.toLowerCase()) {
      case 'diario':
      case 'daily':
        return expense.cost;

      case 'semanal':
      case 'weekly':
        return expense.cost / daysPerWeek;

      case 'mensual':
      case 'monthly':
        return expense.cost / daysPerMonth;

      case 'anual':
      case 'annual':
      case 'yearly':
        return expense.cost / (daysPerMonth * 12);

      default:
        return 0;
    }
  }

  /// Calcula el costo operativo correspondiente a una cantidad de días.
  double getCostForDays({
    required OperatingExpense expense,
    required double days,
  }) {
    if (!expense.active || days <= 0) {
      return 0;
    }

    return getDailyCost(expense) * days;
  }

  /// Calcula el costo total de los gastos operativos activos
  /// para una cantidad determinada de días.
  double getTotalCostForDays({
    required double days,
  }) {
    if (days <= 0) {
      return 0;
    }

    double total = 0;

    for (final expense in getActiveExpenses()) {
      total += getCostForDays(
        expense: expense,
        days: days,
      );
    }

    return total;
  }
}
