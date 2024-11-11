import 'package:decodart/model/hive/decod.dart';
import 'package:decodart/widgets/dialog/dialog.dart' show showDialog;
import 'package:flutter/cupertino.dart';

class StatContent extends StatelessWidget {
  final GameData score;
  final VoidCallback onReset;
  const StatContent({
    super.key,
    required this.score,
    required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Taux de réussite', style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey2)),
          Text('${(score.rate!*100).toStringAsFixed(0)} %', style: const TextStyle(fontSize: 55)),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              "Continuez de décoder afin d'apprendre à mieux reconnaître les symboles dans l'art 🕵️",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            )
          ),
          CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            showDialog(
              context,
              content: const Text('Voulez-vous vraiment supprimer les œuvres déjà décodées et réinitialiser votre score ?'),
              onPressedOk: () => onReset()
            );
          },
          child: const Text(
            'Réinitialiser',
            style: TextStyle(
              fontSize: 16,
              color: CupertinoColors.activeBlue,
            ),
          ),
        ),
        ]
      )
    );
  }
}