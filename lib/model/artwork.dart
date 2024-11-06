import 'package:decodart/model/abstract_item.dart' show AbstractItem, AbstractListItem;
import 'package:decodart/model/artist.dart' show Artist, ArtistForeignKey, ArtistListItem;
import 'package:decodart/model/artwork_tag.dart';
import 'package:decodart/model/geolocated.dart' show GeolocatedListItem;
import 'package:decodart/model/hive/artwork.dart' as hive;
import 'package:decodart/model/image.dart' show AbstractImage, ImageWithPath;
import 'package:decodart/model/museum.dart' show MuseumForeignKey;
import 'package:decodart/model/room.dart';
import 'package:decodart/widgets/component/formatted_content/_util.dart';


typedef ArtworkForeignKey = ArtworkListItem;

class ArtworkListItem extends AbstractItem implements AbstractListItem {
  final ArtistForeignKey artist;
  @override
  final AbstractImage image;

  const ArtworkListItem({
    super.uid,
    required title,
    required this.artist,
    required this.image
  }): super(name: title);

  factory ArtworkListItem.fromJson(Map<String, dynamic> json) {
    return ArtworkListItem(
      uid: json['uid'],
      title: json['title'],
      artist: ArtistForeignKey.fromJson(json['artist']),
      image: ImageWithPath.fromJson(json['image'])
    );
  }

  factory ArtworkListItem.fromGeolocatedListItem(GeolocatedListItem item) {
    return ArtworkListItem(
      uid: item.uid,
      title: item.title,
      artist: ArtistForeignKey(
        name: item.subtitle
      ),
      image: item.image);
  }

  factory ArtworkListItem.fromButton(ArtworkButtonContent button) {
    return ArtworkListItem(
      uid: button.uid,
      title: button.title,
      artist: ArtistForeignKey(
        name: button.subtitle
      ),
      image: button.image
    );
  }

  factory ArtworkListItem.fromHive(hive.ArtworkListItem artwork) {
    return ArtworkListItem(
      uid: artwork.uid,
      title: artwork.title,
      artist: ArtistForeignKey.fromHive(artwork.artist),
      image: ImageWithPath.fromHive(artwork.image));
  }

  hive.ArtworkListItem toHive(){
    return hive.ArtworkListItem(
      uid: uid!,
      title: title,
      artist: artist.toHive(),
      image: (image as ImageWithPath).toHive(saveBoundingBox: false));
  }

  @override
  String get title => name;
  @override
  String get subtitle => artist.name;

  @override
  Map<String, dynamic> toJson(){
    return {
      'uid': uid,
      'title': title,
      'artist': artist.toJson(),
      'image': image.toJson()
    };
  }
}

class Artwork extends AbstractItem {
  final String year;
  final double? width;
  final double? height;
  final double? depth;
  final RoomForeignKey? room;
  final String description;
  final double? latitude;
  final double? longitude;
  final String city;
  final String country;
  final int sortYear;
  final Artist artist;
  final MuseumForeignKey? museum;
  final List<AbstractImage> images;
  final bool hasDecodQuestion;
  final List<ArtworkTag> tags;

  const Artwork({
    super.uid,
    required this.year,
    this.width,
    this.height,
    this.depth,
    required title,
    this.room,
    required this.description,
    required this.artist,
    this.museum,
    this.latitude,
    this.longitude,
    required this.city,
    required this.country,
    required this.sortYear,
    required this.images,
    required this.hasDecodQuestion,
    required this.tags
  }): super(name: title);

  factory Artwork.fromJson(Map<String, dynamic> json) {
    return Artwork(
      uid: json['uid'],
      year: json['year'],
      width: json['width'],
      height: json['height'],
      depth: json['depth'],
      title: json['title'],
      museum: (json['museum']!=null)?MuseumForeignKey.fromJson(json['museum']):null,
      room: json['room']!=null?RoomForeignKey.fromJson(json['room']):null,
      artist: Artist.fromJson(json['artist']),
      latitude: json['latitude'],
      longitude: json['longitude'],
      city: json['city'],
      country: json['country'],
      sortYear: json['sortyear'],
      description: json['description'],
      images: json['images'].map((imageJson) => ImageWithPath.fromJson(imageJson)).toList()
                                                                                  .cast<ImageWithPath>(),
      hasDecodQuestion: json['hasdecodquestion'],
      tags: json['tags'].map((item) => ArtworkTag.fromJson(item))
                        .toList()
                        .cast<ArtworkTag>()
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'year': year,
      'width': width,
      'height': height,
      'depth': depth,
      'title': title,
      'museum': museum?.toJson(),
      'room': room?.toJson(),
      'artist': artist.toJson(),
      'latitude': latitude,
      'longitude': longitude,
      'city': city,
      'country': country,
      'sortyear': sortYear,
      'description': description,
      'images': images.map((item) => item.toJson()).toList()
    };
  }

  String get title => name;

  // to extract a preview of the artwork (recent, decoded, etc.)
  ArtworkListItem get listItem {
    return ArtworkListItem(
      uid: uid,
      title: title,
      artist: ArtistListItem(
        uid: artist.uid,
        name: artist.name
      ), image: images[0]);
  }
}