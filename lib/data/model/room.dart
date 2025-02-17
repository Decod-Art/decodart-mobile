import 'package:decodart/data/model/abstract_item.dart' show AbstractItem;
import 'package:decodart/data/model/artwork.dart' show ArtworkListItem;
import 'package:decodart/data/model/museum.dart' show MuseumForeignKey;

class RoomForeignKey extends AbstractItem {
  final MuseumForeignKey? museum;
  const RoomForeignKey({
    super.uid,
    required super.name,
    required this.museum
  });

  factory RoomForeignKey.fromJson(Map<String, dynamic> json) => RoomForeignKey(
    uid: json['uid'],
    name: json['name'],
    museum: json['museum'] != null
      ? MuseumForeignKey.fromJson(json['museum'])
      : null
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
  }) : super(museum: null);

  factory RoomListItem.fromJson(Map<String, dynamic> json) => RoomListItem(
    uid: json['uid'],
    name: json['name'],
    description: json['description'],
    artworks: json['artwork_preview']!=null
      ? json['artwork_preview'].map((item) => ArtworkListItem.fromJson(item))
                              .toList()
                              .cast<ArtworkListItem>()
      : const[]
    );

  @override
  Map<String, dynamic> toJson() => {...super.toJson(),'description': description};
}
