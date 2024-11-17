import 'dart:math' show Random;

import 'package:decodart/api/decod.dart' show fetchDecodQuestionByArtworkId, fetchDecodQuestionRandomly;
import 'package:decodart/controller_and_mixins/decod/menu_controller.dart' show MenuController;
import 'package:decodart/model/hive/artwork.dart' as hive show ArtworkListItem;
import 'package:decodart/model/artwork.dart' show Artwork;
import 'package:decodart/model/decod.dart' show DecodQuestion, DecodQuestionType, DecodTag;
import 'package:decodart/model/hive/decod.dart' show GameData;
import 'package:decodart/model/image.dart' show ImageOnline;



class GameController extends MenuController {
  double _total = 0;
  double points = 0;
  int currentQuestionIndex = 0;
  final List<DecodQuestion> questions = [];
  final List<bool> hasBeenCorrectlyAnswered = [];

  final Artwork? artwork;
  final DecodTag? tag;

  bool errorLoading = false;

  GameController({this.artwork, this.tag});

  Future<void> init() async {
    await openBoxes();
  }

  void add(List<DecodQuestion> questions, {bool shuffle = false}) {
    this.questions.addAll(
      shuffle
        ? questions.map((item) => item.shuffleAnswers()).toList()
        : questions
    );
    this.questions.shuffle(Random());
    hasBeenCorrectlyAnswered.addAll(List.generate(this.questions.length, (_)=>false));
  }

  Future<void> fetchQuestions ({bool shuffle = false}) async {
    try {
      if(hasArtwork) {
        add(await fetchDecodQuestionByArtworkId(artwork!.uid!), shuffle: shuffle);
      } else {
        add(await fetchDecodQuestionRandomly(tag: tag), shuffle: shuffle);
      }
    } catch (_, __) {
      errorLoading = true;
    }
  }

  void clear() {
    errorLoading = false;
    questions.clear();
    hasBeenCorrectlyAnswered.clear();
  }

  void setCurrentQuestionToCorrect([bool isCorrect=true]) {
    if (isOver) {
      throw GameException('Game is over cannot be continued');
    }
    hasBeenCorrectlyAnswered[currentQuestionIndex] = isCorrect;
  }

  void nextQuestion() {
    if (isOver) {
      throw GameException('Game is over cannot be continued');
    } 
    currentQuestionIndex ++;
    if (isOver && artwork != null) {
      _saveArtwork();
    }
  }

  void saveScore() {
    var scoreData = gameDataBox.get('score', defaultValue: GameData());
    scoreData?.count += 1;
    scoreData?.success += points;
    gameDataBox.put('score', scoreData!);
    _total += points;
    points = 0;
  }

  // artwork should be set here
  Future<void> _saveArtwork () async {
    var history = decodedArtworkHistoryBox.get('history', defaultValue: [])
                                          ?.cast<hive.ArtworkListItem>();

    if (history != null && !history.any((item) => item.uid == artwork!.uid)) {
      var preview = artwork!.listItem;
      await (preview.image as ImageOnline).downloadImageData();
      history.insert(0, preview.toHive());
      decodedArtworkHistoryBox.put('history', history);
    }
  }

  double get totalPoints => _total;

  bool get hasArtwork => artwork != null;

  bool get containsQuestions => questions.isNotEmpty;

  bool get canBePlayed => containsQuestions;

  bool get isNotReady => isEmpty && !errorLoading;

  bool get hasFailedLoading => errorLoading;

  bool get isEmpty => !containsQuestions;

  bool get isNotEmpty => containsQuestions;

  bool get isOver => currentQuestionIndex >= questions.length;

  bool get isNotOver => !isOver;

  DecodQuestionType get currentQuestionType => currentQuestion.questionType;

  DecodQuestion get currentQuestion {
    if (isOver) {
      throw GameException('Game is over cannot be continued');
    }
    return questions[currentQuestionIndex];
  }
}

class GameException implements Exception {
  final String message;

  GameException(this.message);

  @override
  String toString() {
    return "GameException: $message";
  }
}