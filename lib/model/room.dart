import 'package:decodart/model/abstract_item.dart' show AbstractItem;
import 'package:decodart/model/image.dart' show AbstractImage, ImageWithPath;
import 'package:decodart/model/museum.dart' show MuseumForeignKey;

typedef RoomForeignKey = RoomListItem;

class RoomListItem extends AbstractItem {
  const RoomListItem({
    super.uid,
    required super.name
  });

  factory RoomListItem.fromJson(Map<String, dynamic> json) {
    return RoomListItem(
      uid: json['uid'],
      name: json['name']);
  }
}

class Room extends RoomListItem {
  final String description;
  @override
  final AbstractImage? image;
  final MuseumForeignKey museum;

  const Room({
    super.uid,
    required super.name,
    required this.description,
    this.image,
    required this.museum});

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      uid: json['uid'],
      name: json['name'],
      description: json['description'],
      museum: MuseumForeignKey.fromJson(json['museum']),
      image: json['image'] != null?ImageWithPath.fromJson(json['image']):null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'description': description,
      if (image != null)
        'image': image!.toJson(),
      'museum': museum.toJson()
    };
  }

  bool get hasImage => image != null;

  @override
  String toString() {
    return "Salle $name";
  }
}