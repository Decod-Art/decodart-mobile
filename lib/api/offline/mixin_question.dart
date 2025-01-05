import 'package:decodart/model/artwork.dart' show Artwork;
import 'package:decodart/model/decod.dart' show DecodQuestion;
import 'package:decodart/util/logger.dart' show logger;
import 'package:decodart/api/decod.dart' as api_decod;

/// Mixin to handle the offline loading of Decod' questions.
mixin QuestionOffline {
  /// Loads Decod' questions associated with artworks.
  ///
  /// This method iterates through the artworks and fetches Decod' questions for each artwork
  /// that has associated questions. The questions are then stored in a map.
  ///
  /// [artworks] A map where the keys are artwork IDs and the values are [Artwork] objects.
  /// [pause] The duration of the pause between requests in milliseconds (default is 25 ms).
  ///
  /// Returns a map where the keys are artwork IDs and the values are lists of [DecodQuestion] objects.
  Future<Map<int, List<DecodQuestion>>> loadQuestions(Map<int, Artwork> artworks, {int pause=25}) async {
    Map<int, List<DecodQuestion>> questions = {};
    try {
      for (var entry in artworks.entries) {
        final key = entry.key;
        final value = entry.value;
        // Not all artworks have questions
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