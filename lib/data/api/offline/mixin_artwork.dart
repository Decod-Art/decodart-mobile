import 'package:decodart/data/api/artwork.dart' as api_art;
import 'package:decodart/data/model/artwork.dart' show ArtworkListItem, Artwork;
import 'package:decodart/util/logger.dart';

/// Mixin pour gérer le chargement des œuvres d'art en mode hors ligne.
mixin ArtworkOffline {
  /// Loads a list of artworks for a given museum.
  ///
  /// This method retrieves artworks in batches of [limit] until all artworks
  /// from the museum are fetched.
  ///
  /// [museumId] The identifier of the museum for which artworks are being loaded.
  /// [limit] The maximum number of artworks to retrieve per batch.
  /// [pause] The duration of the pause between requests in milliseconds (default is 25 ms).
  ///
  /// Returns a list of [ArtworkListItem] objects.
  Future<List<ArtworkListItem>> loadArtworks(int museumId, int limit, {int pause=25}) async {
    List<ArtworkListItem> artworks = [];
    int lastBatch = limit;
    try {
      while (lastBatch == limit) {
        final offset = artworks.length;
        final newArtworks = await api_art.fetchAllArtworks(limit: limit, offset: offset, canUseOffline: false, museumId: museumId);
        artworks.addAll(newArtworks);
        lastBatch = newArtworks.length;
        // Pause to avoid saturating the API
        await Future.delayed(Duration(milliseconds: pause));
      }
      return artworks;
    } catch (e) {
      logger.e('Erreur lors du chargement des œuvres d\'art: $e');
      rethrow;
    }
  }

  /// Loads the details of artworks from a list of artwork items.
  ///
  /// This method retrieves the details of each artwork individually.
  ///
  /// [artworks] The list of artwork items for which to load the details.
  /// [pause] The duration of the pause between requests in milliseconds (default is 25 ms).
  ///
  /// Returns a map where the keys are the identifiers of the artworks, and the values are [Artwork] objects.
  Future<Map<int, Artwork>> loadArtworkDetails(List<ArtworkListItem> artworks, {int pause=25}) async {
    Map<int, Artwork> artworkMap = {};
    try {
      for (final artwork in artworks) {
        artworkMap[artwork.uid!] = await api_art.fetchArtworkById(artwork.uid!, canUseOffline: false);
        await Future.delayed(Duration(milliseconds: pause));
      }
    } catch (e) {
      logger.e('Erreur lors du chargement du détail des œuvres d\'art: $e');
      rethrow;
    }
    return artworkMap;
  }
}