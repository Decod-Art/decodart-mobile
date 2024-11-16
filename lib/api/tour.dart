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

Future<List<TourListItem>>  fetchAllTours({
  int limit=10,
  int offset=0,
  int? museumId,
  bool isExhibition=false,
  String? query
}) async {
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
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final tours = jsonDecode(response.body);
      return tours['data'].map((tour) => TourListItem.fromJson(tour))
                          .toList()
                          .cast<TourListItem>();
    } else {
      logger.e('Error from server: ${response.statusCode}');
      throw FetchTourException('Error from server: ${response.statusCode}');
    }
  } catch (e, stackTrace) {
    logger.e(e);
    logger.d(stackTrace);
    rethrow;
  }
}

Future<Tour> fetchTourById(int id) async {
  try {
    final uri = Uri.parse('$hostName/tours/$id');
    logger.d(uri);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body)['data'];
      return Tour.fromJson(json);
    } else {
      throw FetchTourException('Failed to load tour: ${response.statusCode}');
    }
  } catch (e, stackTrace) {
    logger.e(e);
    logger.d(stackTrace);
    rethrow;
  }
}