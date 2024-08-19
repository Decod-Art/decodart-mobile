import 'package:decodart/model/image.dart' show AbstractImage;

abstract class UnnamedAbstractItem {
  final int? uid;
  const UnnamedAbstractItem({this.uid});

  bool get isNew => uid == null;
  Map<String, dynamic> toJson() {
    return {
      if(!isNew)
        "uid": uid,
    };
  }
}

abstract class AbstractListItem {
  int? get uid;
  String get title;
  String get subtitle;
  AbstractImage get image;
}

abstract class AbstractItem extends UnnamedAbstractItem {
  final String name;
  const AbstractItem({super.uid, required this.name});
  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      "name": name
    };
  }
}