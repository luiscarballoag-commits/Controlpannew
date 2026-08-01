import 'package:hive/hive.dart';

part 'product_component.g.dart';

@HiveType(typeId: 10)
class ProductComponent extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String productId;

  @HiveField(2)
  String ingredientId;

  @HiveField(3)
  String ingredientName;

  @HiveField(4)
  double gramsPerPiece;

  ProductComponent({
    required this.id,
    required this.productId,
    required this.ingredientId,
    required this.ingredientName,
    required this.gramsPerPiece,
  });
}
