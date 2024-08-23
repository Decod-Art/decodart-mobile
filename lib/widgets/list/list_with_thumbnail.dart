import 'package:decodart/model/abstract_item.dart' show AbstractListItem;
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 15),
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => onPress(item),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        item.image.path,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              color: CupertinoColors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            item.subtitle,
                            style: const TextStyle(
                              color: CupertinoColors.systemGrey,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      CupertinoIcons.chevron_forward,
                      color: CupertinoColors.systemGrey,
                    ),
                  ],
                ),
              ),
            ),
            if (item != items.last)
              const Divider(
                indent: 16.0,
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