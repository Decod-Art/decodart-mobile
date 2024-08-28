// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'decod.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameDataAdapter extends TypeAdapter<GameData> {
  @override
  final int typeId = 0;

  @override
  GameData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameData(
      success: fields[0] == null ? 0 : fields[0] as double,
      count: fields[1] == null ? 0 : fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, GameData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.success)
      ..writeByte(1)
      ..write(obj.count);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
