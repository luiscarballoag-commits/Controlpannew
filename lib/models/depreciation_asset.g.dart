// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'depreciation_asset.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DepreciationAssetAdapter extends TypeAdapter<DepreciationAsset> {
  @override
  final int typeId = 14;

  @override
  DepreciationAsset read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DepreciationAsset(
      id: fields[0] as String,
      name: fields[1] as String,
      purchaseValue: fields[2] as double,
      usefulLifeYears: fields[3] as double,
      productiveHoursPerMonth: fields[4] as double,
      active: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, DepreciationAsset obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.purchaseValue)
      ..writeByte(3)
      ..write(obj.usefulLifeYears)
      ..writeByte(4)
      ..write(obj.productiveHoursPerMonth)
      ..writeByte(5)
      ..write(obj.active);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DepreciationAssetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
