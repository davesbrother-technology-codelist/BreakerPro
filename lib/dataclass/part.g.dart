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
    )
      ..isSelected = fields[9] as bool
      ..partCondition = fields[10] as String
      ..warranty = fields[11] as double
      ..qty = fields[12] as int
      ..salesPrice = fields[13] as double
      ..costPrice = fields[14] as double
      ..isDefault = fields[15] as bool
      ..mnfPartNo = fields[16] as String
      ..comments = fields[17] as String
      ..imgList = (fields[18] as List).cast<String>()
      ..partLocation = fields[19] as String
      ..description = fields[20] as String
      ..forUpload = fields[21] as bool
      ..status = fields[22] as String
      ..isEbay = fields[23] as bool
      ..isFeaturedWeb = fields[24] as bool
      ..featuredWebDate = fields[25] as String
      ..partId = fields[26] as String;
  }

  @override
  void write(BinaryWriter writer, Part obj) {
    writer
      ..writeByte(27)
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
      ..write(obj.isSelected)
      ..writeByte(10)
      ..write(obj.partCondition)
      ..writeByte(11)
      ..write(obj.warranty)
      ..writeByte(12)
      ..write(obj.qty)
      ..writeByte(13)
      ..write(obj.salesPrice)
      ..writeByte(14)
      ..write(obj.costPrice)
      ..writeByte(15)
      ..write(obj.isDefault)
      ..writeByte(16)
      ..write(obj.mnfPartNo)
      ..writeByte(17)
      ..write(obj.comments)
      ..writeByte(18)
      ..write(obj.imgList)
      ..writeByte(19)
      ..write(obj.partLocation)
      ..writeByte(20)
      ..write(obj.description)
      ..writeByte(21)
      ..write(obj.forUpload)
      ..writeByte(22)
      ..write(obj.status)
      ..writeByte(23)
      ..write(obj.isEbay)
      ..writeByte(24)
      ..write(obj.isFeaturedWeb)
      ..writeByte(25)
      ..write(obj.featuredWebDate)
      ..writeByte(26)
      ..write(obj.partId);
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
