import 'package:decodart/api/offline.dart';
import 'package:decodart/model/museum.dart' show MuseumListItem, Museum;
import 'package:decodart/util/logger.dart' show logger;
import 'package:decodart/util/online.dart' show hostName;
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonDecode;

// fetchAllMuseums
// fetchMuseumById

class FetchMuseumException implements Exception {
  final String message;
  FetchMuseumException(this.message);

  @override
  String toString() => 'FetchMuseumException: $message';
}

/// Fetches all museums with the specified parameters.
///
/// This method sends a GET request to the server to retrieve a list of museums
/// based on the provided parameters.
///
/// [limit] specifies the maximum number of museums to retrieve (default is 10).
/// [offset] specifies the offset for pagination (default is 0).
/// [query] is a search string to filter the museums.
///
/// Returns a list of [MuseumListItem] objects if the request is successful.
///
/// Throws a [FetchMuseumException] if there is an error during the request or if the server returns an error.
Future<List<MuseumListItem>>  fetchAllMuseums({
  int limit=10,
  int offset=0,
  String? query
}) async {
  try {
    final Uri uri = Uri.parse('$hostName/museums').replace(
      queryParameters: {
        'limit': '$limit',
        'offset': '$offset',
        if (query != null) 'query': query,
      },
    );
    logger.d(uri);
    final response = await http.get(uri).timeout(
      Duration(seconds: 5), onTimeout: () => http.Response('Request timed out', 408)
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'].map((museum) => MuseumListItem.fromJson(museum))
                                              .toList()
                                              .cast<MuseumListItem>();
    } else {
      throw FetchMuseumException('Error from server: ${response.statusCode}');
    }
  } catch (e, stackTrace) {
    logger.e(e);
    logger.d(stackTrace);
    rethrow;
  } 
}

/// Fetches a museum by its unique identifier.
///
/// This method sends a GET request to the server to retrieve the details
/// of a museum specified by its unique identifier [id].
///
/// [id] is the unique identifier of the museum to retrieve.
///
/// Returns a [Museum] object if the request is successful.
///
/// Throws a [FetchMuseumException] if there is an error during the request or if the server returns an error.
Future<Museum> fetchMuseumById(int id, {canUseOffline=true}) async {
  if (OfflineManager.useOffline&&canUseOffline) {
    OfflineManager offline = OfflineManager();
    return offline.fetchMuseumById(id);
  }
  try {
    final uri = Uri.parse('$hostName/museums/$id');
    logger.d(uri);
    final response = await http.get(uri).timeout(
      Duration(seconds: 5), onTimeout: () => http.Response('Request timed out', 408)
    );
    if (response.statusCode == 200) {
      return Museum.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw FetchMuseumException('Failed to load museum: ${response.statusCode}');
    }
  } catch (e, stackTrace) {
    logger.e(e);
    logger.d(stackTrace);
    rethrow;
  }
}