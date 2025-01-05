import 'package:decodart/model/artwork.dart' show ArtworkListItem, Artwork;
import 'package:decodart/model/museum.dart' show Museum;
import 'package:decodart/model/room.dart' show RoomListItem;
import 'package:decodart/api/room.dart' as api_room;
import 'package:decodart/util/logger.dart' show logger;

/// Mixin to handle the offline loading of rooms and indexing artworks per room.
mixin RoomOffline {
  /// Loads rooms associated with a museum.
  ///
  /// This method retrieves rooms in batches of [limit] until all rooms from the museum are fetched.
  ///
  /// [museum] The [Museum] object for which rooms are being loaded.
  /// [limit] The maximum number of rooms to retrieve per batch.
  /// [pause] The duration of the pause between requests in milliseconds (default is 25 ms).
  ///
  /// Returns a list of [RoomListItem] objects.
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

  /// Indexes artworks per room.
  ///
  /// This method iterates through the artworks and groups them by their associated room.
  ///
  /// [artworks] A map where the keys are artwork IDs and the values are [Artwork] objects.
  ///
  /// Returns a map where the keys are room IDs and the values are lists of [ArtworkListItem] objects.
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