import 'dart:convert' show jsonDecode;
import 'package:decodart/api/offline.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' show MediaType; // MIME

import 'package:decodart/model/artwork.dart' show ArtworkListItem, Artwork;
import 'package:decodart/util/online.dart' show hostName;
import 'package:decodart/util/logger.dart' show logger;

/// The artwork API provides these three methods:
/// fetchAllArtworks
/// fetchArtworkById
/// fetchArtworkByImage

/// FetchArtworkException is raised for any failed API call and Json format error
class FetchArtworkException implements Exception {
  final String message;
  FetchArtworkException(this.message);

  @override
  String toString() => 'FetchArtworkException: $message';
}

/// Retrieves all artworks with the specified parameters.
///
/// [limit] specifies the maximum number of artworks to retrieve.
/// [offset] specifies the offset for pagination.
/// [query] is a search string to filter the artworks by keyword (title, artist name)
/// [museumId] is the identifier of the museum to filter the artworks.
/// [roomId] is the room ID of the museum to filter the artworks.
/// [canUseOffline] permits to force the API to collect data online (e.g. when downloading data for the offline mode), (default true)
///
/// Returns a list of artwork items.
/// Throws a [FetchArtworkException] if the API fails or returned an ill-formed json
Future<List<ArtworkListItem>> fetchAllArtworks({
    int limit=10,
    int offset=0,
    String? query,
    int? museumId,
    int? roomId, 
    bool canUseOffline=true}) async {
      if (OfflineManager.useOffline&&canUseOffline) {
        OfflineManager offline = OfflineManager();
        return offline.fetchAllArtworks(limit: limit, offset: offset, query: query);
      }
      try {
        final Uri uri = Uri.parse('$hostName/artworks').replace(
          queryParameters: {
            'limit': '$limit',
            'offset': '$offset',
            if (query != null) 'query': query,
            if (museumId != null) 'museumId': '$museumId',
            if (roomId != null) 'roomId': roomId.toString()
          },
        );
        logger.d(uri);
        final response = await http.get(uri).timeout(
          Duration(seconds: 5), onTimeout: () => http.Response('Request timed out', 408),
        );
        if (response.statusCode == 200) {
          // Note that ill-formatted json should produce an exception
          final results = jsonDecode(response.body);
          return results['data'].map((item) => ArtworkListItem.fromJson(item))
                                .toList()
                                .cast<ArtworkListItem>();
        } else {
          throw FetchArtworkException('Error from server: ${response.statusCode}');
        }
      } catch (e, stackTrace) {
        logger.e(e);
        logger.d(stackTrace);
        rethrow;
      }
}

/// Fetches an artwork by its unique identifier.
///
/// This method sends a GET request to the server to retrieve the details
/// of an artwork specified by its unique identifier [uid].
///
/// [uid] is the unique identifier of the artwork to retrieve.
/// [canUseOffline] permits to force the API to collect data online (e.g. when downloading data for the offline mode), (default true)
///
/// Returns an [Artwork] object if the request is successful.
///
/// Throws a [FetchArtworkException] if the artwork is not found or if there is an error during the request.
Future<Artwork> fetchArtworkById(int uid, {canUseOffline=true}) async {
  if (OfflineManager.useOffline&&canUseOffline) {
    OfflineManager offline = OfflineManager();
    return offline.fetchArtworkById(uid);
  }
  try {
    final uri = Uri.parse('$hostName/artworks/$uid');
    logger.d(uri);
    final response = await http.get(uri).timeout(
      Duration(seconds: 5), onTimeout: () => http.Response('Request timed out', 408)
    );
    if (response.statusCode == 200) {
      return Artwork.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw FetchArtworkException('Artwork not found');
    }
  } catch (e, stackTrace) {
    logger.e('$e, uid: $uid');
    logger.d(stackTrace);
    rethrow;
  }
}

/// Fetches artworks by an image.
///
/// This method sends a POST request to the server with an image file to search for artworks
/// that match the image. The image is specified by its file path [imagePath].
///
/// [imagePath] is the file path of the image to use for the search. The image must be in JPEG or PNG format.
///
/// Returns a list of [ArtworkListItem] objects if the request is successful.
///
/// Throws a [FetchArtworkException] if the image has an incorrect MIME type, if there is an error during the request,
/// or if the server returns an error.
Future<List<ArtworkListItem>> fetchArtworkByImage(String imagePath) async {
  try {
    final url = Uri.parse('$hostName/artworks/search');
    logger.d(url);
    String mimeType;// = 'application/octet-stream';
    if (imagePath.endsWith('.jpg') || imagePath.endsWith('.jpeg')) {
      mimeType = 'image/jpeg';
    } else if (imagePath.endsWith('.png')) {
      mimeType = 'image/png';
    } else {
      throw FetchArtworkException("Incorrect MIME TYPE for image...");
    }
    final request = http.MultipartRequest('POST', url)
                       ..files.add(await http.MultipartFile.fromPath(
                          'picture',
                          imagePath,
                          contentType: MediaType.parse(mimeType)
                        )
                      );
    // Larger timeout duration because of image transfer
    final response = await request.send().timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      List<dynamic> results = jsonDecode(await response.stream.bytesToString())['data'];
      return results.map((item) => ArtworkListItem.fromJson(item)).toList();
    } {
      throw FetchArtworkException('Error from server: ${response.statusCode}');
    }
  } catch(e, stackTrace){
    logger.e('$e, image from: $imagePath');
    logger.d(stackTrace);
    rethrow;
  }
}