import 'package:decodart/controller/global/hive.dart' show HiveService;
import 'package:decodart/model/hive/artwork.dart' show ArtworkListItem;
import 'package:decodart/model/hive/decod.dart' show GameData;
import 'package:hive/hive.dart';

class MenuController {
  static const String gameDataBoxName = 'gameDataBox';
  static const String gameArtworkHistoryName = 'gameArtworkHistory';

  MenuController();

  Future<void> openBoxes () async {
    await HiveService().openBox<GameData>(gameDataBoxName);
    await HiveService().openBox<List>(gameArtworkHistoryName);
  }

  Future<void> reset () async {
    await gameDataBox.clear();
    await decodedArtworkHistoryBox.clear();
  }

  void dispose () {
    final service = HiveService();
    service.closeBox(gameDataBoxName);
    service.closeBox(gameArtworkHistoryName);
  }

  bool get isOpened {
    final service = HiveService();
    return service.isBoxOpened(gameDataBoxName)&&service.isBoxOpened(gameArtworkHistoryName);
  }

  bool get isNotOpened => !isOpened;

  Box<GameData> get gameDataBox => HiveService().getBox<GameData>(gameDataBoxName)!;
  Box<List> get decodedArtworkHistoryBox => HiveService().getBox<List>(gameArtworkHistoryName)!;

  GameData get score =>  gameDataBox.get('score', defaultValue: GameData())!;

  List<ArtworkListItem> get decodedArtworkHistory {
    return decodedArtworkHistoryBox
      .get('history', defaultValue: [])
      !.cast<ArtworkListItem>();
  }

}