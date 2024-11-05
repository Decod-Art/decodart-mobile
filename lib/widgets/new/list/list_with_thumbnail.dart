import 'package:decodart/model/abstract_item.dart' show AbstractListItem;
import 'package:decodart/widgets/new/list/util/list_tile.dart' show ListTile;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Divider;

class ListWithThumbnail<T extends AbstractListItem> extends StatelessWidget {
  final List<T> items;
  final void Function(T) onPress;

  const ListWithThumbnail({
    super.key,
    required this.items,
    required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: items.map((item) {
        return Column(
          children: [
            if (item == items.first)
              const SizedBox(height: 8),
            ListTile(item: item, onPress: onPress),
            if (item != items.last)
              const Divider(
                indent: 80.0,
                color: CupertinoColors.separator,
              ),
            if (item == items.last)
              const SizedBox(height: 8),
          ],
        );
      }).toList(),
    );
  }
}