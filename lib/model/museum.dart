import 'package:decodart/model/abstract_item.dart' show AbstractItem, AbstractListItem;
import 'package:decodart/model/image.dart' show ImageWithPath, AbstractImage;


class MuseumForeignKey extends AbstractItem {
  const MuseumForeignKey({
    super.uid,
    required super.name
  });
  factory MuseumForeignKey.fromJson(Map<String,dynamic>json) {
    return MuseumForeignKey(
      uid: json['uid'],
      name: json['name']);
  }
}


class MuseumListItem extends MuseumForeignKey implements AbstractListItem{
  @override
  final AbstractImage image;
  final String city;
    const MuseumListItem({
      super.uid,
      required super.name,
      required this.image,
      required this.city
    });
    factory MuseumListItem.fromJson(Map<String, dynamic> json) {
      return MuseumListItem(
        uid: json['uid'],
        name: json['name'],
        image: ImageWithPath.fromJson(json['image']),
        city: json['city']
      );
    }

  @override
  Map<String, dynamic> toJson() {
      return {
        ...super.toJson(),
        'image': image.toJson(),
        'city': city
      };
    }
    @override
    String get subtitle => city;
  
    @override
    String get title => name;
}

class Museum extends MuseumListItem {
  final String description;
  final String country;
  final double latitude;
  final double longitude;
  final bool hasExhibitions;
  final bool hasCollection;
  final bool hasTours;

  const Museum({
    super.uid,
    required super.name,
    required this.description,
    required super.city,
    required this.country,
    required this.latitude,
    required this.longitude,
    required super.image,
    required this.hasExhibitions,
    required this.hasCollection,
    required this.hasTours
    });

  factory Museum.fromJson(Map<String, dynamic> json) {
    return Museum(
      uid: json['uid'],
      name: json['name'],
      description: json['description'],
      city: json['city'],
      country: json['country'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      image: ImageWithPath.fromJson(json['image']),
      hasExhibitions: json['hasexhibitions'],
      hasCollection: json['hascollection'],
      hasTours: json['hastours'],
    );
  }
  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'description': description,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  String get descriptionText {
    final lines = description.split('\n');

    final filteredLines = lines
        .where((line) => !RegExp(r'\[.*?\]\(.*?\)').hasMatch(line))
        .where((line) => !line.startsWith('#'))
        .where((line) => line != "")
        .map((line) => line.replaceAll('*', ''))
        .toList();

    return filteredLines.join('\n');
  }
}