
import 'dart:math' show min;
import 'dart:typed_data' show Uint8List;

import 'package:decodart/api/artwork.dart' as api_art;
import 'package:decodart/api/decod.dart' as api_decod;
import 'package:decodart/api/image.dart' as api_image;
import 'package:decodart/api/museum.dart' as api_museum;
import 'package:decodart/api/offline/mixin_artwork.dart' show ArtworkOffline;
import 'package:decodart/api/offline/mixin_image.dart' show ImageOffline;
import 'package:decodart/api/offline/mixin_question.dart' show QuestionOffline;
import 'package:decodart/api/offline/mixin_tour.dart' show TourOffline;
import 'package:decodart/api/tour.dart' as api_tour;
import 'package:decodart/model/artwork.dart' show Artwork, ArtworkListItem;
import 'package:decodart/model/decod.dart' show DecodQuestion;
import 'package:decodart/model/museum.dart' show Museum;
import 'package:decodart/model/tour.dart' show TourListItem, Tour;
import 'package:decodart/util/logger.dart' show logger;
import 'package:mutex/mutex.dart' show Mutex;

class OfflineManager with ArtworkOffline, TourOffline, QuestionOffline, ImageOffline {
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
  List<ArtworkListItem> _artworkList = [];
  Map<int, Artwork> _artworkMap = {};

  // The id of the question are those of the related artworks
  Map<int, List<DecodQuestion>> _questions = {};

  List<TourListItem> _tourList = [];
  List<TourListItem> _exhibitionList = [];
  final Map<int, Tour> _tourMap = {};
  
  final Map<String, Uint8List> _images = {};

  final int limit = 25;

  late int estimatedNumberOfItems;

  void clearAll() {
    museum = null;
    _artworkList.clear();
    _images.clear();
    _artworkMap.clear();
    _tourList.clear();
    _exhibitionList.clear();
    _tourMap.clear();
    _questions.clear();
  }

  Future<void> downloadMuseum(int uid) async {
    m.acquire();
    _loading = true;
    _failed = false;
    try {
      clearAll();
      final nbArtworks = await api_art.countAllArtworks(uid);
      estimatedNumberOfItems = 2 * nbArtworks + nbArtworks ~/ limit;

      museum = await api_museum.fetchMuseumById(uid, canUseOffline: false);

      _artworkList = await loadArtworks(uid, limit);
      _artworkMap = await loadArtworkDetails(_artworkList);
      
      _tourList = await loadTours(uid, false, limit);
      _exhibitionList = await loadTours(uid, true, limit);
      _tourMap.addAll(await loadTourDetails(_tourList));
      _tourMap.addAll(await loadTourDetails(_exhibitionList));

      _questions = await loadQuestions(_artworkMap);

      await loadImageFromArtworks(_artworkMap, _images);
      await loadImageFromTours(_tourMap, _images);
      await loadImageFromQuestions(_questions, _images);
      await loadImageFromMuseum(museum!, _images);
    } catch (e) {
      logger.e(e);
      _failed = true;
    } finally {
      _loading = false;
      m.release();
    }
  }

  bool isAvailableOffline(int uid) => !_failed&&!_loading&&hasData&&museum?.uid==uid;
  bool isDownloading(int uid) => _loading&&museum?.uid==uid;
  double get percentOfLoading => min(nbElements / estimatedNumberOfItems, 1.0);
  bool get loading => _loading;
  bool get hasData => _artworkList.isNotEmpty;
  // ~/ refers to the integer division
  int get nbElements => _artworkList.length ~/ limit + _images.length + _artworkMap.length; // + other lists and Map

  // Offline API

  Uint8List fetchImageData(String path) {
    final data = _images[path];
    if (data == null) throw api_image.FetchImageException("Image $path not available offline");
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
    if (artwork == null) throw api_art.FetchArtworkException("Artwork $uid not available offline");
    return artwork;
  }

  Tour fetchTourById(int uid) {
    final tour = _tourMap[uid];
    if (tour == null) throw api_tour.FetchTourException("Tour $uid not available offline");
    return tour;
  }

  List<DecodQuestion> fetchDecodQuestions(int uid) {
    final q = _questions[uid];
    if (q == null) throw api_decod.FetchDecodQuestionException("Question $uid not available offline");
    return q;
  }

  Museum fetchMuseumById(int uid) {
    if (museum?.uid == uid) return museum!;
    throw api_museum.FetchMuseumException("No museum $uid available offline");
  }
}
