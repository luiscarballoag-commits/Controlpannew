// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'elaboration_ingredient.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ElaborationIngredientAdapter extends TypeAdapter<ElaborationIngredient> {
  @override
  final int typeId = 21;

  @override
  ElaborationIngredient read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ElaborationIngredient(
      ingredientId: fields[0] as String,
      ingredientName: fields[1] as String,
      quantity: fields[2] as double,
      unit: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ElaborationIngredient obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.ingredientId)
      ..writeByte(1)
      ..write(obj.ingredientName)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.unit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ElaborationIngredientAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
