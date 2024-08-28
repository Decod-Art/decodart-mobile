import 'package:decodart/model/hive/decod.dart' show GameData;
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StatsWidget extends StatefulWidget {
  const StatsWidget({super.key});

  @override
  State<StatsWidget> createState() => StatsWidgetState();
}

class StatsWidgetState extends State<StatsWidget> {
  Box<GameData>? gameDataBox;

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  @override
  void dispose() {
    // Fermer la boîte Hive dans dispose
    gameDataBox?.close();
    super.dispose();
  }

  Future<void> _openBox() async {
    gameDataBox = await Hive.openBox<GameData>('gameDataBox');
    setState(() {});
  }

  Future<void> reset() async {
    await gameDataBox?.clear();
    setState(() {});
  }

  Widget _statsBlock(BuildContext context) {
    if (gameDataBox == null) {
      return const Center(
        child: CupertinoActivityIndicator(),
      );
    }
    return ValueListenableBuilder(
      valueListenable: gameDataBox!.listenable(),
      builder: (context, Box<GameData> box, _) {
        var score = box.get('score', defaultValue: GameData());
        if (score!.hasPlayed) {
          return Container(
            width: double.infinity,
            height: 200,
            //padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey6,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Taux de réussite', style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey2)),
                Text('${(score.rate!*100).toStringAsFixed(0)} %', style: const TextStyle(fontSize: 55)),
                const Text(
                  "Continuez de Décoder afin d'apprendre à mieux reconnaître les symboles dans l'art 🕵️",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () async {
                  await reset();
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
        } else {
          return Container(
            width: double.infinity,
            height: 200,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey6,
              borderRadius: BorderRadius.circular(16.0),
            ),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 20),
      child: _statsBlock(context)
    );
  }
}