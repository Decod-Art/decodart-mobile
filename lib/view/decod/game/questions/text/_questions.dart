import 'package:decodart/model/decod.dart' show DecodQuestion;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;

class Questions extends StatelessWidget {
  final DecodQuestion question;
  const Questions({super.key, required this.question});
  @override
  Widget build(BuildContext context){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            textAlign: TextAlign.center,
            question.question, // Remplacez par le contenu de votre question
            style: const TextStyle(fontSize: 24),
          ),
          if (question.showImage)
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
                      question.image.path,
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
}