import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 8)
class Product extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String massRecipeId;

  @HiveField(3)
  double pieceWeightGrams;

  @HiveField(4)
  bool isFilled;

  @HiveField(5)
  bool isActive;

  @HiveField(6)
  String notes;

  Product({
    required this.id,
    required this.name,
    required this.massRecipeId,
    required this.pieceWeightGrams,
    this.isFilled = false,
    this.isActive = true,
    this.notes = '',
  });
}
