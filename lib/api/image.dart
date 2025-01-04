import 'dart:typed_data' show Uint8List;

import 'package:decodart/api/offline.dart';
import 'package:decodart/util/logger.dart';
import 'package:http/http.dart' as http;

/// An exception that is thrown when an error occurs while fetching an image.
class FetchImageException implements Exception {
  final String message;

  /// Constructs a [FetchImageException] with the given error [message].
  FetchImageException(this.message);

  @override
  String toString() => 'FetchImageException: $message';
}

Future<Uint8List> fetchImageData(String path, {bool canUseOffline=true}) async {
  if (OfflineManager.useOffline&&canUseOffline) {
    OfflineManager offline = OfflineManager();
    return offline.fetchImageData(path);
  }
  try {
    final response = await http.get(Uri.parse(path));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw FetchImageException('Failed to load image data');
    }
  } catch(e) {
    logger.e(e);
    rethrow;
  }
}