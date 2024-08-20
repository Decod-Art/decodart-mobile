import 'package:decodart/model/image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;

class ThumbnailWidget extends StatelessWidget {
  final String title;
  final AbstractImage image;
  const ThumbnailWidget({
    super.key,
    required this.title,
    required this.image
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Stack(
          children: [
            // Image de fond
            Image.network(
              image.path,
              width: 180,
              height: 250,
              fit: BoxFit.cover,
            ),
            // Icône du pinceau en haut à droite
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(8.0),
                child: const Icon(
                  CupertinoIcons.paintbrush_fill,
                  color: CupertinoColors.white,
                  size: 20,
                ),
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
                      CupertinoColors.black.withOpacity(0.0),
                      CupertinoColors.black.withOpacity(0.9),
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