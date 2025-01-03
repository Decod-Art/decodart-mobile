import 'package:decodart/model/image.dart' show ImageOnline;


/// A base abstract class for items.
abstract class AbstractItemBase {const AbstractItemBase();}

/// An abstract class representing an unnamed item with an optional unique identifier.
abstract class UnnamedAbstractItem extends AbstractItemBase {
  /// The unique identifier of the item. It can be null if the item is new.
  final int? uid;

  /// Constructs an [UnnamedAbstractItem] with an optional [uid].
  const UnnamedAbstractItem({this.uid});

  /// Checks if the item is new (i.e., it does not have a unique identifier).
  bool get isNew => uid == null;

  /// Converts the item to a JSON-compatible map.
  ///
  /// If the item is not new, the map will include the [uid].
  Map<String, dynamic> toJson() => {if (!isNew) "uid": uid};
}

/// An abstract class representing a list item with a unique identifier, title, subtitle, and image.
abstract class AbstractListItem implements UnnamedAbstractItem {
  /// The title of the item.
  String get title;

  /// The subtitle of the item.
  String get subtitle;

  /// The image associated with the item.
  ImageOnline get image;
}

/// An abstract class representing a named item, extending [UnnamedAbstractItem].
abstract class AbstractItem extends UnnamedAbstractItem {
  /// The name of the item.
  final String name;

  /// Constructs an [AbstractItem] with an optional [uid] and a required [name].
  const AbstractItem({super.uid, required this.name});

  /// Converts the item to a JSON-compatible map.
  ///
  /// The map will include the [name] and, if the item is not new, the [uid].
  @override
  Map<String, dynamic> toJson() => {...super.toJson(), "name": name};
}