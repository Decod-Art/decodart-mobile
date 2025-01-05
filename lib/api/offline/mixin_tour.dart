import 'package:decodart/api/tour.dart' as api_tour;
import 'package:decodart/model/tour.dart' show TourListItem, Tour;
import 'package:decodart/util/logger.dart';

mixin TourOffline {

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
        await Future.delayed(Duration(milliseconds: 50));
      }
      return tours;
    } catch (e) {
      logger.e('Erreur lors du chargement des tours et expositions: $e');
      rethrow;
    }
  }
  Future<Map<int, Tour>> loadTourDetails(List<TourListItem> tours, {int pause=25}) async {
    Map<int, Tour> tourMap = {};
    try {
      for (final tour in tours) {
        tourMap[tour.uid!] = await api_tour.fetchTourById(tour.uid!, canUseOffline: false);
        await Future.delayed(Duration(milliseconds: pause));
      }
    } catch (e) {
      logger.e('Erreur lors du chargement du détail des tours/expositions : $e');
    }
    return tourMap;
  }
}