import 'dart:math' show Random;

import 'package:decodart/api/decod.dart' show fetchDecodQuestions;
import 'package:decodart/controller_and_mixins/decod/menu_controller.dart' show MenuController;
import 'package:decodart/model/hive/artwork.dart' as hive show ArtworkListItem;
import 'package:decodart/model/artwork.dart' show Artwork;
import 'package:decodart/model/decod.dart' show DecodQuestion, DecodQuestionType, DecodTag;
import 'package:decodart/model/hive/decod.dart' show GameData;



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

  /// Adds a list of questions to the game.
  ///
  /// [questions] is the list of questions to add.
  /// [shuffle] specifies whether to shuffle the questions (default is false).
  void add(List<DecodQuestion> questions, {bool shuffle = false}) {
    this.questions.addAll(
      shuffle
        ? questions.map((item) => item.shuffleAnswers()).toList()
        : questions
    );
    this.questions.shuffle(Random());
    hasBeenCorrectlyAnswered.addAll(List.generate(this.questions.length, (_)=>false));
  }

  /// Fetches questions from the server and adds them to the game.
  ///
  /// [shuffle] specifies whether to shuffle the questions (default is false).
  Future<void> fetchQuestions ({bool shuffle = false}) async {
    try {
      if(hasArtwork) {
        add(await fetchDecodQuestions(artworkId: artwork!.uid!), shuffle: shuffle);
      } else {
        add(await fetchDecodQuestions(tag: tag), shuffle: shuffle);
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

  /// Sets the current question as correctly answered.
  ///
  /// [isCorrect] specifies whether the answer is correct (default is true).
  /// 
  /// Throws a [GameException] if no question is available
  void setCurrentQuestionToCorrect([bool isCorrect=true]) {
    if (isOver) {
      throw GameException('Game is over cannot be continued');
    }
    hasBeenCorrectlyAnswered[currentQuestionIndex] = isCorrect;
  }

  /// Moves to the next question.
  ///
  /// Throws a [GameException] if the game is over.
  void nextQuestion() {
    if (isOver) {
      throw GameException('Game is over cannot be continued');
    } 
    currentQuestionIndex ++;
    if (isOver && artwork != null) _saveArtwork();
    
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
      if (preview.image.isDownloaded) {
        await preview.image.downloadImageData();
      }
      history.insert(0, preview.toHive());
      decodedArtworkHistoryBox.put('history', history);
    }
  }

  double get totalPoints => _total;

  bool get hasArtwork => artwork != null;

  bool get containsQuestions => questions.isNotEmpty;

  bool get canBePlayed => containsQuestions;

  bool get isNotReady => isEmpty && !errorLoading;

  bool get isReady => !isNotEmpty;

  bool get hasFailedLoading => errorLoading;

  bool get isEmpty => !containsQuestions;

  bool get isNotEmpty => !isEmpty;

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