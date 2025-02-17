import 'package:decodart/data/model/decod.dart' show DecodQuestion;
import 'package:decodart/ui/decod/widgets/game/widgets/summary.dart' show SummaryWidget;
import 'package:flutter/cupertino.dart';

/// A widget that displays the end screen of the Decod game.
/// 
/// The `EndingWidget` is a stateless widget that shows the total points scored, a summary of the questions and their results, and a button to finish the game.
/// 
/// Attributes:
/// 
/// - `totalPoints` (required): A [double] representing the total points scored by the user.
/// - `questions` (required): A [List] of [DecodQuestion] objects representing the questions asked during the game.
/// - `results` (required): A [List] of [bool] values indicating whether each question was answered correctly.
class EndingWidget extends StatelessWidget {
  final double totalPoints;
  final List<DecodQuestion> questions;
  final List<bool> results;
  const EndingWidget({
    super.key,
    required this.totalPoints,
    required this.questions,
    required this.results
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text("${totalPoints == totalPoints.toInt() ? totalPoints.toInt() : totalPoints}/${questions.length}", style: const TextStyle(fontSize: 55))
              ),
              Text(totalPoints>questions.length/2?"🎉":"❌", style: const TextStyle(fontSize: 40)),
              if (totalPoints > questions.length/2)
                const Text('Bon score !', style: TextStyle(fontSize: 25))
            ]
          ),
        ),
        Expanded(
          flex: 4,
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(
                questions.length,
                (index) => SummaryWidget(
                  number: index+1,
                  question: questions[index],
                  isCorrect: results[index]
                )
              )
            )
          )
        ),
        const SizedBox(height: 5),
        Container(
          color: CupertinoColors.systemGrey6,
          width: double.infinity,
          height: 100,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: CupertinoButton.filled(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Terminer'),
            )
          ),
        ),
      ],
    );
  }
}