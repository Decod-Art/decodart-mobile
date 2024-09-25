import 'package:decodart/model/decod.dart' show DecodQuestion, DecodTag;
import 'package:decodart/api/util.dart' show hostName;
import 'package:http/http.dart' as http;
import 'dart:convert';

class FetchDecodQuestionException implements Exception {
  final String message;
  FetchDecodQuestionException(this.message);

  @override
  String toString() => 'FetchDecodQuestionException: $message';
}

Future<List<DecodQuestion>> fetchDecodQuestionByArtworkId(int id) async {
  try {
      final response = await http.get(Uri.parse('$hostName/decods/detailed?artworkId=$id&limit=10&random=true'));
      if (response.statusCode == 200) {
        List<dynamic> list = jsonDecode(response.body)['data'];
        return list.map((json) => DecodQuestion.fromJson(json)).toList();
      } else {
        throw FetchDecodQuestionException('Failed to load DecodQuestion: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
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
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      List<dynamic> list = jsonDecode(response.body)['data'];
      return list.map((json) => DecodTag.fromJson(json)).toList();
    } else {
      throw FetchDecodQuestionException('Failed to load DecodTag: ${response.statusCode}');
    }
  } catch (e, stackTrace) {
    print(e);
    print(stackTrace);
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
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        List<dynamic> list = jsonDecode(response.body)['data'];
        return list.map((json) => DecodQuestion.fromJson(json)).toList();
      } else {
        throw FetchDecodQuestionException('Failed to load DecodQuestion: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
      rethrow;
    }
}