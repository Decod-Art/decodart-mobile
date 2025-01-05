import 'package:decodart/model/artwork.dart' show Artwork;
import 'package:decodart/model/decod.dart' show DecodQuestion;
import 'package:decodart/util/logger.dart' show logger;
import 'package:decodart/api/decod.dart' as api_decod;

mixin QuestionOffline {
  Future<Map<int, List<DecodQuestion>>> loadQuestions(Map<int, Artwork> artworks, {int pause=25}) async {
    Map<int, List<DecodQuestion>> questions = {};
    try {
      for (var entry in artworks.entries) {
        final key = entry.key;
        final value = entry.value;
        if (value.hasDecodQuestion) {
          final newQuestions = await api_decod.fetchDecodQuestions(artworkId: value.uid!);
          questions[key] = newQuestions;
          await Future.delayed(Duration(milliseconds: pause));
        }
      }
    } catch (e) {
      logger.e("Failed to retrieve the decod'questions: $e");
      rethrow;
    }
    return questions;
  }
}