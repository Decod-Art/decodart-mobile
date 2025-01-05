import 'dart:convert' show jsonDecode;
import 'package:decodart/api/offline/offline.dart' show OfflineManager;
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

/// Fetches rooms with the specified parameters.
///
/// This method sends a GET request to the server to retrieve a list of rooms
/// based on the provided parameters.
///
/// [limit] specifies the maximum number of rooms to retrieve (default is 5).
/// [offset] specifies the offset for pagination (default is 0).
/// [query] is a search string to filter the rooms.
/// [museum] is the foreign key of the museum to filter the rooms.
/// [canUseOffline] permits to force the API to collect data online (e.g. when downloading data for the offline mode), (default true)
///
/// Returns a list of [RoomListItem] objects if the request is successful.
///
/// Throws a [FetchRoomsException] if there is an error during the request or if the server returns an error.

Future<List<RoomListItem>> fetchRooms({
    int limit=5,
    int offset=0,
    String? query,
    required MuseumForeignKey museum,
    bool canUseOffline=true
  }) async {
    if (OfflineManager.useOffline&&canUseOffline) {
      OfflineManager offline = OfflineManager();
      return offline.fetchRooms(limit: limit, offset: offset, query: query, museum: museum);
    }
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
        Duration(seconds: 5), onTimeout: () => http.Response('Request timed out', 408)
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'].map((item) => RoomListItem.fromJson(item))
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