// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BoundingBoxAdapter extends TypeAdapter<BoundingBox> {
  @override
  final int typeId = 1;

  @override
  BoundingBox read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BoundingBox(
      uid: fields[0] == null ? 0 : fields[0] as int?,
      x: fields[1] == null ? 0 : fields[1] as double,
      y: fields[2] == null ? 0 : fields[2] as double,
      width: fields[3] == null ? 0 : fields[3] as double,
      height: fields[4] == null ? 0 : fields[4] as double,
      label: fields[5] == null ? '' : fields[5] as String,
      description: fields[6] == null ? '' : fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BoundingBox obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.x)
      ..writeByte(2)
      ..write(obj.y)
      ..writeByte(3)
      ..write(obj.width)
      ..writeByte(4)
      ..write(obj.height)
      ..writeByte(5)
      ..write(obj.label)
      ..writeByte(6)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BoundingBoxAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ImageAdapter extends TypeAdapter<Image> {
  @override
  final int typeId = 2;

  @override
  Image read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Image(
      uid: fields[0] == null ? 0 : fields[0] as int,
      boundingBoxes: (fields[1] as List?)?.cast<BoundingBox>(),
      path: fields[2] as String,
      data: fields[3] as Uint8List,
    );
  }

  @override
  void write(BinaryWriter writer, Image obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.boundingBoxes)
      ..writeByte(2)
      ..write(obj.path)
      ..writeByte(3)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
