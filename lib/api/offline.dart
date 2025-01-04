
import 'dart:typed_data';

import 'package:decodart/api/artwork.dart' as apiArt;
import 'package:decodart/api/image.dart' as apiImage;
import 'package:decodart/model/artwork.dart';
import 'package:decodart/util/logger.dart';
import 'package:mutex/mutex.dart';

class OfflineManager {
  static bool useOffline=true;
  // Managing the fact that OfflineManager is a Singleton
  static final OfflineManager _instance = OfflineManager._internal();
  OfflineManager._internal();
  factory OfflineManager() {
    return _instance;
  }
  
  Mutex m = Mutex();

  int? museumId;

  bool _loading = false;
  bool _failed = false;
  final List<ArtworkListItem> _artworkList = [];
  final Map<String, Uint8List> _images = {};
  final int limit = 25;

  late int estimatedNumberOfItems;

  void clearAll() {
    _artworkList.clear();
    _images.clear();
  }

  Future<void> downloadMuseum(int uid) async {
    m.acquire();
    _loading = true;
    _failed = false;
    museumId = uid;
    try {
      clearAll();
      estimatedNumberOfItems = 2*500;
      await loadArtworks(uid);
      await loadImages();
    } finally {
      _loading = false;
      m.release();
    }
  }

  bool isAvailableOffline(int uid) => !_failed&&!_loading&&hasData&&museumId==uid;
  bool isDownloading(int uid) => _loading&&museumId==uid;
  double get percentOfLoading => nbElements / estimatedNumberOfItems;
  bool get loading => _loading;
  bool get hasData => _artworkList.isNotEmpty;
  int get nbElements => _artworkList.length + _images.length; // + other lists and Map


  Future<void> loadArtworks(int museumId) async {
    int lastBatch = limit;
    try {
      while (lastBatch == limit) {
        final offset = _artworkList.length;
        final artworks = await apiArt.fetchAllArtworks(limit: limit, offset: offset, canUseOffline: false);
        _artworkList.addAll(artworks);
        lastBatch = artworks.length;
        await Future.delayed(Duration(milliseconds: 50));
      }
    } catch (e) {
      _failed = true;
      logger.e('Erreur lors du chargement des œuvres d\'art: $e');
      rethrow;
    }
  }

  Future<void> loadImages() async {
    for (final artwork in _artworkList) {
      final imagePath = artwork.image.path;
      final data = await artwork.image.downloadImageData();
      _images[imagePath] = data;
      await Future.delayed(Duration(milliseconds: 10));
    }
  }

  Uint8List fetchImageData(String path) {
    final data = _images[path];
    if (data == null) {
      throw apiImage.FetchImageException("Image not available offline");
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
}
