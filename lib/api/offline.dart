
import 'dart:typed_data';

import 'package:decodart/api/artwork.dart' as api_art;
import 'package:decodart/api/decod.dart' as api_decod;
import 'package:decodart/api/image.dart' as api_image;
import 'package:decodart/api/museum.dart' as api_museum;
import 'package:decodart/api/tour.dart' as api_tour;
import 'package:decodart/model/artwork.dart' show Artwork, ArtworkListItem;
import 'package:decodart/model/decod.dart' show DecodQuestion;
import 'package:decodart/model/museum.dart' show Museum;
import 'package:decodart/model/tour.dart' show TourListItem, Tour;
import 'package:decodart/util/logger.dart' show logger;
import 'package:mutex/mutex.dart' show Mutex;

class OfflineManager {
  static bool useOffline=false;
  // Managing the fact that OfflineManager is a Singleton
  static final OfflineManager _instance = OfflineManager._internal();
  OfflineManager._internal();
  factory OfflineManager() {
    return _instance;
  }
  
  Mutex m = Mutex();

  Museum? museum;

  bool _loading = false;
  bool _failed = false;
  final List<ArtworkListItem> _artworkList = [];
  final Map<int, Artwork> _artworkMap = {};

  // The id of the question are those of the related artworks
  final Map<int, List<DecodQuestion>> _questions = {};

  final List<TourListItem> _tourList = [];
  final Map<int, Tour> _tourMap = {};

  final List<TourListItem> _exhibitionList = [];
  final Map<int, Tour> _exhibitionMap = {};
  
  final Map<String, Uint8List> _images = {};

  final int limit = 25;

  late int estimatedNumberOfItems;

  void clearAll() {
    museum = null;
    _artworkList.clear();
    _images.clear();
    _artworkMap.clear();
  }

  Future<void> downloadMuseum(int uid) async {
    m.acquire();
    _loading = true;
    _failed = false;
    try {
      clearAll();
      estimatedNumberOfItems = 3*500;

      museum = await api_museum.fetchMuseumById(uid, canUseOffline: false);
      await loadArtworks(uid);
      await loadTours(uid, false, _tourList, _tourMap);
      await loadTours(uid, true, _exhibitionList, _exhibitionMap);
      await loadQuestions();
      await loadImages();
    } finally {
      _loading = false;
      m.release();
    }
  }

  bool isAvailableOffline(int uid) => !_failed&&!_loading&&hasData&&museum?.uid==uid;
  bool isDownloading(int uid) => _loading&&museum?.uid==uid;
  double get percentOfLoading => nbElements / estimatedNumberOfItems;
  bool get loading => _loading;
  bool get hasData => _artworkList.isNotEmpty;
  int get nbElements => _artworkList.length + _images.length + _artworkMap.length; // + other lists and Map


  Future<void> loadArtworks(int museumId) async {
    int lastBatch = limit;
    try {
      // Download list of artworks
      while (lastBatch == limit) {
        final offset = _artworkList.length;
        final artworks = await api_art.fetchAllArtworks(limit: limit, offset: offset, canUseOffline: false);
        _artworkList.addAll(artworks);
        lastBatch = artworks.length;
        await Future.delayed(Duration(milliseconds: 50));
      }

      // Download the details of each artwork
      for (final artwork in _artworkList) {
        _artworkMap[artwork.uid!] = await api_art.fetchArtworkById(artwork.uid!, canUseOffline: false);
        await Future.delayed(Duration(milliseconds: 10));
      }
    } catch (e) {
      _failed = true;
      logger.e('Erreur lors du chargement des œuvres d\'art: $e');
      rethrow;
    }
  }

