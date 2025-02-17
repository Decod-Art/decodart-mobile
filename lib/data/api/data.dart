import 'dart:typed_data' show Uint8List;

import 'package:decodart/data/api/offline/offline.dart';
import 'package:decodart/util/logger.dart';
import 'package:http/http.dart' as http;

/// An exception that is thrown when an error occurs while fetching data from an URL.
class FetchDataException implements Exception {
  final String message;

  /// Constructs a [FetchDataException] with the given error [message].
  FetchDataException(this.message);

  @override
  String toString() => 'FetchImageException: $message';
}
/// Fetch the dta online or offline if option is set
/// canUseOffline is to permit the app to download "offline" data
/// even when the option is set to True by the user
Future<Uint8List> fetchData(String path, {bool canUseOffline=true}) async {
  // Offline Mode
  if (OfflineManager.appIsOffline&&canUseOffline) {
    OfflineManager offline = OfflineManager();
    return offline.fetchData(path);
  }

  // Online mode
  try {
    final response = await http.get(Uri.parse(path));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw FetchDataException('Failed to load data from $path');
    }
  } catch(e) {
    logger.e(e);
    rethrow;
  }
}