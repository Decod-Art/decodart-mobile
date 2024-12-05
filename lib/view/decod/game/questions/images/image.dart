import 'package:decodart/view/decod/game/questions/images/_answers.dart' show Answers;
import 'package:flutter/cupertino.dart';
import 'package:decodart/view/decod/game/questions/abstract_question.dart' show AbstractQuestionWidget;

/// A widget that displays an image-based question in the Decod game.
/// 
/// The `ImageQuestion` is a stateful widget that shows a question and a list of possible answers in the form of images.
/// The user can select an answer, and the widget will call the `submitPoints` callback with the points gained.
/// 
/// Attributes:
/// 
/// - `submitPoints` (required): An [OnQuestionOver] callback that is called when the question is over, with the number of points gained.
/// - `question` (required): A [DecodQuestion] object representing the question details.
class ImageQuestion extends AbstractQuestionWidget {
  const ImageQuestion({
    super.key,
    required super.submitPoints,
    required super.question,
  });

  @override
  State<StatefulWidget> createState() => _ImageQuestionState();
}

class _ImageQuestionState extends State<ImageQuestion> {
  bool clickable = true; // If the user already answered, then answers become unclickable
  int selectedAnswer = -1; // Index of the selected answer. -1 is not selected answer

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
                    // Display the question text
                    Text(widget.question.question, style: const TextStyle(fontSize: 24)),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 13,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                child: Answers(
                  selected: selectedAnswer,
                  onPress: (index) {
                    if (clickable) {
                      setState(() {
                        selectedAnswer = index;
                        clickable = false;
                      });
                      // In image questions, the user can only get 0 or 1 point
                      widget.submitPoints(widget.question.answers[selectedAnswer].isCorrect ? 1 : 0);
                    }
                  },
                  answers: widget.question.answers,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}