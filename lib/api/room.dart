import 'dart:convert';
import 'package:decodart/model/museum.dart' show MuseumForeignKey;
import 'package:http/http.dart' as http;

import 'package:decodart/api/util.dart' show hostName;
import 'package:decodart/model/room.dart' show RoomListItem;

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

  final url = Uri.parse('$hostName/rooms').replace(
    queryParameters: {
      'limit': limit.toString(),
      'offset': offset.toString(),
      'museumId': museum.uid!.toString(),
      if (query != null) 'query': query,
      'detailed': 'true',
      'keepRoomWithArtwork': 'true'
    },
  );
  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Si la requête a réussi, décodez le corps de la réponse
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((item) => RoomListItem.fromJson(item))
                 .toList()
                 .cast<RoomListItem>();
    } else {
      print('Erreur de requête: ${response.statusCode}');
      throw FetchRoomsException('Erreur de requête: ${response.statusCode}');
    }
  } catch (e) {
    print('Erreur: $e');
    throw FetchRoomsException('Erreur: $e');
  }
}