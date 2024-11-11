import 'package:decodart/model/hive/artwork.dart';
import 'package:decodart/model/hive/decod.dart' show GameData;
import 'package:hive_flutter/hive_flutter.dart';

class GameController {
  late final Box<GameData> gameDataBox;
  late final Box<List> decodedArtworkHistoryBox;
  bool isOpened = false;
  GameController();

  Future<void> openBoxes () async {
    gameDataBox = await Hive.openBox<GameData>('gameDataBox');
    decodedArtworkHistoryBox = await Hive.openBox<List>('gameArtworkHistory');
    isOpened = true;
  }

  Future<void> reset () async {
    await gameDataBox.clear();
    await decodedArtworkHistoryBox.clear();
  }

  void dispose () {
    isOpened = false;
    gameDataBox.close();
    decodedArtworkHistoryBox.close();
  }

  bool get isNotOpened => !isOpened;

  GameData get score =>  gameDataBox.get('score', defaultValue: GameData())!;

  List<ArtworkListItem> get decodedArtworkHistory {
    return decodedArtworkHistoryBox
      .get('history', defaultValue: [])
      !.cast<ArtworkListItem>();
  }

}