import 'package:decodart/api/offline/offline.dart';
import 'package:decodart/model/tour.dart' show TourListItem, Tour;
import 'package:decodart/util/online.dart' show hostName;
import 'package:decodart/util/logger.dart' show logger;
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonDecode;

// fetchAllTours
// fetchTourById

class FetchTourException implements Exception {
  final String message;
  FetchTourException(this.message);

  @override
  String toString() => 'FetchTourException: $message';
}

/// Fetches all tours with the specified parameters.
///
/// This method sends a GET request to the server to retrieve a list of tours
/// based on the provided parameters.
///
/// [limit] specifies the maximum number of tours to retrieve (default is 10).
/// [offset] specifies the offset for pagination (default is 0).
/// [museumId] is the identifier of the museum to filter the tours.
/// [isExhibition] specifies whether to filter tours that are exhibitions (default is false).
/// [query] is a search string to filter the tours.
/// [canUseOffline] permits to force the API to collect data online (e.g. when downloading data for the offline mode), (default true)
///
/// Returns a list of [TourListItem] objects if the request is successful.
///
/// Throws a [FetchTourException] if there is an error during the request or if the server returns an error.
Future<List<TourListItem>>  fetchAllTours({
  int limit=10,
  int offset=0,
  int? museumId,
  bool isExhibition=false,
  String? query,
  bool canUseOffline=true
}) async {
  if (OfflineManager.appIsOffline&&canUseOffline) {
    OfflineManager offline = OfflineManager();
    return offline.fetchAllTours(limit: limit, offset: offset, isExhibition: isExhibition, query: query);
  }
  try {
    final Uri uri = Uri.parse('$hostName/tours').replace(
      queryParameters: {
        'limit': '$limit',
        'offset': '$offset',
        if (museumId != null) 'museumId': '$museumId',
        'isExhibition': '$isExhibition',
        if (query != null) 'query': query
      },
    );
    logger.d(uri);
    final response = await http.get(uri).timeout(
      Duration(seconds: 5), onTimeout: () => http.Response('Request timed out', 408)
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'].map((tour) => TourListItem.fromJson(tour))
                                              .toList()
                                              .cast<TourListItem>();
    } else {
      throw FetchTourException('Error from server: ${response.statusCode}');
    }
  } catch (e, stackTrace) {
    logger.e(e);
    logger.d(stackTrace);
    rethrow;
  }
}

/// Fetches a tour by its unique identifier.
///
/// This method sends a GET request to the server to retrieve the details
/// of a tour specified by its unique identifier [id].
///
/// [id] is the unique identifier of the tour to retrieve.
/// [canUseOffline] permits to force the API to collect data online (e.g. when downloading data for the offline mode), (default true)
///
/// Returns a [Tour] object if the request is successful.
///
/// Throws a [FetchTourException] if there is an error during the request or if the server returns an error.
Future<Tour> fetchTourById(int id, {bool canUseOffline=true}) async {
  if (OfflineManager.appIsOffline&&canUseOffline) {
    OfflineManager offline = OfflineManager();
    return offline.fetchTourById(id);
  }
  try {
    final uri = Uri.parse('$hostName/tours/$id');
    logger.d(uri);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return Tour.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw FetchTourException('Failed to load tour: ${response.statusCode}');
    }
  } catch (e, stackTrace) {
    logger.e(e);
    logger.d(stackTrace);
    rethrow;
  }
}