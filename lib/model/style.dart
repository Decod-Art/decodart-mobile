import 'package:decodart/model/abstract_item.dart' show AbstractItem;

typedef StyleForeignKey = StyleListItem;

class StyleListItem extends AbstractItem {
  const StyleListItem({
    super.uid,
    required super.name
  });

  factory StyleListItem.fromJson(Map<String, dynamic> json) {
    return StyleListItem(
      uid: json['uid'],
      name: json['name']
    );
  }
}
