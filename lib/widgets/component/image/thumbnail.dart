import 'package:decodart/model/image.dart' show ImageOnline;
import 'package:decodart/widgets/component/image/image.dart';
import 'package:decodart/widgets/list/util/item_type.dart' show ItemType;
import 'package:flutter/cupertino.dart';

class ThumbnailWidget extends StatelessWidget {
  final String title;
  final ImageOnline image;
  final VoidCallback onPressed;
  final ItemType itemType;
  const ThumbnailWidget({
    super.key,
    required this.title,
    required this.image,
    required this.onPressed,
    required this.itemType
  });

  Widget get icon {
    switch(itemType) {
      case ItemType.museum:
        return Image.asset(
          'images/icons/museum.png',
          width: 20,
          height: 20,
          color: CupertinoColors.white, // Optionnel : pour colorer l'icône
        );
      case ItemType.artwork:
        return const Icon(
          CupertinoIcons.paintbrush_fill,
          color: CupertinoColors.white,
          size: 20,
        );
      case ItemType.tour:
        return Image.asset(
          'images/icons/mappin_and_ellipse.png',
          width: 20,
          height: 20,
          color: CupertinoColors.white, // Optionnel : pour colorer l'icône
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.all(10),
      onPressed: onPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Stack(
          children: [
            // Image de fond
            DecodImage(image, width: 180, height: 250, fit: BoxFit.cover),
            // Icône du pinceau en haut à droite
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(8.0),
                child: icon
              ),
            ),
            // Titre en bas à gauche
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              top: 170,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      CupertinoColors.black.withValues(alpha: 0.0),
                      CupertinoColors.black.withValues(alpha: 0.9),
                    ],
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ),
            ),
          ],
        ),
      )
    );
  }
}