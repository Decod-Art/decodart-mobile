// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artwork.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ArtworkListItemAdapter extends TypeAdapter<ArtworkListItem> {
  @override
  final int typeId = 4;

  @override
  ArtworkListItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ArtworkListItem(
      uid: fields[0] as int,
      title: fields[3] as String,
      artist: fields[1] as ArtistForeignKey,
      image: fields[2] as Image,
    );
  }

  @override
  void write(BinaryWriter writer, ArtworkListItem obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.artist)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.title);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArtworkListItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
