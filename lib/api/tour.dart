import 'package:decodart/model/tour.dart' show TourListItem, Tour;
import 'package:decodart/api/util.dart' show hostName;
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  bool isExhibition=false
}) async {
  try {
    final Uri uri = Uri.parse('$hostName/tours').replace(
      queryParameters: {
        'limit': '$limit',
        'offset': '$offset',
        if (museumId != null) 'museumId': '$museumId',
        'isExhibition': '$isExhibition',
      },
    );
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final tours = jsonDecode(response.body);
      return tours['data'].map((tour) => TourListItem.fromJson(tour))
                          .toList()
                          .cast<TourListItem>();
    }
  } catch (e, stackTrace) {
    print(e);
    print(stackTrace);
  }
  return [];
}

Future<Tour> fetchTourById(int id) async {
  try {
      final response = await http.get(Uri.parse('$hostName/tours/$id'));
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body)['data'];
        return Tour.fromJson(json);
      } else {
        throw FetchTourException('Failed to load tour: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
      rethrow;
    }
}