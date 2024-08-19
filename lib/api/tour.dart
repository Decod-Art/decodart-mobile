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

Future<List<TourListItem>>  fetchAllTours() async {
    try {
    final response = await http.get(Uri.parse('$hostName/tours/'));
    if (response.statusCode == 200) {
      List<dynamic> tours = jsonDecode(response.body);
      return tours.map((tour) => TourListItem.fromJson(tour)).toList();
    }
  } catch (e, stackTrace) {
    print(e);
    print(stackTrace);
  }
  return [];
}

Future<List<TourListItem>>  fetchExhibitionByMuseum(int museumId) async {
    try {
    final response = await http.get(Uri.parse('$hostName/tours/exhibition/museum/$museumId'));
    if (response.statusCode == 200) {
      List<dynamic> tours = jsonDecode(response.body);
      return tours.map((tour) => TourListItem.fromJson(tour)).toList();
    }
  } catch (e, stackTrace) {
    print(e);
    print(stackTrace);
  }
  return [];
}

Future<List<TourListItem>>  fetchTourByMuseum(int museumId) async {
    try {
    final response = await http.get(Uri.parse('$hostName/tours/museum/$museumId'));
    if (response.statusCode == 200) {
      List<dynamic> tours = jsonDecode(response.body);
      return tours.map((tour) => TourListItem.fromJson(tour)).toList();
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
        Map<String, dynamic> json = jsonDecode(response.body);
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