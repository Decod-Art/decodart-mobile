import 'dart:convert' show jsonDecode;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' show MediaType; // MIME

import 'package:decodart/model/artwork.dart' show ArtworkListItem, Artwork;
import 'package:decodart/api/util.dart' show hostName;
import 'package:decodart/util/logger.dart' show logger;

// fetchAllArtworks
// fetchArtworkById
// fetchArtworkByImage

class FetchArtworkException implements Exception {
  final String message;
  FetchArtworkException(this.message);

  @override
  String toString() => 'FetchArtworkException: $message';
}

Future<List<ArtworkListItem>> fetchAllArtworks({
    int limit=10,
    int offset=0,
    String? query,
    int? museumId,
    String? room}) async {

  try {
    final Uri uri = Uri.parse('$hostName/artworks').replace(
      queryParameters: {
        'limit': '$limit',
        'offset': '$offset',
        if (query != null) 'query': query,
        if (museumId != null) 'museumId': '$museumId',
        if (room != null) 'room': room
      },
    );
    logger.d(uri);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final results = jsonDecode(response.body);
      List<ArtworkListItem> listItems = results['data'].map((item) => ArtworkListItem.fromJson(item))
                                                       .toList()
                                                       .cast<ArtworkListItem>();
      return listItems;
    } else {
      logger.e('Error from server: ${response.statusCode}');
    }
  } catch (e, stackTrace) {
    logger.e(e);
    logger.d(stackTrace);
  }
  return [];
}

Future<Artwork> fetchArtworkById(int uid) async {
  try {
    final uri = Uri.parse('$hostName/artworks/$uid');
    logger.d(uri);
    final response = await http.get(uri);
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

Future<List<ArtworkListItem>> fetchArtworkByImage(String imagePath) async {
  try {
    final url = Uri.parse('$hostName/artworks/search');
    logger.d(url);
    String mimeType = 'application/octet-stream';
    if (imagePath.endsWith('.jpg') || imagePath.endsWith('.jpeg')) {
      mimeType = 'image/jpeg';
    } else if (imagePath.endsWith('.png')) {
      mimeType = 'image/png';
    }
    final request = http.MultipartRequest('POST', url)
                       ..files.add(await http.MultipartFile.fromPath(
                        'picture',
                        imagePath,
                        contentType: MediaType.parse(mimeType)
                      )
                    );
    final response = await request.send();
    if (response.statusCode == 200) {
      List<dynamic> results = jsonDecode(await response.stream.bytesToString())['data'];
      return results.map((item) => ArtworkListItem.fromJson(item)).toList();
    } {
      logger.e('Error from server: ${response.statusCode}');
    }
  } catch(e, stackTrace){
    logger.e('$e, image from: $imagePath');
    logger.d(stackTrace);
  }
  return [];
}