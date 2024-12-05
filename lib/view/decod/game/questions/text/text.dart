import 'package:decodart/view/decod/game/questions/text/_answers.dart' show Answers;
import 'package:decodart/view/decod/game/questions/text/_questions.dart' show Questions;
import 'package:flutter/cupertino.dart';
import 'package:decodart/view/decod/game/questions/abstract_question.dart' show AbstractQuestionWidget;

/// A widget that displays a text-based question in the Decod game.
/// 
/// The `TextQuestion` is a stateful widget that shows a question and a list of possible answers.
/// The user can select an answer, and the widget will call the `submitPoints` callback with the points gained.
/// 
/// Attributes:
/// 
/// - `submitPoints` (required): An [OnQuestionOver] callback that is called when the question is over, with the number of points gained.
/// - `question` (required): A [DecodQuestion] object representing the question details.
class TextQuestion extends AbstractQuestionWidget {
  const TextQuestion({super.key, required super.submitPoints, required super.question});

  @override
  State<StatefulWidget> createState() => _TextQuestionState();
}

class _TextQuestionState extends State<TextQuestion> {
  bool clickable = true; // If the user already answered, then answers become unclickable
  int selectedAnswer = -1; // Index of the selected answer

  @override
  void didUpdateWidget(covariant TextQuestion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question != widget.question) {
      clickable = true;
      selectedAnswer = -1;
    }
  }

  void _click(int index) {
    if (clickable) {
      selectedAnswer = index;
      clickable = false;
      // In text questions, the user can only get 0 or 1 point
      widget.submitPoints(widget.question.answers[index].isCorrect ? 1 : 0);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Expanded(
                flex: widget.question.answers.length == 2 ? 20 : 10,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Questions(question: widget.question),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 7, right: 7, bottom: 15),
                  child: Answers(answers: widget.question.answers, selected: selectedAnswer, onPress: _click),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}