import 'package:cached_network_image/cached_network_image.dart' show CachedNetworkImage;
import 'package:decodart/data/model/geolocated.dart' show GeolocatedListItem;
import 'package:decodart/ui/core/navigation/navigate_to_items.dart' show navigateToGeoLocated;

import 'package:flutter/cupertino.dart';

/// A widget that displays a summary of a geolocated item.
/// 
/// This widget shows an image, a title, a shortened description, and a button that navigates
/// to a detailed view of the geolocated item when pressed. This widget
/// typically appears in the modal screen over the map view
/// 
/// The widget requires the following parameters:
/// - [item]: A [GeolocatedListItem] object containing the data to be displayed.
/// 
/// Example usage:
/// 
/// ```dart
/// GeolocatedSummaryWidget(
///   item: geolocatedItem,
/// )
/// ```
/// Or with a modal opening:
/// ```dart
/// showSmallModal(context, (context) => GeolocatedSummaryWidget(item: item, key: modalKey));
/// ```
class GeolocatedSummaryWidget extends StatelessWidget {
  final GeolocatedListItem item;
  const GeolocatedSummaryWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      child: Column(
        children: [
          Text(item.name, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15), // Coins arrondis
                  child: CachedNetworkImage(
                    imageUrl: item.image.path,
                    fit: BoxFit.cover,
                    height: 110,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    height: 110,
                    color: CupertinoColors.lightBackgroundGray,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: item.isMuseum?CupertinoColors.systemCyan:CupertinoColors.systemRed, // Fond rouge
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(10),
                          child: item.isMuseum
                            ? Image.asset(
                                'images/icons/museum.png',
                                width: 30,
                                height: 30,
                                color: CupertinoColors.white,
                              )
                            : const Icon(
                                CupertinoIcons.paintbrush_fill,
                                color: CupertinoColors.white,
                                size: 30,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.isMuseum
                            ? 'Musée'
                            : 'Œuvre d\'art',
                          style: const TextStyle(color: CupertinoColors.black, fontSize: 18),
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
            item.descriptionShortened,
            maxLines: 5, // Maximum de 5 lignes
            overflow: TextOverflow.ellipsis, // Points de suspension si le texte est trop long
            style: const TextStyle(fontSize: 15, color: CupertinoColors.black),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: CupertinoButton.filled(
              onPressed: () =>  navigateToGeoLocated(item, context, modal: true),
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