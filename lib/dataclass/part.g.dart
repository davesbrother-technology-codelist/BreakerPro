// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'part.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PartAdapter extends TypeAdapter<Part> {
  @override
  final int typeId = 0;

  @override
  Part read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Part(
      fields[0] as int,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      fields[5] as String,
      fields[6] as String,
      fields[7] as String,
      fields[8] as String,
    )..isSelected = fields[9] as bool;
  }

  @override
  void write(BinaryWriter writer, Part obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.partName)
      ..writeByte(2)
      ..write(obj.partType)
      ..writeByte(3)
      ..write(obj.predefinedList)
      ..writeByte(4)
      ..write(obj.postageOptions)
      ..writeByte(5)
      ..write(obj.defaultLocation)
      ..writeByte(6)
      ..write(obj.defaultDescription)
      ..writeByte(7)
      ..write(obj.postageOptionsCode)
      ..writeByte(8)
      ..write(obj.ebayTitle)
      ..writeByte(9)
      ..write(obj.isSelected);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PartAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
