import 'dart:typed_data' show Uint8List;

import 'package:decodart/model/museum.dart' show Museum;

mixin PDFOffline {
  Future<void> loadMapFromMuseum(Museum museum, Map<String, Uint8List> data) async {
    if (museum.hasMap) {
      final map = museum.pdfMap;
      final path = map.path;
      final mapData = await map.downloadData();
      data[path] = mapData;
    }
  }
}