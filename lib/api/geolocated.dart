import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:decodart/util/online.dart' show hostName;
import 'package:decodart/util/logger.dart' show logger;
import 'package:decodart/model/geolocated.dart' show GeolocatedListItem;

// fetchAllOnMap
// fetchAroundMe

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
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final results = jsonDecode(response.body);
      List<GeolocatedListItem> listItems = results['data'].map((item) => GeolocatedListItem.fromJson(item))
                                                          .toList()
                                                          .cast<GeolocatedListItem>();
      return listItems;
    } else {
      logger.e('Error from server: ${response.statusCode}');
    }
  } catch (e, stackTrace) {
    logger.e(e);
    logger.d(stackTrace);
  }
  return [];
}

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
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final results = jsonDecode(response.body);
      List<GeolocatedListItem> listItems = results['data'].map((item) => GeolocatedListItem.fromJson(item))
                                                          .toList()
                                                          .cast<GeolocatedListItem>();
      return listItems;
    } else {
      logger.e('Error from server: ${response.statusCode}');
    }
  } catch (e, stackTrace) {
    logger.e(e);
    logger.d(stackTrace);
  }
  return [];
}