// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'elaboration_recipe.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ElaborationRecipeAdapter extends TypeAdapter<ElaborationRecipe> {
  @override
  final int typeId = 20;

  @override
  ElaborationRecipe read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ElaborationRecipe(
      id: fields[0] as String,
      name: fields[1] as String,
      ingredients: (fields[2] as List).cast<ElaborationIngredient>(),
    );
  }

  @override
  void write(BinaryWriter writer, ElaborationRecipe obj) {
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
      other is ElaborationRecipeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
