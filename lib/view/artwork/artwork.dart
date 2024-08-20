import 'package:decodart/model/artwork.dart' show Artwork;
import 'package:decodart/widgets/buttons/button_list.dart' show ButtonListWidget;
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart' show CachedNetworkImage;
import 'package:flutter_markdown/flutter_markdown.dart';

class ArtworkView extends StatelessWidget {
  final Artwork artwork;
  const ArtworkView({
    super.key,
    required this.artwork
    });

  

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  artwork.title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                child: Text(
                  "${artwork.artist.name}, ${artwork.year}",
                  style: const TextStyle(
                    fontSize: 20
                  )
                )
              ),
              const SizedBox(height: 20),
              const ButtonListWidget(),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: CupertinoButton.filled(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        onPressed: () {
                          // Action pour le bouton
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'images/icons/plus_magnifyingglass.png',
                              width: 24,
                              height: 24,
                              color: CupertinoColors.white, // Optionnel : pour colorer l'icône
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "Décoder l'œuvre",
                              style: TextStyle(
                                color: CupertinoColors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                    )
                  ),
                ]
              ),
              const SizedBox(height: 20),
              CachedNetworkImage(
                imageUrl: artwork.images[0].path,
                width: double.infinity,
                fit: BoxFit.cover),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(15),
                child: MarkdownBody(
                    data: artwork.description,
                  )
                ),
              // Ajoutez d'autres widgets pour afficher les autres propriétés de l'artwork
            ],
          ),
        )
      )
    );
  }
}