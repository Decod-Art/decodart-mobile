
import 'dart:math' show min;
import 'dart:typed_data' show Uint8List;

import 'package:decodart/data/api/artwork.dart' as api_art;
import 'package:decodart/data/api/decod.dart' as api_decod;
import 'package:decodart/data/api/data.dart' as api_image;
import 'package:decodart/data/api/museum.dart' as api_museum;
import 'package:decodart/data/api/offline/mixin_pdf.dart' show PDFOffline;
import 'package:decodart/data/api/room.dart' as api_room;
import 'package:decodart/data/api/offline/mixin_artwork.dart' show ArtworkOffline;
import 'package:decodart/data/api/offline/mixin_image.dart' show ImageOffline;
import 'package:decodart/data/api/offline/mixin_question.dart' show QuestionOffline;
import 'package:decodart/data/api/offline/mixin_room.dart';
import 'package:decodart/data/api/offline/mixin_tour.dart' show TourOffline;
import 'package:decodart/data/api/tour.dart' as api_tour;
import 'package:decodart/data/model/artwork.dart' show Artwork, ArtworkListItem;
import 'package:decodart/data/model/decod.dart' show DecodQuestion;
import 'package:decodart/data/model/museum.dart' show Museum, MuseumForeignKey, MuseumListItem;
import 'package:decodart/data/model/room.dart' show RoomListItem;
import 'package:decodart/data/model/tour.dart' show TourListItem, Tour;
import 'package:decodart/util/logger.dart' show logger;
import 'package:mutex/mutex.dart' show Mutex;

/// OfflineManager class to handle offline data.
/// Uses several mixins to add specific functionalities.
class OfflineManager with ArtworkOffline, TourOffline, QuestionOffline, ImageOffline, RoomOffline, PDFOffline {
  static bool appIsOffline=false;
  static const int pauseBetweenQueries = 15;
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

  List<RoomListItem> _roomList = [];
  Map<int, List<ArtworkListItem>> _artworkPerRoom = {};
  
  final Map<String, Uint8List> _data = {};

  final int limit = 25;

  late int estimatedNumberOfItems;

  bool get isAvailable => museum !=null;

  void clearAll() {
    museum = null;
    _artworkList.clear();
    _data.clear();
    _artworkMap.clear();
    _tourList.clear();
    _exhibitionList.clear();
    _tourMap.clear();
    _questions.clear();
    _roomList.clear();
    _artworkPerRoom.clear();
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

      _artworkList = await loadArtworks(uid, limit, pause: pauseBetweenQueries);
      _artworkMap = await loadArtworkDetails(_artworkList, pause: pauseBetweenQueries);
      
      _tourList = await loadTours(uid, false, limit, pause: pauseBetweenQueries);
      _exhibitionList = await loadTours(uid, true, limit, pause: pauseBetweenQueries);
      _tourMap.addAll(await loadTourDetails(_tourList, pause: pauseBetweenQueries));
      _tourMap.addAll(await loadTourDetails(_exhibitionList, pause: pauseBetweenQueries));

      _questions = await loadQuestions(_artworkMap, pause: pauseBetweenQueries);

      _roomList = await loadRooms(museum!, limit, pause: pauseBetweenQueries);
      _artworkPerRoom = indexArtworkPerRoom(_artworkMap);


      await loadImageFromArtworks(_artworkMap, _data, pause: pauseBetweenQueries);
      await loadImageFromTours(_tourMap, _data, pause: pauseBetweenQueries);
      await loadImageFromQuestions(_questions, _data, pause: pauseBetweenQueries);
      await loadImageFromMuseum(museum!, _data, pause: pauseBetweenQueries);
      await loadMapFromMuseum(museum!, _data);
    } catch (e) {
      logger.e("Erreur lors du téléchargement du musée pour usage hors ligne: $e");
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
  int get nbElements => _artworkList.length ~/ limit + _data.length + _artworkMap.length; // + other lists and Map

  // Offline API

  Uint8List fetchData(String path) {
    final data = _data[path];
    if (data == null) throw api_image.FetchDataException("Image $path not available offline");
    return data;
  }

  List<ArtworkListItem> fetchAllArtworks({
    int limit=10,
    int offset=0,
    String? query,
    int? roomId
    }) {
      late final List<ArtworkListItem> artworkList;
      if (roomId != null) {
        if (!_artworkPerRoom.containsKey(roomId)) throw api_art.FetchArtworkException("Room $roomId does not contain any artwork...");
        artworkList = _artworkPerRoom[roomId]!;
      } else {
        artworkList = _artworkList;
      }
      
      final filteredList = artworkList.where((artwork) {
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

  List<MuseumListItem> fetchAllMuseums({
    int limit=10,
    int offset=0,
    String? query
    }) {
      final initialList = [museum!];
      final filteredList = initialList.where((t) {
      final matchesQuery = query == null || t.name.toLowerCase().contains(query.toLowerCase().trim());
      return matchesQuery; 
    }).toList();

    // Appliquer la pagination
    final paginatedList = filteredList.skip(offset).take(limit).toList();

    return paginatedList;
  }

  List<RoomListItem> fetchRooms({int limit=10, int offset=0, String? query, required MuseumForeignKey museum}) {
    if (this.museum!.uid != museum.uid) throw api_room.FetchRoomsException("Room for museum ${museum.name} not available offline");
    final filteredList = _roomList.where((artwork) {
      // final matchesMuseum = museumId == null || artwork.room.museum.uid == museumId;
      // final matchesRoom = roomId == null || artwork.room.uid == roomId;
      final matchesQuery = query == null || artwork.name.toLowerCase().contains(query.toLowerCase().trim());
      return matchesQuery; //matchesMuseum && matchesRoom && 
    }).toList();

    // Appliquer la pagination
    final paginatedList = filteredList.skip(offset).take(limit).toList();

    return paginatedList;
  }
}
