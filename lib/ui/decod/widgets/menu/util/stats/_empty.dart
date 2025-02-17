import 'package:flutter/cupertino.dart';

class EmptyStat extends StatelessWidget {
  const EmptyStat({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(color: CupertinoColors.systemGrey6, borderRadius: BorderRadius.circular(16.0)),
      child: const Center(
        child: Text(
          "Décodez pour apprendre à mieux reconnaître les symboles dans l'art 🕵️",
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        )
      ),
    );
  }
}