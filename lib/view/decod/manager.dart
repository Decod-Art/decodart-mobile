
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show CircularProgressIndicator, Colors;
import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;

import 'package:decodart/model/decod.dart' show DecodQuestion, DecodQuestionType;
import 'package:decodart/api/decod.dart' show fetchDecodQuestionByArtworkId, fetchDecodQuestionRandomly;
import 'package:decodart/view/decod/questions/text.dart' show TextQuestion;
import 'package:decodart/view/decod/questions/bounding_box/bounding_box.dart' show BoundingBoxQuestion;
import 'package:decodart/view/decod/questions/image.dart' show ImageQuestion;

class DecodManagerWidget extends StatefulWidget {
  final int? artworkId;
  const DecodManagerWidget({super.key, this.artworkId});

  @override
  State<DecodManagerWidget> createState() => _DecodManagerWidgetState();
}

class _DecodManagerWidgetState extends State<DecodManagerWidget> {
  double totalPoints = 0;
  int currentQuestionIndex = 0;
  final List<DecodQuestion> questions = [];

  Future<void> _saveScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('score', score + (prefs.getInt('score') ?? 0));
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
    totalPoints += points*10;
    _saveScore((points*10).toInt());
    Future.delayed(Duration(seconds: duration), () {
      _nextQuestion();
    });
  }

  Widget _showQuestion() {
    if (currentQuestionIndex >= questions.length) {
      _validateQuestion(0, duration: 5);
      return Center(
        child: Text(
          "Votre score : ${totalPoints.toInt()}",
          style: const TextStyle(color: Colors.white, fontSize: 24),
        )
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
      backgroundColor: Colors.black,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.black,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(CupertinoIcons.clear, color: Colors.white),
        ),
      ),
      child: Container(
        color: Colors.black,
        child: Center(
          child: questions.isEmpty
              ? const CircularProgressIndicator(color: Colors.white)
              : _showQuestion(),
        ),
      ),
    );
  }
}
