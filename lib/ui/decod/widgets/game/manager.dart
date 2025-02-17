
import 'package:decodart/ui/decod/view_models/game_view_model.dart' show GameViewModel;
import 'package:decodart/data/model/artwork.dart' show Artwork;
import 'package:decodart/ui/core/miscellaneous/error/error.dart' show ErrorView;

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:decodart/ui/decod/widgets/game/end.dart' show EndingWidget;

import 'package:decodart/data/model/decod.dart' show DecodQuestionType, DecodTag;
import 'package:decodart/ui/decod/widgets/game/questions/text/text.dart' show TextQuestion;
import 'package:decodart/ui/decod/widgets/game/questions/findMe/find_me.dart' show FindMeQuestion;
import 'package:decodart/ui/decod/widgets/game/questions/images/image.dart' show ImageQuestion;

/// A widget that manages the Decod game.
/// 
/// The `DecodManager` is a stateful widget that handles the initialization, question fetching, and game logic for the Decod game.
/// It displays different types of questions (image, text, bounding box) and provides feedback for correct and incorrect answers.
/// 
/// Attributes:
/// 
/// - `artwork` (optional): An [Artwork] object representing the artwork to be decoded.
/// - `tag` (optional): A [DecodTag] object representing the category of the questions.
class DecodManager extends StatefulWidget {
  final Artwork? artwork;
  final DecodTag? tag;
  const DecodManager({super.key, this.artwork, this.tag});

  @override
  State<DecodManager> createState() => _DecodManagerState();
}

class _DecodManagerState extends State<DecodManager> {
  late final GameViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = GameViewModel(artwork: widget.artwork, tag: widget.tag);
    _initManager();
  }

  Future<void> _initManager () async {
    // Controller init opens the 
    // hive boxes related to the decod game
    // _fetchQuestions clear the data of the controller
    // which should be empty at the beginning
    // and load questions from the API
    await Future.wait([viewModel.init(), _fetchQuestions()]);
  }

  void _correctAnswer() async {
    HapticFeedback.heavyImpact();
  }

  void _incorrectAnswer() async {
    HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 200));
    HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 200));
    HapticFeedback.heavyImpact();
  }

  Future<void> _fetchQuestions() async {
    setState(() {viewModel.clear();});
    await viewModel.fetchQuestions(shuffle: true);
    setState(() {});
  }

  void _validateQuestion(double points, {int duration=1}) {
    // Points should be a number between 0 and 1
    if (points >= 1) {
      // The answer is considered valid
      _correctAnswer();
      viewModel.setCurrentQuestionToCorrect();
    } else {
      _incorrectAnswer();
    }
    viewModel.points += points;
    viewModel.saveScore();
    Future.delayed(Duration(seconds: duration), () => setState(() {viewModel.nextQuestion();}));
  }

  Widget _showQuestion() {
    if (viewModel.isOver) {
      return EndingWidget(
        totalPoints: viewModel.totalPoints,
        questions: viewModel.questions,
        results: viewModel.hasBeenCorrectlyAnswered
      );
    }
    switch (viewModel.currentQuestionType) {
      case DecodQuestionType.image:
        return ImageQuestion(
          question: viewModel.currentQuestion,
          submitPoints: _validateQuestion,
        );
      case DecodQuestionType.text:
        return TextQuestion(
          question: viewModel.currentQuestion,
          submitPoints: _validateQuestion,
        );
      case DecodQuestionType.boundingbox:
        return FindMeQuestion(
          submitPoints: _validateQuestion,
          question: viewModel.currentQuestion);
    }
  } 

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: const Text(""),
        middle: const Text('Décoder', style: TextStyle(color: CupertinoColors.black)),
        trailing: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            height: 30,
            width: 30,
            decoration: const BoxDecoration(
              color: CupertinoColors.lightBackgroundGray, // Fond plus clair
              shape: BoxShape.circle,
            ),
            child: const Icon(
              CupertinoIcons.clear_thick,
              size: 17,
              color: CupertinoColors.systemGrey,
            ),
          ),
        ),
      ),
      child: SafeArea(
        child: Center(
          child: viewModel.isNotReady
              ? const CupertinoActivityIndicator()
              : viewModel.hasFailedLoading
                ? ErrorView(onPress: _fetchQuestions)
                : _showQuestion(),
        ),
      )
    );
  }
}
