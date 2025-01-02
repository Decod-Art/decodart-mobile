import 'package:decodart/model/abstract_item.dart' show AbstractItem, AbstractListItem;
import 'package:decodart/model/artist.dart' show Artist, ArtistForeignKey;
import 'package:decodart/model/artwork_tag.dart' show ArtworkTag;
import 'package:decodart/model/geolocated.dart' show GeolocatedListItem;
import 'package:decodart/model/hive/artwork.dart' as hive;
import 'package:decodart/model/image.dart' show AbstractImage, ImageOnline;
import 'package:decodart/model/museum.dart' show MuseumForeignKey;
import 'package:decodart/model/room.dart' show RoomForeignKey;
import 'package:decodart/widgets/component/formatted_content/_util.dart' show ArtworkButtonContent;


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

  factory ArtworkListItem.fromJson(Map<String, dynamic> json) => ArtworkListItem(
    uid: json['uid'],
    title: json['title'],
    artist: ArtistForeignKey.fromJson(json['artist']),
    image: ImageOnline.fromJson(json['image'])
  );

  factory ArtworkListItem.fromGeolocatedListItem(GeolocatedListItem item) => ArtworkListItem(
    uid: item.uid,
    title: item.title,
    artist: ArtistForeignKey(name: item.subtitle),
    image: item.image);

  factory ArtworkListItem.fromButton(ArtworkButtonContent button) => ArtworkListItem(
    uid: button.uid,
    title: button.title,
    artist: ArtistForeignKey(name: button.subtitle),
    image: button.image
  );

  factory ArtworkListItem.fromHive(hive.ArtworkListItem artwork) => ArtworkListItem(
    uid: artwork.uid,
    title: artwork.title,
    artist: ArtistForeignKey.fromHive(artwork.artist),
    image: ImageOnline.fromHive(artwork.image)
  );

  hive.ArtworkListItem toHive() => hive.ArtworkListItem(
    uid: uid!,
    title: title,
    artist: artist.toHive(),
    image: (image as ImageOnline).toHive(saveBoundingBox: false)
  );

  @override
  String get title => name;

  @override
  String get subtitle => artist.name;

  @override
  Map<String, dynamic> toJson() => {
    'uid': uid,
    'title': title,
    'artist': artist.toJson(),
    'image': image.toJson()
  };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ArtworkListItem) return false;
    return uid == other.uid;
  }

  @override
  int get hashCode => uid.hashCode;
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
    this.latitude,
    this.longitude,
    required this.city,
    required this.country,
    required this.sortYear,
    required this.images,
    required this.hasDecodQuestion,
    required this.tags
  }): super(name: title);

  factory Artwork.fromJson(Map<String, dynamic> json) => Artwork(
    uid: json['uid'],
    year: json['year'],
    width: json['width'],
    height: json['height'],
    depth: json['depth'],
    title: json['title'],
    room: json['room']!=null?RoomForeignKey.fromJson(json['room']):null,
    artist: Artist.fromJson(json['artist']),
    latitude: json['latitude'],
    longitude: json['longitude'],
    city: json['city'],
    country: json['country'],
    sortYear: json['sortyear'],
    description: json['description'],
    images: json['images'].map((imageJson) => ImageOnline.fromJson(imageJson)).toList()
                                                                              .cast<ImageOnline>(),
    hasDecodQuestion: json['hasdecodquestion'],
    tags: json['tags'].map((item) => ArtworkTag.fromJson(item))
                      .toList()
                      .cast<ArtworkTag>()
  );

  /// toJson return a json format of an artwork
  /// It does **not** reuse the super.toJson()
  /// because super is actually a different object
  /// (name instead of title)
  @override
  Map<String, dynamic> toJson() => {
    'uid': uid,
    'year': year,
    'width': width,
    'height': height,
    'depth': depth,
    'title': title,
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

  String get title => name;

  bool get hasMuseum => room?.museum != null;
  MuseumForeignKey get museum => room!.museum!;

  // to extract a preview of the artwork (recent, decoded, etc.)
  ArtworkListItem get listItem => ArtworkListItem(
    uid: uid,
    title: title,
    artist: ArtistForeignKey(uid: artist.uid, name: artist.name),
    image: images[0]
  );

  void sortTags() {
    tags.sort((a, b) => a.category.name.compareTo(b.category.name));
  }

  List<ArtworkTag> get sortedTags {
    sortTags();
    return tags;
  }
}