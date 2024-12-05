import 'package:decodart/model/decod.dart' show DecodAnswer;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;

/// A widget that displays a grid of possible answers for a text-based question in the Decod game.
/// 
/// The `Answers` widget is a stateless widget that shows a list of possible answers. The user can select an answer, and the widget will call the `onPress` callback with the index of the selected answer.
/// 
/// Attributes:
/// 
/// - `answers` (required): A [List] of [DecodAnswer] objects representing the possible answers.
/// - `selected` (optional): An [int] representing the index of the selected answer. (no answer selected is -1).
/// - `onPress` (required): A [void Function(int)] callback that is called when an answer is selected, with the index of the selected answer.
class Answers extends StatelessWidget {
  final List<DecodAnswer> answers;
  // -1 for no selection
  final int selected;
  final void Function(int) onPress;
  const Answers({super.key, required this.answers, required this.selected, required this.onPress});

  @override
  Widget build(BuildContext context){
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculez la hauteur des éléments en fonction de l'espace disponible
        double itemHeight = constraints.maxHeight / (answers.length / 2).ceil();

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: itemHeight,
          ),
          itemCount: answers.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => onPress(index),
              child: Container(
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: selected == index
                    ? (answers[index].isCorrect?Colors.green:Colors.red)
                    : Colors.grey[300],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    answers[index].text!,
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
}