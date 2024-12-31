import 'package:decodart/model/hive/artist.dart' show ArtistForeignKey;
import 'package:decodart/model/hive/image.dart' show Image;
import 'package:hive/hive.dart';

// dart run build_runner build
// hive data at the bottom of current file
part 'artwork.g.dart';

@HiveType(typeId: 4)
class ArtworkListItem extends HiveObject {
  @HiveField(0)
  int uid;
  @HiveField(1)
  ArtistForeignKey artist;
  @HiveField(2)
  Image image;
  @HiveField(3)
  String title;

  ArtworkListItem({
    required this.uid,
    required this.title,
    required this.artist,
    required this.image
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ArtworkListItem) return false;
    return uid == other.uid;
  }

  @override
  int get hashCode => uid.hashCode;
}