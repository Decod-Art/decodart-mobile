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
  
  @override
  void initState() {
    super.initState();
    found = List.generate(widget.question.answers[0].image!.boundingBoxes!.length, (_)=>false);
  }

  @override
  void didUpdateWidget(covariant BoundingBoxQuestion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question != widget.question) {
      found = List.generate(widget.question.answers[0].image!.boundingBoxes!.length, (_)=>false);
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
      final double numberFound = found.where((element) => element).length.toDouble();
      final double total = found.length.toDouble();
      widget.submitPoints(numberFound/total);
    }
  }

  void foundIncorrect() {
    isOver = true;
    setState(() {});
    final double numberFound = found.where((element) => element).length.toDouble();
    final double total = found.length.toDouble();
    widget.submitPoints(numberFound/total);
  }

  @override
  Widget getQuestion(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.question.question,
            style: const TextStyle(color: Colors.white, fontSize: 24),
          )
        ]
      ),
    );
  }

  @override
  Widget getAnswers(BuildContext context) {
    return InteractiveViewer(
      panEnabled: true, // Permet le panoramique
      minScale: 0.5, // Échelle minimale
      maxScale: 4.0, // Échelle maximale
      child: FindInImageWidget(
        image: widget.question.answers[0].image!,
        foundCorrect: foundCorrect,
        foundIncorrect: foundIncorrect,
        isOver: isOver,
        isCorrect: foundEverything(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Expanded(
              flex: 1,
              child: getQuestion(context),
            ),
            Expanded(
              flex: 5,
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
