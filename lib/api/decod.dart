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

Future<List<DecodQuestion>> fetchDecodQuestionRandomly() async {
  try {
      final response = await http.get(Uri.parse('$hostName/decods/detailed?random=true&limit=50'));
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