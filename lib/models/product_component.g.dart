// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_component.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductComponentAdapter extends TypeAdapter<ProductComponent> {
  @override
  final int typeId = 10;

  @override
  ProductComponent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductComponent(
      id: fields[0] as String,
      productId: fields[1] as String,
      ingredientId: fields[2] as String,
      ingredientName: fields[3] as String,
      gramsPerPiece: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ProductComponent obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.ingredientId)
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
      other is ProductComponentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
