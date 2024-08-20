import 'package:cached_network_image/cached_network_image.dart' show CachedNetworkImage;
import 'package:decodart/api/artwork.dart' show fetchArtworkById;
import 'package:decodart/api/museum.dart' show fetchMuseumById;
import 'package:decodart/model/abstract_item.dart' show AbstractItem;
import 'package:decodart/model/artwork.dart' show Artwork;
import 'package:decodart/model/geolocated.dart' show GeolocatedListItem;
import 'package:decodart/model/museum.dart' show Museum;
import 'package:decodart/view/artwork/future_artwork.dart' show FutureArtworkView;
import 'package:decodart/view/museum/future_museum.dart' show FutureMuseumView;
import 'package:decodart/widgets/modal/modal.dart' show ShowModal;

import 'package:flutter/cupertino.dart';

class GeolocatedSummaryWidget extends StatelessWidget with ShowModal {
  final GeolocatedListItem item;
  late final Future<AbstractItem> itemDetailed;
  GeolocatedSummaryWidget({
    super.key,
    required this.item
  }) {
    if (item.isMuseum) {
      itemDetailed = fetchMuseumById(item.uid);
    } else {
      itemDetailed = fetchArtworkById(item.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      child: Column(
        children: [
          Text(
            item.name,
            style: const TextStyle(
              fontSize: 18,
              //fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15), // Coins arrondis
                  child: CachedNetworkImage(
                    imageUrl: item.image.path,
                    fit: BoxFit.cover,
                    height: 110, // Hauteur maximale
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15), // Coins arrondis
                  child: Container(
                    height: 110,
                    color: CupertinoColors.lightBackgroundGray, // Fond gris
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: item.isMuseum?CupertinoColors.systemCyan:CupertinoColors.systemRed, // Fond rouge
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(10), // Espacement autour de l'icône
                          child: item.isMuseum
                            ?Image.asset(
                              'images/icons/museum.png',
                              width: 30,
                              height: 30,
                              color: CupertinoColors.white, // Optionnel : pour colorer l'icône
                            )
                            :const Icon(
                              CupertinoIcons.paintbrush_fill, // Icône de pinceau
                              color: CupertinoColors.white, // Couleur de l'icône
                              size: 30,
                            ),
                        ),
                        const SizedBox(height: 8), // Espacement entre l'icône et le texte
                        Text(
                          item.isMuseum?'Musée':'Œuvre d\'art',
                          style: const TextStyle(
                            color: CupertinoColors.black, // Couleur du texte
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            item.descriptionText,
            maxLines: 5, // Maximum de 5 lignes
            overflow: TextOverflow.ellipsis, // Points de suspension si le texte est trop long
            style: const TextStyle(
              fontSize: 15,
              color: CupertinoColors.black,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: CupertinoButton.filled(
              onPressed: () {
                if (item.isMuseum) {
                  showDecodModalBottomSheet(
                    context,
                    (context) => FutureMuseumView(museum: itemDetailed as Future<Museum>),
                    expand: true,
                    useRootNavigator: true);
                } else {
                  showDecodModalBottomSheet(
                    context,
                    (context) => FutureArtworkView(artwork: itemDetailed as Future<Artwork>),
                    expand: true,
                    useRootNavigator: true);
                }
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(CupertinoIcons.info_circle_fill, color: CupertinoColors.white),
                  SizedBox(width: 5),
                  Text('Plus d\'infos'),
                ],
              ),
            ),
          )
        ],
      )
    );
  }
}