
import 'package:hive/hive.dart';

// dart run build_runner build
// hive data at the bottom of current file
part 'decod.g.dart';

@HiveType(typeId: 0)
class GameData extends HiveObject {
  @HiveField(0, defaultValue: 0)
  double success;

  @HiveField(1, defaultValue: 0)
  int count;

  GameData({this.success=0.0, this.count=0});

  double? get rate => count!=0?success/count:null;
  bool get hasPlayed => count != 0;
}