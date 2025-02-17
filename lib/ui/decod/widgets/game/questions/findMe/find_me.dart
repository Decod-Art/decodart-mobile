import 'package:decodart/ui/decod/widgets/game/questions/findMe/image_drawing.dart' show ImageDrawingWidget;
import 'package:flutter/cupertino.dart';

import 'package:decodart/ui/decod/widgets/game/questions/abstract_question.dart' show AbstractQuestionWidget;
import 'package:flutter/services.dart';

/// A widget that displays a "Find Me" question in the Decod game.
/// 
/// The `FindMeQuestion` is a stateful widget that shows an image with bounding boxes. The user must find and select the correct objects within the image.
/// The widget provides feedback for correct and incorrect selections and calculates the points based on the number of correct selections.
/// 
/// Attributes:
/// 
/// - `submitPoints` (required): An [OnQuestionOver] callback that is called when the question is over, with the number of points gained.
/// - `question` (required): A [DecodQuestion] object representing the question details.
class FindMeQuestion extends AbstractQuestionWidget {

  const FindMeQuestion({
    super.key,
    required super.submitPoints,
    required super.question
    });

  @override
  State<AbstractQuestionWidget> createState() => _BoundingBoxQuestionState();
}

const int numberOfErrorsAllowed = 2;

class _BoundingBoxQuestionState extends State<FindMeQuestion> {
  bool isOver = false;
  // found is a bool list saying if a specific object in the image has been found
  late List<bool> found;
  late int tries;
  
  @override
  void initState() {
    super.initState();
    _initQuestion();
  }

  void _initQuestion() {
    // initialize found to false
    found = List.generate(widget.question.answers[0].image!.boundingBoxes!.length, (_) => false);
    tries = numberOfErrorsAllowed;
  }

  @override
  void didUpdateWidget(covariant FindMeQuestion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question != widget.question) {
      _initQuestion();
      isOver = false;
    }
  }

  bool get foundEverything => found.every((element) => element);

  void foundCorrect(int index) {
    HapticFeedback.mediumImpact();
    found[index] = true; // note that found might already be true
    
    if(foundEverything) isOver = true;
    setState(() {});
    if(isOver) computePoints();
  }

  void computePoints() {
    final double numberFound = found.where((element) => element).length.toDouble();
    final double total = found.length.toDouble();
    widget.submitPoints(numberFound/total);
  }

  void foundIncorrect() {
    HapticFeedback.mediumImpact();
    tries -= 1;
    if (tries <= 0){
      isOver = true;
      computePoints();
      setState(() {});
    }
  }

  Widget get finalMessage {
    if(isOver){
      return foundEverything 
        ? const Text("🎉", style: TextStyle(fontSize: 35))
        : const Text("❌", style: TextStyle(fontSize: 35));
    }
    else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.question.question,
                    style: const TextStyle(fontSize: 24),
                  ),
                ]
              )
            ),
            SizedBox(
              height: 45,
              child: Center(
                child: finalMessage
              )
            ),
            Expanded(
              flex: 17,
              child: Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 15, left: 15, right: 15),
                child: ImageDrawingWidget(
                  image: widget.question.answers[0].image!,
                  foundCorrect: foundCorrect,
                  foundIncorrect: foundIncorrect,
                  readOnly: isOver
                )
              )

            ),
          ],
        );
      },
    );
  }
}
