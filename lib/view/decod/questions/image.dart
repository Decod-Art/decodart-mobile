import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:decodart/view/decod/questions/abstract_question.dart' show AbstractQuestionWidget;

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
  Widget getAnswers(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (clickable) {
                setState(() {
                  selectedAnswer = 0;
                  clickable = false;
                });
                widget.submitPoints(widget.question.answers[0].isCorrect ? 1 : 0);
              }
            },
            child: Container(
              margin: const EdgeInsets.all(8.0),
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Center(
                  child: Stack(
                    children: [
                      Image.network(
                        widget.question.answers[0].image!.path,
                        fit: BoxFit.contain,
                      ),
                      Positioned.fill(
                        child: Container(
                          color: selectedAnswer == 0
                              ? widget.question.answers[0].isCorrect
                                  ? Colors.green.withOpacity(0.5)
                                  : Colors.red.withOpacity(0.5)
                              : Colors.transparent,
                        ),
                      ),
                    ],
                  )
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (clickable) {
                setState(() {
                  selectedAnswer = 1;
                  clickable = false;
                });
                widget.submitPoints(widget.question.answers[1].isCorrect ? 1 : 0);
              }
            },
            child: Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Center(
                  child: Stack(
                    children: [
                      Image.network(
                        widget.question.answers[1].image!.path,
                        fit: BoxFit.contain,
                      ),
                      Positioned.fill(
                        child: Container(
                          color: selectedAnswer == 1
                              ? widget.question.answers[1].isCorrect
                                  ? Colors.green.withOpacity(0.5)
                                  : Colors.red.withOpacity(0.5)
                              : Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                )
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget getQuestion(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.question.question, // Remplacez par le contenu de votre question
            style: const TextStyle(fontSize: 24),
          ),
        ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: getQuestion(context),
              )
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: getAnswers(context)
              )
            ),
          ],
        );
      },
    );
  }


}