import 'package:decodart/view/decod/game/questions/images/_answers.dart' show Answers;
import 'package:flutter/cupertino.dart';
import 'package:decodart/view/decod/game/questions/abstract_question.dart' show AbstractQuestionWidget;

class ImageQuestion extends AbstractQuestionWidget {
  const ImageQuestion({
    super.key,
    required super.submitPoints,
    required super.question
    });

  @override
  State<StatefulWidget> createState() => _ImageQuestionState();
}

class _ImageQuestionState extends State<ImageQuestion> {
  bool clickable = true;
  int selectedAnswer = -1;

  @override
  void didUpdateWidget(covariant ImageQuestion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question != widget.question) {
      clickable = true;
      selectedAnswer = -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.question.question, // Remplacez par le contenu de votre question
                      style: const TextStyle(fontSize: 24),
                    ),
                  ]
                ),
              )
            ),
            Expanded(
              flex: 13,
              child: Padding(
                padding: const EdgeInsets.only(left:15, right: 15, bottom: 15),
                child: Answers(
                  selected: selectedAnswer,
                  onPress: (index) {
                    if (clickable) {
                      setState(() {
                        selectedAnswer = index;
                        clickable = false;
                      });
                      widget.submitPoints(widget.question.answers[index].isCorrect ? 1 : 0);
                    }
                  },
                  answers: widget.question.answers
                )
              )
            ),
          ],
        );
      },
    );
  }
}