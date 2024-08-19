import 'package:decodart/model/museum.dart' show MuseumListItem, Museum;
import 'package:decodart/api/util.dart' show hostName;
import 'package:http/http.dart' as http;
import 'dart:convert';

class FetchMuseumException implements Exception {
  final String message;
  FetchMuseumException(this.message);

  @override
  String toString() => 'FetchMuseumException: $message';
}

Future<List<MuseumListItem>>  fetchAllMuseums() async {
    try {
    final response = await http.get(Uri.parse('$hostName/museums/'));
    if (response.statusCode == 200) {
      List<dynamic> museums = jsonDecode(response.body);
      List<MuseumListItem> listItems = museums.map((museum) => MuseumListItem.fromJson(museum)).toList();
      return listItems;
    }
  } catch (e, stackTrace) {
    print(e);
    print(stackTrace);
  }
  return [];
}

Future<Museum> fetchMuseumById(int id) async {
  try {
      final response = await http.get(Uri.parse('$hostName/museums/$id'));
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        return Museum.fromJson(json);
      } else {
        throw FetchMuseumException('Failed to load museum: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
      rethrow;
    }
}