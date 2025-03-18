// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meat_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MeatItemAdapter extends TypeAdapter<MeatItem> {
  @override
  final int typeId = 0;

  @override
  MeatItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MeatItem(
      type: fields[0] as String,
      totalCount: fields[1] as double,
      lastUpdated: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, MeatItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.totalCount)
      ..writeByte(2)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeatItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
