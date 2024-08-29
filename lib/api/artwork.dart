import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // Importez cette bibliothèque pour définir le type MIME

import 'package:decodart/model/artwork.dart' show ArtworkListItem, Artwork;
import 'package:decodart/api/util.dart' show hostName;

class FetchArtworkException implements Exception {
  final String message;
  FetchArtworkException(this.message);

  @override
  String toString() => 'FetchArtworkException: $message';
}

Future<List<ArtworkListItem>> fetchAllArtworks({int limit=10, int offset=0}) async {
    try {
    final response = await http.get(Uri.parse('$hostName/artworks?limit=$limit&offset=$offset'));
    if (response.statusCode == 200) {
      final results = jsonDecode(response.body);
      List<ArtworkListItem> listItems = results['data'].map((item) => ArtworkListItem.fromJson(item))
                                                                 .toList()
                                                                 .cast<ArtworkListItem>();
      return listItems;
    }
  } catch (e, stackTrace) {
    print(e);
    print(stackTrace);
  }
  return [];
}

Future<Artwork> fetchArtworkById(int uid) async {
    try {
    final response = await http.get(Uri.parse('$hostName/artworks/$uid'));
    if (response.statusCode == 200) {
      return Artwork.fromJson(jsonDecode(response.body));
    } else {
      throw FetchArtworkException('Artwork not found');
    }
  } catch (e, stackTrace) {
    print(e);
    print(stackTrace);
    rethrow;
  }
}

Future<List<ArtworkListItem>> fetchArtworksByMuseum(int museumId, {int limit=10, int offset=0}) async {
  try {
    final response = await http.get(Uri.parse('$hostName/artworks?museumId=$museumId&offset=$offset&limit=$limit'));
    if (response.statusCode == 200) {
      final results = jsonDecode(response.body);
      List<ArtworkListItem> listItems = results['data'].map((item) => ArtworkListItem.fromJson(item))
                                                                 .toList()
                                                                 .cast<ArtworkListItem>();
      return listItems;
    }
  } catch (e, stackTrace) {
    print(e);
    print(stackTrace);
  }
  return [];
}

Future<List<ArtworkListItem>> fetchArtworkByImage(String imagePath) async {
  try {
    final url = Uri.parse('$hostName/artworks/search');
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
      List<dynamic> results = jsonDecode(await response.stream.bytesToString());
      return results.map((item) => ArtworkListItem.fromJson(item)).toList();
    }
  } catch(e, stackTrace){
    print(e);
    print(stackTrace);
  }
  return [];
}