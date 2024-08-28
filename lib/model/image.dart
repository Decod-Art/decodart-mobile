import 'package:decodart/model/abstract_item.dart' show UnnamedAbstractItem;
import 'package:decodart/api/util.dart' show checkUrlForCdn;
import 'package:decodart/model/hive/image.dart' as hive;
import 'package:flutter/material.dart';


abstract class AbstractImage extends UnnamedAbstractItem {
  final List<BoundingBox>? boundingBoxes;
  const AbstractImage({
    super.uid,
    this.boundingBoxes
  });
  String get path;
  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'boundingboxes': boundingBoxes?.map((item) => item.toJson()).toList()
    };
  }
  AbstractImage copyWithNewBoundingBoxes(List<BoundingBox>? boundingBoxes);
}

class ImageWithPath extends AbstractImage {
  final String _path;
  const ImageWithPath(
    String path,
    {
      super.uid,
      super.boundingBoxes,
    }):_path = path;

  @override
  String get path => checkUrlForCdn(_path)!;

  factory ImageWithPath.fromJson(Map<String, dynamic>json) {
    return ImageWithPath(
      json['path'],
      uid: json['uid'],
      boundingBoxes: json['boundingboxes']?.map((boundingBoxesJson) => BoundingBox.fromJson(boundingBoxesJson))
                                           .toList()
                                           .cast<BoundingBox>()

    );
  }

  factory ImageWithPath.fromHive(hive.Image image) {
    return ImageWithPath(
      image.path,
      uid: image.uid,
      boundingBoxes: image.boundingBoxes?.map((item) => BoundingBox.fromHive(item)).toList(),
      );
  }

  hive.Image toHive({saveBoundingBox=true}) {
    return hive.Image(
      uid: uid!,
      boundingBoxes: saveBoundingBox?boundingBoxes?.map((item) => item.toHive()).toList():null,
      path: path);
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
    return ImageWithPath(
      _path,
      uid: uid,
      boundingBoxes: boundingBoxes);
  }
}

class ImageWithData extends AbstractImage {
  final String content;
  final String filetype;
  const ImageWithData(
    String data,
    {
      super.uid,
      super.boundingBoxes,
      required this.filetype,
    }):content = data;

  String get data => content.split(',').last;

  @override
  String get path => content;
  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'imagedata': data,
      'filetype': filetype,
    };
  }
  @override
  AbstractImage copyWithNewBoundingBoxes(List<BoundingBox>? boundingBoxes) {
    return ImageWithData(
      content,
      uid: uid,
      boundingBoxes: boundingBoxes,
      filetype: filetype);
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
