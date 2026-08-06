// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'elaboration_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ElaborationRecordAdapter extends TypeAdapter<ElaborationRecord> {
  @override
  final int typeId = 24;

  @override
  ElaborationRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ElaborationRecord(
      id: fields[0] as String,
      productionId: fields[1] as String,
      productName: fields[2] as String,
      quantity: fields[3] as int,
      date: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ElaborationRecord obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productionId)
      ..writeByte(2)
      ..write(obj.productName)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ElaborationRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
