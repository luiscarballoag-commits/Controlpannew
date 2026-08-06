import 'package:hive/hive.dart';

part 'elaboration_record.g.dart';

@HiveType(typeId: 24)
class ElaborationRecord extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String productionId;

  @HiveField(2)
  final String productName;

  @HiveField(3)
  final int quantity;

  @HiveField(4)
  final DateTime date;

  ElaborationRecord({
    required this.id,
    required this.productionId,
    required this.productName,
    required this.quantity,
    required this.date,
  });
}
