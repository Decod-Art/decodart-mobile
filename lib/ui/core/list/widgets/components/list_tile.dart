import 'package:decodart/data/model/abstract_item.dart';
import 'package:decodart/ui/core/miscellaneous/image/image.dart' show DecodImage;
import 'package:flutter/cupertino.dart';

class ListTile<T extends AbstractListItem> extends StatelessWidget {
  final void Function(T) onPress;
  final T item;
  const ListTile({
    super.key,
    required this.onPress,
    required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 15),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () => onPress(item),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: DecodImage(
                item.image,
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: CupertinoColors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    item.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
    );
  }
}