import 'package:decodart/data/model/abstract_item.dart' show AbstractItem;
import 'package:decodart/data/model/hive/artist.dart' as hive;
import 'package:decodart/data/model/image.dart' show AbstractImage, ImageOnline;


class ArtistForeignKey extends AbstractItem {
  const ArtistForeignKey({super.uid, required super.name});

  factory ArtistForeignKey.fromJson(Map<String, dynamic> json) => ArtistForeignKey(
    uid: json['uid'],
    name: json['name']
  );

  factory ArtistForeignKey.fromHive(hive.ArtistForeignKey artist) => ArtistForeignKey(
    uid: artist.uid,
    name: artist.name
  );

  hive.ArtistForeignKey toHive() => hive.ArtistForeignKey(uid: uid!, name: name);
}

class Artist extends ArtistForeignKey {
  final String? birth;
  final String? death;
  final String biography;
  final String birthLocation;
  final String deathLocation;
  final String activityLocation;
  final String? ulangetty;
  final AbstractImage image;

  bool get hasBiography => biography.trim().isNotEmpty;

  const Artist({
    super.uid,
    required super.name,
    required this.biography,
    this.birth,
    this.death,
    required this.birthLocation,
    required this.deathLocation,
    required this.activityLocation,
    this.ulangetty,
    required this.image});

  factory Artist.fromJson(Map<String, dynamic> json) => Artist(
    uid: json['uid'],
    name: json['name'],
    biography: json['biography'],
    birth: json['birth'],
    death: json['death'],
    birthLocation: json['birthlocation'],
    deathLocation: json['deathlocation'],
    activityLocation: json['activitylocation'],
    ulangetty: json['ulangetty'],
    image: ImageOnline.fromJson(json['image'])
  );

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'biography': biography,
    'birth': birth,
    'death': death,
    'birthlocation': birthLocation,
    'deathlocation': deathLocation,
    'activitylocation': activityLocation,
    'ulangetty': ulangetty,
    'image': image.toJson()
  };
}