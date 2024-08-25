import 'package:decodart/view/decod/questions/bounding_box/decod_images_2.dart' show ImageDrawingWidget;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;

import 'package:decodart/view/decod/questions/abstract_question.dart' show AbstractQuestionWidget, AbstractQuestionWidgetState;
import 'package:decodart/view/decod/questions/bounding_box/decod_images.dart' show FindInImageWidget;

class BoundingBoxQuestion extends AbstractQuestionWidget {

  const BoundingBoxQuestion({
    super.key,
    required super.submitPoints,
    required super.question
    });

  @override
  State<AbstractQuestionWidget> createState() => _BoundingBoxQuestionState();
}

class _BoundingBoxQuestionState extends AbstractQuestionWidgetState {
  bool isOver = false;
  late List<bool> found;
  late int tries;
  
  @override
  void initState() {
    super.initState();
    found = List.generate(widget.question.answers[0].image!.boundingBoxes!.length, (_)=>false);
    tries = 2 + widget.question.image.boundingBoxes!.length;
  }

  @override
  void didUpdateWidget(covariant BoundingBoxQuestion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question != widget.question) {
      found = List.generate(widget.question.answers[0].image!.boundingBoxes!.length, (_)=>false);
      isOver = false;
      tries = 2 + widget.question.image.boundingBoxes!.length;
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
      final double numberFound = found.where((element) => element).length.toDouble();
      final double total = found.length.toDouble();
      widget.submitPoints(numberFound/total);
    }
  }

  void foundIncorrect() {
    tries -= 1;
    if (tries <= 0){
      isOver = true;
      setState(() {});
      final double numberFound = found.where((element) => element).length.toDouble();
      final double total = found.length.toDouble();
      widget.submitPoints(numberFound/total);
    }
  }

  @override
  Widget getQuestion(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.question.question,
          style: const TextStyle(fontSize: 24),
        ),
      ]
    );
  }

  @override
  Widget getAnswers(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: ImageDrawingWidget(
        image: widget.question.answers[0].image!,
        foundCorrect: foundCorrect,
        foundIncorrect: foundIncorrect,
        isOver: isOver,
        isCorrect: foundEverything(),
      )
    );
  }

  Widget _finalMessage() {
    if(isOver){
      return foundEverything()?const Text("🎉", style: TextStyle(fontSize: 35),):const Text("☠", style: TextStyle(fontSize: 35));
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
                child: getQuestion(context),
              )
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Center(
                  child: _finalMessage()
                )
              )
            ),
            Expanded(
              flex: 10,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: getAnswers(context)
              )
            ),
          ],
        );
      },
    );
  }
}
