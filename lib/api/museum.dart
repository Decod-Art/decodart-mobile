import 'package:decodart/model/museum.dart' show MuseumListItem, Museum;
import 'package:decodart/util/logger.dart' show logger;
import 'package:decodart/util/online.dart' show hostName;
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonDecode;

class FetchMuseumException implements Exception {
  final String message;
  FetchMuseumException(this.message);

  @override
  String toString() => 'FetchMuseumException: $message';
}

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
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final museums = jsonDecode(response.body);
      List<MuseumListItem> listItems = museums['data'].map((museum) => MuseumListItem.fromJson(museum))
                                                      .toList()
                                                      .cast<MuseumListItem>();
      return listItems;
    } else {
      logger.e('Error from server: ${response.statusCode}');
      throw FetchMuseumException('Error from server: ${response.statusCode}');
    }
  } catch (e, stackTrace) {
    logger.e(e);
    logger.d(stackTrace);
    rethrow;
  } 
}

Future<Museum> fetchMuseumById(int id) async {
  try {
    final uri = Uri.parse('$hostName/museums/$id');
    logger.d(uri);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body)['data'];
      return Museum.fromJson(json);
    } else {
      throw FetchMuseumException('Failed to load museum: ${response.statusCode}');
    }
  } catch (e, stackTrace) {
    logger.e(e);
    logger.d(stackTrace);
    rethrow;
  }
}