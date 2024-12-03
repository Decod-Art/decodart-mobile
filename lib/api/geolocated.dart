import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:decodart/util/online.dart' show hostName;
import 'package:decodart/util/logger.dart' show logger;
import 'package:decodart/model/geolocated.dart' show GeolocatedListItem;

// fetchAllOnMap
// fetchAroundMe
class FetchGeolocatedException implements Exception {
  final String message;
  FetchGeolocatedException(this.message);

  @override
  String toString() => 'FetchGeolocatedException: $message';
}
/// Fetches all geolocated items within the specified latitude and longitude bounds.
///
/// This method sends a GET request to the server to retrieve a list of geolocated items
/// within the specified latitude and longitude bounds.
///
/// [minLatitude] specifies the minimum latitude of the bounding box.
/// [maxLatitude] specifies the maximum latitude of the bounding box.
/// [minLongitude] specifies the minimum longitude of the bounding box.
/// [maxLongitude] specifies the maximum longitude of the bounding box.
///
/// Returns a list of [GeolocatedListItem] objects if the request is successful.
///
/// Throws a [FetchGeolocatedException] if there is an error during the request or if the server returns an error.
Future<List<GeolocatedListItem>>  fetchAllOnMap({
  required double minLatitude,
  required double maxLatitude,
  required double minLongitude,
  required double maxLongitude}) async {
  try {
    final Uri uri = Uri.parse('$hostName/geolocated').replace(
      queryParameters: {
        'minLat': '$minLatitude',
        'maxLat': '$maxLatitude',
        'minLon': '$minLongitude',
        'maxLon': '$maxLongitude',
      },
    );
    logger.d(uri);
    final response = await http.get(uri).timeout(
      Duration(seconds: 5), onTimeout: () => http.Response('Request timed out', 408)
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'].map((item) => GeolocatedListItem.fromJson(item))
                                              .toList()
                                              .cast<GeolocatedListItem>();
    } else {
      throw FetchGeolocatedException("Error from server: ${response.statusCode}");
    }
  } catch (e, stackTrace) {
    logger.e(e);
    logger.d(stackTrace);
    rethrow;
  }
}

/// Fetches geolocated items around the specified location.
///
/// This method sends a GET request to the server to retrieve a list of geolocated items
/// around the specified latitude and longitude.
///
/// [limit] specifies the maximum number of items to retrieve (default is 10).
/// [offset] specifies the offset for pagination (default is 0).
/// [query] is a search string to filter the items.
/// [latitude] specifies the latitude of the location (default is 43.612286).
/// [longitude] specifies the longitude of the location (default is 3.880830).
///
/// Returns a list of [GeolocatedListItem] objects if the request is successful.
///
/// Throws a [FetchGeolocatedException] if there is an error during the request or if the server returns an error.
Future<List<GeolocatedListItem>>  fetchAroundMe({
  int limit=10,
  int offset=0,
  String? query,
  double latitude=43.612286,
  double longitude=3.880830
}) async {
  try {
    final Uri uri = Uri.parse('$hostName/geolocated/aroundme').replace(
      queryParameters: {
        'latitude': '$latitude',
        'longitude': '$longitude',
        if (query != null) 'query': query,
        'limit': '$limit',
        'offset': '$offset'
      },
    );
    logger.d(uri);
    final response = await http.get(uri).timeout(
      Duration(seconds: 5), onTimeout: () => http.Response('Request timed out', 408)
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'].map((item) => GeolocatedListItem.fromJson(item))
                                              .toList()
                                              .cast<GeolocatedListItem>();
    } else {
      throw FetchGeolocatedException('Error from server: ${response.statusCode}');
    }
  } catch (e, stackTrace) {
    logger.e(e);
    logger.d(stackTrace);
    rethrow;
  }  
}