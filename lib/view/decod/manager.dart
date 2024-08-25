
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show CircularProgressIndicator, Colors;
import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;

import 'package:decodart/model/decod.dart' show DecodQuestion, DecodQuestionType;
import 'package:decodart/api/decod.dart' show fetchDecodQuestionByArtworkId, fetchDecodQuestionRandomly;
import 'package:decodart/view/decod/questions/text.dart' show TextQuestion;
import 'package:decodart/view/decod/questions/bounding_box/bounding_box.dart' show BoundingBoxQuestion;
import 'package:decodart/view/decod/questions/image.dart' show ImageQuestion;

class DecodView extends StatefulWidget {
  final int? artworkId;
  const DecodView({super.key, this.artworkId});

  @override
  State<DecodView> createState() => _DecodViewState();
}

class _DecodViewState extends State<DecodView> {
  double totalPoints = 0;
  int currentQuestionIndex = 0;
  final List<DecodQuestion> questions = [];

  Future<void> _saveScore(double score) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('success', score + (prefs.getDouble('success') ?? 0));
    await prefs.setDouble('count', 1 + (prefs.getDouble('count') ?? 0));
    //score + (prefs.getInt('score') ?? 0
  }

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    if (widget.artworkId != null){
      questions.addAll(await fetchDecodQuestionByArtworkId(widget.artworkId!));
    } else {
      questions.addAll(await fetchDecodQuestionRandomly());
    }
    setState(() {});
  }

  void _nextQuestion() {
    print('Next question');
    currentQuestionIndex++;
    if (currentQuestionIndex >= questions.length + 1) {
      if (mounted) {
        Navigator.pop(context);
      }
    } else {
      setState(() {
      });
    }
  }

  void _validateQuestion(double points, {int duration=1}) {
    totalPoints += points;
    _saveScore(points);
    Future.delayed(Duration(seconds: duration), () {
      _nextQuestion();
    });
  }

  Widget _showQuestion() {
    if (currentQuestionIndex >= questions.length) {
      _validateQuestion(0, duration: 5);
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: Text("${totalPoints == totalPoints.toInt() ? totalPoints.toInt() : totalPoints}/${questions.length}", style: const TextStyle(fontSize: 55))
            )
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(totalPoints>questions.length/2?"🎉":"😭", style: const TextStyle(fontSize: 60))
            )
          )
        ],
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
        return BoundingBoxQuestion(
          submitPoints: _validateQuestion,
          question: currentQuestion);
      default:
        return const Center(
          child: Text(
            'Type de question inconnu',
            style: TextStyle(color: Colors.white),
          ),
        );
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
              ? const CircularProgressIndicator(color: Colors.white)
              : _showQuestion(),
        ),
      )
    );
  }
}
