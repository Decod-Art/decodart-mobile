import 'package:decodart/model/abstract_item.dart' show AbstractItem, AbstractListItem;
import 'package:decodart/model/artist.dart' show ArtistForeignKey, Artist;
import 'package:decodart/model/image.dart' show AbstractImage, ImageWithPath;
import 'package:decodart/model/museum.dart' show MuseumForeignKey;
import 'package:decodart/model/style.dart' show StyleForeignKey;
import 'package:decodart/model/technique.dart' show TechniqueForeignKey;
import 'package:decodart/model/context.dart' show Context;


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
  final String? room;
  final String description;
  final double? latitude;
  final double? longitude;
  final String city;
  final String country;
  final int sortYear;
  final Artist artist;
  final Context context;
  final MuseumForeignKey? museum;
  final StyleForeignKey style;
  final TechniqueForeignKey technique;
  final List<AbstractImage> images;
  final bool hasDecodQuestion;

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
    required this.context,
    this.museum,
    required this.style,
    required this.technique,
    this.latitude,
    this.longitude,
    required this.city,
    required this.country,
    required this.sortYear,
    required this.images,
    required this.hasDecodQuestion
  }): super(name: title);

  factory Artwork.fromJson(Map<String, dynamic> json) {
    return Artwork(
      uid: json['uid'],
      year: json['year'],
      width: json['width'],
      height: json['height'],
      depth: json['depth'],
      title: json['title'],
      museum: MuseumForeignKey.fromJson(json['museum']),
      room: json['room'],
      artist: Artist.fromJson(json['artist']),
      context: Context.fromJson(json['context']),
      style: StyleForeignKey.fromJson(json['style']),
      technique: TechniqueForeignKey.fromJson(json['technique']),
      latitude: json['latitude'],
      longitude: json['longitude'],
      city: json['city'],
      country: json['country'],
      sortYear: json['sortyear'],
      description: json['description'],
      images: json['images'].map((imageJson) => ImageWithPath.fromJson(imageJson)).toList()
                                                                                  .cast<ImageWithPath>(),
      hasDecodQuestion: json['hasdecodquestion']
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
      'room': room,
      'artist': artist.toJson(),
      'context': context.toJson(),
      'style': style.toJson(),
      'technique': technique.toJson(),
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
}