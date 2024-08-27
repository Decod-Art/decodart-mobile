
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;

import 'package:decodart/view/decod/end.dart' show EndingWidget;

import 'package:decodart/model/decod.dart' show DecodQuestion, DecodQuestionType;
import 'package:decodart/api/decod.dart' show fetchDecodQuestionByArtworkId, fetchDecodQuestionRandomly;
import 'package:decodart/view/decod/questions/text.dart' show TextQuestion;
import 'package:decodart/view/decod/questions/colorize/colorize.dart' show ColorizeQuestion;
import 'package:decodart/view/decod/questions/image.dart' show ImageQuestion;

class DecodView extends StatefulWidget {
  final int? artworkId; // TODO Artwork
  const DecodView({super.key, this.artworkId});

  @override
  State<DecodView> createState() => _DecodViewState();
}

class _DecodViewState extends State<DecodView> {

  double totalPoints = 0;
  int currentQuestionIndex = 0;

  final List<DecodQuestion> questions = [];
  final List<bool> results = [];

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _saveScore(double score) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('success', score + (prefs.getDouble('success') ?? 0));
    await prefs.setDouble('count', 1 + (prefs.getDouble('count') ?? 0));
  }

  Future<void> _fetchQuestions() async {
    if (widget.artworkId != null){
      questions.addAll(await fetchDecodQuestionByArtworkId(widget.artworkId!));
    } else {
      questions.addAll(await fetchDecodQuestionRandomly());
    }
    results.addAll(List.generate(questions.length, (_)=>false));
    setState(() {});
  }

  void _nextQuestion() {
    currentQuestionIndex++;
    setState(() {});
  }

  void _validateQuestion(double points, {int duration=1}) {
    // TODO raise exception if points > 1 or points < 0
    if (points >= 1) {
      results[currentQuestionIndex] = true;
    }
    totalPoints += points;
    _saveScore(points);
    Future.delayed(Duration(seconds: duration), () {
      _nextQuestion();
    });
  }

  Widget _showQuestion() {
    if (currentQuestionIndex >= questions.length) {
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
