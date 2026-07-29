// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_catalog.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IngredientCatalogAdapter extends TypeAdapter<IngredientCatalog> {
  @override
  final int typeId = 0;

  @override
  IngredientCatalog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IngredientCatalog(
      id: fields[0] as String,
      name: fields[1] as String,
      category: fields[2] as String,
      unit: fields[3] as String,
      purchasePrice: fields[4] as double,
      stock: fields[5] as double,
      minimumStock: fields[6] as double,
      notes: fields[7] as String,
      purchaseUnit: fields[8] as String,
      packageSize: fields[9] as double,
      packageUnit: fields[10] as String,
      normalizedStock: fields[11] as double,
    );
  }

  @override
  void write(BinaryWriter writer, IngredientCatalog obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.unit)
      ..writeByte(4)
      ..write(obj.purchasePrice)
      ..writeByte(5)
      ..write(obj.stock)
      ..writeByte(6)
      ..write(obj.minimumStock)
      ..writeByte(7)
      ..write(obj.notes)
      ..writeByte(8)
      ..write(obj.purchaseUnit)
      ..writeByte(9)
      ..write(obj.packageSize)
      ..writeByte(10)
      ..write(obj.packageUnit)
      ..writeByte(11)
      ..write(obj.normalizedStock);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IngredientCatalogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
