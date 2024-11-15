
import 'package:decodart/controller/decod/game_controller.dart' show GameController;
import 'package:decodart/model/artwork.dart' show Artwork;

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:decodart/view/decod/game/end.dart' show EndingWidget;

import 'package:decodart/model/decod.dart' show DecodQuestionType, DecodTag;
import 'package:decodart/api/decod.dart' show fetchDecodQuestionByArtworkId, fetchDecodQuestionRandomly;
import 'package:decodart/view/decod/game/questions/text.dart' show TextQuestion;
import 'package:decodart/view/decod/game/questions/colorize/colorize.dart' show ColorizeQuestion;
import 'package:decodart/view/decod/game/questions/image.dart' show ImageQuestion;

class DecodView extends StatefulWidget {
  final Artwork? artwork;
  final DecodTag? tag;
  const DecodView({super.key, this.artwork, this.tag});

  @override
  State<DecodView> createState() => _DecodViewState();
}

class _DecodViewState extends State<DecodView> {
  late final GameController controller;

  @override
  void initState() {
    super.initState();
    controller = GameController(artwork: widget.artwork);
    _fetchQuestions();
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
    await controller.init();
    controller.add(
      controller.hasArtwork
        ? await fetchDecodQuestionByArtworkId(controller.artwork!.uid!)
        : await fetchDecodQuestionRandomly(tag: widget.tag),
      shuffle: true
    );

    setState(() {});
  }

  void _validateQuestion(double points, {int duration=1}) {
    if (points >= 1) {
      _correctAnswer();
      controller.setCurrentQuestionToCorrect();
    } else {
      _incorrectAnswer();
    }
    controller.points += points;
    controller.saveScore();
    Future.delayed(Duration(seconds: duration), () {
      setState(() {controller.nextQuestion();});
    });
  }

  Widget _showQuestion() {
    if (controller.isOver) {
      return EndingWidget(
        totalPoints: controller.totalPoints,
        questions: controller.questions,
        results: controller.hasBeenCorrectlyAnswered
      );
    }
    switch (controller.currentQuestionType) {
      case DecodQuestionType.image:
        return ImageQuestion(
          question: controller.currentQuestion,
          submitPoints: _validateQuestion,
        );
      case DecodQuestionType.text:
        return TextQuestion(
          question: controller.currentQuestion,
          submitPoints: _validateQuestion,
        );
      case DecodQuestionType.boundingbox:
        return ColorizeQuestion(
          submitPoints: _validateQuestion,
          question: controller.currentQuestion);
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
          child: controller.isEmpty
              ? const CupertinoActivityIndicator()
              : _showQuestion(),
        ),
      )
    );
  }
}
