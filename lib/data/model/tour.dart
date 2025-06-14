import 'package:decodart/data/model/abstract_item.dart' show AbstractItem, AbstractListItem;
import 'package:decodart/data/model/artwork.dart' show ArtworkForeignKey;
import 'package:decodart/data/model/image.dart' show ImageOnline;
import 'package:decodart/data/model/museum.dart' show MuseumForeignKey;


class TourListItem extends AbstractItem implements AbstractListItem {
  @override
  final String subtitle;

  @override
  final ImageOnline image;

  const TourListItem({
      super.uid,
      required super.name,
      required this.subtitle,
      required this.image
  });

  factory TourListItem.fromJson(Map<String, dynamic> json) => TourListItem(
    uid: json['uid'],
    name: json['name'],
    subtitle: json['subtitle'],
    image: ImageOnline.fromJson(json['image'])
  );

  @override
  String get title => name;

  @override
  Map<String, dynamic> toJson() => {...super.toJson(), 'subtitle': subtitle, 'image': image.toJson()};
}

class Tour extends TourListItem {
  final String description;
  final bool isExhibition;
  final DateTime? startDate;
  final DateTime? endDate;
  final MuseumForeignKey? museum;
  final List<ArtworkForeignKey> artworks;

  const Tour({
    super.uid,
    required super.name,
    required this.description,
    required this.isExhibition,
    required super.subtitle,
    required super.image,
    this.startDate,
    this.endDate,
    this.museum,
    required this.artworks
  });



  factory Tour.fromJson(Map<String, dynamic> json) => Tour(
    uid: json['uid'],
    name: json['name'],
    description: json['description'],
    subtitle: json['subtitle'],
    isExhibition: json['isexhibition'],
    startDate: json['startdate'] != null ? DateTime.parse(json['startdate']) : null,
    endDate: json['enddate'] != null ? DateTime.parse(json['enddate']) : null,
    museum: json['museum']!=null?MuseumForeignKey.fromJson(json['museum']):null,
    image: ImageOnline.fromJson(json['image']),
    artworks: (json['artworks'] as List).map((item) => ArtworkForeignKey.fromJson(item)).toList()
  );
  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'description': description,
    'isexhibition': isExhibition,
    'startdate': startDate?.toString(),
    'enddate': endDate?.toString(),
    'museum': museum?.toJson(),
    'artworks': artworks.map((item) => item.toJson()).toList()
  };
}