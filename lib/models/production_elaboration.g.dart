// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'production_elaboration.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductionElaborationAdapter extends TypeAdapter<ProductionElaboration> {
  @override
  final int typeId = 9;

  @override
  ProductionElaboration read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductionElaboration(
      id: fields[0] as String,
      productionId: fields[1] as String,
      productName: fields[2] as String,
      quantity: fields[3] as int,
      completed: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ProductionElaboration obj) {
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
      ..write(obj.completed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductionElaborationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
