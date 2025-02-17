import 'package:decodart/data/model/abstract_item.dart' show AbstractListItem;

ItemType defaultItemTypeFct(AbstractListItem item) {
  return ItemType.artwork;
}

enum ItemType {
  museum,
  artwork,
  tour
}
