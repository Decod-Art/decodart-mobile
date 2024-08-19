import 'package:decodart/model/abstract_item.dart' show AbstractItem;
import 'package:decodart/model/image.dart' show AbstractImage, ImageWithPath;

typedef ArtistForeignKey = ArtistListItem;

class ArtistListItem extends AbstractItem {
  const ArtistListItem({
    super.uid,
    required super.name
  });
  factory ArtistListItem.fromJson(Map<String, dynamic> json) {
    return ArtistListItem(
      uid: json['uid'],
      name: json['name']);
  }
}

class Artist extends ArtistListItem {
  final String? birth;
  final String? death;
  final String biography;
  final String birthLocation;
  final String deathLocation;
  final String activityLocation;
  final String? ulangetty;
  final AbstractImage image;

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

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      uid: json['uid'],
      name: json['name'],
      biography: json['biography'],
      birth: json['birth'],
      death: json['death'],
      birthLocation: json['birthlocation'],
      deathLocation: json['deathlocation'],
      activityLocation: json['activitylocation'],
      ulangetty: json['ulangetty'],
      image: ImageWithPath.fromJson(json['image'])
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
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
}