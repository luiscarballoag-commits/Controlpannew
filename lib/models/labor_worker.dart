import 'package:hive/hive.dart';

part 'labor_worker.g.dart';

@HiveType(typeId: 13)
class LaborWorker extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String role;

  @HiveField(2)
  final double quantity;

  @HiveField(3)
  final double cost;

  @HiveField(4)
  final String period;

  @HiveField(5)
  final bool active;
  @HiveField(6)
  final double hoursPerDay;

  LaborWorker({
    required this.id,
    required this.role,
    required this.quantity,
    required this.cost,
    required this.period,
    this.active = true,
    this.hoursPerDay = 8,
  });

  LaborWorker copyWith({
    String? id,
    String? role,
    double? quantity,
    double? cost,
    String? period,
    bool? active,
    double? hoursPerDay,
  }) {
    return LaborWorker(
      id: id ?? this.id,
      role: role ?? this.role,
      quantity: quantity ?? this.quantity,
      cost: cost ?? this.cost,
      period: period ?? this.period,
      active: active ?? this.active,
      hoursPerDay: hoursPerDay ?? this.hoursPerDay,
    );
  }
}
