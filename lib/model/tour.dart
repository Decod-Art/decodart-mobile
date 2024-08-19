import 'package:decodart/model/abstract_item.dart' show AbstractItem, AbstractListItem;
import 'package:decodart/model/image.dart' show AbstractImage, ImageWithPath;
import 'package:decodart/model/museum.dart' show MuseumForeignKey;


class TourListItem extends AbstractItem implements AbstractListItem {
  @override
  final String subtitle;
  @override
  final AbstractImage image;
  const TourListItem({
      super.uid,
      required super.name,
      required this.subtitle,
      required this.image
    });
    factory TourListItem.fromJson(Map<String, dynamic> json) {
      return TourListItem(
        uid: json['uid'],
        name: json['name'],
        subtitle: json['subtitle'],
        image: ImageWithPath.fromJson(json['image']));
    }
    @override
    String get title => name;

  @override
  Map<String, dynamic> toJson() {
      return {
        ...super.toJson(),
        'subtitle': subtitle,
        'image': image.toJson()
      };
    }
}

class Tour extends TourListItem {
  final String description;
  final bool isExhibition;
  final DateTime? startDate;
  final DateTime? endDate;
  final MuseumForeignKey? museum;

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
    });



  factory Tour.fromJson(Map<String, dynamic> json) {
    return Tour(
      uid: json['uid'],
      name: json['name'],
      description: json['description'],
      subtitle: json['subtitle'],
      isExhibition: json['isexhibition'],
      startDate: json['startdate'] != null ? DateTime.parse(json['startdate']) : null,
      endDate: json['enddate'] != null ? DateTime.parse(json['enddate']) : null,
      museum: json['museum']!=null?MuseumForeignKey.fromJson(json['museum']):null,
      image: ImageWithPath.fromJson(json['image'])
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'description': description,
      'isexhibition': isExhibition,
      'startdate': startDate?.toString(),
      'enddate': endDate?.toString(),
      'museum': museum?.toJson()
    };
  }
}