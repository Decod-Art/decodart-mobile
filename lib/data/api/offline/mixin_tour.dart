import 'package:decodart/data/api/tour.dart' as api_tour;
import 'package:decodart/data/model/tour.dart' show TourListItem, Tour;
import 'package:decodart/util/logger.dart';

/// Mixin to handle the offline loading of tours and exhibitions.
mixin TourOffline {
  /// Loads tours and exhibitions associated with a museum.
  ///
  /// This method retrieves tours in batches of [limit] until all tours from the museum are fetched.
  ///
  /// [museumId] The identifier of the museum for which tours are being loaded.
  /// [isExhibition] A boolean indicating whether to load exhibitions.
  /// [limit] The maximum number of tours to retrieve per batch.
  /// [pause] The duration of the pause between requests in milliseconds (default is 25 ms).
  ///
  /// Returns a list of [TourListItem] objects.
  Future<List<TourListItem>> loadTours(int museumId, bool isExhibition, int limit, {int pause=25}) async {
    List<TourListItem> tours = [];
    int lastBatch = limit;
    try {
      // Download list of tours
      while (lastBatch == limit) {
        final offset = tours.length;
        final newTours = await api_tour.fetchAllTours(limit: limit, offset: offset, canUseOffline: false);
        tours.addAll(newTours);
        lastBatch = newTours.length;
        await Future.delayed(Duration(milliseconds: pause));
      }
      return tours;
    } catch (e) {
      logger.e('Erreur lors du chargement des tours et expositions: $e');
      rethrow;
    }
  }

  /// Loads the details of tours and exhibitions.
  ///
  /// This method iterates through the list of tour items and fetches the details for each tour.
  ///
  /// [tours] A list of [TourListItem] objects for which to load details.
  /// [pause] The duration of the pause between requests in milliseconds (default is 25 ms).
  ///
  /// Returns a map where the keys are tour IDs and the values are [Tour] objects.
  Future<Map<int, Tour>> loadTourDetails(List<TourListItem> tours, {int pause=25}) async {
    Map<int, Tour> tourMap = {};
    try {
      for (final tour in tours) {
        tourMap[tour.uid!] = await api_tour.fetchTourById(tour.uid!, canUseOffline: false);
        await Future.delayed(Duration(milliseconds: pause));
      }
    } catch (e) {
      logger.e('Erreur lors du chargement du détail des tours/expositions : $e');
      rethrow;
    }
    return tourMap;
  }
}