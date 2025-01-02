import 'package:cached_network_image/cached_network_image.dart' show CachedNetworkImage;
import 'package:decodart/model/geolocated.dart' show GeolocatedListItem;
import 'package:decodart/view/map/summary.dart' show GeolocatedSummaryWidget;
import 'package:decodart/widgets/navigation/small_modal.dart' show showSmallModal;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show CircleAvatar;


/// A widget that represents a marker on a map with an image and a name.
/// 
/// When the marker is tapped, it shows a modal with a summary of the geolocated item
/// and triggers a callback function.
/// 
/// The widget displays a circular avatar with the item's image and a text with the item's name.
/// 
/// The image is fetched from a network using the CachedNetworkImage package.
/// 
/// The widget requires the following parameters:
/// - [onPress]: A callback function to be executed when the marker is tapped.
/// - [item]: A [GeolocatedListItem] object containing the data to be displayed.
/// - [modalKey]: A [GlobalKey] to obtain information about the modal window.
/// 
/// Example usage:
/// 
/// ```dart
/// DecodMarkerUI(
///   onPress: () {
///     // Handle marker tap
///   },
///   item: geolocatedItem,
///   modalKey: GlobalKey(),
/// )
/// ```
class DecodMarkerUI extends StatelessWidget {
  final VoidCallback onPress;
  final GeolocatedListItem item;
  // to obtain info about the modal window
  final GlobalKey modalKey;

  const DecodMarkerUI({super.key, required this.onPress, required this.item, required this.modalKey});

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: () {
        showSmallModal(context, (context) => GeolocatedSummaryWidget(item: item, key: modalKey));
        onPress();
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 30, // Ajustez la taille du cercle selon vos besoins
            backgroundColor: CupertinoColors.white, // Bordure blanche
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: item.image.path,
                fit: BoxFit.cover,
                width: 56,
                height: 56
              )
            ),
          ),
          const SizedBox(height: 4), // Espace entre l'image et le texte
          Text(
            item.name,
            style: const TextStyle(fontSize: 10, color: Color.fromARGB(255, 99, 98, 98)),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}