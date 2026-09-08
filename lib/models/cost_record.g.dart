// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cost_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CostRecordAdapter extends TypeAdapter<CostRecord> {
  @override
  final int typeId = 8;

  @override
  CostRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CostRecord(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      productionId: fields[2] as String,
      recipeName: fields[3] as String,
      rawMaterialCost: fields[4] as double,
      laborCost: fields[5] as double,
      operatingCost: fields[6] as double,
      depreciationCost: fields[7] as double,
      totalCost: fields[8] as double,
      costPerKg: fields[9] as double,
      costPerPiece: fields[10] as double,
      profitPercentage: fields[11] as double,
      suggestedSalePrice: fields[12] as double,
      elaborationCost: fields[13] as double,
    );
  }

  @override
  void write(BinaryWriter writer, CostRecord obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.productionId)
      ..writeByte(3)
      ..write(obj.recipeName)
      ..writeByte(4)
      ..write(obj.rawMaterialCost)
      ..writeByte(5)
      ..write(obj.laborCost)
      ..writeByte(6)
      ..write(obj.operatingCost)
      ..writeByte(7)
      ..write(obj.depreciationCost)
      ..writeByte(8)
      ..write(obj.totalCost)
      ..writeByte(9)
      ..write(obj.costPerKg)
      ..writeByte(10)
      ..write(obj.costPerPiece)
      ..writeByte(11)
      ..write(obj.profitPercentage)
      ..writeByte(12)
      ..write(obj.suggestedSalePrice)
      ..writeByte(13)
      ..write(obj.elaborationCost);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CostRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
