import 'package:hive/hive.dart';

part 'operating_expense.g.dart';

@HiveType(typeId: 15)
class OperatingExpense extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double cost;

  @HiveField(3)
  final String period;

  @HiveField(4)
  final bool active;

  OperatingExpense({
    required this.id,
    required this.name,
    required this.cost,
    required this.period,
    this.active = true,
  });

  OperatingExpense copyWith({
    String? id,
    String? name,
    double? cost,
    String? period,
    bool? active,
  }) {
    return OperatingExpense(
      id: id ?? this.id,
      name: name ?? this.name,
      cost: cost ?? this.cost,
      period: period ?? this.period,
      active: active ?? this.active,
    );
  }
}
