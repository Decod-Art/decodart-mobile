import 'package:decodart/model/decod.dart' show DecodQuestion;
import 'package:decodart/view/decod/game/widgets/summary.dart' show SummaryWidget;
import 'package:flutter/cupertino.dart';

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

  List<Widget> _summary(BuildContext context){
    return List.generate(
      questions.length,
      (index) => SummaryWidget
      (number: index+1,
      question: questions[index],
      isCorrect: results[index]));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Center(
            child: Text("${totalPoints == totalPoints.toInt() ? totalPoints.toInt() : totalPoints}/${questions.length}", style: const TextStyle(fontSize: 55))
          )
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(totalPoints>questions.length/2?"🎉":"❌", style: const TextStyle(fontSize: 40)),
              if (totalPoints > questions.length/2)
                const Text('Bon score !', style: TextStyle(fontSize: 25))
            ]
          )
        ),
        Expanded(
          flex: 4,
          child: SingleChildScrollView(
            child: Column(
              children: _summary(context),
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