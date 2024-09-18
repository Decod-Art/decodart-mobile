import 'package:latlong2/latlong.dart' show LatLng;
import 'package:decodart/model/abstract_item.dart' show AbstractItem, AbstractListItem;
import 'package:decodart/model/image.dart' show AbstractImage, ImageWithPath;

class GeolocatedListItem extends AbstractItem implements AbstractListItem {
  final double latitude;
  final double longitude;
  @override
  final String subtitle;
  @override
  final AbstractImage image;
  final bool isMuseum;
  final String description;

  const GeolocatedListItem({
    required super.uid,
    required String title,
    required this.latitude,
    required this.longitude,
    required this.subtitle,
    required this.image,
    required this.isMuseum,
    required this.description
  }): super(name: title);

  @override
  String get title => name;

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

  factory GeolocatedListItem.fromJson(Map<String, dynamic> json) {
    return GeolocatedListItem(
      uid: json['uid'],
      title: json['title'],
      subtitle: json['subtitle'], 
      latitude: json['latitude'],
      longitude: json['longitude'],
      image: ImageWithPath.fromJson(json['image']),
      isMuseum: json['ismuseum'],
      description: json['description']);
  }

  @override
  int get uid {
    return super.uid!;
  }

  LatLng get coordinates {
    return LatLng(latitude, longitude);
  }

  @override
  String toString() {
    return "[UID: $uid], [title: $title], [coordinates: $coordinates]";
  }
}
