import 'package:decodart/model/abstract_item.dart' show UnnamedAbstractItem;
import 'package:decodart/util/online.dart' show checkUrlForCdn;
import 'package:decodart/model/hive/image.dart' as hive;
import 'dart:typed_data' show Uint8List;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart' show Offset;


abstract class AbstractImage extends UnnamedAbstractItem {
  final List<BoundingBox>? boundingBoxes;
  const AbstractImage({
    super.uid,
    this.boundingBoxes
  });

  bool get isDownloaded => false;

  Uint8List? get data => null;

  String get path;

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'boundingboxes': boundingBoxes?.map((item) => item.toJson()).toList()
    };
  }

  AbstractImage copyWithNewBoundingBoxes(List<BoundingBox>? boundingBoxes);

  bool get hasBoundingBox => boundingBoxes != null;
}

class ImageOnline extends AbstractImage {
  final String _path;
  @override
  Uint8List? data;

  ImageOnline(
    String path,
    {
      super.uid,
      super.boundingBoxes,
      this.data
    }):_path = path;

  @override
  String get path => checkUrlForCdn(_path)!;

  Future<void> downloadImageData() async {
    final response = await http.get(Uri.parse(path));
    if (response.statusCode == 200) {
      data = response.bodyBytes;
    } else {
      throw Exception('Failed to load image data');
    }
  }

  @override
  bool get isDownloaded => data != null;

  factory ImageOnline.fromJson(Map<String, dynamic>json) {
    return ImageOnline(
      json['path'],
      uid: json['uid'],
      boundingBoxes: json['boundingboxes']?.map((boundingBoxesJson) => BoundingBox.fromJson(boundingBoxesJson))
                                           .toList()
                                           .cast<BoundingBox>()
    );
  }

  factory ImageOnline.fromHive(hive.Image image) {
    return ImageOnline(
      image.path,
      uid: image.uid,
      boundingBoxes: image.boundingBoxes?.map((item) => BoundingBox.fromHive(item)).toList(),
      data: image.data
      );
  }

  hive.Image toHive({saveBoundingBox=true}) {
    return hive.Image(
      uid: uid!,
      boundingBoxes: saveBoundingBox?boundingBoxes?.map((item) => item.toHive()).toList():null,
      path: path,
      data: data!);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'path': _path,
    };
  }
  @override
  AbstractImage copyWithNewBoundingBoxes(List<BoundingBox>? boundingBoxes) {
    return ImageOnline(
      _path,
      uid: uid,
      boundingBoxes: boundingBoxes);
  }
}

class BoundingBox extends UnnamedAbstractItem{
  final double x, y, width, height;
  final String label;
  final String description;

  BoundingBox({
    super.uid,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.label = "",
    this.description = ""
  });

  factory BoundingBox.fromJson(Map<String, dynamic> json) {
    return BoundingBox(
      x: json['x'],
      y: json['y'],
      width: json['width'],
      height: json['height'],
      label: json['label'],
      description: json['description']);
  }

  factory BoundingBox.fromHive(hive.BoundingBox boundingBox) {
    return BoundingBox(
      x: boundingBox.x,
      y: boundingBox.y,
      width: boundingBox.width,
      height: boundingBox.height);
  }

  hive.BoundingBox toHive(){
    return hive.BoundingBox(
      uid: uid,
      x: x,
      y: y,
      width: width,
      height: height);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'label': label,
      'description': description
    };
  }

  Offset get startPoint {
    return Offset(x, y);
  }

  Offset get endPoint {
    return Offset(x+width, y+height);
  }

  Offset get center {
    return Offset(x+width/2, y+height/2);
  }
}
