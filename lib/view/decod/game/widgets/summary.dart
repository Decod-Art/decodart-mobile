import 'package:decodart/model/decod.dart' show DecodQuestion, DecodQuestionType;
import 'package:decodart/widgets/component/image/image.dart' show DecodImage;
import 'package:flutter/cupertino.dart';

/// A widget that displays a summary of a question in the Decod game.
/// 
/// The `SummaryWidget` is a stateless widget that shows the details of a question, including the question number, the question text, the correct answer, and whether the user's answer was correct.
/// 
/// Attributes:
/// 
/// - `number` (required): An [int] representing the question number.
/// - `question` (required): A [DecodQuestion] object representing the question details.
/// - `isCorrect` (required): A [bool] indicating whether the user's answer was correct.
class SummaryWidget extends StatelessWidget {
  final int number;
  final DecodQuestion question;
  final bool isCorrect;
  const SummaryWidget({super.key, required this.number, required this.question, required this.isCorrect});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: CupertinoColors.systemGrey),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(color: CupertinoColors.systemGrey6, borderRadius: BorderRadius.circular(8.0)),
              child: DecodImage(question.image, fit: BoxFit.contain,),
            ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Question #$number',
                      style: const TextStyle(color: CupertinoColors.systemGrey),
                    ),
                    const SizedBox(height: 4.0),
                    Text(question.question),
                    const SizedBox(height: 4.0),
                    if (question.questionType == DecodQuestionType.boundingbox)
                      Text(
                        "Il y avait ${question.answers[0].image!.boundingBoxes!.length} réponse${question.answers[0].image!.boundingBoxes!.length>1?'s':''}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    if (question.questionType == DecodQuestionType.text)
                      Text(question.correctAnswer!.text!, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(width: 15)
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Text(isCorrect?'✅':'❌', style: const TextStyle(fontSize: 24)),
          ),
        ],
      ),
    );
  }
}