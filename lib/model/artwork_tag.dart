import 'package:decodart/model/abstract_item.dart';

class ArtworkTagCategory  extends UnnamedAbstractItem  {
  final String name;
  const ArtworkTagCategory({super.uid, required this.name});

  factory ArtworkTagCategory.fromJson(Map<String, dynamic> json) => ArtworkTagCategory(
    uid: json['uid'],
    name: json['name']
  );
}

class ArtworkTag extends UnnamedAbstractItem {
  final ArtworkTagCategory category;
  final String description;
  final String name;
  const ArtworkTag({
    super.uid,
    required this.name,
    required this.category,
    required this.description
  });

  factory ArtworkTag.fromJson(Map<String, dynamic> json) => ArtworkTag(
    uid: json['uid'],
    name: json['name'],
    description: json['description'],
    category: ArtworkTagCategory.fromJson(json['category'])
  );
}