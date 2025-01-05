import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:decodart/api/data.dart' show fetchData;
import 'package:decodart/model/abstract_item.dart' show UnnamedAbstractItem;
import 'package:decodart/util/online.dart' show checkUrlForCdn;
import 'package:decodart/model/hive/image.dart' as hive;
import 'dart:typed_data' show Uint8List;
import 'package:flutter/material.dart' show Offset, Size;
import 'package:mutex/mutex.dart' show Mutex;

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
  Map<String, dynamic> toJson() => {
    ...super.toJson(), 'boundingboxes': boundingBoxes?.map((item) => item.toJson()).toList()
  };

  AbstractImage copyWithNewBoundingBoxes(List<BoundingBox>? boundingBoxes);

  bool get hasBoundingBox => boundingBoxes != null;
}

class ImageOnline extends AbstractImage {
  final Mutex mutex = Mutex();
  final String _path;

  @override
  Uint8List? data;

  ImageOnline(
    String path,
    {super.uid, super.boundingBoxes, this.data}
  ):_path = path;

  @override
  String get path => checkUrlForCdn(_path)!;

  Future<Uint8List> downloadImageData({keep=true}) async {
    await mutex.acquire();
    try {
      final Uint8List data = hasData ? this.data! : await fetchData(path);
      if (!hasData && keep) {
         this.data = data;
      } else if (keep == false){
        this.data = null;
      }
      return data;
    } finally {
      mutex.release();
    }
  }
  
  Future<Size> getDimension({keep=true}) async {
    final imageData = await downloadImageData(keep: keep);
    final ui.Image image = await _decodeImage(imageData);
    return Size(image.width.toDouble(), image.height.toDouble());
  }

  Future<ui.Image> _decodeImage(Uint8List imageData) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(imageData, (ui.Image img) {
      completer.complete(img);
    });
    return completer.future;
  }

  void clearImageData() {
    data = null;
  }

  @override
  bool get isDownloaded => data != null;

  bool get hasData => isDownloaded;

  factory ImageOnline.fromJson(Map<String, dynamic>json) => ImageOnline(
    json['path'],
    uid: json['uid'],
    boundingBoxes: json['boundingboxes']?.map((boundingBoxesJson) => BoundingBox.fromJson(boundingBoxesJson))
                                         .toList()
                                         .cast<BoundingBox>()
  );

  factory ImageOnline.fromHive(hive.Image image) =>ImageOnline(
    image.path,
    uid: image.uid,
    boundingBoxes: image.boundingBoxes?.map((item) => BoundingBox.fromHive(item)).toList(),
    data: image.data
  );

  hive.Image toHive({saveBoundingBox=true}) => hive.Image(
    uid: uid,
    boundingBoxes: saveBoundingBox?boundingBoxes?.map((item) => item.toHive()).toList():null,
    path: path,
    data: data!
  );

  @override
  Map<String, dynamic> toJson() => {...super.toJson(), 'path': _path};

  @override
  AbstractImage copyWithNewBoundingBoxes(List<BoundingBox>? boundingBoxes) => ImageOnline(
    _path,
    uid: uid,
    boundingBoxes: boundingBoxes
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ImageOnline) return false;
    return _path == other._path;
  }

  @override
  int get hashCode => _path.hashCode;
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

  factory BoundingBox.fromJson(Map<String, dynamic> json) => BoundingBox(
    x: json['x'],
    y: json['y'],
    width: json['width'],
    height: json['height'],
    label: json['label'],
    description: json['description']
  );

  factory BoundingBox.fromHive(hive.BoundingBox boundingBox) => BoundingBox(
    x: boundingBox.x,
    y: boundingBox.y,
    width: boundingBox.width,
    height: boundingBox.height
  );

  hive.BoundingBox toHive() => hive.BoundingBox(
    uid: uid,
    x: x,
    y: y,
    width: width,
    height: height
  );

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'x': x,
    'y': y,
    'width': width,
    'height': height,
    'label': label,
    'description': description
  };

  Offset get startPoint => Offset(x, y);

  Offset get endPoint => Offset(x+width, y+height);

  Offset get center => Offset(x+width/2, y+height/2);
}
