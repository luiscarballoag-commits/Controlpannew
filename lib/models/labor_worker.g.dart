// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'labor_worker.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LaborWorkerAdapter extends TypeAdapter<LaborWorker> {
  @override
  final int typeId = 13;

  @override
  LaborWorker read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LaborWorker(
      id: fields[0] as String,
      role: fields[1] as String,
      quantity: fields[2] as double,
      cost: fields[3] as double,
      period: fields[4] as String,
      active: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, LaborWorker obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.role)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.cost)
      ..writeByte(4)
      ..write(obj.period)
      ..writeByte(5)
      ..write(obj.active);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LaborWorkerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
