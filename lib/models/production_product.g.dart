// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'production_product.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductionProductAdapter extends TypeAdapter<ProductionProduct> {
  @override
  final int typeId = 12;

  @override
  ProductionProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductionProduct(
      id: fields[0] as String,
      productionId: fields[1] as String,
      productName: fields[2] as String,
      quantity: fields[3] as int,
      extraCost: fields[4] as double,
      date: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ProductionProduct obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productionId)
      ..writeByte(2)
      ..write(obj.productName)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.extraCost)
      ..writeByte(5)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductionProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
