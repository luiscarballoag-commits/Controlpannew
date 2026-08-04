// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_recipe.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductRecipeAdapter extends TypeAdapter<ProductRecipe> {
  @override
  final int typeId = 11;

  @override
  ProductRecipe read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductRecipe(
      id: fields[0] as String,
      name: fields[1] as String,
      ingredients: (fields[2] as List).cast<RecipeIngredient>(),
    );
  }

  @override
  void write(BinaryWriter writer, ProductRecipe obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.ingredients);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductRecipeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
