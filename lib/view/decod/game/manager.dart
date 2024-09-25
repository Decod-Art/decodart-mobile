
import 'package:decodart/model/artwork.dart' show Artwork;
import 'package:decodart/model/hive/decod.dart' show GameData;
import 'package:decodart/model/hive/artwork.dart' as hive show ArtworkListItem;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:decodart/view/decod/game/end.dart' show EndingWidget;

import 'package:decodart/model/decod.dart' show DecodQuestion, DecodQuestionType, DecodTag;
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

  double totalPoints = 0;
  int currentQuestionIndex = 0;
  Box<GameData>? gameDataBox;
  Box<List>? artworkHistory;

  final List<DecodQuestion> questions = [];
  final List<bool> results = [];

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
    _openBox();
  }

  void _correctAnswer() async {
    // if (await Vibration.hasVibrator() ?? false) {
    //   Vibration.vibrate(duration: 100);  // Short vibration (100 ms)
    // }
    HapticFeedback.heavyImpact();
  }

  void _incorrectAnswer() async {
    // if (await Vibration.hasVibrator() ?? false) {
    //   Vibration.vibrate(duration: 500);  // Short vibration (100 ms)
    // }
    HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 200));
    HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 200));
    HapticFeedback.heavyImpact();
  }

  Future<void> _openBox() async {
      gameDataBox = await Hive.openBox<GameData>('gameDataBox');
      artworkHistory = await Hive.openBox<List>('gameArtworkHistory');
      setState(() {});
    }

  Future<void> _saveScore(double score) async {
    var scoreData = gameDataBox?.get('score', defaultValue: GameData());
    scoreData?.count += 1;
    scoreData?.success += score;
    gameDataBox?.put('score', scoreData!);
  }

  void _addArtwork() {
    if (widget.artwork != null){
      var history = artworkHistory?.get('history', defaultValue: [])
                                  ?.cast<hive.ArtworkListItem>();
      if (history !=null && !history.any((item) => item.uid == widget.artwork!.uid)) {
        history.insert(0, widget.artwork!.listItem.toHive());
        artworkHistory?.put('history', history);
      }
    }
  }

  Future<void> _fetchQuestions() async {
    if (widget.artwork != null){
      questions.addAll(await fetchDecodQuestionByArtworkId(widget.artwork!.uid!));
    } else {
      questions.addAll(await fetchDecodQuestionRandomly(tag: widget.tag));
    }
    results.addAll(List.generate(questions.length, (_)=>false));
    setState(() {});
  }

  void _nextQuestion() {
    currentQuestionIndex++;
    setState(() {});
  }

  void _validateQuestion(double points, {int duration=1}) {
    if (points >= 1) {
      _correctAnswer();
      results[currentQuestionIndex] = true;
    } else {
      _incorrectAnswer();
    }
    totalPoints += points;
    _saveScore(points);
    Future.delayed(Duration(seconds: duration), () {
      _nextQuestion();
    });
  }

  Widget _showQuestion() {
    if (currentQuestionIndex >= questions.length) {
      _addArtwork();

      return EndingWidget(
        totalPoints: totalPoints,
        questions: questions,
        results: results
      );
    }
    final currentQuestion = questions[currentQuestionIndex];
    switch (currentQuestion.questionType) {
      case DecodQuestionType.image:
        return ImageQuestion(
          question: currentQuestion,
          submitPoints: _validateQuestion,
        );
      case DecodQuestionType.text:
        return TextQuestion(
          question: currentQuestion,
          submitPoints: _validateQuestion,
        );
      case DecodQuestionType.boundingbox:
        return ColorizeQuestion(
          submitPoints: _validateQuestion,
          question: currentQuestion);
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
          child: questions.isEmpty
              ? const CupertinoActivityIndicator()
              : _showQuestion(),
        ),
      )
    );
  }
}
