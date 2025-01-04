import 'package:decodart/api/offline.dart';
import 'package:decodart/model/decod.dart' show DecodQuestion, DecodTag;
import 'package:decodart/util/online.dart' show hostName;
import 'package:decodart/util/logger.dart' show logger;
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonDecode;

// fetchDecodQuestions
// fetchTags

/// FetchDecodQuestionException is raised for any failed API call and Json format error
class FetchDecodQuestionException implements Exception {
  final String message;
  FetchDecodQuestionException(this.message);

  @override
  String toString() => 'FetchDecodQuestionException: $message';
}

/// Fetches Decod questions.
///
/// This method sends a GET request to the server to retrieve a list of Decod questions
/// associated with a specific set of criteria.
///
/// [artworkId] is the unique identifier of the artwork to retrieve questions for.
/// [limit] specifies the maximum number of questions to retrieve (default is 10).
/// [offset] specifies the offset for pagination (default is 0).
/// [random] specifies whether to retrieve questions in random order (default is true).
/// [tag] specifies a DecodTag to filter the questions.
/// [query] is a search string to filter the questions.
/// [seed] is used to seed the random number generator for reproducible results.
/// [uid] is the unique identifier of the user to retrieve personalized questions.
///
/// Returns a list of [DecodQuestion] objects if the request is successful.
///
/// Throws a [FetchDecodQuestionException] if there is an error during the request or if the server returns an error.
Future<List<DecodQuestion>> fetchDecodQuestions(
  {int? artworkId,
  int limit=10,
  int offset=0,
  bool random=true,
  DecodTag? tag,
  String? query,
  int? seed,
  int? uid,
  bool canUseOffline=true}) async {
  if (OfflineManager.useOffline&&canUseOffline) {
    OfflineManager offline = OfflineManager();
    return offline.fetchDecodQuestions(artworkId!);
  }
  try {
    final Uri uri = Uri.parse('$hostName/decods/detailed').replace(
      queryParameters: {
        if (artworkId != null)'artworkId': artworkId.toString(),
        'limit': limit.toString(),
        'offset': offset.toString(),
        'random': '$random',
        if (query != null)'query': query.toString(),
        if (tag != null) 'tag': tag.uid.toString(),
        if (seed != null)'seed': seed.toString(),
        if (uid != null)'uid': uid.toString()
      },
    );
    logger.d(uri);
    final response = await http.get(uri).timeout(
      Duration(seconds: 5), onTimeout: () => http.Response('Request timed out', 408),
    );
    if (response.statusCode == 200) {
      List<dynamic> list = jsonDecode(response.body)['data'];
      return list.map((json) => DecodQuestion.fromJson(json)).toList();
    } else {
      throw FetchDecodQuestionException('Failed to load DecodQuestion: ${response.statusCode}');
    }
  } catch (e, stackTrace) {
    logger.e('$e');
    logger.d(stackTrace);
    rethrow;
  }
}

/// Fetches Decod tags with the specified parameters.
///
/// This method sends a GET request to the server to retrieve a list of Decod tags
/// based on the provided parameters.
///
/// [limit] specifies the maximum number of tags to retrieve (default is 5).
/// [offset] specifies the offset for pagination (default is 0).
/// [query] is a search string to filter the tags.
/// [hasQuestion] specifies whether to filter tags that have associated questions.
///
/// Returns a list of [DecodTag] objects if the request is successful.
///
/// Throws a [FetchDecodQuestionException] if there is an error during the request or if the server returns an error.
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
    final response = await http.get(uri).timeout(
      Duration(seconds: 5), onTimeout: () => http.Response('Request timed out', 408),
    );
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
