import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:decodart/view/decod/questions/abstract_question.dart' show AbstractQuestionWidget, AbstractQuestionWidgetState;

class TextQuestion extends AbstractQuestionWidget {
  const TextQuestion({
    super.key,
    required super.submitPoints,
    required super.question
    });

  @override
  State<StatefulWidget> createState() => _TextQuestionState();
}

class _TextQuestionState extends AbstractQuestionWidgetState {
  bool clickable = true;
  int selectedAnswer = -1;

  @override
  void didUpdateWidget(covariant TextQuestion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question != widget.question) {
      clickable = true;
      selectedAnswer = -1;
    }
  }

  @override
  Widget getAnswers(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3,
      ),
      itemCount: widget.question.answers.length, // Remplacez par le nombre d'éléments que vous avez
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // Action à effectuer lors du clic sur l'élément
            print('Element $index cliqué');
            _click(index);
          },
          child: Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: selectedAnswer==index
                ?(widget.question.answers[index].isCorrect?Colors.green:Colors.red)
                :Colors.grey[300],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: Text(
                widget.question.answers[index].text!, // Remplacez par le texte de votre élément
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        );
      },
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
            style: const TextStyle(color: Colors.white, fontSize: 24),
          ),
          if (widget.question.showImage)
            Expanded(
              child: Image.network(
                widget.question.image.path,
                fit: BoxFit.contain,
              ),
            )
        ]
      ),
    );
  }

  void _click(int index) {
    if (clickable) {
      selectedAnswer = index;
      clickable = false;
      setState(() {});
      widget.submitPoints(widget.question.answers[index].isCorrect?1:0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Expanded(
              flex: widget.question.answers.length==2?4:2,
              child: getQuestion(context),
            ),
            Expanded(
              flex: 1,
              child: getAnswers(context)
            ),
          ],
        );
      },
    );
  }


}