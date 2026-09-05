// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operating_expense.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OperatingExpenseAdapter extends TypeAdapter<OperatingExpense> {
  @override
  final int typeId = 15;

  @override
  OperatingExpense read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OperatingExpense(
      id: fields[0] as String,
      name: fields[1] as String,
      cost: fields[2] as double,
      period: fields[3] as String,
      active: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, OperatingExpense obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.cost)
      ..writeByte(3)
      ..write(obj.period)
      ..writeByte(4)
      ..write(obj.active);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OperatingExpenseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
