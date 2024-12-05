import 'package:decodart/model/decod.dart' show DecodAnswer;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;

/// A widget that displays a list of possible answers for an image-based question in the Decod game.
/// 
/// The `Answers` widget is a stateless widget that shows a list of possible answers in the form of images. The user can select an answer, and the widget will call the `onPress` callback with the index of the selected answer.
/// 
/// Attributes:
/// 
/// - `selected` (optional): An [int] representing the index of the selected answer. Defaults to -1 (no answer selected).
/// - `onPress` (required): A [void Function(int)] callback that is called when an answer is selected, with the index of the selected answer.
/// - `answers` (required): A [List] of [DecodAnswer] objects representing the possible answers.
class Answers extends StatelessWidget {
  final int selected;
  final void Function(int) onPress;
  final List<DecodAnswer> answers;
  const Answers({super.key, this.selected=-1, required this.onPress, required this.answers});
  

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index){
        if (index % 2 == 1) {
          return const SizedBox(height: 16.0);
        }
        index = index == 0 ? 0 : 1;
        return Expanded(
          child: GestureDetector(
            onTap: () {
              onPress(index);
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
                      Positioned.fill(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Image.network(
                            answers[index].image!.path,
                          )
                        )
                      ),
                      Positioned.fill(
                        child: Container(
                          color: selected == index
                              ? answers[index].isCorrect
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
        );
      })
    );
  }
}