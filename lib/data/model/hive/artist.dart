
import 'package:hive/hive.dart';

// dart run build_runner build
// hive data at the bottom of current file
part 'artist.g.dart';

@HiveType(typeId: 3)
class ArtistForeignKey extends HiveObject {
  @HiveField(0, defaultValue: 0)
  int uid;
  @HiveField(1)
  String name;

  ArtistForeignKey({required this.uid, required this.name});
}