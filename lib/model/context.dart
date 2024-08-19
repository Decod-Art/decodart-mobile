import 'package:decodart/model/abstract_item.dart' show AbstractItem;

typedef ContextForeignKey = ContextListItem;

class ContextListItem extends AbstractItem {
  const ContextListItem({
    super.uid,
    required super.name
  });

  factory ContextListItem.fromJson(Map<String, dynamic>json) {
    return ContextListItem(
      uid: json['uid'],
      name: json['name']
    ); 
  }
}

class Context extends ContextListItem {
  final String description;
  final String location;
  final String period;

  const Context({
    super.uid,
    required super.name,
    required this.description,
    required this.location,
    required this.period});

  factory Context.fromJson(Map<String, dynamic> json) {
    return Context(
      uid: json['uid'],
      name: json['name'],
      description: json['description'],
      location: json['location'],
      period: json['period']
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'location': location,
      'period': period,
      'description': description
    };
  }
}