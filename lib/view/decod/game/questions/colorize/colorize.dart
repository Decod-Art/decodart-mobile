import 'package:decodart/view/decod/game/questions/colorize/image_drawing.dart' show ImageDrawingWidget;
import 'package:flutter/cupertino.dart';

import 'package:decodart/view/decod/game/questions/abstract_question.dart' show AbstractQuestionWidget;

class ColorizeQuestion extends AbstractQuestionWidget {

  const ColorizeQuestion({
    super.key,
    required super.submitPoints,
    required super.question
    });

  @override
  State<AbstractQuestionWidget> createState() => _BoundingBoxQuestionState();
}

class _BoundingBoxQuestionState extends State<ColorizeQuestion> {
  final int numberOfErrorsAllowed = 2;
  bool isOver = false;
  late List<bool> found;
  late int tries;
  
  @override
  void initState() {
    super.initState();
    _initQuestion();
  }

  void _initQuestion() {
    found = List.generate(widget.question.answers[0].image!.boundingBoxes!.length, (_)=>false);
    tries = numberOfErrorsAllowed;
  }

  @override
  void didUpdateWidget(covariant ColorizeQuestion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question != widget.question) {
      _initQuestion();
      isOver = false;
    }
  }

  bool foundEverything() {
    return found.every((element) => element);
  }

  void foundCorrect(int index) {
    if (found[index]) {
      // already true
    } else {
      found[index] = true;
    }
    if(foundEverything()) {
      isOver = true;
    }
    setState(() {});
    if(isOver) {
      computePoints();
    }
  }

  void computePoints() {
    final double numberFound = found.where((element) => element).length.toDouble();
    final double total = found.length.toDouble();
    widget.submitPoints(numberFound/total);
  }

  void foundIncorrect() {
    tries -= 1;
    print('tries:$tries');
    if (tries <= 0){
      isOver = true;
      computePoints();
      setState(() {});
    }
  }

  Widget _finalMessage() {
    if(isOver){
      return foundEverything()?const Text("🎉", style: TextStyle(fontSize: 35),):const Text("❌", style: TextStyle(fontSize: 35));
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
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(15),
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
              )
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: _finalMessage()
              )
            ),
            Expanded(
              flex: 10,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: ImageDrawingWidget(
                    image: widget.question.answers[0].image!,
                    foundCorrect: foundCorrect,
                    foundIncorrect: foundIncorrect,
                    isOver: isOver,
                    isCorrect: foundEverything(),
                  )
                )
              )
            ),
          ],
        );
      },
    );
  }
}
