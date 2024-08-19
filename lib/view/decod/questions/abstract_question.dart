import 'package:decodart/model/decod.dart' show DecodQuestion;
import 'package:flutter/cupertino.dart';

typedef OnQuestionOver = void Function(double);

abstract class AbstractQuestionWidget extends StatefulWidget {
  final OnQuestionOver submitPoints;//add the number of points gained
  final DecodQuestion question;

  const AbstractQuestionWidget({
    super.key,
    required this.submitPoints,
    required this.question
    });
}

abstract class AbstractQuestionWidgetState extends State<AbstractQuestionWidget> {
  bool showAnswer = false;
  bool isCorrect = false;

  void validateQuestion() {
    // Logique de validation ici
    setState(() {
      showAnswer = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      widget.submitPoints(1);
    });
  }
  
  Widget getQuestion(BuildContext context);

  Widget  getAnswers(BuildContext context);
}