import 'package:latlong2/latlong.dart' show LatLng;
import 'package:decodart/model/abstract_item.dart' show AbstractItem, AbstractListItem;
import 'package:decodart/model/image.dart' show ImageOnline;

class GeolocatedListItem extends AbstractItem implements AbstractListItem {
  final double latitude;
  final double longitude;

  @override
  final String subtitle;

  @override
  final ImageOnline image;

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

  String get city => subtitle;

  String get descriptionShortened {
    final lines = description.split('\n');

    final filteredLines = lines
        .where((line) => !RegExp(r'\[.*?\]\(.*?\)').hasMatch(line))
        .where((line) => !line.startsWith('#'))
        .where((line) => line != "")
        .map((line) => line.replaceAll('*', ''))
        .toList();

    return filteredLines.join('\n');
  }

  factory GeolocatedListItem.fromJson(Map<String, dynamic> json) => GeolocatedListItem(
    uid: json['uid'],
    title: json['title'],
    subtitle: json['subtitle'], 
    latitude: json['latitude'],
    longitude: json['longitude'],
    image: ImageOnline.fromJson(json['image']),
    isMuseum: json['ismuseum'],
    description: json['description']
  );

  LatLng get coordinates => LatLng(latitude, longitude);

  @override
  String toString() => "[UID: $uid], [title: $title], [coordinates: $coordinates]";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final GeolocatedListItem otherItem = other as GeolocatedListItem;
    return uid == otherItem.uid && isMuseum == otherItem.isMuseum;
  }

  @override
  int get hashCode => Object.hash(uid, isMuseum);
}
