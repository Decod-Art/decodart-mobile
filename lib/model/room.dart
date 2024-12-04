import 'package:decodart/model/abstract_item.dart' show AbstractItem;
import 'package:decodart/model/artwork.dart' show ArtworkListItem;
import 'package:decodart/model/image.dart' show AbstractImage, ImageOnline;
import 'package:decodart/model/museum.dart' show MuseumForeignKey;

class RoomForeignKey extends AbstractItem {

  const RoomForeignKey({
    super.uid,
    required super.name
  });

  factory RoomForeignKey.fromJson(Map<String, dynamic> json) => RoomForeignKey(
    uid: json['uid'],
    name: json['name']
  );
}

class RoomListItem extends RoomForeignKey {
  final String description;
  final List<ArtworkListItem> artworks;

  const RoomListItem({
    super.uid,
    required super.name,
    required this.description,
    required this.artworks
  });

  factory RoomListItem.fromJson(Map<String, dynamic> json) => RoomListItem(
    uid: json['uid'],
    name: json['name'],
    description: json['description'],
    artworks: json['artworkPreview']!=null
      ? json['artworkPreview'].map((item) => ArtworkListItem.fromJson(item))
                              .toList()
                              .cast<ArtworkListItem>()
      : const[]
    );

  @override
  Map<String, dynamic> toJson() => {...super.toJson(),'description': description};
}

class Room extends RoomListItem {
  final AbstractImage? image;
  final MuseumForeignKey museum;

  const Room({
    super.uid,
    required super.name,
    required super.description,
    this.image,
    required this.museum,
    required super.artworks});

  factory Room.fromJson(Map<String, dynamic> json) => Room(
    uid: json['uid'],
    name: json['name'],
    description: json['description'],
    museum: MuseumForeignKey.fromJson(json['museum']),
    image: json['image'] != null
      ? ImageOnline.fromJson(json['image'])
      : null,
    artworks: json['artworkPreview']!=null
      ? json['artworkPreview'].map((item) => ArtworkListItem.fromJson(item))
                              .toList()
                              .cast<ArtworkListItem>()
      : const[]
  );

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    if (image != null) 'image': image!.toJson(),
    'museum': museum.toJson()
  };

  bool get hasImage => image != null;

  @override
  String toString() => "Salle $name";
}