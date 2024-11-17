import 'dart:convert' show jsonDecode;
import 'package:decodart/model/museum.dart' show MuseumForeignKey;
import 'package:http/http.dart' as http;

import 'package:decodart/util/online.dart' show hostName;
import 'package:decodart/util/logger.dart' show logger;
import 'package:decodart/model/room.dart' show RoomListItem;

// fetchRooms

class FetchRoomsException implements Exception {
  final String message;
  FetchRoomsException(this.message);

  @override
  String toString() => 'FetchRoomsException: $message';
}

Future<List<RoomListItem>> fetchRooms({
    int limit=5,
    int offset=0,
    String? query,
    required MuseumForeignKey museum
  }) async {

  final uri = Uri.parse('$hostName/rooms').replace(
    queryParameters: {
      'limit': limit.toString(),
      'offset': offset.toString(),
      'museumId': museum.uid!.toString(),
      if (query != null) 'query': query,
      'detailed': 'true',
      'keepRoomWithArtwork': 'true'
    },
  );
  logger.d(uri);
  try {
    final response = await http.get(uri).timeout(
      Duration(seconds: 5),
      onTimeout: () {
        // Handle timeout
        return http.Response('Request timed out', 408); // 408 is the HTTP status code for Request Timeout
      },
    );

    if (response.statusCode == 200) {
      // Si la requête a réussi, décodez le corps de la réponse
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((item) => RoomListItem.fromJson(item))
                 .toList()
                 .cast<RoomListItem>();
    } else {
      throw FetchRoomsException('Erreur de requête: ${response.statusCode}');
    }
  } catch (e, stackTrace) {
    logger.e(e);
    logger.d(stackTrace);
    rethrow;
  }
}