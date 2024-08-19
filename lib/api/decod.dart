import 'package:decodart/model/decod.dart' show DecodQuestion;
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
      final response = await http.get(Uri.parse('$hostName/decods/artwork/$id'));
      if (response.statusCode == 200) {
        List<dynamic> list = jsonDecode(response.body);
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

Future<List<DecodQuestion>> fetchDecodQuestionRandomly() async {
  try {
      final response = await http.get(Uri.parse('$hostName/decods/random'));
      if (response.statusCode == 200) {
        List<dynamic> list = jsonDecode(response.body);
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