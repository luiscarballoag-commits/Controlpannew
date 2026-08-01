// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'elaboration_ingredient.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ElaborationIngredientAdapter extends TypeAdapter<ElaborationIngredient> {
  @override
  final int typeId = 10;

  @override
  ElaborationIngredient read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ElaborationIngredient(
      id: fields[0] as String,
      elaborationId: fields[1] as String,
      inventoryItemId: fields[2] as String,
      ingredientName: fields[3] as String,
      gramsPerPiece: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ElaborationIngredient obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.elaborationId)
      ..writeByte(2)
      ..write(obj.inventoryItemId)
      ..writeByte(3)
      ..write(obj.ingredientName)
      ..writeByte(4)
      ..write(obj.gramsPerPiece);
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
