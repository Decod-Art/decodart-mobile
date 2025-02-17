
import 'package:hive/hive.dart';
import 'dart:typed_data' show Uint8List;

// dart run build_runner build
// hive data at the bottom of current file
part 'image.g.dart';

@HiveType(typeId: 1)
class BoundingBox {
  @HiveField(0, defaultValue: 0)
  final int? uid;
  @HiveField(1, defaultValue: 0)
  final double x;
  @HiveField(2, defaultValue: 0)
  final double y;
  @HiveField(3, defaultValue: 0)
  final double width;
  @HiveField(4, defaultValue: 0)
  final double height;
  @HiveField(5, defaultValue: "")
  final String label;
  @HiveField(6, defaultValue: "")
  final String description;

  BoundingBox({
    required this.uid,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.label = "",
    this.description = ""
  });
}

@HiveType(typeId: 2)
class Image {
  @HiveField(0, defaultValue: 0)
  final int? uid;
  @HiveField(1, defaultValue: null)
  final List<BoundingBox>? boundingBoxes;
  @HiveField(2)
  final String path;
  @HiveField(3)
  final Uint8List data;

  Image({
    required this.uid,
    required this.boundingBoxes,
    required this.path,
    required this.data
  });
}