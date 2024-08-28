// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ArtistForeignKeyAdapter extends TypeAdapter<ArtistForeignKey> {
  @override
  final int typeId = 3;

  @override
  ArtistForeignKey read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ArtistForeignKey(
      uid: fields[0] == null ? 0 : fields[0] as int,
      name: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ArtistForeignKey obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArtistForeignKeyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
