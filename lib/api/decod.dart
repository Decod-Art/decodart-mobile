import 'package:decodart/model/decod.dart' show DecodQuestion, DecodTag;
import 'package:decodart/util/online.dart' show hostName;
import 'package:decodart/util/logger.dart' show logger;
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonDecode;

// fetchDecodQuestionByArtworkId
// fetchTags
// fetchDecodQuestionRandomly

class FetchDecodQuestionException implements Exception {
  final String message;
  FetchDecodQuestionException(this.message);

  @override
  String toString() => 'FetchDecodQuestionException: $message';
}

Future<List<DecodQuestion>> fetchDecodQuestionByArtworkId(int id,{int limit=10, bool random=true}) async {
  try {
    final Uri uri = Uri.parse('$hostName/decods/detailed').replace(
      queryParameters: {
        'artworkId': '$id',
        'limit': '$limit',
        'random': '$random'
      },
    );
    logger.d(uri);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      List<dynamic> list = jsonDecode(response.body)['data'];
      return list.map((json) => DecodQuestion.fromJson(json)).toList();
    } else {
      throw FetchDecodQuestionException('Failed to load DecodQuestion: ${response.statusCode}');
    }
  } catch (e, stackTrace) {
    logger.e('$e: ArtworkId: $id');
    logger.d(stackTrace);
    rethrow;
  }
}

Future<List<DecodTag>> fetchTags({
    int limit=5,
    int offset=0,
    String? query,
    bool? hasQuestion
  }) async {
  try {
    final Uri uri = Uri.parse('$hostName/decodTag').replace(
      queryParameters: {
        'limit': '$limit',
        'offset': '$offset',
        if (query != null) 'query': query,
        if (hasQuestion !=null) 'hasQuestion': hasQuestion.toString()
      },
    );
    logger.d(uri);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      List<dynamic> list = jsonDecode(response.body)['data'];
      return list.map((json) => DecodTag.fromJson(json)).toList();
    } else {
      throw FetchDecodQuestionException('Failed to load DecodTag: ${response.statusCode}');
    }
  } catch (e, stackTrace) {
    logger.e(e);
    logger.d(stackTrace);
    rethrow;
  }
}

Future<List<DecodQuestion>> fetchDecodQuestionRandomly({
    int limit=5,
    int offset=0,
    bool random=true,
    DecodTag? tag
  }) async {
  try {
      final Uri uri = Uri.parse('$hostName/decods/detailed').replace(
        queryParameters: {
          'limit': '$limit',
          'offset': '$offset',
          'random': random.toString(),
          if (tag !=null) 'tag': tag.uid.toString()
        },
      );
      logger.d(uri);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        List<dynamic> list = jsonDecode(response.body)['data'];
        return list.map((json) => DecodQuestion.fromJson(json)).toList();
      } else {
        throw FetchDecodQuestionException('Failed to load DecodQuestion: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      logger.e(e);
      logger.d(stackTrace);
      rethrow;
    }
}