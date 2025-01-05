import 'package:decodart/model/artwork.dart' show ArtworkListItem, Artwork;
import 'package:decodart/model/museum.dart' show Museum;
import 'package:decodart/model/room.dart' show RoomListItem;
import 'package:decodart/api/room.dart' as api_room;
import 'package:decodart/util/logger.dart' show logger;

mixin RoomOffline {
  Future<List<RoomListItem>> loadRooms(Museum museum, int limit, {int pause=25}) async {
    List<RoomListItem> rooms = [];
    int lastBatch = limit;
    try {
      while (lastBatch == limit) {
        final offset = rooms.length;
        final newRooms = await api_room.fetchRooms(
          limit: limit,
          offset: offset,
          canUseOffline: false,
          museum: museum
        );
        rooms.addAll(newRooms);
        lastBatch = newRooms.length;
        await Future.delayed(Duration(milliseconds: pause));
      }
    } catch (e) {
      logger.e("Erreur lors du chargement des pièces: $e");
      rethrow;
    }
    return rooms;
  }

  Map<int, List<ArtworkListItem>> indexArtworkPerRoom(Map<int, Artwork> artworks) {
    Map<int, List<ArtworkListItem>> rooms = {};
    for(final entry in artworks.entries) {
      final artwork = entry.value;
      final artworkListItem = artwork.listItem;
      final items = rooms.putIfAbsent(artwork.room!.uid!, () => []);
      items.add(artworkListItem);
    }
    return rooms;
  }
}