  Future<void> loadTours(
    int museumId,
    bool isExhibition,
    List<TourListItem> tours,
    Map<int, Tour>tourMap) async {
      int lastBatch = limit;
      try {
        // Download list of tours
        while (lastBatch == limit) {
          final offset = _tourList.length;
          final tours = await api_tour.fetchAllTours(limit: limit, offset: offset, canUseOffline: false);
          _tourList.addAll(tours);
          lastBatch = tours.length;
          await Future.delayed(Duration(milliseconds: 50));
        }

        // Download the details of each tours
        for (final tour in _tourList) {
          _tourMap[tour.uid!] = await api_tour.fetchTourById(tour.uid!, canUseOffline: false);
          await Future.delayed(Duration(milliseconds: 10));
        }
      } catch (e) {
        _failed = true;
        logger.e('Erreur lors du chargement des tours et expositions: $e');
        rethrow;
      }
  }

  Future<void> loadQuestions() async {
    _artworkMap.forEach(((key, value) async {
      if (value.hasDecodQuestion) {
        final questions = await api_decod.fetchDecodQuestions(artworkId: value.uid!);
        _questions[value.uid!] = questions;
      }
    }));
  }

  Future<void> loadImages() async {
    _artworkMap.forEach((_, artwork) async {
      for (var image in artwork.images) {
        final imagePath = image.path;
        final data = await image.downloadImageData(keep: false);
        _images[imagePath] = data;
        await Future.delayed(Duration(milliseconds: 10));
      }
    });

    _questions.forEach((k, questions) async {
      for (final q in questions) {
        final imagePath = q.image.path;
        final data = await q.image.downloadImageData(keep: false);
        _images[imagePath] = data;
        for(final a in q.answers) {
          if (a.image != null) {
            final imagePath = a.image!.path;
            final data = await a.image!.downloadImageData(keep: false);
            _images[imagePath] = data;
          }
        }
      }
    });
  }

  Uint8List fetchImageData(String path) {
    final data = _images[path];
    if (data == null) {
      throw api_image.FetchImageException("Image $path not available offline");
    }
    return data;
  }

  List<ArtworkListItem> fetchAllArtworks({
    int limit=10,
    int offset=0,
    String? query
    }) {
      final filteredList = _artworkList.where((artwork) {
      // final matchesMuseum = museumId == null || artwork.room.museum.uid == museumId;
      // final matchesRoom = roomId == null || artwork.room.uid == roomId;
      final matchesQuery = query == null ||
          artwork.title.toLowerCase().contains(query.toLowerCase().trim()) ||
          artwork.artist.name.toLowerCase().contains(query.toLowerCase().trim());
      return matchesQuery; //matchesMuseum && matchesRoom && 
    }).toList();

    // Appliquer la pagination
    final paginatedList = filteredList.skip(offset).take(limit).toList();

    return paginatedList;
  }

  List<TourListItem> fetchAllTours({
    int limit=10,
    int offset=0,
    bool isExhibition=false,
    String? query
    }) {
      final initialList = isExhibition ? _exhibitionList : _tourList;
      final filteredList = initialList.where((t) {
      final matchesQuery = query == null ||
          t.name.toLowerCase().contains(query.toLowerCase().trim()) ||
          t.subtitle.toLowerCase().contains(query.toLowerCase().trim());
      return matchesQuery; 
    }).toList();

    // Appliquer la pagination
    final paginatedList = filteredList.skip(offset).take(limit).toList();

    return paginatedList;
  }

  Artwork fetchArtworkById(int uid) {
    final artwork = _artworkMap[uid];
    if (artwork == null) {
      throw api_art.FetchArtworkException("Artwork $uid not available offline");
    }
    return artwork;
  }

  Tour fetchTourById(int uid) {
    final tour = _tourMap[uid];
    if (tour == null) {
      throw api_tour.FetchTourException("Tour $uid not available offline");
    }
    return tour;
  }

  List<DecodQuestion> fetchDecodQuestions(int uid) {
    final q = _questions[uid];
    if (q == null) {
      throw api_decod.FetchDecodQuestionException("Question $uid not available offline");
    }
    return q;
  }

  Museum fetchMuseumById(int uid) {
    if (museum?.uid == uid) return museum!;
    throw api_museum.FetchMuseumException("No museum $uid available offline");
  }
}
