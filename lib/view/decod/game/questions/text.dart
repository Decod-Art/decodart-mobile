import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:decodart/view/decod/game/questions/abstract_question.dart' show AbstractQuestionWidget;

class TextQuestion extends AbstractQuestionWidget {
  const TextQuestion({
    super.key,
    required super.submitPoints,
    required super.question
    });

  @override
  State<StatefulWidget> createState() => _TextQuestionState();
}

class _TextQuestionState extends State<TextQuestion> {
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

  Widget getAnswers(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculez la hauteur des éléments en fonction de l'espace disponible
        double itemHeight = constraints.maxHeight / (widget.question.answers.length / 2).ceil();

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: itemHeight,
          ),
          itemCount: widget.question.answers.length, // Remplacez par le nombre d'éléments que vous avez
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
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
    );
  }

  Widget getQuestion(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            textAlign: TextAlign.center,
            widget.question.question, // Remplacez par le contenu de votre question
            style: const TextStyle(fontSize: 24),
          ),
          if (widget.question.showImage)
            ...[
              const SizedBox(height: 5),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey, // Couleur de fond grise
                    borderRadius: BorderRadius.circular(15), // Coins arrondis
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15), // Coins arrondis pour l'image
                    child: Image.network(
                      widget.question.image.path,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              )
            ],
          const SizedBox(height: 15),
        ]
      ),
    );
  }

  void _click(int index) {
    if (clickable) {
      selectedAnswer = index;
      clickable = false;
      widget.submitPoints(widget.question.answers[index].isCorrect?1:0);
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
                flex: widget.question.answers.length==2?20:10,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: getQuestion(context),
                )
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 7, right: 7, bottom: 15),
                  child: getAnswers(context)
                )
              ),
            ],
          );
        },
      )
    );
  }


}