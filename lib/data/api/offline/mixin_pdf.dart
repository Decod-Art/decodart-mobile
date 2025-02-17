import 'dart:typed_data' show Uint8List;

import 'package:decodart/data/model/museum.dart' show Museum;

/// Mixin to handle the offline loading of PDF files.
mixin PDFOffline {
  /// Loads the map PDF associated with a museum.
  ///
  /// This method checks if the museum has a map, and if so, downloads the PDF data
  /// and stores it in the provided map.
  ///
  /// [museum] The [Museum] object containing the map information.
  /// [data] A map to store the downloaded PDF data, where the key is the file path 
  /// and the value is the [Uint8List] of PDF data.
  Future<void> loadMapFromMuseum(Museum museum, Map<String, Uint8List> data) async {
    if (museum.hasMap) {
      final map = museum.pdfMap;
      final path = map.path;
      final mapData = await map.downloadData();
      data[path] = mapData;
    }
  }
}