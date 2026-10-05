// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'production_variety_cost.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductionVarietyCostAdapter extends TypeAdapter<ProductionVarietyCost> {
  @override
  final int typeId = 25;

  @override
  ProductionVarietyCost read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductionVarietyCost(
      id: fields[0] as String,
      productionId: fields[1] as String,
      recipeId: fields[2] as String,
      productName: fields[3] as String,
      quantity: fields[4] as int,
      baseCostPerPiece: fields[5] as double,
      elaborationCostPerPiece: fields[6] as double,
      totalCostPerPiece: fields[7] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ProductionVarietyCost obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productionId)
      ..writeByte(2)
      ..write(obj.recipeId)
      ..writeByte(3)
      ..write(obj.productName)
      ..writeByte(4)
      ..write(obj.quantity)
      ..writeByte(5)
      ..write(obj.baseCostPerPiece)
      ..writeByte(6)
      ..write(obj.elaborationCostPerPiece)
      ..writeByte(7)
      ..write(obj.totalCostPerPiece);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductionVarietyCostAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
