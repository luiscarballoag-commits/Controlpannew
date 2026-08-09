// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'elaboration_production.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ElaborationProductionAdapter extends TypeAdapter<ElaborationProduction> {
  @override
  final int typeId = 22;

  @override
  ElaborationProduction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ElaborationProduction(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      recipeId: fields[2] as String,
      recipeName: fields[3] as String,
      quantity: fields[4] as int,
      productionId: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ElaborationProduction obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.recipeId)
      ..writeByte(3)
      ..write(obj.recipeName)
      ..writeByte(4)
      ..write(obj.quantity)
      ..writeByte(5)
      ..write(obj.productionId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ElaborationProductionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
