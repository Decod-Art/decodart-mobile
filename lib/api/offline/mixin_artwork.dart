import 'package:decodart/api/artwork.dart' as api_art;
import 'package:decodart/model/artwork.dart' show ArtworkListItem, Artwork;
import 'package:decodart/util/logger.dart';

mixin ArtworkOffline {
  Future<List<ArtworkListItem>> loadArtworks(int museumId, int limit, {int pause=25}) async {
    List<ArtworkListItem> artworks = [];
    int lastBatch = limit;
    try {
      while (lastBatch == limit) {
        final offset = artworks.length;
        final newArtworks = await api_art.fetchAllArtworks(limit: limit, offset: offset, canUseOffline: false, museumId: museumId);
        artworks.addAll(newArtworks);
        lastBatch = newArtworks.length;
        await Future.delayed(Duration(milliseconds: pause));
      }
      return artworks;
    } catch (e) {
      logger.e('Erreur lors du chargement des œuvres d\'art: $e');
      rethrow;
    }
  }

  Future<Map<int, Artwork>> loadArtworkDetails(List<ArtworkListItem> artworks, {int pause=25}) async {
    Map<int, Artwork> artworkMap = {};
    try {
      for (final artwork in artworks) {
        artworkMap[artwork.uid!] = await api_art.fetchArtworkById(artwork.uid!, canUseOffline: false);
        await Future.delayed(Duration(milliseconds: pause));
      }
    } catch (e) {
      logger.e('Erreur lors du chargement du détail des œuvres d\'art: $e');
    }
    return artworkMap;
  }
}