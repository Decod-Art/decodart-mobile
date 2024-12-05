import 'package:decodart/model/decod.dart' show DecodQuestion;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;

/// A widget that displays the question text and optionally an image for a text-based question in the Decod game.
/// 
/// The `Questions` widget is a stateless widget that shows the question text and, if applicable, an image related to the question.
/// 
/// Attributes:
/// 
/// - `question` (required): A [DecodQuestion] object representing the question details.
class Questions extends StatelessWidget {
  final DecodQuestion question;
  const Questions({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display the question text
          Text(question.question, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24)),
          // If the question has an associated image, display it
          if (question.showImage) ...[
            const SizedBox(height: 5),
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(15)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(question.image.path, fit: BoxFit.contain),
                ),
              ),
            ),
          ],
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}