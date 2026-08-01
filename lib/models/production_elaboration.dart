import 'package:hive/hive.dart';

part 'production_elaboration.g.dart';

@HiveType(typeId: 9)
class ProductionElaboration extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String productionId;

  @HiveField(2)
  String productName;

  @HiveField(3)
  int quantity;

  @HiveField(4)
  bool completed;

  ProductionElaboration({
    required this.id,
    required this.productionId,
    required this.productName,
    required this.quantity,
    this.completed = false,
  });
}

