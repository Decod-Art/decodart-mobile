import 'package:decodart/model/abstract_item.dart' show AbstractItem;

typedef TechniqueForeignKey = TechniqueListItem;

class TechniqueListItem extends AbstractItem {
  const TechniqueListItem({
    super.uid,
    required super.name
  });
  factory TechniqueListItem.fromJson(Map<String, dynamic> json) {
    return TechniqueListItem(
      uid: json['uid'],
      name: json['name']
    );
  }
}