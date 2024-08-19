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

  const GeolocatedListItem({
    required super.uid,
    required String title,
    required this.latitude,
    required this.longitude,
    required this.subtitle,
    required this.image,
    required this.isMuseum
  }): super(name: title);

  @override
  String get title => name;

  factory GeolocatedListItem.fromJson(Map<String, dynamic> json) {
    return GeolocatedListItem(
      uid: json['uid'],
      title: json['title'],
      subtitle: json['subtitle'], 
      latitude: json['latitude'],
      longitude: json['longitude'],
      image: ImageWithPath.fromJson(json['image']),
      isMuseum: json['ismuseum']);
  }

  @override
  int get uid {
    return super.uid!;
  }

  LatLng get coordinates {
    return LatLng(latitude, longitude);
  }  
}
