import 'package:hive/hive.dart';

part 'depreciation_asset.g.dart';

@HiveType(typeId: 14)
class DepreciationAsset extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double purchaseValue;

  @HiveField(3)
  final double usefulLifeYears;

  @HiveField(4)
  final double productiveHoursPerMonth;

  @HiveField(5)
  final bool active;

  DepreciationAsset({
    required this.id,
    required this.name,
    required this.purchaseValue,
    required this.usefulLifeYears,
    required this.productiveHoursPerMonth,
    this.active = true,
  });

  DepreciationAsset copyWith({
    String? id,
    String? name,
    double? purchaseValue,
    double? usefulLifeYears,
    double? productiveHoursPerMonth,
    bool? active,
  }) {
    return DepreciationAsset(
      id: id ?? this.id,
      name: name ?? this.name,
      purchaseValue: purchaseValue ?? this.purchaseValue,
      usefulLifeYears: usefulLifeYears ?? this.usefulLifeYears,
      productiveHoursPerMonth:
          productiveHoursPerMonth ?? this.productiveHoursPerMonth,
      active: active ?? this.active,
    );
  }
}
