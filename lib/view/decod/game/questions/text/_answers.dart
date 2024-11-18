import 'package:decodart/model/decod.dart' show DecodAnswer;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;

class Answers extends StatelessWidget {
  final List<DecodAnswer> answers;
  final int selected;
  final void Function(int) onPress;
  const Answers({super.key, required this.answers, this.selected=-1, required this.onPress});

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
          itemCount: answers.length, // Remplacez par le nombre d'éléments que vous avez
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => onPress(index),
              child: Container(
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: selected==index
                    ?(answers[index].isCorrect?Colors.green:Colors.red)
                    :Colors.grey[300],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    answers[index].text!, // Remplacez par le texte de votre élément
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